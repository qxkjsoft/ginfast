/*
Navicat MySQL Data Transfer

Source Server         : localhsot5.7
Source Server Version : 50726
Source Host           : localhost:3306
Source Database       : gin-fast-tenant

Target Server Type    : MYSQL
Target Server Version : 50726
File Encoding         : 65001

Date: 2026-04-09 17:24:03
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for demo_students
-- ----------------------------
DROP TABLE IF EXISTS `demo_students`;
CREATE TABLE `demo_students` (
  `student_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `student_name` varchar(50) COLLATE utf8_unicode_ci NOT NULL COMMENT '姓名',
  `age` int(11) NOT NULL DEFAULT '18' COMMENT '年龄',
  `gender` varchar(50) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '性别',
  `class_name` varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT '班级名称',
  `admission_date` datetime NOT NULL COMMENT '入学日期',
  `email` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT ' 邮箱',
  `phone` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '电话号码',
  `address` text COLLATE utf8_unicode_ci COMMENT '地址',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT '创建人',
  `tenant_id` int(11) unsigned DEFAULT '0' COMMENT '租户ID字段',
  PRIMARY KEY (`student_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='学员管理';

-- ----------------------------
-- Records of demo_students
-- ----------------------------

-- ----------------------------
-- Table structure for demo_teacher
-- ----------------------------
DROP TABLE IF EXISTS `demo_teacher`;
CREATE TABLE `demo_teacher` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(50) NOT NULL COMMENT '教师姓名',
  `employee_id` varchar(20) DEFAULT NULL COMMENT '工号',
  `gender` tinyint(1) DEFAULT '0' COMMENT '性别：0-未知 1-男 2-女',
  `phone` varchar(20) DEFAULT NULL COMMENT '手机号',
  `email` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `subject` varchar(50) DEFAULT NULL COMMENT '所教学科',
  `title` varchar(50) DEFAULT NULL COMMENT '职称',
  `status` tinyint(1) DEFAULT '1' COMMENT '状态：0-离职 1-在职',
  `hire_date` date DEFAULT NULL COMMENT '入职日期',
  `birth_date` date DEFAULT NULL COMMENT '出生日期',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  `created_by` int(11) unsigned DEFAULT '0' COMMENT '创建人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='教师表';

-- ----------------------------
-- Records of demo_teacher
-- ----------------------------

-- ----------------------------
-- Table structure for example
-- ----------------------------
DROP TABLE IF EXISTS `example`;
CREATE TABLE `example` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '名称',
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '描述',
  `created_at` datetime NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `tenant_id` int(11) unsigned DEFAULT '0' COMMENT '租户ID字段',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of example
-- ----------------------------
INSERT INTO `example` VALUES ('1', '项目管理系统', '用于管理项目进度和任务分配的系统', '2024-01-15 09:30:00', '2024-01-20 14:25:00', null, '1', '1');
INSERT INTO `example` VALUES ('2', '客户关系管理', '帮助企业维护客户关系的软件平台', '2024-01-16 10:15:00', '2024-01-22 11:40:00', null, '1', '1');
INSERT INTO `example` VALUES ('3', '财务分析工具', '提供财务报表和数据分析功能', '2024-01-17 14:20:00', '2024-01-25 16:30:00', null, '1', '1');
INSERT INTO `example` VALUES ('4', '库存管理系统', '实时跟踪和管理库存水平', '2024-01-18 08:45:00', '2024-01-26 09:15:00', null, '1', '1');
INSERT INTO `example` VALUES ('5', '人力资源平台', '员工信息管理和招聘流程优化', '2024-01-19 11:30:00', '2024-01-27 13:20:00', null, '1', '1');
INSERT INTO `example` VALUES ('6', '在线学习系统', '提供课程管理和在线学习功能', '2024-01-20 15:10:00', '2024-01-28 17:05:00', null, '1', '1');
INSERT INTO `example` VALUES ('7', '营销自动化', '自动化营销活动和客户跟进', '2024-01-21 09:00:00', '2024-01-29 10:45:00', null, '1', '1');
INSERT INTO `example` VALUES ('8', '数据可视化', '将数据转化为直观的图表和报告', '2024-01-22 13:25:00', '2024-01-30 15:30:00', null, '1', '1');
INSERT INTO `example` VALUES ('9', '移动应用开发', '跨平台移动应用开发框架', '2024-01-23 16:40:00', '2024-01-31 18:20:00', null, '1', '1');
INSERT INTO `example` VALUES ('10', '云存储服务', '安全可靠的云端文件存储解决方案', '2024-01-24 10:50:00', '2024-02-01 12:35:00', null, '1', '1');
INSERT INTO `example` VALUES ('11', '智能客服系统', '基于AI的智能客户服务助手', '2024-01-25 14:15:00', '2024-02-02 16:10:00', null, '1', '1');
INSERT INTO `example` VALUES ('12', '供应链管理', '优化供应链流程和物流管理', '2024-01-26 08:30:00', '2024-02-03 10:25:00', null, '1', '1');
INSERT INTO `example` VALUES ('13', '质量控制系统', '产品质量检测和流程监控', '2024-01-27 11:45:00', '2024-02-04 13:40:00', null, '1', '1');
INSERT INTO `example` VALUES ('14', '企业门户网站', '企业信息发布和员工协作平台', '2024-01-28 15:20:00', '2024-02-05 17:15:00', null, '1', '1');
INSERT INTO `example` VALUES ('15', '数据分析平台', '大数据处理和分析工具集', '2024-01-29 09:35:00', '2024-02-06 11:30:00', null, '1', '1');

-- ----------------------------
-- Table structure for sys_affix
-- ----------------------------
DROP TABLE IF EXISTS `sys_affix`;
CREATE TABLE `sys_affix` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '文件名',
  `path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '路径',
  `url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '文件url',
  `file_md5` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '文件MD5(秒传检测)',
  `size` int(10) DEFAULT NULL COMMENT '文件大小',
  `ftype` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '文件类型',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `suffix` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '文件后缀',
  `tenant_id` int(11) unsigned DEFAULT '0' COMMENT '租户ID字段',
  `thumbnail_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '缩略图路径',
  `thumbnail_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '缩略图名称',
  `thumbnail_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '缩略图URL',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_sys_affix_file_md5` (`file_md5`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_affix
-- ----------------------------

-- ----------------------------
-- Table structure for sys_affix_chunk
-- ----------------------------
DROP TABLE IF EXISTS `sys_affix_chunk`;
CREATE TABLE `sys_affix_chunk` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `upload_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '上传会话ID',
  `file_md5` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '文件MD5',
  `file_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '原始文件名',
  `file_size` bigint(20) DEFAULT NULL COMMENT '文件总大小',
  `chunk_size` int(11) DEFAULT NULL COMMENT '分片大小',
  `total_chunks` int(11) DEFAULT NULL COMMENT '总分片数',
  `chunk_index` int(11) NOT NULL COMMENT '当前分片序号',
  `chunk_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '分片文件路径',
  `status` tinyint(4) DEFAULT '0' COMMENT '0-上传中 1-已合并 2-已取消',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL COMMENT '创建者ID',
  `tenant_id` int(11) unsigned DEFAULT '0' COMMENT '租户ID',
  PRIMARY KEY (`id`),
  KEY `idx_upload_id` (`upload_id`),
  KEY `idx_file_md5` (`file_md5`)
) ENGINE=InnoDB AUTO_INCREMENT=165 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_affix_chunk
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
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=217 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

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
INSERT INTO `sys_api` VALUES ('105', '生成代码文件', '/api/codegen/generate', 'POST', '代码生成', '2025-11-07 15:32:53', '2025-11-07 15:32:53', null, '1');
INSERT INTO `sys_api` VALUES ('106', '获取表的字段信息', '/api/codegen/columns', 'GET', '代码生成', '2025-11-07 15:33:52', '2025-11-07 15:33:52', null, '1');
INSERT INTO `sys_api` VALUES ('187', '获取数据库列表', '/api/codegen/databases', 'GET', '代码生成', '2025-11-17 15:12:26', '2025-11-17 15:12:26', null, '1');
INSERT INTO `sys_api` VALUES ('188', '获取指定数据库中的表集合', '/api/codegen/tables', 'GET', '代码生成', '2025-11-17 15:13:38', '2025-11-17 15:13:38', null, '1');
INSERT INTO `sys_api` VALUES ('189', '代码预览', '/api/codegen/preview', 'GET', '代码生成', '2025-11-17 15:14:25', '2025-11-17 15:14:25', null, '1');
INSERT INTO `sys_api` VALUES ('190', '代码生成配置列表', '/api/sysGen/list', 'GET', '代码生成', '2025-11-17 15:15:20', '2025-11-17 15:15:20', null, '1');
INSERT INTO `sys_api` VALUES ('191', ' 批量创建代码生成配置', '/api/sysGen/batchInsert', 'POST', '代码生成', '2025-11-17 15:22:46', '2025-11-17 15:22:46', null, '1');
INSERT INTO `sys_api` VALUES ('192', '获取代码生成配置详情', '/api/sysGen/:id', 'GET', '代码生成', '2025-11-17 15:23:29', '2025-11-17 15:23:29', null, '1');
INSERT INTO `sys_api` VALUES ('193', '更新代码生成配置和字段信息', '/api/sysGen/update', 'PUT', '代码生成', '2025-11-17 15:24:41', '2025-11-17 15:24:41', null, '1');
INSERT INTO `sys_api` VALUES ('194', '删除代码生成配置和字段信息', '/api/sysGen/:id', 'DELETE', '代码生成', '2025-11-17 15:26:44', '2025-11-17 15:26:44', null, '1');
INSERT INTO `sys_api` VALUES ('195', '刷新代码生成配置的字段信息', '/api/sysGen/refreshFields', 'PUT', '代码生成', '2025-11-17 15:27:33', '2025-11-17 15:27:33', null, '1');
INSERT INTO `sys_api` VALUES ('196', '生成菜单', '/api/codegen/insertmenuandapi', 'POST', '代码生成', '2025-11-26 15:12:56', '2025-11-26 15:12:56', null, '1');
INSERT INTO `sys_api` VALUES ('197', '批量删除', '/api/sysMenu/batchDelete', 'DELETE', '菜单管理', '2025-12-05 17:48:52', '2025-12-05 17:48:52', null, '1');
INSERT INTO `sys_api` VALUES ('198', '获取插件列表', '/api/pluginsmanager/exports', 'GET', '插件管理', '2025-12-08 16:38:26', '2025-12-08 16:38:26', null, '1');
INSERT INTO `sys_api` VALUES ('199', '导出插件', '/api/pluginsmanager/export', 'POST', '插件管理', '2025-12-08 16:39:19', '2025-12-08 16:44:36', null, '1');
INSERT INTO `sys_api` VALUES ('200', '导入插件', '/api/pluginsmanager/import', 'POST', '插件管理', '2025-12-08 16:47:11', '2025-12-08 16:47:11', null, '1');
INSERT INTO `sys_api` VALUES ('201', '卸载插件', '/api/pluginsmanager/uninstall', 'DELETE', '插件管理', '2025-12-08 16:48:07', '2025-12-08 16:48:07', null, '1');
INSERT INTO `sys_api` VALUES ('202', '切换租户', '/api/users/switchTenant/:tenantld', 'GET', '用户管理', '2026-01-09 16:29:37', '2026-01-09 16:29:37', null, '1');
INSERT INTO `sys_api` VALUES ('203', '定时任务列表', '/api/sysJobs/list', 'GET', '任务调度', '2026-02-11 11:56:54', '2026-02-11 11:56:54', null, '1');
INSERT INTO `sys_api` VALUES ('204', '定时任务获取所有执行器列表', '/api/sysJobs/executors', 'GET', '任务调度', '2026-02-12 17:57:47', '2026-02-12 17:57:47', null, '1');
INSERT INTO `sys_api` VALUES ('205', '定时任务新增', '/api/sysJobs/add', 'POST', '任务调度', '2026-02-11 11:57:33', '2026-02-11 11:57:33', null, '1');
INSERT INTO `sys_api` VALUES ('206', '定时任务编辑', '/api/sysJobs/edit', 'PUT', '任务调度', '2026-02-11 11:57:58', '2026-02-11 11:57:58', null, '1');
INSERT INTO `sys_api` VALUES ('207', '定时任务获取数据', '/api/sysJobs/:id', 'GET', '任务调度', '2026-02-11 11:59:54', '2026-02-11 11:59:54', null, '1');
INSERT INTO `sys_api` VALUES ('208', '定时任务设置任务状态', '/api/sysJobs/setStatus', 'PUT', '任务调度', '2026-02-12 17:56:33', '2026-02-12 17:56:33', null, '1');
INSERT INTO `sys_api` VALUES ('209', '定时任务删除', '/api/sysJobs/delete', 'DELETE', '任务调度', '2026-02-11 11:59:05', '2026-02-11 11:59:05', null, '1');
INSERT INTO `sys_api` VALUES ('210', '定时任务立即执行任务', '/api/sysJobs/executeNow', 'POST', '任务调度', '2026-02-12 17:57:07', '2026-02-12 17:57:07', null, '1');
INSERT INTO `sys_api` VALUES ('211', '定时任务日志', '/api/sysJobResults/list', 'GET', '任务调度', '2026-02-11 12:00:54', '2026-02-11 12:00:54', null, '1');
INSERT INTO `sys_api` VALUES ('212', '定时任务日志删除', '/api/sysJobResults/delete', 'DELETE', '任务调度', '2026-02-11 12:01:22', '2026-02-11 12:01:22', null, '1');
INSERT INTO `sys_api` VALUES ('213', '分片上传初始化', '/api/sysAffix/chunk/init', 'POST', '文件管理', '2026-04-09 15:12:48', '2026-04-09 15:12:48', null, '1');
INSERT INTO `sys_api` VALUES ('214', '分片上传上传分片', '/api/sysAffix/chunk/upload', 'POST', '文件管理', '2026-04-09 15:37:44', '2026-04-09 15:37:44', null, '1');
INSERT INTO `sys_api` VALUES ('215', '分片上传合并分片', '/api/sysAffix/chunk/merge', 'POST', '文件管理', '2026-04-09 15:39:26', '2026-04-09 15:39:26', null, '1');
INSERT INTO `sys_api` VALUES ('216', '分片上传取消上传', '/api/sysAffix/chunk/cancel', 'DELETE', '文件管理', '2026-04-09 15:43:38', '2026-04-09 15:43:38', null, '1');

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
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_casbin_rule` (`ptype`,`v0`,`v1`,`v2`,`v3`,`v4`,`v5`) USING BTREE,
  UNIQUE KEY `idx_sys_casbin_rule` (`ptype`,`v0`,`v1`,`v2`,`v3`,`v4`,`v5`)
) ENGINE=InnoDB AUTO_INCREMENT=7561 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_casbin_rule
-- ----------------------------
INSERT INTO `sys_casbin_rule` VALUES ('6266', 'g', 'user_1', 'role_1', '*', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4189', 'g', 'user_4', 'role_2', '*', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7386', 'p', 'role_1', '/api/codegen/generate', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7425', 'p', 'role_1', '/api/codegen/insertmenuandapi', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7443', 'p', 'role_1', '/api/codegen/preview', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7412', 'p', 'role_1', '/api/codegen/tables', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7384', 'p', 'role_1', '/api/config/get', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7452', 'p', 'role_1', '/api/config/update', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7442', 'p', 'role_1', '/api/config/viewCache', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7469', 'p', 'role_1', '/api/plugins/example/:id', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7463', 'p', 'role_1', '/api/plugins/example/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7464', 'p', 'role_1', '/api/plugins/example/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7403', 'p', 'role_1', '/api/plugins/example/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7421', 'p', 'role_1', '/api/plugins/example/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7431', 'p', 'role_1', '/api/pluginsmanager/export', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7426', 'p', 'role_1', '/api/pluginsmanager/exports', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7459', 'p', 'role_1', '/api/pluginsmanager/import', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7454', 'p', 'role_1', '/api/pluginsmanager/uninstall', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7420', 'p', 'role_1', '/api/sysAffix/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7410', 'p', 'role_1', '/api/sysAffix/download/:id', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7419', 'p', 'role_1', '/api/sysAffix/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7402', 'p', 'role_1', '/api/sysAffix/updateName', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7462', 'p', 'role_1', '/api/sysAffix/upload', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7423', 'p', 'role_1', '/api/sysApi/:id', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7461', 'p', 'role_1', '/api/sysApi/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7456', 'p', 'role_1', '/api/sysApi/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7392', 'p', 'role_1', '/api/sysApi/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7467', 'p', 'role_1', '/api/sysApi/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7432', 'p', 'role_1', '/api/sysDepartment/:id', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7417', 'p', 'role_1', '/api/sysDepartment/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7446', 'p', 'role_1', '/api/sysDepartment/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7393', 'p', 'role_1', '/api/sysDepartment/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7429', 'p', 'role_1', '/api/sysDepartment/getDivision', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7447', 'p', 'role_1', '/api/sysDict/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7468', 'p', 'role_1', '/api/sysDict/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7418', 'p', 'role_1', '/api/sysDict/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7455', 'p', 'role_1', '/api/sysDict/getAllDicts', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7449', 'p', 'role_1', '/api/sysDict/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7457', 'p', 'role_1', '/api/sysDictItem/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7409', 'p', 'role_1', '/api/sysDictItem/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7401', 'p', 'role_1', '/api/sysDictItem/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7433', 'p', 'role_1', '/api/sysDictItem/getByDictId/:dictId', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7414', 'p', 'role_1', '/api/sysGen/:id', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7413', 'p', 'role_1', '/api/sysGen/:id', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7453', 'p', 'role_1', '/api/sysGen/batchInsert', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7411', 'p', 'role_1', '/api/sysGen/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7424', 'p', 'role_1', '/api/sysGen/refreshFields', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7382', 'p', 'role_1', '/api/sysGen/update', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7441', 'p', 'role_1', '/api/sysMenu/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7391', 'p', 'role_1', '/api/sysMenu/apis/:id', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7390', 'p', 'role_1', '/api/sysMenu/batchDelete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7451', 'p', 'role_1', '/api/sysMenu/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7395', 'p', 'role_1', '/api/sysMenu/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7435', 'p', 'role_1', '/api/sysMenu/export', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7445', 'p', 'role_1', '/api/sysMenu/getMenuList', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7399', 'p', 'role_1', '/api/sysMenu/getRouters', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7458', 'p', 'role_1', '/api/sysMenu/import', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7396', 'p', 'role_1', '/api/sysMenu/setApis', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7428', 'p', 'role_1', '/api/sysOperationLog/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7397', 'p', 'role_1', '/api/sysOperationLog/export', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7383', 'p', 'role_1', '/api/sysOperationLog/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7450', 'p', 'role_1', '/api/sysRole/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7408', 'p', 'role_1', '/api/sysRole/addRoleMenu', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7434', 'p', 'role_1', '/api/sysRole/dataScope', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7389', 'p', 'role_1', '/api/sysRole/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7400', 'p', 'role_1', '/api/sysRole/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7415', 'p', 'role_1', '/api/sysRole/getRoles', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7416', 'p', 'role_1', '/api/sysRole/getUserPermission/:roleId', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7430', 'p', 'role_1', '/api/sysTenant/:id', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7398', 'p', 'role_1', '/api/sysTenant/:id', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7385', 'p', 'role_1', '/api/sysTenant/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7436', 'p', 'role_1', '/api/sysTenant/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7404', 'p', 'role_1', '/api/sysTenant/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7405', 'p', 'role_1', '/api/sysUserTenant/batchAdd', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7422', 'p', 'role_1', '/api/sysUserTenant/batchDelete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7438', 'p', 'role_1', '/api/sysUserTenant/get', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7406', 'p', 'role_1', '/api/sysUserTenant/getRolesAll', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7381', 'p', 'role_1', '/api/sysUserTenant/getUserRoleIDs', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7437', 'p', 'role_1', '/api/sysUserTenant/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7439', 'p', 'role_1', '/api/sysUserTenant/setUserRoles', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7470', 'p', 'role_1', '/api/sysUserTenant/userListAll', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7444', 'p', 'role_1', '/api/users/:id', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7387', 'p', 'role_1', '/api/users/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7388', 'p', 'role_1', '/api/users/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7460', 'p', 'role_1', '/api/users/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7466', 'p', 'role_1', '/api/users/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7440', 'p', 'role_1', '/api/users/logout', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7427', 'p', 'role_1', '/api/users/profile', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7407', 'p', 'role_1', '/api/users/switchTenant/:tenantld', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7394', 'p', 'role_1', '/api/users/updateAccount', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7465', 'p', 'role_1', '/api/users/updateBasicInfo', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7448', 'p', 'role_1', '/api/users/uploadAvatar', 'POST', '*', '', '');
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
INSERT INTO `sys_casbin_rule` VALUES ('7481', 'p', 'role_2', '/api/codegen/generate', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7540', 'p', 'role_2', '/api/codegen/insertmenuandapi', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7539', 'p', 'role_2', '/api/codegen/preview', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7497', 'p', 'role_2', '/api/codegen/tables', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7550', 'p', 'role_2', '/api/config/get', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7553', 'p', 'role_2', '/api/config/update', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7472', 'p', 'role_2', '/api/config/viewCache', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7532', 'p', 'role_2', '/api/plugins/example/:id', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7473', 'p', 'role_2', '/api/plugins/example/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7512', 'p', 'role_2', '/api/plugins/example/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7549', 'p', 'role_2', '/api/plugins/example/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7541', 'p', 'role_2', '/api/plugins/example/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7524', 'p', 'role_2', '/api/pluginsmanager/export', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7523', 'p', 'role_2', '/api/pluginsmanager/exports', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7486', 'p', 'role_2', '/api/pluginsmanager/import', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7525', 'p', 'role_2', '/api/pluginsmanager/uninstall', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7480', 'p', 'role_2', '/api/sysAffix/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7506', 'p', 'role_2', '/api/sysAffix/download/:id', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7552', 'p', 'role_2', '/api/sysAffix/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7521', 'p', 'role_2', '/api/sysAffix/updateName', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7556', 'p', 'role_2', '/api/sysAffix/upload', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7529', 'p', 'role_2', '/api/sysApi/:id', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7518', 'p', 'role_2', '/api/sysApi/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7479', 'p', 'role_2', '/api/sysApi/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7484', 'p', 'role_2', '/api/sysApi/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7476', 'p', 'role_2', '/api/sysApi/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7500', 'p', 'role_2', '/api/sysDepartment/:id', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7530', 'p', 'role_2', '/api/sysDepartment/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7519', 'p', 'role_2', '/api/sysDepartment/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7560', 'p', 'role_2', '/api/sysDepartment/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7510', 'p', 'role_2', '/api/sysDepartment/getDivision', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7547', 'p', 'role_2', '/api/sysDict/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7520', 'p', 'role_2', '/api/sysDict/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7531', 'p', 'role_2', '/api/sysDict/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7534', 'p', 'role_2', '/api/sysDict/getAllDicts', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7475', 'p', 'role_2', '/api/sysDict/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7502', 'p', 'role_2', '/api/sysDictItem/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7548', 'p', 'role_2', '/api/sysDictItem/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7495', 'p', 'role_2', '/api/sysDictItem/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7501', 'p', 'role_2', '/api/sysDictItem/getByDictId/:dictId', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7522', 'p', 'role_2', '/api/sysGen/:id', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7498', 'p', 'role_2', '/api/sysGen/:id', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7538', 'p', 'role_2', '/api/sysGen/batchInsert', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7490', 'p', 'role_2', '/api/sysGen/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7517', 'p', 'role_2', '/api/sysGen/refreshFields', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7558', 'p', 'role_2', '/api/sysGen/update', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7505', 'p', 'role_2', '/api/sysMenu/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7491', 'p', 'role_2', '/api/sysMenu/apis/:id', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7535', 'p', 'role_2', '/api/sysMenu/batchDelete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7478', 'p', 'role_2', '/api/sysMenu/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7483', 'p', 'role_2', '/api/sysMenu/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7485', 'p', 'role_2', '/api/sysMenu/export', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7559', 'p', 'role_2', '/api/sysMenu/getMenuList', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7527', 'p', 'role_2', '/api/sysMenu/getRouters', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7507', 'p', 'role_2', '/api/sysMenu/import', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7546', 'p', 'role_2', '/api/sysMenu/setApis', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7533', 'p', 'role_2', '/api/sysOperationLog/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7513', 'p', 'role_2', '/api/sysOperationLog/export', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7544', 'p', 'role_2', '/api/sysOperationLog/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7511', 'p', 'role_2', '/api/sysRole/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7487', 'p', 'role_2', '/api/sysRole/addRoleMenu', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7471', 'p', 'role_2', '/api/sysRole/dataScope', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7528', 'p', 'role_2', '/api/sysRole/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7482', 'p', 'role_2', '/api/sysRole/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7551', 'p', 'role_2', '/api/sysRole/getRoles', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7477', 'p', 'role_2', '/api/sysRole/getUserPermission/:roleId', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7555', 'p', 'role_2', '/api/sysTenant/:id', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7508', 'p', 'role_2', '/api/sysTenant/:id', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7514', 'p', 'role_2', '/api/sysTenant/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7554', 'p', 'role_2', '/api/sysTenant/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7503', 'p', 'role_2', '/api/sysTenant/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7515', 'p', 'role_2', '/api/sysUserTenant/batchAdd', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7496', 'p', 'role_2', '/api/sysUserTenant/batchDelete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7537', 'p', 'role_2', '/api/sysUserTenant/get', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7474', 'p', 'role_2', '/api/sysUserTenant/getRolesAll', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7504', 'p', 'role_2', '/api/sysUserTenant/getUserRoleIDs', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7536', 'p', 'role_2', '/api/sysUserTenant/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7516', 'p', 'role_2', '/api/sysUserTenant/setUserRoles', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7557', 'p', 'role_2', '/api/sysUserTenant/userListAll', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7488', 'p', 'role_2', '/api/users/:id', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7493', 'p', 'role_2', '/api/users/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7494', 'p', 'role_2', '/api/users/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7545', 'p', 'role_2', '/api/users/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7543', 'p', 'role_2', '/api/users/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7526', 'p', 'role_2', '/api/users/logout', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7499', 'p', 'role_2', '/api/users/profile', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7492', 'p', 'role_2', '/api/users/switchTenant/:tenantld', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7489', 'p', 'role_2', '/api/users/updateAccount', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7509', 'p', 'role_2', '/api/users/updateBasicInfo', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('7542', 'p', 'role_2', '/api/users/uploadAvatar', 'POST', '*', '', '');
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
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

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
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_dict
-- ----------------------------
INSERT INTO `sys_dict` VALUES ('1', '性别', 'gender', '1', '这是一个性别字典', '2024-07-01 10:00:00', null, null, '1');
INSERT INTO `sys_dict` VALUES ('2', '状态', 'status', '1', '状态字段可以用这个', '2024-07-01 10:00:00', null, null, '1');
INSERT INTO `sys_dict` VALUES ('3', '岗位', 'post', '1', '岗位字段', '2024-07-01 10:00:00', null, null, '1');
INSERT INTO `sys_dict` VALUES ('4', '任务状态', 'taskStatus', '1', '任务状态字段可以用它', '2024-07-01 10:00:00', null, null, '1');

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
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

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

-- ----------------------------
-- Table structure for sys_gen
-- ----------------------------
DROP TABLE IF EXISTS `sys_gen`;
CREATE TABLE `sys_gen` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `db_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '数据库类型',
  `database` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '数据库',
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '数据库表名',
  `module_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '模块名称',
  `file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '文件名称',
  `describe` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '描述',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '修改时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '删除时间',
  `created_by` int(11) unsigned DEFAULT NULL COMMENT '创建人',
  `is_cover` tinyint(3) DEFAULT '0' COMMENT '是否覆盖',
  `is_menu` tinyint(3) DEFAULT '0' COMMENT '是否生成菜单',
  `is_tree` tinyint(3) DEFAULT '0',
  `is_relation_tree` tinyint(3) DEFAULT '0' COMMENT '是否关联树形分类',
  `relation_tree_table` int(11) unsigned DEFAULT '0' COMMENT '关联的树形表',
  `relation_field` int(11) unsigned DEFAULT '0' COMMENT '关联的字段ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_gen
-- ----------------------------
INSERT INTO `sys_gen` VALUES ('23', 'mysql', 'gin-fast-tenant', 'demo_students', 'test_school', 'demo_students', '学员管理', '2025-11-13 15:17:27', '2025-11-17 16:31:43', null, '1', '1', '1', null, '0', '0', '0');
INSERT INTO `sys_gen` VALUES ('24', 'mysql', 'gin-fast-tenant', 'demo_teacher', 'test_school', 'demo_teacher', '教师表', '2025-11-13 15:17:27', '2025-11-17 17:29:28', null, '1', '1', '1', null, '0', '0', '0');

-- ----------------------------
-- Table structure for sys_gen_field
-- ----------------------------
DROP TABLE IF EXISTS `sys_gen_field`;
CREATE TABLE `sys_gen_field` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `gen_id` int(11) unsigned DEFAULT NULL,
  `data_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '列名',
  `data_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '数据类型',
  `data_comment` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '列注释',
  `data_extra` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '额外信息',
  `data_column_key` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '列键信息',
  `data_unsigned` tinyint(3) DEFAULT '0' COMMENT '是否为无符号类型',
  `is_primary` tinyint(3) DEFAULT '0' COMMENT '是否主键',
  `go_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'go类型',
  `front_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '前端类型',
  `custom_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '自定义字段名称',
  `require` tinyint(3) DEFAULT '0' COMMENT '是否必填',
  `list_show` tinyint(3) DEFAULT '0' COMMENT '列表显示',
  `form_show` tinyint(3) DEFAULT '0' COMMENT '表单显示',
  `query_show` tinyint(3) DEFAULT '0' COMMENT '查询显示',
  `query_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '查询方式\r\nEQ  等于\r\nNE 不等于\r\nGT 大于\r\nGTE 大于等于\r\nLT 小于\r\nLTE 小于等于\r\nLIKE 包含\r\nBETWEEN 范围',
  `form_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '表单类型\r\ninput 文本框\r\ntextarea 文本域\r\nnumber 数字输入框\r\nselect 下拉框\r\nradio 单选框\r\ncheckbox 复选框\r\ndatetime 日期时间',
  `dict_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '关联的字典',
  `gorm_tag` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'gorm标签',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=214 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_gen_field
-- ----------------------------
INSERT INTO `sys_gen_field` VALUES ('185', '23', 'student_id', 'int', 'ID', 'auto_increment', 'PRI', '1', '1', 'uint', 'number', 'stu_id', '1', '0', '0', '1', 'EQ', '', '', 'column:student_id;primaryKey;not null;autoIncrement');
INSERT INTO `sys_gen_field` VALUES ('186', '23', 'student_name', 'varchar', '姓名', '', '', '0', '0', 'string', 'string', 'stu_name', '1', '1', '1', '1', 'LIKE', 'textarea', '', 'column:student_name;not null');
INSERT INTO `sys_gen_field` VALUES ('187', '23', 'age', 'int', '年龄', '', '', '0', '0', 'int', 'number', 'age', '1', '1', '1', '1', 'LIKE', '', '', 'column:age;not null;default:18');
INSERT INTO `sys_gen_field` VALUES ('188', '23', 'gender', 'varchar', '性别', '', '', '0', '0', 'string', 'string', 'gender', '1', '1', '1', '1', 'BETWEEN', 'radio', 'gender', 'column:gender;not null;default:\'\'');
INSERT INTO `sys_gen_field` VALUES ('189', '23', 'class_name', 'varchar', '班级名称', '', '', '0', '0', 'string', 'string', 'class_name', '0', '1', '1', '0', '', 'checkbox', 'class', 'column:class_name;not null');
INSERT INTO `sys_gen_field` VALUES ('190', '23', 'admission_date', 'datetime', '入学日期', '', '', '0', '0', 'time.Time', 'string', 'admission_date', '0', '0', '1', '0', '', '', '', 'column:admission_date;not null');
INSERT INTO `sys_gen_field` VALUES ('191', '23', 'email', 'varchar', ' 邮箱', '', 'UNI', '0', '0', 'string', 'string', 'email', '0', '0', '1', '1', '', 'checkbox', 'status', 'column:email;uniqueIndex');
INSERT INTO `sys_gen_field` VALUES ('192', '23', 'phone', 'varchar', '电话号码', '', '', '0', '0', 'string', 'string', 'phone', '0', '0', '0', '0', '', '', '', 'column:phone');
INSERT INTO `sys_gen_field` VALUES ('193', '23', 'address', 'text', '地址', '', '', '0', '0', 'string', 'string', 'address', '0', '0', '1', '1', '', 'select', 'status', 'column:address');
INSERT INTO `sys_gen_field` VALUES ('194', '23', 'created_at', 'datetime', '创建时间', '', '', '0', '0', 'time.Time', 'string', 'created_at', null, null, '1', '1', 'BETWEEN', '', '', 'column:created_at');
INSERT INTO `sys_gen_field` VALUES ('195', '23', 'updated_at', 'datetime', '更新时间', '', '', '0', '0', 'time.Time', 'string', 'updated_at', null, null, '1', null, '', '', '', 'column:updated_at');
INSERT INTO `sys_gen_field` VALUES ('196', '23', 'deleted_at', 'datetime', '删除时间', '', '', '0', '0', 'time.Time', 'string', 'deleted_at', null, null, '1', null, '', '', '', 'column:deleted_at');
INSERT INTO `sys_gen_field` VALUES ('197', '23', 'created_by', 'int', '创建人', '', '', '1', '0', 'uint', 'number', 'created_by', null, null, '1', null, '', '', '', 'column:created_by');
INSERT INTO `sys_gen_field` VALUES ('198', '23', 'tenant_id', 'int', '租户ID字段', '', '', '1', '0', 'uint', 'number', 'tenant_id', null, null, '1', '1', '', '', '', 'column:tenant_id');
INSERT INTO `sys_gen_field` VALUES ('199', '24', 'id', 'int', '主键ID', 'auto_increment', 'PRI', '1', '1', 'uint', 'number', 'tc_id', '1', '1', '1', '1', '', '', '', 'column:id;primaryKey;not null;autoIncrement');
INSERT INTO `sys_gen_field` VALUES ('200', '24', 'name', 'varchar', '教师姓名', '', '', '0', '0', 'string', 'string', 'tc_name', '1', '1', '1', '1', 'LIKE', 'input', '', 'column:name;not null');
INSERT INTO `sys_gen_field` VALUES ('201', '24', 'employee_id', 'varchar', '工号', '', '', '0', '0', 'string', 'string', 'employee_id', '1', '1', '1', '1', 'BETWEEN', '', '', 'column:employee_id');
INSERT INTO `sys_gen_field` VALUES ('202', '24', 'gender', 'tinyint', '性别', '', '', '0', '0', 'int', 'number', 'gender', '1', '1', '1', '1', 'EQ', 'select', 'gender', 'column:gender;default:0');
INSERT INTO `sys_gen_field` VALUES ('203', '24', 'phone', 'varchar', '手机号', '', '', '0', '0', 'string', 'string', 'phone', '1', '1', '1', '1', 'GT', '', '', 'column:phone');
INSERT INTO `sys_gen_field` VALUES ('204', '24', 'email', 'varchar', '邮箱', '', '', '0', '0', 'string', 'string', 'email', '1', '1', '1', '1', 'NE', '', '', 'column:email');
INSERT INTO `sys_gen_field` VALUES ('205', '24', 'subject', 'varchar', '所教学科', '', '', '0', '0', 'string', 'string', 'subject', '1', '1', '1', '1', '', '', '', 'column:subject');
INSERT INTO `sys_gen_field` VALUES ('206', '24', 'title', 'varchar', '职称', '', '', '0', '0', 'string', 'string', 'title', '1', '1', '1', '1', '', '', '', 'column:title');
INSERT INTO `sys_gen_field` VALUES ('207', '24', 'status', 'tinyint', '状态', '', '', '0', '0', 'int', 'number', 'status', '1', '1', '1', '1', '', 'select', 'status', 'column:status;default:1');
INSERT INTO `sys_gen_field` VALUES ('208', '24', 'hire_date', 'date', '入职日期', '', '', '0', '0', 'time.Time', 'string', 'hire_date', '1', '1', '1', '1', 'BETWEEN', '', '', 'column:hire_date');
INSERT INTO `sys_gen_field` VALUES ('209', '24', 'birth_date', 'date', '出生日期', '', '', '0', '0', 'time.Time', 'string', 'birth_date', '1', '1', '1', '1', '', 'select', 'test_date', 'column:birth_date');
INSERT INTO `sys_gen_field` VALUES ('210', '24', 'created_at', 'datetime', '创建时间', '', '', '0', '0', 'time.Time', 'string', 'created_at', null, null, null, null, '', '', '', 'column:created_at');
INSERT INTO `sys_gen_field` VALUES ('211', '24', 'updated_at', 'datetime', '更新时间', '', '', '0', '0', 'time.Time', 'string', 'updated_at', null, null, null, null, '', '', '', 'column:updated_at');
INSERT INTO `sys_gen_field` VALUES ('212', '24', 'deleted_at', 'datetime', '删除时间', '', '', '0', '0', 'time.Time', 'string', 'deleted_at', null, null, null, null, '', '', '', 'column:deleted_at');
INSERT INTO `sys_gen_field` VALUES ('213', '24', 'created_by', 'int', '创建人', '', '', '1', '0', 'uint', 'number', 'created_by', null, null, null, null, '', '', '', 'column:created_by');

-- ----------------------------
-- Table structure for sys_jobs
-- ----------------------------
DROP TABLE IF EXISTS `sys_jobs`;
CREATE TABLE `sys_jobs` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务ID',
  `group` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务分组名称',
  `name` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务名称',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT '任务描述',
  `executor_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '执行器名称',
  `execution_policy` tinyint(4) NOT NULL DEFAULT '1' COMMENT '执行策略: 0=单次执行, 1=重复执行',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '任务状态: 0=禁用, 1=启用',
  `cron_expression` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Cron表达式',
  `parameters` json DEFAULT NULL COMMENT '任务参数(JSON格式)',
  `blocking_policy` tinyint(4) NOT NULL DEFAULT '0' COMMENT '阻塞策略: 0=丢弃, 1=覆盖, 2=并行',
  `timeout` bigint(20) NOT NULL DEFAULT '30000000000' COMMENT '超时时间(纳秒)',
  `max_retry` int(11) NOT NULL DEFAULT '0' COMMENT '最大重试次数',
  `retry_interval` bigint(20) NOT NULL DEFAULT '10000000000' COMMENT '重试间隔(纳秒)',
  `parallel_num` int(11) NOT NULL DEFAULT '1' COMMENT '并行数',
  `running_count` int(11) NOT NULL DEFAULT '0' COMMENT '当前运行中的任务数',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_group` (`group`),
  KEY `idx_status` (`status`),
  KEY `idx_executor_name` (`executor_name`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='任务调度表';

-- ----------------------------
-- Records of sys_jobs
-- ----------------------------

-- ----------------------------
-- Table structure for sys_job_results
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_results`;
CREATE TABLE `sys_job_results` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `job_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '任务ID',
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '执行状态: SUCCESS, FAILED, PANIC',
  `error` text COLLATE utf8mb4_unicode_ci COMMENT '错误信息',
  `start_time` datetime NOT NULL COMMENT '开始时间',
  `end_time` datetime NOT NULL COMMENT '结束时间',
  `duration` bigint(20) NOT NULL COMMENT '执行时长(纳秒)',
  `retry_count` int(11) NOT NULL DEFAULT '0' COMMENT '重试次数',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '记录创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_job_id` (`job_id`),
  KEY `idx_status` (`status`),
  KEY `idx_start_time` (`start_time`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `sys_job_results_ibfk_1` FOREIGN KEY (`job_id`) REFERENCES `sys_jobs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='任务执行结果表';

-- ----------------------------
-- Records of sys_job_results
-- ----------------------------

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '路由ID',
  `parent_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '父级路由ID，顶层为0',
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
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_parent_id` (`parent_id`) USING BTREE,
  KEY `idx_sort` (`sort`) USING BTREE,
  KEY `idx_type` (`type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=140350 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='系统菜单路由表';

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
INSERT INTO `sys_menu` VALUES ('140254', '140239', '', '', '', '', '复制链接', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:affix:copy', '2025-10-17 11:38:09', '2025-10-17 11:38:09', null, '1');
INSERT INTO `sys_menu` VALUES ('140255', '1006', '', '', '', '', '导出', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:log:export', '2025-10-20 10:16:51', '2025-10-20 10:16:51', null, '1');
INSERT INTO `sys_menu` VALUES ('140256', '1006', '', '', '', '', '删除', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:log:delete', '2025-10-20 10:17:19', '2025-10-20 10:17:19', null, '1');
INSERT INTO `sys_menu` VALUES ('140257', '1003', '', '', '', '', '导出', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:menu:export', '2025-10-20 17:18:01', '2025-10-20 17:18:13', null, '1');
INSERT INTO `sys_menu` VALUES ('140258', '1003', '', '', '', '', '导入', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:menu:import', '2025-10-21 11:29:45', '2025-10-21 11:29:45', null, '1');
INSERT INTO `sys_menu` VALUES ('140259', '10', '/system/systenant', 'SystemSystenant', '', 'system/tenant/tenant', 'tenant', '0', '0', '0', '1', '0', '', '0', '', 'IconTags', '0', '2', '0', '', '2025-10-24 09:11:32', '2025-10-24 09:20:59', null, '1');
INSERT INTO `sys_menu` VALUES ('140260', '140259', '', '', '', '', '新增租户', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:tenant:add', '2025-10-24 09:14:25', '2025-10-24 09:14:25', null, '1');
INSERT INTO `sys_menu` VALUES ('140261', '140259', '', '', '', '', '修改租户', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:tenant:edit', '2025-10-24 09:14:50', '2025-10-24 09:14:50', null, '1');
INSERT INTO `sys_menu` VALUES ('140262', '140259', '', '', '', '', '删除租户', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:tenant:delete', '2025-10-24 09:15:07', '2025-10-24 09:15:07', null, '1');
INSERT INTO `sys_menu` VALUES ('140263', '140259', '', '', '', '', '分配用户', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:tenant:assignUser', '2025-10-27 18:03:07', '2025-10-27 18:03:07', null, '1');
INSERT INTO `sys_menu` VALUES ('140264', '1007', '', '', '', '', '修改用户基本信息', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:userinfo:updateBasicInfo', '2025-10-31 09:26:42', '2025-10-31 09:26:42', null, '1');
INSERT INTO `sys_menu` VALUES ('140265', '10', '/system/codegen', 'SystemCodegen', '', 'system/codegen/codegen', 'codegen', '0', '0', '0', '1', '0', '', '0', '', 'IconCode', '0', '2', '0', '', '2025-11-04 11:45:49', '2025-11-04 11:45:49', null, '1');
INSERT INTO `sys_menu` VALUES ('140329', '140265', '', '', '', '', '导入表', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:codegen:batchInsert', '2025-11-17 15:32:25', '2025-11-17 15:32:25', null, '1');
INSERT INTO `sys_menu` VALUES ('140330', '140265', '', '', '', '', '配置', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:codegen:update', '2025-11-17 15:33:57', '2025-11-17 15:33:57', null, '1');
INSERT INTO `sys_menu` VALUES ('140331', '140265', '', '', '', '', '预览', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:codegen:preview', '2025-11-17 15:34:24', '2025-11-17 15:34:24', null, '1');
INSERT INTO `sys_menu` VALUES ('140332', '140265', '', '', '', '', '生成代码文件', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:codegen:generate', '2025-11-17 15:35:00', '2025-11-17 15:35:00', null, '1');
INSERT INTO `sys_menu` VALUES ('140333', '140265', '', '', '', '', '同步数据库', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:codegen:refreshFields', '2025-11-17 15:35:51', '2025-11-17 15:35:51', null, '1');
INSERT INTO `sys_menu` VALUES ('140334', '140265', '', '', '', '', '删除', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:codegen:delete', '2025-11-17 15:36:50', '2025-11-17 15:36:50', null, '1');
INSERT INTO `sys_menu` VALUES ('140335', '140265', '', '', '', '', '生成菜单', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:codegen:insertmenuandapi', '2025-11-26 15:16:32', '2025-11-26 15:16:32', null, '1');
INSERT INTO `sys_menu` VALUES ('140336', '10', '/system/pluginsmanager', 'SystemPluginsmanager', '', 'system/pluginsmanager/pluginsmanager', 'plugins-manager', '0', '0', '0', '1', '0', '', '0', '', 'IconApps', '0', '2', '0', '', '2025-12-05 17:59:34', '2025-12-05 17:59:34', null, '1');
INSERT INTO `sys_menu` VALUES ('140338', '140336', '', '', '', '', '导出插件', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:pluginsmanager:export', '2025-12-08 16:33:32', '2025-12-08 16:33:32', null, '1');
INSERT INTO `sys_menu` VALUES ('140339', '140336', '', '', '', '', '导入插件', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:pluginsmanager:import', '2025-12-08 16:33:51', '2025-12-08 16:33:51', null, '1');
INSERT INTO `sys_menu` VALUES ('140340', '140336', '', '', '', '', '插件卸载', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:pluginsmanager:uninstall', '2025-12-08 16:34:53', '2025-12-08 16:34:53', null, '1');
INSERT INTO `sys_menu` VALUES ('140341', '0', '/sysjobs', 'Sysjobs', '', '', 'sysjobs', '0', '0', '0', '1', '0', '', '0', 'functions', '', '0', '1', '0', '', '2026-02-11 11:29:40', '2026-02-11 11:38:29', null, '1');
INSERT INTO `sys_menu` VALUES ('140342', '140341', '/system/sysjobslist', 'SystemSysjobslist', '', 'system/sysjobs/sysjobslist', 'jobslist', '0', '0', '0', '1', '0', '', '0', '', 'IconList', '0', '2', '0', '', '2026-02-11 11:36:54', '2026-02-11 11:36:54', null, '1');
INSERT INTO `sys_menu` VALUES ('140343', '140342', '', '', '', '', '新增', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:sysjobs:add', '2026-02-11 11:43:35', '2026-02-11 11:43:35', null, '1');
INSERT INTO `sys_menu` VALUES ('140344', '140342', '', '', '', '', '编辑', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:sysjobs:edit', '2026-02-11 11:44:00', '2026-02-11 11:44:00', null, '1');
INSERT INTO `sys_menu` VALUES ('140345', '140342', '', '', '', '', '删除', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:sysjobs:delete', '2026-02-11 11:44:22', '2026-02-11 11:44:22', null, '1');
INSERT INTO `sys_menu` VALUES ('140346', '140342', '', '', '', '', '执行一次', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:sysjobs:executeNow', '2026-02-12 17:59:02', '2026-02-12 17:59:02', null, '1');
INSERT INTO `sys_menu` VALUES ('140347', '140341', '/system/joblog', 'SystemJoblog', '', 'system/sysjobresults/sysjobresultslist', 'joblog', '0', '0', '0', '1', '0', '', '0', '', 'IconHistory', '0', '2', '0', '', '2026-02-11 11:41:27', '2026-02-11 11:41:27', null, '1');
INSERT INTO `sys_menu` VALUES ('140348', '140347', '', '', '', '', '删除', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:sysjobresults:delete', '2026-02-11 11:45:18', '2026-02-11 11:45:18', null, '1');
INSERT INTO `sys_menu` VALUES ('140349', '140239', '', '', '', '', '大文件上传', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:affix:bigupload', '2026-04-09 15:47:39', '2026-04-09 15:47:39', null, '1');

-- ----------------------------
-- Table structure for sys_menu_api
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu_api`;
CREATE TABLE `sys_menu_api` (
  `menu_id` int(11) unsigned NOT NULL,
  `api_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`menu_id`,`api_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_menu_api
-- ----------------------------
INSERT INTO `sys_menu_api` VALUES ('10', '5');
INSERT INTO `sys_menu_api` VALUES ('10', '6');
INSERT INTO `sys_menu_api` VALUES ('10', '7');
INSERT INTO `sys_menu_api` VALUES ('10', '12');
INSERT INTO `sys_menu_api` VALUES ('10', '27');
INSERT INTO `sys_menu_api` VALUES ('10', '54');
INSERT INTO `sys_menu_api` VALUES ('10', '202');
INSERT INTO `sys_menu_api` VALUES ('1001', '7');
INSERT INTO `sys_menu_api` VALUES ('1001', '8');
INSERT INTO `sys_menu_api` VALUES ('1001', '18');
INSERT INTO `sys_menu_api` VALUES ('1001', '19');
INSERT INTO `sys_menu_api` VALUES ('1002', '19');
INSERT INTO `sys_menu_api` VALUES ('1003', '13');
INSERT INTO `sys_menu_api` VALUES ('1004', '18');
INSERT INTO `sys_menu_api` VALUES ('1004', '37');
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
INSERT INTO `sys_menu_api` VALUES ('140224', '197');
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
INSERT INTO `sys_menu_api` VALUES ('140265', '190');
INSERT INTO `sys_menu_api` VALUES ('140329', '188');
INSERT INTO `sys_menu_api` VALUES ('140329', '191');
INSERT INTO `sys_menu_api` VALUES ('140330', '192');
INSERT INTO `sys_menu_api` VALUES ('140330', '193');
INSERT INTO `sys_menu_api` VALUES ('140331', '189');
INSERT INTO `sys_menu_api` VALUES ('140332', '105');
INSERT INTO `sys_menu_api` VALUES ('140333', '195');
INSERT INTO `sys_menu_api` VALUES ('140334', '194');
INSERT INTO `sys_menu_api` VALUES ('140335', '196');
INSERT INTO `sys_menu_api` VALUES ('140336', '198');
INSERT INTO `sys_menu_api` VALUES ('140338', '199');
INSERT INTO `sys_menu_api` VALUES ('140339', '200');
INSERT INTO `sys_menu_api` VALUES ('140340', '201');
INSERT INTO `sys_menu_api` VALUES ('140342', '203');
INSERT INTO `sys_menu_api` VALUES ('140342', '204');
INSERT INTO `sys_menu_api` VALUES ('140343', '205');
INSERT INTO `sys_menu_api` VALUES ('140344', '206');
INSERT INTO `sys_menu_api` VALUES ('140344', '207');
INSERT INTO `sys_menu_api` VALUES ('140344', '208');
INSERT INTO `sys_menu_api` VALUES ('140345', '209');
INSERT INTO `sys_menu_api` VALUES ('140346', '210');
INSERT INTO `sys_menu_api` VALUES ('140347', '211');
INSERT INTO `sys_menu_api` VALUES ('140348', '212');
INSERT INTO `sys_menu_api` VALUES ('140349', '55');
INSERT INTO `sys_menu_api` VALUES ('140349', '213');
INSERT INTO `sys_menu_api` VALUES ('140349', '214');
INSERT INTO `sys_menu_api` VALUES ('140349', '215');
INSERT INTO `sys_menu_api` VALUES ('140349', '216');

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
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_sys_operation_logs_deleted_at` (`deleted_at`) USING BTREE,
  KEY `idx_user_id` (`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='系统操作日志表';

-- ----------------------------
-- Records of sys_operation_logs
-- ----------------------------

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
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES ('1', '系统管理员', '0', '1', '最高权限管理员角色', '0', '2025-09-01 17:32:12', '2025-09-30 15:53:24', null, '1', '1', '', '0');
INSERT INTO `sys_role` VALUES ('2', '演示', '0', '1', '', '0', '2025-10-14 15:12:09', '2025-10-17 15:34:47', null, '1', '0', '', '0');

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu` (
  `role_id` int(11) unsigned NOT NULL,
  `menu_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`role_id`,`menu_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

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
INSERT INTO `sys_role_menu` VALUES ('1', '140265');
INSERT INTO `sys_role_menu` VALUES ('1', '140329');
INSERT INTO `sys_role_menu` VALUES ('1', '140330');
INSERT INTO `sys_role_menu` VALUES ('1', '140331');
INSERT INTO `sys_role_menu` VALUES ('1', '140332');
INSERT INTO `sys_role_menu` VALUES ('1', '140333');
INSERT INTO `sys_role_menu` VALUES ('1', '140334');
INSERT INTO `sys_role_menu` VALUES ('1', '140335');
INSERT INTO `sys_role_menu` VALUES ('1', '140336');
INSERT INTO `sys_role_menu` VALUES ('1', '140338');
INSERT INTO `sys_role_menu` VALUES ('1', '140339');
INSERT INTO `sys_role_menu` VALUES ('1', '140340');
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
INSERT INTO `sys_role_menu` VALUES ('2', '140264');
INSERT INTO `sys_role_menu` VALUES ('2', '140265');
INSERT INTO `sys_role_menu` VALUES ('2', '140329');
INSERT INTO `sys_role_menu` VALUES ('2', '140330');
INSERT INTO `sys_role_menu` VALUES ('2', '140331');
INSERT INTO `sys_role_menu` VALUES ('2', '140332');
INSERT INTO `sys_role_menu` VALUES ('2', '140333');
INSERT INTO `sys_role_menu` VALUES ('2', '140334');
INSERT INTO `sys_role_menu` VALUES ('2', '140335');
INSERT INTO `sys_role_menu` VALUES ('2', '140336');
INSERT INTO `sys_role_menu` VALUES ('2', '140338');
INSERT INTO `sys_role_menu` VALUES ('2', '140339');
INSERT INTO `sys_role_menu` VALUES ('2', '140340');

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
  `platform_domain` varchar(255) DEFAULT NULL COMMENT '主域名',
  `menu_permission` varchar(1000) DEFAULT NULL COMMENT '菜单权限',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `code` (`code`) USING BTREE,
  UNIQUE KEY `domain` (`domain`) USING BTREE,
  KEY `idx_sys_tenants_deleted_at` (`deleted_at`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_tenants
-- ----------------------------
INSERT INTO `sys_tenants` VALUES ('1', '2025-11-03 11:16:45', '2026-01-09 16:31:23', null, '1', '测试租户1', 'dom1', '', '1', '', '', '1,10,1001,140214,140215,140216,1002,140218,140219,140220,140221,140244,1003,140222,140223,140224,140225,140257,140258,1004,140229,140230,140231,1006,140255,140256,1007,140252,140264,140239,140240,140241,140242,140243,140254');

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
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `username` (`username`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_users
-- ----------------------------
INSERT INTO `sys_users` VALUES ('1', 'admin', '$2a$10$0aS9FxWlOz/PXiqzsBr7huy.Dqdwucyb795qiWcA6fsn0Lu.GLA.C', 'admin@example.com', '1', '1', '18800000006', '1', '超级管理员', '/public/uploads/2025-11-04/20251104_0945787a-8536-45fc-ba75-e94c8daaec06.jpeg', '超级管理员', '2025-08-18 14:55:05', '2025-11-17 17:38:01', null, '0', '0');
INSERT INTO `sys_users` VALUES ('4', 'demo', '$2a$10$yxq80jnZCRPn/hhQYUffheRnDopYjiq1AKGdgrg1oatLha7tc/.Qe', '', '1', '1', '', '1', '演示账号', '', '演示账号', '2025-10-17 15:38:37', '2025-10-31 16:32:34', null, '1', '0');

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role` (
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
  `role_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '角色ID',
  PRIMARY KEY (`user_id`,`role_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

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
  PRIMARY KEY (`user_id`,`tenant_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='用户及租户关联表';

-- ----------------------------
-- Records of sys_user_tenant
-- ----------------------------

-- ----------------------------
-- Table structure for sys_param
-- ----------------------------
DROP TABLE IF EXISTS `sys_param`;
CREATE TABLE `sys_param` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL COMMENT '参数名称',
  `code` varchar(255) NOT NULL COMMENT '参数唯一标识',
  `value` text COMMENT '参数值',
  `status` tinyint(4) DEFAULT '1' COMMENT '状态(0禁用/1启用)',
  `description` varchar(500) DEFAULT NULL COMMENT '描述',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) unsigned DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_sys_param_code` (`code`),
  KEY `idx_sys_param_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COMMENT='系统参数配置';

-- ----------------------------
-- Table structure for sys_area
-- ----------------------------
DROP TABLE IF EXISTS `sys_area`;
CREATE TABLE `sys_area` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `value` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '地区编码',
  `label` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '地区名称',
  `level` tinyint(4) DEFAULT NULL COMMENT '层级 1省2市3区县4街道',
  `parent` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '父级编码',
  `sort` int(11) DEFAULT '0' COMMENT '排序',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sys_area_value` (`value`),
  KEY `idx_sys_area_parent` (`parent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='行政区划';
