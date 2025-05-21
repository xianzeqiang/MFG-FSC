/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80027
 Source Host           : localhost:3306
 Source Schema         : molecular

 Target Server Type    : MySQL
 Target Server Version : 80027
 File Encoding         : 65001

 Date: 21/05/2025 16:28:13
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for similarity
-- ----------------------------
DROP TABLE IF EXISTS `similarity`;
CREATE TABLE `similarity`  (
  `Scaffold_SMILES1` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `Scaffold_SMILES2` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `is_Similarity` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  INDEX `idx_similarity_Scaffold_SMILES1`(`Scaffold_SMILES1`(768)) USING BTREE,
  INDEX `idx_similarity_Scaffold_SMILES2`(`Scaffold_SMILES2`(768)) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
