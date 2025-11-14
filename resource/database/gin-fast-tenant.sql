/*
Navicat MySQL Data Transfer

Source Server         : localhsot5.7
Source Server Version : 50726
Source Host           : localhost:3306
Source Database       : gin-fast-tenant

Target Server Type    : MYSQL
Target Server Version : 50726
File Encoding         : 65001

Date: 2025-11-14 18:14:33
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
  `created_by` int(11) unsigned DEFAULT NULL COMMENT '创建人',
  `tenant_id` int(11) unsigned DEFAULT NULL COMMENT '租户ID字段',
  PRIMARY KEY (`student_id`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='学员管理';

-- ----------------------------
-- Records of demo_students
-- ----------------------------
INSERT INTO `demo_students` VALUES ('1', '张三6', '18', '男', '计算机科学与技术1班', '2023-09-01 00:00:00', 'zhangsan@example.com', '13800138001', '北京市海淀区', '2025-11-13 15:41:38', '2025-11-13 15:41:51', null, '1', '0');
INSERT INTO `demo_students` VALUES ('2', '李四', '19', '女', '计算机科学与技术1班', '2023-09-01 00:00:00', 'lisi@example.com', '13800138002', '北京市朝阳区', '2025-11-13 15:41:38', null, null, '1', null);
INSERT INTO `demo_students` VALUES ('3', '王五', '18', '男', '软件工程2班', '2023-09-01 00:00:00', 'wangwu@example.com', '13800138003', '上海市浦东新区', '2025-11-13 15:41:38', null, null, '1', null);
INSERT INTO `demo_students` VALUES ('4', '赵六', '17', '女', '软件工程2班', '2023-09-01 00:00:00', 'zhaoliu@example.com', '13800138004', '广州市天河区', '2025-11-13 15:41:38', null, null, '1', null);
INSERT INTO `demo_students` VALUES ('5', '孙七', '19', '男', '数据科学1班', '2023-09-01 00:00:00', 'sunqi@example.com', '13800138005', '深圳市南山区', '2025-11-13 15:41:38', null, null, '1', null);
INSERT INTO `demo_students` VALUES ('15', '66', '1', '1', '1', '2025-11-04 08:00:00', '1', '1', '1', '2025-11-13 15:39:30', '2025-11-13 15:40:12', null, '1', '0');
INSERT INTO `demo_students` VALUES ('16', '11', '11', '1', '[\"b\",\"a\"]', '2025-11-01 08:00:00', '', '', '1', '2025-11-14 16:24:52', '2025-11-14 16:24:52', null, '1', '0');
INSERT INTO `demo_students` VALUES ('17', '22', '22', '0', '[\"b\"]', '2025-11-04 08:00:00', '', '', '2', '2025-11-14 16:28:27', '2025-11-14 16:28:27', null, '1', '0');
INSERT INTO `demo_students` VALUES ('18', '3', '3', '1', '[\"a\",\"b\"]', '2025-11-25 08:00:00', '', '', '1', '2025-11-14 18:06:49', '2025-11-14 18:06:49', null, '1', '0');

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
  `created_by` int(11) unsigned DEFAULT NULL COMMENT '创建人',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COMMENT='教师表';

-- ----------------------------
-- Records of demo_teacher
-- ----------------------------
INSERT INTO `demo_teacher` VALUES ('1', '张明', 'T2023001', '1', '13812345678', 'zhangming@school.com', '数学', '高级教师', '1', '2018-09-01', '1985-03-15', '2023-01-15 08:30:00', '2023-06-20 14:25:00', null, '1');
INSERT INTO `demo_teacher` VALUES ('2', '李雪', 'T2023002', '2', '13987654321', 'lixue@school.com', '语文', '特级教师', '1', '2015-07-15', '1982-11-20', '2023-01-15 08:32:00', '2023-08-10 09:15:00', null, '1');
INSERT INTO `demo_teacher` VALUES ('3', '王建国', 'T2023003', '1', '13698765432', 'wangjianguo@school.com', '物理', '一级教师', '1', '2020-03-01', '1990-07-08', '2023-01-16 10:20:00', '2023-07-22 16:40:00', null, '1');
INSERT INTO `demo_teacher` VALUES ('4', '刘芳', 'T2023004', '2', '13512348765', 'liufang@school.com', '英语', '高级教师', '1', '2019-08-20', '1988-12-05', '2023-01-16 10:25:00', '2023-09-05 11:30:00', null, '1');
INSERT INTO `demo_teacher` VALUES ('5', '陈伟', 'T2023005', '1', '13765432109', 'chenwei@school.com', '化学', '二级教师', '1', '2022-02-15', '1993-05-18', '2023-01-17 14:15:00', '2023-10-12 13:45:00', null, '1');

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
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

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
INSERT INTO `example` VALUES ('16', '11', '11', '2025-11-06 17:13:18', '2025-11-06 17:13:18', null, '1', '0');

-- ----------------------------
-- Table structure for sys_affix
-- ----------------------------
DROP TABLE IF EXISTS `sys_affix`;
CREATE TABLE `sys_affix` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
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
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_affix
-- ----------------------------
INSERT INTO `sys_affix` VALUES ('1', '20251112_e54d5902-8ac9-4015-ba4b-fba84313d38f.jpeg', 'resource\\public\\uploads\\2025-11-12\\20251112_e54d5902-8ac9-4015-ba4b-fba84313d38f.jpeg', '/public/uploads/2025-11-12/20251112_e54d5902-8ac9-4015-ba4b-fba84313d38f.jpeg', '94425', 'image', '2025-11-12 15:14:14', '2025-11-12 15:14:14', null, '1', '.jpeg', '0');
INSERT INTO `sys_affix` VALUES ('2', '20251112_dc41d7cf-79ce-4bf3-b7eb-6eae3fe0efe8.mp4', 'resource\\public\\uploads\\2025-11-12\\20251112_dc41d7cf-79ce-4bf3-b7eb-6eae3fe0efe8.mp4', '/public/uploads/2025-11-12/20251112_dc41d7cf-79ce-4bf3-b7eb-6eae3fe0efe8.mp4', '4287097', 'video', '2025-11-12 15:17:08', '2025-11-12 15:17:08', null, '1', '.mp4', '0');

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
) ENGINE=InnoDB AUTO_INCREMENT=182 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

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
INSERT INTO `sys_api` VALUES ('105', '生成代码文件', '/api/codegen/generate', 'POST', '代码生成', '2025-11-07 15:32:53', '2025-11-07 15:32:53', null, '1');
INSERT INTO `sys_api` VALUES ('106', '获取表的字段信息', '/api/codegen/columns', 'GET', '代码生成', '2025-11-07 15:33:52', '2025-11-07 15:33:52', null, '1');
INSERT INTO `sys_api` VALUES ('177', '列表查询', '/api/plugins/testbook/teststudents/list', 'GET', '学员管理', '2025-11-13 16:41:40', '2025-11-13 16:41:40', null, '1');
INSERT INTO `sys_api` VALUES ('178', '新增', '/api/plugins/testbook/teststudents/add', 'POST', '学员管理', '2025-11-13 16:41:40', '2025-11-13 16:41:40', null, '1');
INSERT INTO `sys_api` VALUES ('179', '修改', '/api/plugins/testbook/teststudents/edit', 'PUT', '学员管理', '2025-11-13 16:41:40', '2025-11-13 16:41:40', null, '1');
INSERT INTO `sys_api` VALUES ('180', '删除', '/api/plugins/testbook/teststudents/delete', 'DELETE', '学员管理', '2025-11-13 16:41:40', '2025-11-13 16:41:40', null, '1');
INSERT INTO `sys_api` VALUES ('181', '查询单条数据', '/api/plugins/testbook/teststudents/:id', 'GET', '学员管理', '2025-11-13 16:41:40', '2025-11-13 16:41:40', null, '1');

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
  UNIQUE KEY `idx_sys_casbin_rule` (`ptype`,`v0`,`v1`,`v2`,`v3`,`v4`,`v5`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5377 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_casbin_rule
-- ----------------------------
INSERT INTO `sys_casbin_rule` VALUES ('4188', 'g', 'user_1', 'role_1', '*', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('4189', 'g', 'user_4', 'role_2', '*', '', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5277', 'p', 'role_1', '/api/codegen/columns', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5247', 'p', 'role_1', '/api/codegen/generate', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5295', 'p', 'role_1', '/api/config/get', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5296', 'p', 'role_1', '/api/config/update', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5232', 'p', 'role_1', '/api/config/viewCache', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5297', 'p', 'role_1', '/api/plugins/example/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5251', 'p', 'role_1', '/api/plugins/example/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5240', 'p', 'role_1', '/api/plugins/example/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5274', 'p', 'role_1', '/api/plugins/example/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5257', 'p', 'role_1', '/api/plugins/example/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5271', 'p', 'role_1', '/api/sysAffix/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5234', 'p', 'role_1', '/api/sysAffix/download/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5262', 'p', 'role_1', '/api/sysAffix/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5239', 'p', 'role_1', '/api/sysAffix/updateName', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5253', 'p', 'role_1', '/api/sysAffix/upload', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5270', 'p', 'role_1', '/api/sysApi/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5258', 'p', 'role_1', '/api/sysApi/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5298', 'p', 'role_1', '/api/sysApi/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5259', 'p', 'role_1', '/api/sysApi/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5252', 'p', 'role_1', '/api/sysApi/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5265', 'p', 'role_1', '/api/sysDepartment/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5260', 'p', 'role_1', '/api/sysDepartment/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5273', 'p', 'role_1', '/api/sysDepartment/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5242', 'p', 'role_1', '/api/sysDepartment/getDivision', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5289', 'p', 'role_1', '/api/sysDict/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5299', 'p', 'role_1', '/api/sysDict/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5231', 'p', 'role_1', '/api/sysDict/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5303', 'p', 'role_1', '/api/sysDict/getAllDicts', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5230', 'p', 'role_1', '/api/sysDict/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5261', 'p', 'role_1', '/api/sysDictItem/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5291', 'p', 'role_1', '/api/sysDictItem/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5290', 'p', 'role_1', '/api/sysDictItem/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5300', 'p', 'role_1', '/api/sysDictItem/getByDictId/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5264', 'p', 'role_1', '/api/sysMenu/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5288', 'p', 'role_1', '/api/sysMenu/apis/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5294', 'p', 'role_1', '/api/sysMenu/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5302', 'p', 'role_1', '/api/sysMenu/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5236', 'p', 'role_1', '/api/sysMenu/export', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5281', 'p', 'role_1', '/api/sysMenu/getMenuList', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5267', 'p', 'role_1', '/api/sysMenu/getRouters', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5301', 'p', 'role_1', '/api/sysMenu/import', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5243', 'p', 'role_1', '/api/sysMenu/setApis', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5235', 'p', 'role_1', '/api/sysOperationLog/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5275', 'p', 'role_1', '/api/sysOperationLog/export', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5269', 'p', 'role_1', '/api/sysOperationLog/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5282', 'p', 'role_1', '/api/sysRole/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5238', 'p', 'role_1', '/api/sysRole/addRoleMenu', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5254', 'p', 'role_1', '/api/sysRole/dataScope', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5293', 'p', 'role_1', '/api/sysRole/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5237', 'p', 'role_1', '/api/sysRole/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5278', 'p', 'role_1', '/api/sysRole/getRoles', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5279', 'p', 'role_1', '/api/sysRole/getUserPermission/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5244', 'p', 'role_1', '/api/sysTenant/*', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5283', 'p', 'role_1', '/api/sysTenant/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5263', 'p', 'role_1', '/api/sysTenant/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5284', 'p', 'role_1', '/api/sysTenant/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5255', 'p', 'role_1', '/api/sysTenant/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5276', 'p', 'role_1', '/api/sysUserTenant/batchAdd', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5292', 'p', 'role_1', '/api/sysUserTenant/batchDelete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5245', 'p', 'role_1', '/api/sysUserTenant/get', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5241', 'p', 'role_1', '/api/sysUserTenant/getRolesAll', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5256', 'p', 'role_1', '/api/sysUserTenant/getUserRoleIDs', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5280', 'p', 'role_1', '/api/sysUserTenant/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5246', 'p', 'role_1', '/api/sysUserTenant/setUserRoles', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5272', 'p', 'role_1', '/api/sysUserTenant/userListAll', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5248', 'p', 'role_1', '/api/users/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5250', 'p', 'role_1', '/api/users/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5287', 'p', 'role_1', '/api/users/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5249', 'p', 'role_1', '/api/users/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5304', 'p', 'role_1', '/api/users/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5233', 'p', 'role_1', '/api/users/logout', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5286', 'p', 'role_1', '/api/users/profile', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5285', 'p', 'role_1', '/api/users/updateAccount', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5266', 'p', 'role_1', '/api/users/updateBasicInfo', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5268', 'p', 'role_1', '/api/users/uploadAvatar', 'POST', '*', '', '');
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
INSERT INTO `sys_casbin_rule` VALUES ('5365', 'p', 'role_2', '/api/config/get', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5322', 'p', 'role_2', '/api/config/update', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5346', 'p', 'role_2', '/api/config/viewCache', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5370', 'p', 'role_2', '/api/plugins/example/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5366', 'p', 'role_2', '/api/plugins/example/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5338', 'p', 'role_2', '/api/plugins/example/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5319', 'p', 'role_2', '/api/plugins/example/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5342', 'p', 'role_2', '/api/plugins/example/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5362', 'p', 'role_2', '/api/sysAffix/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5363', 'p', 'role_2', '/api/sysAffix/download/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5357', 'p', 'role_2', '/api/sysAffix/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5331', 'p', 'role_2', '/api/sysAffix/updateName', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5310', 'p', 'role_2', '/api/sysAffix/upload', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5320', 'p', 'role_2', '/api/sysApi/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5323', 'p', 'role_2', '/api/sysApi/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5306', 'p', 'role_2', '/api/sysApi/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5309', 'p', 'role_2', '/api/sysApi/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5351', 'p', 'role_2', '/api/sysApi/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5337', 'p', 'role_2', '/api/sysDepartment/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5326', 'p', 'role_2', '/api/sysDepartment/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5368', 'p', 'role_2', '/api/sysDepartment/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5350', 'p', 'role_2', '/api/sysDepartment/getDivision', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5335', 'p', 'role_2', '/api/sysDict/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5356', 'p', 'role_2', '/api/sysDict/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5307', 'p', 'role_2', '/api/sysDict/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5333', 'p', 'role_2', '/api/sysDict/getAllDicts', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5341', 'p', 'role_2', '/api/sysDict/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5321', 'p', 'role_2', '/api/sysDictItem/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5345', 'p', 'role_2', '/api/sysDictItem/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5361', 'p', 'role_2', '/api/sysDictItem/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5369', 'p', 'role_2', '/api/sysDictItem/getByDictId/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5334', 'p', 'role_2', '/api/sysMenu/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5305', 'p', 'role_2', '/api/sysMenu/apis/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5354', 'p', 'role_2', '/api/sysMenu/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5360', 'p', 'role_2', '/api/sysMenu/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5328', 'p', 'role_2', '/api/sysMenu/export', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5374', 'p', 'role_2', '/api/sysMenu/getMenuList', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5308', 'p', 'role_2', '/api/sysMenu/getRouters', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5348', 'p', 'role_2', '/api/sysMenu/import', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5355', 'p', 'role_2', '/api/sysMenu/setApis', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5347', 'p', 'role_2', '/api/sysOperationLog/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5352', 'p', 'role_2', '/api/sysOperationLog/export', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5325', 'p', 'role_2', '/api/sysOperationLog/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5336', 'p', 'role_2', '/api/sysRole/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5376', 'p', 'role_2', '/api/sysRole/addRoleMenu', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5318', 'p', 'role_2', '/api/sysRole/dataScope', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5375', 'p', 'role_2', '/api/sysRole/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5359', 'p', 'role_2', '/api/sysRole/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5373', 'p', 'role_2', '/api/sysRole/getRoles', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5330', 'p', 'role_2', '/api/sysRole/getUserPermission/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5371', 'p', 'role_2', '/api/sysTenant/*', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5353', 'p', 'role_2', '/api/sysTenant/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5367', 'p', 'role_2', '/api/sysTenant/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5364', 'p', 'role_2', '/api/sysTenant/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5311', 'p', 'role_2', '/api/sysTenant/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5339', 'p', 'role_2', '/api/sysUserTenant/batchAdd', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5316', 'p', 'role_2', '/api/sysUserTenant/batchDelete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5315', 'p', 'role_2', '/api/sysUserTenant/get', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5317', 'p', 'role_2', '/api/sysUserTenant/getRolesAll', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5343', 'p', 'role_2', '/api/sysUserTenant/getUserRoleIDs', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5312', 'p', 'role_2', '/api/sysUserTenant/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5340', 'p', 'role_2', '/api/sysUserTenant/setUserRoles', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5313', 'p', 'role_2', '/api/sysUserTenant/userListAll', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5324', 'p', 'role_2', '/api/users/*', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5332', 'p', 'role_2', '/api/users/add', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5358', 'p', 'role_2', '/api/users/delete', 'DELETE', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5314', 'p', 'role_2', '/api/users/edit', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5349', 'p', 'role_2', '/api/users/list', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5372', 'p', 'role_2', '/api/users/logout', 'POST', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5329', 'p', 'role_2', '/api/users/profile', 'GET', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5327', 'p', 'role_2', '/api/users/updateAccount', 'PUT', '*', '', '');
INSERT INTO `sys_casbin_rule` VALUES ('5344', 'p', 'role_2', '/api/users/uploadAvatar', 'POST', '*', '', '');
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_dict
-- ----------------------------
INSERT INTO `sys_dict` VALUES ('1', '性别', 'gender', '1', '这是一个性别字典', '2024-07-01 10:00:00', null, null, '1');
INSERT INTO `sys_dict` VALUES ('2', '状态', 'status', '1', '状态字段可以用这个', '2024-07-01 10:00:00', null, null, '1');
INSERT INTO `sys_dict` VALUES ('3', '岗位', 'post', '1', '岗位字段', '2024-07-01 10:00:00', null, null, '1');
INSERT INTO `sys_dict` VALUES ('4', '任务状态', 'taskStatus', '1', '任务状态字段可以用它', '2024-07-01 10:00:00', null, null, '1');
INSERT INTO `sys_dict` VALUES ('5', '测试字典', 'testStart', '1', '测试字典', '2025-09-16 17:47:37', '2025-09-16 17:47:37', null, '1');
INSERT INTO `sys_dict` VALUES ('6', '测试班级', 'class', '1', '', '2025-11-14 15:33:26', '2025-11-14 15:33:26', null, '1');

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
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

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
INSERT INTO `sys_dict_item` VALUES ('46', '班级A', 'a', '1', '6');
INSERT INTO `sys_dict_item` VALUES ('47', '班级B', 'b', '1', '6');

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
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_gen
-- ----------------------------
INSERT INTO `sys_gen` VALUES ('23', 'mysql', 'gin-fast-tenant', 'demo_students', 'test_book', 'test_students', '学员管理', '2025-11-13 15:17:27', '2025-11-14 17:04:20', null, '1');
INSERT INTO `sys_gen` VALUES ('24', 'mysql', 'gin-fast-tenant', 'demo_teacher', 'test_book', 'test_teacher', '教师表', '2025-11-13 15:17:27', '2025-11-13 15:58:20', null, '1');

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
INSERT INTO `sys_gen_field` VALUES ('187', '23', 'age', 'int', '年龄', '', '', '0', '0', 'int', 'number', 'age', '1', '1', '1', '1', 'GTE', '', '', 'column:age;not null;default:18');
INSERT INTO `sys_gen_field` VALUES ('188', '23', 'gender', 'varchar', '性别', '', '', '0', '0', 'string', 'string', 'gender', '1', '1', '1', '1', '', 'radio', 'gender', 'column:gender;not null;default:\'\'');
INSERT INTO `sys_gen_field` VALUES ('189', '23', 'class_name', 'varchar', '班级名称', '', '', '0', '0', 'string', 'string', 'class_name', '0', '1', '1', '0', '', 'checkbox', 'class', 'column:class_name;not null');
INSERT INTO `sys_gen_field` VALUES ('190', '23', 'admission_date', 'datetime', '入学日期', '', '', '0', '0', 'time.Time', 'string', 'admission_date', '0', '0', '1', '0', '', '', '', 'column:admission_date;not null');
INSERT INTO `sys_gen_field` VALUES ('191', '23', 'email', 'varchar', ' 邮箱', '', 'UNI', '0', '0', 'string', 'string', 'email', '0', '0', '0', '0', '', 'checkbox', 'status', 'column:email;uniqueIndex');
INSERT INTO `sys_gen_field` VALUES ('192', '23', 'phone', 'varchar', '电话号码', '', '', '0', '0', 'string', 'string', 'phone', '0', '0', '0', '0', '', '', '', 'column:phone');
INSERT INTO `sys_gen_field` VALUES ('193', '23', 'address', 'text', '地址', '', '', '0', '0', 'string', 'string', 'address', '0', '0', '1', '1', '', 'select', 'status', 'column:address');
INSERT INTO `sys_gen_field` VALUES ('194', '23', 'created_at', 'datetime', '创建时间', '', '', '0', '0', 'time.Time', 'string', 'created_at', null, null, null, '1', 'BETWEEN', '', '', 'column:created_at');
INSERT INTO `sys_gen_field` VALUES ('195', '23', 'updated_at', 'datetime', '更新时间', '', '', '0', '0', 'time.Time', 'string', 'updated_at', null, null, null, null, '', '', '', 'column:updated_at');
INSERT INTO `sys_gen_field` VALUES ('196', '23', 'deleted_at', 'datetime', '删除时间', '', '', '0', '0', 'time.Time', 'string', 'deleted_at', null, null, null, null, '', '', '', 'column:deleted_at');
INSERT INTO `sys_gen_field` VALUES ('197', '23', 'created_by', 'int', '创建人', '', '', '1', '0', 'uint', 'number', 'created_by', null, null, null, null, '', '', '', 'column:created_by');
INSERT INTO `sys_gen_field` VALUES ('198', '23', 'tenant_id', 'int', '租户ID字段', '', '', '1', '0', 'uint', 'number', 'tenant_id', null, null, null, null, '', '', '', 'column:tenant_id');
INSERT INTO `sys_gen_field` VALUES ('199', '24', 'id', 'int', '主键ID', 'auto_increment', 'PRI', '1', '1', 'uint', 'number', 'teacher_id', '1', '1', '1', '1', '', '', '', 'column:id;primaryKey;not null;autoIncrement');
INSERT INTO `sys_gen_field` VALUES ('200', '24', 'name', 'varchar', '教师姓名', '', '', '0', '0', 'string', 'string', 'teacher_name', '1', '1', '1', '1', '', '', '', 'column:name;not null');
INSERT INTO `sys_gen_field` VALUES ('201', '24', 'employee_id', 'varchar', '工号', '', '', '0', '0', 'string', 'string', 'employee_id', '1', '1', '1', '1', '', '', '', 'column:employee_id');
INSERT INTO `sys_gen_field` VALUES ('202', '24', 'gender', 'tinyint', '性别：0-未知 1-男 2-女', '', '', '0', '0', 'int', 'number', 'gender', '1', '1', '1', '1', '', '', '', 'column:gender;default:0');
INSERT INTO `sys_gen_field` VALUES ('203', '24', 'phone', 'varchar', '手机号', '', '', '0', '0', 'string', 'string', 'phone', '1', '1', '1', '1', '', '', '', 'column:phone');
INSERT INTO `sys_gen_field` VALUES ('204', '24', 'email', 'varchar', '邮箱', '', '', '0', '0', 'string', 'string', 'email', '1', '1', '1', '1', '', '', '', 'column:email');
INSERT INTO `sys_gen_field` VALUES ('205', '24', 'subject', 'varchar', '所教学科', '', '', '0', '0', 'string', 'string', 'subject', '1', '1', '1', '1', '', '', '', 'column:subject');
INSERT INTO `sys_gen_field` VALUES ('206', '24', 'title', 'varchar', '职称', '', '', '0', '0', 'string', 'string', 'title', '1', '1', '1', '1', '', '', '', 'column:title');
INSERT INTO `sys_gen_field` VALUES ('207', '24', 'status', 'tinyint', '状态：0-离职 1-在职', '', '', '0', '0', 'int', 'number', 'status', '1', '1', '1', '1', '', '', '', 'column:status;default:1');
INSERT INTO `sys_gen_field` VALUES ('208', '24', 'hire_date', 'date', '入职日期', '', '', '0', '0', 'time.Time', 'string', 'hire_date', '1', '1', '1', '1', '', '', '', 'column:hire_date');
INSERT INTO `sys_gen_field` VALUES ('209', '24', 'birth_date', 'date', '出生日期', '', '', '0', '0', 'time.Time', 'string', 'birth_date', '1', '1', '1', '1', '', '', '', 'column:birth_date');
INSERT INTO `sys_gen_field` VALUES ('210', '24', 'created_at', 'datetime', '创建时间', '', '', '0', '0', 'time.Time', 'string', 'created_at', null, null, null, null, '', '', '', 'column:created_at');
INSERT INTO `sys_gen_field` VALUES ('211', '24', 'updated_at', 'datetime', '更新时间', '', '', '0', '0', 'time.Time', 'string', 'updated_at', null, null, null, null, '', '', '', 'column:updated_at');
INSERT INTO `sys_gen_field` VALUES ('212', '24', 'deleted_at', 'datetime', '删除时间', '', '', '0', '0', 'time.Time', 'string', 'deleted_at', null, null, null, null, '', '', '', 'column:deleted_at');
INSERT INTO `sys_gen_field` VALUES ('213', '24', 'created_by', 'int', '创建人', '', '', '1', '0', 'uint', 'number', 'created_by', null, null, null, null, '', '', '', 'column:created_by');

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
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_parent_id` (`parent_id`) USING BTREE,
  KEY `idx_sort` (`sort`) USING BTREE,
  KEY `idx_type` (`type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=140325 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='系统菜单路由表';

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
INSERT INTO `sys_menu` VALUES ('140321', '0', '/plugins/testbook/teststudentslist', 'Pluginstestbookteststudents', '', 'plugins/testbook/views/teststudentslist', '学员管理', '0', '0', '0', '1', '0', '', '0', '', 'IconMenu', '0', '2', '0', '', '2025-11-13 16:41:40', '2025-11-13 16:41:40', null, '1');
INSERT INTO `sys_menu` VALUES ('140322', '140321', '', '', '', '', '新增', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'plugins:testbookteststudents:add', '2025-11-13 16:41:40', '2025-11-13 16:41:40', null, '1');
INSERT INTO `sys_menu` VALUES ('140323', '140321', '', '', '', '', '编辑', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'plugins:testbookteststudents:edit', '2025-11-13 16:41:40', '2025-11-13 16:41:40', null, '1');
INSERT INTO `sys_menu` VALUES ('140324', '140321', '', '', '', '', '删除', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'plugins:testbookteststudents:delete', '2025-11-13 16:41:40', '2025-11-13 16:41:40', null, '1');

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
INSERT INTO `sys_menu_api` VALUES ('140265', '105');
INSERT INTO `sys_menu_api` VALUES ('140265', '106');
INSERT INTO `sys_menu_api` VALUES ('140321', '177');
INSERT INTO `sys_menu_api` VALUES ('140322', '178');
INSERT INTO `sys_menu_api` VALUES ('140323', '179');
INSERT INTO `sys_menu_api` VALUES ('140323', '181');
INSERT INTO `sys_menu_api` VALUES ('140324', '180');

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
) ENGINE=InnoDB AUTO_INCREMENT=2216 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='系统操作日志表';

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
INSERT INTO `sys_operation_logs` VALUES ('1477', '2025-11-03 09:07:01.000', '2025-11-03 09:07:01.000', null, '0', 'admin', '其他', 'login', 'POST', '/api/login', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"captchaId\":\"AztmSg5LCUPgxPF2Ocsa\",\"captchaValue\":null,\"password\":\"***\",\"tenantCode\":\"\",\"username\":\"admin\"}', '', '200', '133', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1478', '2025-11-03 09:07:01.000', '2025-11-03 09:07:01.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '52', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1479', '2025-11-03 09:07:01.000', '2025-11-03 09:07:01.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '12', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1480', '2025-11-03 09:07:01.000', '2025-11-03 09:07:01.000', null, '1', 'admin', '字典管理', 'query', 'GET', '/api/sysDict/getAllDicts', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '13', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1481', '2025-11-03 09:07:07.000', '2025-11-03 09:07:07.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getRoles', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '10', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1482', '2025-11-03 09:07:07.000', '2025-11-03 09:07:07.000', null, '1', 'admin', '部门管理', 'query', 'GET', '/api/sysDepartment/getDivision', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '9', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1483', '2025-11-03 09:07:07.000', '2025-11-03 09:07:07.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '35', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1484', '2025-11-03 09:19:50.000', '2025-11-03 09:19:50.000', null, '1', 'admin', '部门管理', 'query', 'GET', '/api/sysDepartment/getDivision', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1485', '2025-11-03 09:19:50.000', '2025-11-03 09:19:50.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getRoles', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1486', '2025-11-03 09:19:50.000', '2025-11-03 09:19:50.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '8', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1487', '2025-11-03 09:20:50.000', '2025-11-03 09:20:50.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '53', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1488', '2025-11-03 09:20:50.000', '2025-11-03 09:20:50.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '159', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1489', '2025-11-03 09:20:57.000', '2025-11-03 09:20:57.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getRoles', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '12', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1490', '2025-11-03 09:20:57.000', '2025-11-03 09:20:57.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '15', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1491', '2025-11-03 09:20:57.000', '2025-11-03 09:20:57.000', null, '1', 'admin', '部门管理', 'query', 'GET', '/api/sysDepartment/getDivision', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '11', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1492', '2025-11-03 09:21:00.000', '2025-11-03 09:21:00.000', null, '1', 'admin', '用户管理', 'create', 'POST', '/api/users/logout', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1493', '2025-11-03 09:21:02.000', '2025-11-03 09:21:02.000', null, '0', 'admin', '其他', 'login', 'POST', '/api/login', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"captchaId\":\"9gO7EzrdZxlIAnL8MItt\",\"captchaValue\":null,\"password\":\"***\",\"tenantCode\":\"\",\"username\":\"admin\"}', '', '200', '92', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1494', '2025-11-03 09:21:02.000', '2025-11-03 09:21:02.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '9', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1495', '2025-11-03 09:21:02.000', '2025-11-03 09:21:02.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1496', '2025-11-03 09:21:02.000', '2025-11-03 09:21:02.000', null, '1', 'admin', '字典管理', 'query', 'GET', '/api/sysDict/getAllDicts', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '5', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1497', '2025-11-03 09:21:05.000', '2025-11-03 09:21:05.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getRoles', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1498', '2025-11-03 09:21:05.000', '2025-11-03 09:21:05.000', null, '1', 'admin', '部门管理', 'query', 'GET', '/api/sysDepartment/getDivision', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1499', '2025-11-03 09:21:05.000', '2025-11-03 09:21:05.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '5', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1500', '2025-11-03 09:21:07.000', '2025-11-03 09:21:07.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getRoles', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1501', '2025-11-03 09:21:07.000', '2025-11-03 09:21:07.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '23', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1502', '2025-11-03 09:29:45.000', '2025-11-03 09:29:45.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '23', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1503', '2025-11-03 09:29:45.000', '2025-11-03 09:29:45.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '61', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1504', '2025-11-03 09:29:46.000', '2025-11-03 09:29:46.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getRoles', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '62', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1505', '2025-11-03 09:29:46.000', '2025-11-03 09:29:46.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '129', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1506', '2025-11-03 09:29:47.000', '2025-11-03 09:29:47.000', null, '1', 'admin', '部门管理', 'query', 'GET', '/api/sysDepartment/getDivision', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '6', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1507', '2025-11-03 09:29:47.000', '2025-11-03 09:29:47.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getRoles', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '5', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1508', '2025-11-03 09:29:47.000', '2025-11-03 09:29:47.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '23', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1509', '2025-11-03 09:30:33.000', '2025-11-03 09:30:33.000', null, '1', 'admin', '用户管理', 'create', 'POST', '/api/users/logout', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1510', '2025-11-03 10:58:30.000', '2025-11-03 10:58:30.000', null, '0', 'admin', '其他', 'login', 'POST', '/api/login', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"captchaId\":\"aVi1iL5egb9IGCmotMvk\",\"captchaValue\":null,\"password\":\"***\",\"tenantCode\":\"\",\"username\":\"admin\"}', '', '200', '151', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1511', '2025-11-03 10:58:30.000', '2025-11-03 10:58:30.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '32', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1512', '2025-11-03 10:58:30.000', '2025-11-03 10:58:30.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '8', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1513', '2025-11-03 10:58:30.000', '2025-11-03 10:58:30.000', null, '1', 'admin', '字典管理', 'query', 'GET', '/api/sysDict/getAllDicts', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1514', '2025-11-03 10:58:59.000', '2025-11-03 10:58:59.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '57', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1515', '2025-11-03 10:58:59.000', '2025-11-03 10:58:59.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '306', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1516', '2025-11-03 10:59:04.000', '2025-11-03 10:59:04.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getRoles', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '14', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1517', '2025-11-03 10:59:04.000', '2025-11-03 10:59:04.000', null, '1', 'admin', '部门管理', 'query', 'GET', '/api/sysDepartment/getDivision', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '25', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1518', '2025-11-03 10:59:04.000', '2025-11-03 10:59:04.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '40', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1519', '2025-11-03 10:59:19.000', '2025-11-03 10:59:19.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getRoles', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1520', '2025-11-03 10:59:19.000', '2025-11-03 10:59:19.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '22', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1521', '2025-11-03 10:59:25.000', '2025-11-03 10:59:25.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '10', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1522', '2025-11-03 11:00:01.000', '2025-11-03 11:00:01.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/sysTenant/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '46', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1523', '2025-11-03 11:15:58.000', '2025-11-03 11:15:58.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '65', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1524', '2025-11-03 11:15:58.000', '2025-11-03 11:15:58.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '199', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1525', '2025-11-03 11:15:59.000', '2025-11-03 11:15:59.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/sysTenant/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '79', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1526', '2025-11-03 11:16:45.000', '2025-11-03 11:16:45.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/sysTenant/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"code\":\"dom1\",\"description\":\"\",\"domain\":\"\",\"name\":\"测试租户1\",\"status\":1}', '', '200', '16', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1527', '2025-11-03 11:16:45.000', '2025-11-03 11:16:45.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/sysTenant/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '5', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1528', '2025-11-03 11:16:46.000', '2025-11-03 11:16:46.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/sysUserTenant/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '18', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1529', '2025-11-03 11:20:03.000', '2025-11-03 11:20:03.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/sysUserTenant/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1530', '2025-11-03 11:20:09.000', '2025-11-03 11:20:09.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/sysTenant/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1531', '2025-11-03 11:20:10.000', '2025-11-03 11:20:10.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/sysUserTenant/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1532', '2025-11-04 09:02:06.000', '2025-11-04 09:02:06.000', null, '0', 'admin', '其他', 'login', 'POST', '/api/login', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"captchaId\":\"iiuRhEr8MJuniYTtRop7\",\"captchaValue\":\"2459\",\"password\":\"***\",\"tenantCode\":\"\",\"username\":\"admin\"}', '', '200', '124', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1533', '2025-11-04 09:02:06.000', '2025-11-04 09:02:06.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '25', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1534', '2025-11-04 09:02:06.000', '2025-11-04 09:02:06.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1535', '2025-11-04 09:02:06.000', '2025-11-04 09:02:06.000', null, '1', 'admin', '字典管理', 'query', 'GET', '/api/sysDict/getAllDicts', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '11', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1536', '2025-11-04 10:45:36.000', '2025-11-04 10:45:36.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '11', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1537', '2025-11-04 10:45:36.000', '2025-11-04 10:45:36.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1538', '2025-11-04 10:47:28.000', '2025-11-04 10:47:28.000', null, '1', 'admin', '用户管理', 'create', 'POST', '/api/users/logout', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '22', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1539', '2025-11-04 10:47:40.000', '2025-11-04 10:47:40.000', null, '0', 'admin', '其他', 'login', 'POST', '/api/login', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"captchaId\":\"fomczZih8NuU15cPgIYS\",\"captchaValue\":null,\"password\":\"***\",\"tenantCode\":\"\",\"username\":\"admin\"}', '', '200', '99', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1540', '2025-11-04 10:47:40.000', '2025-11-04 10:47:40.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '11', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1541', '2025-11-04 10:47:40.000', '2025-11-04 10:47:40.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1542', '2025-11-04 10:47:40.000', '2025-11-04 10:47:40.000', null, '1', 'admin', '字典管理', 'query', 'GET', '/api/sysDict/getAllDicts', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '19', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1543', '2025-11-04 10:47:48.000', '2025-11-04 10:47:48.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '15', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1544', '2025-11-04 10:48:01.000', '2025-11-04 10:48:01.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '8', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1545', '2025-11-04 10:48:01.000', '2025-11-04 10:48:01.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '32', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1546', '2025-11-04 10:48:02.000', '2025-11-04 10:48:02.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '27', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1547', '2025-11-04 10:48:21.000', '2025-11-04 10:48:21.000', null, '0', 'admin', '其他', 'login', 'POST', '/api/login', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"password\":\"***\",\"username\":\"admin\"}', '', '200', '100', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1548', '2025-11-04 10:48:23.000', '2025-11-04 10:48:23.000', null, '1', 'admin', '用户管理', 'create', 'POST', '/api/users/logout', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1549', '2025-11-04 10:49:06.000', '2025-11-04 10:49:06.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '', '', '200', '7', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1550', '2025-11-04 10:52:59.000', '2025-11-04 10:52:59.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/codegen/databases', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '', '', '403', '2', '您没有权限访问此资源', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1551', '2025-11-04 10:54:36.000', '2025-11-04 10:54:36.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/codegen/databases', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1552', '2025-11-04 10:57:10.000', '2025-11-04 10:57:10.000', null, '0', 'admin', '其他', 'login', 'POST', '/api/login', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"password\":\"***\",\"username\":\"admin\"}', '', '200', '101', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1553', '2025-11-04 10:57:44.000', '2025-11-04 10:57:44.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/codegen/databases', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1554', '2025-11-04 10:59:03.000', '2025-11-04 10:59:03.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/codegen/tables', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1555', '2025-11-04 11:07:41.000', '2025-11-04 11:07:41.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/codegen/columns', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '', '', '200', '5', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1556', '2025-11-04 11:39:00.000', '2025-11-04 11:39:00.000', null, '0', 'admin', '其他', 'login', 'POST', '/api/login', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"captchaId\":\"Dqc0lGb4glgsLA2nDtWy\",\"captchaValue\":null,\"password\":\"***\",\"tenantCode\":\"\",\"username\":\"admin\"}', '', '200', '112', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1557', '2025-11-04 11:39:00.000', '2025-11-04 11:39:00.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '26', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1558', '2025-11-04 11:39:00.000', '2025-11-04 11:39:00.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1559', '2025-11-04 11:39:00.000', '2025-11-04 11:39:00.000', null, '1', 'admin', '字典管理', 'query', 'GET', '/api/sysDict/getAllDicts', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '48', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1560', '2025-11-04 11:39:36.000', '2025-11-04 11:39:36.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '34', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1561', '2025-11-04 11:43:25.000', '2025-11-04 11:43:25.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '10', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1562', '2025-11-04 11:45:49.000', '2025-11-04 11:45:49.000', null, '1', 'admin', '菜单管理', 'create', 'POST', '/api/sysMenu/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"affix\":false,\"component\":\"system/codegen/codegen\",\"disable\":false,\"hide\":false,\"icon\":\"IconCode\",\"id\":0,\"iframe\":false,\"isFull\":false,\"isLink\":false,\"keepAlive\":true,\"link\":\"\",\"name\":\"SystemCodegen\",\"parentId\":10,\"path\":\"/system/codegen\",\"permission\":\"\",\"redirect\":\"\",\"sort\":1,\"svgIcon\":\"\",\"title\":\"codegen\",\"type\":2}', '', '200', '94', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1563', '2025-11-04 11:45:49.000', '2025-11-04 11:45:49.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '9', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1564', '2025-11-04 11:46:00.000', '2025-11-04 11:46:00.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '28', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1565', '2025-11-04 11:46:00.000', '2025-11-04 11:46:00.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '30', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1566', '2025-11-04 11:46:01.000', '2025-11-04 11:46:01.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '35', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1567', '2025-11-04 11:46:05.000', '2025-11-04 11:46:05.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/codegen/databases', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1568', '2025-11-04 11:46:17.000', '2025-11-04 11:46:17.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/sysTenant/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '34', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1569', '2025-11-04 11:46:23.000', '2025-11-04 11:46:23.000', null, '1', 'admin', '部门管理', 'query', 'GET', '/api/sysDepartment/getDivision', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1570', '2025-11-04 11:46:23.000', '2025-11-04 11:46:23.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getRoles', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '5', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1571', '2025-11-04 11:46:23.000', '2025-11-04 11:46:23.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '11', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1572', '2025-11-04 11:46:26.000', '2025-11-04 11:46:26.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getRoles', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1573', '2025-11-04 11:46:26.000', '2025-11-04 11:46:26.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '8', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1574', '2025-11-04 11:47:58.000', '2025-11-04 11:47:58.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '23', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1575', '2025-11-04 11:47:58.000', '2025-11-04 11:47:58.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '28', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1576', '2025-11-04 11:47:59.000', '2025-11-04 11:47:59.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/codegen/databases', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '63', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1577', '2025-11-04 11:48:00.000', '2025-11-04 11:48:00.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1578', '2025-11-04 11:48:00.000', '2025-11-04 11:48:00.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '8', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1579', '2025-11-04 11:48:00.000', '2025-11-04 11:48:00.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '7', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1580', '2025-11-04 11:48:13.000', '2025-11-04 11:48:13.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '18', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1581', '2025-11-04 11:48:13.000', '2025-11-04 11:48:13.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '15', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1582', '2025-11-04 11:48:14.000', '2025-11-04 11:48:14.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '11', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1583', '2025-11-04 11:48:14.000', '2025-11-04 11:48:14.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '31', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1584', '2025-11-04 11:48:14.000', '2025-11-04 11:48:14.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/codegen/databases', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '130', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1585', '2025-11-04 11:48:15.000', '2025-11-04 11:48:15.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '44', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1586', '2025-11-04 11:48:57.000', '2025-11-04 11:48:57.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1587', '2025-11-04 11:48:57.000', '2025-11-04 11:48:57.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '47', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1588', '2025-11-04 11:48:57.000', '2025-11-04 11:48:57.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/codegen/databases', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '6', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1589', '2025-11-04 11:51:11.000', '2025-11-04 11:51:11.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/codegen/databases', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1590', '2025-11-04 11:51:14.000', '2025-11-04 11:51:14.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '17', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1591', '2025-11-04 11:51:14.000', '2025-11-04 11:51:14.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '34', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1592', '2025-11-04 11:51:14.000', '2025-11-04 11:51:14.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/codegen/databases', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '6', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1593', '2025-11-04 11:51:54.000', '2025-11-04 11:51:54.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '82', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1594', '2025-11-04 11:51:54.000', '2025-11-04 11:51:54.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '125', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1595', '2025-11-04 11:51:55.000', '2025-11-04 11:51:55.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/codegen/databases', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '9', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1596', '2025-11-04 11:54:48.000', '2025-11-04 11:54:48.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/codegen/tables', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1597', '2025-11-04 11:55:06.000', '2025-11-04 11:55:06.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/codegen/tables', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '8', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1598', '2025-11-04 11:57:04.000', '2025-11-04 11:57:04.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/codegen/columns', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '6', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1599', '2025-11-04 11:57:12.000', '2025-11-04 11:57:12.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/codegen/columns', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '11', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1600', '2025-11-04 14:54:37.000', '2025-11-04 14:54:37.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '', '', '400', '1', 'EOF', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1601', '2025-11-04 14:55:57.000', '2025-11-04 14:55:57.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"sys_affix\"}', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1602', '2025-11-04 15:42:04.000', '2025-11-04 15:42:04.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"sys_affix\"}', '', '200', '7', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1603', '2025-11-04 16:10:40.000', '2025-11-04 16:10:40.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/codegen/preview', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1604', '2025-11-04 16:19:40.000', '2025-11-04 16:19:40.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"sys_affix\"}', '', '200', '60', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1605', '2025-11-04 16:33:18.000', '2025-11-04 16:33:18.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"sys_affix\"}', '', '200', '48', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1606', '2025-11-04 16:33:43.000', '2025-11-04 16:33:43.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"sys_affix\"}', '', '200', '9', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1607', '2025-11-04 16:49:08.000', '2025-11-04 16:49:08.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"sys_affix\"}', '', '200', '52', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1608', '2025-11-04 17:36:12.000', '2025-11-04 17:36:12.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '63', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1609', '2025-11-04 17:36:12.000', '2025-11-04 17:36:12.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '114', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1610', '2025-11-04 17:36:13.000', '2025-11-04 17:36:13.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/codegen/databases', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1611', '2025-11-04 17:37:18.000', '2025-11-04 17:37:18.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1612', '2025-11-04 17:37:23.000', '2025-11-04 17:37:23.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/plugins/example/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"description\":\"3312\",\"id\":0,\"name\":\"123\"}', '', '200', '8', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1613', '2025-11-04 17:37:23.000', '2025-11-04 17:37:23.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1614', '2025-11-04 17:37:29.000', '2025-11-04 17:37:29.000', null, '1', 'admin', '其他', 'update', 'PUT', '/api/plugins/example/edit', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"createdAt\":\"2025-11-04T17:37:23+08:00\",\"createdBy\":1,\"deletedAt\":null,\"description\":\"bbb\",\"id\":1,\"name\":\"aaa\",\"tenantID\":0,\"updatedAt\":\"2025-11-04T17:37:23+08:00\"}', '', '200', '35', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1615', '2025-11-04 17:37:29.000', '2025-11-04 17:37:29.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1616', '2025-11-04 17:37:39.000', '2025-11-04 17:37:39.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/plugins/example/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"createdAt\":\"2025-11-04T17:37:23+08:00\",\"createdBy\":1,\"deletedAt\":null,\"description\":\"bbb\",\"id\":0,\"name\":\"bbb\",\"tenantID\":0,\"updatedAt\":\"2025-11-04T17:37:23+08:00\"}', '', '200', '12', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1617', '2025-11-04 17:37:39.000', '2025-11-04 17:37:39.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1618', '2025-11-04 17:37:41.000', '2025-11-04 17:37:41.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1619', '2025-11-04 17:37:42.000', '2025-11-04 17:37:42.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1620', '2025-11-04 17:37:46.000', '2025-11-04 17:37:46.000', null, '1', 'admin', '其他', 'delete', 'DELETE', '/api/plugins/example/delete', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"id\":1}', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1621', '2025-11-04 17:37:46.000', '2025-11-04 17:37:46.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1622', '2025-11-04 17:54:04.000', '2025-11-04 17:54:04.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '53', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1623', '2025-11-04 17:58:21.000', '2025-11-04 17:58:21.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '27', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1624', '2025-11-04 17:58:21.000', '2025-11-04 17:58:21.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '458', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1625', '2025-11-04 18:06:09.000', '2025-11-04 18:06:09.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '10', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1626', '2025-11-04 18:06:09.000', '2025-11-04 18:06:09.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '102', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1627', '2025-11-04 18:06:10.000', '2025-11-04 18:06:10.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '90', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1628', '2025-11-04 18:06:13.000', '2025-11-04 18:06:13.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/2', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '400', '15', 'ID不能为空', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1629', '2025-11-04 18:09:21.000', '2025-11-04 18:09:21.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '20', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1630', '2025-11-04 18:09:27.000', '2025-11-04 18:09:27.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '9', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1631', '2025-11-04 18:10:02.000', '2025-11-04 18:10:02.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '46', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1632', '2025-11-04 18:10:34.000', '2025-11-04 18:10:34.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '48', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1633', '2025-11-04 18:10:34.000', '2025-11-04 18:10:34.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '152', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1634', '2025-11-04 18:10:35.000', '2025-11-04 18:10:35.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '16', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1635', '2025-11-04 18:10:37.000', '2025-11-04 18:10:37.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/get', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '0', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1636', '2025-11-05 08:52:22.000', '2025-11-05 08:52:22.000', null, '0', 'admin', '其他', 'login', 'POST', '/api/login', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"captchaId\":\"WkXCRHWG7y6rIYaSVc4g\",\"captchaValue\":null,\"password\":\"***\",\"tenantCode\":\"\",\"username\":\"admin\"}', '', '200', '114', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1637', '2025-11-05 08:52:22.000', '2025-11-05 08:52:22.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '76', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1638', '2025-11-05 08:52:22.000', '2025-11-05 08:52:22.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1639', '2025-11-05 08:52:22.000', '2025-11-05 08:52:22.000', null, '1', 'admin', '字典管理', 'query', 'GET', '/api/sysDict/getAllDicts', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '31', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1640', '2025-11-05 08:54:34.000', '2025-11-05 08:54:34.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '14902', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1641', '2025-11-05 08:54:38.000', '2025-11-05 08:54:38.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '91', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1642', '2025-11-05 08:54:38.000', '2025-11-05 08:54:38.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '83', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1643', '2025-11-05 08:54:39.000', '2025-11-05 08:54:39.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '13', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1644', '2025-11-05 08:58:58.000', '2025-11-05 08:58:58.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/2', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '8966', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1645', '2025-11-05 09:02:07.000', '2025-11-05 09:02:07.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '16', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1646', '2025-11-05 09:35:21.000', '2025-11-05 09:35:21.000', null, '0', 'admin', '其他', 'login', 'POST', '/api/login', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"password\":\"***\",\"username\":\"admin\"}', '', '200', '96', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1647', '2025-11-05 09:37:28.000', '2025-11-05 09:37:28.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"sys_affix\"}', '', '200', '56', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1648', '2025-11-05 09:50:55.000', '2025-11-05 09:50:55.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"sys_affix\"}', '', '200', '38', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1649', '2025-11-05 10:04:56.000', '2025-11-05 10:04:56.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '167', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1650', '2025-11-05 10:04:56.000', '2025-11-05 10:04:56.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '245', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1651', '2025-11-05 10:04:58.000', '2025-11-05 10:04:58.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '19', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1652', '2025-11-05 10:05:02.000', '2025-11-05 10:05:02.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/2', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1653', '2025-11-05 10:16:51.000', '2025-11-05 10:16:51.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '24', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1654', '2025-11-05 10:16:51.000', '2025-11-05 10:16:51.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '82', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1655', '2025-11-05 10:16:52.000', '2025-11-05 10:16:52.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '11', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1656', '2025-11-05 10:16:59.000', '2025-11-05 10:16:59.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/plugins/example/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"description\":\"aaa\",\"id\":0,\"name\":\"aaa\"}', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1657', '2025-11-05 10:16:59.000', '2025-11-05 10:16:59.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '10', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1658', '2025-11-05 10:17:01.000', '2025-11-05 10:17:01.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1659', '2025-11-05 10:23:28.000', '2025-11-05 10:23:28.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1660', '2025-11-05 10:27:14.000', '2025-11-05 10:27:14.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '23', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1661', '2025-11-05 10:27:14.000', '2025-11-05 10:27:14.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '82', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1662', '2025-11-05 10:27:15.000', '2025-11-05 10:27:15.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '40', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1663', '2025-11-05 10:27:19.000', '2025-11-05 10:27:19.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '6', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1664', '2025-11-05 10:42:06.000', '2025-11-05 10:42:06.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '8', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1665', '2025-11-05 10:42:06.000', '2025-11-05 10:42:06.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '145', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1666', '2025-11-05 10:42:07.000', '2025-11-05 10:42:07.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '400', '53', 'unsupported data type: 0xc000e3f428: Table not set, please set it like: db.Model(&user) or db.Table(\"users\")', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1667', '2025-11-05 10:42:11.000', '2025-11-05 10:42:11.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '400', '4', 'unsupported data type: 0xc000e3f998: Table not set, please set it like: db.Model(&user) or db.Table(\"users\")', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1668', '2025-11-05 10:43:48.000', '2025-11-05 10:43:48.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '140', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1669', '2025-11-05 10:43:48.000', '2025-11-05 10:43:48.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '37', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1670', '2025-11-05 10:43:49.000', '2025-11-05 10:43:49.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '73', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1671', '2025-11-05 10:43:55.000', '2025-11-05 10:43:55.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1672', '2025-11-05 10:43:56.000', '2025-11-05 10:43:56.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1673', '2025-11-05 10:43:59.000', '2025-11-05 10:43:59.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1674', '2025-11-05 10:44:00.000', '2025-11-05 10:44:00.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1675', '2025-11-05 10:44:09.000', '2025-11-05 10:44:09.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1676', '2025-11-05 10:44:12.000', '2025-11-05 10:44:12.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1677', '2025-11-05 10:47:20.000', '2025-11-05 10:47:20.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"sys_affix\"}', '', '200', '45', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1678', '2025-11-05 10:49:39.000', '2025-11-05 10:49:39.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"sys_affix\"}', '', '200', '69', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1679', '2025-11-05 11:00:23.000', '2025-11-05 11:00:23.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"sys_affix\"}', '', '200', '43', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1680', '2025-11-05 11:00:58.000', '2025-11-05 11:00:58.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"students\"}', '', '200', '91', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1681', '2025-11-05 11:16:53.000', '2025-11-05 11:16:53.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/codegen/tables', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1682', '2025-11-05 11:17:03.000', '2025-11-05 11:17:03.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/codegen/columns', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1683', '2025-11-05 11:24:17.000', '2025-11-05 11:24:17.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"students\"}', '', '200', '86', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1684', '2025-11-05 11:27:42.000', '2025-11-05 11:27:42.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"students\"}', '', '200', '62', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1685', '2025-11-05 11:37:16.000', '2025-11-05 11:37:16.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"students\"}', '', '200', '119', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1686', '2025-11-05 11:39:25.000', '2025-11-05 11:39:25.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"students\"}', '', '200', '79', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1687', '2025-11-05 11:40:50.000', '2025-11-05 11:40:50.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"students\"}', '', '200', '68', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1688', '2025-11-05 11:54:35.000', '2025-11-05 11:54:35.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"students\"}', '', '200', '7110', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1689', '2025-11-05 11:54:46.000', '2025-11-05 11:54:46.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/codegen/columns', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1690', '2025-11-05 14:48:47.000', '2025-11-05 14:48:47.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/codegen/columns', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1691', '2025-11-05 14:49:17.000', '2025-11-05 14:49:17.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"students\"}', '', '200', '10531', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1692', '2025-11-05 15:10:06.000', '2025-11-05 15:10:06.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"students\"}', '', '200', '68', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1693', '2025-11-05 15:26:43.000', '2025-11-05 15:26:43.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"students\"}', '', '200', '9', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1694', '2025-11-05 15:50:09.000', '2025-11-05 15:50:09.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/codegen/columns', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1695', '2025-11-05 15:56:09.000', '2025-11-05 15:56:09.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/codegen/columns', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1696', '2025-11-05 16:19:21.000', '2025-11-05 16:19:21.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"students\"}', '', '200', '110', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1697', '2025-11-05 16:31:12.000', '2025-11-05 16:31:12.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"students\"}', '', '200', '53', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1698', '2025-11-05 16:44:22.000', '2025-11-05 16:44:22.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"students\"}', '', '200', '49', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1699', '2025-11-05 16:47:14.000', '2025-11-05 16:47:14.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"students\"}', '', '200', '9', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1700', '2025-11-05 16:56:30.000', '2025-11-05 16:56:30.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"students\"}', '', '200', '7', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1701', '2025-11-05 17:06:11.000', '2025-11-05 17:06:11.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"students\"}', '', '200', '102', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1702', '2025-11-05 17:10:47.000', '2025-11-05 17:10:47.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"students\"}', '', '200', '11', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1703', '2025-11-05 17:13:03.000', '2025-11-05 17:13:03.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"students\"}', '', '200', '8', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1704', '2025-11-05 17:22:02.000', '2025-11-05 17:22:02.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"students\"}', '', '200', '59', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1705', '2025-11-06 09:33:53.000', '2025-11-06 09:33:53.000', null, '0', 'admin', '其他', 'login', 'POST', '/api/login', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"password\":\"***\",\"username\":\"admin\"}', '', '200', '120', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1706', '2025-11-06 09:34:20.000', '2025-11-06 09:34:20.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"students\"}', '', '200', '182', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1707', '2025-11-06 09:47:53.000', '2025-11-06 09:47:53.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"students\"}', '', '200', '52', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1708', '2025-11-06 09:53:47.000', '2025-11-06 09:53:47.000', null, '0', 'admin', '其他', 'login', 'POST', '/api/login', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"captchaId\":\"NwENIzOon0Ds4SyaPPf2\",\"captchaValue\":null,\"password\":\"***\",\"tenantCode\":\"\",\"username\":\"admin\"}', '', '200', '96', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1709', '2025-11-06 09:53:47.000', '2025-11-06 09:53:47.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '80', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1710', '2025-11-06 09:53:47.000', '2025-11-06 09:53:47.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1711', '2025-11-06 09:53:47.000', '2025-11-06 09:53:47.000', null, '1', 'admin', '字典管理', 'query', 'GET', '/api/sysDict/getAllDicts', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '31', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1712', '2025-11-06 09:54:09.000', '2025-11-06 09:54:09.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '38', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1713', '2025-11-06 09:54:27.000', '2025-11-06 09:54:27.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '9', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1714', '2025-11-06 09:58:03.000', '2025-11-06 09:58:03.000', null, '1', 'admin', '菜单管理', 'create', 'POST', '/api/sysMenu/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"affix\":false,\"component\":\"plugins/students/views/studentslist\",\"disable\":false,\"hide\":false,\"icon\":\"\",\"id\":0,\"iframe\":false,\"isFull\":false,\"isLink\":false,\"keepAlive\":true,\"link\":\"\",\"name\":\"PluginsStudents\",\"parentId\":140247,\"path\":\"/plugins/students\",\"permission\":\"\",\"redirect\":\"\",\"sort\":1,\"svgIcon\":\"\",\"title\":\"学员管理\",\"type\":2}', '', '200', '65', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1715', '2025-11-06 09:58:03.000', '2025-11-06 09:58:03.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '14', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1716', '2025-11-06 09:59:12.000', '2025-11-06 09:59:12.000', null, '1', 'admin', '菜单管理', 'create', 'POST', '/api/sysMenu/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"affix\":false,\"component\":\"\",\"disable\":false,\"hide\":false,\"icon\":\"\",\"id\":0,\"iframe\":false,\"isFull\":false,\"isLink\":false,\"keepAlive\":true,\"link\":\"\",\"name\":\"\",\"parentId\":140266,\"path\":\"\",\"permission\":\"plugins:students:add\",\"redirect\":\"\",\"sort\":1,\"svgIcon\":\"\",\"title\":\"新增\",\"type\":3}', '', '200', '9', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1717', '2025-11-06 09:59:12.000', '2025-11-06 09:59:12.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '14', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1718', '2025-11-06 09:59:40.000', '2025-11-06 09:59:40.000', null, '1', 'admin', '菜单管理', 'create', 'POST', '/api/sysMenu/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"affix\":false,\"component\":\"\",\"disable\":false,\"hide\":false,\"icon\":\"\",\"id\":0,\"iframe\":false,\"isFull\":false,\"isLink\":false,\"keepAlive\":true,\"link\":\"\",\"name\":\"\",\"parentId\":140266,\"path\":\"\",\"permission\":\"plugins:students:edit\",\"redirect\":\"\",\"sort\":1,\"svgIcon\":\"\",\"title\":\"编辑\",\"type\":3}', '', '200', '9', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1719', '2025-11-06 09:59:40.000', '2025-11-06 09:59:40.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '57', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1720', '2025-11-06 10:00:09.000', '2025-11-06 10:00:09.000', null, '1', 'admin', '菜单管理', 'create', 'POST', '/api/sysMenu/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"affix\":false,\"component\":\"\",\"disable\":false,\"hide\":false,\"icon\":\"\",\"id\":0,\"iframe\":false,\"isFull\":false,\"isLink\":false,\"keepAlive\":true,\"link\":\"\",\"name\":\"\",\"parentId\":140266,\"path\":\"\",\"permission\":\"plugins:example:delete\",\"redirect\":\"\",\"sort\":1,\"svgIcon\":\"\",\"title\":\"删除\",\"type\":3}', '', '400', '2', '按钮权限标识已存在', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1721', '2025-11-06 10:00:18.000', '2025-11-06 10:00:18.000', null, '1', 'admin', '菜单管理', 'create', 'POST', '/api/sysMenu/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"affix\":false,\"component\":\"\",\"disable\":false,\"hide\":false,\"icon\":\"\",\"id\":0,\"iframe\":false,\"isFull\":false,\"isLink\":false,\"keepAlive\":true,\"link\":\"\",\"name\":\"\",\"parentId\":140266,\"path\":\"\",\"permission\":\"plugins:students:delete\",\"redirect\":\"\",\"sort\":1,\"svgIcon\":\"\",\"title\":\"删除\",\"type\":3}', '', '200', '10', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1722', '2025-11-06 10:00:18.000', '2025-11-06 10:00:18.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '44', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1723', '2025-11-06 10:00:24.000', '2025-11-06 10:00:24.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1724', '2025-11-06 10:01:14.000', '2025-11-06 10:01:14.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '8', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1725', '2025-11-06 10:01:19.000', '2025-11-06 10:01:19.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1726', '2025-11-06 10:01:21.000', '2025-11-06 10:01:21.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '7', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1727', '2025-11-06 10:01:23.000', '2025-11-06 10:01:23.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/66', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1728', '2025-11-06 10:01:47.000', '2025-11-06 10:01:47.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '6', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1729', '2025-11-06 10:01:50.000', '2025-11-06 10:01:50.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/65', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '0', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1730', '2025-11-06 10:03:02.000', '2025-11-06 10:03:02.000', null, '1', 'admin', 'API管理', 'create', 'POST', '/api/sysApi/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"apiGroup\":\"学员管理\",\"method\":\"GET\",\"path\":\"/api/plugins/students/list\",\"title\":\"列表查询\"}', '', '200', '9', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1731', '2025-11-06 10:03:02.000', '2025-11-06 10:03:02.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '48', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1732', '2025-11-06 10:03:45.000', '2025-11-06 10:03:45.000', null, '1', 'admin', 'API管理', 'create', 'POST', '/api/sysApi/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"apiGroup\":\"学员管理\",\"method\":\"POST\",\"path\":\"/api/plugins/students/add\",\"title\":\"新增\"}', '', '200', '9', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1733', '2025-11-06 10:03:46.000', '2025-11-06 10:03:46.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '33', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1734', '2025-11-06 10:04:07.000', '2025-11-06 10:04:07.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/90', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1735', '2025-11-06 10:04:44.000', '2025-11-06 10:04:44.000', null, '1', 'admin', 'API管理', 'create', 'POST', '/api/sysApi/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"apiGroup\":\"学员管理\",\"method\":\"PUT\",\"path\":\"/api/plugins/students/edit\",\"title\":\"修改\"}', '', '200', '8', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1736', '2025-11-06 10:04:44.000', '2025-11-06 10:04:44.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '12', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1737', '2025-11-06 10:05:01.000', '2025-11-06 10:05:01.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/68', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1738', '2025-11-06 10:05:39.000', '2025-11-06 10:05:39.000', null, '1', 'admin', 'API管理', 'create', 'POST', '/api/sysApi/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"apiGroup\":\"学员管理\",\"method\":\"DELETE\",\"path\":\"/api/plugins/students/delete\",\"title\":\"删除\"}', '', '200', '9', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1739', '2025-11-06 10:05:39.000', '2025-11-06 10:05:39.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '5', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1740', '2025-11-06 10:05:50.000', '2025-11-06 10:05:50.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/93', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1741', '2025-11-06 10:06:35.000', '2025-11-06 10:06:35.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/69', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1742', '2025-11-06 10:07:00.000', '2025-11-06 10:07:00.000', null, '1', 'admin', 'API管理', 'create', 'POST', '/api/sysApi/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"apiGroup\":\"学员管理\",\"method\":\"GET\",\"path\":\"/api/plugins/students/:id\",\"title\":\"查询单条数据\"}', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1743', '2025-11-06 10:07:00.000', '2025-11-06 10:07:00.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '16', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1744', '2025-11-06 10:09:13.000', '2025-11-06 10:09:13.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/apis/140266', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '7', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1745', '2025-11-06 10:09:13.000', '2025-11-06 10:09:13.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '9', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1746', '2025-11-06 10:09:19.000', '2025-11-06 10:09:19.000', null, '1', 'admin', '菜单管理', 'create', 'POST', '/api/sysMenu/setApis', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"apiIds\":[90],\"menuId\":140266}', '', '200', '14', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1747', '2025-11-06 10:09:19.000', '2025-11-06 10:09:19.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '6', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1748', '2025-11-06 10:09:25.000', '2025-11-06 10:09:25.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/apis/140266', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1749', '2025-11-06 10:09:26.000', '2025-11-06 10:09:26.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '11', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1750', '2025-11-06 10:09:56.000', '2025-11-06 10:09:56.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/apis/140269', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1751', '2025-11-06 10:09:56.000', '2025-11-06 10:09:56.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '7', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1752', '2025-11-06 10:10:00.000', '2025-11-06 10:10:00.000', null, '1', 'admin', '菜单管理', 'create', 'POST', '/api/sysMenu/setApis', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"apiIds\":[93],\"menuId\":140269}', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1753', '2025-11-06 10:10:00.000', '2025-11-06 10:10:00.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '7', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1754', '2025-11-06 10:10:02.000', '2025-11-06 10:10:02.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/apis/140267', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1755', '2025-11-06 10:10:02.000', '2025-11-06 10:10:02.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '5', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1756', '2025-11-06 10:10:06.000', '2025-11-06 10:10:06.000', null, '1', 'admin', '菜单管理', 'create', 'POST', '/api/sysMenu/setApis', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"apiIds\":[91],\"menuId\":140267}', '', '200', '9', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1757', '2025-11-06 10:10:06.000', '2025-11-06 10:10:06.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '8', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1758', '2025-11-06 10:10:07.000', '2025-11-06 10:10:07.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/apis/140268', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1759', '2025-11-06 10:10:07.000', '2025-11-06 10:10:07.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '6', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1760', '2025-11-06 10:10:12.000', '2025-11-06 10:10:12.000', null, '1', 'admin', '菜单管理', 'create', 'POST', '/api/sysMenu/setApis', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"apiIds\":[92],\"menuId\":140268}', '', '200', '9', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1761', '2025-11-06 10:10:12.000', '2025-11-06 10:10:12.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '7', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1762', '2025-11-06 10:11:28.000', '2025-11-06 10:11:28.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '37', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1763', '2025-11-06 10:11:28.000', '2025-11-06 10:11:28.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '168', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1764', '2025-11-06 10:11:28.000', '2025-11-06 10:11:28.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '14', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1765', '2025-11-06 10:12:03.000', '2025-11-06 10:12:03.000', null, '1', 'admin', '菜单管理', 'update', 'PUT', '/api/sysMenu/edit', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"affix\":false,\"apis\":[{\"apiGroup\":\"学员管理\",\"createdAt\":\"2025-11-06T10:03:02+08:00\",\"createdBy\":1,\"deletedAt\":null,\"id\":90,\"method\":\"GET\",\"path\":\"/api/plugins/students/list\",\"sysMenuList\":null,\"title\":\"列表查询\",\"updatedAt\":\"2025-11-06T10:03:02+08:00\"}],\"component\":\"plugins/students/views/studentslist\",\"createdAt\":\"2025-11-06T09:58:03+08:00\",\"createdBy\":1,\"deletedAt\":null,\"disable\":false,\"hide\":false,\"i18n\":\"学员管理\",\"icon\":\"IconMenu\",\"id\":140266,\"iframe\":false,\"isFull\":false,\"isLink\":false,\"keepAlive\":true,\"link\":\"\",\"name\":\"PluginsStudents\",\"parentId\":140247,\"path\":\"/plugins/students\",\"permission\":\"\",\"redirect\":\"\",\"sort\":1,\"svgIcon\":\"\",\"title\":\"学员管理\",\"type\":2,\"updatedAt\":\"2025-11-06T09:58:03+08:00\"}', '', '200', '11', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1766', '2025-11-06 10:12:04.000', '2025-11-06 10:12:04.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '42', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1767', '2025-11-06 10:12:07.000', '2025-11-06 10:12:07.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '12', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1768', '2025-11-06 10:12:07.000', '2025-11-06 10:12:07.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '81', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1769', '2025-11-06 10:12:07.000', '2025-11-06 10:12:07.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '14', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1770', '2025-11-06 10:12:11.000', '2025-11-06 10:12:11.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '400', '3', 'Error 1054 (42S22): Unknown column \'id\' in \'order clause\'', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1771', '2025-11-06 10:16:39.000', '2025-11-06 10:16:39.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/codegen/databases', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '6', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1772', '2025-11-06 10:16:41.000', '2025-11-06 10:16:41.000', null, '1', 'admin', '部门管理', 'query', 'GET', '/api/sysDepartment/getDivision', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '7', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1773', '2025-11-06 10:16:41.000', '2025-11-06 10:16:41.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getRoles', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '9', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1774', '2025-11-06 10:16:41.000', '2025-11-06 10:16:41.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '78', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1775', '2025-11-06 10:16:44.000', '2025-11-06 10:16:44.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getRoles', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '41', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1776', '2025-11-06 10:16:45.000', '2025-11-06 10:16:45.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '42', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1777', '2025-11-06 10:16:50.000', '2025-11-06 10:16:50.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '7', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1778', '2025-11-06 10:16:53.000', '2025-11-06 10:16:53.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '39', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1779', '2025-11-06 10:16:55.000', '2025-11-06 10:16:55.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1780', '2025-11-06 10:16:56.000', '2025-11-06 10:16:56.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '8', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1781', '2025-11-06 10:16:58.000', '2025-11-06 10:16:58.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1782', '2025-11-06 10:16:59.000', '2025-11-06 10:16:59.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1783', '2025-11-06 10:17:02.000', '2025-11-06 10:17:02.000', null, '1', 'admin', '文件管理', 'query', 'GET', '/api/sysAffix/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '13', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1784', '2025-11-06 10:18:22.000', '2025-11-06 10:18:22.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '22', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1785', '2025-11-06 10:18:22.000', '2025-11-06 10:18:22.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '231', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1786', '2025-11-06 10:18:23.000', '2025-11-06 10:18:23.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '38', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1787', '2025-11-06 10:19:34.000', '2025-11-06 10:19:34.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1788', '2025-11-06 10:24:07.000', '2025-11-06 10:24:07.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '13', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1789', '2025-11-06 10:24:45.000', '2025-11-06 10:24:45.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '86', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1790', '2025-11-06 10:25:10.000', '2025-11-06 10:25:10.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getRoles', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '10', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1791', '2025-11-06 10:25:10.000', '2025-11-06 10:25:10.000', null, '1', 'admin', '部门管理', 'query', 'GET', '/api/sysDepartment/getDivision', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '12', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1792', '2025-11-06 10:25:10.000', '2025-11-06 10:25:10.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '23', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1793', '2025-11-06 10:37:39.000', '2025-11-06 10:37:39.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '154', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1794', '2025-11-06 10:37:39.000', '2025-11-06 10:37:39.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '9', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1795', '2025-11-06 10:37:40.000', '2025-11-06 10:37:40.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '34', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1796', '2025-11-06 10:42:38.000', '2025-11-06 10:42:38.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/codegen/databases', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1797', '2025-11-06 10:42:39.000', '2025-11-06 10:42:39.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getRoles', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1798', '2025-11-06 10:42:39.000', '2025-11-06 10:42:39.000', null, '1', 'admin', '部门管理', 'query', 'GET', '/api/sysDepartment/getDivision', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1799', '2025-11-06 10:42:39.000', '2025-11-06 10:42:39.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '31', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1800', '2025-11-06 10:42:43.000', '2025-11-06 10:42:43.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '8', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1801', '2025-11-06 10:43:19.000', '2025-11-06 10:43:19.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getRoles', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '7', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1802', '2025-11-06 10:43:19.000', '2025-11-06 10:43:19.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '16', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1803', '2025-11-06 10:43:20.000', '2025-11-06 10:43:20.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '6', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1804', '2025-11-06 10:43:33.000', '2025-11-06 10:43:33.000', null, '1', 'admin', '文件管理', 'query', 'GET', '/api/sysAffix/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '15', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1805', '2025-11-06 10:44:48.000', '2025-11-06 10:44:48.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1806', '2025-11-06 10:45:31.000', '2025-11-06 10:45:31.000', null, '1', 'admin', '文件管理', 'query', 'GET', '/api/sysAffix/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '5', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1807', '2025-11-06 10:47:17.000', '2025-11-06 10:47:17.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '71', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1808', '2025-11-06 10:47:17.000', '2025-11-06 10:47:17.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '18', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1809', '2025-11-06 10:58:37.000', '2025-11-06 10:58:37.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '89', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1810', '2025-11-06 10:58:38.000', '2025-11-06 10:58:38.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '189', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1811', '2025-11-06 11:01:27.000', '2025-11-06 11:01:27.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '12', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1812', '2025-11-06 11:01:27.000', '2025-11-06 11:01:27.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '71', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1813', '2025-11-06 11:01:27.000', '2025-11-06 11:01:27.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '39', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1814', '2025-11-06 11:01:43.000', '2025-11-06 11:01:43.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"students\"}', '', '200', '394', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1815', '2025-11-06 11:01:44.000', '2025-11-06 11:01:44.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '42', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1816', '2025-11-06 11:01:44.000', '2025-11-06 11:01:44.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '44', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1817', '2025-11-06 11:01:45.000', '2025-11-06 11:01:45.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1818', '2025-11-06 11:01:45.000', '2025-11-06 11:01:45.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '90', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1819', '2025-11-06 11:01:52.000', '2025-11-06 11:01:52.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1820', '2025-11-06 11:01:53.000', '2025-11-06 11:01:53.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '108', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1821', '2025-11-06 11:01:53.000', '2025-11-06 11:01:53.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '10', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1822', '2025-11-06 11:02:08.000', '2025-11-06 11:02:08.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1823', '2025-11-06 11:02:10.000', '2025-11-06 11:02:10.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/codegen/databases', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1824', '2025-11-06 11:02:59.000', '2025-11-06 11:02:59.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '33', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1825', '2025-11-06 11:02:59.000', '2025-11-06 11:02:59.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '118', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1826', '2025-11-06 11:03:00.000', '2025-11-06 11:03:00.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '49', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1827', '2025-11-06 11:09:56.000', '2025-11-06 11:09:56.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '8', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1828', '2025-11-06 11:09:56.000', '2025-11-06 11:09:56.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '33', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1829', '2025-11-06 11:09:56.000', '2025-11-06 11:09:56.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '46', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1830', '2025-11-06 11:17:05.000', '2025-11-06 11:17:05.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"students\"}', '', '200', '46', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1831', '2025-11-06 11:17:06.000', '2025-11-06 11:17:06.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '78', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1832', '2025-11-06 11:17:06.000', '2025-11-06 11:17:06.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '139', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1833', '2025-11-06 11:17:06.000', '2025-11-06 11:17:06.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '15', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1834', '2025-11-06 11:17:07.000', '2025-11-06 11:17:07.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1835', '2025-11-06 11:17:07.000', '2025-11-06 11:17:07.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '28', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1836', '2025-11-06 11:17:07.000', '2025-11-06 11:17:07.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1837', '2025-11-06 11:18:51.000', '2025-11-06 11:18:51.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '23', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1838', '2025-11-06 11:18:51.000', '2025-11-06 11:18:51.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '131', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1839', '2025-11-06 11:18:52.000', '2025-11-06 11:18:52.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '44', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1840', '2025-11-06 11:19:08.000', '2025-11-06 11:19:08.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '39', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1841', '2025-11-06 11:19:08.000', '2025-11-06 11:19:08.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '79', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1842', '2025-11-06 11:19:09.000', '2025-11-06 11:19:09.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1843', '2025-11-06 11:19:29.000', '2025-11-06 11:19:29.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1844', '2025-11-06 11:19:29.000', '2025-11-06 11:19:29.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '59', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1845', '2025-11-06 11:19:30.000', '2025-11-06 11:19:30.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '40', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1846', '2025-11-06 11:19:48.000', '2025-11-06 11:19:48.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '13', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1847', '2025-11-06 11:19:48.000', '2025-11-06 11:19:48.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '56', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1848', '2025-11-06 11:19:49.000', '2025-11-06 11:19:49.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '50', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1849', '2025-11-06 11:21:25.000', '2025-11-06 11:21:25.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '66', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1850', '2025-11-06 11:21:25.000', '2025-11-06 11:21:25.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '25', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1851', '2025-11-06 11:21:25.000', '2025-11-06 11:21:25.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '21', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1852', '2025-11-06 11:23:58.000', '2025-11-06 11:23:58.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '38', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1853', '2025-11-06 11:23:58.000', '2025-11-06 11:23:58.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '205', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1854', '2025-11-06 11:23:59.000', '2025-11-06 11:23:59.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1855', '2025-11-06 11:24:26.000', '2025-11-06 11:24:26.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '62', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1856', '2025-11-06 11:24:26.000', '2025-11-06 11:24:26.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '71', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1857', '2025-11-06 11:24:26.000', '2025-11-06 11:24:26.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1858', '2025-11-06 11:26:47.000', '2025-11-06 11:26:47.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '130', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1859', '2025-11-06 11:26:47.000', '2025-11-06 11:26:47.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '75', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1860', '2025-11-06 11:26:47.000', '2025-11-06 11:26:47.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '47', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1861', '2025-11-06 11:27:33.000', '2025-11-06 11:27:33.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '5', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1862', '2025-11-06 11:27:33.000', '2025-11-06 11:27:33.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '29', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1863', '2025-11-06 11:27:34.000', '2025-11-06 11:27:34.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '101', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1864', '2025-11-06 11:40:55.000', '2025-11-06 11:40:55.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '27', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1865', '2025-11-06 11:40:55.000', '2025-11-06 11:40:55.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '68', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1866', '2025-11-06 11:40:56.000', '2025-11-06 11:40:56.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '110', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1867', '2025-11-06 12:01:07.000', '2025-11-06 12:01:07.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/plugins/students/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"address\":\"11\",\"admissionDate\":\"11\",\"age\":11,\"className\":\"11\",\"email\":\"11\",\"gender\":\"11\",\"phone\":\"11\",\"studentId\":0,\"studentName\":\"test\"}', '', '400', '10', 'parsing time \"11\" as \"2006-01-02T15:04:05Z07:00\": cannot parse \"11\" as \"2006\"', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1868', '2025-11-06 14:27:34.000', '2025-11-06 14:27:34.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/plugins/students/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"address\":\"11\",\"admissionDate\":\"2025-01-01\",\"age\":11,\"className\":\"11\",\"email\":\"11\",\"gender\":\"11\",\"phone\":\"11\",\"studentId\":0,\"studentName\":\"test\"}', '', '400', '0', 'parsing time \"2025-01-01\" as \"2006-01-02T15:04:05Z07:00\": cannot parse \"\" as \"T\"', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1869', '2025-11-06 14:40:17.000', '2025-11-06 14:40:17.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/plugins/students/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"address\":\"11\",\"admissionDate\":\"2025-01-01\",\"age\":11,\"className\":\"11\",\"email\":\"11\",\"gender\":\"11\",\"phone\":\"11\",\"studentId\":0,\"studentName\":\"test\"}', '', '400', '631701', 'parsing time \"2025-01-01\" as \"2006-01-02T15:04:05Z07:00\": cannot parse \"\" as \"T\"', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1870', '2025-11-06 14:45:44.000', '2025-11-06 14:45:44.000', null, '0', 'admin', '其他', 'login', 'POST', '/api/login', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"captchaId\":\"UzM7OQqp3oCu4reBZHVS\",\"captchaValue\":null,\"password\":\"***\",\"tenantCode\":\"\",\"username\":\"admin\"}', '', '200', '212', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1871', '2025-11-06 14:45:44.000', '2025-11-06 14:45:44.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '25', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1872', '2025-11-06 14:45:44.000', '2025-11-06 14:45:44.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '6', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1873', '2025-11-06 14:45:44.000', '2025-11-06 14:45:44.000', null, '1', 'admin', '字典管理', 'query', 'GET', '/api/sysDict/getAllDicts', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '93', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1874', '2025-11-06 14:45:54.000', '2025-11-06 14:45:54.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '5', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1875', '2025-11-06 14:46:17.000', '2025-11-06 14:46:17.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/plugins/students/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"address\":\"11\",\"admissionDate\":\"2006-01-02T15:04:05Z07:00\",\"age\":11,\"className\":\"11\",\"email\":\"11\",\"gender\":\"11\",\"phone\":\"11\",\"studentId\":0,\"studentName\":\"11\"}', '', '400', '5', 'parsing time \"2006-01-02T15:04:05Z07:00\": extra text: \"07:00\"', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1876', '2025-11-06 14:46:33.000', '2025-11-06 14:46:33.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/plugins/students/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"address\":\"11\",\"admissionDate\":\"2006-01-02T15:04:05Z\",\"age\":11,\"className\":\"11\",\"email\":\"11\",\"gender\":\"11\",\"phone\":\"11\",\"studentId\":0,\"studentName\":\"11\"}', '', '400', '9', 'Error 1292 (22007): Incorrect datetime value: \'0000-00-00\' for column \'deleted_at\' at row 1', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1877', '2025-11-06 14:48:26.000', '2025-11-06 14:48:26.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/plugins/students/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"address\":\"11\",\"admissionDate\":\"2006-01-02T15:04:05Z\",\"age\":11,\"className\":\"11\",\"email\":\"11\",\"gender\":\"11\",\"phone\":\"11\",\"studentId\":0,\"studentName\":\"11\"}', '', '400', '5', 'Error 1292 (22007): Incorrect datetime value: \'0000-00-00\' for column \'deleted_at\' at row 1', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1878', '2025-11-06 14:51:22.000', '2025-11-06 14:51:22.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/plugins/students/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"address\":\"11\",\"admissionDate\":\"2006-01-02T15:04:05Z\",\"age\":11,\"className\":\"11\",\"email\":\"11\",\"gender\":\"11\",\"phone\":\"11\",\"studentId\":0,\"studentName\":\"11\"}', '', '400', '10', 'Error 1292 (22007): Incorrect datetime value: \'0000-00-00\' for column \'deleted_at\' at row 1', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1879', '2025-11-06 14:57:45.000', '2025-11-06 14:57:45.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/plugins/students/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"address\":\"11\",\"admissionDate\":\"2006-01-02T15:04:05Z\",\"age\":11,\"className\":\"11\",\"email\":\"11\",\"gender\":\"11\",\"phone\":\"11\",\"studentId\":0,\"studentName\":\"11\"}', '', '200', '5', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1880', '2025-11-06 14:57:45.000', '2025-11-06 14:57:45.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '6', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1881', '2025-11-06 14:58:02.000', '2025-11-06 14:58:02.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/6', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1882', '2025-11-06 14:58:32.000', '2025-11-06 14:58:32.000', null, '1', 'admin', '其他', 'update', 'PUT', '/api/plugins/students/edit', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"address\":\"22\",\"admissionDate\":\"2006-01-02T23:04:05+08:00\",\"age\":22,\"className\":\"22\",\"createdAt\":\"2025-11-06T14:57:46+08:00\",\"createdBy\":0,\"deletedAt\":null,\"email\":\"22\",\"gender\":\"22\",\"phone\":\"22\",\"studentId\":6,\"studentName\":\"22\",\"tenantId\":0,\"updatedAt\":\"2025-11-06T14:57:46+08:00\"}', '', '200', '10', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1883', '2025-11-06 14:58:32.000', '2025-11-06 14:58:32.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1884', '2025-11-06 14:58:45.000', '2025-11-06 14:58:45.000', null, '1', 'admin', '其他', 'delete', 'DELETE', '/api/plugins/students/delete', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"studentId\":6}', '', '400', '5', 'ID不能为空', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1885', '2025-11-06 15:01:16.000', '2025-11-06 15:01:16.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '10', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1886', '2025-11-06 15:18:20.000', '2025-11-06 15:18:20.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '17', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1887', '2025-11-06 15:18:20.000', '2025-11-06 15:18:20.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '17', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1888', '2025-11-06 15:18:20.000', '2025-11-06 15:18:20.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '8', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1889', '2025-11-06 15:18:20.000', '2025-11-06 15:18:20.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '26', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1890', '2025-11-06 15:18:22.000', '2025-11-06 15:18:22.000', null, '1', 'admin', '文件管理', 'query', 'GET', '/api/sysAffix/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1891', '2025-11-06 15:19:46.000', '2025-11-06 15:19:46.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"students\"}', '', '200', '127', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1892', '2025-11-06 15:19:48.000', '2025-11-06 15:19:48.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '17', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1893', '2025-11-06 15:19:48.000', '2025-11-06 15:19:48.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '29', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1894', '2025-11-06 15:19:48.000', '2025-11-06 15:19:48.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '50', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1895', '2025-11-06 15:19:48.000', '2025-11-06 15:19:48.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '59', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1896', '2025-11-06 15:19:52.000', '2025-11-06 15:19:52.000', null, '0', '', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '404', '0', '请求处理失败', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1897', '2025-11-06 15:19:53.000', '2025-11-06 15:19:53.000', null, '1', 'admin', '文件管理', 'query', 'GET', '/api/sysAffix/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1898', '2025-11-06 15:25:44.000', '2025-11-06 15:25:44.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '66', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1899', '2025-11-06 15:25:44.000', '2025-11-06 15:25:44.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '42', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1900', '2025-11-06 15:25:45.000', '2025-11-06 15:25:45.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '13', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1901', '2025-11-06 15:26:17.000', '2025-11-06 15:26:17.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '8', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1902', '2025-11-06 15:26:17.000', '2025-11-06 15:26:17.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '76', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1903', '2025-11-06 15:26:17.000', '2025-11-06 15:26:17.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1904', '2025-11-06 15:27:07.000', '2025-11-06 15:27:07.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/plugins/students/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"address\":\"33\",\"admissionDate\":\"2006-01-02 23:04:05\",\"age\":\"33\",\"className\":\"33\",\"email\":\"33\",\"gender\":\"33\",\"phone\":\"33\",\"studentId\":0,\"studentName\":\"33\"}', '', '400', '3', 'parsing time \"2006-01-02 23:04:05\" as \"2006-01-02T15:04:05Z07:00\": cannot parse \" 23:04:05\" as \"T\"', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1905', '2025-11-06 15:28:12.000', '2025-11-06 15:28:12.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/plugins/students/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"address\":\"33\",\"admissionDate\":\"2006-01-02T15:04:05\",\"age\":\"33\",\"className\":\"33\",\"email\":\"33\",\"gender\":\"33\",\"phone\":\"33\",\"studentId\":0,\"studentName\":\"33\"}', '', '400', '2', 'parsing time \"2006-01-02T15:04:05\" as \"2006-01-02T15:04:05Z07:00\": cannot parse \"\" as \"Z07:00\"', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1906', '2025-11-06 15:28:25.000', '2025-11-06 15:28:25.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/plugins/students/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"address\":\"33\",\"admissionDate\":\"2006-01-02T15:04:05Z07:00\",\"age\":\"33\",\"className\":\"33\",\"email\":\"33\",\"gender\":\"33\",\"phone\":\"33\",\"studentId\":0,\"studentName\":\"33\"}', '', '400', '0', 'parsing time \"2006-01-02T15:04:05Z07:00\": extra text: \"07:00\"', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1907', '2025-11-06 15:28:30.000', '2025-11-06 15:28:30.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/plugins/students/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"address\":\"33\",\"admissionDate\":\"2006-01-02T15:04:05Z\",\"age\":\"33\",\"className\":\"33\",\"email\":\"33\",\"gender\":\"33\",\"phone\":\"33\",\"studentId\":0,\"studentName\":\"33\"}', '', '400', '0', 'json: cannot unmarshal string into Go struct field CreateRequest.Age of type int', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1908', '2025-11-06 15:36:11.000', '2025-11-06 15:36:11.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/codegen/columns', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1909', '2025-11-06 15:52:24.000', '2025-11-06 15:52:24.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '14', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1910', '2025-11-06 15:52:24.000', '2025-11-06 15:52:24.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '101', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1911', '2025-11-06 15:52:26.000', '2025-11-06 15:52:26.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '44', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1912', '2025-11-06 15:53:38.000', '2025-11-06 15:53:38.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '19', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1913', '2025-11-06 15:53:38.000', '2025-11-06 15:53:38.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '6', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1914', '2025-11-06 15:55:06.000', '2025-11-06 15:55:06.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"students\"}', '', '200', '102', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1915', '2025-11-06 15:55:07.000', '2025-11-06 15:55:07.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '37', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1916', '2025-11-06 15:55:07.000', '2025-11-06 15:55:07.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '49', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1917', '2025-11-06 15:55:08.000', '2025-11-06 15:55:08.000', null, '0', '', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '404', '0', '请求处理失败', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1918', '2025-11-06 15:55:58.000', '2025-11-06 15:55:58.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '23', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1919', '2025-11-06 15:55:58.000', '2025-11-06 15:55:58.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '97', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1920', '2025-11-06 15:55:59.000', '2025-11-06 15:55:59.000', null, '0', '', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '404', '0', '请求处理失败', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1921', '2025-11-06 15:56:03.000', '2025-11-06 15:56:03.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '7', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1922', '2025-11-06 15:56:03.000', '2025-11-06 15:56:03.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '52', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1923', '2025-11-06 15:56:04.000', '2025-11-06 15:56:04.000', null, '0', '', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '404', '2', '请求处理失败', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1924', '2025-11-06 15:56:06.000', '2025-11-06 15:56:06.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1925', '2025-11-06 15:56:06.000', '2025-11-06 15:56:06.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '13', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1926', '2025-11-06 15:56:06.000', '2025-11-06 15:56:06.000', null, '0', '', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '404', '1', '请求处理失败', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1927', '2025-11-06 15:58:08.000', '2025-11-06 15:58:08.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '31', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1928', '2025-11-06 15:58:08.000', '2025-11-06 15:58:08.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '98', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1929', '2025-11-06 15:58:09.000', '2025-11-06 15:58:09.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '17', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1930', '2025-11-06 16:02:15.000', '2025-11-06 16:02:15.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1931', '2025-11-06 16:02:49.000', '2025-11-06 16:02:49.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '23', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1932', '2025-11-06 16:02:49.000', '2025-11-06 16:02:49.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '55', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1933', '2025-11-06 16:02:50.000', '2025-11-06 16:02:50.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '31', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1934', '2025-11-06 16:03:05.000', '2025-11-06 16:03:05.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/plugins/students/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"address\":\"33\",\"admissionDate\":\"2025-11-06\",\"age\":33,\"className\":\"33\",\"email\":\"33\",\"gender\":\"33\",\"phone\":\"33\",\"studentId\":0,\"studentName\":\"33\"}', '', '400', '0', 'parsing time \"2025-11-06\" as \"2006-01-02T15:04:05Z07:00\": cannot parse \"\" as \"T\"', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1935', '2025-11-06 16:11:57.000', '2025-11-06 16:11:57.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '13', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1936', '2025-11-06 16:11:57.000', '2025-11-06 16:11:57.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '16', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1937', '2025-11-06 16:11:58.000', '2025-11-06 16:11:58.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '36', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1938', '2025-11-06 16:12:25.000', '2025-11-06 16:12:25.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/plugins/students/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"address\":\"33\",\"admissionDate\":\"2025-11-06T00:00:00Z\",\"age\":33,\"className\":\"33\",\"email\":\"33\",\"gender\":\"33\",\"phone\":\"33\",\"studentId\":0,\"studentName\":\"33\"}', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1939', '2025-11-06 16:12:25.000', '2025-11-06 16:12:25.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1940', '2025-11-06 16:12:36.000', '2025-11-06 16:12:36.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/7', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '400', '0', '不能为空', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1941', '2025-11-06 16:19:31.000', '2025-11-06 16:19:31.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1942', '2025-11-06 16:19:38.000', '2025-11-06 16:19:38.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/7', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1943', '2025-11-06 16:22:02.000', '2025-11-06 16:22:02.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"students\"}', '', '200', '65', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1944', '2025-11-06 16:22:04.000', '2025-11-06 16:22:04.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '159', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1945', '2025-11-06 16:22:05.000', '2025-11-06 16:22:05.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1946', '2025-11-06 16:22:05.000', '2025-11-06 16:22:05.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '110', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1947', '2025-11-06 16:23:08.000', '2025-11-06 16:23:08.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"students\"}', '', '200', '54', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1948', '2025-11-06 16:23:08.000', '2025-11-06 16:23:08.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '16', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1949', '2025-11-06 16:23:09.000', '2025-11-06 16:23:09.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '307', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1950', '2025-11-06 16:23:09.000', '2025-11-06 16:23:09.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1951', '2025-11-06 16:23:35.000', '2025-11-06 16:23:35.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '87', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1952', '2025-11-06 16:23:35.000', '2025-11-06 16:23:35.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '112', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1953', '2025-11-06 16:23:39.000', '2025-11-06 16:23:39.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"students\"}', '', '200', '123', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1954', '2025-11-06 16:23:40.000', '2025-11-06 16:23:40.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1955', '2025-11-06 16:23:40.000', '2025-11-06 16:23:40.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '80', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1956', '2025-11-06 16:23:42.000', '2025-11-06 16:23:42.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '70', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1957', '2025-11-06 16:25:51.000', '2025-11-06 16:25:51.000', null, '0', '', '系统配置', 'query', 'GET', '/api/config/get', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '11', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1958', '2025-11-06 16:25:51.000', '2025-11-06 16:25:51.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '55', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1959', '2025-11-06 16:25:52.000', '2025-11-06 16:25:52.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '86', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1960', '2025-11-06 16:26:11.000', '2025-11-06 16:26:11.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"students\"}', '', '200', '73', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1961', '2025-11-06 16:26:12.000', '2025-11-06 16:26:12.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1962', '2025-11-06 16:26:13.000', '2025-11-06 16:26:13.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1963', '2025-11-06 16:26:55.000', '2025-11-06 16:26:55.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '10', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1964', '2025-11-06 16:26:55.000', '2025-11-06 16:26:55.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '150', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1965', '2025-11-06 16:26:56.000', '2025-11-06 16:26:56.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '40', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1966', '2025-11-06 16:27:07.000', '2025-11-06 16:27:07.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/plugins/students/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"address\":\"44\",\"admissionDate\":\"2025-11-06T00:00:00Z\",\"age\":44,\"className\":\"44\",\"email\":\"44\",\"gender\":\"44\",\"phone\":\"44\",\"studentId\":0,\"studentName\":\"44\"}', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1967', '2025-11-06 16:27:07.000', '2025-11-06 16:27:07.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1968', '2025-11-06 16:27:11.000', '2025-11-06 16:27:11.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/8', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1969', '2025-11-06 16:27:21.000', '2025-11-06 16:27:21.000', null, '1', 'admin', '其他', 'update', 'PUT', '/api/plugins/students/edit', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"address\":\"55\",\"admissionDate\":\"2025-11-07T00:00:00Z\",\"age\":55,\"className\":\"55\",\"createdAt\":\"2025-11-06T16:27:07+08:00\",\"createdBy\":0,\"deletedAt\":null,\"email\":\"55\",\"gender\":\"55\",\"phone\":\"55\",\"studentId\":8,\"studentName\":\"55\",\"tenantId\":0,\"updatedAt\":\"2025-11-06T16:27:07+08:00\"}', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1970', '2025-11-06 16:27:21.000', '2025-11-06 16:27:21.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1971', '2025-11-06 16:27:24.000', '2025-11-06 16:27:24.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/8', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '0', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1972', '2025-11-06 16:27:29.000', '2025-11-06 16:27:29.000', null, '1', 'admin', '其他', 'delete', 'DELETE', '/api/plugins/students/delete', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"studentId\":8}', '', '200', '8', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1973', '2025-11-06 16:27:29.000', '2025-11-06 16:27:29.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1974', '2025-11-06 16:27:41.000', '2025-11-06 16:27:41.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '8', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1975', '2025-11-06 16:27:42.000', '2025-11-06 16:27:42.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1976', '2025-11-06 16:49:58.000', '2025-11-06 16:49:58.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1977', '2025-11-06 16:49:58.000', '2025-11-06 16:49:58.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '22', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1978', '2025-11-06 16:50:04.000', '2025-11-06 16:50:04.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"students\"}', '', '200', '139', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1979', '2025-11-06 16:50:05.000', '2025-11-06 16:50:05.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '0', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1980', '2025-11-06 16:50:05.000', '2025-11-06 16:50:05.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '12', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1981', '2025-11-06 16:50:08.000', '2025-11-06 16:50:08.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '5', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1982', '2025-11-06 16:50:22.000', '2025-11-06 16:50:22.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '15', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1983', '2025-11-06 16:50:22.000', '2025-11-06 16:50:22.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '54', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1984', '2025-11-06 16:50:23.000', '2025-11-06 16:50:23.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '5', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1985', '2025-11-06 16:50:40.000', '2025-11-06 16:50:40.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/codegen/databases', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '7', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1986', '2025-11-06 17:06:46.000', '2025-11-06 17:06:46.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '15', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1987', '2025-11-06 17:12:06.000', '2025-11-06 17:12:06.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '17', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1988', '2025-11-06 17:12:29.000', '2025-11-06 17:12:29.000', null, '1', 'admin', '用户管理', 'create', 'POST', '/api/users/logout', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1989', '2025-11-06 17:12:36.000', '2025-11-06 17:12:36.000', null, '0', 'admin', '其他', 'login', 'POST', '/api/login', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"captchaId\":\"GDcY4CjgvDEvzSLLr2Kd\",\"captchaValue\":null,\"password\":\"***\",\"tenantCode\":\"\",\"username\":\"admin\"}', '', '200', '123', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1990', '2025-11-06 17:12:36.000', '2025-11-06 17:12:36.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '6', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1991', '2025-11-06 17:12:36.000', '2025-11-06 17:12:36.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1992', '2025-11-06 17:12:36.000', '2025-11-06 17:12:36.000', null, '1', 'admin', '字典管理', 'query', 'GET', '/api/sysDict/getAllDicts', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '34', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1993', '2025-11-06 17:12:39.000', '2025-11-06 17:12:39.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1994', '2025-11-06 17:12:41.000', '2025-11-06 17:12:41.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '5', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1995', '2025-11-06 17:13:18.000', '2025-11-06 17:13:18.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/plugins/example/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"description\":\"11\",\"id\":0,\"name\":\"11\"}', '', '200', '9', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1996', '2025-11-06 17:13:18.000', '2025-11-06 17:13:18.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '11', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1997', '2025-11-06 17:13:22.000', '2025-11-06 17:13:22.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/example/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '5', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1998', '2025-11-06 17:13:52.000', '2025-11-06 17:13:52.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/plugins/students/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"address\":\"6\",\"admissionDate\":\"2025-11-06T00:00:00Z\",\"age\":6,\"className\":\"6\",\"email\":\"6\",\"gender\":\"6\",\"phone\":\"6\",\"studentId\":0,\"studentName\":\"6\"}', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('1999', '2025-11-06 17:13:52.000', '2025-11-06 17:13:52.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2000', '2025-11-06 17:16:22.000', '2025-11-06 17:16:22.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/plugins/students/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"address\":\"7\",\"admissionDate\":\"2025-11-25T00:00:00Z\",\"age\":7,\"className\":\"7\",\"email\":\"7\",\"gender\":\"7\",\"phone\":\"7\",\"studentId\":0,\"studentName\":\"7\"}', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2001', '2025-11-06 17:16:22.000', '2025-11-06 17:16:22.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2002', '2025-11-06 17:19:57.000', '2025-11-06 17:19:57.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"students\"}', '', '200', '67', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2003', '2025-11-06 17:19:58.000', '2025-11-06 17:19:58.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '34', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2004', '2025-11-06 17:19:58.000', '2025-11-06 17:19:58.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2005', '2025-11-06 17:20:35.000', '2025-11-06 17:20:35.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/codegen/databases', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2006', '2025-11-06 17:21:24.000', '2025-11-06 17:21:24.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '33', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2007', '2025-11-06 17:27:39.000', '2025-11-06 17:27:39.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/sysTenant/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '7', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2008', '2025-11-06 17:27:41.000', '2025-11-06 17:27:41.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/sysUserTenant/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '17', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2009', '2025-11-06 17:27:47.000', '2025-11-06 17:27:47.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/sysUserTenant/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '5', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2010', '2025-11-06 17:27:48.000', '2025-11-06 17:27:48.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/sysUserTenant/userListAll', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '11', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2011', '2025-11-06 17:28:01.000', '2025-11-06 17:28:01.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/sysUserTenant/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '6', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2012', '2025-11-07 11:10:37.000', '2025-11-07 11:10:37.000', null, '0', 'admin', '其他', 'login', 'POST', '/api/login', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"password\":\"***\",\"username\":\"admin\"}', '', '200', '100', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2013', '2025-11-07 11:12:15.000', '2025-11-07 11:12:15.000', null, '0', 'admin', '其他', 'login', 'POST', '/api/login', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"captchaId\":\"T33MiQN9zjuwXfArysRm\",\"captchaValue\":null,\"password\":\"***\",\"tenantCode\":\"\",\"username\":\"admin\"}', '', '200', '101', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2014', '2025-11-07 11:12:15.000', '2025-11-07 11:12:15.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '56', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2015', '2025-11-07 11:12:15.000', '2025-11-07 11:12:15.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2016', '2025-11-07 11:12:15.000', '2025-11-07 11:12:15.000', null, '1', 'admin', '字典管理', 'query', 'GET', '/api/sysDict/getAllDicts', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '9', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2017', '2025-11-07 11:12:25.000', '2025-11-07 11:12:25.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '48', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2018', '2025-11-07 11:13:11.000', '2025-11-07 11:13:11.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getRoles', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '21', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2019', '2025-11-07 11:13:11.000', '2025-11-07 11:13:11.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '68', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2020', '2025-11-07 11:13:13.000', '2025-11-07 11:13:13.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getUserPermission/1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '12', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2021', '2025-11-07 11:13:18.000', '2025-11-07 11:13:18.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getUserPermission/2', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '0', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2022', '2025-11-07 11:13:28.000', '2025-11-07 11:13:28.000', null, '1', 'admin', '菜单管理', 'delete', 'DELETE', '/api/sysMenu/delete', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"id\":140267}', '', '200', '18', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2023', '2025-11-07 11:13:28.000', '2025-11-07 11:13:28.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '5', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2024', '2025-11-07 11:13:29.000', '2025-11-07 11:13:29.000', null, '1', 'admin', '菜单管理', 'delete', 'DELETE', '/api/sysMenu/delete', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"id\":140268}', '', '200', '16', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2025', '2025-11-07 11:13:29.000', '2025-11-07 11:13:29.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '7', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2026', '2025-11-07 11:13:30.000', '2025-11-07 11:13:30.000', null, '1', 'admin', '菜单管理', 'delete', 'DELETE', '/api/sysMenu/delete', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"id\":140269}', '', '200', '8', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2027', '2025-11-07 11:13:30.000', '2025-11-07 11:13:30.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '22', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2028', '2025-11-07 11:13:33.000', '2025-11-07 11:13:33.000', null, '1', 'admin', '菜单管理', 'delete', 'DELETE', '/api/sysMenu/delete', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"id\":140266}', '', '200', '9', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2029', '2025-11-07 11:13:33.000', '2025-11-07 11:13:33.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '8', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2030', '2025-11-07 11:13:43.000', '2025-11-07 11:13:43.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '60', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2031', '2025-11-07 11:13:43.000', '2025-11-07 11:13:43.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '46', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2032', '2025-11-07 11:13:44.000', '2025-11-07 11:13:44.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '13', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2033', '2025-11-07 11:15:16.000', '2025-11-07 11:15:16.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '6', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2034', '2025-11-07 11:15:19.000', '2025-11-07 11:15:19.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '5', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2035', '2025-11-07 11:15:27.000', '2025-11-07 11:15:27.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/codegen/databases', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2036', '2025-11-07 11:15:28.000', '2025-11-07 11:15:28.000', null, '1', 'admin', '部门管理', 'query', 'GET', '/api/sysDepartment/getDivision', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2037', '2025-11-07 11:15:28.000', '2025-11-07 11:15:28.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getRoles', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '6', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2038', '2025-11-07 11:15:28.000', '2025-11-07 11:15:28.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '15', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2039', '2025-11-07 11:27:21.000', '2025-11-07 11:27:21.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '26', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2040', '2025-11-07 11:27:21.000', '2025-11-07 11:27:21.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '93', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2041', '2025-11-07 11:27:24.000', '2025-11-07 11:27:24.000', null, '1', 'admin', '部门管理', 'query', 'GET', '/api/sysDepartment/getDivision', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2042', '2025-11-07 11:27:24.000', '2025-11-07 11:27:24.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getRoles', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2043', '2025-11-07 11:27:24.000', '2025-11-07 11:27:24.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '24', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2044', '2025-11-07 11:27:42.000', '2025-11-07 11:27:42.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '20', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2045', '2025-11-07 11:27:45.000', '2025-11-07 11:27:45.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2046', '2025-11-07 11:27:48.000', '2025-11-07 11:27:48.000', null, '1', 'admin', 'API管理', 'delete', 'DELETE', '/api/sysApi/delete', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"id\":94}', '', '200', '9', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2047', '2025-11-07 11:27:48.000', '2025-11-07 11:27:48.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '9', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2048', '2025-11-07 11:27:50.000', '2025-11-07 11:27:50.000', null, '1', 'admin', 'API管理', 'delete', 'DELETE', '/api/sysApi/delete', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"id\":93}', '', '400', '1', '该API已被菜单关联，无法删除', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2049', '2025-11-07 11:27:51.000', '2025-11-07 11:27:51.000', null, '1', 'admin', 'API管理', 'delete', 'DELETE', '/api/sysApi/delete', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"id\":92}', '', '400', '1', '该API已被菜单关联，无法删除', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2050', '2025-11-07 11:27:57.000', '2025-11-07 11:27:57.000', null, '1', 'admin', 'API管理', 'delete', 'DELETE', '/api/sysApi/delete', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"id\":93}', '', '400', '1', '该API已被菜单关联，无法删除', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2051', '2025-11-07 11:30:24.000', '2025-11-07 11:30:24.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2052', '2025-11-07 11:30:26.000', '2025-11-07 11:30:26.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '5', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2053', '2025-11-07 11:32:49.000', '2025-11-07 11:32:49.000', null, '1', 'admin', '部门管理', 'query', 'GET', '/api/sysDepartment/getDivision', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2054', '2025-11-07 11:32:49.000', '2025-11-07 11:32:49.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '26', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2055', '2025-11-07 11:32:49.000', '2025-11-07 11:32:49.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getRoles', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '0', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2056', '2025-11-07 11:32:55.000', '2025-11-07 11:32:55.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '11', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2057', '2025-11-07 11:32:55.000', '2025-11-07 11:32:55.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '93', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2058', '2025-11-07 11:32:56.000', '2025-11-07 11:32:56.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getRoles', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2059', '2025-11-07 11:32:56.000', '2025-11-07 11:32:56.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '36', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2060', '2025-11-07 11:32:56.000', '2025-11-07 11:32:56.000', null, '1', 'admin', '部门管理', 'query', 'GET', '/api/sysDepartment/getDivision', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '33', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2061', '2025-11-07 11:33:09.000', '2025-11-07 11:33:09.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getRoles', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2062', '2025-11-07 11:33:09.000', '2025-11-07 11:33:09.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '23', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2063', '2025-11-07 11:33:54.000', '2025-11-07 11:33:54.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '41', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2064', '2025-11-07 11:33:57.000', '2025-11-07 11:33:57.000', null, '1', 'admin', '部门管理', 'query', 'GET', '/api/sysDepartment/getDivision', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '0', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2065', '2025-11-07 11:34:09.000', '2025-11-07 11:34:09.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '17', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2066', '2025-11-07 11:34:09.000', '2025-11-07 11:34:09.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '17', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2067', '2025-11-07 11:34:10.000', '2025-11-07 11:34:10.000', null, '1', 'admin', '部门管理', 'query', 'GET', '/api/sysDepartment/getDivision', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2068', '2025-11-07 11:34:22.000', '2025-11-07 11:34:22.000', null, '1', 'admin', '字典管理', 'query', 'GET', '/api/sysDict/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '35', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2069', '2025-11-07 11:35:05.000', '2025-11-07 11:35:05.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '84', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2070', '2025-11-07 11:35:05.000', '2025-11-07 11:35:05.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '114', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2071', '2025-11-07 11:35:06.000', '2025-11-07 11:35:06.000', null, '1', 'admin', '字典管理', 'query', 'GET', '/api/sysDict/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '129', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2072', '2025-11-07 11:35:07.000', '2025-11-07 11:35:07.000', null, '1', 'admin', '字典管理', 'query', 'GET', '/api/sysDict/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '67', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2073', '2025-11-07 11:35:11.000', '2025-11-07 11:35:11.000', null, '1', 'admin', '操作日志管理', 'query', 'GET', '/api/sysOperationLog/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '6', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2074', '2025-11-07 11:36:51.000', '2025-11-07 11:36:51.000', null, '1', 'admin', '操作日志管理', 'query', 'GET', '/api/sysOperationLog/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '15', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2075', '2025-11-07 11:37:12.000', '2025-11-07 11:37:12.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '7', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2076', '2025-11-07 11:37:15.000', '2025-11-07 11:37:15.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '7', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2077', '2025-11-07 11:37:16.000', '2025-11-07 11:37:16.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '7', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2078', '2025-11-07 11:37:24.000', '2025-11-07 11:37:24.000', null, '1', 'admin', '操作日志管理', 'query', 'GET', '/api/sysOperationLog/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '7', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2079', '2025-11-07 11:38:24.000', '2025-11-07 11:38:24.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2080', '2025-11-07 11:38:33.000', '2025-11-07 11:38:33.000', null, '1', 'admin', '文件管理', 'query', 'GET', '/api/sysAffix/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '9', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2081', '2025-11-07 11:39:18.000', '2025-11-07 11:39:18.000', null, '1', 'admin', '文件管理', 'query', 'GET', '/api/sysAffix/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '73', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2082', '2025-11-07 11:39:22.000', '2025-11-07 11:39:22.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/sysTenant/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '7', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2083', '2025-11-07 11:39:26.000', '2025-11-07 11:39:26.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/sysUserTenant/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '24', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2084', '2025-11-07 11:40:47.000', '2025-11-07 11:40:47.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/sysTenant/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '42', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2085', '2025-11-07 11:42:51.000', '2025-11-07 11:42:51.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"students\"}', '', '200', '290', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2086', '2025-11-07 11:42:53.000', '2025-11-07 11:42:53.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '22', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2087', '2025-11-07 11:42:53.000', '2025-11-07 11:42:53.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '79', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2088', '2025-11-07 11:42:54.000', '2025-11-07 11:42:54.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/sysTenant/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2089', '2025-11-07 11:44:25.000', '2025-11-07 11:44:25.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '24', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2090', '2025-11-07 11:44:25.000', '2025-11-07 11:44:25.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '40', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2091', '2025-11-07 11:44:26.000', '2025-11-07 11:44:26.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/sysTenant/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '5', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2092', '2025-11-07 11:44:57.000', '2025-11-07 11:44:57.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '32', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2093', '2025-11-07 11:44:57.000', '2025-11-07 11:44:57.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '46', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2094', '2025-11-07 11:44:58.000', '2025-11-07 11:44:58.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/sysTenant/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '13', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2095', '2025-11-07 11:46:09.000', '2025-11-07 11:46:09.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '30', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2096', '2025-11-07 11:46:23.000', '2025-11-07 11:46:23.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2097', '2025-11-07 11:51:36.000', '2025-11-07 11:51:36.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '14', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2098', '2025-11-07 14:47:14.000', '2025-11-07 14:47:14.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '22', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2099', '2025-11-07 14:48:16.000', '2025-11-07 14:48:16.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '18', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2100', '2025-11-07 14:48:16.000', '2025-11-07 14:48:16.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '26', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2101', '2025-11-07 14:48:17.000', '2025-11-07 14:48:17.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '40', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2102', '2025-11-07 14:48:21.000', '2025-11-07 14:48:21.000', null, '1', 'admin', '操作日志管理', 'query', 'GET', '/api/sysOperationLog/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '5', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2103', '2025-11-07 14:48:23.000', '2025-11-07 14:48:23.000', null, '1', 'admin', '部门管理', 'query', 'GET', '/api/sysDepartment/getDivision', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2104', '2025-11-07 14:48:23.000', '2025-11-07 14:48:23.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getRoles', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2105', '2025-11-07 14:48:23.000', '2025-11-07 14:48:23.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '13', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2106', '2025-11-07 14:48:23.000', '2025-11-07 14:48:23.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getRoles', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2107', '2025-11-07 14:48:23.000', '2025-11-07 14:48:23.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '7', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2108', '2025-11-07 15:03:17.000', '2025-11-07 15:03:17.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '11', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2109', '2025-11-07 15:03:17.000', '2025-11-07 15:03:17.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '15', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2110', '2025-11-07 15:03:18.000', '2025-11-07 15:03:18.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getRoles', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '7', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2111', '2025-11-07 15:03:18.000', '2025-11-07 15:03:18.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '79', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2112', '2025-11-07 15:04:24.000', '2025-11-07 15:04:24.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"students\"}', '', '200', '89', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2113', '2025-11-07 15:04:25.000', '2025-11-07 15:04:25.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2114', '2025-11-07 15:04:25.000', '2025-11-07 15:04:25.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '87', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2115', '2025-11-07 15:04:25.000', '2025-11-07 15:04:25.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getRoles', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '14', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2116', '2025-11-07 15:04:26.000', '2025-11-07 15:04:26.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '104', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2117', '2025-11-07 15:05:43.000', '2025-11-07 15:05:43.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '50', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2118', '2025-11-07 15:05:43.000', '2025-11-07 15:05:43.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '65', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2119', '2025-11-07 15:05:44.000', '2025-11-07 15:05:44.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getRoles', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2120', '2025-11-07 15:05:44.000', '2025-11-07 15:05:44.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '29', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2121', '2025-11-07 15:07:23.000', '2025-11-07 15:07:23.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2122', '2025-11-07 15:07:23.000', '2025-11-07 15:07:23.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '19', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2123', '2025-11-07 15:07:24.000', '2025-11-07 15:07:24.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '42', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2124', '2025-11-07 15:07:24.000', '2025-11-07 15:07:24.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '20', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2125', '2025-11-07 15:07:31.000', '2025-11-07 15:07:31.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '9', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2126', '2025-11-07 15:07:55.000', '2025-11-07 15:07:55.000', null, '1', 'admin', '菜单管理', 'update', 'PUT', '/api/sysMenu/edit', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"affix\":false,\"apis\":[{\"apiGroup\":\"学员管理\",\"createdAt\":\"2025-11-07T15:04:24+08:00\",\"createdBy\":0,\"deletedAt\":null,\"id\":100,\"method\":\"GET\",\"path\":\"/api/plugins/students/list\",\"sysMenuList\":null,\"title\":\"列表查询\",\"updatedAt\":\"2025-11-07T15:04:24+08:00\"}],\"component\":\"plugins/students/views/studentslist\",\"createdAt\":\"2025-11-07T15:04:24+08:00\",\"createdBy\":0,\"deletedAt\":null,\"disable\":false,\"hide\":false,\"i18n\":\"学员管理\",\"icon\":\"IconMenu\",\"id\":140274,\"iframe\":false,\"isFull\":false,\"isLink\":false,\"keepAlive\":true,\"link\":\"\",\"name\":\"PluginsStudents\",\"path\":\"/plugins/students\",\"permission\":\"\",\"redirect\":\"\",\"sort\":99,\"svgIcon\":\"\",\"title\":\"学员管理\",\"type\":2,\"updatedAt\":\"2025-11-07T15:04:24+08:00\"}', '', '200', '14', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2127', '2025-11-07 15:07:55.000', '2025-11-07 15:07:55.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '22', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2128', '2025-11-07 15:08:06.000', '2025-11-07 15:08:06.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '16', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2129', '2025-11-07 15:08:06.000', '2025-11-07 15:08:06.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '35', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2130', '2025-11-07 15:08:06.000', '2025-11-07 15:08:06.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '20', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2131', '2025-11-07 15:08:14.000', '2025-11-07 15:08:14.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '11', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2132', '2025-11-07 15:08:14.000', '2025-11-07 15:08:14.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '12', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2133', '2025-11-07 15:08:14.000', '2025-11-07 15:08:14.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '15', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2134', '2025-11-07 15:08:38.000', '2025-11-07 15:08:38.000', null, '1', 'admin', '菜单管理', 'update', 'PUT', '/api/sysMenu/edit', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"affix\":false,\"apis\":[{\"apiGroup\":\"学员管理\",\"createdAt\":\"2025-11-07T15:04:24+08:00\",\"createdBy\":0,\"deletedAt\":null,\"id\":100,\"method\":\"GET\",\"path\":\"/api/plugins/students/list\",\"sysMenuList\":null,\"title\":\"列表查询\",\"updatedAt\":\"2025-11-07T15:04:24+08:00\"}],\"component\":\"plugins/students/views/studentslist\",\"createdAt\":\"2025-11-07T15:04:24+08:00\",\"createdBy\":0,\"deletedAt\":null,\"disable\":false,\"hide\":false,\"i18n\":\"学员管理\",\"icon\":\"IconMenu\",\"id\":140274,\"iframe\":false,\"isFull\":false,\"isLink\":false,\"keepAlive\":true,\"link\":\"\",\"name\":\"PluginsStudents\",\"path\":\"/plugins/students\",\"permission\":\"\",\"redirect\":\"\",\"sort\":1,\"svgIcon\":\"\",\"title\":\"学员管理\",\"type\":2,\"updatedAt\":\"2025-11-07T15:07:56+08:00\"}', '', '200', '7', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2135', '2025-11-07 15:08:38.000', '2025-11-07 15:08:38.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '11', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2136', '2025-11-07 15:08:40.000', '2025-11-07 15:08:40.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '13', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2137', '2025-11-07 15:08:40.000', '2025-11-07 15:08:40.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '15', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2138', '2025-11-07 15:08:40.000', '2025-11-07 15:08:40.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '29', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2139', '2025-11-07 15:08:48.000', '2025-11-07 15:08:48.000', null, '1', 'admin', '菜单管理', 'update', 'PUT', '/api/sysMenu/edit', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"affix\":false,\"apis\":[{\"apiGroup\":\"学员管理\",\"createdAt\":\"2025-11-07T15:04:24+08:00\",\"createdBy\":0,\"deletedAt\":null,\"id\":100,\"method\":\"GET\",\"path\":\"/api/plugins/students/list\",\"sysMenuList\":null,\"title\":\"列表查询\",\"updatedAt\":\"2025-11-07T15:04:24+08:00\"}],\"component\":\"plugins/students/views/studentslist\",\"createdAt\":\"2025-11-07T15:04:24+08:00\",\"createdBy\":0,\"deletedAt\":null,\"disable\":false,\"hide\":false,\"i18n\":\"学员管理\",\"icon\":\"IconMenu\",\"id\":140274,\"iframe\":false,\"isFull\":false,\"isLink\":false,\"keepAlive\":true,\"link\":\"\",\"name\":\"PluginsStudents\",\"path\":\"/plugins/students\",\"permission\":\"\",\"redirect\":\"\",\"sort\":1,\"svgIcon\":\"\",\"title\":\"学员管理\",\"type\":2,\"updatedAt\":\"2025-11-07T15:08:38+08:00\"}', '', '200', '26', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2140', '2025-11-07 15:08:48.000', '2025-11-07 15:08:48.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '9', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2141', '2025-11-07 15:10:39.000', '2025-11-07 15:10:39.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '8', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2142', '2025-11-07 15:10:39.000', '2025-11-07 15:10:39.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '11', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2143', '2025-11-07 15:10:39.000', '2025-11-07 15:10:39.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '11', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2144', '2025-11-07 15:10:45.000', '2025-11-07 15:10:45.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '11', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2145', '2025-11-07 15:11:11.000', '2025-11-07 15:11:11.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/plugins/students/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"address\":\"8\",\"admissionDate\":\"2025-11-07T00:00:00Z\",\"age\":8,\"className\":\"8\",\"email\":\"8\",\"gender\":\"8\",\"phone\":\"8\",\"studentId\":0,\"studentName\":\"8\"}', '', '200', '45', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2146', '2025-11-07 15:11:11.000', '2025-11-07 15:11:11.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2147', '2025-11-07 15:11:16.000', '2025-11-07 15:11:16.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/6', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2148', '2025-11-07 15:11:21.000', '2025-11-07 15:11:21.000', null, '1', 'admin', '其他', 'update', 'PUT', '/api/plugins/students/edit', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"address\":\"2\",\"admissionDate\":\"2006-01-02T23:04:05+08:00\",\"age\":2,\"className\":\"2\",\"createdAt\":\"2025-11-06T14:57:46+08:00\",\"createdBy\":0,\"deletedAt\":null,\"email\":\"2\",\"gender\":\"2\",\"phone\":\"2\",\"studentId\":6,\"studentName\":\"2\",\"tenantId\":0,\"updatedAt\":\"2025-11-06T14:58:32+08:00\"}', '', '200', '10', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2149', '2025-11-07 15:11:21.000', '2025-11-07 15:11:21.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2150', '2025-11-07 15:11:23.000', '2025-11-07 15:11:23.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/7', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '1', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2151', '2025-11-07 15:11:29.000', '2025-11-07 15:11:29.000', null, '1', 'admin', '其他', 'update', 'OPTIONS', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"address\":\"3\",\"admissionDate\":\"2025-11-06T08:00:00+08:00\",\"age\":3,\"className\":\"3\",\"createdAt\":\"2025-11-06T16:12:26+08:00\",\"createdBy\":0,\"deletedAt\":null,\"email\":\"3\",\"gender\":\"3\",\"phone\":\"3\",\"studentId\":7,\"studentName\":\"3\",\"tenantId\":0,\"updatedAt\":\"2025-11-06T16:12:26+08:00\"}', '', '204', '47', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2152', '2025-11-07 15:11:29.000', '2025-11-07 15:11:29.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '0', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2153', '2025-11-07 15:12:30.000', '2025-11-07 15:12:30.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '28', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2154', '2025-11-07 15:12:30.000', '2025-11-07 15:12:30.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '54', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2155', '2025-11-07 15:12:32.000', '2025-11-07 15:12:32.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '22', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2156', '2025-11-07 15:12:39.000', '2025-11-07 15:12:39.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '13', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2157', '2025-11-07 15:12:39.000', '2025-11-07 15:12:39.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '23', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2158', '2025-11-07 15:12:40.000', '2025-11-07 15:12:40.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '16', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2159', '2025-11-07 15:12:44.000', '2025-11-07 15:12:44.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getRoles', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2160', '2025-11-07 15:12:44.000', '2025-11-07 15:12:44.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '11', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2161', '2025-11-07 15:12:47.000', '2025-11-07 15:12:47.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getUserPermission/1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2162', '2025-11-07 15:14:24.000', '2025-11-07 15:14:24.000', null, '1', 'admin', '角色管理', 'create', 'POST', '/api/sysRole/addRoleMenu', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"menuId\":[1,10,1001,1002,1003,1004,1005,1006,1007,140213,140214,140215,140216,140218,140219,140220,140221,140222,140223,140224,140225,140226,140227,140228,140229,140230,140231,140232,140233,140234,140235,140236,140237,140238,140239,140240,140241,140242,140243,140244,140245,140246,140247,140248,140249,140250,140251,140252,140254,140255,140256,140257,140258,140259,140260,140261,140262,140263,140264,140274,140275,140276,140277],\"roleId\":1}', '', '200', '32', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2163', '2025-11-07 15:14:27.000', '2025-11-07 15:14:27.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '15', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2164', '2025-11-07 15:14:27.000', '2025-11-07 15:14:27.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '69', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2165', '2025-11-07 15:14:28.000', '2025-11-07 15:14:28.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getRoles', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '8', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2166', '2025-11-07 15:14:28.000', '2025-11-07 15:14:28.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '25', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2167', '2025-11-07 15:14:29.000', '2025-11-07 15:14:29.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2168', '2025-11-07 15:14:42.000', '2025-11-07 15:14:42.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/plugins/students/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"address\":\"9\",\"admissionDate\":\"2025-11-19T00:00:00Z\",\"age\":9,\"className\":\"9\",\"email\":\"9\",\"gender\":\"9\",\"phone\":\"9\",\"studentId\":0,\"studentName\":\"9\"}', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2169', '2025-11-07 15:14:42.000', '2025-11-07 15:14:42.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2170', '2025-11-07 15:14:45.000', '2025-11-07 15:14:45.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2171', '2025-11-07 15:14:46.000', '2025-11-07 15:14:46.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2172', '2025-11-07 15:15:04.000', '2025-11-07 15:15:04.000', null, '1', 'admin', '其他', 'delete', 'DELETE', '/api/plugins/students/delete', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"studentId\":11}', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2173', '2025-11-07 15:15:04.000', '2025-11-07 15:15:04.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '6', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2174', '2025-11-07 15:15:08.000', '2025-11-07 15:15:08.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getUserPermission/1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '2', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2175', '2025-11-07 15:15:12.000', '2025-11-07 15:15:12.000', null, '1', 'admin', '角色管理', 'create', 'POST', '/api/sysRole/addRoleMenu', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"menuId\":[1,10,1001,1002,1003,1004,1005,1006,1007,140213,140214,140215,140216,140218,140219,140220,140221,140222,140223,140224,140225,140226,140227,140228,140229,140230,140231,140232,140233,140234,140235,140236,140237,140238,140239,140240,140241,140242,140243,140244,140245,140246,140247,140248,140249,140250,140251,140252,140254,140255,140256,140257,140258,140259,140260,140261,140262,140263,140264,140274,140275,140276],\"roleId\":1}', '', '200', '20', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2176', '2025-11-07 15:15:17.000', '2025-11-07 15:15:17.000', null, '1', 'admin', '其他', 'delete', 'DELETE', '/api/plugins/students/delete', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"studentId\":12}', '', '403', '3', '您没有权限访问此资源', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2177', '2025-11-07 15:24:04.000', '2025-11-07 15:24:04.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '91', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2178', '2025-11-07 15:24:05.000', '2025-11-07 15:24:05.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '116', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2179', '2025-11-07 15:24:05.000', '2025-11-07 15:24:05.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/plugins/students/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '34', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2180', '2025-11-07 15:24:09.000', '2025-11-07 15:24:09.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '10', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2181', '2025-11-07 15:24:13.000', '2025-11-07 15:24:13.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/apis/140276', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '8', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2182', '2025-11-07 15:24:13.000', '2025-11-07 15:24:13.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '11', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2183', '2025-11-07 15:29:58.000', '2025-11-07 15:29:58.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '39', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2184', '2025-11-07 15:29:58.000', '2025-11-07 15:29:58.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '153', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2185', '2025-11-07 15:29:59.000', '2025-11-07 15:29:59.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '153', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2186', '2025-11-07 15:30:25.000', '2025-11-07 15:30:25.000', null, '1', 'admin', '其他', 'create', 'POST', '/api/codegen/generate', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '{\"database\":\"gin-fast-tenant\",\"table\":\"students\"}', '', '403', '2', '您没有权限访问此资源', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2187', '2025-11-07 15:30:36.000', '2025-11-07 15:30:36.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '66', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2188', '2025-11-07 15:30:36.000', '2025-11-07 15:30:36.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '35', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2189', '2025-11-07 15:30:37.000', '2025-11-07 15:30:37.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '56', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2190', '2025-11-07 15:31:02.000', '2025-11-07 15:31:02.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '9', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2191', '2025-11-07 15:31:10.000', '2025-11-07 15:31:10.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '8', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2192', '2025-11-07 15:31:23.000', '2025-11-07 15:31:23.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/89', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '3', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2193', '2025-11-07 15:32:12.000', '2025-11-07 15:32:12.000', null, '1', 'admin', '其他', 'query', 'GET', '/api/codegen/columns', '127.0.0.1', 'PostmanRuntime-ApipostRuntime/1.1.0', '', '', '403', '4', '您没有权限访问此资源', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2194', '2025-11-07 15:32:53.000', '2025-11-07 15:32:53.000', null, '1', 'admin', 'API管理', 'create', 'POST', '/api/sysApi/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"apiGroup\":\"代码生成\",\"method\":\"POST\",\"path\":\"/api/codegen/generate\",\"title\":\"生成代码文件\"}', '', '200', '13', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2195', '2025-11-07 15:32:53.000', '2025-11-07 15:32:53.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '54', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2196', '2025-11-07 15:33:52.000', '2025-11-07 15:33:52.000', null, '1', 'admin', 'API管理', 'create', 'POST', '/api/sysApi/add', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"apiGroup\":\"代码生成\",\"method\":\"GET\",\"path\":\"/api/codegen/columns\",\"title\":\"获取表的字段信息\"}', '', '200', '6', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2197', '2025-11-07 15:33:52.000', '2025-11-07 15:33:52.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '9', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2198', '2025-11-07 15:34:21.000', '2025-11-07 15:34:21.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/apis/140265', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '8', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2199', '2025-11-07 15:34:21.000', '2025-11-07 15:34:21.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '8', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2200', '2025-11-07 15:34:24.000', '2025-11-07 15:34:24.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '5', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2201', '2025-11-07 15:34:26.000', '2025-11-07 15:34:26.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '6', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2202', '2025-11-07 15:34:29.000', '2025-11-07 15:34:29.000', null, '1', 'admin', 'API管理', 'query', 'GET', '/api/sysApi/list', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '5', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2203', '2025-11-07 15:34:39.000', '2025-11-07 15:34:39.000', null, '1', 'admin', '菜单管理', 'create', 'POST', '/api/sysMenu/setApis', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"apiIds\":[106,105],\"menuId\":140265}', '', '200', '37', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2204', '2025-11-07 15:34:40.000', '2025-11-07 15:34:40.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '9', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2205', '2025-11-07 15:35:01.000', '2025-11-07 15:35:01.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getRoles', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '4', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2206', '2025-11-07 15:35:01.000', '2025-11-07 15:35:01.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '13', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2207', '2025-11-07 15:35:03.000', '2025-11-07 15:35:03.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getUserPermission/1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '6', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2208', '2025-11-07 15:35:07.000', '2025-11-07 15:35:07.000', null, '1', 'admin', '角色管理', 'create', 'POST', '/api/sysRole/addRoleMenu', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"menuId\":[1,10,1001,1002,1003,1004,1005,1006,1007,140213,140214,140215,140216,140218,140219,140220,140221,140222,140223,140224,140225,140226,140227,140228,140229,140230,140231,140232,140233,140234,140235,140236,140237,140238,140239,140240,140241,140242,140243,140244,140245,140246,140247,140248,140249,140250,140251,140252,140254,140255,140256,140257,140258,140259,140260,140261,140262,140263,140264,140274,140275,140276,140265],\"roleId\":1}', '', '400', '6', '菜单ID不存在', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2209', '2025-11-07 15:35:27.000', '2025-11-07 15:35:27.000', null, '1', 'admin', '用户管理', 'query', 'GET', '/api/users/profile', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '30', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2210', '2025-11-07 15:35:27.000', '2025-11-07 15:35:27.000', null, '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getRouters', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '48', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2211', '2025-11-07 15:35:28.000', '2025-11-07 15:35:28.000', null, '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getRoles', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '45', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2212', '2025-11-07 15:35:28.000', '2025-11-07 15:35:28.000', '2025-11-11 15:53:12.408', '1', 'admin', '菜单管理', 'query', 'GET', '/api/sysMenu/getMenuList', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '51', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2213', '2025-11-07 15:35:40.000', '2025-11-07 15:35:40.000', '2025-11-11 15:53:12.408', '1', 'admin', '角色管理', 'query', 'GET', '/api/sysRole/getUserPermission/1', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '', '', '200', '5', '', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2214', '2025-11-07 15:35:45.000', '2025-11-07 15:35:45.000', '2025-11-11 15:52:00.383', '1', 'admin', '角色管理', 'create', 'POST', '/api/sysRole/addRoleMenu', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"menuId\":[1,10,1001,1002,1003,1004,1005,1006,1007,140213,140214,140215,140216,140218,140219,140220,140221,140222,140223,140224,140225,140226,140227,140228,140229,140230,140231,140232,140233,140234,140235,140236,140237,140238,140239,140240,140241,140242,140243,140244,140245,140246,140247,140248,140249,140250,140251,140252,140254,140255,140256,140257,140258,140259,140260,140261,140262,140263,140264,140274,140275,140276,140265],\"roleId\":1}', '', '400', '8', '菜单ID不存在', '', '0');
INSERT INTO `sys_operation_logs` VALUES ('2215', '2025-11-07 15:35:51.000', '2025-11-07 15:35:51.000', '2025-11-11 15:52:00.383', '1', 'admin', '角色管理', 'create', 'POST', '/api/sysRole/addRoleMenu', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', '{\"menuId\":[1,10,1001,1002,1003,1004,1005,1006,1007,140213,140214,140215,140216,140218,140219,140220,140221,140222,140223,140224,140225,140226,140227,140228,140229,140230,140231,140232,140233,140234,140235,140236,140237,140238,140239,140240,140241,140242,140243,140244,140245,140246,140247,140248,140249,140250,140251,140252,140254,140255,140256,140257,140258,140259,140260,140261,140262,140263,140264,140274,140275,140276],\"roleId\":1}', '', '400', '7', '菜单ID不存在', '', '0');

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
INSERT INTO `sys_role` VALUES ('1', '系统管理员', '1', '1', '最高权限管理员角色', '0', '2025-09-01 17:32:12', '2025-09-30 15:53:24', null, '1', '1', '', '0');
INSERT INTO `sys_role` VALUES ('2', '演示', '1', '1', '', '0', '2025-10-14 15:12:09', '2025-10-17 15:34:47', null, '1', '0', '', '0');

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
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `code` (`code`) USING BTREE,
  KEY `idx_sys_tenants_deleted_at` (`deleted_at`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of sys_tenants
-- ----------------------------
INSERT INTO `sys_tenants` VALUES ('1', '2025-11-03 11:16:45', '2025-11-03 11:16:45', null, '1', '测试租户1', 'dom1', '', '1', '');

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
INSERT INTO `sys_users` VALUES ('1', 'admin', '$2a$10$0aS9FxWlOz/PXiqzsBr7huy.Dqdwucyb795qiWcA6fsn0Lu.GLA.C', 'admin@example.com', '1', '1', '18800000006', '1', '超级管理员6', '/public/uploads/2025-11-04/20251104_0945787a-8536-45fc-ba75-e94c8daaec06.jpeg', '超级管理员', '2025-08-18 14:55:05', '2025-11-04 10:47:54', null, '0', '0');
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
