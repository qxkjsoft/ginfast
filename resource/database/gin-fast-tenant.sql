-- 本文件仅含表结构，不含数据。
-- 超管账号：首次启动时按 config.yml 的 server.initadmin 配置自动创建。
-- 菜单/API 数据：登录后通过系统【菜单管理-菜单恢复】功能，从 resource/database/menu_backup 备份导入。
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
-- Table structure for sys_menu_api
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu_api`;
CREATE TABLE `sys_menu_api` (
  `menu_id` int(11) unsigned NOT NULL,
  `api_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`menu_id`,`api_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;


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
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu` (
  `role_id` int(11) unsigned NOT NULL,
  `menu_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`role_id`,`menu_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;


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
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role` (
  `user_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
  `role_id` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '角色ID',
  PRIMARY KEY (`user_id`,`role_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;


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
