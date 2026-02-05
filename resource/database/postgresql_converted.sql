-- PostgreSQL SQL 转换文件
-- 由 MySQL SQL 转换而来

SET session_replication_role = replica;
SET client_min_messages TO WARNING;

-- Table structure for demo_students
DROP TABLE IF EXISTS demo_students;
CREATE TABLE demo_students (
    student_id SERIAL NOT NULL,
    student_name VARCHAR(50) NOT NULL,
    age INTEGER NOT NULL DEFAULT '18',
    gender VARCHAR(50) NOT NULL DEFAULT '',
    class_name VARCHAR(20) NOT NULL,
    admission_date TIMESTAMP NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    created_by INTEGER DEFAULT '0',
    tenant_id INTEGER DEFAULT '0',
    PRIMARY KEY (student_id)
);

COMMENT ON COLUMN demo_students.updated_at IS '更新时间';
COMMENT ON COLUMN demo_students.deleted_at IS '删除时间';
COMMENT ON COLUMN demo_students.created_by IS '创建人';
COMMENT ON COLUMN demo_students.student_name IS '姓名';
COMMENT ON COLUMN demo_students.age IS '年龄';
COMMENT ON COLUMN demo_students.gender IS '性别';
COMMENT ON COLUMN demo_students.admission_date IS '入学日期';
COMMENT ON COLUMN demo_students.created_at IS '创建时间';
COMMENT ON COLUMN demo_students.tenant_id IS '租户ID字段';
COMMENT ON COLUMN demo_students.class_name IS '班级名称';
COMMENT ON COLUMN demo_students.email IS ' 邮箱';
COMMENT ON COLUMN demo_students.phone IS '电话号码';
COMMENT ON COLUMN demo_students.address IS '地址';

-- Records of demo_students
-- Table structure for demo_teacher
DROP TABLE IF EXISTS demo_teacher;
CREATE TABLE demo_teacher (
    id SERIAL NOT NULL,
    name VARCHAR(50) NOT NULL,
    employee_id VARCHAR(20),
    gender SMALLINT DEFAULT '0',
    phone VARCHAR(20),
    email VARCHAR(100),
    subject VARCHAR(50),
    title VARCHAR(50),
    status SMALLINT DEFAULT '1',
    hire_date DATE,
    birth_date DATE,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    created_by INTEGER DEFAULT '0',
    PRIMARY KEY (id)
);

COMMENT ON COLUMN demo_teacher.updated_at IS '更新时间';
COMMENT ON COLUMN demo_teacher.id IS '主键ID';
COMMENT ON COLUMN demo_teacher.name IS '教师姓名';
COMMENT ON COLUMN demo_teacher.employee_id IS '工号';
COMMENT ON COLUMN demo_teacher.gender IS '性别：0-未知 1-男 2-女';
COMMENT ON COLUMN demo_teacher.email IS '邮箱';
COMMENT ON COLUMN demo_teacher.subject IS '所教学科';
COMMENT ON COLUMN demo_teacher.created_at IS '创建时间';
COMMENT ON COLUMN demo_teacher.hire_date IS '入职日期';
COMMENT ON COLUMN demo_teacher.created_by IS '创建人';
COMMENT ON COLUMN demo_teacher.deleted_at IS '删除时间';
COMMENT ON COLUMN demo_teacher.birth_date IS '出生日期';
COMMENT ON COLUMN demo_teacher.phone IS '手机号';
COMMENT ON COLUMN demo_teacher.title IS '职称';
COMMENT ON COLUMN demo_teacher.status IS '状态：0-离职 1-在职';

-- Records of demo_teacher
-- Table structure for example
DROP TABLE IF EXISTS example;
CREATE TABLE example (
    id SERIAL NOT NULL,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    created_by INTEGER,
    tenant_id INTEGER DEFAULT '0',
    PRIMARY KEY (id)
);

COMMENT ON COLUMN example.name IS '名称';
COMMENT ON COLUMN example.description IS '描述';
COMMENT ON COLUMN example.tenant_id IS '租户ID字段';

-- Records of example
INSERT INTO example VALUES ('1', '项目管理系统', '用于管理项目进度和任务分配的系统', '2024-01-15 09:30:00', '2024-01-20 14:25:00', NULL, '1', '1');
INSERT INTO example VALUES ('2', '客户关系管理', '帮助企业维护客户关系的软件平台', '2024-01-16 10:15:00', '2024-01-22 11:40:00', NULL, '1', '1');
INSERT INTO example VALUES ('3', '财务分析工具', '提供财务报表和数据分析功能', '2024-01-17 14:20:00', '2024-01-25 16:30:00', NULL, '1', '1');
INSERT INTO example VALUES ('4', '库存管理系统', '实时跟踪和管理库存水平', '2024-01-18 08:45:00', '2024-01-26 09:15:00', NULL, '1', '1');
INSERT INTO example VALUES ('5', '人力资源平台', '员工信息管理和招聘流程优化', '2024-01-19 11:30:00', '2024-01-27 13:20:00', NULL, '1', '1');
INSERT INTO example VALUES ('6', '在线学习系统', '提供课程管理和在线学习功能', '2024-01-20 15:10:00', '2024-01-28 17:05:00', NULL, '1', '1');
INSERT INTO example VALUES ('7', '营销自动化', '自动化营销活动和客户跟进', '2024-01-21 09:00:00', '2024-01-29 10:45:00', NULL, '1', '1');
INSERT INTO example VALUES ('8', '数据可视化', '将数据转化为直观的图表和报告', '2024-01-22 13:25:00', '2024-01-30 15:30:00', NULL, '1', '1');
INSERT INTO example VALUES ('9', '移动应用开发', '跨平台移动应用开发框架', '2024-01-23 16:40:00', '2024-01-31 18:20:00', NULL, '1', '1');
INSERT INTO example VALUES ('10', '云存储服务', '安全可靠的云端文件存储解决方案', '2024-01-24 10:50:00', '2024-02-01 12:35:00', NULL, '1', '1');
INSERT INTO example VALUES ('11', '智能客服系统', '基于AI的智能客户服务助手', '2024-01-25 14:15:00', '2024-02-02 16:10:00', NULL, '1', '1');
INSERT INTO example VALUES ('12', '供应链管理', '优化供应链流程和物流管理', '2024-01-26 08:30:00', '2024-02-03 10:25:00', NULL, '1', '1');
INSERT INTO example VALUES ('13', '质量控制系统', '产品质量检测和流程监控', '2024-01-27 11:45:00', '2024-02-04 13:40:00', NULL, '1', '1');
INSERT INTO example VALUES ('14', '企业门户网站', '企业信息发布和员工协作平台', '2024-01-28 15:20:00', '2024-02-05 17:15:00', NULL, '1', '1');
INSERT INTO example VALUES ('15', '数据分析平台', '大数据处理和分析工具集', '2024-01-29 09:35:00', '2024-02-06 11:30:00', NULL, '1', '1');
-- Table structure for sys_affix
DROP TABLE IF EXISTS sys_affix;
CREATE TABLE sys_affix (
    id SERIAL NOT NULL,
    name VARCHAR(255),
    path VARCHAR(255),
    url VARCHAR(255),
    size INTEGER,
    ftype VARCHAR(100),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    created_by INTEGER,
    suffix VARCHAR(100),
    tenant_id INTEGER DEFAULT '0',
    thumbnail_path VARCHAR(255),
    thumbnail_name VARCHAR(255),
    thumbnail_url VARCHAR(255),
    PRIMARY KEY (id)
);

COMMENT ON COLUMN sys_affix.name IS '文件名';
COMMENT ON COLUMN sys_affix.path IS '路径';
COMMENT ON COLUMN sys_affix.size IS '文件大小';
COMMENT ON COLUMN sys_affix.ftype IS '文件类型';
COMMENT ON COLUMN sys_affix.tenant_id IS '租户ID字段';
COMMENT ON COLUMN sys_affix.thumbnail_name IS '缩略图名称';
COMMENT ON COLUMN sys_affix.id IS 'ID';
COMMENT ON COLUMN sys_affix.url IS '文件url';
COMMENT ON COLUMN sys_affix.suffix IS '文件后缀';
COMMENT ON COLUMN sys_affix.thumbnail_path IS '缩略图路径';
COMMENT ON COLUMN sys_affix.thumbnail_url IS '缩略图URL';

-- Records of sys_affix
-- Table structure for sys_api
DROP TABLE IF EXISTS sys_api;
CREATE TABLE sys_api (
    id SERIAL NOT NULL,
    title VARCHAR(255),
    path VARCHAR(255),
    method VARCHAR(32),
    api_group VARCHAR(255),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    created_by INTEGER,
    PRIMARY KEY (id)
);

COMMENT ON COLUMN sys_api.title IS '权限名称';
COMMENT ON COLUMN sys_api.path IS '权限路径';
COMMENT ON COLUMN sys_api.method IS '请求方法';
COMMENT ON COLUMN sys_api.api_group IS '分组';

-- Records of sys_api
INSERT INTO sys_api VALUES ('1', '用户登录', '/api/login', 'POST', '认证管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', NULL, '1');
INSERT INTO sys_api VALUES ('2', '刷新Token', '/api/refreshToken', 'POST', '认证管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', NULL, '1');
INSERT INTO sys_api VALUES ('3', '生成验证码ID', '/api/captcha/id', 'GET', '认证管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', NULL, '1');
INSERT INTO sys_api VALUES ('4', '获取验证码图片', '/api/captcha/image', 'GET', '认证管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', NULL, '1');
INSERT INTO sys_api VALUES ('5', '用户登出', '/api/users/logout', 'POST', '认证管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', NULL, '1');
INSERT INTO sys_api VALUES ('6', '获取当前用户信息', '/api/users/profile', 'GET', '用户管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', NULL, '1');
INSERT INTO sys_api VALUES ('7', '根据ID获取用户信息', '/api/users/:id', 'GET', '用户管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', NULL, '1');
INSERT INTO sys_api VALUES ('8', '用户列表', '/api/users/list', 'GET', '用户管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', NULL, '1');
INSERT INTO sys_api VALUES ('9', '新增用户', '/api/users/add', 'POST', '用户管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', NULL, '1');
INSERT INTO sys_api VALUES ('10', '更新用户信息', '/api/users/edit', 'PUT', '用户管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', NULL, '1');
INSERT INTO sys_api VALUES ('11', '删除用户', '/api/users/delete', 'DELETE', '用户管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', NULL, '1');
INSERT INTO sys_api VALUES ('12', '获取用户权限菜单', '/api/sysMenu/getRouters', 'GET', '菜单管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, '1');
INSERT INTO sys_api VALUES ('13', '获取完整菜单列表', '/api/sysMenu/getMenuList', 'GET', '菜单管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, '1');
INSERT INTO sys_api VALUES ('14', '根据ID获取菜单信息', '/api/sysMenu/:id', 'GET', '菜单管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, '1');
INSERT INTO sys_api VALUES ('15', '新增菜单', '/api/sysMenu/add', 'POST', '菜单管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, '1');
INSERT INTO sys_api VALUES ('16', '更新菜单', '/api/sysMenu/edit', 'PUT', '菜单管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, '1');
INSERT INTO sys_api VALUES ('17', '删除菜单', '/api/sysMenu/delete', 'DELETE', '菜单管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, '1');
INSERT INTO sys_api VALUES ('18', '获取部门列表', '/api/sysDepartment/getDivision', 'GET', '部门管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, '1');
INSERT INTO sys_api VALUES ('19', '获取所有角色数据', '/api/sysRole/getRoles', 'GET', '角色管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, '1');
INSERT INTO sys_api VALUES ('20', '根据角色ID获取角色菜单权限', '/api/sysRole/getUserPermission/:roleId', 'GET', '角色管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, '1');
INSERT INTO sys_api VALUES ('21', '添加角色的菜单权限', '/api/sysRole/addRoleMenu', 'POST', '角色管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, '1');
INSERT INTO sys_api VALUES ('22', '角色分页列表', '/api/sysRole/list', 'GET', '角色管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, '1');
INSERT INTO sys_api VALUES ('23', '根据ID获取角色信息', '/api/sysRole/:id', 'GET', '角色管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, '1');
INSERT INTO sys_api VALUES ('24', '新增角色', '/api/sysRole/add', 'POST', '角色管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, '1');
INSERT INTO sys_api VALUES ('25', '更新角色', '/api/sysRole/edit', 'PUT', '角色管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, '1');
INSERT INTO sys_api VALUES ('26', '删除角色', '/api/sysRole/delete', 'DELETE', '角色管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, '1');
INSERT INTO sys_api VALUES ('27', '获取所有字典数据', '/api/sysDict/getAllDicts', 'GET', '字典管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, '1');
INSERT INTO sys_api VALUES ('28', '根据字典编码获取字典', '/api/sysDict/getByCode/:code', 'GET', '字典管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, '1');
INSERT INTO sys_api VALUES ('29', 'API列表', '/api/sysApi/list', 'GET', 'API管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, '1');
INSERT INTO sys_api VALUES ('30', '根据ID获取API信息', '/api/sysApi/:id', 'GET', 'API管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, '1');
INSERT INTO sys_api VALUES ('31', '新增API', '/api/sysApi/add', 'POST', 'API管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, '1');
INSERT INTO sys_api VALUES ('32', '更新API', '/api/sysApi/edit', 'PUT', 'API管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, '1');
INSERT INTO sys_api VALUES ('33', '删除API', '/api/sysApi/delete', 'DELETE', 'API管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, '1');
INSERT INTO sys_api VALUES ('34', '测试11', '/api/sysTest/test', 'POST', 'test', '2025-09-03 11:14:23', '2025-09-03 11:30:19', NULL, '1');
INSERT INTO sys_api VALUES ('35', '根据菜单ID获取API的ID集合', '/api/sysMenu/apis/:id', 'GET', '菜单管理', '2025-09-04 17:25:14', '2025-09-04 17:25:14', NULL, '1');
INSERT INTO sys_api VALUES ('36', '设置菜单API权限', '/api/sysMenu/setApis', 'POST', '菜单管理', '2025-09-04 17:26:04', '2025-09-04 17:26:04', NULL, '1');
INSERT INTO sys_api VALUES ('37', '根据ID获取部门信息', '/api/sysDepartment/:id', 'GET', '部门管理', '2025-09-12 14:46:42', '2025-09-12 14:46:42', NULL, '1');
INSERT INTO sys_api VALUES ('38', '新增部门', '/api/sysDepartment/add', 'POST', '部门管理', '2025-09-12 14:47:27', '2025-09-12 14:47:27', NULL, '1');
INSERT INTO sys_api VALUES ('39', '更新部门', '/api/sysDepartment/edit', 'PUT', '部门管理', '2025-09-12 14:48:15', '2025-09-12 14:48:27', NULL, '1');
INSERT INTO sys_api VALUES ('40', '删除部门', '/api/sysDepartment/delete', 'DELETE', '部门管理', '2025-09-12 14:49:15', '2025-09-12 14:49:15', NULL, '1');
INSERT INTO sys_api VALUES ('41', '字典分页列表', '/api/sysDict/list', 'GET', '字典管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', NULL, '1');
INSERT INTO sys_api VALUES ('42', '根据ID获取字典信息', '/api/sysDict/:id', 'GET', '字典管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', NULL, '1');
INSERT INTO sys_api VALUES ('43', '新增字典', '/api/sysDict/add', 'POST', '字典管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', NULL, '1');
INSERT INTO sys_api VALUES ('44', '更新字典', '/api/sysDict/edit', 'PUT', '字典管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', NULL, '1');
INSERT INTO sys_api VALUES ('45', '删除字典', '/api/sysDict/delete', 'DELETE', '字典管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', NULL, '1');
INSERT INTO sys_api VALUES ('46', '字典项列表', '/api/sysDictItem/list', 'GET', '字典项管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', NULL, '1');
INSERT INTO sys_api VALUES ('47', '根据ID获取字典项信息', '/api/sysDictItem/:id', 'GET', '字典项管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', NULL, '1');
INSERT INTO sys_api VALUES ('48', '根据字典ID获取字典项列表', '/api/sysDictItem/getByDictId/:dictId', 'GET', '字典项管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', NULL, '1');
INSERT INTO sys_api VALUES ('49', '根据字典编码获取字典项列表', '/api/sysDictItem/getByDictCode/:dictCode', 'GET', '字典项管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', NULL, '1');
INSERT INTO sys_api VALUES ('50', '新增字典项', '/api/sysDictItem/add', 'POST', '字典项管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', NULL, '1');
INSERT INTO sys_api VALUES ('51', '更新字典项', '/api/sysDictItem/edit', 'PUT', '字典项管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', NULL, '1');
INSERT INTO sys_api VALUES ('52', '删除字典项', '/api/sysDictItem/delete', 'DELETE', '字典项管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', NULL, '1');
INSERT INTO sys_api VALUES ('53', '修改用户密码、手机号及邮箱', '/api/users/updateAccount', 'PUT', '用户管理', '2025-09-18 18:11:01', '2025-09-18 18:11:01', NULL, '1');
INSERT INTO sys_api VALUES ('54', '头像上传', '/api/users/uploadAvatar', 'POST', '用户管理', '2025-09-24 17:01:05', '2025-09-24 17:01:05', NULL, '1');
INSERT INTO sys_api VALUES ('55', '上传文件', '/api/sysAffix/upload', 'POST', '文件管理', '2025-09-25 15:51:04', '2025-09-25 15:51:04', NULL, '1');
INSERT INTO sys_api VALUES ('56', '删除文件', '/api/sysAffix/delete', 'DELETE', '文件管理', '2025-09-25 15:51:38', '2025-09-25 15:51:38', NULL, '1');
INSERT INTO sys_api VALUES ('57', '修改文件名', '/api/sysAffix/updateName', 'PUT', '文件管理', '2025-09-25 15:52:31', '2025-09-25 15:52:31', NULL, '1');
INSERT INTO sys_api VALUES ('58', '文件列表', '/api/sysAffix/list', 'GET', '文件管理', '2025-09-25 15:54:03', '2025-09-25 15:54:03', NULL, '1');
INSERT INTO sys_api VALUES ('59', '获取文件详情', '/api/sysAffix/:id', 'GET', '文件管理', '2025-09-25 15:54:55', '2025-09-25 15:54:55', NULL, '1');
INSERT INTO sys_api VALUES ('60', '下载文件', '/api/sysAffix/download/:id', 'GET', '文件管理', '2025-09-25 15:56:15', '2025-09-25 15:58:06', NULL, '1');
INSERT INTO sys_api VALUES ('61', '设置数据权限', '/api/sysRole/dataScope', 'PUT', '角色管理', '2025-09-26 17:04:15', '2025-09-26 17:04:15', NULL, '1');
INSERT INTO sys_api VALUES ('62', '读取系统配置', '/api/config/get', 'GET', '系统配置', '2025-10-09 16:21:29', '2025-10-09 16:21:29', NULL, '1');
INSERT INTO sys_api VALUES ('63', '修改系统配置', '/api/config/update', 'PUT', '系统配置', '2025-10-09 16:21:59', '2025-10-09 16:22:09', NULL, '1');
INSERT INTO sys_api VALUES ('64', '查看内存缓存', '/api/config/viewCache', 'GET', '系统配置', '2025-10-10 17:41:33', '2025-10-10 17:41:33', NULL, '1');
INSERT INTO sys_api VALUES ('65', '列表查询', '/api/plugins/example/list', 'GET', '插件示例', '2025-10-14 10:54:47', '2025-10-14 10:54:47', NULL, '1');
INSERT INTO sys_api VALUES ('66', '新增', '/api/plugins/example/add', 'POST', '插件示例', '2025-10-14 10:56:43', '2025-10-14 10:56:43', NULL, '1');
INSERT INTO sys_api VALUES ('67', '修改', '/api/plugins/example/edit', 'PUT', '插件示例', '2025-10-14 10:57:10', '2025-10-14 10:57:17', NULL, '1');
INSERT INTO sys_api VALUES ('68', '删除', '/api/plugins/example/delete', 'DELETE', '插件示例', '2025-10-14 10:58:03', '2025-10-14 10:58:03', NULL, '1');
INSERT INTO sys_api VALUES ('69', '查询单条数据', '/api/plugins/example/:id', 'GET', '插件示例', '2025-10-14 10:59:33', '2025-10-14 10:59:33', NULL, '1');
INSERT INTO sys_api VALUES ('70', '日志列表', '/api/sysOperationLog/list', 'GET', '日志管理', '2025-10-20 10:10:58', '2025-10-20 10:10:58', NULL, '1');
INSERT INTO sys_api VALUES ('71', '日志统计', '/api/sysOperationLog/stats', 'GET', '日志管理', '2025-10-20 10:12:01', '2025-10-20 10:12:01', '2025-10-20 10:45:07', '1');
INSERT INTO sys_api VALUES ('72', '日志删除', '/api/sysOperationLog/delete', 'DELETE', '日志管理', '2025-10-20 10:13:19', '2025-10-20 10:13:19', NULL, '1');
INSERT INTO sys_api VALUES ('73', '日志导出', '/api/sysOperationLog/export', 'GET', '日志管理', '2025-10-20 10:14:11', '2025-10-20 10:14:11', NULL, '1');
INSERT INTO sys_api VALUES ('74', '导出菜单', '/api/sysMenu/export', 'GET', '菜单管理', '2025-10-20 17:17:07', '2025-10-20 17:17:07', NULL, '1');
INSERT INTO sys_api VALUES ('75', '导入菜单', '/api/sysMenu/import', 'POST', '菜单管理', '2025-10-21 11:30:34', '2025-10-24 08:59:44', NULL, '1');
INSERT INTO sys_api VALUES ('76', '租户列表', '/api/sysTenant/list', 'GET', '租户管理', '2025-10-24 09:04:18', '2025-10-24 09:04:18', NULL, '1');
INSERT INTO sys_api VALUES ('77', '根据ID获取租户信息', '/api/sysTenant/:id', 'GET', '租户管理', '2025-10-24 09:05:23', '2025-10-24 09:05:23', NULL, '1');
INSERT INTO sys_api VALUES ('78', '新增租户', '/api/sysTenant/add', 'POST', '租户管理', '2025-10-24 09:06:10', '2025-10-24 09:06:10', NULL, '1');
INSERT INTO sys_api VALUES ('79', '编辑租户', '/api/sysTenant/edit', 'PUT', '租户管理', '2025-10-24 09:06:54', '2025-10-24 09:06:54', NULL, '1');
INSERT INTO sys_api VALUES ('80', '删除租户', '/api/sysTenant/:id', 'DELETE', '租户管理', '2025-10-24 09:07:47', '2025-10-24 09:07:56', NULL, '1');
INSERT INTO sys_api VALUES ('81', '租户关联列表', '/api/sysUserTenant/list', 'GET', '租户管理', '2025-10-27 17:51:52', '2025-10-27 17:51:52', NULL, '1');
INSERT INTO sys_api VALUES ('82', '根据用户ID和租户ID获取用户租户关联信息', '/api/sysUserTenant/get', 'GET', '租户管理', '2025-10-27 17:53:13', '2025-10-27 17:53:13', NULL, '1');
INSERT INTO sys_api VALUES ('83', '批量新增用户租户关联', '/api/sysUserTenant/batchAdd', 'POST', '租户管理', '2025-10-27 17:53:48', '2025-10-27 17:53:48', NULL, '1');
INSERT INTO sys_api VALUES ('84', '批量删除用户租户关联', '/api/sysUserTenant/batchDelete', 'DELETE', '租户管理', '2025-10-27 17:54:25', '2025-10-27 17:54:25', NULL, '1');
INSERT INTO sys_api VALUES ('85', '用户列表(不限租户)', '/api/sysUserTenant/userListAll', 'GET', '用户管理', '2025-10-28 09:41:19', '2025-10-28 16:32:35', NULL, '1');
INSERT INTO sys_api VALUES ('86', '获取所有的角色数据(不限制租户)', '/api/sysUserTenant/getRolesAll', 'GET', '租户管理', '2025-10-29 09:17:01', '2025-10-29 09:17:01', NULL, '1');
INSERT INTO sys_api VALUES ('87', '设置用户角色(不限租户)', '/api/sysUserTenant/setUserRoles', 'POST', '租户管理 ', '2025-10-29 09:17:50', '2025-10-29 09:17:50', NULL, '1');
INSERT INTO sys_api VALUES ('88', '获取用户角色ID集合(不限租户)', '/api/sysUserTenant/getUserRoleIDs', 'GET', '租户管理', '2025-10-29 09:18:51', '2025-10-29 09:18:51', NULL, '1');
INSERT INTO sys_api VALUES ('89', '修改用户基本信息', '/api/users/updateBasicInfo', 'PUT', '用户管理', '2025-10-31 09:05:00', '2025-10-31 09:05:00', NULL, '1');
INSERT INTO sys_api VALUES ('105', '生成代码文件', '/api/codegen/generate', 'POST', '代码生成', '2025-11-07 15:32:53', '2025-11-07 15:32:53', NULL, '1');
INSERT INTO sys_api VALUES ('106', '获取表的字段信息', '/api/codegen/columns', 'GET', '代码生成', '2025-11-07 15:33:52', '2025-11-07 15:33:52', NULL, '1');
INSERT INTO sys_api VALUES ('187', '获取数据库列表', '/api/codegen/databases', 'GET', '代码生成', '2025-11-17 15:12:26', '2025-11-17 15:12:26', NULL, '1');
INSERT INTO sys_api VALUES ('188', '获取指定数据库中的表集合', '/api/codegen/tables', 'GET', '代码生成', '2025-11-17 15:13:38', '2025-11-17 15:13:38', NULL, '1');
INSERT INTO sys_api VALUES ('189', '代码预览', '/api/codegen/preview', 'GET', '代码生成', '2025-11-17 15:14:25', '2025-11-17 15:14:25', NULL, '1');
INSERT INTO sys_api VALUES ('190', '代码生成配置列表', '/api/sysGen/list', 'GET', '代码生成', '2025-11-17 15:15:20', '2025-11-17 15:15:20', NULL, '1');
INSERT INTO sys_api VALUES ('191', ' 批量创建代码生成配置', '/api/sysGen/batchInsert', 'POST', '代码生成', '2025-11-17 15:22:46', '2025-11-17 15:22:46', NULL, '1');
INSERT INTO sys_api VALUES ('192', '获取代码生成配置详情', '/api/sysGen/:id', 'GET', '代码生成', '2025-11-17 15:23:29', '2025-11-17 15:23:29', NULL, '1');
INSERT INTO sys_api VALUES ('193', '更新代码生成配置和字段信息', '/api/sysGen/update', 'PUT', '代码生成', '2025-11-17 15:24:41', '2025-11-17 15:24:41', NULL, '1');
INSERT INTO sys_api VALUES ('194', '删除代码生成配置和字段信息', '/api/sysGen/:id', 'DELETE', '代码生成', '2025-11-17 15:26:44', '2025-11-17 15:26:44', NULL, '1');
INSERT INTO sys_api VALUES ('195', '刷新代码生成配置的字段信息', '/api/sysGen/refreshFields', 'PUT', '代码生成', '2025-11-17 15:27:33', '2025-11-17 15:27:33', NULL, '1');
INSERT INTO sys_api VALUES ('196', '生成菜单', '/api/codegen/insertmenuandapi', 'POST', '代码生成', '2025-11-26 15:12:56', '2025-11-26 15:12:56', NULL, '1');
INSERT INTO sys_api VALUES ('197', '批量删除', '/api/sysMenu/batchDelete', 'DELETE', '菜单管理', '2025-12-05 17:48:52', '2025-12-05 17:48:52', NULL, '1');
INSERT INTO sys_api VALUES ('198', '获取插件列表', '/api/pluginsmanager/exports', 'GET', '插件管理', '2025-12-08 16:38:26', '2025-12-08 16:38:26', NULL, '1');
INSERT INTO sys_api VALUES ('199', '导出插件', '/api/pluginsmanager/export', 'POST', '插件管理', '2025-12-08 16:39:19', '2025-12-08 16:44:36', NULL, '1');
INSERT INTO sys_api VALUES ('200', '导入插件', '/api/pluginsmanager/import', 'POST', '插件管理', '2025-12-08 16:47:11', '2025-12-08 16:47:11', NULL, '1');
INSERT INTO sys_api VALUES ('201', '卸载插件', '/api/pluginsmanager/uninstall', 'DELETE', '插件管理', '2025-12-08 16:48:07', '2025-12-08 16:48:07', NULL, '1');
INSERT INTO sys_api VALUES ('202', '切换租户', '/api/users/switchTenant/:tenantld', 'GET', '用户管理', '2026-01-09 16:29:37', '2026-01-09 16:29:37', NULL, '1');
-- Table structure for sys_casbin_rule
DROP TABLE IF EXISTS sys_casbin_rule;
CREATE TABLE sys_casbin_rule (
    id SERIAL NOT NULL,
    ptype VARCHAR(100),
    v0 VARCHAR(100),
    v1 VARCHAR(100),
    v2 VARCHAR(100),
    v3 VARCHAR(100),
    v4 VARCHAR(100),
    v5 VARCHAR(100),
    PRIMARY KEY (id)
);


-- Records of sys_casbin_rule
INSERT INTO sys_casbin_rule VALUES ('6266', 'g', 'user_1', 'role_1', '*', '', '', '');
INSERT INTO sys_casbin_rule VALUES ('4189', 'g', 'user_4', 'role_2', '*', '', '', '');
INSERT INTO sys_casbin_rule VALUES ('7045', 'p', 'role_1', '/api/codegen/generate', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7092', 'p', 'role_1', '/api/codegen/insertmenuandapi', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7091', 'p', 'role_1', '/api/codegen/preview', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7025', 'p', 'role_1', '/api/codegen/tables', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7037', 'p', 'role_1', '/api/config/get', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7107', 'p', 'role_1', '/api/config/update', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7100', 'p', 'role_1', '/api/config/viewCache', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7111', 'p', 'role_1', '/api/plugins/example/:id', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7032', 'p', 'role_1', '/api/plugins/example/add', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7048', 'p', 'role_1', '/api/plugins/example/delete', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7082', 'p', 'role_1', '/api/plugins/example/edit', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7110', 'p', 'role_1', '/api/plugins/example/list', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7065', 'p', 'role_1', '/api/pluginsmanager/export', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7098', 'p', 'role_1', '/api/pluginsmanager/exports', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7087', 'p', 'role_1', '/api/pluginsmanager/import', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7103', 'p', 'role_1', '/api/pluginsmanager/uninstall', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7096', 'p', 'role_1', '/api/sysAffix/delete', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7066', 'p', 'role_1', '/api/sysAffix/download/:id', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7029', 'p', 'role_1', '/api/sysAffix/list', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7099', 'p', 'role_1', '/api/sysAffix/updateName', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7095', 'p', 'role_1', '/api/sysAffix/upload', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7052', 'p', 'role_1', '/api/sysApi/:id', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7056', 'p', 'role_1', '/api/sysApi/add', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7072', 'p', 'role_1', '/api/sysApi/delete', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7071', 'p', 'role_1', '/api/sysApi/edit', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7075', 'p', 'role_1', '/api/sysApi/list', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7053', 'p', 'role_1', '/api/sysDepartment/add', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7073', 'p', 'role_1', '/api/sysDepartment/delete', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7042', 'p', 'role_1', '/api/sysDepartment/edit', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7069', 'p', 'role_1', '/api/sysDepartment/getDivision', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7085', 'p', 'role_1', '/api/sysDict/add', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7077', 'p', 'role_1', '/api/sysDict/delete', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7089', 'p', 'role_1', '/api/sysDict/edit', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7083', 'p', 'role_1', '/api/sysDict/getAllDicts', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7070', 'p', 'role_1', '/api/sysDict/list', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7074', 'p', 'role_1', '/api/sysDictItem/add', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7036', 'p', 'role_1', '/api/sysDictItem/delete', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7090', 'p', 'role_1', '/api/sysDictItem/edit', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7078', 'p', 'role_1', '/api/sysDictItem/getByDictId/:dictId', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7046', 'p', 'role_1', '/api/sysGen/:id', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7064', 'p', 'role_1', '/api/sysGen/:id', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7057', 'p', 'role_1', '/api/sysGen/batchInsert', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7049', 'p', 'role_1', '/api/sysGen/list', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7054', 'p', 'role_1', '/api/sysGen/refreshFields', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7031', 'p', 'role_1', '/api/sysGen/update', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7094', 'p', 'role_1', '/api/sysMenu/add', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7035', 'p', 'role_1', '/api/sysMenu/apis/:id', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7055', 'p', 'role_1', '/api/sysMenu/batchDelete', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7076', 'p', 'role_1', '/api/sysMenu/delete', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7034', 'p', 'role_1', '/api/sysMenu/edit', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7079', 'p', 'role_1', '/api/sysMenu/export', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7104', 'p', 'role_1', '/api/sysMenu/getMenuList', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7051', 'p', 'role_1', '/api/sysMenu/getRouters', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7043', 'p', 'role_1', '/api/sysMenu/import', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7060', 'p', 'role_1', '/api/sysMenu/setApis', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7039', 'p', 'role_1', '/api/sysOperationLog/delete', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7101', 'p', 'role_1', '/api/sysOperationLog/export', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7027', 'p', 'role_1', '/api/sysOperationLog/list', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7028', 'p', 'role_1', '/api/sysRole/add', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7084', 'p', 'role_1', '/api/sysRole/addRoleMenu', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7109', 'p', 'role_1', '/api/sysRole/dataScope', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7059', 'p', 'role_1', '/api/sysRole/delete', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7058', 'p', 'role_1', '/api/sysRole/edit', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7088', 'p', 'role_1', '/api/sysRole/getRoles', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7105', 'p', 'role_1', '/api/sysRole/getUserPermission/:roleId', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7030', 'p', 'role_1', '/api/sysTenant/:id', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7062', 'p', 'role_1', '/api/sysTenant/:id', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7102', 'p', 'role_1', '/api/sysTenant/add', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7108', 'p', 'role_1', '/api/sysTenant/edit', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7061', 'p', 'role_1', '/api/sysTenant/list', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7097', 'p', 'role_1', '/api/sysUserTenant/batchAdd', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7080', 'p', 'role_1', '/api/sysUserTenant/batchDelete', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7086', 'p', 'role_1', '/api/sysUserTenant/get', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7081', 'p', 'role_1', '/api/sysUserTenant/getRolesAll', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7106', 'p', 'role_1', '/api/sysUserTenant/getUserRoleIDs', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7063', 'p', 'role_1', '/api/sysUserTenant/list', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7113', 'p', 'role_1', '/api/sysUserTenant/setUserRoles', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7112', 'p', 'role_1', '/api/sysUserTenant/userListAll', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7067', 'p', 'role_1', '/api/users/:id', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7033', 'p', 'role_1', '/api/users/add', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7041', 'p', 'role_1', '/api/users/delete', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7040', 'p', 'role_1', '/api/users/edit', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7093', 'p', 'role_1', '/api/users/list', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7047', 'p', 'role_1', '/api/users/logout', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7050', 'p', 'role_1', '/api/users/profile', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7068', 'p', 'role_1', '/api/users/switchTenant/:tenantld', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7038', 'p', 'role_1', '/api/users/updateAccount', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7044', 'p', 'role_1', '/api/users/updateBasicInfo', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7026', 'p', 'role_1', '/api/users/uploadAvatar', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4148', 'p', 'role_10', '/api/config/get', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4155', 'p', 'role_10', '/api/config/update', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4162', 'p', 'role_10', '/api/config/viewCache', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4168', 'p', 'role_10', '/api/sysAffix/list', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4125', 'p', 'role_10', '/api/sysApi/*', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4175', 'p', 'role_10', '/api/sysApi/add', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4179', 'p', 'role_10', '/api/sysApi/delete', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4153', 'p', 'role_10', '/api/sysApi/edit', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4158', 'p', 'role_10', '/api/sysApi/list', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4176', 'p', 'role_10', '/api/sysDepartment/add', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4133', 'p', 'role_10', '/api/sysDepartment/delete', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4167', 'p', 'role_10', '/api/sysDepartment/edit', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4122', 'p', 'role_10', '/api/sysDepartment/getDivision', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4136', 'p', 'role_10', '/api/sysDict/add', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4144', 'p', 'role_10', '/api/sysDict/delete', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4137', 'p', 'role_10', '/api/sysDict/edit', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4184', 'p', 'role_10', '/api/sysDict/getAllDicts', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4139', 'p', 'role_10', '/api/sysDict/list', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4146', 'p', 'role_10', '/api/sysDictItem/add', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4154', 'p', 'role_10', '/api/sysDictItem/delete', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4147', 'p', 'role_10', '/api/sysDictItem/edit', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4141', 'p', 'role_10', '/api/sysDictItem/getByDictId/*', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4174', 'p', 'role_10', '/api/sysMenu/add', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4145', 'p', 'role_10', '/api/sysMenu/apis/*', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4124', 'p', 'role_10', '/api/sysMenu/delete', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4123', 'p', 'role_10', '/api/sysMenu/edit', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4172', 'p', 'role_10', '/api/sysMenu/export', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4177', 'p', 'role_10', '/api/sysMenu/getMenuList', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4150', 'p', 'role_10', '/api/sysMenu/getRouters', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4126', 'p', 'role_10', '/api/sysMenu/import', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4161', 'p', 'role_10', '/api/sysMenu/setApis', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4134', 'p', 'role_10', '/api/sysOperationLog/delete', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4156', 'p', 'role_10', '/api/sysOperationLog/export', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4131', 'p', 'role_10', '/api/sysOperationLog/list', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4128', 'p', 'role_10', '/api/sysRole/add', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4135', 'p', 'role_10', '/api/sysRole/addRoleMenu', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4151', 'p', 'role_10', '/api/sysRole/dataScope', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4140', 'p', 'role_10', '/api/sysRole/delete', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4166', 'p', 'role_10', '/api/sysRole/edit', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4130', 'p', 'role_10', '/api/sysRole/getRoles', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4132', 'p', 'role_10', '/api/sysRole/getUserPermission/*', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4163', 'p', 'role_10', '/api/sysTenant/*', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4142', 'p', 'role_10', '/api/sysTenant/*', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4180', 'p', 'role_10', '/api/sysTenant/add', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4157', 'p', 'role_10', '/api/sysTenant/edit', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4173', 'p', 'role_10', '/api/sysTenant/list', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4164', 'p', 'role_10', '/api/sysUserTenant/batchAdd', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4169', 'p', 'role_10', '/api/sysUserTenant/batchDelete', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4149', 'p', 'role_10', '/api/sysUserTenant/get', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4182', 'p', 'role_10', '/api/sysUserTenant/getRolesAll', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4152', 'p', 'role_10', '/api/sysUserTenant/getUserRoleIDs', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4165', 'p', 'role_10', '/api/sysUserTenant/list', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4129', 'p', 'role_10', '/api/sysUserTenant/setUserRoles', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4181', 'p', 'role_10', '/api/sysUserTenant/userListAll', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4127', 'p', 'role_10', '/api/users/*', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4159', 'p', 'role_10', '/api/users/add', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4160', 'p', 'role_10', '/api/users/delete', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4178', 'p', 'role_10', '/api/users/edit', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4143', 'p', 'role_10', '/api/users/list', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4170', 'p', 'role_10', '/api/users/logout', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4183', 'p', 'role_10', '/api/users/profile', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4138', 'p', 'role_10', '/api/users/updateAccount', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('4171', 'p', 'role_10', '/api/users/uploadAvatar', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7118', 'p', 'role_2', '/api/codegen/generate', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7132', 'p', 'role_2', '/api/codegen/insertmenuandapi', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7183', 'p', 'role_2', '/api/codegen/preview', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7117', 'p', 'role_2', '/api/codegen/tables', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7129', 'p', 'role_2', '/api/config/get', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7163', 'p', 'role_2', '/api/config/update', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7188', 'p', 'role_2', '/api/config/viewCache', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7130', 'p', 'role_2', '/api/plugins/example/:id', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7147', 'p', 'role_2', '/api/plugins/example/add', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7156', 'p', 'role_2', '/api/plugins/example/delete', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7155', 'p', 'role_2', '/api/plugins/example/edit', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7149', 'p', 'role_2', '/api/plugins/example/list', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7152', 'p', 'role_2', '/api/pluginsmanager/export', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7126', 'p', 'role_2', '/api/pluginsmanager/exports', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7136', 'p', 'role_2', '/api/pluginsmanager/import', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7198', 'p', 'role_2', '/api/pluginsmanager/uninstall', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7196', 'p', 'role_2', '/api/sysAffix/delete', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7140', 'p', 'role_2', '/api/sysAffix/download/:id', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7115', 'p', 'role_2', '/api/sysAffix/list', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7162', 'p', 'role_2', '/api/sysAffix/updateName', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7154', 'p', 'role_2', '/api/sysAffix/upload', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7121', 'p', 'role_2', '/api/sysApi/:id', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7128', 'p', 'role_2', '/api/sysApi/add', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7187', 'p', 'role_2', '/api/sysApi/delete', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7145', 'p', 'role_2', '/api/sysApi/edit', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7144', 'p', 'role_2', '/api/sysApi/list', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7139', 'p', 'role_2', '/api/sysDepartment/add', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7170', 'p', 'role_2', '/api/sysDepartment/delete', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7122', 'p', 'role_2', '/api/sysDepartment/edit', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7173', 'p', 'role_2', '/api/sysDepartment/getDivision', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7195', 'p', 'role_2', '/api/sysDict/add', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7123', 'p', 'role_2', '/api/sysDict/delete', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7133', 'p', 'role_2', '/api/sysDict/edit', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7119', 'p', 'role_2', '/api/sysDict/getAllDicts', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7191', 'p', 'role_2', '/api/sysDict/list', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7146', 'p', 'role_2', '/api/sysDictItem/add', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7181', 'p', 'role_2', '/api/sysDictItem/delete', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7202', 'p', 'role_2', '/api/sysDictItem/edit', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7134', 'p', 'role_2', '/api/sysDictItem/getByDictId/:dictId', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7148', 'p', 'role_2', '/api/sysGen/:id', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7143', 'p', 'role_2', '/api/sysGen/:id', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7197', 'p', 'role_2', '/api/sysGen/batchInsert', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7135', 'p', 'role_2', '/api/sysGen/list', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7169', 'p', 'role_2', '/api/sysGen/refreshFields', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7172', 'p', 'role_2', '/api/sysGen/update', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7194', 'p', 'role_2', '/api/sysMenu/add', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7180', 'p', 'role_2', '/api/sysMenu/apis/:id', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7186', 'p', 'role_2', '/api/sysMenu/batchDelete', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7175', 'p', 'role_2', '/api/sysMenu/delete', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7114', 'p', 'role_2', '/api/sysMenu/edit', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7141', 'p', 'role_2', '/api/sysMenu/export', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7201', 'p', 'role_2', '/api/sysMenu/getMenuList', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7184', 'p', 'role_2', '/api/sysMenu/getRouters', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7131', 'p', 'role_2', '/api/sysMenu/import', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7138', 'p', 'role_2', '/api/sysMenu/setApis', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7189', 'p', 'role_2', '/api/sysOperationLog/delete', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7182', 'p', 'role_2', '/api/sysOperationLog/export', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7120', 'p', 'role_2', '/api/sysOperationLog/list', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7137', 'p', 'role_2', '/api/sysRole/add', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7179', 'p', 'role_2', '/api/sysRole/addRoleMenu', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7176', 'p', 'role_2', '/api/sysRole/dataScope', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7166', 'p', 'role_2', '/api/sysRole/delete', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7127', 'p', 'role_2', '/api/sysRole/edit', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7161', 'p', 'role_2', '/api/sysRole/getRoles', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7174', 'p', 'role_2', '/api/sysRole/getUserPermission/:roleId', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7190', 'p', 'role_2', '/api/sysTenant/:id', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7167', 'p', 'role_2', '/api/sysTenant/:id', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7150', 'p', 'role_2', '/api/sysTenant/add', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7164', 'p', 'role_2', '/api/sysTenant/edit', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7124', 'p', 'role_2', '/api/sysTenant/list', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7151', 'p', 'role_2', '/api/sysUserTenant/batchAdd', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7168', 'p', 'role_2', '/api/sysUserTenant/batchDelete', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7177', 'p', 'role_2', '/api/sysUserTenant/get', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7171', 'p', 'role_2', '/api/sysUserTenant/getRolesAll', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7116', 'p', 'role_2', '/api/sysUserTenant/getUserRoleIDs', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7125', 'p', 'role_2', '/api/sysUserTenant/list', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7178', 'p', 'role_2', '/api/sysUserTenant/setUserRoles', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7142', 'p', 'role_2', '/api/sysUserTenant/userListAll', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7158', 'p', 'role_2', '/api/users/:id', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7185', 'p', 'role_2', '/api/users/add', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7193', 'p', 'role_2', '/api/users/delete', 'DELETE', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7192', 'p', 'role_2', '/api/users/edit', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7153', 'p', 'role_2', '/api/users/list', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7199', 'p', 'role_2', '/api/users/logout', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7200', 'p', 'role_2', '/api/users/profile', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7160', 'p', 'role_2', '/api/users/switchTenant/:tenantld', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7157', 'p', 'role_2', '/api/users/updateAccount', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7165', 'p', 'role_2', '/api/users/updateBasicInfo', 'PUT', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('7159', 'p', 'role_2', '/api/users/uploadAvatar', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('2966', 'p', 'role_4', '/api/sysAffix/list', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('2971', 'p', 'role_4', '/api/sysDict/getAllDicts', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('2970', 'p', 'role_4', '/api/sysMenu/getRouters', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('2969', 'p', 'role_4', '/api/users/*', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('2967', 'p', 'role_4', '/api/users/logout', 'POST', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('2968', 'p', 'role_4', '/api/users/profile', 'GET', '*', '', '');
INSERT INTO sys_casbin_rule VALUES ('2965', 'p', 'role_4', '/api/users/uploadAvatar', 'POST', '*', '', '');
-- Table structure for sys_department
DROP TABLE IF EXISTS sys_department;
CREATE TABLE sys_department (
    id SERIAL NOT NULL,
    parent_id INTEGER DEFAULT '0',
    name VARCHAR(255),
    status SMALLINT,
    leader VARCHAR(255),
    phone VARCHAR(255),
    email VARCHAR(255),
    sort INTEGER DEFAULT '0',
    describe VARCHAR(255),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    created_by INTEGER,
    tenant_id INTEGER DEFAULT '0',
    PRIMARY KEY (id)
);

COMMENT ON COLUMN sys_department.name IS '部门名称';
COMMENT ON COLUMN sys_department.phone IS '联系电话';
COMMENT ON COLUMN sys_department.email IS '邮箱';
COMMENT ON COLUMN sys_department.describe IS '描述';
COMMENT ON COLUMN sys_department.tenant_id IS '租户ID字段';
COMMENT ON COLUMN sys_department.parent_id IS '父级';
COMMENT ON COLUMN sys_department.status IS '状态： 0 停用 1 启用';
COMMENT ON COLUMN sys_department.leader IS '负责人';
COMMENT ON COLUMN sys_department.sort IS '排序';

-- Records of sys_department
INSERT INTO sys_department VALUES ('1', '0', '总部', '1', '张明', '13800000001', 'headquarters@company.com', '1', '公司总部管理部门', '2023-01-15 09:00:00', '2025-10-31 17:05:24', NULL, '1', '0');
-- Table structure for sys_dict
DROP TABLE IF EXISTS sys_dict;
CREATE TABLE sys_dict (
    id SERIAL NOT NULL,
    name VARCHAR(255),
    code VARCHAR(255),
    status SMALLINT,
    description VARCHAR(500),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    created_by INTEGER,
    PRIMARY KEY (id)
);

COMMENT ON COLUMN sys_dict.id IS 'ID';
COMMENT ON COLUMN sys_dict.name IS '字典名称';
COMMENT ON COLUMN sys_dict.code IS '字典编码';
COMMENT ON COLUMN sys_dict.status IS '状态';

-- Records of sys_dict
INSERT INTO sys_dict VALUES ('1', '性别', 'gender', '1', '这是一个性别字典', '2024-07-01 10:00:00', NULL, NULL, '1');
INSERT INTO sys_dict VALUES ('2', '状态', 'status', '1', '状态字段可以用这个', '2024-07-01 10:00:00', NULL, NULL, '1');
INSERT INTO sys_dict VALUES ('3', '岗位', 'post', '1', '岗位字段', '2024-07-01 10:00:00', NULL, NULL, '1');
INSERT INTO sys_dict VALUES ('4', '任务状态', 'taskStatus', '1', '任务状态字段可以用它', '2024-07-01 10:00:00', NULL, NULL, '1');
-- Table structure for sys_dict_item
DROP TABLE IF EXISTS sys_dict_item;
CREATE TABLE sys_dict_item (
    id SERIAL NOT NULL,
    name VARCHAR(255),
    value VARCHAR(255),
    status SMALLINT,
    dict_id INTEGER,
    PRIMARY KEY (id)
);

COMMENT ON COLUMN sys_dict_item.status IS '状态';

-- Records of sys_dict_item
INSERT INTO sys_dict_item VALUES ('11', '男', '1', '1', '1');
INSERT INTO sys_dict_item VALUES ('12', '女', '0', '1', '1');
INSERT INTO sys_dict_item VALUES ('13', '其它', '2', '1', '1');
INSERT INTO sys_dict_item VALUES ('21', '禁用', '0', '1', '2');
INSERT INTO sys_dict_item VALUES ('22', '启用', '1', '1', '2');
INSERT INTO sys_dict_item VALUES ('31', '总经理', '1', '1', '3');
INSERT INTO sys_dict_item VALUES ('32', '总监', '2', '1', '3');
INSERT INTO sys_dict_item VALUES ('33', '人事主管', '3', '1', '3');
INSERT INTO sys_dict_item VALUES ('34', '开发部主管', '4', '1', '3');
INSERT INTO sys_dict_item VALUES ('35', '普通职员', '5', '1', '3');
INSERT INTO sys_dict_item VALUES ('36', '其它', '999', '1', '3');
INSERT INTO sys_dict_item VALUES ('41', '失败', '0', '1', '4');
INSERT INTO sys_dict_item VALUES ('42', '成功', '1', '1', '4');
-- Table structure for sys_gen
DROP TABLE IF EXISTS sys_gen;
CREATE TABLE sys_gen (
    id SERIAL NOT NULL,
    db_type VARCHAR(255),
    database VARCHAR(255),
    name VARCHAR(255),
    module_name VARCHAR(255),
    file_name VARCHAR(255),
    describe VARCHAR(1000),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    created_by INTEGER,
    is_cover SMALLINT DEFAULT '0',
    is_menu SMALLINT DEFAULT '0',
    is_tree SMALLINT DEFAULT '0',
    PRIMARY KEY (id)
);

COMMENT ON COLUMN sys_gen.db_type IS '数据库类型';
COMMENT ON COLUMN sys_gen.module_name IS '模块名称';
COMMENT ON COLUMN sys_gen.created_at IS '创建时间';
COMMENT ON COLUMN sys_gen.updated_at IS '修改时间';
COMMENT ON COLUMN sys_gen.deleted_at IS '删除时间';
COMMENT ON COLUMN sys_gen.is_cover IS '是否覆盖';
COMMENT ON COLUMN sys_gen.is_menu IS '是否生成菜单';
COMMENT ON COLUMN sys_gen.id IS 'ID';
COMMENT ON COLUMN sys_gen.database IS '数据库';
COMMENT ON COLUMN sys_gen.name IS '数据库表名';
COMMENT ON COLUMN sys_gen.file_name IS '文件名称';
COMMENT ON COLUMN sys_gen.describe IS '描述';
COMMENT ON COLUMN sys_gen.created_by IS '创建人';
COMMENT ON COLUMN sys_gen.is_tree IS '是否为树状结构';

-- Records of sys_gen
INSERT INTO sys_gen VALUES ('23', 'mysql', 'gin-fast-tenant', 'demo_students', 'test_school', 'demo_students', '学员管理', '2025-11-13 15:17:27', '2025-11-17 16:31:43', NULL, '1', '1', '1', 0);
INSERT INTO sys_gen VALUES ('24', 'mysql', 'gin-fast-tenant', 'demo_teacher', 'test_school', 'demo_teacher', '教师表', '2025-11-13 15:17:27', '2025-11-17 17:29:28', NULL, '1', '1', '1', 0);
-- Table structure for sys_gen_field
DROP TABLE IF EXISTS sys_gen_field;
CREATE TABLE sys_gen_field (
    id SERIAL NOT NULL,
    gen_id INTEGER,
    data_name VARCHAR(255),
    data_type VARCHAR(255),
    data_comment VARCHAR(255),
    data_extra VARCHAR(255),
    data_column_key VARCHAR(255),
    data_unsigned SMALLINT DEFAULT '0',
    is_primary SMALLINT DEFAULT '0',
    go_type VARCHAR(255),
    front_type VARCHAR(255),
    custom_name VARCHAR(255) DEFAULT '',
    require SMALLINT DEFAULT '0',
    list_show SMALLINT DEFAULT '0',
    form_show SMALLINT DEFAULT '0',
    query_show SMALLINT DEFAULT '0',
    query_type VARCHAR(255),
    form_type VARCHAR(255),
    dict_type VARCHAR(255),
    gorm_tag VARCHAR(255),
    PRIMARY KEY (id)
);

COMMENT ON COLUMN sys_gen_field.list_show IS '列表显示';
COMMENT ON COLUMN sys_gen_field.query_show IS '查询显示';
COMMENT ON COLUMN sys_gen_field.data_type IS '数据类型';
COMMENT ON COLUMN sys_gen_field.data_comment IS '列注释';
COMMENT ON COLUMN sys_gen_field.data_extra IS '额外信息';
COMMENT ON COLUMN sys_gen_field.data_column_key IS '列键信息';
COMMENT ON COLUMN sys_gen_field.data_unsigned IS '是否为无符号类型';
COMMENT ON COLUMN sys_gen_field.query_type IS '查询方式\r\nEQ  等于\r\nNE 不等于\r\nGT 大于\r\nGTE 大于等于\r\nLT 小于\r\nLTE 小于等于\r\nLIKE 包含\r\nBETWEEN 范围';
COMMENT ON COLUMN sys_gen_field.form_type IS '表单类型\r\ninput 文本框\r\ntextarea 文本域\r\nnumber 数字输入框\r\nselect 下拉框\r\nradio 单选框\r\ncheckbox 复选框\r\ndatetime 日期时间';
COMMENT ON COLUMN sys_gen_field.dict_type IS '关联的字典';
COMMENT ON COLUMN sys_gen_field.gorm_tag IS 'gorm标签';
COMMENT ON COLUMN sys_gen_field.form_show IS '表单显示';
COMMENT ON COLUMN sys_gen_field.data_name IS '列名';
COMMENT ON COLUMN sys_gen_field.is_primary IS '是否主键';
COMMENT ON COLUMN sys_gen_field.go_type IS 'go类型';
COMMENT ON COLUMN sys_gen_field.front_type IS '前端类型';
COMMENT ON COLUMN sys_gen_field.custom_name IS '自定义字段名称';
COMMENT ON COLUMN sys_gen_field.require IS '是否必填';

-- Records of sys_gen_field
INSERT INTO sys_gen_field VALUES ('185', '23', 'student_id', 'int', 'ID', 'auto_increment', 'PRI', '1', '1', 'uint', 'number', 'stu_id', '1', '0', '0', '1', 'EQ', '', '', 'column:student_id;primaryKey;not NULL;autoIncrement');
INSERT INTO sys_gen_field VALUES ('186', '23', 'student_name', 'varchar', '姓名', '', '', '0', '0', 'string', 'string', 'stu_name', '1', '1', '1', '1', 'LIKE', 'textarea', '', 'column:student_name;not NULL');
INSERT INTO sys_gen_field VALUES ('187', '23', 'age', 'int', '年龄', '', '', '0', '0', 'int', 'number', 'age', '1', '1', '1', '1', 'LIKE', '', '', 'column:age;not NULL;default:18');
INSERT INTO sys_gen_field VALUES ('188', '23', 'gender', 'varchar', '性别', '', '', '0', '0', 'string', 'string', 'gender', '1', '1', '1', '1', 'BETWEEN', 'radio', 'gender', 'column:gender;not NULL;default:''''');
INSERT INTO sys_gen_field VALUES ('189', '23', 'class_name', 'varchar', '班级名称', '', '', '0', '0', 'string', 'string', 'class_name', '0', '1', '1', '0', '', 'checkbox', 'class', 'column:class_name;not NULL');
INSERT INTO sys_gen_field VALUES ('190', '23', 'admission_date', 'datetime', '入学日期', '', '', '0', '0', 'time.Time', 'string', 'admission_date', '0', '0', '1', '0', '', '', '', 'column:admission_date;not NULL');
INSERT INTO sys_gen_field VALUES ('191', '23', 'email', 'varchar', ' 邮箱', '', 'UNI', '0', '0', 'string', 'string', 'email', '0', '0', '1', '1', '', 'checkbox', 'status', 'column:email;uniqueIndex');
INSERT INTO sys_gen_field VALUES ('192', '23', 'phone', 'varchar', '电话号码', '', '', '0', '0', 'string', 'string', 'phone', '0', '0', '0', '0', '', '', '', 'column:phone');
INSERT INTO sys_gen_field VALUES ('193', '23', 'address', 'text', '地址', '', '', '0', '0', 'string', 'string', 'address', '0', '0', '1', '1', '', 'select', 'status', 'column:address');
INSERT INTO sys_gen_field VALUES ('194', '23', 'created_at', 'datetime', '创建时间', '', '', '0', '0', 'time.Time', 'string', 'created_at', NULL, NULL, '1', '1', 'BETWEEN', '', '', 'column:created_at');
INSERT INTO sys_gen_field VALUES ('195', '23', 'updated_at', 'datetime', '更新时间', '', '', '0', '0', 'time.Time', 'string', 'updated_at', NULL, NULL, '1', NULL, '', '', '', 'column:updated_at');
INSERT INTO sys_gen_field VALUES ('196', '23', 'deleted_at', 'datetime', '删除时间', '', '', '0', '0', 'time.Time', 'string', 'deleted_at', NULL, NULL, '1', NULL, '', '', '', 'column:deleted_at');
INSERT INTO sys_gen_field VALUES ('197', '23', 'created_by', 'int', '创建人', '', '', '1', '0', 'uint', 'number', 'created_by', NULL, NULL, '1', NULL, '', '', '', 'column:created_by');
INSERT INTO sys_gen_field VALUES ('198', '23', 'tenant_id', 'int', '租户ID字段', '', '', '1', '0', 'uint', 'number', 'tenant_id', NULL, NULL, '1', '1', '', '', '', 'column:tenant_id');
INSERT INTO sys_gen_field VALUES ('199', '24', 'id', 'int', '主键ID', 'auto_increment', 'PRI', '1', '1', 'uint', 'number', 'tc_id', '1', '1', '1', '1', '', '', '', 'column:id;primaryKey;not NULL;autoIncrement');
INSERT INTO sys_gen_field VALUES ('200', '24', 'name', 'varchar', '教师姓名', '', '', '0', '0', 'string', 'string', 'tc_name', '1', '1', '1', '1', 'LIKE', 'input', '', 'column:name;not NULL');
INSERT INTO sys_gen_field VALUES ('201', '24', 'employee_id', 'varchar', '工号', '', '', '0', '0', 'string', 'string', 'employee_id', '1', '1', '1', '1', 'BETWEEN', '', '', 'column:employee_id');
INSERT INTO sys_gen_field VALUES ('202', '24', 'gender', 'tinyint', '性别', '', '', '0', '0', 'int', 'number', 'gender', '1', '1', '1', '1', 'EQ', 'select', 'gender', 'column:gender;default:0');
INSERT INTO sys_gen_field VALUES ('203', '24', 'phone', 'varchar', '手机号', '', '', '0', '0', 'string', 'string', 'phone', '1', '1', '1', '1', 'GT', '', '', 'column:phone');
INSERT INTO sys_gen_field VALUES ('204', '24', 'email', 'varchar', '邮箱', '', '', '0', '0', 'string', 'string', 'email', '1', '1', '1', '1', 'NE', '', '', 'column:email');
INSERT INTO sys_gen_field VALUES ('205', '24', 'subject', 'varchar', '所教学科', '', '', '0', '0', 'string', 'string', 'subject', '1', '1', '1', '1', '', '', '', 'column:subject');
INSERT INTO sys_gen_field VALUES ('206', '24', 'title', 'varchar', '职称', '', '', '0', '0', 'string', 'string', 'title', '1', '1', '1', '1', '', '', '', 'column:title');
INSERT INTO sys_gen_field VALUES ('207', '24', 'status', 'tinyint', '状态', '', '', '0', '0', 'int', 'number', 'status', '1', '1', '1', '1', '', 'select', 'status', 'column:status;default:1');
INSERT INTO sys_gen_field VALUES ('208', '24', 'hire_date', 'date', '入职日期', '', '', '0', '0', 'time.Time', 'string', 'hire_date', '1', '1', '1', '1', 'BETWEEN', '', '', 'column:hire_date');
INSERT INTO sys_gen_field VALUES ('209', '24', 'birth_date', 'date', '出生日期', '', '', '0', '0', 'time.Time', 'string', 'birth_date', '1', '1', '1', '1', '', 'select', 'test_date', 'column:birth_date');
INSERT INTO sys_gen_field VALUES ('210', '24', 'created_at', 'datetime', '创建时间', '', '', '0', '0', 'time.Time', 'string', 'created_at', NULL, NULL, NULL, NULL, '', '', '', 'column:created_at');
INSERT INTO sys_gen_field VALUES ('211', '24', 'updated_at', 'datetime', '更新时间', '', '', '0', '0', 'time.Time', 'string', 'updated_at', NULL, NULL, NULL, NULL, '', '', '', 'column:updated_at');
INSERT INTO sys_gen_field VALUES ('212', '24', 'deleted_at', 'datetime', '删除时间', '', '', '0', '0', 'time.Time', 'string', 'deleted_at', NULL, NULL, NULL, NULL, '', '', '', 'column:deleted_at');
INSERT INTO sys_gen_field VALUES ('213', '24', 'created_by', 'int', '创建人', '', '', '1', '0', 'uint', 'number', 'created_by', NULL, NULL, NULL, NULL, '', '', '', 'column:created_by');
-- Table structure for sys_menu
DROP TABLE IF EXISTS sys_menu;
CREATE TABLE sys_menu (
    id SERIAL NOT NULL,
    parent_id INTEGER NOT NULL DEFAULT '0',
    path VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    redirect VARCHAR(255),
    component VARCHAR(255),
    title VARCHAR(100),
    is_full SMALLINT DEFAULT '0',
    hide SMALLINT DEFAULT '0',
    disable SMALLINT DEFAULT '0',
    keep_alive SMALLINT DEFAULT '0',
    affix SMALLINT DEFAULT '0',
    link VARCHAR(500) DEFAULT '',
    iframe SMALLINT DEFAULT '0',
    svg_icon VARCHAR(100) DEFAULT '',
    icon VARCHAR(100) DEFAULT '',
    sort INTEGER DEFAULT '0',
    type SMALLINT DEFAULT '2',
    is_link SMALLINT DEFAULT '0',
    permission VARCHAR(255) DEFAULT '',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    created_by INTEGER,
    PRIMARY KEY (id)
);

COMMENT ON COLUMN sys_menu.keep_alive IS '是否缓存：0-否，1-是';
COMMENT ON COLUMN sys_menu.link IS '外链地址';
COMMENT ON COLUMN sys_menu.icon IS '普通图标名称';
COMMENT ON COLUMN sys_menu.permission IS '权限标识';
COMMENT ON COLUMN sys_menu.created_at IS '创建时间';
COMMENT ON COLUMN sys_menu.updated_at IS '更新时间';
COMMENT ON COLUMN sys_menu.id IS '路由ID';
COMMENT ON COLUMN sys_menu.name IS '路由名称';
COMMENT ON COLUMN sys_menu.title IS '菜单标题，国际化key';
COMMENT ON COLUMN sys_menu.affix IS '是否固定：0-否，1-是';
COMMENT ON COLUMN sys_menu.svg_icon IS 'svg图标名称';
COMMENT ON COLUMN sys_menu.type IS '类型：1-目录，2-菜单，3-按钮';
COMMENT ON COLUMN sys_menu.parent_id IS '父级路由ID，顶层为0';
COMMENT ON COLUMN sys_menu.redirect IS '重定向';
COMMENT ON COLUMN sys_menu.component IS '组件文件路径';
COMMENT ON COLUMN sys_menu.is_full IS '是否全屏显示：0-否，1-是';
COMMENT ON COLUMN sys_menu.sort IS '排序字段';
COMMENT ON COLUMN sys_menu.path IS '路由路径';
COMMENT ON COLUMN sys_menu.iframe IS '是否内嵌：0-否，1-是';
COMMENT ON COLUMN sys_menu.is_link IS '是否外链';
COMMENT ON COLUMN sys_menu.hide IS '是否隐藏：0-否，1-是';
COMMENT ON COLUMN sys_menu.disable IS '是否停用：0-否，1-是';

-- Records of sys_menu
INSERT INTO sys_menu VALUES ('1', '0', '/home', 'home', NULL, 'home/home', 'home', '0', '0', '0', '0', '1', '', '0', 'home', '', '0', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', NULL, '1');
INSERT INTO sys_menu VALUES ('10', '0', '/system', 'system', NULL, NULL, 'system', '0', '0', '0', '1', '0', '', '0', 'set', '', '0', '1', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', NULL, '1');
INSERT INTO sys_menu VALUES ('1001', '10', '/system/account', 'account', '', 'system/account/account', 'account', '0', '0', '0', '1', '0', '', '0', '', 'IconUser', '0', '2', '0', '', '2025-08-27 09:09:44', '2025-10-11 15:37:41', NULL, '1');
INSERT INTO sys_menu VALUES ('1002', '10', '/system/role', 'role', '', 'system/role/role', 'role', '0', '0', '0', '1', '0', '', '0', '', 'IconUserGroup', '0', '2', '0', '', '2025-08-27 09:09:44', '2025-10-11 16:16:08', NULL, '1');
INSERT INTO sys_menu VALUES ('1003', '10', '/system/menu', 'menu', NULL, 'system/menu/menu', 'menu', '0', '0', '0', '1', '0', '', '0', '', 'icon-menu', '0', '2', '0', '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', NULL, '1');
INSERT INTO sys_menu VALUES ('1004', '10', '/system/division', 'division', '', 'system/division/division', 'division', '0', '0', '0', '1', '0', '', '0', '', 'IconMindMapping', '0', '2', '0', '', '2025-08-27 09:09:44', '2025-10-11 16:23:14', NULL, '1');
INSERT INTO sys_menu VALUES ('1005', '10', '/system/dictionary', 'dictionary', '', 'system/dictionary/dictionary', 'dictionary', '0', '0', '0', '1', '0', '', '0', '', 'IconBook', '0', '2', '0', '', '2025-08-27 09:09:44', '2025-10-11 16:23:47', NULL, '1');
INSERT INTO sys_menu VALUES ('1006', '10', '/system/log', 'log', '', 'system/log/log', 'log', '0', '0', '0', '1', '0', '', '0', '', 'IconCommon', '0', '2', '0', '', '2025-08-27 09:09:44', '2025-10-20 17:14:19', NULL, '1');
INSERT INTO sys_menu VALUES ('1007', '10', '/system/userinfo', 'userinfo', '', 'system/userinfo/userinfo', 'userinfo', '0', '1', '0', '1', '0', '', '0', '', 'icon-menu', '0', '2', '0', '', '2025-08-27 09:09:44', '2025-09-17 11:19:11', NULL, '1');
INSERT INTO sys_menu VALUES ('140213', '10', '/system/api', 'SystemApi', '', 'system/sysapi/sysapi', 'api-management', '0', '0', '0', '1', '0', '', '0', '', 'IconFile', '0', '2', '0', '', '2025-09-03 10:53:57', '2025-10-16 08:53:42', NULL, '1');
INSERT INTO sys_menu VALUES ('140214', '1001', '', '', '', '', '新增', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:account:add', '2025-09-03 16:11:58', '2025-09-03 16:11:58', NULL, '1');
INSERT INTO sys_menu VALUES ('140215', '1001', '', '', '', '', '编辑', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:account:edit', '2025-09-03 17:11:24', '2025-09-03 17:11:24', NULL, '1');
INSERT INTO sys_menu VALUES ('140216', '1001', '', '', '', '', '删除', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:account:delete', '2025-09-03 17:12:22', '2025-09-03 17:12:22', NULL, '1');
INSERT INTO sys_menu VALUES ('140218', '1002', '', '', '', '', '新增', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:role:add', '2025-09-04 16:43:54', '2025-09-04 16:43:54', NULL, '1');
INSERT INTO sys_menu VALUES ('140219', '1002', '', '', '', '', '编辑', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:role:edit', '2025-09-04 16:47:15', '2025-09-04 16:47:15', NULL, '1');
INSERT INTO sys_menu VALUES ('140220', '1002', '', '', '', '', '删除', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:role:delete', '2025-09-04 16:50:19', '2025-09-04 16:50:19', NULL, '1');
INSERT INTO sys_menu VALUES ('140221', '1002', '', '', '', '', '分配权限', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:role:addRoleMenu', '2025-09-04 16:53:09', '2025-09-04 16:53:09', NULL, '1');
INSERT INTO sys_menu VALUES ('140222', '1003', '', '', '', '', '新增', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:menu:add', '2025-09-04 17:07:16', '2025-09-04 17:07:16', NULL, '1');
INSERT INTO sys_menu VALUES ('140223', '1003', '', '', '', '', '编辑', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:menu:edit', '2025-09-04 17:11:51', '2025-09-04 17:11:51', NULL, '1');
INSERT INTO sys_menu VALUES ('140224', '1003', '', '', '', '', '删除', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:menu:delete', '2025-09-04 17:12:24', '2025-09-04 17:12:24', NULL, '1');
INSERT INTO sys_menu VALUES ('140225', '1003', '', '', '', '', '分配权限', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:menu:setMenuApis', '2025-09-04 17:20:09', '2025-09-04 17:20:09', NULL, '1');
INSERT INTO sys_menu VALUES ('140226', '140213', '', '', '', '', '新增', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:api:add', '2025-09-04 17:30:56', '2025-09-04 17:30:56', NULL, '1');
INSERT INTO sys_menu VALUES ('140227', '140213', '', '', '', '', '编辑', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:api:edit', '2025-09-04 17:31:20', '2025-09-04 17:31:20', NULL, '1');
INSERT INTO sys_menu VALUES ('140228', '140213', '', '', '', '', '删除', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:api:delete', '2025-09-04 17:31:38', '2025-09-04 17:31:38', NULL, '1');
INSERT INTO sys_menu VALUES ('140229', '1004', '', '', '', '', '新增部门', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:division:add', '2025-09-12 14:50:55', '2025-09-12 14:50:55', NULL, '1');
INSERT INTO sys_menu VALUES ('140230', '1004', '', '', '', '', '编辑部门', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:division:edit', '2025-09-12 14:51:17', '2025-09-12 14:51:17', NULL, '1');
INSERT INTO sys_menu VALUES ('140231', '1004', '', '', '', '', '删除部门', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:division:delete', '2025-09-12 14:51:51', '2025-09-12 14:51:51', NULL, '1');
INSERT INTO sys_menu VALUES ('140232', '1005', '', '', '', '', '新增', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:dict:add', '2025-09-16 16:38:06', '2025-09-16 16:38:06', NULL, '1');
INSERT INTO sys_menu VALUES ('140233', '1005', '', '', '', '', '编辑', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:dict:edit', '2025-09-16 16:39:58', '2025-09-16 16:39:58', NULL, '1');
INSERT INTO sys_menu VALUES ('140234', '1005', '', '', '', '', '删除', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:dict:delete', '2025-09-16 16:40:19', '2025-09-16 16:40:19', NULL, '1');
INSERT INTO sys_menu VALUES ('140235', '1005', '', '', '', '', '字典项管理', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:dictitem:list', '2025-09-16 17:09:58', '2025-09-16 17:31:35', NULL, '1');
INSERT INTO sys_menu VALUES ('140236', '1005', '', '', '', '', '新增字典项', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:dictitem:add', '2025-09-16 17:32:06', '2025-09-16 17:32:06', NULL, '1');
INSERT INTO sys_menu VALUES ('140237', '1005', '', '', '', '', '编辑字典项', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:dictitem:edit', '2025-09-16 17:33:16', '2025-09-16 17:33:16', NULL, '1');
INSERT INTO sys_menu VALUES ('140238', '1005', '', '', '', '', '删除字典项', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:dictitem:delete', '2025-09-16 17:33:41', '2025-09-16 17:33:41', NULL, '1');
INSERT INTO sys_menu VALUES ('140239', '10', '/system/affix', 'SystemAffix', '', 'system/affix/affix', 'file-manager', '0', '0', '0', '1', '0', '', '0', '', 'IconFolder', '0', '2', '0', '', '2025-09-25 15:17:00', '2025-10-15 18:14:16', NULL, '1');
INSERT INTO sys_menu VALUES ('140240', '140239', '', '', '', '', '文件上传', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:affix:upload', '2025-09-25 15:45:29', '2025-09-25 15:46:29', NULL, '1');
INSERT INTO sys_menu VALUES ('140241', '140239', '', '', '', '', '删除文件', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:affix:delete', '2025-09-25 15:46:52', '2025-09-25 15:46:52', NULL, '1');
INSERT INTO sys_menu VALUES ('140242', '140239', '', '', '', '', '修改文件名', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:affix:updateName', '2025-09-25 15:47:41', '2025-09-25 15:47:41', NULL, '1');
INSERT INTO sys_menu VALUES ('140243', '140239', '', '', '', '', '下载文件', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:affix:download', '2025-09-25 15:48:56', '2025-09-25 15:48:56', NULL, '1');
INSERT INTO sys_menu VALUES ('140244', '1002', '', '', '', '', '数据权限', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:role:dataScope', '2025-09-26 17:07:16', '2025-09-26 17:07:16', NULL, '1');
INSERT INTO sys_menu VALUES ('140245', '10', '/system/sysconfig', 'SystemSysconfig', '', 'system/sysconfig/sysconfig', 'system-config', '0', '0', '0', '1', '0', '', '0', '', 'IconSettings', '0', '2', '0', '', '2025-10-09 16:15:21', '2025-10-15 18:10:54', NULL, '1');
INSERT INTO sys_menu VALUES ('140246', '140245', '', '', '', '', '修改系统配置', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:config:update', '2025-10-09 16:24:33', '2025-10-09 16:24:33', NULL, '1');
INSERT INTO sys_menu VALUES ('140247', '0', '/demo', 'Demo', '', '', 'plugin-example', '0', '0', '0', '1', '0', '', '0', 'more', '', '0', '1', '0', '', '2025-10-13 14:38:38', '2025-10-16 08:55:06', NULL, '1');
INSERT INTO sys_menu VALUES ('140248', '140247', '/plugins/example', 'PluginsExample', '', 'plugins/example/views/examplelist', 'plugin-example', '0', '0', '0', '1', '0', '', '0', '', 'IconMenu', '0', '2', '0', '', '2025-10-13 15:19:20', '2025-10-16 08:55:19', NULL, '1');
INSERT INTO sys_menu VALUES ('140249', '140248', '', '', '', '', '新增', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'plugins:example:add', '2025-10-14 11:02:42', '2025-10-14 11:02:42', NULL, '1');
INSERT INTO sys_menu VALUES ('140250', '140248', '', '', '', '', '编辑', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'plugins:example:edit', '2025-10-14 11:03:08', '2025-10-14 11:03:08', NULL, '1');
INSERT INTO sys_menu VALUES ('140251', '140248', '', '', '', '', '删除', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'plugins:example:delete', '2025-10-14 11:03:25', '2025-10-14 11:03:25', NULL, '1');
INSERT INTO sys_menu VALUES ('140252', '1007', '', '', '', '', '修改密码、手机号等', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:userinfo:updateAccount', '2025-10-17 11:12:56', '2025-10-17 11:12:56', NULL, '1');
INSERT INTO sys_menu VALUES ('140254', '140239', '', '', '', '', '复制链接', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:affix:copy', '2025-10-17 11:38:09', '2025-10-17 11:38:09', NULL, '1');
INSERT INTO sys_menu VALUES ('140255', '1006', '', '', '', '', '导出', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:log:export', '2025-10-20 10:16:51', '2025-10-20 10:16:51', NULL, '1');
INSERT INTO sys_menu VALUES ('140256', '1006', '', '', '', '', '删除', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:log:delete', '2025-10-20 10:17:19', '2025-10-20 10:17:19', NULL, '1');
INSERT INTO sys_menu VALUES ('140257', '1003', '', '', '', '', '导出', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:menu:export', '2025-10-20 17:18:01', '2025-10-20 17:18:13', NULL, '1');
INSERT INTO sys_menu VALUES ('140258', '1003', '', '', '', '', '导入', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:menu:import', '2025-10-21 11:29:45', '2025-10-21 11:29:45', NULL, '1');
INSERT INTO sys_menu VALUES ('140259', '10', '/system/systenant', 'SystemSystenant', '', 'system/tenant/tenant', 'tenant', '0', '0', '0', '1', '0', '', '0', '', 'IconTags', '0', '2', '0', '', '2025-10-24 09:11:32', '2025-10-24 09:20:59', NULL, '1');
INSERT INTO sys_menu VALUES ('140260', '140259', '', '', '', '', '新增租户', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:tenant:add', '2025-10-24 09:14:25', '2025-10-24 09:14:25', NULL, '1');
INSERT INTO sys_menu VALUES ('140261', '140259', '', '', '', '', '修改租户', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:tenant:edit', '2025-10-24 09:14:50', '2025-10-24 09:14:50', NULL, '1');
INSERT INTO sys_menu VALUES ('140262', '140259', '', '', '', '', '删除租户', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:tenant:delete', '2025-10-24 09:15:07', '2025-10-24 09:15:07', NULL, '1');
INSERT INTO sys_menu VALUES ('140263', '140259', '', '', '', '', '分配用户', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:tenant:assignUser', '2025-10-27 18:03:07', '2025-10-27 18:03:07', NULL, '1');
INSERT INTO sys_menu VALUES ('140264', '1007', '', '', '', '', '修改用户基本信息', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:userinfo:updateBasicInfo', '2025-10-31 09:26:42', '2025-10-31 09:26:42', NULL, '1');
INSERT INTO sys_menu VALUES ('140265', '10', '/system/codegen', 'SystemCodegen', '', 'system/codegen/codegen', 'codegen', '0', '0', '0', '1', '0', '', '0', '', 'IconCode', '0', '2', '0', '', '2025-11-04 11:45:49', '2025-11-04 11:45:49', NULL, '1');
INSERT INTO sys_menu VALUES ('140329', '140265', '', '', '', '', '导入表', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:codegen:batchInsert', '2025-11-17 15:32:25', '2025-11-17 15:32:25', NULL, '1');
INSERT INTO sys_menu VALUES ('140330', '140265', '', '', '', '', '配置', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:codegen:update', '2025-11-17 15:33:57', '2025-11-17 15:33:57', NULL, '1');
INSERT INTO sys_menu VALUES ('140331', '140265', '', '', '', '', '预览', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:codegen:preview', '2025-11-17 15:34:24', '2025-11-17 15:34:24', NULL, '1');
INSERT INTO sys_menu VALUES ('140332', '140265', '', '', '', '', '生成代码文件', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:codegen:generate', '2025-11-17 15:35:00', '2025-11-17 15:35:00', NULL, '1');
INSERT INTO sys_menu VALUES ('140333', '140265', '', '', '', '', '同步数据库', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:codegen:refreshFields', '2025-11-17 15:35:51', '2025-11-17 15:35:51', NULL, '1');
INSERT INTO sys_menu VALUES ('140334', '140265', '', '', '', '', '删除', '0', '0', '0', '1', '0', '', '0', '', '', '1', '3', '0', 'system:codegen:delete', '2025-11-17 15:36:50', '2025-11-17 15:36:50', NULL, '1');
INSERT INTO sys_menu VALUES ('140335', '140265', '', '', '', '', '生成菜单', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:codegen:insertmenuandapi', '2025-11-26 15:16:32', '2025-11-26 15:16:32', NULL, '1');
INSERT INTO sys_menu VALUES ('140336', '10', '/system/pluginsmanager', 'SystemPluginsmanager', '', 'system/pluginsmanager/pluginsmanager', 'plugins-manager', '0', '0', '0', '1', '0', '', '0', '', 'IconApps', '0', '2', '0', '', '2025-12-05 17:59:34', '2025-12-05 17:59:34', NULL, '1');
INSERT INTO sys_menu VALUES ('140338', '140336', '', '', '', '', '导出插件', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:pluginsmanager:export', '2025-12-08 16:33:32', '2025-12-08 16:33:32', NULL, '1');
INSERT INTO sys_menu VALUES ('140339', '140336', '', '', '', '', '导入插件', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:pluginsmanager:import', '2025-12-08 16:33:51', '2025-12-08 16:33:51', NULL, '1');
INSERT INTO sys_menu VALUES ('140340', '140336', '', '', '', '', '插件卸载', '0', '0', '0', '1', '0', '', '0', '', '', '0', '3', '0', 'system:pluginsmanager:uninstall', '2025-12-08 16:34:53', '2025-12-08 16:34:53', NULL, '1');
-- Table structure for sys_menu_api
DROP TABLE IF EXISTS sys_menu_api;
CREATE TABLE sys_menu_api (
    menu_id INTEGER NOT NULL,
    api_id INTEGER NOT NULL,
    PRIMARY KEY (menu_id,api_id)
);


-- Records of sys_menu_api
INSERT INTO sys_menu_api VALUES ('10', '5');
INSERT INTO sys_menu_api VALUES ('10', '6');
INSERT INTO sys_menu_api VALUES ('10', '7');
INSERT INTO sys_menu_api VALUES ('10', '12');
INSERT INTO sys_menu_api VALUES ('10', '27');
INSERT INTO sys_menu_api VALUES ('10', '54');
INSERT INTO sys_menu_api VALUES ('10', '202');
INSERT INTO sys_menu_api VALUES ('1001', '8');
INSERT INTO sys_menu_api VALUES ('1001', '18');
INSERT INTO sys_menu_api VALUES ('1001', '19');
INSERT INTO sys_menu_api VALUES ('1002', '19');
INSERT INTO sys_menu_api VALUES ('1003', '13');
INSERT INTO sys_menu_api VALUES ('1004', '18');
INSERT INTO sys_menu_api VALUES ('1005', '41');
INSERT INTO sys_menu_api VALUES ('1006', '70');
INSERT INTO sys_menu_api VALUES ('1007', '6');
INSERT INTO sys_menu_api VALUES ('140213', '29');
INSERT INTO sys_menu_api VALUES ('140214', '9');
INSERT INTO sys_menu_api VALUES ('140215', '10');
INSERT INTO sys_menu_api VALUES ('140216', '11');
INSERT INTO sys_menu_api VALUES ('140218', '24');
INSERT INTO sys_menu_api VALUES ('140219', '25');
INSERT INTO sys_menu_api VALUES ('140220', '26');
INSERT INTO sys_menu_api VALUES ('140221', '13');
INSERT INTO sys_menu_api VALUES ('140221', '20');
INSERT INTO sys_menu_api VALUES ('140221', '21');
INSERT INTO sys_menu_api VALUES ('140222', '15');
INSERT INTO sys_menu_api VALUES ('140223', '16');
INSERT INTO sys_menu_api VALUES ('140224', '17');
INSERT INTO sys_menu_api VALUES ('140224', '197');
INSERT INTO sys_menu_api VALUES ('140225', '29');
INSERT INTO sys_menu_api VALUES ('140225', '35');
INSERT INTO sys_menu_api VALUES ('140225', '36');
INSERT INTO sys_menu_api VALUES ('140226', '31');
INSERT INTO sys_menu_api VALUES ('140227', '30');
INSERT INTO sys_menu_api VALUES ('140227', '32');
INSERT INTO sys_menu_api VALUES ('140228', '33');
INSERT INTO sys_menu_api VALUES ('140229', '38');
INSERT INTO sys_menu_api VALUES ('140230', '39');
INSERT INTO sys_menu_api VALUES ('140231', '40');
INSERT INTO sys_menu_api VALUES ('140232', '43');
INSERT INTO sys_menu_api VALUES ('140233', '44');
INSERT INTO sys_menu_api VALUES ('140234', '45');
INSERT INTO sys_menu_api VALUES ('140235', '48');
INSERT INTO sys_menu_api VALUES ('140236', '50');
INSERT INTO sys_menu_api VALUES ('140237', '51');
INSERT INTO sys_menu_api VALUES ('140238', '52');
INSERT INTO sys_menu_api VALUES ('140239', '58');
INSERT INTO sys_menu_api VALUES ('140240', '55');
INSERT INTO sys_menu_api VALUES ('140241', '56');
INSERT INTO sys_menu_api VALUES ('140242', '57');
INSERT INTO sys_menu_api VALUES ('140243', '60');
INSERT INTO sys_menu_api VALUES ('140244', '61');
INSERT INTO sys_menu_api VALUES ('140245', '62');
INSERT INTO sys_menu_api VALUES ('140245', '64');
INSERT INTO sys_menu_api VALUES ('140246', '63');
INSERT INTO sys_menu_api VALUES ('140248', '65');
INSERT INTO sys_menu_api VALUES ('140248', '69');
INSERT INTO sys_menu_api VALUES ('140249', '66');
INSERT INTO sys_menu_api VALUES ('140250', '67');
INSERT INTO sys_menu_api VALUES ('140251', '68');
INSERT INTO sys_menu_api VALUES ('140252', '53');
INSERT INTO sys_menu_api VALUES ('140254', '60');
INSERT INTO sys_menu_api VALUES ('140255', '73');
INSERT INTO sys_menu_api VALUES ('140256', '72');
INSERT INTO sys_menu_api VALUES ('140257', '74');
INSERT INTO sys_menu_api VALUES ('140258', '75');
INSERT INTO sys_menu_api VALUES ('140259', '76');
INSERT INTO sys_menu_api VALUES ('140260', '78');
INSERT INTO sys_menu_api VALUES ('140261', '77');
INSERT INTO sys_menu_api VALUES ('140261', '79');
INSERT INTO sys_menu_api VALUES ('140262', '80');
INSERT INTO sys_menu_api VALUES ('140263', '81');
INSERT INTO sys_menu_api VALUES ('140263', '82');
INSERT INTO sys_menu_api VALUES ('140263', '83');
INSERT INTO sys_menu_api VALUES ('140263', '84');
INSERT INTO sys_menu_api VALUES ('140263', '85');
INSERT INTO sys_menu_api VALUES ('140263', '86');
INSERT INTO sys_menu_api VALUES ('140263', '87');
INSERT INTO sys_menu_api VALUES ('140263', '88');
INSERT INTO sys_menu_api VALUES ('140264', '89');
INSERT INTO sys_menu_api VALUES ('140265', '190');
INSERT INTO sys_menu_api VALUES ('140329', '188');
INSERT INTO sys_menu_api VALUES ('140329', '191');
INSERT INTO sys_menu_api VALUES ('140330', '192');
INSERT INTO sys_menu_api VALUES ('140330', '193');
INSERT INTO sys_menu_api VALUES ('140331', '189');
INSERT INTO sys_menu_api VALUES ('140332', '105');
INSERT INTO sys_menu_api VALUES ('140333', '195');
INSERT INTO sys_menu_api VALUES ('140334', '194');
INSERT INTO sys_menu_api VALUES ('140335', '196');
INSERT INTO sys_menu_api VALUES ('140336', '198');
INSERT INTO sys_menu_api VALUES ('140338', '199');
INSERT INTO sys_menu_api VALUES ('140339', '200');
INSERT INTO sys_menu_api VALUES ('140340', '201');
-- Table structure for sys_operation_logs
DROP TABLE IF EXISTS sys_operation_logs;
CREATE TABLE sys_operation_logs (
    id BIGSERIAL NOT NULL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    user_id BIGINT,
    username VARCHAR(50),
    module VARCHAR(100),
    operation VARCHAR(100),
    method VARCHAR(10),
    path VARCHAR(500),
    ip VARCHAR(50),
    user_agent VARCHAR(500),
    request_data TEXT,
    response_data TEXT,
    status_code INTEGER,
    duration BIGINT,
    error_msg TEXT,
    location VARCHAR(100),
    tenant_id INTEGER DEFAULT '0',
    PRIMARY KEY (id)
);

COMMENT ON COLUMN sys_operation_logs.username IS '操作用户名';
COMMENT ON COLUMN sys_operation_logs.operation IS '操作类型';
COMMENT ON COLUMN sys_operation_logs.method IS '请求方法';
COMMENT ON COLUMN sys_operation_logs.request_data IS '请求参数';
COMMENT ON COLUMN sys_operation_logs.duration IS '操作耗时(毫秒)';
COMMENT ON COLUMN sys_operation_logs.tenant_id IS '租户ID字段';
COMMENT ON COLUMN sys_operation_logs.user_id IS '操作用户ID';
COMMENT ON COLUMN sys_operation_logs.error_msg IS '错误信息';
COMMENT ON COLUMN sys_operation_logs.location IS '操作地点';
COMMENT ON COLUMN sys_operation_logs.ip IS '客户端IP';
COMMENT ON COLUMN sys_operation_logs.user_agent IS '用户代理';
COMMENT ON COLUMN sys_operation_logs.response_data IS '响应数据';
COMMENT ON COLUMN sys_operation_logs.module IS '操作模块';
COMMENT ON COLUMN sys_operation_logs.path IS '请求路径';
COMMENT ON COLUMN sys_operation_logs.status_code IS '响应状态码';

-- Records of sys_operation_logs
-- Table structure for sys_role
DROP TABLE IF EXISTS sys_role;
CREATE TABLE sys_role (
    id SERIAL NOT NULL,
    name VARCHAR(255) DEFAULT '',
    sort INTEGER DEFAULT '0',
    status SMALLINT DEFAULT '0',
    description VARCHAR(255),
    parent_id INTEGER DEFAULT '0',
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    created_by INTEGER,
    data_scope INTEGER DEFAULT '0',
    checked_depts VARCHAR(1000),
    tenant_id INTEGER DEFAULT '0',
    PRIMARY KEY (id)
);

COMMENT ON COLUMN sys_role.checked_depts IS '数据权限关联的部门';
COMMENT ON COLUMN sys_role.tenant_id IS '租户ID字段';
COMMENT ON COLUMN sys_role.name IS '角色名称';
COMMENT ON COLUMN sys_role.sort IS '排序';
COMMENT ON COLUMN sys_role.status IS '状态';
COMMENT ON COLUMN sys_role.description IS '描述';
COMMENT ON COLUMN sys_role.data_scope IS '数据权限';

-- Records of sys_role
INSERT INTO sys_role VALUES ('1', '系统管理员', '0', '1', '最高权限管理员角色', '0', '2025-09-01 17:32:12', '2025-09-30 15:53:24', NULL, '1', '1', '', '0');
INSERT INTO sys_role VALUES ('2', '演示', '0', '1', '', '0', '2025-10-14 15:12:09', '2025-10-17 15:34:47', NULL, '1', '0', '', '0');
-- Table structure for sys_role_menu
DROP TABLE IF EXISTS sys_role_menu;
CREATE TABLE sys_role_menu (
    role_id INTEGER NOT NULL,
    menu_id INTEGER NOT NULL,
    PRIMARY KEY (role_id,menu_id)
);


-- Records of sys_role_menu
INSERT INTO sys_role_menu VALUES ('1', '1');
INSERT INTO sys_role_menu VALUES ('1', '10');
INSERT INTO sys_role_menu VALUES ('1', '1001');
INSERT INTO sys_role_menu VALUES ('1', '1002');
INSERT INTO sys_role_menu VALUES ('1', '1003');
INSERT INTO sys_role_menu VALUES ('1', '1004');
INSERT INTO sys_role_menu VALUES ('1', '1005');
INSERT INTO sys_role_menu VALUES ('1', '1006');
INSERT INTO sys_role_menu VALUES ('1', '1007');
INSERT INTO sys_role_menu VALUES ('1', '140213');
INSERT INTO sys_role_menu VALUES ('1', '140214');
INSERT INTO sys_role_menu VALUES ('1', '140215');
INSERT INTO sys_role_menu VALUES ('1', '140216');
INSERT INTO sys_role_menu VALUES ('1', '140218');
INSERT INTO sys_role_menu VALUES ('1', '140219');
INSERT INTO sys_role_menu VALUES ('1', '140220');
INSERT INTO sys_role_menu VALUES ('1', '140221');
INSERT INTO sys_role_menu VALUES ('1', '140222');
INSERT INTO sys_role_menu VALUES ('1', '140223');
INSERT INTO sys_role_menu VALUES ('1', '140224');
INSERT INTO sys_role_menu VALUES ('1', '140225');
INSERT INTO sys_role_menu VALUES ('1', '140226');
INSERT INTO sys_role_menu VALUES ('1', '140227');
INSERT INTO sys_role_menu VALUES ('1', '140228');
INSERT INTO sys_role_menu VALUES ('1', '140229');
INSERT INTO sys_role_menu VALUES ('1', '140230');
INSERT INTO sys_role_menu VALUES ('1', '140231');
INSERT INTO sys_role_menu VALUES ('1', '140232');
INSERT INTO sys_role_menu VALUES ('1', '140233');
INSERT INTO sys_role_menu VALUES ('1', '140234');
INSERT INTO sys_role_menu VALUES ('1', '140235');
INSERT INTO sys_role_menu VALUES ('1', '140236');
INSERT INTO sys_role_menu VALUES ('1', '140237');
INSERT INTO sys_role_menu VALUES ('1', '140238');
INSERT INTO sys_role_menu VALUES ('1', '140239');
INSERT INTO sys_role_menu VALUES ('1', '140240');
INSERT INTO sys_role_menu VALUES ('1', '140241');
INSERT INTO sys_role_menu VALUES ('1', '140242');
INSERT INTO sys_role_menu VALUES ('1', '140243');
INSERT INTO sys_role_menu VALUES ('1', '140244');
INSERT INTO sys_role_menu VALUES ('1', '140245');
INSERT INTO sys_role_menu VALUES ('1', '140246');
INSERT INTO sys_role_menu VALUES ('1', '140247');
INSERT INTO sys_role_menu VALUES ('1', '140248');
INSERT INTO sys_role_menu VALUES ('1', '140249');
INSERT INTO sys_role_menu VALUES ('1', '140250');
INSERT INTO sys_role_menu VALUES ('1', '140251');
INSERT INTO sys_role_menu VALUES ('1', '140252');
INSERT INTO sys_role_menu VALUES ('1', '140254');
INSERT INTO sys_role_menu VALUES ('1', '140255');
INSERT INTO sys_role_menu VALUES ('1', '140256');
INSERT INTO sys_role_menu VALUES ('1', '140257');
INSERT INTO sys_role_menu VALUES ('1', '140258');
INSERT INTO sys_role_menu VALUES ('1', '140259');
INSERT INTO sys_role_menu VALUES ('1', '140260');
INSERT INTO sys_role_menu VALUES ('1', '140261');
INSERT INTO sys_role_menu VALUES ('1', '140262');
INSERT INTO sys_role_menu VALUES ('1', '140263');
INSERT INTO sys_role_menu VALUES ('1', '140264');
INSERT INTO sys_role_menu VALUES ('1', '140265');
INSERT INTO sys_role_menu VALUES ('1', '140329');
INSERT INTO sys_role_menu VALUES ('1', '140330');
INSERT INTO sys_role_menu VALUES ('1', '140331');
INSERT INTO sys_role_menu VALUES ('1', '140332');
INSERT INTO sys_role_menu VALUES ('1', '140333');
INSERT INTO sys_role_menu VALUES ('1', '140334');
INSERT INTO sys_role_menu VALUES ('1', '140335');
INSERT INTO sys_role_menu VALUES ('1', '140336');
INSERT INTO sys_role_menu VALUES ('1', '140338');
INSERT INTO sys_role_menu VALUES ('1', '140339');
INSERT INTO sys_role_menu VALUES ('1', '140340');
INSERT INTO sys_role_menu VALUES ('2', '1');
INSERT INTO sys_role_menu VALUES ('2', '10');
INSERT INTO sys_role_menu VALUES ('2', '1001');
INSERT INTO sys_role_menu VALUES ('2', '1002');
INSERT INTO sys_role_menu VALUES ('2', '1003');
INSERT INTO sys_role_menu VALUES ('2', '1004');
INSERT INTO sys_role_menu VALUES ('2', '1005');
INSERT INTO sys_role_menu VALUES ('2', '1006');
INSERT INTO sys_role_menu VALUES ('2', '1007');
INSERT INTO sys_role_menu VALUES ('2', '140213');
INSERT INTO sys_role_menu VALUES ('2', '140214');
INSERT INTO sys_role_menu VALUES ('2', '140215');
INSERT INTO sys_role_menu VALUES ('2', '140216');
INSERT INTO sys_role_menu VALUES ('2', '140218');
INSERT INTO sys_role_menu VALUES ('2', '140219');
INSERT INTO sys_role_menu VALUES ('2', '140220');
INSERT INTO sys_role_menu VALUES ('2', '140221');
INSERT INTO sys_role_menu VALUES ('2', '140222');
INSERT INTO sys_role_menu VALUES ('2', '140223');
INSERT INTO sys_role_menu VALUES ('2', '140224');
INSERT INTO sys_role_menu VALUES ('2', '140225');
INSERT INTO sys_role_menu VALUES ('2', '140226');
INSERT INTO sys_role_menu VALUES ('2', '140227');
INSERT INTO sys_role_menu VALUES ('2', '140228');
INSERT INTO sys_role_menu VALUES ('2', '140229');
INSERT INTO sys_role_menu VALUES ('2', '140230');
INSERT INTO sys_role_menu VALUES ('2', '140231');
INSERT INTO sys_role_menu VALUES ('2', '140232');
INSERT INTO sys_role_menu VALUES ('2', '140233');
INSERT INTO sys_role_menu VALUES ('2', '140234');
INSERT INTO sys_role_menu VALUES ('2', '140235');
INSERT INTO sys_role_menu VALUES ('2', '140236');
INSERT INTO sys_role_menu VALUES ('2', '140237');
INSERT INTO sys_role_menu VALUES ('2', '140238');
INSERT INTO sys_role_menu VALUES ('2', '140239');
INSERT INTO sys_role_menu VALUES ('2', '140240');
INSERT INTO sys_role_menu VALUES ('2', '140241');
INSERT INTO sys_role_menu VALUES ('2', '140242');
INSERT INTO sys_role_menu VALUES ('2', '140243');
INSERT INTO sys_role_menu VALUES ('2', '140244');
INSERT INTO sys_role_menu VALUES ('2', '140245');
INSERT INTO sys_role_menu VALUES ('2', '140246');
INSERT INTO sys_role_menu VALUES ('2', '140247');
INSERT INTO sys_role_menu VALUES ('2', '140248');
INSERT INTO sys_role_menu VALUES ('2', '140249');
INSERT INTO sys_role_menu VALUES ('2', '140250');
INSERT INTO sys_role_menu VALUES ('2', '140251');
INSERT INTO sys_role_menu VALUES ('2', '140252');
INSERT INTO sys_role_menu VALUES ('2', '140254');
INSERT INTO sys_role_menu VALUES ('2', '140255');
INSERT INTO sys_role_menu VALUES ('2', '140256');
INSERT INTO sys_role_menu VALUES ('2', '140257');
INSERT INTO sys_role_menu VALUES ('2', '140258');
INSERT INTO sys_role_menu VALUES ('2', '140259');
INSERT INTO sys_role_menu VALUES ('2', '140260');
INSERT INTO sys_role_menu VALUES ('2', '140261');
INSERT INTO sys_role_menu VALUES ('2', '140262');
INSERT INTO sys_role_menu VALUES ('2', '140263');
INSERT INTO sys_role_menu VALUES ('2', '140264');
INSERT INTO sys_role_menu VALUES ('2', '140265');
INSERT INTO sys_role_menu VALUES ('2', '140329');
INSERT INTO sys_role_menu VALUES ('2', '140330');
INSERT INTO sys_role_menu VALUES ('2', '140331');
INSERT INTO sys_role_menu VALUES ('2', '140332');
INSERT INTO sys_role_menu VALUES ('2', '140333');
INSERT INTO sys_role_menu VALUES ('2', '140334');
INSERT INTO sys_role_menu VALUES ('2', '140335');
INSERT INTO sys_role_menu VALUES ('2', '140336');
INSERT INTO sys_role_menu VALUES ('2', '140338');
INSERT INTO sys_role_menu VALUES ('2', '140339');
INSERT INTO sys_role_menu VALUES ('2', '140340');
-- Table structure for sys_tenants
DROP TABLE IF EXISTS sys_tenants;
CREATE TABLE sys_tenants (
    id SERIAL NOT NULL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    created_by INTEGER NOT NULL DEFAULT '0',
    name VARCHAR(100) NOT NULL,
    code VARCHAR(50) NOT NULL,
    description VARCHAR(500),
    status SMALLINT NOT NULL DEFAULT '1',
    domain VARCHAR(255),
    platform_domain VARCHAR(255),
    menu_permission VARCHAR(1000),
    PRIMARY KEY (id)
);

COMMENT ON COLUMN sys_tenants.description IS '租户描述';
COMMENT ON COLUMN sys_tenants.status IS '状态 0停用 1启用';
COMMENT ON COLUMN sys_tenants.domain IS '租户域名';
COMMENT ON COLUMN sys_tenants.platform_domain IS '主域名';
COMMENT ON COLUMN sys_tenants.menu_permission IS '菜单权限';
COMMENT ON COLUMN sys_tenants.created_by IS '创建人';
COMMENT ON COLUMN sys_tenants.name IS '租户名称';
COMMENT ON COLUMN sys_tenants.code IS '租户编码';

-- Records of sys_tenants
INSERT INTO sys_tenants VALUES ('1', '2025-11-03 11:16:45', '2026-01-09 16:31:23', NULL, '1', '测试租户1', 'dom1', '', '1', '', '', '1,10,1001,140214,140215,140216,1002,140218,140219,140220,140221,140244,1003,140222,140223,140224,140225,140257,140258,1004,140229,140230,140231,1006,140255,140256,1007,140252,140264,140239,140240,140241,140242,140243,140254');
-- Table structure for sys_users
DROP TABLE IF EXISTS sys_users;
CREATE TABLE sys_users (
    id SERIAL NOT NULL,
    username VARCHAR(50) NOT NULL DEFAULT '',
    password VARCHAR(255) NOT NULL DEFAULT '',
    email VARCHAR(100) DEFAULT '',
    status SMALLINT DEFAULT '1',
    dept_id INTEGER DEFAULT '0',
    phone VARCHAR(64) DEFAULT '',
    sex VARCHAR(64) DEFAULT '',
    nick_name VARCHAR(100) DEFAULT '',
    avatar VARCHAR(255) DEFAULT '',
    description VARCHAR(500),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    created_by INTEGER DEFAULT '0',
    tenant_id INTEGER DEFAULT '0',
    PRIMARY KEY (id)
);

COMMENT ON COLUMN sys_users.status IS '是否启用 0停用 1启用';
COMMENT ON COLUMN sys_users.dept_id IS '部门ID';
COMMENT ON COLUMN sys_users.phone IS '电话';
COMMENT ON COLUMN sys_users.sex IS '性别';
COMMENT ON COLUMN sys_users.avatar IS '头像';
COMMENT ON COLUMN sys_users.description IS '描述';
COMMENT ON COLUMN sys_users.username IS '用户名';
COMMENT ON COLUMN sys_users.nick_name IS '昵称';
COMMENT ON COLUMN sys_users.created_by IS '创建人';
COMMENT ON COLUMN sys_users.tenant_id IS '租户ID字段';
COMMENT ON COLUMN sys_users.password IS '密码';
COMMENT ON COLUMN sys_users.email IS '邮箱';

-- Records of sys_users
INSERT INTO sys_users VALUES ('1', 'admin', '$2a$10$0aS9FxWlOz/PXiqzsBr7huy.Dqdwucyb795qiWcA6fsn0Lu.GLA.C', 'admin@example.com', '1', '1', '18800000006', '1', '超级管理员', '/public/uploads/2025-11-04/20251104_0945787a-8536-45fc-ba75-e94c8daaec06.jpeg', '超级管理员', '2025-08-18 14:55:05', '2025-11-17 17:38:01', NULL, '0', '0');
INSERT INTO sys_users VALUES ('4', 'demo', '$2a$10$yxq80jnZCRPn/hhQYUffheRnDopYjiq1AKGdgrg1oatLha7tc/.Qe', '', '1', '1', '', '1', '演示账号', '', '演示账号', '2025-10-17 15:38:37', '2025-10-31 16:32:34', NULL, '1', '0');
-- Table structure for sys_user_role
DROP TABLE IF EXISTS sys_user_role;
CREATE TABLE sys_user_role (
    user_id INTEGER NOT NULL DEFAULT '0',
    role_id INTEGER NOT NULL DEFAULT '0',
    PRIMARY KEY (user_id,role_id)
);

COMMENT ON COLUMN sys_user_role.user_id IS '用户ID';
COMMENT ON COLUMN sys_user_role.role_id IS '角色ID';

-- Records of sys_user_role
INSERT INTO sys_user_role VALUES ('1', '1');
INSERT INTO sys_user_role VALUES ('4', '2');
-- Table structure for sys_user_tenant
DROP TABLE IF EXISTS sys_user_tenant;
CREATE TABLE sys_user_tenant (
    user_id INTEGER NOT NULL DEFAULT '0',
    tenant_id INTEGER NOT NULL DEFAULT '0',
    is_default SMALLINT DEFAULT '0',
    created_at TIMESTAMP,
    PRIMARY KEY (user_id,tenant_id)
);

COMMENT ON COLUMN sys_user_tenant.user_id IS '用户ID';
COMMENT ON COLUMN sys_user_tenant.tenant_id IS '租户id';
COMMENT ON COLUMN sys_user_tenant.is_default IS '是否默认租户';

-- Records of sys_user_tenant

-- 创建索引
CREATE UNIQUE INDEX idx_casbin_rule ON sys_casbin_rule (ptype, v0, v1, v2, v3, v4, v5);
CREATE INDEX idx_sys_operation_logs_deleted_at ON sys_operation_logs (deleted_at);
CREATE INDEX idx_user_id ON sys_operation_logs (user_id);
CREATE UNIQUE INDEX username ON sys_users (username);
CREATE UNIQUE INDEX code ON sys_tenants (code);
CREATE UNIQUE INDEX domain ON sys_tenants (domain);
CREATE INDEX idx_sys_tenants_deleted_at ON sys_tenants (deleted_at);
CREATE INDEX idx_parent_id ON sys_menu (parent_id);
CREATE INDEX idx_sort ON sys_menu (sort);
CREATE INDEX idx_type ON sys_menu (type);

-- 设置序列值
-- 表 demo_teacher 的列 id 没有数据，序列 demo_teacher_id_seq 将保持默认起始值
SELECT setval('example_id_seq', 15, true);
-- 表 sys_operation_logs 的列 id 没有数据，序列 sys_operation_logs_id_seq 将保持默认起始值
SELECT setval('sys_role_id_seq', 2, true);
SELECT setval('sys_users_id_seq', 4, true);
SELECT setval('sys_gen_field_id_seq', 213, true);
SELECT setval('sys_tenants_id_seq', 1, true);
SELECT setval('sys_api_id_seq', 202, true);
SELECT setval('sys_dict_item_id_seq', 42, true);
SELECT setval('sys_gen_id_seq', 24, true);
SELECT setval('sys_menu_id_seq', 140340, true);
-- 表 demo_students 的列 student_id 没有数据，序列 demo_students_student_id_seq 将保持默认起始值
-- 表 sys_affix 的列 id 没有数据，序列 sys_affix_id_seq 将保持默认起始值
SELECT setval('sys_casbin_rule_id_seq', 7202, true);
SELECT setval('sys_department_id_seq', 1, true);
SELECT setval('sys_dict_id_seq', 4, true);


SET session_replication_role = DEFAULT;
SET client_min_messages TO NOTICE;
