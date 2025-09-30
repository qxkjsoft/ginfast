/*
Navicat MySQL Data Transfer

Source Server         : localhsot5.7
Source Server Version : 50726
Source Host           : localhost:3306
Source Database       : gin-fast

Target Server Type    : MYSQL
Target Server Version : 50726
File Encoding         : 65001

Date: 2025-09-30 18:04:46
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
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_casbin_rule` (`ptype`,`v0`,`v1`,`v2`,`v3`,`v4`,`v5`)
) ENGINE=InnoDB AUTO_INCREMENT=1136 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of casbin_rule
-- ----------------------------
INSERT INTO `casbin_rule` VALUES ('16', 'g', 'role_16', 'role_1', null, null, null, null);
INSERT INTO `casbin_rule` VALUES ('17', 'g', 'role_17', 'role_1', null, null, null, null);
INSERT INTO `casbin_rule` VALUES ('18', 'g', 'role_18', 'role_1', null, null, null, null);
INSERT INTO `casbin_rule` VALUES ('19', 'g', 'role_19', 'role_2', null, null, null, null);
INSERT INTO `casbin_rule` VALUES ('20', 'g', 'role_20', 'role_2', null, null, null, null);
INSERT INTO `casbin_rule` VALUES ('1134', 'g', 'role_21', 'role_3', '', '', '', '');
INSERT INTO `casbin_rule` VALUES ('22', 'g', 'role_22', 'role_3', null, null, null, null);
INSERT INTO `casbin_rule` VALUES ('23', 'g', 'role_23', 'role_4', null, null, null, null);
INSERT INTO `casbin_rule` VALUES ('24', 'g', 'role_24', 'role_4', null, null, null, null);
INSERT INTO `casbin_rule` VALUES ('25', 'g', 'role_25', 'role_4', null, null, null, null);
INSERT INTO `casbin_rule` VALUES ('26', 'g', 'role_26', 'role_5', null, null, null, null);
INSERT INTO `casbin_rule` VALUES ('27', 'g', 'role_27', 'role_5', null, null, null, null);
INSERT INTO `casbin_rule` VALUES ('28', 'g', 'role_28', 'role_6', null, null, null, null);
INSERT INTO `casbin_rule` VALUES ('29', 'g', 'role_29', 'role_6', null, null, null, null);
INSERT INTO `casbin_rule` VALUES ('30', 'g', 'role_30', 'role_7', null, null, null, null);
INSERT INTO `casbin_rule` VALUES ('31', 'g', 'role_31', 'role_7', null, null, null, null);
INSERT INTO `casbin_rule` VALUES ('32', 'g', 'role_32', 'role_8', null, null, null, null);
INSERT INTO `casbin_rule` VALUES ('33', 'g', 'role_33', 'role_8', null, null, null, null);
INSERT INTO `casbin_rule` VALUES ('34', 'g', 'role_34', 'role_8', null, null, null, null);
INSERT INTO `casbin_rule` VALUES ('35', 'g', 'role_35', 'role_9', null, null, null, null);
INSERT INTO `casbin_rule` VALUES ('36', 'g', 'role_36', 'role_9', null, null, null, null);
INSERT INTO `casbin_rule` VALUES ('1135', 'g', 'role_37', 'role_10', '', '', '', '');
INSERT INTO `casbin_rule` VALUES ('38', 'g', 'role_38', 'role_10', null, null, null, null);
INSERT INTO `casbin_rule` VALUES ('39', 'g', 'role_39', 'role_10', null, null, null, null);
INSERT INTO `casbin_rule` VALUES ('40', 'g', 'role_40', 'role_11', null, null, null, null);
INSERT INTO `casbin_rule` VALUES ('41', 'g', 'role_41', 'role_11', null, null, null, null);
INSERT INTO `casbin_rule` VALUES ('42', 'g', 'role_42', 'role_12', null, null, null, null);
INSERT INTO `casbin_rule` VALUES ('43', 'g', 'role_43', 'role_12', null, null, null, null);
INSERT INTO `casbin_rule` VALUES ('44', 'g', 'role_44', 'role_13', null, null, null, null);
INSERT INTO `casbin_rule` VALUES ('45', 'g', 'role_45', 'role_13', null, null, null, null);
INSERT INTO `casbin_rule` VALUES ('46', 'g', 'role_46', 'role_14', null, null, null, null);
INSERT INTO `casbin_rule` VALUES ('47', 'g', 'role_47', 'role_14', null, null, null, null);
INSERT INTO `casbin_rule` VALUES ('48', 'g', 'role_48', 'role_15', null, null, null, null);
INSERT INTO `casbin_rule` VALUES ('49', 'g', 'role_49', 'role_15', null, null, null, null);
INSERT INTO `casbin_rule` VALUES ('50', 'g', 'role_50', 'role_15', null, null, null, null);
INSERT INTO `casbin_rule` VALUES ('51', 'g', 'role_52', 'role_51', null, null, null, null);
INSERT INTO `casbin_rule` VALUES ('54', 'g', 'role_53', 'role_51', '', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1132', 'g', 'user_1', 'role_1', '', '', '', '');
INSERT INTO `casbin_rule` VALUES ('949', 'g', 'user_19', 'role_16', '', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1128', 'g', 'user_3', 'role_1', '', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1130', 'g', 'user_4', 'role_1', '', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1131', 'g', 'user_5', 'role_1', '', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1133', 'g', 'user_9', 'role_51', '', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1114', 'p', 'role_1', '/api/sysAffix/delete', 'DELETE', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1103', 'p', 'role_1', '/api/sysAffix/download/*', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1126', 'p', 'role_1', '/api/sysAffix/list', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1102', 'p', 'role_1', '/api/sysAffix/updateName', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1094', 'p', 'role_1', '/api/sysAffix/upload', 'POST', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1086', 'p', 'role_1', '/api/sysApi/*', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1085', 'p', 'role_1', '/api/sysApi/add', 'POST', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1125', 'p', 'role_1', '/api/sysApi/delete', 'DELETE', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1121', 'p', 'role_1', '/api/sysApi/edit', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1098', 'p', 'role_1', '/api/sysApi/list', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1087', 'p', 'role_1', '/api/sysDepartment/add', 'POST', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1118', 'p', 'role_1', '/api/sysDepartment/delete', 'DELETE', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1088', 'p', 'role_1', '/api/sysDepartment/edit', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1096', 'p', 'role_1', '/api/sysDepartment/getDivision', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1092', 'p', 'role_1', '/api/sysDict/add', 'POST', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1112', 'p', 'role_1', '/api/sysDict/delete', 'DELETE', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1111', 'p', 'role_1', '/api/sysDict/edit', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1123', 'p', 'role_1', '/api/sysDict/getAllDicts', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1097', 'p', 'role_1', '/api/sysDict/list', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1107', 'p', 'role_1', '/api/sysDictItem/add', 'POST', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1122', 'p', 'role_1', '/api/sysDictItem/delete', 'DELETE', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1113', 'p', 'role_1', '/api/sysDictItem/edit', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1093', 'p', 'role_1', '/api/sysDictItem/getByDictId/*', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1082', 'p', 'role_1', '/api/sysMenu/add', 'POST', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1101', 'p', 'role_1', '/api/sysMenu/apis/*', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1083', 'p', 'role_1', '/api/sysMenu/delete', 'DELETE', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1100', 'p', 'role_1', '/api/sysMenu/edit', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1104', 'p', 'role_1', '/api/sysMenu/getMenuList', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1119', 'p', 'role_1', '/api/sysMenu/getRouters', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1084', 'p', 'role_1', '/api/sysMenu/setApis', 'POST', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1099', 'p', 'role_1', '/api/sysRole/add', 'POST', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1106', 'p', 'role_1', '/api/sysRole/addRoleMenu', 'POST', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1095', 'p', 'role_1', '/api/sysRole/dataScope', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1110', 'p', 'role_1', '/api/sysRole/delete', 'DELETE', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1081', 'p', 'role_1', '/api/sysRole/edit', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1116', 'p', 'role_1', '/api/sysRole/getRoles', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1091', 'p', 'role_1', '/api/sysRole/getUserPermission/*', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1115', 'p', 'role_1', '/api/users/*', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1117', 'p', 'role_1', '/api/users/add', 'POST', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1120', 'p', 'role_1', '/api/users/delete', 'DELETE', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1105', 'p', 'role_1', '/api/users/edit', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1109', 'p', 'role_1', '/api/users/list', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1108', 'p', 'role_1', '/api/users/logout', 'POST', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1089', 'p', 'role_1', '/api/users/profile', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1090', 'p', 'role_1', '/api/users/updateAccount', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1124', 'p', 'role_1', '/api/users/uploadAvatar', 'POST', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1033', 'p', 'role_16', '/api/sysDepartment/getDivision', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1031', 'p', 'role_16', '/api/sysDict/getAllDicts', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1026', 'p', 'role_16', '/api/sysMenu/getRouters', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1028', 'p', 'role_16', '/api/sysRole/getRoles', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1025', 'p', 'role_16', '/api/users/*', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1029', 'p', 'role_16', '/api/users/add', 'POST', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1030', 'p', 'role_16', '/api/users/edit', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1027', 'p', 'role_16', '/api/users/list', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1034', 'p', 'role_16', '/api/users/logout', 'POST', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1035', 'p', 'role_16', '/api/users/profile', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1032', 'p', 'role_16', '/api/users/uploadAvatar', 'POST', '', '', '');
INSERT INTO `casbin_rule` VALUES ('995', 'p', 'role_2', '/api/sysDepartment/getDivision', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('992', 'p', 'role_2', '/api/sysDict/getAllDicts', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('999', 'p', 'role_2', '/api/sysMenu/getRouters', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1000', 'p', 'role_2', '/api/sysRole/getRoles', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('998', 'p', 'role_2', '/api/users/*', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('990', 'p', 'role_2', '/api/users/add', 'POST', '', '', '');
INSERT INTO `casbin_rule` VALUES ('996', 'p', 'role_2', '/api/users/edit', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('994', 'p', 'role_2', '/api/users/list', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('991', 'p', 'role_2', '/api/users/logout', 'POST', '', '', '');
INSERT INTO `casbin_rule` VALUES ('997', 'p', 'role_2', '/api/users/profile', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('993', 'p', 'role_2', '/api/users/uploadAvatar', 'POST', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1006', 'p', 'role_3', '/api/sysDict/getAllDicts', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1004', 'p', 'role_3', '/api/sysMenu/getMenuList', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1002', 'p', 'role_3', '/api/sysMenu/getRouters', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1003', 'p', 'role_3', '/api/sysRole/add', 'POST', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1010', 'p', 'role_3', '/api/sysRole/addRoleMenu', 'POST', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1009', 'p', 'role_3', '/api/sysRole/edit', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1008', 'p', 'role_3', '/api/sysRole/getRoles', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1005', 'p', 'role_3', '/api/sysRole/getUserPermission/*', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1001', 'p', 'role_3', '/api/users/*', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1011', 'p', 'role_3', '/api/users/logout', 'POST', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1012', 'p', 'role_3', '/api/users/profile', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1007', 'p', 'role_3', '/api/users/uploadAvatar', 'POST', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1024', 'p', 'role_4', '/api/sysDict/getAllDicts', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1015', 'p', 'role_4', '/api/sysMenu/getMenuList', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1023', 'p', 'role_4', '/api/sysMenu/getRouters', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1013', 'p', 'role_4', '/api/sysRole/add', 'POST', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1016', 'p', 'role_4', '/api/sysRole/addRoleMenu', 'POST', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1014', 'p', 'role_4', '/api/sysRole/edit', 'PUT', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1019', 'p', 'role_4', '/api/sysRole/getRoles', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1020', 'p', 'role_4', '/api/sysRole/getUserPermission/*', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1017', 'p', 'role_4', '/api/users/*', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1021', 'p', 'role_4', '/api/users/logout', 'POST', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1022', 'p', 'role_4', '/api/users/profile', 'GET', '', '', '');
INSERT INTO `casbin_rule` VALUES ('1018', 'p', 'role_4', '/api/users/uploadAvatar', 'POST', '', '', '');

-- ----------------------------
-- Table structure for sys_affix
-- ----------------------------
DROP TABLE IF EXISTS `sys_affix`;
CREATE TABLE `sys_affix` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '文件名',
  `path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '路径',
  `size` int(10) DEFAULT NULL COMMENT '文件大小',
  `ftype` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '文件类型',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `suffix` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '文件后缀',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of sys_affix
-- ----------------------------
INSERT INTO `sys_affix` VALUES ('11', '222', '/public/uploads/2025-09-26/20250926_0b6c43f1-0f51-4da2-ae33-2cb01ed9f4d6.png', '6396', 'image', '2025-09-26 09:22:15', '2025-09-26 09:22:44', null, '1', '.png');
INSERT INTO `sys_affix` VALUES ('12', '11', '/public/uploads/2025-09-26/20250926_01ca7ad7-af8e-4eb8-aad3-518f1ebed140.png', '7563', 'image', '2025-09-26 09:22:19', '2025-09-26 09:22:40', null, '1', '.png');
INSERT INTO `sys_affix` VALUES ('13', '测试文档2.xls', '/public/uploads/2025-09-26/20250926_3ae83e73-2087-45e3-b88a-8aa3db42143e.xls', '19456', 'document', '2025-09-26 09:37:58', '2025-09-26 09:37:58', null, '1', '.xls');
INSERT INTO `sys_affix` VALUES ('14', 'gophercolor.png', '/public/uploads/2025-09-28/20250928_cd975f3e-8ec0-4550-a777-952e57ccc662.png', '45032', 'image', '2025-09-28 10:02:49', '2025-09-28 10:02:49', null, '3', '.png');
INSERT INTO `sys_affix` VALUES ('15', 'MYBK1650.png', '/public/uploads/2025-09-28/20250928_092b03ff-12ce-4031-afb6-d3f52b95f1c7.png', '358320', 'image', '2025-09-28 10:02:53', '2025-09-28 10:02:53', null, '3', '.png');
INSERT INTO `sys_affix` VALUES ('16', '5bfc43b3d5c48c48c0d6d011ccc62c4f.jpeg', '/public/uploads/2025-09-28/20250928_8ed07ca7-a52a-4905-8c26-d6f330c2bb11.jpeg', '66862', 'image', '2025-09-28 16:41:20', '2025-09-28 16:41:20', null, '4', '.jpeg');

-- ----------------------------
-- Table structure for sys_api
-- ----------------------------
DROP TABLE IF EXISTS `sys_api`;
CREATE TABLE `sys_api` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '权限名称',
  `path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '权限路径',
  `method` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '请求方法',
  `api_group` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '分组',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of sys_api
-- ----------------------------
INSERT INTO `sys_api` VALUES ('1', '用户登录', '/api/login', 'POST', '认证管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', null, null);
INSERT INTO `sys_api` VALUES ('2', '刷新Token', '/api/refreshToken', 'POST', '认证管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', null, null);
INSERT INTO `sys_api` VALUES ('3', '生成验证码ID', '/api/captcha/id', 'GET', '认证管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', null, null);
INSERT INTO `sys_api` VALUES ('4', '获取验证码图片', '/api/captcha/image', 'GET', '认证管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', null, null);
INSERT INTO `sys_api` VALUES ('5', '用户登出', '/api/users/logout', 'POST', '认证管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', null, null);
INSERT INTO `sys_api` VALUES ('6', '获取当前用户信息', '/api/users/profile', 'GET', '用户管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', null, null);
INSERT INTO `sys_api` VALUES ('7', '根据ID获取用户信息', '/api/users/:id', 'GET', '用户管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', null, null);
INSERT INTO `sys_api` VALUES ('8', '用户列表', '/api/users/list', 'GET', '用户管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', null, null);
INSERT INTO `sys_api` VALUES ('9', '新增用户', '/api/users/add', 'POST', '用户管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', null, null);
INSERT INTO `sys_api` VALUES ('10', '更新用户信息', '/api/users/edit', 'PUT', '用户管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', null, null);
INSERT INTO `sys_api` VALUES ('11', '删除用户', '/api/users/delete', 'DELETE', '用户管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', null, null);
INSERT INTO `sys_api` VALUES ('12', '获取用户权限菜单', '/api/sysMenu/getRouters', 'GET', '菜单管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, null);
INSERT INTO `sys_api` VALUES ('13', '获取完整菜单列表', '/api/sysMenu/getMenuList', 'GET', '菜单管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, null);
INSERT INTO `sys_api` VALUES ('14', '根据ID获取菜单信息', '/api/sysMenu/:id', 'GET', '菜单管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, null);
INSERT INTO `sys_api` VALUES ('15', '新增菜单', '/api/sysMenu/add', 'POST', '菜单管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, null);
INSERT INTO `sys_api` VALUES ('16', '更新菜单', '/api/sysMenu/edit', 'PUT', '菜单管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, null);
INSERT INTO `sys_api` VALUES ('17', '删除菜单', '/api/sysMenu/delete', 'DELETE', '菜单管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, null);
INSERT INTO `sys_api` VALUES ('18', '获取部门列表', '/api/sysDepartment/getDivision', 'GET', '部门管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, null);
INSERT INTO `sys_api` VALUES ('19', '获取所有角色数据', '/api/sysRole/getRoles', 'GET', '角色管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, null);
INSERT INTO `sys_api` VALUES ('20', '根据角色ID获取角色菜单权限', '/api/sysRole/getUserPermission/:roleId', 'GET', '角色管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, null);
INSERT INTO `sys_api` VALUES ('21', '添加角色的菜单权限', '/api/sysRole/addRoleMenu', 'POST', '角色管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, null);
INSERT INTO `sys_api` VALUES ('22', '角色分页列表', '/api/sysRole/list', 'GET', '角色管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, null);
INSERT INTO `sys_api` VALUES ('23', '根据ID获取角色信息', '/api/sysRole/:id', 'GET', '角色管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, null);
INSERT INTO `sys_api` VALUES ('24', '新增角色', '/api/sysRole/add', 'POST', '角色管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, null);
INSERT INTO `sys_api` VALUES ('25', '更新角色', '/api/sysRole/edit', 'PUT', '角色管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, null);
INSERT INTO `sys_api` VALUES ('26', '删除角色', '/api/sysRole/delete', 'DELETE', '角色管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, null);
INSERT INTO `sys_api` VALUES ('27', '获取所有字典数据', '/api/sysDict/getAllDicts', 'GET', '字典管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, null);
INSERT INTO `sys_api` VALUES ('28', '根据字典编码获取字典', '/api/sysDict/getByCode/:code', 'GET', '字典管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, null);
INSERT INTO `sys_api` VALUES ('29', 'API列表', '/api/sysApi/list', 'GET', 'API管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, null);
INSERT INTO `sys_api` VALUES ('30', '根据ID获取API信息', '/api/sysApi/:id', 'GET', 'API管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, null);
INSERT INTO `sys_api` VALUES ('31', '新增API', '/api/sysApi/add', 'POST', 'API管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, null);
INSERT INTO `sys_api` VALUES ('32', '更新API', '/api/sysApi/edit', 'PUT', 'API管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, null);
INSERT INTO `sys_api` VALUES ('33', '删除API', '/api/sysApi/delete', 'DELETE', 'API管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, null);
INSERT INTO `sys_api` VALUES ('34', '测试11', '/api/sysTest/test', 'POST', 'test', '2025-09-03 11:14:23', '2025-09-03 11:30:19', null, '1');
INSERT INTO `sys_api` VALUES ('35', '根据菜单ID获取API的ID集合', '/api/sysMenu/apis/:id', 'GET', '菜单管理', '2025-09-04 17:25:14', '2025-09-04 17:25:14', null, '1');
INSERT INTO `sys_api` VALUES ('36', '设置菜单API权限', '/api/sysMenu/setApis', 'POST', '菜单管理', '2025-09-04 17:26:04', '2025-09-04 17:26:04', null, '1');
INSERT INTO `sys_api` VALUES ('37', '根据ID获取部门信息', '/api/sysDepartment/:id', 'GET', '部门管理', '2025-09-12 14:46:42', '2025-09-12 14:46:42', null, '1');
INSERT INTO `sys_api` VALUES ('38', '新增部门', '/api/sysDepartment/add', 'POST', '部门管理', '2025-09-12 14:47:27', '2025-09-12 14:47:27', null, '1');
INSERT INTO `sys_api` VALUES ('39', '更新部门', '/api/sysDepartment/edit', 'PUT', '部门管理', '2025-09-12 14:48:15', '2025-09-12 14:48:27', null, '1');
INSERT INTO `sys_api` VALUES ('40', '删除部门', '/api/sysDepartment/delete', 'DELETE', '部门管理', '2025-09-12 14:49:15', '2025-09-12 14:49:15', null, '1');
INSERT INTO `sys_api` VALUES ('41', '字典分页列表', '/api/sysDict/list', 'GET', '字典管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', null, '1');
INSERT INTO `sys_api` VALUES ('42', '根据ID获取字典信息', '/api/sysDict/:id', 'GET', '字典管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', null, '1');
INSERT INTO `sys_api` VALUES ('43', '新增字典', '/api/sysDict/add', 'POST', '字典管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', null, '1');
INSERT INTO `sys_api` VALUES ('44', '更新字典', '/api/sysDict/edit', 'PUT', '字典管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', null, '1');
INSERT INTO `sys_api` VALUES ('45', '删除字典', '/api/sysDict/delete', 'DELETE', '字典管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', null, '1');
INSERT INTO `sys_api` VALUES ('46', '字典项列表', '/api/sysDictItem/list', 'GET', '字典项管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', null, '1');
INSERT INTO `sys_api` VALUES ('47', '根据ID获取字典项信息', '/api/sysDictItem/:id', 'GET', '字典项管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', null, '1');
INSERT INTO `sys_api` VALUES ('48', '根据字典ID获取字典项列表', '/api/sysDictItem/getByDictId/:dictId', 'GET', '字典项管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', null, '1');
INSERT INTO `sys_api` VALUES ('49', '根据字典编码获取字典项列表', '/api/sysDictItem/getByDictCode/:dictCode', 'GET', '字典项管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', null, '1');
INSERT INTO `sys_api` VALUES ('50', '新增字典项', '/api/sysDictItem/add', 'POST', '字典项管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', null, '1');
INSERT INTO `sys_api` VALUES ('51', '更新字典项', '/api/sysDictItem/edit', 'PUT', '字典项管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', null, '1');
INSERT INTO `sys_api` VALUES ('52', '删除字典项', '/api/sysDictItem/delete', 'DELETE', '字典项管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', null, '1');
INSERT INTO `sys_api` VALUES ('53', '修改用户密码、手机号及邮箱', '/api/users/updateAccount', 'PUT', '用户管理', '2025-09-18 18:11:01', '2025-09-18 18:11:01', null, '1');
INSERT INTO `sys_api` VALUES ('54', '头像上传', '/api/users/uploadAvatar', 'POST', '用户管理', '2025-09-24 17:01:05', '2025-09-24 17:01:05', null, '1');
INSERT INTO `sys_api` VALUES ('55', '上传文件', '/api/sysAffix/upload', 'POST', '文件管理', '2025-09-25 15:51:04', '2025-09-25 15:51:04', null, '1');
INSERT INTO `sys_api` VALUES ('56', '删除文件', '/api/sysAffix/delete', 'DELETE', '文件管理', '2025-09-25 15:51:38', '2025-09-25 15:51:38', null, '1');
INSERT INTO `sys_api` VALUES ('57', '修改文件名', '/api/sysAffix/updateName', 'PUT', '文件管理', '2025-09-25 15:52:31', '2025-09-25 15:52:31', null, '1');
INSERT INTO `sys_api` VALUES ('58', '文件列表', '/api/sysAffix/list', 'GET', '文件管理', '2025-09-25 15:54:03', '2025-09-25 15:54:03', null, '1');
INSERT INTO `sys_api` VALUES ('59', '获取文件详情', '/api/sysAffix/:id', 'GET', '文件管理', '2025-09-25 15:54:55', '2025-09-25 15:54:55', null, '1');
INSERT INTO `sys_api` VALUES ('60', '下载文件', '/api/sysAffix/download/:id', 'GET', '文件管理', '2025-09-25 15:56:15', '2025-09-25 15:58:06', null, '1');
INSERT INTO `sys_api` VALUES ('61', '设置数据权限', '/api/sysRole/dataScope', 'PUT', '角色管理', '2025-09-26 17:04:15', '2025-09-26 17:04:15', null, '1');

-- ----------------------------
-- Table structure for sys_department
-- ----------------------------
DROP TABLE IF EXISTS `sys_department`;
CREATE TABLE `sys_department` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) unsigned DEFAULT '0' COMMENT '父级',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '部门名称',
  `status` tinyint(1) DEFAULT NULL COMMENT '状态： 0 停用 1 启用',
  `leader` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '负责人',
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '联系电话',
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '邮箱',
  `sort` int(11) DEFAULT NULL COMMENT '排序',
  `describe` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '描述',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of sys_department
-- ----------------------------
INSERT INTO `sys_department` VALUES ('1', '0', '总部', '1', '张明', '13800000001', 'headquarters@company.com', '1', '公司总部管理部门', '2023-01-15 09:00:00', '2023-01-15 09:00:00', null, '1');
INSERT INTO `sys_department` VALUES ('2', '1', '技术研发中心', '1', '李强', '13800000002', 'tech@company.com', '10', '技术研发部门', '2023-01-15 09:00:00', '2023-01-15 09:00:00', null, '1');
INSERT INTO `sys_department` VALUES ('3', '1', '市场营销部', '1', '王芳', '13800000003', 'marketing@company.com', '20', '市场推广和营销', '2023-01-15 09:00:00', '2023-01-15 09:00:00', null, '1');
INSERT INTO `sys_department` VALUES ('4', '2', '前端开发部', '1', '赵刚', '13800000004', 'frontend@company.com', '11', '前端开发团队', '2023-02-10 10:30:00', '2023-02-10 10:30:00', null, '2');
INSERT INTO `sys_department` VALUES ('5', '2', '后端开发部', '1', '钱勇', '13800000005', 'backend@company.com', '12', '后端开发团队', '2023-02-10 10:30:00', '2023-02-10 10:30:00', null, '2');
INSERT INTO `sys_department` VALUES ('6', '2', '测试质量部', '1', '孙丽', '13800000006', 'qa@company.com', '13', '软件测试和质量保障', '2023-02-10 10:30:00', '2023-02-10 10:30:00', null, '2');
INSERT INTO `sys_department` VALUES ('7', '3', '数字营销组', '1', '周婷', '13800000007', 'digital@company.com', '21', '数字媒体营销', '2023-02-15 14:20:00', '2023-02-15 14:20:00', null, '3');
INSERT INTO `sys_department` VALUES ('8', '3', '品牌推广组', '1', '吴伟', '13800000008', 'brand@company.com', '22', '品牌建设和推广', '2023-02-15 14:20:00', '2023-02-15 14:20:00', null, '3');
INSERT INTO `sys_department` VALUES ('9', '5', 'Java开发组', '1', '郑华', '13800000009', 'java@company.com', '121', 'Java后端开发', '2023-03-01 11:15:00', '2023-03-01 11:15:00', null, '5');
INSERT INTO `sys_department` VALUES ('10', '5', 'Python开发组', '1', '冯超', '13800000010', 'python@company.com', '122', 'Python后端开发', '2023-03-01 11:15:00', '2023-03-01 11:15:00', null, '5');
INSERT INTO `sys_department` VALUES ('11', '0', '分部', '1', '小明', '13800000011', 'python@company.com', '1', '分部', '2025-08-28 16:28:37', null, null, '1');
INSERT INTO `sys_department` VALUES ('12', '11', '营销部', '1', '李雷', '13800000012', 'python@company.com', '2', '市场推广和营销', '2025-08-28 16:28:41', null, null, '1');
INSERT INTO `sys_department` VALUES ('13', '4', 'Web前端组', '1', '陈静', '13800000013', 'web@company.com', '111', 'Web前端开发', '2023-03-15 08:45:00', '2023-03-15 08:45:00', null, '4');
INSERT INTO `sys_department` VALUES ('14', '4', '移动端组', '1', '林涛', '13800000014', 'mobile@company.com', '112', '移动端开发', '2023-03-15 08:45:00', '2023-03-15 08:45:00', null, '4');
INSERT INTO `sys_department` VALUES ('15', '6', '功能测试组', '1', '黄敏', '13800000015', 'functional@company.com', '131', '功能测试', '2023-03-20 13:20:00', '2023-03-20 13:20:00', null, '6');
INSERT INTO `sys_department` VALUES ('16', '6', '自动化测试组', '1', '刘洋', '13800000016', 'auto@company.com', '132', '自动化测试', '2023-03-20 13:20:00', '2023-03-20 13:20:00', null, '6');
INSERT INTO `sys_department` VALUES ('17', '1', '人力资源部', '0', '杨雪', '13800000017', 'hr@company.com', '30', '人力资源管理', '2023-04-01 09:30:00', '2023-06-01 14:00:00', null, '1');
INSERT INTO `sys_department` VALUES ('18', '1', '财务部', '1', '朱军', '13800000018', 'finance@company.com', '40', '财务管理', '2023-04-01 09:30:00', '2023-04-01 09:30:00', null, '1');
INSERT INTO `sys_department` VALUES ('19', '11', '技术部', '1', '韩梅', '13800000019', 'tech_branch@company.com', '3', '分部技术团队', '2023-05-10 16:15:00', '2023-05-10 16:15:00', null, '11');
INSERT INTO `sys_department` VALUES ('20', '19', '运维组', '1', '高飞', '13800000020', 'ops@company.com', '31', '系统运维', '2023-05-10 16:15:00', '2023-05-10 16:15:00', null, '19');
INSERT INTO `sys_department` VALUES ('21', '9', '微服务组', '1', '秦朗', '13800000021', 'micro@company.com', '1211', '微服务开发', '2023-06-01 10:00:00', '2023-06-01 10:00:00', null, '9');
INSERT INTO `sys_department` VALUES ('22', '10', 'AI开发组', '1', '宋佳', '13800000022', 'ai@company.com', '1221', '人工智能开发', '2023-06-01 10:00:00', '2023-06-01 10:00:00', null, '10');
INSERT INTO `sys_department` VALUES ('23', '3', '市场调研组', '0', '董磊', '13800000023', 'research@company.com', '23', '市场调研分析', '2023-06-15 11:45:00', '2023-08-01 15:30:00', null, '3');
INSERT INTO `sys_department` VALUES ('24', '18', '成本控制组', '1', '谢芳', '13800000024', 'cost@company.com', '41', '成本控制管理', '2023-07-01 14:20:00', '2023-07-01 14:20:00', null, '18');
INSERT INTO `sys_department` VALUES ('25', '18', '预算规划组', '1', '唐勇', '13800000025', 'budget@company.com', '42', '预算规划管理', '2023-07-01 14:20:00', '2023-07-01 14:20:00', null, '18');

-- ----------------------------
-- Table structure for sys_dict
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict`;
CREATE TABLE `sys_dict` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '字典名称',
  `code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '字典编码',
  `status` tinyint(1) DEFAULT NULL COMMENT '状态',
  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of sys_dict
-- ----------------------------
INSERT INTO `sys_dict` VALUES ('1', '性别', 'gender', '1', '这是一个性别字典', '2024-07-01 10:00:00', null, null, null);
INSERT INTO `sys_dict` VALUES ('2', '状态', 'status', '1', '状态字段可以用这个', '2024-07-01 10:00:00', null, null, null);
INSERT INTO `sys_dict` VALUES ('3', '岗位', 'post', '1', '岗位字段', '2024-07-01 10:00:00', null, null, null);
INSERT INTO `sys_dict` VALUES ('4', '任务状态', 'taskStatus', '1', '任务状态字段可以用它', '2024-07-01 10:00:00', null, null, null);
INSERT INTO `sys_dict` VALUES ('5', '测试字典', 'testStart', '1', '测试字典', '2025-09-16 17:47:37', '2025-09-16 17:47:37', null, '1');

-- ----------------------------
-- Table structure for sys_dict_item
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_item`;
CREATE TABLE `sys_dict_item` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `value` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL COMMENT '状态',
  `dict_id` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of sys_dict_item
-- ----------------------------
INSERT INTO `sys_dict_item` VALUES ('11', '男', '1', '1', '1');
INSERT INTO `sys_dict_item` VALUES ('12', '女', '0', '1', '1');
INSERT INTO `sys_dict_item` VALUES ('13', '其它', '2', '1', '1');
INSERT INTO `sys_dict_item` VALUES ('21', '禁用', '0', '1', '2');
INSERT INTO `sys_dict_item` VALUES ('22', '启用', '1', '1', '2');
INSERT INTO `sys_dict_item` VALUES ('31', '总经理', '1', '1', '3');
INSERT INTO `sys_dict_item` VALUES ('32', '总监', '2', '1', '3');
INSERT INTO `sys_dict_item` VALUES ('33', '人事主管', '3', '1', '3');
INSERT INTO `sys_dict_item` VALUES ('34', '开发部主管', '4', '1', '3');
INSERT INTO `sys_dict_item` VALUES ('35', '普通职员', '5', '1', '3');
INSERT INTO `sys_dict_item` VALUES ('36', '其它', '999', '1', '3');
INSERT INTO `sys_dict_item` VALUES ('41', '失败', '0', '1', '4');
INSERT INTO `sys_dict_item` VALUES ('42', '成功', '1', '1', '4');
INSERT INTO `sys_dict_item` VALUES ('43', '测试状态1', '1', '1', '5');
INSERT INTO `sys_dict_item` VALUES ('45', '测试状态2', '2', '1', '5');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '路由ID',
  `parent_id` varchar(32) NOT NULL DEFAULT '0' COMMENT '父级路由ID，顶层为0',
  `path` varchar(255) NOT NULL COMMENT '路由路径',
  `name` varchar(100) NOT NULL COMMENT '路由名称',
  `redirect` varchar(255) DEFAULT NULL COMMENT '重定向',
  `component` varchar(255) DEFAULT NULL COMMENT '组件文件路径',
  `title` varchar(100) DEFAULT NULL COMMENT '菜单标题，国际化key',
  `is_full` tinyint(1) DEFAULT '0' COMMENT '是否全屏显示：0-否，1-是',
  `hide` tinyint(1) DEFAULT '0' COMMENT '是否隐藏：0-否，1-是',
  `disable` tinyint(1) DEFAULT '0' COMMENT '是否停用：0-否，1-是',
  `keep_alive` tinyint(1) DEFAULT '0' COMMENT '是否缓存：0-否，1-是',
  `affix` tinyint(1) DEFAULT '0' COMMENT '是否固定：0-否，1-是',
  `link` varchar(500) DEFAULT '' COMMENT '外链地址',
  `iframe` tinyint(1) DEFAULT '0' COMMENT '是否内嵌：0-否，1-是',
  `svg_icon` varchar(100) DEFAULT '' COMMENT 'svg图标名称',
  `icon` varchar(100) DEFAULT '' COMMENT '普通图标名称',
  `sort` int(11) DEFAULT '1' COMMENT '排序字段',
  `type` tinyint(1) DEFAULT '2' COMMENT '类型：1-目录，2-菜单，3-按钮',
  `is_link` tinyint(1) DEFAULT '0' COMMENT '是否外链',
  `permission` varchar(255) DEFAULT '' COMMENT '权限标识',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_sort` (`sort`),
  KEY `idx_type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=140245 DEFAULT CHARSET=utf8mb4 COMMENT='系统菜单路由表';

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES ('1', '0', '/home', 'home', null, 'home/home', 'home', '0', '0', '0', '0', '1', '', '0', 'home', '', '1', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('2', '0', '/file', 'file', null, null, 'file', '0', '0', '0', '1', '0', '', '0', 'folder-menu', '', '2', '1', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('3', '0', '/table', 'table', null, null, 'table', '0', '0', '0', '1', '0', '', '0', 'table', '', '3', '1', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('4', '0', '/form', 'form', null, null, 'form', '0', '0', '0', '1', '0', '', '0', 'form', '', '4', '1', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('5', '0', '/multilevel', 'multilevel', null, null, 'multilevel', '0', '0', '0', '1', '0', '', '0', 'switch', '', '5', '1', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('6', '0', '/component', 'component', null, null, 'component', '0', '0', '0', '1', '0', '', '0', 'classify', '', '6', '1', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('7', '0', '/directive', 'directive', null, null, 'directive', '0', '0', '0', '1', '0', '', '0', 'directives', '', '7', '1', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('9', '0', '/functions', 'functions', null, null, 'functions', '0', '0', '0', '1', '0', '', '0', 'functions', '', '9', '1', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('10', '0', '/system', 'system', null, null, 'system', '0', '0', '0', '1', '0', '', '0', 'set', '', '10', '1', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('12', '0', '/hide-menu', 'hide-menu', null, 'hide-menu/hide-menu', 'hide-menu', '0', '1', '0', '1', '0', '', '0', 'switch', '', '12', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('13', '0', '/permission', 'permission', null, null, 'permission', '0', '0', '0', '1', '0', '', '0', 'defend', '', '13', '1', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('14', '0', '/link', 'link', null, null, 'link', '0', '0', '0', '1', '0', '', '0', 'link', '', '14', '1', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('15', '0', '/monitor', 'monitor', null, null, 'system-monitor', '0', '0', '0', '1', '0', '', '0', 'financial-statement', '', '15', '1', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('16', '0', '/SnowAdmin-Thin', 'thin-preview', null, 'link/external/external', 'thin-preview', '0', '0', '0', '0', '1', 'http://115.190.79.132:83/#/login', '0', 'propaganda', '', '16', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('17', '0', '/i18n', 'i18n', null, 'i18n/show/index', 'i18n', '0', '0', '0', '1', '0', '', '0', 'earth', '', '17', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('18', '0', '/about', 'about', null, 'about/about', 'about', '0', '0', '0', '1', '0', '', '0', 'about', '', '18', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('201', '02', '/file/document-library', 'document-library', null, 'file/document-library/document-library', 'document-library', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '1', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('301', '03', '/table/common-table', 'common-table', null, 'table/common-table/common-table', 'common-table', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '1', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('302', '03', '/table/custom-table', 'custom-table', null, 'table/custom-table/custom-table', 'custom-table', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '2', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('401', '04', '/form/common-form', 'common-form', null, 'form/common-form/common-form', 'common-form', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '1', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('402', '04', '/form/step-form', 'step-form', null, 'form/step-form/step-form', 'step-form', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '2', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('501', '05', '/multilevel/second-1', 'second-1', null, 'multilevel/second/second-1', 'second-1', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '1', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('502', '05', '/multilevel/second-2', 'second-2', null, null, 'second-2', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '2', '1', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('601', '06', '/component/player', 'player', null, 'component/player/player', 'player', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '1', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('602', '06', '/component/print', 'print', null, 'component/print/print', 'print', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '2', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('603', '06', '/component/draggable', 'draggable', null, 'component/draggable/draggable', 'draggable', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '3', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('604', '06', '/component/editor', 'editor', null, 'component/editor/editor', 'editor', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '4', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('605', '06', '/component/newbie', 'newbie', null, 'component/newbie/newbie', 'newbie', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '5', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('606', '06', '/component/icon-selector', 'icon-selector', null, 'component/icon-selector/icon-selector', 'icon-selector', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '6', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('607', '06', '/component/user-center', 'user-center', null, 'component/user-center/user-center', 'user-center', '0', '1', '0', '1', '0', '', '0', '', 'icon-menu', '7', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('608', '06', '/component/fingerprintjs2', 'fingerprintjs2', null, 'component/fingerprintjs2/fingerprintjs2', 'fingerprintjs2', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '8', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('609', '06', '/component/barcode', 'barcode', null, 'component/barcode/barcode', 'barcode', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '9', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('610', '06', '/component/qrcode', 'qrcode', null, 'component/qrcode/qrcode', 'qrcode', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '10', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('611', '06', '/component/pinyin', 'pinyin', null, 'component/pinyin/pinyin', 'pinyin', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '11', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('612', '06', '/component/recorder', 'recorder', null, 'component/recorder/recorder', 'recorder', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '12', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('613', '06', '/component/virtual-list', 'virtual-list', null, 'component/virtual-list/index', 'virtual-list', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '13', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('614', '06', '/component/common-layouts', 'common-layouts', null, 'component/common-layouts/index', 'common-layouts', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '14', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('701', '07', '/directive/anti-shake', 'anti-shake', null, 'directive/anti-shake/anti-shake', 'anti-shake', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '1', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('702', '07', '/directive/throttle', 'throttle', null, 'directive/throttle/throttle', 'throttle', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '2', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('703', '07', '/directive/test-directive', 'test-directive', null, 'directive/test-directive/test-directive', 'test-directive', '0', '1', '0', '1', '0', '', '0', '', 'icon-menu', '3', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('901', '09', '/functions/routing-operation', 'routing-operation', null, 'functions/routing-operation/index', 'routing-operation', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '1', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('902', '09', '/functions/common-tools', 'common-tools', null, 'functions/common-tools/common-tools', 'common-tools', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '2', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('903', '09', '/functions/tree-tools', 'tree-tools', null, 'functions/tree-tools/tree-tools', 'tree-tools', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '3', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('904', '09', '/functions/file-tools', 'file-tools', null, 'functions/file-tools/file-tools', 'file-tools', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '4', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('905', '09', '/functions/verify-tools', 'verify-tools', null, 'functions/verify-tools/verify-tools', 'verify-tools', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '5', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('1001', '10', '/system/account', 'account', '', 'system/account/account', 'account', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '1', '2', '0', '', '2025-08-27 09:09:44', '2025-09-04 09:04:33', null, '0');
INSERT INTO `sys_menu` VALUES ('1002', '10', '/system/role', 'role', null, 'system/role/role', 'role', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '2', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('1003', '10', '/system/menu', 'menu', null, 'system/menu/menu', 'menu', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '3', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('1004', '10', '/system/division', 'division', null, 'system/division/division', 'division', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '4', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('1005', '10', '/system/dictionary', 'dictionary', null, 'system/dictionary/dictionary', 'dictionary', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '5', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('1006', '10', '/system/log', 'log', null, 'system/log/log', 'log', '0', '1', '0', '1', '0', '', '0', '', 'icon-menu', '6', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('1007', '10', '/system/userinfo', 'userinfo', '', 'system/userinfo/userinfo', 'userinfo', '0', '1', '0', '1', '0', '', '0', '', 'icon-menu', '7', '2', '0', '', '2025-08-27 09:09:44', '2025-09-17 11:19:11', null, '0');
INSERT INTO `sys_menu` VALUES ('1301', '13', '/permission/btn-perm', 'btn-perm', null, 'permission/btn-perm/btn-perm', 'btn-perm', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '1', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('1302', '13', '/permission/admin-page', 'admin-page', null, 'permission/admin-page/admin-page', 'admin-page', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '2', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('1303', '13', '/permission/common-page', 'common-page', null, 'permission/common-page/common-page', 'common-page', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '3', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('1401', '14', '/link/internal', 'internal', null, null, 'internal', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '1', '1', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('1402', '14', '/link/external', 'external', null, null, 'external', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '2', '1', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('1501', '15', '/monitor/onlineuser', 'onlineuser', null, 'monitor/onlineuser/index', 'onlineuser', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '1', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('1502', '15', '/monitor/crontab', 'crontab', null, 'monitor/crontab/index', 'crontab', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '2', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('1503', '15', '/monitor/crontab-logs', 'crontab-logs', null, 'monitor/crontab-logs/index', 'crontab-logs', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '3', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('50201', '0502', '/multilevel/third-2', 'third-2', null, 'multilevel/third/third-2', 'third-2', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '2', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('50202', '0502', '/multilevel/third-1', 'third-1', null, 'multilevel/third/third-1', 'third-1', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '1', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('50203', '0502', '/multilevel/third-3', 'third-3', null, 'multilevel/third/third-3', 'third-3', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '3', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('90101', '0901', '/functions/routing-operation/common-route', 'common-route', null, 'functions/routing-operation/common-route', 'common-route', '0', '1', '0', '1', '0', '', '0', 'switch', '', '1', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('90102', '0901', '/functions/routing-operation/dynamic-route/:name/:text', 'dynamic-route', null, 'functions/routing-operation/dynamic-route', 'dynamic-route', '0', '1', '0', '1', '0', '', '0', 'switch', '', '2', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('130101', '1301', '', 'btn-add', null, '', '新增按钮666', '0', '0', '0', '0', '0', '', '0', '', '', '1', '3', '0', '', '2025-09-01 11:29:58', '2025-09-01 11:29:58', null, null);
INSERT INTO `sys_menu` VALUES ('130102', '1301', '', 'btn-edit', null, '', '编辑按钮', '0', '0', '0', '0', '0', '', '0', '', '', '2', '3', '0', '', '2025-09-01 11:29:58', '2025-09-01 11:29:58', null, null);
INSERT INTO `sys_menu` VALUES ('130103', '1301', '', 'btn-delete', null, '', '删除按钮', '0', '0', '0', '0', '0', '', '0', '', '', '3', '3', '0', '', '2025-09-01 11:29:58', '2025-09-01 11:29:58', null, null);
INSERT INTO `sys_menu` VALUES ('130201', '1301', '', 'btn-add-2', null, '', '新增按钮-2', '0', '0', '0', '0', '0', '', '0', '', '', '1', '3', '0', '', '2025-09-01 11:29:58', '2025-09-01 11:29:58', null, null);
INSERT INTO `sys_menu` VALUES ('130202', '1301', '', 'btn-edit-2', null, '', '编辑按钮-2', '0', '0', '0', '0', '0', '', '0', '', '', '2', '3', '0', '', '2025-09-01 11:29:58', '2025-09-01 11:29:58', null, null);
INSERT INTO `sys_menu` VALUES ('130203', '1301', '', 'btn-delete-2', null, '', '删除按钮-2', '0', '0', '0', '0', '0', '', '0', '', '', '3', '3', '0', '', '2025-09-01 11:29:58', '2025-09-01 11:29:58', null, null);
INSERT INTO `sys_menu` VALUES ('140101', '1401', '/link/internal/uigradients', 'uigradients', null, 'link/internal/internal', 'uigradients', '0', '0', '0', '1', '0', 'https://uigradients.com/#HoneyDew', '1', '', 'icon-menu', '1', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('140102', '1401', '/link/internal/color-taking-tool', 'color-taking-tool', null, 'link/internal/internal', 'color-taking-tool', '0', '0', '0', '1', '0', 'https://photokit.com/colors/eyedropper/?lang=zh', '1', '', 'icon-menu', '2', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('140103', '1401', '/link/internal/grid-generator', 'grid-generator', null, 'link/internal/internal', 'grid-generator', '0', '0', '0', '1', '0', 'https://cssgrid-generator.netlify.app/', '1', '', 'icon-menu', '3', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('140104', '1401', '/link/internal/gaodemap', 'gaodemap', null, 'link/internal/internal', 'amap', '0', '0', '0', '1', '0', 'http://115.190.79.132:82/', '1', '', 'icon-menu', '4', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('140201', '1402', '/link/external/SnowAdmin-Docs', 'SnowAdmin-Docs', null, 'link/external/external', 'SnowAdmin-Docs', '0', '0', '0', '1', '0', 'http://115.190.79.132:81/', '0', '', 'icon-menu', '5', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('140202', '1402', '/link/external/vue', 'vue', null, 'link/external/external', 'vue', '0', '0', '0', '1', '0', 'https://cn.vuejs.org/', '0', '', 'icon-menu', '1', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('140203', '1402', '/link/external/vite', 'vite', null, 'link/external/external', 'vite', '0', '0', '0', '1', '0', 'https://www.vitejs.net/', '0', '', 'icon-menu', '2', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('140205', '1402', '/link/external/juejin', 'juejin', null, 'link/external/external', 'juejin', '0', '0', '0', '1', '0', 'https://juejin.cn/user/1728883023940600', '0', '', 'icon-menu', '4', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('140206', '0', '/test', 'Test', '/test', '', '测试目录', '0', '0', '0', '1', '0', '', '0', 'add-voucher', 'IconAlipayCircle', '100', '1', '0', '', '2025-09-02 15:11:26', '2025-09-02 17:57:36', null, '1');
INSERT INTO `sys_menu` VALUES ('140207', '140206', '/test1', 'Test1', '/test1', '', '测试目录1', '0', '0', '0', '1', '0', '', '0', 'data-queries', 'IconArrowUp', '1', '1', '0', '', '2025-09-02 15:12:09', '2025-09-02 15:12:09', null, '1');
INSERT INTO `sys_menu` VALUES ('140208', '140207', '/testmenu', 'Testmenu', '', 'system/test/test', '测试菜单', '0', '0', '0', '1', '0', '', '0', 'about', 'IconApps', '1', '2', '0', '', '2025-09-02 15:13:54', '2025-09-04 17:55:23', null, '1');
INSERT INTO `sys_menu` VALUES ('140209', '140208', '', '', '', '', '测试按钮', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'sys:btn:test', '2025-09-02 16:05:48', '2025-09-02 16:05:48', null, '1');
INSERT INTO `sys_menu` VALUES ('140211', '140208', '', '', '', '', '测试按钮2', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'sys:btn:test1', '2025-09-02 17:50:02', '2025-09-02 17:50:02', null, '1');
INSERT INTO `sys_menu` VALUES ('140212', '0', '/test2', 'Test2', '', 'system/test/test2', 'test2', '0', '0', '0', '1', '0', '', '0', 'about', '', '99', '2', '0', '', '2025-09-02 17:55:12', '2025-09-02 17:57:29', null, '1');
INSERT INTO `sys_menu` VALUES ('140213', '10', '/system/api', 'SystemApi', '', 'system/sysapi/sysapi', 'API管理', '0', '0', '0', '1', '0', '', '0', '', 'IconMenu', '4', '2', '0', '', '2025-09-03 10:53:57', '2025-09-04 17:29:12', null, '1');
INSERT INTO `sys_menu` VALUES ('140214', '1001', '', '', '', '', '新增', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:account:add', '2025-09-03 16:11:58', '2025-09-03 16:11:58', null, '1');
INSERT INTO `sys_menu` VALUES ('140215', '1001', '', '', '', '', '编辑', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:account:edit', '2025-09-03 17:11:24', '2025-09-03 17:11:24', null, '1');
INSERT INTO `sys_menu` VALUES ('140216', '1001', '', '', '', '', '删除', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:account:delete', '2025-09-03 17:12:22', '2025-09-03 17:12:22', null, '1');
INSERT INTO `sys_menu` VALUES ('140217', '140208', '', '', '', '', '测试按钮3', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'sys:btn:test3', '2025-09-03 17:37:38', '2025-09-03 17:37:38', null, '1');
INSERT INTO `sys_menu` VALUES ('140218', '1002', '', '', '', '', '新增', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:role:add', '2025-09-04 16:43:54', '2025-09-04 16:43:54', null, '1');
INSERT INTO `sys_menu` VALUES ('140219', '1002', '', '', '', '', '编辑', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:role:edit', '2025-09-04 16:47:15', '2025-09-04 16:47:15', null, '1');
INSERT INTO `sys_menu` VALUES ('140220', '1002', '', '', '', '', '删除', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:role:delete', '2025-09-04 16:50:19', '2025-09-04 16:50:19', null, '1');
INSERT INTO `sys_menu` VALUES ('140221', '1002', '', '', '', '', '分配权限', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:role:addRoleMenu', '2025-09-04 16:53:09', '2025-09-04 16:53:09', null, '1');
INSERT INTO `sys_menu` VALUES ('140222', '1003', '', '', '', '', '新增', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:menu:add', '2025-09-04 17:07:16', '2025-09-04 17:07:16', null, '1');
INSERT INTO `sys_menu` VALUES ('140223', '1003', '', '', '', '', '编辑', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:menu:edit', '2025-09-04 17:11:51', '2025-09-04 17:11:51', null, '1');
INSERT INTO `sys_menu` VALUES ('140224', '1003', '', '', '', '', '删除', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:menu:delete', '2025-09-04 17:12:24', '2025-09-04 17:12:24', null, '1');
INSERT INTO `sys_menu` VALUES ('140225', '1003', '', '', '', '', '分配权限', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:menu:setMenuApis', '2025-09-04 17:20:09', '2025-09-04 17:20:09', null, '1');
INSERT INTO `sys_menu` VALUES ('140226', '140213', '', '', '', '', '新增', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:api:add', '2025-09-04 17:30:56', '2025-09-04 17:30:56', null, '1');
INSERT INTO `sys_menu` VALUES ('140227', '140213', '', '', '', '', '编辑', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:api:edit', '2025-09-04 17:31:20', '2025-09-04 17:31:20', null, '1');
INSERT INTO `sys_menu` VALUES ('140228', '140213', '', '', '', '', '删除', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:api:delete', '2025-09-04 17:31:38', '2025-09-04 17:31:38', null, '1');
INSERT INTO `sys_menu` VALUES ('140229', '1004', '', '', '', '', '新增部门', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:division:add', '2025-09-12 14:50:55', '2025-09-12 14:50:55', null, '1');
INSERT INTO `sys_menu` VALUES ('140230', '1004', '', '', '', '', '编辑部门', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:division:edit', '2025-09-12 14:51:17', '2025-09-12 14:51:17', null, '1');
INSERT INTO `sys_menu` VALUES ('140231', '1004', '', '', '', '', '删除部门', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:division:delete', '2025-09-12 14:51:51', '2025-09-12 14:51:51', null, '1');
INSERT INTO `sys_menu` VALUES ('140232', '1005', '', '', '', '', '新增', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:dict:add', '2025-09-16 16:38:06', '2025-09-16 16:38:06', null, '1');
INSERT INTO `sys_menu` VALUES ('140233', '1005', '', '', '', '', '编辑', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:dict:edit', '2025-09-16 16:39:58', '2025-09-16 16:39:58', null, '1');
INSERT INTO `sys_menu` VALUES ('140234', '1005', '', '', '', '', '删除', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:dict:delete', '2025-09-16 16:40:19', '2025-09-16 16:40:19', null, '1');
INSERT INTO `sys_menu` VALUES ('140235', '1005', '', '', '', '', '字典项管理', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:dictitem:list', '2025-09-16 17:09:58', '2025-09-16 17:31:35', null, '1');
INSERT INTO `sys_menu` VALUES ('140236', '1005', '', '', '', '', '新增字典项', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:dictitem:add', '2025-09-16 17:32:06', '2025-09-16 17:32:06', null, '1');
INSERT INTO `sys_menu` VALUES ('140237', '1005', '', '', '', '', '编辑字典项', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:dictitem:edit', '2025-09-16 17:33:16', '2025-09-16 17:33:16', null, '1');
INSERT INTO `sys_menu` VALUES ('140238', '1005', '', '', '', '', '删除字典项', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:dictitem:delete', '2025-09-16 17:33:41', '2025-09-16 17:33:41', null, '1');
INSERT INTO `sys_menu` VALUES ('140239', '10', '/system/affix', 'SystemAffix', '', 'system/affix/affix', '文件管理', '0', '0', '0', '1', '0', '', '0', '', 'IconMenu', '1', '2', '0', '', '2025-09-25 15:17:00', '2025-09-25 15:17:00', null, '1');
INSERT INTO `sys_menu` VALUES ('140240', '140239', '', '', '', '', '文件上传', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:affix:upload', '2025-09-25 15:45:29', '2025-09-25 15:46:29', null, '1');
INSERT INTO `sys_menu` VALUES ('140241', '140239', '', '', '', '', '删除文件', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:affix:delete', '2025-09-25 15:46:52', '2025-09-25 15:46:52', null, '1');
INSERT INTO `sys_menu` VALUES ('140242', '140239', '', '', '', '', '修改文件名', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:affix:updateName', '2025-09-25 15:47:41', '2025-09-25 15:47:41', null, '1');
INSERT INTO `sys_menu` VALUES ('140243', '140239', '', '', '', '', '下载文件', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:affix:download', '2025-09-25 15:48:56', '2025-09-25 15:48:56', null, '1');
INSERT INTO `sys_menu` VALUES ('140244', '1002', '', '', '', '', '数据权限', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:role:dataScope', '2025-09-26 17:07:16', '2025-09-26 17:07:16', null, '1');

-- ----------------------------
-- Table structure for sys_menu_api
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu_api`;
CREATE TABLE `sys_menu_api` (
  `menu_id` int(11) unsigned NOT NULL,
  `api_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`menu_id`,`api_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of sys_menu_api
-- ----------------------------
INSERT INTO `sys_menu_api` VALUES ('1', '5');
INSERT INTO `sys_menu_api` VALUES ('1', '6');
INSERT INTO `sys_menu_api` VALUES ('1', '7');
INSERT INTO `sys_menu_api` VALUES ('1', '12');
INSERT INTO `sys_menu_api` VALUES ('1', '27');
INSERT INTO `sys_menu_api` VALUES ('1', '54');
INSERT INTO `sys_menu_api` VALUES ('1001', '8');
INSERT INTO `sys_menu_api` VALUES ('1001', '18');
INSERT INTO `sys_menu_api` VALUES ('1001', '19');
INSERT INTO `sys_menu_api` VALUES ('1002', '19');
INSERT INTO `sys_menu_api` VALUES ('1003', '13');
INSERT INTO `sys_menu_api` VALUES ('1004', '18');
INSERT INTO `sys_menu_api` VALUES ('1005', '41');
INSERT INTO `sys_menu_api` VALUES ('1007', '53');
INSERT INTO `sys_menu_api` VALUES ('140213', '29');
INSERT INTO `sys_menu_api` VALUES ('140214', '9');
INSERT INTO `sys_menu_api` VALUES ('140215', '10');
INSERT INTO `sys_menu_api` VALUES ('140216', '11');
INSERT INTO `sys_menu_api` VALUES ('140218', '24');
INSERT INTO `sys_menu_api` VALUES ('140219', '25');
INSERT INTO `sys_menu_api` VALUES ('140220', '26');
INSERT INTO `sys_menu_api` VALUES ('140221', '13');
INSERT INTO `sys_menu_api` VALUES ('140221', '20');
INSERT INTO `sys_menu_api` VALUES ('140221', '21');
INSERT INTO `sys_menu_api` VALUES ('140222', '15');
INSERT INTO `sys_menu_api` VALUES ('140223', '16');
INSERT INTO `sys_menu_api` VALUES ('140224', '17');
INSERT INTO `sys_menu_api` VALUES ('140225', '29');
INSERT INTO `sys_menu_api` VALUES ('140225', '35');
INSERT INTO `sys_menu_api` VALUES ('140225', '36');
INSERT INTO `sys_menu_api` VALUES ('140226', '31');
INSERT INTO `sys_menu_api` VALUES ('140227', '30');
INSERT INTO `sys_menu_api` VALUES ('140227', '32');
INSERT INTO `sys_menu_api` VALUES ('140228', '33');
INSERT INTO `sys_menu_api` VALUES ('140229', '38');
INSERT INTO `sys_menu_api` VALUES ('140230', '39');
INSERT INTO `sys_menu_api` VALUES ('140231', '40');
INSERT INTO `sys_menu_api` VALUES ('140232', '43');
INSERT INTO `sys_menu_api` VALUES ('140233', '44');
INSERT INTO `sys_menu_api` VALUES ('140234', '45');
INSERT INTO `sys_menu_api` VALUES ('140235', '48');
INSERT INTO `sys_menu_api` VALUES ('140236', '50');
INSERT INTO `sys_menu_api` VALUES ('140237', '51');
INSERT INTO `sys_menu_api` VALUES ('140238', '52');
INSERT INTO `sys_menu_api` VALUES ('140239', '58');
INSERT INTO `sys_menu_api` VALUES ('140240', '55');
INSERT INTO `sys_menu_api` VALUES ('140241', '56');
INSERT INTO `sys_menu_api` VALUES ('140242', '57');
INSERT INTO `sys_menu_api` VALUES ('140243', '60');
INSERT INTO `sys_menu_api` VALUES ('140244', '61');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '角色名称',
  `sort` int(11) DEFAULT '0' COMMENT '排序',
  `status` tinyint(3) DEFAULT '0' COMMENT '状态',
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '描述',
  `parent_id` int(11) unsigned DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) unsigned DEFAULT NULL,
  `data_scope` int(11) DEFAULT '0' COMMENT '数据权限',
  `checked_depts` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '数据权限关联的部门',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES ('1', '系统管理员', '1', '1', '最高权限管理员角色', '0', '2025-09-01 17:32:12', '2025-09-30 15:53:24', null, '1', '1', '');
INSERT INTO `sys_role` VALUES ('2', '业务管理员', '2', '1', '业务管理主要角色', '0', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('3', '内容审核员', '3', '1', '负责内容审核', '0', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('4', '财务经理', '4', '1', '财务管理主要角色', '0', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('5', '客服主管', '5', '1', '客户服务管理角色', '0', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('6', '运营总监', '6', '1', '运营部门负责人', '0', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('7', '产品经理', '7', '1', '产品管理主要角色', '0', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('8', '技术总监', '8', '1', '技术部门负责人', '0', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('9', '市场专员', '9', '1', '市场推广角色', '0', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('10', '人力资源经理', '10', '1', '人力资源管理部门角色', '0', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('11', '安全总监', '11', '1', '负责系统安全和数据保护', '0', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('12', '数据分析师', '12', '1', '负责业务数据分析和洞察', '0', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('13', '项目经理', '13', '1', '项目管理与协调', '0', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('14', '质量保证经理', '14', '1', '质量管理与控制', '0', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('15', '基础设施管理员', '15', '1', 'IT基础设施管理', '0', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('16', '用户管理员', '1', '1', '管理用户账户', '1', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('17', '权限管理员', '2', '1', '管理权限设置', '1', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('18', '日志审计员', '3', '1', '查看系统日志', '1', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('19', '业务操作员', '1', '1', '日常业务操作', '2', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('20', '数据录入员', '2', '1', '业务数据录入', '2', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('21', '图文审核员', '1', '0', '审核图文内容', '3', '2025-09-01 17:32:12', '2025-09-30 15:00:54', null, '1', '0', '');
INSERT INTO `sys_role` VALUES ('22', '视频审核员', '2', '1', '审核视频内容', '3', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('23', '会计', '1', '1', '日常会计核算', '4', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('24', '出纳', '2', '1', '资金管理', '4', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('25', '财务分析员', '3', '1', '财务数据分析', '4', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('26', '在线客服', '1', '1', '提供在线客服支持', '5', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('27', '电话客服', '2', '1', '提供电话客服支持', '5', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('28', '活动运营', '1', '1', '活动策划与执行', '6', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('29', '用户运营', '2', '1', '用户维护与增长', '6', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('30', 'UI设计师', '1', '1', '界面设计', '7', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('31', '交互设计师', '2', '1', '交互设计', '7', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('32', '后端开发', '1', '1', '后端开发工程师', '8', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('33', '前端开发', '2', '1', '前端开发工程师', '8', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('34', '测试工程师', '3', '1', '系统测试', '8', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('35', '推广专员', '1', '1', '市场推广', '9', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('36', '品牌专员', '2', '1', '品牌管理', '9', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('37', '招聘专员', '1', '0', '人员招聘', '10', '2025-09-01 17:32:12', '2025-09-30 15:51:54', null, '1', '0', '');
INSERT INTO `sys_role` VALUES ('38', '培训专员', '2', '1', '员工培训', '10', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('39', '薪酬专员', '3', '1', '薪酬福利管理', '10', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('40', '网络安全工程师', '1', '1', '负责网络安全防护', '11', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('41', '数据安全专员', '2', '1', '负责数据安全保护', '11', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('42', '数据挖掘工程师', '1', '1', '负责数据挖掘分析', '12', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('43', '报表开发员', '2', '1', '负责报表开发和维护', '12', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('44', '项目协调员', '1', '1', '协助项目管理工作', '13', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('45', '项目助理', '2', '1', '项目支持工作', '13', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('46', '测试专员', '1', '1', '执行测试工作', '14', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('47', '质量审核员', '2', '1', '进行质量审核', '14', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('48', '网络管理员', '1', '1', '管理网络设备', '15', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('49', '服务器管理员', '2', '1', '管理服务器资源', '15', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('50', '数据库管理员', '3', '1', '管理数据库系统', '15', '2025-09-01 17:32:12', '2025-09-01 17:32:12', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('51', ' 测试角色', '1', '1', 'test', '0', '2025-09-01 17:33:24', '2025-09-30 15:53:33', null, '1', '1', '');
INSERT INTO `sys_role` VALUES ('52', '测试角色_1', '1', '1', '666', '51', '2025-09-01 17:33:44', '2025-09-01 17:51:58', null, '1', '0', null);
INSERT INTO `sys_role` VALUES ('53', '测试角色_2', '1', '1', '', '51', '2025-09-04 14:47:43', '2025-09-04 15:01:06', null, '1', '0', null);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu` (
  `role_id` int(11) unsigned NOT NULL,
  `menu_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`role_id`,`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES ('1', '1');
INSERT INTO `sys_role_menu` VALUES ('1', '2');
INSERT INTO `sys_role_menu` VALUES ('1', '3');
INSERT INTO `sys_role_menu` VALUES ('1', '4');
INSERT INTO `sys_role_menu` VALUES ('1', '5');
INSERT INTO `sys_role_menu` VALUES ('1', '6');
INSERT INTO `sys_role_menu` VALUES ('1', '7');
INSERT INTO `sys_role_menu` VALUES ('1', '9');
INSERT INTO `sys_role_menu` VALUES ('1', '10');
INSERT INTO `sys_role_menu` VALUES ('1', '12');
INSERT INTO `sys_role_menu` VALUES ('1', '13');
INSERT INTO `sys_role_menu` VALUES ('1', '14');
INSERT INTO `sys_role_menu` VALUES ('1', '15');
INSERT INTO `sys_role_menu` VALUES ('1', '16');
INSERT INTO `sys_role_menu` VALUES ('1', '17');
INSERT INTO `sys_role_menu` VALUES ('1', '18');
INSERT INTO `sys_role_menu` VALUES ('1', '201');
INSERT INTO `sys_role_menu` VALUES ('1', '301');
INSERT INTO `sys_role_menu` VALUES ('1', '302');
INSERT INTO `sys_role_menu` VALUES ('1', '401');
INSERT INTO `sys_role_menu` VALUES ('1', '402');
INSERT INTO `sys_role_menu` VALUES ('1', '501');
INSERT INTO `sys_role_menu` VALUES ('1', '502');
INSERT INTO `sys_role_menu` VALUES ('1', '601');
INSERT INTO `sys_role_menu` VALUES ('1', '602');
INSERT INTO `sys_role_menu` VALUES ('1', '603');
INSERT INTO `sys_role_menu` VALUES ('1', '604');
INSERT INTO `sys_role_menu` VALUES ('1', '605');
INSERT INTO `sys_role_menu` VALUES ('1', '606');
INSERT INTO `sys_role_menu` VALUES ('1', '607');
INSERT INTO `sys_role_menu` VALUES ('1', '608');
INSERT INTO `sys_role_menu` VALUES ('1', '609');
INSERT INTO `sys_role_menu` VALUES ('1', '610');
INSERT INTO `sys_role_menu` VALUES ('1', '611');
INSERT INTO `sys_role_menu` VALUES ('1', '612');
INSERT INTO `sys_role_menu` VALUES ('1', '613');
INSERT INTO `sys_role_menu` VALUES ('1', '614');
INSERT INTO `sys_role_menu` VALUES ('1', '701');
INSERT INTO `sys_role_menu` VALUES ('1', '702');
INSERT INTO `sys_role_menu` VALUES ('1', '703');
INSERT INTO `sys_role_menu` VALUES ('1', '901');
INSERT INTO `sys_role_menu` VALUES ('1', '902');
INSERT INTO `sys_role_menu` VALUES ('1', '903');
INSERT INTO `sys_role_menu` VALUES ('1', '904');
INSERT INTO `sys_role_menu` VALUES ('1', '905');
INSERT INTO `sys_role_menu` VALUES ('1', '1001');
INSERT INTO `sys_role_menu` VALUES ('1', '1002');
INSERT INTO `sys_role_menu` VALUES ('1', '1003');
INSERT INTO `sys_role_menu` VALUES ('1', '1004');
INSERT INTO `sys_role_menu` VALUES ('1', '1005');
INSERT INTO `sys_role_menu` VALUES ('1', '1006');
INSERT INTO `sys_role_menu` VALUES ('1', '1007');
INSERT INTO `sys_role_menu` VALUES ('1', '1301');
INSERT INTO `sys_role_menu` VALUES ('1', '1302');
INSERT INTO `sys_role_menu` VALUES ('1', '1303');
INSERT INTO `sys_role_menu` VALUES ('1', '1401');
INSERT INTO `sys_role_menu` VALUES ('1', '1402');
INSERT INTO `sys_role_menu` VALUES ('1', '1501');
INSERT INTO `sys_role_menu` VALUES ('1', '1502');
INSERT INTO `sys_role_menu` VALUES ('1', '1503');
INSERT INTO `sys_role_menu` VALUES ('1', '50201');
INSERT INTO `sys_role_menu` VALUES ('1', '50202');
INSERT INTO `sys_role_menu` VALUES ('1', '50203');
INSERT INTO `sys_role_menu` VALUES ('1', '90101');
INSERT INTO `sys_role_menu` VALUES ('1', '90102');
INSERT INTO `sys_role_menu` VALUES ('1', '130101');
INSERT INTO `sys_role_menu` VALUES ('1', '130102');
INSERT INTO `sys_role_menu` VALUES ('1', '130103');
INSERT INTO `sys_role_menu` VALUES ('1', '130201');
INSERT INTO `sys_role_menu` VALUES ('1', '130202');
INSERT INTO `sys_role_menu` VALUES ('1', '130203');
INSERT INTO `sys_role_menu` VALUES ('1', '140101');
INSERT INTO `sys_role_menu` VALUES ('1', '140102');
INSERT INTO `sys_role_menu` VALUES ('1', '140103');
INSERT INTO `sys_role_menu` VALUES ('1', '140104');
INSERT INTO `sys_role_menu` VALUES ('1', '140201');
INSERT INTO `sys_role_menu` VALUES ('1', '140202');
INSERT INTO `sys_role_menu` VALUES ('1', '140203');
INSERT INTO `sys_role_menu` VALUES ('1', '140205');
INSERT INTO `sys_role_menu` VALUES ('1', '140206');
INSERT INTO `sys_role_menu` VALUES ('1', '140207');
INSERT INTO `sys_role_menu` VALUES ('1', '140208');
INSERT INTO `sys_role_menu` VALUES ('1', '140209');
INSERT INTO `sys_role_menu` VALUES ('1', '140211');
INSERT INTO `sys_role_menu` VALUES ('1', '140212');
INSERT INTO `sys_role_menu` VALUES ('1', '140213');
INSERT INTO `sys_role_menu` VALUES ('1', '140214');
INSERT INTO `sys_role_menu` VALUES ('1', '140215');
INSERT INTO `sys_role_menu` VALUES ('1', '140216');
INSERT INTO `sys_role_menu` VALUES ('1', '140217');
INSERT INTO `sys_role_menu` VALUES ('1', '140218');
INSERT INTO `sys_role_menu` VALUES ('1', '140219');
INSERT INTO `sys_role_menu` VALUES ('1', '140220');
INSERT INTO `sys_role_menu` VALUES ('1', '140221');
INSERT INTO `sys_role_menu` VALUES ('1', '140222');
INSERT INTO `sys_role_menu` VALUES ('1', '140223');
INSERT INTO `sys_role_menu` VALUES ('1', '140224');
INSERT INTO `sys_role_menu` VALUES ('1', '140225');
INSERT INTO `sys_role_menu` VALUES ('1', '140226');
INSERT INTO `sys_role_menu` VALUES ('1', '140227');
INSERT INTO `sys_role_menu` VALUES ('1', '140228');
INSERT INTO `sys_role_menu` VALUES ('1', '140229');
INSERT INTO `sys_role_menu` VALUES ('1', '140230');
INSERT INTO `sys_role_menu` VALUES ('1', '140231');
INSERT INTO `sys_role_menu` VALUES ('1', '140232');
INSERT INTO `sys_role_menu` VALUES ('1', '140233');
INSERT INTO `sys_role_menu` VALUES ('1', '140234');
INSERT INTO `sys_role_menu` VALUES ('1', '140235');
INSERT INTO `sys_role_menu` VALUES ('1', '140236');
INSERT INTO `sys_role_menu` VALUES ('1', '140237');
INSERT INTO `sys_role_menu` VALUES ('1', '140238');
INSERT INTO `sys_role_menu` VALUES ('1', '140239');
INSERT INTO `sys_role_menu` VALUES ('1', '140240');
INSERT INTO `sys_role_menu` VALUES ('1', '140241');
INSERT INTO `sys_role_menu` VALUES ('1', '140242');
INSERT INTO `sys_role_menu` VALUES ('1', '140243');
INSERT INTO `sys_role_menu` VALUES ('1', '140244');
INSERT INTO `sys_role_menu` VALUES ('2', '1');
INSERT INTO `sys_role_menu` VALUES ('2', '10');
INSERT INTO `sys_role_menu` VALUES ('2', '1001');
INSERT INTO `sys_role_menu` VALUES ('2', '140214');
INSERT INTO `sys_role_menu` VALUES ('2', '140215');
INSERT INTO `sys_role_menu` VALUES ('3', '1');
INSERT INTO `sys_role_menu` VALUES ('3', '1002');
INSERT INTO `sys_role_menu` VALUES ('3', '140218');
INSERT INTO `sys_role_menu` VALUES ('3', '140219');
INSERT INTO `sys_role_menu` VALUES ('3', '140221');
INSERT INTO `sys_role_menu` VALUES ('4', '1');
INSERT INTO `sys_role_menu` VALUES ('4', '1002');
INSERT INTO `sys_role_menu` VALUES ('4', '140218');
INSERT INTO `sys_role_menu` VALUES ('4', '140219');
INSERT INTO `sys_role_menu` VALUES ('4', '140221');
INSERT INTO `sys_role_menu` VALUES ('16', '1');
INSERT INTO `sys_role_menu` VALUES ('16', '10');
INSERT INTO `sys_role_menu` VALUES ('16', '1001');
INSERT INTO `sys_role_menu` VALUES ('16', '140206');
INSERT INTO `sys_role_menu` VALUES ('16', '140207');
INSERT INTO `sys_role_menu` VALUES ('16', '140208');
INSERT INTO `sys_role_menu` VALUES ('16', '140209');
INSERT INTO `sys_role_menu` VALUES ('16', '140211');
INSERT INTO `sys_role_menu` VALUES ('16', '140214');
INSERT INTO `sys_role_menu` VALUES ('16', '140215');
INSERT INTO `sys_role_menu` VALUES ('16', '140217');

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role` (
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
  `role_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '角色ID',
  PRIMARY KEY (`user_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES ('1', '1');
INSERT INTO `sys_user_role` VALUES ('3', '1');
INSERT INTO `sys_user_role` VALUES ('4', '1');
INSERT INTO `sys_user_role` VALUES ('5', '1');
INSERT INTO `sys_user_role` VALUES ('9', '51');
INSERT INTO `sys_user_role` VALUES ('19', '16');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(50) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '用户名',
  `password` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '密码',
  `email` varchar(100) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '邮箱',
  `status` tinyint(1) DEFAULT '1' COMMENT '是否启用 0停用 1启用',
  `dept_id` int(11) unsigned DEFAULT '0' COMMENT '部门ID',
  `phone` varchar(64) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '电话',
  `sex` varchar(64) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '性别',
  `nick_name` varchar(100) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '昵称',
  `avatar` varchar(255) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '头像',
  `description` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '描述',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) unsigned DEFAULT '0' COMMENT '创建人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('1', 'admin', '$2a$10$2i5mEP7yLJRiJogOuCYgauPCBCTMSKC.M3cpfln/a7dLSmPMPK3qy', 'admin@example.com', '1', '1', '18800000001', '1', '超级管理员', '/public/uploads/2025-09-25\\20250925_d7befa21-d30f-4675-a1f1-9aab783cd188.png', 'testtesttesttesttesttesttesttesttest', '2025-08-18 14:55:05', '2025-09-28 16:34:18', null, '0');
INSERT INTO `users` VALUES ('3', 'zhangsan', '$2a$10$XwLsucEO67/96xfPs9c1OulukfE9bLsO2RLfJHG/kRPDnOOydFzaq', 'zhangsan@example.com', '1', '12', '13800000001', '1', '张三', '', '', '2025-08-28 15:26:45', '2025-09-28 11:44:28', null, '1');
INSERT INTO `users` VALUES ('4', 'lisi', '$2a$10$XwLsucEO67/96xfPs9c1OulukfE9bLsO2RLfJHG/kRPDnOOydFzaq', 'lisi@example.com', '1', '11', '13800000002', '1', '李四', '', '', '2025-08-28 15:26:45', '2025-09-28 11:48:19', null, '1');
INSERT INTO `users` VALUES ('5', 'wangwu', '$2a$10$XwLsucEO67/96xfPs9c1OulukfE9bLsO2RLfJHG/kRPDnOOydFzaq', 'wangwu@example.com', '1', '2', '13800000003', '1', '王五', '', '', '2025-08-28 15:26:45', '2025-09-28 11:48:32', null, '1');
INSERT INTO `users` VALUES ('6', 'zhaoliu', '$2a$10$XwLsucEO67/96xfPs9c1OulukfE9bLsO2RLfJHG/kRPDnOOydFzaq', 'zhaoliu@example.com', '1', '1', '13800000004', '1', '赵六', '', null, '2025-08-28 15:26:45', '2025-08-28 15:26:45', null, '1');
INSERT INTO `users` VALUES ('7', 'sunqi', '$2a$10$XwLsucEO67/96xfPs9c1OulukfE9bLsO2RLfJHG/kRPDnOOydFzaq', 'sunqi@example.com', '1', '1', '13800000005', '1', '孙七', '', null, '2025-08-28 15:26:45', '2025-08-28 15:26:45', null, '1');
INSERT INTO `users` VALUES ('8', 'zhouba', '$2a$10$XwLsucEO67/96xfPs9c1OulukfE9bLsO2RLfJHG/kRPDnOOydFzaq', 'zhouba@example.com', '1', '1', '13800000006', '1', '周八', '', null, '2025-08-28 15:26:45', '2025-08-28 15:26:45', null, '1');
INSERT INTO `users` VALUES ('9', 'wujiu', '$2a$10$XwLsucEO67/96xfPs9c1OulukfE9bLsO2RLfJHG/kRPDnOOydFzaq', 'wujiu@example.com', '0', '1', '13800000007', '1', '吴九', '', '', '2025-08-28 15:26:45', '2025-09-30 10:58:14', null, '1');
INSERT INTO `users` VALUES ('10', 'zhengshi', '$2a$10$XwLsucEO67/96xfPs9c1OulukfE9bLsO2RLfJHG/kRPDnOOydFzaq', 'zhengshi@example.com', '1', '1', '13800000008', '1', '郑十', '', null, '2025-08-28 15:26:45', '2025-08-28 15:26:45', null, '1');
INSERT INTO `users` VALUES ('11', 'lihua', '$2a$10$XwLsucEO67/96xfPs9c1OulukfE9bLsO2RLfJHG/kRPDnOOydFzaq', 'lihua@example.com', '1', '1', '13800000009', '1', '李华', '', null, '2025-08-28 15:26:45', '2025-08-28 15:26:45', null, '1');
INSERT INTO `users` VALUES ('12', 'hanmei', '$2a$10$XwLsucEO67/96xfPs9c1OulukfE9bLsO2RLfJHG/kRPDnOOydFzaq', 'hanmei@example.com', '1', '1', '13800000010', '1', '韩梅', '', null, '2025-08-28 15:26:45', '2025-08-28 15:26:45', null, '1');
INSERT INTO `users` VALUES ('13', 'lucy', '$2a$10$XwLsucEO67/96xfPs9c1OulukfE9bLsO2RLfJHG/kRPDnOOydFzaq', 'lucy@example.com', '1', '1', '13800000011', '1', '露西', '', null, '2025-08-28 15:26:45', '2025-08-28 15:26:45', null, '1');
INSERT INTO `users` VALUES ('14', 'tom', '$2a$10$XwLsucEO67/96xfPs9c1OulukfE9bLsO2RLfJHG/kRPDnOOydFzaq', 'tom@example.com', '1', '1', '13800000012', '1', '汤姆', '', null, '2025-08-28 15:26:45', '2025-08-28 15:26:45', null, '1');
INSERT INTO `users` VALUES ('15', 'jerry', '$2a$10$XwLsucEO67/96xfPs9c1OulukfE9bLsO2RLfJHG/kRPDnOOydFzaq', 'jerry@example.com', '1', '1', '13800000013', '1', '杰瑞', '', null, '2025-08-28 15:26:45', '2025-08-28 15:26:45', null, '1');
INSERT INTO `users` VALUES ('16', 'alice', '$2a$10$XwLsucEO67/96xfPs9c1OulukfE9bLsO2RLfJHG/kRPDnOOydFzaq', 'alice@example.com', '1', '1', '13800000014', '1', '爱丽丝', '', null, '2025-08-28 15:26:45', '2025-08-28 15:26:45', null, '1');
INSERT INTO `users` VALUES ('17', 'bob', '$2a$10$XwLsucEO67/96xfPs9c1OulukfE9bLsO2RLfJHG/kRPDnOOydFzaq', 'bob@example.com', '1', '1', '13800000015', '1', '鲍勃', '', null, '2025-08-28 15:26:45', '2025-08-28 15:26:45', null, '1');
INSERT INTO `users` VALUES ('18', 'test1', '$2a$10$DqUyiUoQXUW3qKPGus4PqOsfdJbLzRYcHkn/.ZrPeK/b0ip2WCSfy', 'test1@qq. om', '1', '4', '18888888888', '1', 'test1', '', '', '2025-09-04 10:52:42', '2025-09-04 11:05:21', null, '1');
INSERT INTO `users` VALUES ('19', 'test2111', '$2a$10$k8/kIAoYObq.qcdVATAaTeydmwES706w0gf.SeROPAlydveYI5WH2', 'test2@qq.com', '1', '4', '18800000002', '1', '测试2', '', '123', '2025-09-18 18:17:29', '2025-09-19 18:03:21', null, '1');
