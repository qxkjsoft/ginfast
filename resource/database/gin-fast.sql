/*
Navicat MySQL Data Transfer

Source Server         : localhsot5.7
Source Server Version : 50726
Source Host           : localhost:3306
Source Database       : gin-fast

Target Server Type    : MYSQL
Target Server Version : 50726
File Encoding         : 65001

Date: 2025-10-17 15:48:42
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
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of sys_affix
-- ----------------------------
INSERT INTO `sys_affix` VALUES ('29', '网站图标', 'resource\\public\\uploads\\2025-10-11\\20251011_3b06f7c4-2abe-48ac-9630-8deb11ceda01.ico', '/public/uploads/2025-10-11/20251011_3b06f7c4-2abe-48ac-9630-8deb11ceda01.ico', '2462', 'image', '2025-10-11 17:01:27', '2025-10-11 17:50:10', null, '1', '.ico');
INSERT INTO `sys_affix` VALUES ('30', '网站log', 'resource\\public\\uploads\\2025-10-11\\20251011_45438318-e5ac-4fe0-8e64-beb3a81e71b8.svg', '/public/uploads/2025-10-11/20251011_45438318-e5ac-4fe0-8e64-beb3a81e71b8.svg', '9128', 'image', '2025-10-11 17:01:57', '2025-10-11 17:49:57', null, '1', '.svg');

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
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
INSERT INTO `sys_api` VALUES ('62', '读取系统配置', '/api/config/get', 'GET', '系统配置', '2025-10-09 16:21:29', '2025-10-09 16:21:29', null, '1');
INSERT INTO `sys_api` VALUES ('63', '修改系统配置', '/api/config/update', 'PUT', '系统配置', '2025-10-09 16:21:59', '2025-10-09 16:22:09', null, '1');
INSERT INTO `sys_api` VALUES ('64', '查看内存缓存', '/api/config/viewCache', 'GET', '系统配置', '2025-10-10 17:41:33', '2025-10-10 17:41:33', null, '1');
INSERT INTO `sys_api` VALUES ('65', '列表查询', '/api/plugins/example/list', 'GET', '插件示例', '2025-10-14 10:54:47', '2025-10-14 10:54:47', null, '1');
INSERT INTO `sys_api` VALUES ('66', '新增', '/api/plugins/example/add', 'POST', '插件示例', '2025-10-14 10:56:43', '2025-10-14 10:56:43', null, '1');
INSERT INTO `sys_api` VALUES ('67', '修改', '/api/plugins/example/edit', 'PUT', '插件示例', '2025-10-14 10:57:10', '2025-10-14 10:57:17', null, '1');
INSERT INTO `sys_api` VALUES ('68', '删除', '/api/plugins/example/delete', 'DELETE', '插件示例', '2025-10-14 10:58:03', '2025-10-14 10:58:03', null, '1');
INSERT INTO `sys_api` VALUES ('69', '查询单条数据', '/api/plugins/example/:id', 'GET', '插件示例', '2025-10-14 10:59:33', '2025-10-14 10:59:33', null, '1');

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
) ENGINE=InnoDB AUTO_INCREMENT=2205 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of sys_casbin_rule
-- ----------------------------
INSERT INTO `sys_casbin_rule` VALUES ('1290', 'g', 'user_1', 'role_1', '', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2204', 'g', 'user_4', 'role_2', '', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2186', 'p', 'role_1', '/api/config/get', 'GET', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2193', 'p', 'role_1', '/api/config/update', 'PUT', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2153', 'p', 'role_1', '/api/config/viewCache', 'GET', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2167', 'p', 'role_1', '/api/plugins/example/*', 'GET', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2168', 'p', 'role_1', '/api/plugins/example/add', 'POST', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2160', 'p', 'role_1', '/api/plugins/example/delete', 'DELETE', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2199', 'p', 'role_1', '/api/plugins/example/edit', 'PUT', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2175', 'p', 'role_1', '/api/plugins/example/list', 'GET', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2179', 'p', 'role_1', '/api/sysAffix/delete', 'DELETE', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2152', 'p', 'role_1', '/api/sysAffix/download/*', 'GET', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2151', 'p', 'role_1', '/api/sysAffix/list', 'GET', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2159', 'p', 'role_1', '/api/sysAffix/updateName', 'PUT', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2191', 'p', 'role_1', '/api/sysAffix/upload', 'POST', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2184', 'p', 'role_1', '/api/sysApi/*', 'GET', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2174', 'p', 'role_1', '/api/sysApi/add', 'POST', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2185', 'p', 'role_1', '/api/sysApi/delete', 'DELETE', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2203', 'p', 'role_1', '/api/sysApi/edit', 'PUT', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2170', 'p', 'role_1', '/api/sysApi/list', 'GET', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2176', 'p', 'role_1', '/api/sysDepartment/add', 'POST', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2189', 'p', 'role_1', '/api/sysDepartment/delete', 'DELETE', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2177', 'p', 'role_1', '/api/sysDepartment/edit', 'PUT', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2195', 'p', 'role_1', '/api/sysDepartment/getDivision', 'GET', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2190', 'p', 'role_1', '/api/sysDict/add', 'POST', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2197', 'p', 'role_1', '/api/sysDict/delete', 'DELETE', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2178', 'p', 'role_1', '/api/sysDict/edit', 'PUT', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2194', 'p', 'role_1', '/api/sysDict/getAllDicts', 'GET', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2201', 'p', 'role_1', '/api/sysDict/list', 'GET', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2158', 'p', 'role_1', '/api/sysDictItem/add', 'POST', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2166', 'p', 'role_1', '/api/sysDictItem/delete', 'DELETE', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2198', 'p', 'role_1', '/api/sysDictItem/edit', 'PUT', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2150', 'p', 'role_1', '/api/sysDictItem/getByDictId/*', 'GET', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2157', 'p', 'role_1', '/api/sysMenu/add', 'POST', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2172', 'p', 'role_1', '/api/sysMenu/apis/*', 'GET', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2196', 'p', 'role_1', '/api/sysMenu/delete', 'DELETE', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2171', 'p', 'role_1', '/api/sysMenu/edit', 'PUT', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2200', 'p', 'role_1', '/api/sysMenu/getMenuList', 'GET', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2169', 'p', 'role_1', '/api/sysMenu/getRouters', 'GET', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2173', 'p', 'role_1', '/api/sysMenu/setApis', 'POST', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2182', 'p', 'role_1', '/api/sysRole/add', 'POST', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2165', 'p', 'role_1', '/api/sysRole/addRoleMenu', 'POST', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2192', 'p', 'role_1', '/api/sysRole/dataScope', 'PUT', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2183', 'p', 'role_1', '/api/sysRole/delete', 'DELETE', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2156', 'p', 'role_1', '/api/sysRole/edit', 'PUT', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2163', 'p', 'role_1', '/api/sysRole/getRoles', 'GET', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2188', 'p', 'role_1', '/api/sysRole/getUserPermission/*', 'GET', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2155', 'p', 'role_1', '/api/users/*', 'GET', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2164', 'p', 'role_1', '/api/users/add', 'POST', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2202', 'p', 'role_1', '/api/users/delete', 'DELETE', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2187', 'p', 'role_1', '/api/users/edit', 'PUT', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2162', 'p', 'role_1', '/api/users/list', 'GET', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2161', 'p', 'role_1', '/api/users/logout', 'POST', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2154', 'p', 'role_1', '/api/users/profile', 'GET', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2180', 'p', 'role_1', '/api/users/updateAccount', 'PUT', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2181', 'p', 'role_1', '/api/users/uploadAvatar', 'POST', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2146', 'p', 'role_2', '/api/config/get', 'GET', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2134', 'p', 'role_2', '/api/config/viewCache', 'GET', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2147', 'p', 'role_2', '/api/plugins/example/*', 'GET', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2138', 'p', 'role_2', '/api/plugins/example/list', 'GET', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2133', 'p', 'role_2', '/api/sysAffix/list', 'GET', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2137', 'p', 'role_2', '/api/sysApi/list', 'GET', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2141', 'p', 'role_2', '/api/sysDepartment/getDivision', 'GET', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2149', 'p', 'role_2', '/api/sysDict/getAllDicts', 'GET', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2145', 'p', 'role_2', '/api/sysDict/list', 'GET', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2136', 'p', 'role_2', '/api/sysMenu/getMenuList', 'GET', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2139', 'p', 'role_2', '/api/sysMenu/getRouters', 'GET', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2142', 'p', 'role_2', '/api/sysRole/getRoles', 'GET', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2144', 'p', 'role_2', '/api/users/*', 'GET', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2140', 'p', 'role_2', '/api/users/list', 'GET', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2148', 'p', 'role_2', '/api/users/logout', 'POST', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2143', 'p', 'role_2', '/api/users/profile', 'GET', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('2135', 'p', 'role_2', '/api/users/uploadAvatar', 'POST', '', '', '');

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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of sys_department
-- ----------------------------
INSERT INTO `sys_department` VALUES ('1', '0', '总部', '1', '张明', '13800000001', 'headquarters@company.com', '1', '公司总部管理部门', '2023-01-15 09:00:00', '2025-10-14 16:09:36', null, '1');

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
) ENGINE=InnoDB AUTO_INCREMENT=140255 DEFAULT CHARSET=utf8mb4 COMMENT='系统菜单路由表';

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES ('1', '0', '/home', 'home', null, 'home/home', 'home', '0', '0', '0', '0', '1', '', '0', 'home', '', '1', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, '1');
INSERT INTO `sys_menu` VALUES ('10', '0', '/system', 'system', null, null, 'system', '0', '0', '0', '1', '0', '', '0', 'set', '', '10', '1', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, '1');
INSERT INTO `sys_menu` VALUES ('1001', '10', '/system/account', 'account', '', 'system/account/account', 'account', '0', '0', '0', '1', '0', '', '0', '', 'IconUser', '1', '2', '0', '', '2025-08-27 09:09:44', '2025-10-11 15:37:41', null, '1');
INSERT INTO `sys_menu` VALUES ('1002', '10', '/system/role', 'role', '', 'system/role/role', 'role', '0', '0', '0', '1', '0', '', '0', '', 'IconUserGroup', '2', '2', '0', '', '2025-08-27 09:09:44', '2025-10-11 16:16:08', null, '1');
INSERT INTO `sys_menu` VALUES ('1003', '10', '/system/menu', 'menu', null, 'system/menu/menu', 'menu', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '3', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, '1');
INSERT INTO `sys_menu` VALUES ('1004', '10', '/system/division', 'division', '', 'system/division/division', 'division', '0', '0', '0', '1', '0', '', '0', '', 'IconMindMapping', '4', '2', '0', '', '2025-08-27 09:09:44', '2025-10-11 16:23:14', null, '1');
INSERT INTO `sys_menu` VALUES ('1005', '10', '/system/dictionary', 'dictionary', '', 'system/dictionary/dictionary', 'dictionary', '0', '0', '0', '1', '0', '', '0', '', 'IconBook', '5', '2', '0', '', '2025-08-27 09:09:44', '2025-10-11 16:23:47', null, '1');
INSERT INTO `sys_menu` VALUES ('1006', '10', '/system/log', 'log', '', 'system/log/log', 'log', '0', '1', '0', '1', '0', '', '0', '', 'icon-menu', '6', '2', '0', '', '2025-08-27 09:09:44', '2025-10-17 15:33:56', null, '1');
INSERT INTO `sys_menu` VALUES ('1007', '10', '/system/userinfo', 'userinfo', '', 'system/userinfo/userinfo', 'userinfo', '0', '1', '0', '1', '0', '', '0', '', 'icon-menu', '7', '2', '0', '', '2025-08-27 09:09:44', '2025-09-17 11:19:11', null, '1');
INSERT INTO `sys_menu` VALUES ('140213', '10', '/system/api', 'SystemApi', '', 'system/sysapi/sysapi', 'api-management', '0', '0', '0', '1', '0', '', '0', '', 'IconFile', '4', '2', '0', '', '2025-09-03 10:53:57', '2025-10-16 08:53:42', null, '1');
INSERT INTO `sys_menu` VALUES ('140214', '1001', '', '', '', '', '新增', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:account:add', '2025-09-03 16:11:58', '2025-09-03 16:11:58', null, '1');
INSERT INTO `sys_menu` VALUES ('140215', '1001', '', '', '', '', '编辑', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:account:edit', '2025-09-03 17:11:24', '2025-09-03 17:11:24', null, '1');
INSERT INTO `sys_menu` VALUES ('140216', '1001', '', '', '', '', '删除', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:account:delete', '2025-09-03 17:12:22', '2025-09-03 17:12:22', null, '1');
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
INSERT INTO `sys_menu` VALUES ('140239', '10', '/system/affix', 'SystemAffix', '', 'system/affix/affix', 'file-manager', '0', '0', '0', '1', '0', '', '0', '', 'IconFolder', '1', '2', '0', '', '2025-09-25 15:17:00', '2025-10-15 18:14:16', null, '1');
INSERT INTO `sys_menu` VALUES ('140240', '140239', '', '', '', '', '文件上传', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:affix:upload', '2025-09-25 15:45:29', '2025-09-25 15:46:29', null, '1');
INSERT INTO `sys_menu` VALUES ('140241', '140239', '', '', '', '', '删除文件', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:affix:delete', '2025-09-25 15:46:52', '2025-09-25 15:46:52', null, '1');
INSERT INTO `sys_menu` VALUES ('140242', '140239', '', '', '', '', '修改文件名', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:affix:updateName', '2025-09-25 15:47:41', '2025-09-25 15:47:41', null, '1');
INSERT INTO `sys_menu` VALUES ('140243', '140239', '', '', '', '', '下载文件', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:affix:download', '2025-09-25 15:48:56', '2025-09-25 15:48:56', null, '1');
INSERT INTO `sys_menu` VALUES ('140244', '1002', '', '', '', '', '数据权限', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:role:dataScope', '2025-09-26 17:07:16', '2025-09-26 17:07:16', null, '1');
INSERT INTO `sys_menu` VALUES ('140245', '10', '/system/sysconfig', 'SystemSysconfig', '', 'system/sysconfig/sysconfig', 'system-config', '0', '0', '0', '1', '0', '', '0', '', 'IconSettings', '1', '2', '0', '', '2025-10-09 16:15:21', '2025-10-15 18:10:54', null, '1');
INSERT INTO `sys_menu` VALUES ('140246', '140245', '', '', '', '', '修改系统配置', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:config:update', '2025-10-09 16:24:33', '2025-10-09 16:24:33', null, '1');
INSERT INTO `sys_menu` VALUES ('140247', '0', '/demo', 'Demo', '', '', 'plugin-example', '0', '0', '0', '1', '0', '', '0', 'more', '', '999', '1', '0', '', '2025-10-13 14:38:38', '2025-10-16 08:55:06', null, '1');
INSERT INTO `sys_menu` VALUES ('140248', '140247', '/plugins/example', 'PluginsExample', '', 'plugins/example/views/examplelist', 'plugin-example', '0', '0', '0', '1', '0', '', '0', '', 'IconMenu', '1', '2', '0', '', '2025-10-13 15:19:20', '2025-10-16 08:55:19', null, '1');
INSERT INTO `sys_menu` VALUES ('140249', '140248', '', '', '', '', '新增', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'plugins:example:add', '2025-10-14 11:02:42', '2025-10-14 11:02:42', null, '1');
INSERT INTO `sys_menu` VALUES ('140250', '140248', '', '', '', '', '编辑', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'plugins:example:edit', '2025-10-14 11:03:08', '2025-10-14 11:03:08', null, '1');
INSERT INTO `sys_menu` VALUES ('140251', '140248', '', '', '', '', '删除', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'plugins:example:delete', '2025-10-14 11:03:25', '2025-10-14 11:03:25', null, '1');
INSERT INTO `sys_menu` VALUES ('140252', '1007', '', '', '', '', '修改密码、手机号等', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:userinfo:updateAccount', '2025-10-17 11:12:56', '2025-10-17 11:12:56', null, '1');
INSERT INTO `sys_menu` VALUES ('140253', '1001', '', '', '', '', '用户详情', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:account:details', '2025-10-17 11:21:06', '2025-10-17 11:21:06', null, '1');
INSERT INTO `sys_menu` VALUES ('140254', '140239', '', '', '', '', '复制链接', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:affix:copy', '2025-10-17 11:38:09', '2025-10-17 11:38:09', null, '1');

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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES ('1', '系统管理员', '1', '1', '最高权限管理员角色', '0', '2025-09-01 17:32:12', '2025-09-30 15:53:24', null, '1', '1', '');
INSERT INTO `sys_role` VALUES ('2', '演示', '1', '1', '', '0', '2025-10-14 15:12:09', '2025-10-17 15:34:47', null, '1', '0', '');

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
INSERT INTO `sys_role_menu` VALUES ('1', '140253');
INSERT INTO `sys_role_menu` VALUES ('1', '140254');
INSERT INTO `sys_role_menu` VALUES ('2', '1');
INSERT INTO `sys_role_menu` VALUES ('2', '10');
INSERT INTO `sys_role_menu` VALUES ('2', '1001');
INSERT INTO `sys_role_menu` VALUES ('2', '1002');
INSERT INTO `sys_role_menu` VALUES ('2', '1003');
INSERT INTO `sys_role_menu` VALUES ('2', '1004');
INSERT INTO `sys_role_menu` VALUES ('2', '1005');
INSERT INTO `sys_role_menu` VALUES ('2', '1007');
INSERT INTO `sys_role_menu` VALUES ('2', '140213');
INSERT INTO `sys_role_menu` VALUES ('2', '140239');
INSERT INTO `sys_role_menu` VALUES ('2', '140245');
INSERT INTO `sys_role_menu` VALUES ('2', '140247');
INSERT INTO `sys_role_menu` VALUES ('2', '140248');

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
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of sys_users
-- ----------------------------
INSERT INTO `sys_users` VALUES ('1', 'admin', '$2a$10$xtJ/FUMewwR2cb2gJ1/oJ.gEc30hDlejqVL4jrJlBfeVcK.I7MzWy', 'admin@example.com', '1', '1', '18800000006', '1', '超级管理员', '/public/uploads/2025-10-11/20251011_0a829459-2ae9-4308-b571-9b35aaed2738.jpg', '', '2025-08-18 14:55:05', '2025-10-11 17:46:24', null, '0');
INSERT INTO `sys_users` VALUES ('4', 'demo', '$2a$10$kofOK13ojtbIQDsXlgpNquQub8HY1QuDDrCaNMkSitJf25dMPHRZi', '', '1', '1', '', '1', '演示账号', '', '', '2025-10-17 15:38:37', '2025-10-17 15:38:37', null, '1');

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
