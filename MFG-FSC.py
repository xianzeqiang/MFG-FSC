import base64
import numpy as np
import requests
import pandas as pd
from rdkit import DataStructs
from rdkit.DataStructs import ExplicitBitVect
from concurrent.futures import ThreadPoolExecutor
import time
import mysql.connector


# 数据库连接
def connect_to_database():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="root",
        database="Molecular"
    )


def fetch_data(cursor, reference_smiles, target_cid):
    """根据给定的参考 SMILES 从数据库中提取数据，并剔除目标 CID。"""
    print(f"查询参考 SMILES: {reference_smiles}")
    query = """
        SELECT mi.CID, mi.Fingerprint2D 
        FROM molecular_info mi 
        JOIN similarity s ON mi.ScaffoldSmiles = s.Scaffold_SMILES2 
        WHERE s.Scaffold_SMILES1 = %s 
        AND s.is_Similarity = 'Similarity'
    """
    cursor.execute(query, (reference_smiles,))
    results = cursor.fetchall()

    # 返回除目标分子之外的 CID 和 Fingerprint2D 列表，同时找到目标分子的指纹
    data = [(cid[0], cid[1]) for cid in results if cid[0] != target_cid]
    target_fingerprint = next((cid[1] for cid in results if cid[0] == target_cid), None)
    return data, target_fingerprint


# 解码并转换为位向量
def convert_pubchem_fp_to_rdkit(pubchem_fp_base64):
    try:
        # 将 base64 指纹解码为字节并移除填充字节
        decoded_bytes = base64.b64decode(pubchem_fp_base64)[:-2]
        # 计算位向量总长度
        num_bits = len(decoded_bytes) * 8
        # 创建 RDKit 的 ExplicitBitVect 对象
        bitvect = ExplicitBitVect(num_bits)
        # 使用 numpy 将字节直接转换为位，并设置到 ExplicitBitVect 中
        np_bit_array = np.unpackbits(np.frombuffer(decoded_bytes, dtype=np.uint8))
        on_bits = np.where(np_bit_array == 1)[0]
        # 批量设置位
        bitvect.SetBitsFromList(on_bits.tolist())
        return bitvect

    except ValueError as e:
        print(f"base64 解码错误或无效输入: {e}")
        return None
    except Exception as e:
        print(f"转换失败: {e}")
        return None


# 计算 Tanimoto 相似度
def compute_tanimoto_similarity(fp1, fp2):
    return DataStructs.FingerprintSimilarity(fp1, fp2)


# 梯形隶属度函数
def trapezoidal_membership(x, a, b, c, d):
    if b == a:
        b = a + 1e-6
    if d == c:
        d = c + 1e-6
    return max(min((x - a) / (b - a), 1, (d - x) / (d - c)), 0)


# 相似度分类
def classify_similarity(similarity):
    thresholds = [
        (0.8, 0.9, 1.0, 1.0, 'Very High'),
        (0.6, 0.7, 0.8, 0.9, 'High'),
        (0.4, 0.5, 0.6, 0.7, 'Medium'),
        (0.2, 0.3, 0.4, 0.5, 'Low'),
        (0.0, 0.1, 0.2, 0.3, 'Very Low'),
    ]
    for a, b, c, d, label in thresholds:
        if trapezoidal_membership(similarity, a, b, c, d) > 0:
            return label
    return 'Unknown'


def process_batch(batch, target_fp):
    try:
        # 将指纹转换为 RDKit 位向量并存储在列表中
        rdkit_fps = [convert_pubchem_fp_to_rdkit(fp) for _, fp in batch]

        # 计算 Tanimoto 相似度的矩阵
        target_fp_array = np.array([target_fp] * len(rdkit_fps))  # 扩展目标指纹为数组
        similarities = np.array([DataStructs.FingerprintSimilarity(target_fp, rdkit_fp) for rdkit_fp in rdkit_fps])

        # 分类所有相似度
        classifications = np.array([classify_similarity(similarity) for similarity in similarities])

        # 输出结果矩阵
        results = np.column_stack((np.array([cid for cid, _ in batch]), similarities, classifications))
        print(results)

    except Exception as e:
        print(f"处理CID批次失败: {batch}, 错误: {str(e)}")
        return None


# 主函数
def main():
    db = connect_to_database()
    cursor = db.cursor()
    max_worker = 7
    reference_scaffold = "c1ccc2ccccc2c1"
    target_cid = 7005  # 目标 CID
    time_data_start = time.perf_counter()  # 记录开始时间
    # 获取数据并剔除目标分子
    cid_list, target_fp_str = fetch_data(cursor, reference_scaffold, target_cid)
    time_data_end = time.perf_counter()  # 记录结束时间

    # 转换目标分子的指纹为 RDKit 格式
    target_fp = convert_pubchem_fp_to_rdkit(target_fp_str)

    # 按批次处理
    batch_size = int(len(cid_list) / max_worker)
    # 使用线程池并行处理批次
    with ThreadPoolExecutor(max_workers=max_worker) as executor:
        # 提交任务处理批次
        for i in range(0, len(cid_list), batch_size):
            executor.submit(process_batch, cid_list[i:i + batch_size], target_fp)

    cursor.close()
    db.close()
    print(f"数据访问时间: {time_data_end - time_data_start:.2f} 秒")


if __name__ == "__main__":
    time_start = time.perf_counter()  # 记录开始时间
    main()
    time_end = time.perf_counter()  # 记录结束时间
    print(f"总执行时间: {time_end - time_start:.2f} 秒")
