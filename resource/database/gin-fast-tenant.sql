/*
Navicat MySQL Data Transfer

Source Server         : localhsot5.7
Source Server Version : 50726
Source Host           : localhost:3306
Source Database       : gin-fast-tenant

Target Server Type    : MYSQL
Target Server Version : 50726
File Encoding         : 65001

Date: 2025-10-31 18:06:31
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for example
-- ----------------------------
DROP TABLE IF EXISTS `example`;
CREATE TABLE `example` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '名称',
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '描述',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `tenant_id` int(11) unsigned DEFAULT '0' COMMENT '租户ID字段',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of example
-- ----------------------------

-- ----------------------------
-- Table structure for sys_affix
-- ----------------------------
DROP TABLE IF EXISTS `sys_affix`;
CREATE TABLE `sys_affix` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '文件名',
  `path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '路径',
  `url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '文件url',
  `size` int(10) DEFAULT NULL COMMENT '文件大小',
  `ftype` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '文件类型',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `suffix` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '文件后缀',
  `tenant_id` int(11) unsigned DEFAULT '0' COMMENT '租户ID字段',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of sys_affix
-- ----------------------------

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
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of sys_api
-- ----------------------------
INSERT INTO `sys_api` VALUES ('1', '用户登录', '/api/login', 'POST', '认证管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', null, '1');
INSERT INTO `sys_api` VALUES ('2', '刷新Token', '/api/refreshToken', 'POST', '认证管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', null, '1');
INSERT INTO `sys_api` VALUES ('3', '生成验证码ID', '/api/captcha/id', 'GET', '认证管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', null, '1');
INSERT INTO `sys_api` VALUES ('4', '获取验证码图片', '/api/captcha/image', 'GET', '认证管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', null, '1');
INSERT INTO `sys_api` VALUES ('5', '用户登出', '/api/users/logout', 'POST', '认证管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', null, '1');
INSERT INTO `sys_api` VALUES ('6', '获取当前用户信息', '/api/users/profile', 'GET', '用户管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', null, '1');
INSERT INTO `sys_api` VALUES ('7', '根据ID获取用户信息', '/api/users/:id', 'GET', '用户管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', null, '1');
INSERT INTO `sys_api` VALUES ('8', '用户列表', '/api/users/list', 'GET', '用户管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', null, '1');
INSERT INTO `sys_api` VALUES ('9', '新增用户', '/api/users/add', 'POST', '用户管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', null, '1');
INSERT INTO `sys_api` VALUES ('10', '更新用户信息', '/api/users/edit', 'PUT', '用户管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', null, '1');
INSERT INTO `sys_api` VALUES ('11', '删除用户', '/api/users/delete', 'DELETE', '用户管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', null, '1');
INSERT INTO `sys_api` VALUES ('12', '获取用户权限菜单', '/api/sysMenu/getRouters', 'GET', '菜单管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, '1');
INSERT INTO `sys_api` VALUES ('13', '获取完整菜单列表', '/api/sysMenu/getMenuList', 'GET', '菜单管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, '1');
INSERT INTO `sys_api` VALUES ('14', '根据ID获取菜单信息', '/api/sysMenu/:id', 'GET', '菜单管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, '1');
INSERT INTO `sys_api` VALUES ('15', '新增菜单', '/api/sysMenu/add', 'POST', '菜单管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, '1');
INSERT INTO `sys_api` VALUES ('16', '更新菜单', '/api/sysMenu/edit', 'PUT', '菜单管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, '1');
INSERT INTO `sys_api` VALUES ('17', '删除菜单', '/api/sysMenu/delete', 'DELETE', '菜单管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, '1');
INSERT INTO `sys_api` VALUES ('18', '获取部门列表', '/api/sysDepartment/getDivision', 'GET', '部门管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, '1');
INSERT INTO `sys_api` VALUES ('19', '获取所有角色数据', '/api/sysRole/getRoles', 'GET', '角色管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, '1');
INSERT INTO `sys_api` VALUES ('20', '根据角色ID获取角色菜单权限', '/api/sysRole/getUserPermission/:roleId', 'GET', '角色管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, '1');
INSERT INTO `sys_api` VALUES ('21', '添加角色的菜单权限', '/api/sysRole/addRoleMenu', 'POST', '角色管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, '1');
INSERT INTO `sys_api` VALUES ('22', '角色分页列表', '/api/sysRole/list', 'GET', '角色管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, '1');
INSERT INTO `sys_api` VALUES ('23', '根据ID获取角色信息', '/api/sysRole/:id', 'GET', '角色管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, '1');
INSERT INTO `sys_api` VALUES ('24', '新增角色', '/api/sysRole/add', 'POST', '角色管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, '1');
INSERT INTO `sys_api` VALUES ('25', '更新角色', '/api/sysRole/edit', 'PUT', '角色管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, '1');
INSERT INTO `sys_api` VALUES ('26', '删除角色', '/api/sysRole/delete', 'DELETE', '角色管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, '1');
INSERT INTO `sys_api` VALUES ('27', '获取所有字典数据', '/api/sysDict/getAllDicts', 'GET', '字典管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, '1');
INSERT INTO `sys_api` VALUES ('28', '根据字典编码获取字典', '/api/sysDict/getByCode/:code', 'GET', '字典管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, '1');
INSERT INTO `sys_api` VALUES ('29', 'API列表', '/api/sysApi/list', 'GET', 'API管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, '1');
INSERT INTO `sys_api` VALUES ('30', '根据ID获取API信息', '/api/sysApi/:id', 'GET', 'API管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, '1');
INSERT INTO `sys_api` VALUES ('31', '新增API', '/api/sysApi/add', 'POST', 'API管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, '1');
INSERT INTO `sys_api` VALUES ('32', '更新API', '/api/sysApi/edit', 'PUT', 'API管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, '1');
INSERT INTO `sys_api` VALUES ('33', '删除API', '/api/sysApi/delete', 'DELETE', 'API管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', null, '1');
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
INSERT INTO `sys_api` VALUES ('62', '读取系统配置', '/api/config/get', 'GET', '系统配置', '2025-10-09 16:21:29', '2025-10-09 16:21:29', null, '1');
INSERT INTO `sys_api` VALUES ('63', '修改系统配置', '/api/config/update', 'PUT', '系统配置', '2025-10-09 16:21:59', '2025-10-09 16:22:09', null, '1');
INSERT INTO `sys_api` VALUES ('64', '查看内存缓存', '/api/config/viewCache', 'GET', '系统配置', '2025-10-10 17:41:33', '2025-10-10 17:41:33', null, '1');
INSERT INTO `sys_api` VALUES ('65', '列表查询', '/api/plugins/example/list', 'GET', '插件示例', '2025-10-14 10:54:47', '2025-10-14 10:54:47', null, '1');
INSERT INTO `sys_api` VALUES ('66', '新增', '/api/plugins/example/add', 'POST', '插件示例', '2025-10-14 10:56:43', '2025-10-14 10:56:43', null, '1');
INSERT INTO `sys_api` VALUES ('67', '修改', '/api/plugins/example/edit', 'PUT', '插件示例', '2025-10-14 10:57:10', '2025-10-14 10:57:17', null, '1');
INSERT INTO `sys_api` VALUES ('68', '删除', '/api/plugins/example/delete', 'DELETE', '插件示例', '2025-10-14 10:58:03', '2025-10-14 10:58:03', null, '1');
INSERT INTO `sys_api` VALUES ('69', '查询单条数据', '/api/plugins/example/:id', 'GET', '插件示例', '2025-10-14 10:59:33', '2025-10-14 10:59:33', null, '1');
INSERT INTO `sys_api` VALUES ('70', '日志列表', '/api/sysOperationLog/list', 'GET', '日志管理', '2025-10-20 10:10:58', '2025-10-20 10:10:58', null, '1');
INSERT INTO `sys_api` VALUES ('71', '日志统计', '/api/sysOperationLog/stats', 'GET', '日志管理', '2025-10-20 10:12:01', '2025-10-20 10:12:01', '2025-10-20 10:45:07', '1');
INSERT INTO `sys_api` VALUES ('72', '日志删除', '/api/sysOperationLog/delete', 'DELETE', '日志管理', '2025-10-20 10:13:19', '2025-10-20 10:13:19', null, '1');
INSERT INTO `sys_api` VALUES ('73', '日志导出', '/api/sysOperationLog/export', 'GET', '日志管理', '2025-10-20 10:14:11', '2025-10-20 10:14:11', null, '1');
INSERT INTO `sys_api` VALUES ('74', '导出菜单', '/api/sysMenu/export', 'GET', '菜单管理', '2025-10-20 17:17:07', '2025-10-20 17:17:07', null, '1');
INSERT INTO `sys_api` VALUES ('75', '导入菜单', '/api/sysMenu/import', 'POST', '菜单管理', '2025-10-21 11:30:34', '2025-10-24 08:59:44', null, '1');
INSERT INTO `sys_api` VALUES ('76', '租户列表', '/api/sysTenant/list', 'GET', '租户管理', '2025-10-24 09:04:18', '2025-10-24 09:04:18', null, '1');
INSERT INTO `sys_api` VALUES ('77', '根据ID获取租户信息', '/api/sysTenant/:id', 'GET', '租户管理', '2025-10-24 09:05:23', '2025-10-24 09:05:23', null, '1');
INSERT INTO `sys_api` VALUES ('78', '新增租户', '/api/sysTenant/add', 'POST', '租户管理', '2025-10-24 09:06:10', '2025-10-24 09:06:10', null, '1');
INSERT INTO `sys_api` VALUES ('79', '编辑租户', '/api/sysTenant/edit', 'PUT', '租户管理', '2025-10-24 09:06:54', '2025-10-24 09:06:54', null, '1');
INSERT INTO `sys_api` VALUES ('80', '删除租户', '/api/sysTenant/:id', 'DELETE', '租户管理', '2025-10-24 09:07:47', '2025-10-24 09:07:56', null, '1');
INSERT INTO `sys_api` VALUES ('81', '租户关联列表', '/api/sysUserTenant/list', 'GET', '租户管理', '2025-10-27 17:51:52', '2025-10-27 17:51:52', null, '1');
INSERT INTO `sys_api` VALUES ('82', '根据用户ID和租户ID获取用户租户关联信息', '/api/sysUserTenant/get', 'GET', '租户管理', '2025-10-27 17:53:13', '2025-10-27 17:53:13', null, '1');
INSERT INTO `sys_api` VALUES ('83', '批量新增用户租户关联', '/api/sysUserTenant/batchAdd', 'POST', '租户管理', '2025-10-27 17:53:48', '2025-10-27 17:53:48', null, '1');
INSERT INTO `sys_api` VALUES ('84', '批量删除用户租户关联', '/api/sysUserTenant/batchDelete', 'DELETE', '租户管理', '2025-10-27 17:54:25', '2025-10-27 17:54:25', null, '1');
INSERT INTO `sys_api` VALUES ('85', '用户列表(不限租户)', '/api/sysUserTenant/userListAll', 'GET', '用户管理', '2025-10-28 09:41:19', '2025-10-28 16:32:35', null, '1');
INSERT INTO `sys_api` VALUES ('86', '获取所有的角色数据(不限制租户)', '/api/sysUserTenant/getRolesAll', 'GET', '租户管理', '2025-10-29 09:17:01', '2025-10-29 09:17:01', null, '1');
INSERT INTO `sys_api` VALUES ('87', '设置用户角色(不限租户)', '/api/sysUserTenant/setUserRoles', 'POST', '租户管理 ', '2025-10-29 09:17:50', '2025-10-29 09:17:50', null, '1');
INSERT INTO `sys_api` VALUES ('88', '获取用户角色ID集合(不限租户)', '/api/sysUserTenant/getUserRoleIDs', 'GET', '租户管理', '2025-10-29 09:18:51', '2025-10-29 09:18:51', null, '1');
INSERT INTO `sys_api` VALUES ('89', '修改用户基本信息', '/api/users/updateBasicInfo', 'PUT', '用户管理', '2025-10-31 09:05:00', '2025-10-31 09:05:00', null, '1');

-- ----------------------------
-- Table structure for sys_casbin_rule
-- ----------------------------
DROP TABLE IF EXISTS `sys_casbin_rule`;
CREATE TABLE `sys_casbin_rule` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ptype` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `v0` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `v1` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `v2` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `v3` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `v4` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `v5` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_casbin_rule` (`ptype`,`v0`,`v1`,`v2`,`v3`,`v4`,`v5`),
  UNIQUE KEY `idx_sys_casbin_rule` (`ptype`,`v0`,`v1`,`v2`,`v3`,`v4`,`v5`)
) ENGINE=InnoDB AUTO_INCREMENT=4414 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of sys_casbin_rule
-- ----------------------------
INSERT INTO `sys_casbin_rule` VALUES ('4188', 'g', 'user_1', 'role_1', '*', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4189', 'g', 'user_4', 'role_2', '*', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4379', 'p', 'role_1', '/api/config/get', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4349', 'p', 'role_1', '/api/config/update', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4391', 'p', 'role_1', '/api/config/viewCache', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4364', 'p', 'role_1', '/api/plugins/example/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4365', 'p', 'role_1', '/api/plugins/example/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4380', 'p', 'role_1', '/api/plugins/example/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4383', 'p', 'role_1', '/api/plugins/example/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4390', 'p', 'role_1', '/api/plugins/example/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4350', 'p', 'role_1', '/api/sysAffix/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4360', 'p', 'role_1', '/api/sysAffix/download/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4341', 'p', 'role_1', '/api/sysAffix/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4336', 'p', 'role_1', '/api/sysAffix/updateName', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4348', 'p', 'role_1', '/api/sysAffix/upload', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4335', 'p', 'role_1', '/api/sysApi/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4363', 'p', 'role_1', '/api/sysApi/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4338', 'p', 'role_1', '/api/sysApi/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4387', 'p', 'role_1', '/api/sysApi/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4400', 'p', 'role_1', '/api/sysApi/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4357', 'p', 'role_1', '/api/sysDepartment/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4393', 'p', 'role_1', '/api/sysDepartment/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4345', 'p', 'role_1', '/api/sysDepartment/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4342', 'p', 'role_1', '/api/sysDepartment/getDivision', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4346', 'p', 'role_1', '/api/sysDict/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4347', 'p', 'role_1', '/api/sysDict/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4396', 'p', 'role_1', '/api/sysDict/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4351', 'p', 'role_1', '/api/sysDict/getAllDicts', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4395', 'p', 'role_1', '/api/sysDict/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4388', 'p', 'role_1', '/api/sysDictItem/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4353', 'p', 'role_1', '/api/sysDictItem/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4389', 'p', 'role_1', '/api/sysDictItem/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4358', 'p', 'role_1', '/api/sysDictItem/getByDictId/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4385', 'p', 'role_1', '/api/sysMenu/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4344', 'p', 'role_1', '/api/sysMenu/apis/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4356', 'p', 'role_1', '/api/sysMenu/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4370', 'p', 'role_1', '/api/sysMenu/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4406', 'p', 'role_1', '/api/sysMenu/export', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4394', 'p', 'role_1', '/api/sysMenu/getMenuList', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4359', 'p', 'role_1', '/api/sysMenu/getRouters', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4366', 'p', 'role_1', '/api/sysMenu/import', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4386', 'p', 'role_1', '/api/sysMenu/setApis', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4373', 'p', 'role_1', '/api/sysOperationLog/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4339', 'p', 'role_1', '/api/sysOperationLog/export', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4362', 'p', 'role_1', '/api/sysOperationLog/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4405', 'p', 'role_1', '/api/sysRole/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4401', 'p', 'role_1', '/api/sysRole/addRoleMenu', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4402', 'p', 'role_1', '/api/sysRole/dataScope', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4384', 'p', 'role_1', '/api/sysRole/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4343', 'p', 'role_1', '/api/sysRole/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4352', 'p', 'role_1', '/api/sysRole/getRoles', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4378', 'p', 'role_1', '/api/sysRole/getUserPermission/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4340', 'p', 'role_1', '/api/sysTenant/*', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4407', 'p', 'role_1', '/api/sysTenant/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4398', 'p', 'role_1', '/api/sysTenant/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4354', 'p', 'role_1', '/api/sysTenant/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4397', 'p', 'role_1', '/api/sysTenant/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4371', 'p', 'role_1', '/api/sysUserTenant/batchAdd', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4337', 'p', 'role_1', '/api/sysUserTenant/batchDelete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4374', 'p', 'role_1', '/api/sysUserTenant/get', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4403', 'p', 'role_1', '/api/sysUserTenant/getRolesAll', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4375', 'p', 'role_1', '/api/sysUserTenant/getUserRoleIDs', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4381', 'p', 'role_1', '/api/sysUserTenant/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4399', 'p', 'role_1', '/api/sysUserTenant/setUserRoles', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4382', 'p', 'role_1', '/api/sysUserTenant/userListAll', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4355', 'p', 'role_1', '/api/users/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4392', 'p', 'role_1', '/api/users/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4369', 'p', 'role_1', '/api/users/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4377', 'p', 'role_1', '/api/users/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4361', 'p', 'role_1', '/api/users/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4367', 'p', 'role_1', '/api/users/logout', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4368', 'p', 'role_1', '/api/users/profile', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4372', 'p', 'role_1', '/api/users/updateAccount', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4404', 'p', 'role_1', '/api/users/updateBasicInfo', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4376', 'p', 'role_1', '/api/users/uploadAvatar', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4148', 'p', 'role_10', '/api/config/get', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4155', 'p', 'role_10', '/api/config/update', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4162', 'p', 'role_10', '/api/config/viewCache', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4168', 'p', 'role_10', '/api/sysAffix/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4125', 'p', 'role_10', '/api/sysApi/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4175', 'p', 'role_10', '/api/sysApi/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4179', 'p', 'role_10', '/api/sysApi/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4153', 'p', 'role_10', '/api/sysApi/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4158', 'p', 'role_10', '/api/sysApi/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4176', 'p', 'role_10', '/api/sysDepartment/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4133', 'p', 'role_10', '/api/sysDepartment/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4167', 'p', 'role_10', '/api/sysDepartment/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4122', 'p', 'role_10', '/api/sysDepartment/getDivision', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4136', 'p', 'role_10', '/api/sysDict/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4144', 'p', 'role_10', '/api/sysDict/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4137', 'p', 'role_10', '/api/sysDict/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4184', 'p', 'role_10', '/api/sysDict/getAllDicts', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4139', 'p', 'role_10', '/api/sysDict/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4146', 'p', 'role_10', '/api/sysDictItem/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4154', 'p', 'role_10', '/api/sysDictItem/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4147', 'p', 'role_10', '/api/sysDictItem/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4141', 'p', 'role_10', '/api/sysDictItem/getByDictId/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4174', 'p', 'role_10', '/api/sysMenu/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4145', 'p', 'role_10', '/api/sysMenu/apis/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4124', 'p', 'role_10', '/api/sysMenu/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4123', 'p', 'role_10', '/api/sysMenu/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4172', 'p', 'role_10', '/api/sysMenu/export', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4177', 'p', 'role_10', '/api/sysMenu/getMenuList', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4150', 'p', 'role_10', '/api/sysMenu/getRouters', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4126', 'p', 'role_10', '/api/sysMenu/import', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4161', 'p', 'role_10', '/api/sysMenu/setApis', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4134', 'p', 'role_10', '/api/sysOperationLog/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4156', 'p', 'role_10', '/api/sysOperationLog/export', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4131', 'p', 'role_10', '/api/sysOperationLog/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4128', 'p', 'role_10', '/api/sysRole/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4135', 'p', 'role_10', '/api/sysRole/addRoleMenu', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4151', 'p', 'role_10', '/api/sysRole/dataScope', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4140', 'p', 'role_10', '/api/sysRole/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4166', 'p', 'role_10', '/api/sysRole/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4130', 'p', 'role_10', '/api/sysRole/getRoles', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4132', 'p', 'role_10', '/api/sysRole/getUserPermission/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4163', 'p', 'role_10', '/api/sysTenant/*', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4142', 'p', 'role_10', '/api/sysTenant/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4180', 'p', 'role_10', '/api/sysTenant/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4157', 'p', 'role_10', '/api/sysTenant/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4173', 'p', 'role_10', '/api/sysTenant/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4164', 'p', 'role_10', '/api/sysUserTenant/batchAdd', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4169', 'p', 'role_10', '/api/sysUserTenant/batchDelete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4149', 'p', 'role_10', '/api/sysUserTenant/get', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4182', 'p', 'role_10', '/api/sysUserTenant/getRolesAll', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4152', 'p', 'role_10', '/api/sysUserTenant/getUserRoleIDs', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4165', 'p', 'role_10', '/api/sysUserTenant/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4129', 'p', 'role_10', '/api/sysUserTenant/setUserRoles', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4181', 'p', 'role_10', '/api/sysUserTenant/userListAll', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4127', 'p', 'role_10', '/api/users/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4159', 'p', 'role_10', '/api/users/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4160', 'p', 'role_10', '/api/users/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4178', 'p', 'role_10', '/api/users/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4143', 'p', 'role_10', '/api/users/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4170', 'p', 'role_10', '/api/users/logout', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4183', 'p', 'role_10', '/api/users/profile', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4138', 'p', 'role_10', '/api/users/updateAccount', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4171', 'p', 'role_10', '/api/users/uploadAvatar', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4288', 'p', 'role_2', '/api/config/get', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4273', 'p', 'role_2', '/api/config/update', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4281', 'p', 'role_2', '/api/config/viewCache', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4309', 'p', 'role_2', '/api/plugins/example/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4282', 'p', 'role_2', '/api/plugins/example/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4274', 'p', 'role_2', '/api/plugins/example/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4296', 'p', 'role_2', '/api/plugins/example/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4289', 'p', 'role_2', '/api/plugins/example/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4326', 'p', 'role_2', '/api/sysAffix/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4308', 'p', 'role_2', '/api/sysAffix/download/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4312', 'p', 'role_2', '/api/sysAffix/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4327', 'p', 'role_2', '/api/sysAffix/updateName', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4294', 'p', 'role_2', '/api/sysAffix/upload', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4318', 'p', 'role_2', '/api/sysApi/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4305', 'p', 'role_2', '/api/sysApi/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4284', 'p', 'role_2', '/api/sysApi/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4283', 'p', 'role_2', '/api/sysApi/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4314', 'p', 'role_2', '/api/sysApi/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4311', 'p', 'role_2', '/api/sysDepartment/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4307', 'p', 'role_2', '/api/sysDepartment/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4306', 'p', 'role_2', '/api/sysDepartment/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4313', 'p', 'role_2', '/api/sysDepartment/getDivision', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4286', 'p', 'role_2', '/api/sysDict/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4287', 'p', 'role_2', '/api/sysDict/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4265', 'p', 'role_2', '/api/sysDict/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4301', 'p', 'role_2', '/api/sysDict/getAllDicts', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4263', 'p', 'role_2', '/api/sysDict/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4324', 'p', 'role_2', '/api/sysDictItem/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4325', 'p', 'role_2', '/api/sysDictItem/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4280', 'p', 'role_2', '/api/sysDictItem/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4293', 'p', 'role_2', '/api/sysDictItem/getByDictId/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4268', 'p', 'role_2', '/api/sysMenu/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4272', 'p', 'role_2', '/api/sysMenu/apis/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4303', 'p', 'role_2', '/api/sysMenu/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4285', 'p', 'role_2', '/api/sysMenu/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4267', 'p', 'role_2', '/api/sysMenu/export', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4323', 'p', 'role_2', '/api/sysMenu/getMenuList', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4299', 'p', 'role_2', '/api/sysMenu/getRouters', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4276', 'p', 'role_2', '/api/sysMenu/import', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4304', 'p', 'role_2', '/api/sysMenu/setApis', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4290', 'p', 'role_2', '/api/sysOperationLog/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4275', 'p', 'role_2', '/api/sysOperationLog/export', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4278', 'p', 'role_2', '/api/sysOperationLog/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4317', 'p', 'role_2', '/api/sysRole/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4279', 'p', 'role_2', '/api/sysRole/addRoleMenu', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4266', 'p', 'role_2', '/api/sysRole/dataScope', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4264', 'p', 'role_2', '/api/sysRole/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4292', 'p', 'role_2', '/api/sysRole/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4271', 'p', 'role_2', '/api/sysRole/getRoles', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4330', 'p', 'role_2', '/api/sysRole/getUserPermission/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4295', 'p', 'role_2', '/api/sysTenant/*', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4310', 'p', 'role_2', '/api/sysTenant/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4329', 'p', 'role_2', '/api/sysTenant/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4331', 'p', 'role_2', '/api/sysTenant/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4328', 'p', 'role_2', '/api/sysTenant/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4321', 'p', 'role_2', '/api/sysUserTenant/batchAdd', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4333', 'p', 'role_2', '/api/sysUserTenant/batchDelete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4332', 'p', 'role_2', '/api/sysUserTenant/get', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4269', 'p', 'role_2', '/api/sysUserTenant/getRolesAll', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4300', 'p', 'role_2', '/api/sysUserTenant/getUserRoleIDs', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4297', 'p', 'role_2', '/api/sysUserTenant/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4298', 'p', 'role_2', '/api/sysUserTenant/setUserRoles', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4334', 'p', 'role_2', '/api/sysUserTenant/userListAll', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4291', 'p', 'role_2', '/api/users/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4315', 'p', 'role_2', '/api/users/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4302', 'p', 'role_2', '/api/users/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4316', 'p', 'role_2', '/api/users/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4277', 'p', 'role_2', '/api/users/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4270', 'p', 'role_2', '/api/users/logout', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4319', 'p', 'role_2', '/api/users/profile', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4320', 'p', 'role_2', '/api/users/updateAccount', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4322', 'p', 'role_2', '/api/users/uploadAvatar', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2966', 'p', 'role_4', '/api/sysAffix/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2971', 'p', 'role_4', '/api/sysDict/getAllDicts', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2970', 'p', 'role_4', '/api/sysMenu/getRouters', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2969', 'p', 'role_4', '/api/users/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2967', 'p', 'role_4', '/api/users/logout', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2968', 'p', 'role_4', '/api/users/profile', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2965', 'p', 'role_4', '/api/users/uploadAvatar', 'POST', '*', '', '');

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
  `sort` int(11) DEFAULT '0' COMMENT '排序',
  `describe` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '描述',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) unsigned DEFAULT NULL,
  `tenant_id` int(11) unsigned DEFAULT '0' COMMENT '租户ID字段',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of sys_department
-- ----------------------------
INSERT INTO `sys_department` VALUES ('1', '0', '总部', '1', '张明', '13800000001', 'headquarters@company.com', '1', '公司总部管理部门', '2023-01-15 09:00:00', '2025-10-31 17:05:24', null, '1', '0');

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
INSERT INTO `sys_dict` VALUES ('1', '性别', 'gender', '1', '这是一个性别字典', '2024-07-01 10:00:00', null, null, '1');
INSERT INTO `sys_dict` VALUES ('2', '状态', 'status', '1', '状态字段可以用这个', '2024-07-01 10:00:00', null, null, '1');
INSERT INTO `sys_dict` VALUES ('3', '岗位', 'post', '1', '岗位字段', '2024-07-01 10:00:00', null, null, '1');
INSERT INTO `sys_dict` VALUES ('4', '任务状态', 'taskStatus', '1', '任务状态字段可以用它', '2024-07-01 10:00:00', null, null, '1');
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
  `sort` int(11) DEFAULT '0' COMMENT '排序字段',
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
) ENGINE=InnoDB AUTO_INCREMENT=140265 DEFAULT CHARSET=utf8mb4 COMMENT='系统菜单路由表';

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES ('1', '0', '/home', 'home', null, 'home/home', 'home', '0', '0', '0', '0', '1', '', '0', 'home', '', '0', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, '1');
INSERT INTO `sys_menu` VALUES ('10', '0', '/system', 'system', null, null, 'system', '0', '0', '0', '1', '0', '', '0', 'set', '', '0', '1', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, '1');
INSERT INTO `sys_menu` VALUES ('1001', '10', '/system/account', 'account', '', 'system/account/account', 'account', '0', '0', '0', '1', '0', '', '0', '', 'IconUser', '0', '2', '0', '', '2025-08-27 09:09:44', '2025-10-11 15:37:41', null, '1');
INSERT INTO `sys_menu` VALUES ('1002', '10', '/system/role', 'role', '', 'system/role/role', 'role', '0', '0', '0', '1', '0', '', '0', '', 'IconUserGroup', '0', '2', '0', '', '2025-08-27 09:09:44', '2025-10-11 16:16:08', null, '1');
INSERT INTO `sys_menu` VALUES ('1003', '10', '/system/menu', 'menu', null, 'system/menu/menu', 'menu', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '0', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, '1');
INSERT INTO `sys_menu` VALUES ('1004', '10', '/system/division', 'division', '', 'system/division/division', 'division', '0', '0', '0', '1', '0', '', '0', '', 'IconMindMapping', '0', '2', '0', '', '2025-08-27 09:09:44', '2025-10-11 16:23:14', null, '1');
INSERT INTO `sys_menu` VALUES ('1005', '10', '/system/dictionary', 'dictionary', '', 'system/dictionary/dictionary', 'dictionary', '0', '0', '0', '1', '0', '', '0', '', 'IconBook', '0', '2', '0', '', '2025-08-27 09:09:44', '2025-10-11 16:23:47', null, '1');
INSERT INTO `sys_menu` VALUES ('1006', '10', '/system/log', 'log', '', 'system/log/log', 'log', '0', '0', '0', '1', '0', '', '0', '', 'IconCommon', '0', '2', '0', '', '2025-08-27 09:09:44', '2025-10-20 17:14:19', null, '1');
INSERT INTO `sys_menu` VALUES ('1007', '10', '/system/userinfo', 'userinfo', '', 'system/userinfo/userinfo', 'userinfo', '0', '1', '0', '1', '0', '', '0', '', 'icon-menu', '0', '2', '0', '', '2025-08-27 09:09:44', '2025-09-17 11:19:11', null, '1');
INSERT INTO `sys_menu` VALUES ('140213', '10', '/system/api', 'SystemApi', '', 'system/sysapi/sysapi', 'api-management', '0', '0', '0', '1', '0', '', '0', '', 'IconFile', '0', '2', '0', '', '2025-09-03 10:53:57', '2025-10-16 08:53:42', null, '1');
INSERT INTO `sys_menu` VALUES ('140214', '1001', '', '', '', '', '新增', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:account:add', '2025-09-03 16:11:58', '2025-09-03 16:11:58', null, '1');
INSERT INTO `sys_menu` VALUES ('140215', '1001', '', '', '', '', '编辑', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:account:edit', '2025-09-03 17:11:24', '2025-09-03 17:11:24', null, '1');
INSERT INTO `sys_menu` VALUES ('140216', '1001', '', '', '', '', '删除', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:account:delete', '2025-09-03 17:12:22', '2025-09-03 17:12:22', null, '1');
INSERT INTO `sys_menu` VALUES ('140218', '1002', '', '', '', '', '新增', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:role:add', '2025-09-04 16:43:54', '2025-09-04 16:43:54', null, '1');
INSERT INTO `sys_menu` VALUES ('140219', '1002', '', '', '', '', '编辑', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:role:edit', '2025-09-04 16:47:15', '2025-09-04 16:47:15', null, '1');
INSERT INTO `sys_menu` VALUES ('140220', '1002', '', '', '', '', '删除', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:role:delete', '2025-09-04 16:50:19', '2025-09-04 16:50:19', null, '1');
INSERT INTO `sys_menu` VALUES ('140221', '1002', '', '', '', '', '分配权限', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:role:addRoleMenu', '2025-09-04 16:53:09', '2025-09-04 16:53:09', null, '1');
INSERT INTO `sys_menu` VALUES ('140222', '1003', '', '', '', '', '新增', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:menu:add', '2025-09-04 17:07:16', '2025-09-04 17:07:16', null, '1');
INSERT INTO `sys_menu` VALUES ('140223', '1003', '', '', '', '', '编辑', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:menu:edit', '2025-09-04 17:11:51', '2025-09-04 17:11:51', null, '1');
INSERT INTO `sys_menu` VALUES ('140224', '1003', '', '', '', '', '删除', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:menu:delete', '2025-09-04 17:12:24', '2025-09-04 17:12:24', null, '1');
INSERT INTO `sys_menu` VALUES ('140225', '1003', '', '', '', '', '分配权限', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:menu:setMenuApis', '2025-09-04 17:20:09', '2025-09-04 17:20:09', null, '1');
INSERT INTO `sys_menu` VALUES ('140226', '140213', '', '', '', '', '新增', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:api:add', '2025-09-04 17:30:56', '2025-09-04 17:30:56', null, '1');
INSERT INTO `sys_menu` VALUES ('140227', '140213', '', '', '', '', '编辑', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:api:edit', '2025-09-04 17:31:20', '2025-09-04 17:31:20', null, '1');
INSERT INTO `sys_menu` VALUES ('140228', '140213', '', '', '', '', '删除', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:api:delete', '2025-09-04 17:31:38', '2025-09-04 17:31:38', null, '1');
INSERT INTO `sys_menu` VALUES ('140229', '1004', '', '', '', '', '新增部门', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:division:add', '2025-09-12 14:50:55', '2025-09-12 14:50:55', null, '1');
INSERT INTO `sys_menu` VALUES ('140230', '1004', '', '', '', '', '编辑部门', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:division:edit', '2025-09-12 14:51:17', '2025-09-12 14:51:17', null, '1');
INSERT INTO `sys_menu` VALUES ('140231', '1004', '', '', '', '', '删除部门', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:division:delete', '2025-09-12 14:51:51', '2025-09-12 14:51:51', null, '1');
INSERT INTO `sys_menu` VALUES ('140232', '1005', '', '', '', '', '新增', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:dict:add', '2025-09-16 16:38:06', '2025-09-16 16:38:06', null, '1');
INSERT INTO `sys_menu` VALUES ('140233', '1005', '', '', '', '', '编辑', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:dict:edit', '2025-09-16 16:39:58', '2025-09-16 16:39:58', null, '1');
INSERT INTO `sys_menu` VALUES ('140234', '1005', '', '', '', '', '删除', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:dict:delete', '2025-09-16 16:40:19', '2025-09-16 16:40:19', null, '1');
INSERT INTO `sys_menu` VALUES ('140235', '1005', '', '', '', '', '字典项管理', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:dictitem:list', '2025-09-16 17:09:58', '2025-09-16 17:31:35', null, '1');
INSERT INTO `sys_menu` VALUES ('140236', '1005', '', '', '', '', '新增字典项', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:dictitem:add', '2025-09-16 17:32:06', '2025-09-16 17:32:06', null, '1');
INSERT INTO `sys_menu` VALUES ('140237', '1005', '', '', '', '', '编辑字典项', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:dictitem:edit', '2025-09-16 17:33:16', '2025-09-16 17:33:16', null, '1');
INSERT INTO `sys_menu` VALUES ('140238', '1005', '', '', '', '', '删除字典项', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:dictitem:delete', '2025-09-16 17:33:41', '2025-09-16 17:33:41', null, '1');
INSERT INTO `sys_menu` VALUES ('140239', '10', '/system/affix', 'SystemAffix', '', 'system/affix/affix', 'file-manager', '0', '0', '0', '1', '0', '', '0', '', 'IconFolder', '0', '2', '0', '', '2025-09-25 15:17:00', '2025-10-15 18:14:16', null, '1');
INSERT INTO `sys_menu` VALUES ('140240', '140239', '', '', '', '', '文件上传', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:affix:upload', '2025-09-25 15:45:29', '2025-09-25 15:46:29', null, '1');
INSERT INTO `sys_menu` VALUES ('140241', '140239', '', '', '', '', '删除文件', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:affix:delete', '2025-09-25 15:46:52', '2025-09-25 15:46:52', null, '1');
INSERT INTO `sys_menu` VALUES ('140242', '140239', '', '', '', '', '修改文件名', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:affix:updateName', '2025-09-25 15:47:41', '2025-09-25 15:47:41', null, '1');
INSERT INTO `sys_menu` VALUES ('140243', '140239', '', '', '', '', '下载文件', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:affix:download', '2025-09-25 15:48:56', '2025-09-25 15:48:56', null, '1');
INSERT INTO `sys_menu` VALUES ('140244', '1002', '', '', '', '', '数据权限', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:role:dataScope', '2025-09-26 17:07:16', '2025-09-26 17:07:16', null, '1');
INSERT INTO `sys_menu` VALUES ('140245', '10', '/system/sysconfig', 'SystemSysconfig', '', 'system/sysconfig/sysconfig', 'system-config', '0', '0', '0', '1', '0', '', '0', '', 'IconSettings', '0', '2', '0', '', '2025-10-09 16:15:21', '2025-10-15 18:10:54', null, '1');
INSERT INTO `sys_menu` VALUES ('140246', '140245', '', '', '', '', '修改系统配置', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:config:update', '2025-10-09 16:24:33', '2025-10-09 16:24:33', null, '1');
INSERT INTO `sys_menu` VALUES ('140247', '0', '/demo', 'Demo', '', '', 'plugin-example', '0', '0', '0', '1', '0', '', '0', 'more', '', '0', '1', '0', '', '2025-10-13 14:38:38', '2025-10-16 08:55:06', null, '1');
INSERT INTO `sys_menu` VALUES ('140248', '140247', '/plugins/example', 'PluginsExample', '', 'plugins/example/views/examplelist', 'plugin-example', '0', '0', '0', '1', '0', '', '0', '', 'IconMenu', '0', '2', '0', '', '2025-10-13 15:19:20', '2025-10-16 08:55:19', null, '1');
INSERT INTO `sys_menu` VALUES ('140249', '140248', '', '', '', '', '新增', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'plugins:example:add', '2025-10-14 11:02:42', '2025-10-14 11:02:42', null, '1');
INSERT INTO `sys_menu` VALUES ('140250', '140248', '', '', '', '', '编辑', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'plugins:example:edit', '2025-10-14 11:03:08', '2025-10-14 11:03:08', null, '1');
INSERT INTO `sys_menu` VALUES ('140251', '140248', '', '', '', '', '删除', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'plugins:example:delete', '2025-10-14 11:03:25', '2025-10-14 11:03:25', null, '1');
INSERT INTO `sys_menu` VALUES ('140252', '1007', '', '', '', '', '修改密码、手机号等', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:userinfo:updateAccount', '2025-10-17 11:12:56', '2025-10-17 11:12:56', null, '1');
INSERT INTO `sys_menu` VALUES ('140253', '1001', '', '', '', '', '用户详情', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:account:details', '2025-10-17 11:21:06', '2025-10-17 11:21:06', '2025-10-31 16:54:22', '1');
INSERT INTO `sys_menu` VALUES ('140254', '140239', '', '', '', '', '复制链接', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:affix:copy', '2025-10-17 11:38:09', '2025-10-17 11:38:09', null, '1');
INSERT INTO `sys_menu` VALUES ('140255', '1006', '', '', '', '', '导出', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:log:export', '2025-10-20 10:16:51', '2025-10-20 10:16:51', null, '1');
INSERT INTO `sys_menu` VALUES ('140256', '1006', '', '', '', '', '删除', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:log:delete', '2025-10-20 10:17:19', '2025-10-20 10:17:19', null, '1');
INSERT INTO `sys_menu` VALUES ('140257', '1003', '', '', '', '', '导出', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:menu:export', '2025-10-20 17:18:01', '2025-10-20 17:18:13', null, '1');
INSERT INTO `sys_menu` VALUES ('140258', '1003', '', '', '', '', '导入', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:menu:import', '2025-10-21 11:29:45', '2025-10-21 11:29:45', null, '1');
INSERT INTO `sys_menu` VALUES ('140259', '10', '/system/systenant', 'SystemSystenant', '', 'system/tenant/tenant', 'tenant', '0', '0', '0', '1', '0', '', '0', '', 'IconTags', '0', '2', '0', '', '2025-10-24 09:11:32', '2025-10-24 09:20:59', null, '1');
INSERT INTO `sys_menu` VALUES ('140260', '140259', '', '', '', '', '新增租户', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:tenant:add', '2025-10-24 09:14:25', '2025-10-24 09:14:25', null, '1');
INSERT INTO `sys_menu` VALUES ('140261', '140259', '', '', '', '', '修改租户', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:tenant:edit', '2025-10-24 09:14:50', '2025-10-24 09:14:50', null, '1');
INSERT INTO `sys_menu` VALUES ('140262', '140259', '', '', '', '', '删除租户', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:tenant:delete', '2025-10-24 09:15:07', '2025-10-24 09:15:07', null, '1');
INSERT INTO `sys_menu` VALUES ('140263', '140259', '', '', '', '', '分配用户', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:tenant:assignUser', '2025-10-27 18:03:07', '2025-10-27 18:03:07', null, '1');
INSERT INTO `sys_menu` VALUES ('140264', '1007', '', '', '', '', '修改用户基本信息', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:userinfo:updateBasicInfo', '2025-10-31 09:26:42', '2025-10-31 09:26:42', null, '1');

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
INSERT INTO `sys_menu_api` VALUES ('10', '5');
INSERT INTO `sys_menu_api` VALUES ('10', '6');
INSERT INTO `sys_menu_api` VALUES ('10', '7');
INSERT INTO `sys_menu_api` VALUES ('10', '12');
INSERT INTO `sys_menu_api` VALUES ('10', '27');
INSERT INTO `sys_menu_api` VALUES ('10', '54');
INSERT INTO `sys_menu_api` VALUES ('1001', '8');
INSERT INTO `sys_menu_api` VALUES ('1001', '18');
INSERT INTO `sys_menu_api` VALUES ('1001', '19');
INSERT INTO `sys_menu_api` VALUES ('1002', '19');
INSERT INTO `sys_menu_api` VALUES ('1003', '13');
INSERT INTO `sys_menu_api` VALUES ('1004', '18');
INSERT INTO `sys_menu_api` VALUES ('1005', '41');
INSERT INTO `sys_menu_api` VALUES ('1006', '70');
INSERT INTO `sys_menu_api` VALUES ('1007', '6');
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
INSERT INTO `sys_menu_api` VALUES ('140245', '62');
INSERT INTO `sys_menu_api` VALUES ('140245', '64');
INSERT INTO `sys_menu_api` VALUES ('140246', '63');
INSERT INTO `sys_menu_api` VALUES ('140248', '65');
INSERT INTO `sys_menu_api` VALUES ('140248', '69');
INSERT INTO `sys_menu_api` VALUES ('140249', '66');
INSERT INTO `sys_menu_api` VALUES ('140250', '67');
INSERT INTO `sys_menu_api` VALUES ('140251', '68');
INSERT INTO `sys_menu_api` VALUES ('140252', '53');
INSERT INTO `sys_menu_api` VALUES ('140254', '60');
INSERT INTO `sys_menu_api` VALUES ('140255', '73');
INSERT INTO `sys_menu_api` VALUES ('140256', '72');
INSERT INTO `sys_menu_api` VALUES ('140257', '74');
INSERT INTO `sys_menu_api` VALUES ('140258', '75');
INSERT INTO `sys_menu_api` VALUES ('140259', '76');
INSERT INTO `sys_menu_api` VALUES ('140260', '78');
INSERT INTO `sys_menu_api` VALUES ('140261', '77');
INSERT INTO `sys_menu_api` VALUES ('140261', '79');
INSERT INTO `sys_menu_api` VALUES ('140262', '80');
INSERT INTO `sys_menu_api` VALUES ('140263', '81');
INSERT INTO `sys_menu_api` VALUES ('140263', '82');
INSERT INTO `sys_menu_api` VALUES ('140263', '83');
INSERT INTO `sys_menu_api` VALUES ('140263', '84');
INSERT INTO `sys_menu_api` VALUES ('140263', '85');
INSERT INTO `sys_menu_api` VALUES ('140263', '86');
INSERT INTO `sys_menu_api` VALUES ('140263', '87');
INSERT INTO `sys_menu_api` VALUES ('140263', '88');
INSERT INTO `sys_menu_api` VALUES ('140264', '89');

-- ----------------------------
-- Table structure for sys_operation_logs
-- ----------------------------
DROP TABLE IF EXISTS `sys_operation_logs`;
CREATE TABLE `sys_operation_logs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL COMMENT '操作用户ID',
  `username` varchar(50) DEFAULT NULL COMMENT '操作用户名',
  `module` varchar(100) DEFAULT NULL COMMENT '操作模块',
  `operation` varchar(100) DEFAULT NULL COMMENT '操作类型',
  `method` varchar(10) DEFAULT NULL COMMENT '请求方法',
  `path` varchar(500) DEFAULT NULL COMMENT '请求路径',
  `ip` varchar(50) DEFAULT NULL COMMENT '客户端IP',
  `user_agent` varchar(500) DEFAULT NULL COMMENT '用户代理',
  `request_data` text COMMENT '请求参数',
  `response_data` text COMMENT '响应数据',
  `status_code` int(11) DEFAULT NULL COMMENT '响应状态码',
  `duration` bigint(20) DEFAULT NULL COMMENT '操作耗时(毫秒)',
  `error_msg` text COMMENT '错误信息',
  `location` varchar(100) DEFAULT NULL COMMENT '操作地点',
  `tenant_id` int(11) unsigned DEFAULT '0' COMMENT '租户ID字段',
  PRIMARY KEY (`id`),
  KEY `idx_sys_operation_logs_deleted_at` (`deleted_at`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1477 DEFAULT CHARSET=utf8mb4 COMMENT='系统操作日志表';

-- ----------------------------
-- Records of sys_operation_logs
-- ----------------------------
INSERT INTO `sys_operation_logs` VALUES ('1459', '2025-10-31 18:05:18.000', '2025-10-31 18:05:18.000', null, '1', 'admin', '用户管理', 'create', 'POST', '/api/users/logout', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '21', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1460', '2025-10-31 18:05:39.000', '2025-10-31 18:05:39.000', null, '0', 'admin', '其他', 'login', 'POST', '/api/login', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"captchaId\":\"Oe8hfFkY1D7aDzAraq2t\",\"captchaValue\":null,\"password\":\"***\",\"tenantCode\":\"\",\"username\":\"admin\"}', '', '200', '101', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1461', '2025-10-31 18:05:39.000', '2025-10-31 18:05:39.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '11', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1462', '2025-10-31 18:05:39.000', '2025-10-31 18:05:39.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '6', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1463', '2025-10-31 18:05:39.000', '2025-10-31 18:05:39.000', null, '1', 'admin', '字典管理', 'query', 'GET', '/api/sysDict/getAllDicts', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '21', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1464', '2025-10-31 18:05:41.000', '2025-10-31 18:05:41.000', null, '1', 'admin', '部门管理', 'query', 'GET', '/api/sysDepartment/getDivision', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1465', '2025-10-31 18:05:41.000', '2025-10-31 18:05:41.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getRoles', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '10', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1466', '2025-10-31 18:05:41.000', '2025-10-31 18:05:41.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '17', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1467', '2025-10-31 18:05:42.000', '2025-10-31 18:05:42.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getRoles', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1468', '2025-10-31 18:05:42.000', '2025-10-31 18:05:42.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '10', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1469', '2025-10-31 18:05:44.000', '2025-10-31 18:05:44.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '16', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1470', '2025-10-31 18:05:46.000', '2025-10-31 18:05:46.000', null, '1', 'admin', '部门管理', 'query', 'GET', '/api/sysDepartment/getDivision', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1471', '2025-10-31 18:05:48.000', '2025-10-31 18:05:48.000', null, '1', 'admin', '字典管理', 'query', 'GET', '/api/sysDict/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1472', '2025-10-31 18:05:49.000', '2025-10-31 18:05:49.000', null, '1', 'admin', '操作日志管理', 'query', 'GET', '/api/sysOperationLog/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '5', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1473', '2025-10-31 18:05:51.000', '2025-10-31 18:05:51.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1474', '2025-10-31 18:05:52.000', '2025-10-31 18:05:52.000', null, '1', 'admin', '文件管理', 'query', 'GET', '/api/sysAffix/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '6', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1475', '2025-10-31 18:05:56.000', '2025-10-31 18:05:56.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/sysTenant/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '5', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1476', '2025-10-31 18:05:58.000', '2025-10-31 18:05:58.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '7', '', '', '0');

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
  `tenant_id` int(11) unsigned DEFAULT '0' COMMENT '租户ID字段',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES ('1', '系统管理员', '1', '1', '最高权限管理员角色', '0', '2025-09-01 17:32:12', '2025-09-30 15:53:24', null, '1', '1', '', '0');
INSERT INTO `sys_role` VALUES ('2', '演示', '1', '1', '', '0', '2025-10-14 15:12:09', '2025-10-17 15:34:47', null, '1', '0', '', '0');

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
INSERT INTO `sys_role_menu` VALUES ('1', '10');
INSERT INTO `sys_role_menu` VALUES ('1', '1001');
INSERT INTO `sys_role_menu` VALUES ('1', '1002');
INSERT INTO `sys_role_menu` VALUES ('1', '1003');
INSERT INTO `sys_role_menu` VALUES ('1', '1004');
INSERT INTO `sys_role_menu` VALUES ('1', '1005');
INSERT INTO `sys_role_menu` VALUES ('1', '1006');
INSERT INTO `sys_role_menu` VALUES ('1', '1007');
INSERT INTO `sys_role_menu` VALUES ('1', '140213');
INSERT INTO `sys_role_menu` VALUES ('1', '140214');
INSERT INTO `sys_role_menu` VALUES ('1', '140215');
INSERT INTO `sys_role_menu` VALUES ('1', '140216');
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
INSERT INTO `sys_role_menu` VALUES ('1', '140245');
INSERT INTO `sys_role_menu` VALUES ('1', '140246');
INSERT INTO `sys_role_menu` VALUES ('1', '140247');
INSERT INTO `sys_role_menu` VALUES ('1', '140248');
INSERT INTO `sys_role_menu` VALUES ('1', '140249');
INSERT INTO `sys_role_menu` VALUES ('1', '140250');
INSERT INTO `sys_role_menu` VALUES ('1', '140251');
INSERT INTO `sys_role_menu` VALUES ('1', '140252');
INSERT INTO `sys_role_menu` VALUES ('1', '140254');
INSERT INTO `sys_role_menu` VALUES ('1', '140255');
INSERT INTO `sys_role_menu` VALUES ('1', '140256');
INSERT INTO `sys_role_menu` VALUES ('1', '140257');
INSERT INTO `sys_role_menu` VALUES ('1', '140258');
INSERT INTO `sys_role_menu` VALUES ('1', '140259');
INSERT INTO `sys_role_menu` VALUES ('1', '140260');
INSERT INTO `sys_role_menu` VALUES ('1', '140261');
INSERT INTO `sys_role_menu` VALUES ('1', '140262');
INSERT INTO `sys_role_menu` VALUES ('1', '140263');
INSERT INTO `sys_role_menu` VALUES ('1', '140264');
INSERT INTO `sys_role_menu` VALUES ('2', '1');
INSERT INTO `sys_role_menu` VALUES ('2', '10');
INSERT INTO `sys_role_menu` VALUES ('2', '1001');
INSERT INTO `sys_role_menu` VALUES ('2', '1002');
INSERT INTO `sys_role_menu` VALUES ('2', '1003');
INSERT INTO `sys_role_menu` VALUES ('2', '1004');
INSERT INTO `sys_role_menu` VALUES ('2', '1005');
INSERT INTO `sys_role_menu` VALUES ('2', '1006');
INSERT INTO `sys_role_menu` VALUES ('2', '1007');
INSERT INTO `sys_role_menu` VALUES ('2', '140213');
INSERT INTO `sys_role_menu` VALUES ('2', '140214');
INSERT INTO `sys_role_menu` VALUES ('2', '140215');
INSERT INTO `sys_role_menu` VALUES ('2', '140216');
INSERT INTO `sys_role_menu` VALUES ('2', '140218');
INSERT INTO `sys_role_menu` VALUES ('2', '140219');
INSERT INTO `sys_role_menu` VALUES ('2', '140220');
INSERT INTO `sys_role_menu` VALUES ('2', '140221');
INSERT INTO `sys_role_menu` VALUES ('2', '140222');
INSERT INTO `sys_role_menu` VALUES ('2', '140223');
INSERT INTO `sys_role_menu` VALUES ('2', '140224');
INSERT INTO `sys_role_menu` VALUES ('2', '140225');
INSERT INTO `sys_role_menu` VALUES ('2', '140226');
INSERT INTO `sys_role_menu` VALUES ('2', '140227');
INSERT INTO `sys_role_menu` VALUES ('2', '140228');
INSERT INTO `sys_role_menu` VALUES ('2', '140229');
INSERT INTO `sys_role_menu` VALUES ('2', '140230');
INSERT INTO `sys_role_menu` VALUES ('2', '140231');
INSERT INTO `sys_role_menu` VALUES ('2', '140232');
INSERT INTO `sys_role_menu` VALUES ('2', '140233');
INSERT INTO `sys_role_menu` VALUES ('2', '140234');
INSERT INTO `sys_role_menu` VALUES ('2', '140235');
INSERT INTO `sys_role_menu` VALUES ('2', '140236');
INSERT INTO `sys_role_menu` VALUES ('2', '140237');
INSERT INTO `sys_role_menu` VALUES ('2', '140238');
INSERT INTO `sys_role_menu` VALUES ('2', '140239');
INSERT INTO `sys_role_menu` VALUES ('2', '140240');
INSERT INTO `sys_role_menu` VALUES ('2', '140241');
INSERT INTO `sys_role_menu` VALUES ('2', '140242');
INSERT INTO `sys_role_menu` VALUES ('2', '140243');
INSERT INTO `sys_role_menu` VALUES ('2', '140244');
INSERT INTO `sys_role_menu` VALUES ('2', '140245');
INSERT INTO `sys_role_menu` VALUES ('2', '140246');
INSERT INTO `sys_role_menu` VALUES ('2', '140247');
INSERT INTO `sys_role_menu` VALUES ('2', '140248');
INSERT INTO `sys_role_menu` VALUES ('2', '140249');
INSERT INTO `sys_role_menu` VALUES ('2', '140250');
INSERT INTO `sys_role_menu` VALUES ('2', '140251');
INSERT INTO `sys_role_menu` VALUES ('2', '140252');
INSERT INTO `sys_role_menu` VALUES ('2', '140254');
INSERT INTO `sys_role_menu` VALUES ('2', '140255');
INSERT INTO `sys_role_menu` VALUES ('2', '140256');
INSERT INTO `sys_role_menu` VALUES ('2', '140257');
INSERT INTO `sys_role_menu` VALUES ('2', '140258');
INSERT INTO `sys_role_menu` VALUES ('2', '140259');
INSERT INTO `sys_role_menu` VALUES ('2', '140260');
INSERT INTO `sys_role_menu` VALUES ('2', '140261');
INSERT INTO `sys_role_menu` VALUES ('2', '140262');
INSERT INTO `sys_role_menu` VALUES ('2', '140263');

-- ----------------------------
-- Table structure for sys_tenants
-- ----------------------------
DROP TABLE IF EXISTS `sys_tenants`;
CREATE TABLE `sys_tenants` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '创建人',
  `name` varchar(100) NOT NULL COMMENT '租户名称',
  `code` varchar(50) NOT NULL COMMENT '租户编码',
  `description` varchar(500) DEFAULT NULL COMMENT '租户描述',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '状态 0停用 1启用',
  `domain` varchar(255) DEFAULT NULL COMMENT '租户域名',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `idx_sys_tenants_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of sys_tenants
-- ----------------------------

-- ----------------------------
-- Table structure for sys_users
-- ----------------------------
DROP TABLE IF EXISTS `sys_users`;
CREATE TABLE `sys_users` (
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
  `tenant_id` int(11) unsigned DEFAULT '0' COMMENT '租户ID字段',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of sys_users
-- ----------------------------
INSERT INTO `sys_users` VALUES ('1', 'admin', '$2a$10$0aS9FxWlOz/PXiqzsBr7huy.Dqdwucyb795qiWcA6fsn0Lu.GLA.C', 'admin@example.com', '1', '1', '18800000006', '1', '超级管理员6', '/public/uploads/2025-10-30/20251030_734fdce1-decb-4b60-a8a8-d7e57cf72846.jpeg', '超级管理员', '2025-08-18 14:55:05', '2025-10-31 16:32:27', null, '0', '0');
INSERT INTO `sys_users` VALUES ('4', 'demo', '$2a$10$yxq80jnZCRPn/hhQYUffheRnDopYjiq1AKGdgrg1oatLha7tc/.Qe', '', '1', '1', '', '1', '演示账号', '', '演示账号', '2025-10-17 15:38:37', '2025-10-31 16:32:34', null, '1', '0');

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
INSERT INTO `sys_user_role` VALUES ('4', '2');

-- ----------------------------
-- Table structure for sys_user_tenant
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_tenant`;
CREATE TABLE `sys_user_tenant` (
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
  `tenant_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '租户id',
  `is_default` tinyint(1) DEFAULT '0' COMMENT '是否默认租户',
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`user_id`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='用户及租户关联表';

-- ----------------------------
-- Records of sys_user_tenant
-- ----------------------------
