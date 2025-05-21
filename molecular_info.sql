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

 Date: 21/05/2025 16:28:06
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for molecular_info
-- ----------------------------
DROP TABLE IF EXISTS `molecular_info`;
CREATE TABLE `molecular_info`  (
  `CID` int(0) NOT NULL,
  `Name` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `SMILES` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `MolecularFormula` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `MolecularWeight` double NULL DEFAULT NULL,
  `ScaffoldSmiles` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `Fingerprint2D` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `ConvertedFingerprint2D` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `XLogP` float NULL DEFAULT NULL,
  `TPSA` float NULL DEFAULT NULL,
  `Complexity` float NULL DEFAULT NULL,
  `Charge` float NULL DEFAULT NULL,
  `HBondDonorCount` int(0) NULL DEFAULT NULL,
  `HBondAcceptorCount` int(0) NULL DEFAULT NULL,
  `RotatableBondCount` int(0) NULL DEFAULT NULL,
  `HeavyAtomCount` int(0) NULL DEFAULT NULL,
  `IsotopeAtomCount` int(0) NULL DEFAULT NULL,
  `AtomStereoCount` int(0) NULL DEFAULT NULL,
  `DefinedAtomStereoCount` int(0) NULL DEFAULT NULL,
  `UndefinedAtomStereoCount` int(0) NULL DEFAULT NULL,
  `BondStereoCount` int(0) NULL DEFAULT NULL,
  `DefinedBondStereoCount` int(0) NULL DEFAULT NULL,
  `UndefinedBondStereoCount` int(0) NULL DEFAULT NULL,
  `CovalentUnitCount` int(0) NULL DEFAULT NULL,
  `Volume3D` float NULL DEFAULT NULL,
  `XStericQuadrupole3D` float NULL DEFAULT NULL,
  `YStericQuadrupole3D` float NULL DEFAULT NULL,
  `ZStericQuadrupole3D` float NULL DEFAULT NULL,
  `FeatureCount3D` int(0) NULL DEFAULT NULL,
  `FeatureAcceptorCount3D` int(0) NULL DEFAULT NULL,
  `FeatureDonorCount3D` int(0) NULL DEFAULT NULL,
  `FeatureAnionCount3D` int(0) NULL DEFAULT NULL,
  `FeatureCationCount3D` int(0) NULL DEFAULT NULL,
  `FeatureRingCount3D` int(0) NULL DEFAULT NULL,
  `FeatureHydrophobeCount3D` int(0) NULL DEFAULT NULL,
  `ConformerModelRMSD3D` float NULL DEFAULT NULL,
  `EffectiveRotorCount3D` int(0) NULL DEFAULT NULL,
  `ConformerCount3D` int(0) NULL DEFAULT NULL,
  PRIMARY KEY (`CID`) USING BTREE,
  INDEX `idx_molecular_info_ScaffoldSmiles`(`ScaffoldSmiles`(768)) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
