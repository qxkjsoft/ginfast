/*
Navicat MySQL Data Transfer

Source Server         : localhsot5.7
Source Server Version : 50726
Source Host           : localhost:3306
Source Database       : gin-fast

Target Server Type    : MYSQL
Target Server Version : 50726
File Encoding         : 65001

Date: 2025-08-29 18:13:13
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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
-- Table structure for sys_api
-- ----------------------------
DROP TABLE IF EXISTS `sys_api`;
CREATE TABLE `sys_api` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '权限名称',
  `path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '权限路径',
  `method` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `api_group` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '分组',
  `menu_id` int(11) unsigned DEFAULT NULL COMMENT '菜单ID',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of sys_api
-- ----------------------------

-- ----------------------------
-- Table structure for sys_department
-- ----------------------------
DROP TABLE IF EXISTS `sys_department`;
CREATE TABLE `sys_department` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) unsigned DEFAULT '0',
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of sys_dict
-- ----------------------------
INSERT INTO `sys_dict` VALUES ('1', '性别', 'gender', '1', '这是一个性别字典', '2024-07-01 10:00:00', null, null, null);
INSERT INTO `sys_dict` VALUES ('2', '状态', 'status', '1', '状态字段可以用这个', '2024-07-01 10:00:00', null, null, null);
INSERT INTO `sys_dict` VALUES ('3', '岗位', 'post', '1', '岗位字段', '2024-07-01 10:00:00', null, null, null);
INSERT INTO `sys_dict` VALUES ('4', '任务状态', 'taskStatus', '1', '任务状态字段可以用它', '2024-07-01 10:00:00', null, null, null);

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
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '路由ID',
  `parent_id` varchar(32) NOT NULL DEFAULT '0' COMMENT '父级路由ID，顶层为0',
  `path` varchar(255) NOT NULL COMMENT '路由路径',
  `name` varchar(100) NOT NULL COMMENT '路由名称',
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
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL,
  `created_by` int(11) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_sort` (`sort`),
  KEY `idx_type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=140206 DEFAULT CHARSET=utf8mb4 COMMENT='系统菜单路由表';

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES ('1', '0', '/home', 'home', 'home/home', 'home', '0', '0', '0', '0', '1', '', '0', 'home', '', '1', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('2', '0', '/file', 'file', null, 'file', '0', '0', '0', '1', '0', '', '0', 'folder-menu', '', '2', '1', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('3', '0', '/table', 'table', null, 'table', '0', '0', '0', '1', '0', '', '0', 'table', '', '3', '1', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('4', '0', '/form', 'form', null, 'form', '0', '0', '0', '1', '0', '', '0', 'form', '', '4', '1', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('5', '0', '/multilevel', 'multilevel', null, 'multilevel', '0', '0', '0', '1', '0', '', '0', 'switch', '', '5', '1', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('6', '0', '/component', 'component', null, 'component', '0', '0', '0', '1', '0', '', '0', 'classify', '', '6', '1', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('7', '0', '/directive', 'directive', null, 'directive', '0', '0', '0', '1', '0', '', '0', 'directives', '', '7', '1', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('9', '0', '/functions', 'functions', null, 'functions', '0', '0', '0', '1', '0', '', '0', 'functions', '', '9', '1', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('10', '0', '/system', 'system', null, 'system', '0', '0', '0', '1', '0', '', '0', 'set', '', '10', '1', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('12', '0', '/hide-menu', 'hide-menu', 'hide-menu/hide-menu', 'hide-menu', '0', '1', '0', '1', '0', '', '0', 'switch', '', '12', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('13', '0', '/permission', 'permission', null, 'permission', '0', '0', '0', '1', '0', '', '0', 'defend', '', '13', '1', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('14', '0', '/link', 'link', null, 'link', '0', '0', '0', '1', '0', '', '0', 'link', '', '14', '1', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('15', '0', '/monitor', 'monitor', null, 'system-monitor', '0', '0', '0', '1', '0', '', '0', 'financial-statement', '', '15', '1', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('16', '0', '/SnowAdmin-Thin', 'thin-preview', 'link/external/external', 'thin-preview', '0', '0', '0', '0', '1', 'http://115.190.79.132:83/#/login', '0', 'propaganda', '', '16', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('17', '0', '/i18n', 'i18n', 'i18n/show/index', 'i18n', '0', '0', '0', '1', '0', '', '0', 'earth', '', '17', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('18', '0', '/about', 'about', 'about/about', 'about', '0', '0', '0', '1', '0', '', '0', 'about', '', '18', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('201', '02', '/file/document-library', 'document-library', 'file/document-library/document-library', 'document-library', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '1', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('301', '03', '/table/common-table', 'common-table', 'table/common-table/common-table', 'common-table', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '1', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('302', '03', '/table/custom-table', 'custom-table', 'table/custom-table/custom-table', 'custom-table', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '2', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('401', '04', '/form/common-form', 'common-form', 'form/common-form/common-form', 'common-form', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '1', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('402', '04', '/form/step-form', 'step-form', 'form/step-form/step-form', 'step-form', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '2', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('501', '05', '/multilevel/second-1', 'second-1', 'multilevel/second/second-1', 'second-1', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '1', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('502', '05', '/multilevel/second-2', 'second-2', null, 'second-2', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '2', '1', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('601', '06', '/component/player', 'player', 'component/player/player', 'player', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '1', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('602', '06', '/component/print', 'print', 'component/print/print', 'print', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '2', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('603', '06', '/component/draggable', 'draggable', 'component/draggable/draggable', 'draggable', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '3', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('604', '06', '/component/editor', 'editor', 'component/editor/editor', 'editor', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '4', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('605', '06', '/component/newbie', 'newbie', 'component/newbie/newbie', 'newbie', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '5', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('606', '06', '/component/icon-selector', 'icon-selector', 'component/icon-selector/icon-selector', 'icon-selector', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '6', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('607', '06', '/component/user-center', 'user-center', 'component/user-center/user-center', 'user-center', '0', '1', '0', '1', '0', '', '0', '', 'icon-menu', '7', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('608', '06', '/component/fingerprintjs2', 'fingerprintjs2', 'component/fingerprintjs2/fingerprintjs2', 'fingerprintjs2', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '8', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('609', '06', '/component/barcode', 'barcode', 'component/barcode/barcode', 'barcode', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '9', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('610', '06', '/component/qrcode', 'qrcode', 'component/qrcode/qrcode', 'qrcode', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '10', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('611', '06', '/component/pinyin', 'pinyin', 'component/pinyin/pinyin', 'pinyin', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '11', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('612', '06', '/component/recorder', 'recorder', 'component/recorder/recorder', 'recorder', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '12', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('613', '06', '/component/virtual-list', 'virtual-list', 'component/virtual-list/index', 'virtual-list', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '13', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('614', '06', '/component/common-layouts', 'common-layouts', 'component/common-layouts/index', 'common-layouts', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '14', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('701', '07', '/directive/anti-shake', 'anti-shake', 'directive/anti-shake/anti-shake', 'anti-shake', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '1', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('702', '07', '/directive/throttle', 'throttle', 'directive/throttle/throttle', 'throttle', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '2', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('703', '07', '/directive/test-directive', 'test-directive', 'directive/test-directive/test-directive', 'test-directive', '0', '1', '0', '1', '0', '', '0', '', 'icon-menu', '3', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('901', '09', '/functions/routing-operation', 'routing-operation', 'functions/routing-operation/index', 'routing-operation', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '1', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('902', '09', '/functions/common-tools', 'common-tools', 'functions/common-tools/common-tools', 'common-tools', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '2', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('903', '09', '/functions/tree-tools', 'tree-tools', 'functions/tree-tools/tree-tools', 'tree-tools', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '3', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('904', '09', '/functions/file-tools', 'file-tools', 'functions/file-tools/file-tools', 'file-tools', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '4', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('905', '09', '/functions/verify-tools', 'verify-tools', 'functions/verify-tools/verify-tools', 'verify-tools', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '5', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('1001', '10', '/system/account', 'account', 'system/account/account', 'account', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '1', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('1002', '10', '/system/role', 'role', 'system/role/role', 'role', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '2', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('1003', '10', '/system/menu', 'menu', 'system/menu/menu', 'menu', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '3', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('1004', '10', '/system/division', 'division', 'system/division/division', 'division', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '4', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('1005', '10', '/system/dictionary', 'dictionary', 'system/dictionary/dictionary', 'dictionary', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '5', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('1006', '10', '/system/log', 'log', 'system/log/log', 'log', '0', '1', '0', '1', '0', '', '0', '', 'icon-menu', '6', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('1007', '10', '/system/userinfo', 'userinfo', 'system/userinfo/userinfo', 'userinfo', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '7', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('1301', '13', '/permission/btn-perm', 'btn-perm', 'permission/btn-perm/btn-perm', 'btn-perm', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '1', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('1302', '13', '/permission/admin-page', 'admin-page', 'permission/admin-page/admin-page', 'admin-page', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '2', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('1303', '13', '/permission/common-page', 'common-page', 'permission/common-page/common-page', 'common-page', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '3', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('1401', '14', '/link/internal', 'internal', null, 'internal', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '1', '1', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('1402', '14', '/link/external', 'external', null, 'external', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '2', '1', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('1501', '15', '/monitor/onlineuser', 'onlineuser', 'monitor/onlineuser/index', 'onlineuser', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '1', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('1502', '15', '/monitor/crontab', 'crontab', 'monitor/crontab/index', 'crontab', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '2', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('1503', '15', '/monitor/crontab-logs', 'crontab-logs', 'monitor/crontab-logs/index', 'crontab-logs', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '3', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('50201', '0502', '/multilevel/third-2', 'third-2', 'multilevel/third/third-2', 'third-2', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '2', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('50202', '0502', '/multilevel/third-1', 'third-1', 'multilevel/third/third-1', 'third-1', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '1', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('50203', '0502', '/multilevel/third-3', 'third-3', 'multilevel/third/third-3', 'third-3', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '3', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('90101', '0901', '/functions/routing-operation/common-route', 'common-route', 'functions/routing-operation/common-route', 'common-route', '0', '1', '0', '1', '0', '', '0', 'switch', '', '1', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('90102', '0901', '/functions/routing-operation/dynamic-route/:name/:text', 'dynamic-route', 'functions/routing-operation/dynamic-route', 'dynamic-route', '0', '1', '0', '1', '0', '', '0', 'switch', '', '2', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('140101', '1401', '/link/internal/uigradients', 'uigradients', 'link/internal/internal', 'uigradients', '0', '0', '0', '1', '0', 'https://uigradients.com/#HoneyDew', '1', '', 'icon-menu', '1', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('140102', '1401', '/link/internal/color-taking-tool', 'color-taking-tool', 'link/internal/internal', 'color-taking-tool', '0', '0', '0', '1', '0', 'https://photokit.com/colors/eyedropper/?lang=zh', '1', '', 'icon-menu', '2', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('140103', '1401', '/link/internal/grid-generator', 'grid-generator', 'link/internal/internal', 'grid-generator', '0', '0', '0', '1', '0', 'https://cssgrid-generator.netlify.app/', '1', '', 'icon-menu', '3', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('140104', '1401', '/link/internal/gaodemap', 'gaodemap', 'link/internal/internal', 'amap', '0', '0', '0', '1', '0', 'http://115.190.79.132:82/', '1', '', 'icon-menu', '4', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('140201', '1402', '/link/external/SnowAdmin-Docs', 'SnowAdmin-Docs', 'link/external/external', 'SnowAdmin-Docs', '0', '0', '0', '1', '0', 'http://115.190.79.132:81/', '0', '', 'icon-menu', '5', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('140202', '1402', '/link/external/vue', 'vue', 'link/external/external', 'vue', '0', '0', '0', '1', '0', 'https://cn.vuejs.org/', '0', '', 'icon-menu', '1', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('140203', '1402', '/link/external/vite', 'vite', 'link/external/external', 'vite', '0', '0', '0', '1', '0', 'https://www.vitejs.net/', '0', '', 'icon-menu', '2', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);
INSERT INTO `sys_menu` VALUES ('140205', '1402', '/link/external/juejin', 'juejin', 'link/external/external', 'juejin', '0', '0', '0', '1', '0', 'https://juejin.cn/user/1728883023940600', '0', '', 'icon-menu', '4', '2', '2025-08-27 09:09:44', '2025-08-27 09:09:44', null, null);

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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES ('1', '超级管理员', '1', '1', '', '0', '2025-08-27 11:24:39', null, null, null);
INSERT INTO `sys_role` VALUES ('2', '普通管理员', '2', '1', null, '0', '2025-08-27 11:24:54', null, null, null);
INSERT INTO `sys_role` VALUES ('3', '普通管理员_1', '1', '1', null, '2', '2025-08-28 17:06:01', null, null, null);

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
INSERT INTO `sys_role_menu` VALUES ('1', '140101');
INSERT INTO `sys_role_menu` VALUES ('1', '140102');
INSERT INTO `sys_role_menu` VALUES ('1', '140103');
INSERT INTO `sys_role_menu` VALUES ('1', '140104');
INSERT INTO `sys_role_menu` VALUES ('1', '140201');
INSERT INTO `sys_role_menu` VALUES ('1', '140202');
INSERT INTO `sys_role_menu` VALUES ('1', '140203');
INSERT INTO `sys_role_menu` VALUES ('1', '140205');

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
INSERT INTO `sys_user_role` VALUES ('1', '2');

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
INSERT INTO `users` VALUES ('1', 'admin', '$2a$10$XwLsucEO67/96xfPs9c1OulukfE9bLsO2RLfJHG/kRPDnOOydFzaq', 'admin@example.com', '1', '1', '18800000001', '男', '超级管理员', '', null, '2025-08-18 14:55:05', '2025-08-25 10:26:11', null, '0');
INSERT INTO `users` VALUES ('3', 'zhangsan', '$2a$10$XwLsucEO67/96xfPs9c1OulukfE9bLsO2RLfJHG/kRPDnOOydFzaq', 'zhangsan@example.com', '1', '1', '13800000001', '男', '张三', '', null, '2025-08-28 15:26:45', '2025-08-28 15:26:45', null, '1');
INSERT INTO `users` VALUES ('4', 'lisi', '$2a$10$XwLsucEO67/96xfPs9c1OulukfE9bLsO2RLfJHG/kRPDnOOydFzaq', 'lisi@example.com', '1', '1', '13800000002', '男', '李四', '', null, '2025-08-28 15:26:45', '2025-08-28 15:26:45', null, '1');
INSERT INTO `users` VALUES ('5', 'wangwu', '$2a$10$XwLsucEO67/96xfPs9c1OulukfE9bLsO2RLfJHG/kRPDnOOydFzaq', 'wangwu@example.com', '1', '1', '13800000003', '男', '王五', '', null, '2025-08-28 15:26:45', '2025-08-28 15:26:45', null, '1');
INSERT INTO `users` VALUES ('6', 'zhaoliu', '$2a$10$XwLsucEO67/96xfPs9c1OulukfE9bLsO2RLfJHG/kRPDnOOydFzaq', 'zhaoliu@example.com', '1', '1', '13800000004', '男', '赵六', '', null, '2025-08-28 15:26:45', '2025-08-28 15:26:45', null, '1');
INSERT INTO `users` VALUES ('7', 'sunqi', '$2a$10$XwLsucEO67/96xfPs9c1OulukfE9bLsO2RLfJHG/kRPDnOOydFzaq', 'sunqi@example.com', '1', '1', '13800000005', '男', '孙七', '', null, '2025-08-28 15:26:45', '2025-08-28 15:26:45', null, '1');
INSERT INTO `users` VALUES ('8', 'zhouba', '$2a$10$XwLsucEO67/96xfPs9c1OulukfE9bLsO2RLfJHG/kRPDnOOydFzaq', 'zhouba@example.com', '1', '1', '13800000006', '男', '周八', '', null, '2025-08-28 15:26:45', '2025-08-28 15:26:45', null, '1');
INSERT INTO `users` VALUES ('9', 'wujiu', '$2a$10$XwLsucEO67/96xfPs9c1OulukfE9bLsO2RLfJHG/kRPDnOOydFzaq', 'wujiu@example.com', '1', '1', '13800000007', '男', '吴九', '', null, '2025-08-28 15:26:45', '2025-08-28 15:26:45', null, '1');
INSERT INTO `users` VALUES ('10', 'zhengshi', '$2a$10$XwLsucEO67/96xfPs9c1OulukfE9bLsO2RLfJHG/kRPDnOOydFzaq', 'zhengshi@example.com', '1', '1', '13800000008', '男', '郑十', '', null, '2025-08-28 15:26:45', '2025-08-28 15:26:45', null, '1');
INSERT INTO `users` VALUES ('11', 'lihua', '$2a$10$XwLsucEO67/96xfPs9c1OulukfE9bLsO2RLfJHG/kRPDnOOydFzaq', 'lihua@example.com', '1', '1', '13800000009', '女', '李华', '', null, '2025-08-28 15:26:45', '2025-08-28 15:26:45', null, '1');
INSERT INTO `users` VALUES ('12', 'hanmei', '$2a$10$XwLsucEO67/96xfPs9c1OulukfE9bLsO2RLfJHG/kRPDnOOydFzaq', 'hanmei@example.com', '1', '1', '13800000010', '女', '韩梅', '', null, '2025-08-28 15:26:45', '2025-08-28 15:26:45', null, '1');
INSERT INTO `users` VALUES ('13', 'lucy', '$2a$10$XwLsucEO67/96xfPs9c1OulukfE9bLsO2RLfJHG/kRPDnOOydFzaq', 'lucy@example.com', '1', '1', '13800000011', '女', '露西', '', null, '2025-08-28 15:26:45', '2025-08-28 15:26:45', null, '1');
INSERT INTO `users` VALUES ('14', 'tom', '$2a$10$XwLsucEO67/96xfPs9c1OulukfE9bLsO2RLfJHG/kRPDnOOydFzaq', 'tom@example.com', '1', '1', '13800000012', '男', '汤姆', '', null, '2025-08-28 15:26:45', '2025-08-28 15:26:45', null, '1');
INSERT INTO `users` VALUES ('15', 'jerry', '$2a$10$XwLsucEO67/96xfPs9c1OulukfE9bLsO2RLfJHG/kRPDnOOydFzaq', 'jerry@example.com', '1', '1', '13800000013', '男', '杰瑞', '', null, '2025-08-28 15:26:45', '2025-08-28 15:26:45', null, '1');
INSERT INTO `users` VALUES ('16', 'alice', '$2a$10$XwLsucEO67/96xfPs9c1OulukfE9bLsO2RLfJHG/kRPDnOOydFzaq', 'alice@example.com', '1', '1', '13800000014', '女', '爱丽丝', '', null, '2025-08-28 15:26:45', '2025-08-28 15:26:45', null, '1');
INSERT INTO `users` VALUES ('17', 'bob', '$2a$10$XwLsucEO67/96xfPs9c1OulukfE9bLsO2RLfJHG/kRPDnOOydFzaq', 'bob@example.com', '1', '1', '13800000015', '男', '鲍勃', '', null, '2025-08-28 15:26:45', '2025-08-28 15:26:45', null, '1');
