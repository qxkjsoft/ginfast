/*
Navicat MySQL Data Transfer

Source Server         : localhsot5.7
Source Server Version : 50726
Source Host           : localhost:3306
Source Database       : gin-fast

Target Server Type    : MYSQL
Target Server Version : 50726
File Encoding         : 65001

Date: 2025-08-21 18:04:49
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for casbin_rule
-- ----------------------------
DROP TABLE IF EXISTS `casbin_rule`;
CREATE TABLE `casbin_rule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ptype` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `v0` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `v1` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `v2` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `v3` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `v4` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `v5` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of casbin_rule
-- ----------------------------
INSERT INTO `casbin_rule` VALUES ('1', 'g', 'admin', 'admin_role', '', null, null, null);
INSERT INTO `casbin_rule` VALUES ('2', 'g', 'user', 'user_role', '', null, null, null);
INSERT INTO `casbin_rule` VALUES ('3', 'p', 'admin_role', '/api/*', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('4', 'p', 'admin_role', '/api/*', 'POST', null, null, null);
INSERT INTO `casbin_rule` VALUES ('5', 'p', 'admin_role', '/api/*', 'PUT', null, null, null);
INSERT INTO `casbin_rule` VALUES ('6', 'p', 'admin_role', '/api/*', 'DELETE', null, null, null);
INSERT INTO `casbin_rule` VALUES ('7', 'p', 'user_role', '/api/users/profile', 'GET', null, null, null);
INSERT INTO `casbin_rule` VALUES ('8', 'p', 'user_role', '/api/auth/login', 'POST', null, null, null);
INSERT INTO `casbin_rule` VALUES ('9', 'p', 'user_role', '/api/auth/logout', 'POST', null, null, null);

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `role` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('1', 'admin', '$2a$10$XwLsucEO67/96xfPs9c1OulukfE9bLsO2RLfJHG/kRPDnOOydFzaq', 'admin_role', '', '1', '2025-08-18 14:55:05', '2025-08-18 16:07:54', null);
