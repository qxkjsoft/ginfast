-- 禁用外键检查
SET session_replication_role = replica;

-- 表: demo_students
DROP TABLE IF EXISTS demo_students;
CREATE TABLE demo_students (
    student_id SERIAL PRIMARY KEY,
    student_name VARCHAR(50) NOT NULL,
    age INTEGER NOT NULL DEFAULT 18,
    gender VARCHAR(50) NOT NULL DEFAULT '',
    class_name VARCHAR(20) NOT NULL,
    admission_date TIMESTAMP NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    created_by INTEGER DEFAULT 0,
    tenant_id INTEGER DEFAULT 0
);

COMMENT ON TABLE demo_students IS '学员管理';
COMMENT ON COLUMN demo_students.student_id IS 'ID';
COMMENT ON COLUMN demo_students.student_name IS '姓名';
COMMENT ON COLUMN demo_students.age IS '年龄';
COMMENT ON COLUMN demo_students.gender IS '性别';
COMMENT ON COLUMN demo_students.class_name IS '班级名称';
COMMENT ON COLUMN demo_students.admission_date IS '入学日期';
COMMENT ON COLUMN demo_students.email IS '邮箱';
COMMENT ON COLUMN demo_students.phone IS '电话号码';
COMMENT ON COLUMN demo_students.address IS '地址';
COMMENT ON COLUMN demo_students.created_at IS '创建时间';
COMMENT ON COLUMN demo_students.updated_at IS '更新时间';
COMMENT ON COLUMN demo_students.deleted_at IS '删除时间';
COMMENT ON COLUMN demo_students.created_by IS '创建人';
COMMENT ON COLUMN demo_students.tenant_id IS '租户ID字段';

-- 表: demo_teacher
DROP TABLE IF EXISTS demo_teacher;
CREATE TABLE demo_teacher (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    employee_id VARCHAR(20),
    gender SMALLINT DEFAULT 0,
    phone VARCHAR(20),
    email VARCHAR(100),
    subject VARCHAR(50),
    title VARCHAR(50),
    status SMALLINT DEFAULT 1,
    hire_date DATE,
    birth_date DATE,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    created_by INTEGER DEFAULT 0
);

COMMENT ON TABLE demo_teacher IS '教师表';
COMMENT ON COLUMN demo_teacher.id IS '主键ID';
COMMENT ON COLUMN demo_teacher.name IS '教师姓名';
COMMENT ON COLUMN demo_teacher.employee_id IS '工号';
COMMENT ON COLUMN demo_teacher.gender IS '性别：0-未知 1-男 2-女';
COMMENT ON COLUMN demo_teacher.phone IS '手机号';
COMMENT ON COLUMN demo_teacher.email IS '邮箱';
COMMENT ON COLUMN demo_teacher.subject IS '所教学科';
COMMENT ON COLUMN demo_teacher.title IS '职称';
COMMENT ON COLUMN demo_teacher.status IS '状态：0-离职 1-在职';
COMMENT ON COLUMN demo_teacher.hire_date IS '入职日期';
COMMENT ON COLUMN demo_teacher.birth_date IS '出生日期';
COMMENT ON COLUMN demo_teacher.created_at IS '创建时间';
COMMENT ON COLUMN demo_teacher.updated_at IS '更新时间';
COMMENT ON COLUMN demo_teacher.deleted_at IS '删除时间';
COMMENT ON COLUMN demo_teacher.created_by IS '创建人';

-- 表: example
DROP TABLE IF EXISTS example;
CREATE TABLE example (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    created_by INTEGER,
    tenant_id INTEGER DEFAULT 0
);

COMMENT ON COLUMN example.name IS '名称';
COMMENT ON COLUMN example.description IS '描述';
COMMENT ON COLUMN example.created_at IS '创建时间';
COMMENT ON COLUMN example.updated_at IS '更新时间';
COMMENT ON COLUMN example.deleted_at IS '删除时间';
COMMENT ON COLUMN example.created_by IS '创建人';
COMMENT ON COLUMN example.tenant_id IS '租户ID字段';

-- 插入示例数据
INSERT INTO example (id, name, description, created_at, updated_at, deleted_at, created_by, tenant_id) VALUES
(1, '项目管理系统', '用于管理项目进度和任务分配的系统', '2024-01-15 09:30:00', '2024-01-20 14:25:00', NULL, 1, 1),
(2, '客户关系管理', '帮助企业维护客户关系的软件平台', '2024-01-16 10:15:00', '2024-01-22 11:40:00', NULL, 1, 1),
(3, '财务分析工具', '提供财务报表和数据分析功能', '2024-01-17 14:20:00', '2024-01-25 16:30:00', NULL, 1, 1),
(4, '库存管理系统', '实时跟踪和管理库存水平', '2024-01-18 08:45:00', '2024-01-26 09:15:00', NULL, 1, 1),
(5, '人力资源平台', '员工信息管理和招聘流程优化', '2024-01-19 11:30:00', '2024-01-27 13:20:00', NULL, 1, 1),
(6, '在线学习系统', '提供课程管理和在线学习功能', '2024-01-20 15:10:00', '2024-01-28 17:05:00', NULL, 1, 1),
(7, '营销自动化', '自动化营销活动和客户跟进', '2024-01-21 09:00:00', '2024-01-29 10:45:00', NULL, 1, 1),
(8, '数据可视化', '将数据转化为直观的图表和报告', '2024-01-22 13:25:00', '2024-01-30 15:30:00', NULL, 1, 1),
(9, '移动应用开发', '跨平台移动应用开发框架', '2024-01-23 16:40:00', '2024-01-31 18:20:00', NULL, 1, 1),
(10, '云存储服务', '安全可靠的云端文件存储解决方案', '2024-01-24 10:50:00', '2024-02-01 12:35:00', NULL, 1, 1),
(11, '智能客服系统', '基于AI的智能客户服务助手', '2024-01-25 14:15:00', '2024-02-02 16:10:00', NULL, 1, 1),
(12, '供应链管理', '优化供应链流程和物流管理', '2024-01-26 08:30:00', '2024-02-03 10:25:00', NULL, 1, 1),
(13, '质量控制系统', '产品质量检测和流程监控', '2024-01-27 11:45:00', '2024-02-04 13:40:00', NULL, 1, 1),
(14, '企业门户网站', '企业信息发布和员工协作平台', '2024-01-28 15:20:00', '2024-02-05 17:15:00', NULL, 1, 1),
(15, '数据分析平台', '大数据处理和分析工具集', '2024-01-29 09:35:00', '2024-02-06 11:30:00', NULL, 1, 1);

-- 设置序列起始值
SELECT setval('example_id_seq', 16, false);

-- 表: sys_affix
DROP TABLE IF EXISTS sys_affix;
CREATE TABLE sys_affix (
    id SERIAL PRIMARY KEY,
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
    tenant_id INTEGER DEFAULT 0
);

COMMENT ON TABLE sys_affix IS '文件管理表';
COMMENT ON COLUMN sys_affix.id IS 'ID';
COMMENT ON COLUMN sys_affix.name IS '文件名';
COMMENT ON COLUMN sys_affix.path IS '路径';
COMMENT ON COLUMN sys_affix.url IS '文件url';
COMMENT ON COLUMN sys_affix.size IS '文件大小';
COMMENT ON COLUMN sys_affix.ftype IS '文件类型';
COMMENT ON COLUMN sys_affix.created_at IS '创建时间';
COMMENT ON COLUMN sys_affix.updated_at IS '更新时间';
COMMENT ON COLUMN sys_affix.deleted_at IS '删除时间';
COMMENT ON COLUMN sys_affix.created_by IS '创建人';
COMMENT ON COLUMN sys_affix.suffix IS '文件后缀';
COMMENT ON COLUMN sys_affix.tenant_id IS '租户ID字段';

-- 表: sys_api
DROP TABLE IF EXISTS sys_api;
CREATE TABLE sys_api (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    path VARCHAR(255),
    method VARCHAR(32),
    api_group VARCHAR(255),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    created_by INTEGER
);

COMMENT ON TABLE sys_api IS 'API权限表';
COMMENT ON COLUMN sys_api.id IS 'ID';
COMMENT ON COLUMN sys_api.title IS '权限名称';
COMMENT ON COLUMN sys_api.path IS '权限路径';
COMMENT ON COLUMN sys_api.method IS '请求方法';
COMMENT ON COLUMN sys_api.api_group IS '分组';
COMMENT ON COLUMN sys_api.created_at IS '创建时间';
COMMENT ON COLUMN sys_api.updated_at IS '更新时间';
COMMENT ON COLUMN sys_api.deleted_at IS '删除时间';
COMMENT ON COLUMN sys_api.created_by IS '创建人';

-- 插入API数据
INSERT INTO sys_api (id, title, path, method, api_group, created_at, updated_at, deleted_at, created_by) VALUES
(1, '用户登录', '/api/login', 'POST', '认证管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', NULL, 1),
(2, '刷新Token', '/api/refreshToken', 'POST', '认证管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', NULL, 1),
(3, '生成验证码ID', '/api/captcha/id', 'GET', '认证管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', NULL, 1),
(4, '获取验证码图片', '/api/captcha/image', 'GET', '认证管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', NULL, 1),
(5, '用户登出', '/api/users/logout', 'POST', '认证管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', NULL, 1),
(6, '获取当前用户信息', '/api/users/profile', 'GET', '用户管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', NULL, 1),
(7, '根据ID获取用户信息', '/api/users/:id', 'GET', '用户管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', NULL, 1),
(8, '用户列表', '/api/users/list', 'GET', '用户管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', NULL, 1),
(9, '新增用户', '/api/users/add', 'POST', '用户管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', NULL, 1),
(10, '更新用户信息', '/api/users/edit', 'PUT', '用户管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', NULL, 1),
(11, '删除用户', '/api/users/delete', 'DELETE', '用户管理', '2025-09-03 11:13:09', '2025-09-03 11:13:09', NULL, 1),
(12, '获取用户权限菜单', '/api/sysMenu/getRouters', 'GET', '菜单管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, 1),
(13, '获取完整菜单列表', '/api/sysMenu/getMenuList', 'GET', '菜单管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, 1),
(14, '根据ID获取菜单信息', '/api/sysMenu/:id', 'GET', '菜单管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, 1),
(15, '新增菜单', '/api/sysMenu/add', 'POST', '菜单管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, 1),
(16, '更新菜单', '/api/sysMenu/edit', 'PUT', '菜单管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, 1),
(17, '删除菜单', '/api/sysMenu/delete', 'DELETE', '菜单管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, 1),
(18, '获取部门列表', '/api/sysDepartment/getDivision', 'GET', '部门管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, 1),
(19, '获取所有角色数据', '/api/sysRole/getRoles', 'GET', '角色管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, 1),
(20, '根据角色ID获取角色菜单权限', '/api/sysRole/getUserPermission/:roleId', 'GET', '角色管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, 1),
(21, '添加角色的菜单权限', '/api/sysRole/addRoleMenu', 'POST', '角色管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, 1),
(22, '角色分页列表', '/api/sysRole/list', 'GET', '角色管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, 1),
(23, '根据ID获取角色信息', '/api/sysRole/:id', 'GET', '角色管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, 1),
(24, '新增角色', '/api/sysRole/add', 'POST', '角色管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, 1),
(25, '更新角色', '/api/sysRole/edit', 'PUT', '角色管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, 1),
(26, '删除角色', '/api/sysRole/delete', 'DELETE', '角色管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, 1),
(27, '获取所有字典数据', '/api/sysDict/getAllDicts', 'GET', '字典管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, 1),
(28, '根据字典编码获取字典', '/api/sysDict/getByCode/:code', 'GET', '字典管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, 1),
(29, 'API列表', '/api/sysApi/list', 'GET', 'API管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, 1),
(30, '根据ID获取API信息', '/api/sysApi/:id', 'GET', 'API管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, 1),
(31, '新增API', '/api/sysApi/add', 'POST', 'API管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, 1),
(32, '更新API', '/api/sysApi/edit', 'PUT', 'API管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, 1),
(33, '删除API', '/api/sysApi/delete', 'DELETE', 'API管理', '2025-09-03 11:13:10', '2025-09-03 11:13:10', NULL, 1),
(34, '测试11', '/api/sysTest/test', 'POST', 'test', '2025-09-03 11:14:23', '2025-09-03 11:30:19', NULL, 1),
(35, '根据菜单ID获取API的ID集合', '/api/sysMenu/apis/:id', 'GET', '菜单管理', '2025-09-04 17:25:14', '2025-09-04 17:25:14', NULL, 1),
(36, '设置菜单API权限', '/api/sysMenu/setApis', 'POST', '菜单管理', '2025-09-04 17:26:04', '2025-09-04 17:26:04', NULL, 1),
(37, '根据ID获取部门信息', '/api/sysDepartment/:id', 'GET', '部门管理', '2025-09-12 14:46:42', '2025-09-12 14:46:42', NULL, 1),
(38, '新增部门', '/api/sysDepartment/add', 'POST', '部门管理', '2025-09-12 14:47:27', '2025-09-12 14:47:27', NULL, 1),
(39, '更新部门', '/api/sysDepartment/edit', 'PUT', '部门管理', '2025-09-12 14:48:15', '2025-09-12 14:48:27', NULL, 1),
(40, '删除部门', '/api/sysDepartment/delete', 'DELETE', '部门管理', '2025-09-12 14:49:15', '2025-09-12 14:49:15', NULL, 1),
(41, '字典分页列表', '/api/sysDict/list', 'GET', '字典管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', NULL, 1),
(42, '根据ID获取字典信息', '/api/sysDict/:id', 'GET', '字典管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', NULL, 1),
(43, '新增字典', '/api/sysDict/add', 'POST', '字典管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', NULL, 1),
(44, '更新字典', '/api/sysDict/edit', 'PUT', '字典管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', NULL, 1),
(45, '删除字典', '/api/sysDict/delete', 'DELETE', '字典管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', NULL, 1),
(46, '字典项列表', '/api/sysDictItem/list', 'GET', '字典项管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', NULL, 1),
(47, '根据ID获取字典项信息', '/api/sysDictItem/:id', 'GET', '字典项管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', NULL, 1),
(48, '根据字典ID获取字典项列表', '/api/sysDictItem/getByDictId/:dictId', 'GET', '字典项管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', NULL, 1),
(49, '根据字典编码获取字典项列表', '/api/sysDictItem/getByDictCode/:dictCode', 'GET', '字典项管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', NULL, 1),
(50, '新增字典项', '/api/sysDictItem/add', 'POST', '字典项管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', NULL, 1),
(51, '更新字典项', '/api/sysDictItem/edit', 'PUT', '字典项管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', NULL, 1),
(52, '删除字典项', '/api/sysDictItem/delete', 'DELETE', '字典项管理', '2025-09-16 16:31:15', '2025-09-16 16:31:15', NULL, 1),
(53, '修改用户密码、手机号及邮箱', '/api/users/updateAccount', 'PUT', '用户管理', '2025-09-18 18:11:01', '2025-09-18 18:11:01', NULL, 1),
(54, '头像上传', '/api/users/uploadAvatar', 'POST', '用户管理', '2025-09-24 17:01:05', '2025-09-24 17:01:05', NULL, 1),
(55, '上传文件', '/api/sysAffix/upload', 'POST', '文件管理', '2025-09-25 15:51:04', '2025-09-25 15:51:04', NULL, 1),
(56, '删除文件', '/api/sysAffix/delete', 'DELETE', '文件管理', '2025-09-25 15:51:38', '2025-09-25 15:51:38', NULL, 1),
(57, '修改文件名', '/api/sysAffix/updateName', 'PUT', '文件管理', '2025-09-25 15:52:31', '2025-09-25 15:52:31', NULL, 1),
(58, '文件列表', '/api/sysAffix/list', 'GET', '文件管理', '2025-09-25 15:54:03', '2025-09-25 15:54:03', NULL, 1),
(59, '获取文件详情', '/api/sysAffix/:id', 'GET', '文件管理', '2025-09-25 15:54:55', '2025-09-25 15:54:55', NULL, 1),
(60, '下载文件', '/api/sysAffix/download/:id', 'GET', '文件管理', '2025-09-25 15:56:15', '2025-09-25 15:58:06', NULL, 1),
(61, '设置数据权限', '/api/sysRole/dataScope', 'PUT', '角色管理', '2025-09-26 17:04:15', '2025-09-26 17:04:15', NULL, 1),
(62, '读取系统配置', '/api/config/get', 'GET', '系统配置', '2025-10-09 16:21:29', '2025-10-09 16:21:29', NULL, 1),
(63, '修改系统配置', '/api/config/update', 'PUT', '系统配置', '2025-10-09 16:21:59', '2025-10-09 16:22:09', NULL, 1),
(64, '查看内存缓存', '/api/config/viewCache', 'GET', '系统配置', '2025-10-10 17:41:33', '2025-10-10 17:41:33', NULL, 1),
(65, '列表查询', '/api/plugins/example/list', 'GET', '插件示例', '2025-10-14 10:54:47', '2025-10-14 10:54:47', NULL, 1),
(66, '新增', '/api/plugins/example/add', 'POST', '插件示例', '2025-10-14 10:56:43', '2025-10-14 10:56:43', NULL, 1),
(67, '修改', '/api/plugins/example/edit', 'PUT', '插件示例', '2025-10-14 10:57:10', '2025-10-14 10:57:17', NULL, 1),
(68, '删除', '/api/plugins/example/delete', 'DELETE', '插件示例', '2025-10-14 10:58:03', '2025-10-14 10:58:03', NULL, 1),
(69, '查询单条数据', '/api/plugins/example/:id', 'GET', '插件示例', '2025-10-14 10:59:33', '2025-10-14 10:59:33', NULL, 1),
(70, '日志列表', '/api/sysOperationLog/list', 'GET', '日志管理', '2025-10-20 10:10:58', '2025-10-20 10:10:58', NULL, 1),
(71, '日志统计', '/api/sysOperationLog/stats', 'GET', '日志管理', '2025-10-20 10:12:01', '2025-10-20 10:12:01', '2025-10-20 10:45:07', 1),
(72, '日志删除', '/api/sysOperationLog/delete', 'DELETE', '日志管理', '2025-10-20 10:13:19', '2025-10-20 10:13:19', NULL, 1),
(73, '日志导出', '/api/sysOperationLog/export', 'GET', '日志管理', '2025-10-20 10:14:11', '2025-10-20 10:14:11', NULL, 1),
(74, '导出菜单', '/api/sysMenu/export', 'GET', '菜单管理', '2025-10-20 17:17:07', '2025-10-20 17:17:07', NULL, 1),
(75, '导入菜单', '/api/sysMenu/import', 'POST', '菜单管理', '2025-10-21 11:30:34', '2025-10-24 08:59:44', NULL, 1),
(76, '租户列表', '/api/sysTenant/list', 'GET', '租户管理', '2025-10-24 09:04:18', '2025-10-24 09:04:18', NULL, 1),
(77, '根据ID获取租户信息', '/api/sysTenant/:id', 'GET', '租户管理', '2025-10-24 09:05:23', '2025-10-24 09:05:23', NULL, 1),
(78, '新增租户', '/api/sysTenant/add', 'POST', '租户管理', '2025-10-24 09:06:10', '2025-10-24 09:06:10', NULL, 1),
(79, '编辑租户', '/api/sysTenant/edit', 'PUT', '租户管理', '2025-10-24 09:06:54', '2025-10-24 09:06:54', NULL, 1),
(80, '删除租户', '/api/sysTenant/:id', 'DELETE', '租户管理', '2025-10-24 09:07:47', '2025-10-24 09:07:56', NULL, 1),
(81, '租户关联列表', '/api/sysUserTenant/list', 'GET', '租户管理', '2025-10-27 17:51:52', '2025-10-27 17:51:52', NULL, 1),
(82, '根据用户ID和租户ID获取用户租户关联信息', '/api/sysUserTenant/get', 'GET', '租户管理', '2025-10-27 17:53:13', '2025-10-27 17:53:13', NULL, 1),
(83, '批量新增用户租户关联', '/api/sysUserTenant/batchAdd', 'POST', '租户管理', '2025-10-27 17:53:48', '2025-10-27 17:53:48', NULL, 1),
(84, '批量删除用户租户关联', '/api/sysUserTenant/batchDelete', 'DELETE', '租户管理', '2025-10-27 17:54:25', '2025-10-27 17:54:25', NULL, 1),
(85, '用户列表(不限租户)', '/api/sysUserTenant/userListAll', 'GET', '用户管理', '2025-10-28 09:41:19', '2025-10-28 16:32:35', NULL, 1),
(86, '获取所有的角色数据(不限制租户)', '/api/sysUserTenant/getRolesAll', 'GET', '租户管理', '2025-10-29 09:17:01', '2025-10-29 09:17:01', NULL, 1),
(87, '设置用户角色(不限租户)', '/api/sysUserTenant/setUserRoles', 'POST', '租户管理 ', '2025-10-29 09:17:50', '2025-10-29 09:17:50', NULL, 1),
(88, '获取用户角色ID集合(不限租户)', '/api/sysUserTenant/getUserRoleIDs', 'GET', '租户管理', '2025-10-29 09:18:51', '2025-10-29 09:18:51', NULL, 1),
(89, '修改用户基本信息', '/api/users/updateBasicInfo', 'PUT', '用户管理', '2025-10-31 09:05:00', '2025-10-31 09:05:00', NULL, 1),
(105, '生成代码文件', '/api/codegen/generate', 'POST', '代码生成', '2025-11-07 15:32:53', '2025-11-07 15:32:53', NULL, 1),
(106, '获取表的字段信息', '/api/codegen/columns', 'GET', '代码生成', '2025-11-07 15:33:52', '2025-11-07 15:33:52', NULL, 1),
(187, '获取数据库列表', '/api/codegen/databases', 'GET', '代码生成', '2025-11-17 15:12:26', '2025-11-17 15:12:26', NULL, 1),
(188, '获取指定数据库中的表集合', '/api/codegen/tables', 'GET', '代码生成', '2025-11-17 15:13:38', '2025-11-17 15:13:38', NULL, 1),
(189, '代码预览', '/api/codegen/preview', 'GET', '代码生成', '2025-11-17 15:14:25', '2025-11-17 15:14:25', NULL, 1),
(190, '代码生成配置列表', '/api/sysGen/list', 'GET', '代码生成', '2025-11-17 15:15:20', '2025-11-17 15:15:20', NULL, 1),
(191, '批量创建代码生成配置', '/api/sysGen/batchInsert', 'POST', '代码生成', '2025-11-17 15:22:46', '2025-11-17 15:22:46', NULL, 1),
(192, '获取代码生成配置详情', '/api/sysGen/:id', 'GET', '代码生成', '2025-11-17 15:23:29', '2025-11-17 15:23:29', NULL, 1),
(193, '更新代码生成配置和字段信息', '/api/sysGen/update', 'PUT', '代码生成', '2025-11-17 15:24:41', '2025-11-17 15:24:41', NULL, 1),
(194, '删除代码生成配置和字段信息', '/api/sysGen/:id', 'DELETE', '代码生成', '2025-11-17 15:26:44', '2025-11-17 15:26:44', NULL, 1),
(195, '刷新代码生成配置的字段信息', '/api/sysGen/refreshFields', 'PUT', '代码生成', '2025-11-17 15:27:33', '2025-11-17 15:27:33', NULL, 1),
(196, '生成菜单', '/api/codegen/insertmenuandapi', 'POST', '代码生成', '2025-11-26 15:12:56', '2025-11-26 15:12:56', NULL, 1),
(197, '批量删除', '/api/sysMenu/batchDelete', 'DELETE', '菜单管理', '2025-12-05 17:48:52', '2025-12-05 17:48:52', NULL, 1),
(198, '获取插件列表', '/api/pluginsmanager/exports', 'GET', '插件管理', '2025-12-08 16:38:26', '2025-12-08 16:38:26', NULL, 1),
(199, '导出插件', '/api/pluginsmanager/export', 'POST', '插件管理', '2025-12-08 16:39:19', '2025-12-08 16:44:36', NULL, 1),
(200, '导入插件', '/api/pluginsmanager/import', 'POST', '插件管理', '2025-12-08 16:47:11', '2025-12-08 16:47:11', NULL, 1),
(201, '卸载插件', '/api/pluginsmanager/uninstall', 'DELETE', '插件管理', '2025-12-08 16:48:07', '2025-12-08 16:48:07', NULL, 1);

-- 设置序列起始值
SELECT setval('sys_api_id_seq', 202, false);

-- 表: sys_casbin_rule
DROP TABLE IF EXISTS sys_casbin_rule;
CREATE TABLE sys_casbin_rule (
    id SERIAL PRIMARY KEY,
    ptype VARCHAR(100),
    v0 VARCHAR(100),
    v1 VARCHAR(100),
    v2 VARCHAR(100),
    v3 VARCHAR(100),
    v4 VARCHAR(100),
    v5 VARCHAR(100)
);

-- 插入casbin规则数据
INSERT INTO sys_casbin_rule (id, ptype, v0, v1, v2, v3, v4, v5) VALUES
(6266, 'g', 'user_1', 'role_1', '*', '', '', ''),
(4189, 'g', 'user_4', 'role_2', '*', '', '', ''),
(6949, 'p', 'role_1', '/api/codegen/generate', 'POST', '*', '', ''),
(7000, 'p', 'role_1', '/api/codegen/insertmenuandapi', 'POST', '*', '', ''),
(6964, 'p', 'role_1', '/api/codegen/preview', 'GET', '*', '', ''),
(6938, 'p', 'role_1', '/api/codegen/tables', 'GET', '*', '', ''),
(6983, 'p', 'role_1', '/api/config/get', 'GET', '*', '', ''),
(7004, 'p', 'role_1', '/api/config/update', 'PUT', '*', '', ''),
(7014, 'p', 'role_1', '/api/config/viewCache', 'GET', '*', '', ''),
(6954, 'p', 'role_1', '/api/plugins/example/*', 'GET', '*', '', ''),
(6955, 'p', 'role_1', '/api/plugins/example/add', 'POST', '*', '', ''),
(7024, 'p', 'role_1', '/api/plugins/example/delete', 'DELETE', '*', '', ''),
(6956, 'p', 'role_1', '/api/plugins/example/edit', 'PUT', '*', '', ''),
(6984, 'p', 'role_1', '/api/plugins/example/list', 'GET', '*', '', ''),
(6950, 'p', 'role_1', '/api/pluginsmanager/export', 'POST', '*', '', ''),
(6972, 'p', 'role_1', '/api/pluginsmanager/exports', 'GET', '*', '', ''),
(6976, 'p', 'role_1', '/api/pluginsmanager/import', 'POST', '*', '', ''),
(6977, 'p', 'role_1', '/api/pluginsmanager/uninstall', 'DELETE', '*', '', ''),
(6991, 'p', 'role_1', '/api/sysAffix/delete', 'DELETE', '*', '', ''),
(6945, 'p', 'role_1', '/api/sysAffix/download/*', 'GET', '*', '', ''),
(7015, 'p', 'role_1', '/api/sysAffix/list', 'GET', '*', '', ''),
(7003, 'p', 'role_1', '/api/sysAffix/updateName', 'PUT', '*', '', ''),
(6990, 'p', 'role_1', '/api/sysAffix/upload', 'POST', '*', '', ''),
(6969, 'p', 'role_1', '/api/sysApi/*', 'GET', '*', '', ''),
(6995, 'p', 'role_1', '/api/sysApi/add', 'POST', '*', '', ''),
(7002, 'p', 'role_1', '/api/sysApi/delete', 'DELETE', '*', '', ''),
(6988, 'p', 'role_1', '/api/sysApi/edit', 'PUT', '*', '', ''),
(6966, 'p', 'role_1', '/api/sysApi/list', 'GET', '*', '', ''),
(6981, 'p', 'role_1', '/api/sysDepartment/add', 'POST', '*', '', ''),
(6989, 'p', 'role_1', '/api/sysDepartment/delete', 'DELETE', '*', '', ''),
(6975, 'p', 'role_1', '/api/sysDepartment/edit', 'PUT', '*', '', ''),
(6993, 'p', 'role_1', '/api/sysDepartment/getDivision', 'GET', '*', '', ''),
(7011, 'p', 'role_1', '/api/sysDict/add', 'POST', '*', '', ''),
(6958, 'p', 'role_1', '/api/sysDict/delete', 'DELETE', '*', '', ''),
(6951, 'p', 'role_1', '/api/sysDict/edit', 'PUT', '*', '', ''),
(6986, 'p', 'role_1', '/api/sysDict/getAllDicts', 'GET', '*', '', ''),
(7008, 'p', 'role_1', '/api/sysDict/list', 'GET', '*', '', ''),
(7013, 'p', 'role_1', '/api/sysDictItem/add', 'POST', '*', '', ''),
(6982, 'p', 'role_1', '/api/sysDictItem/delete', 'DELETE', '*', '', ''),
(6944, 'p', 'role_1', '/api/sysDictItem/edit', 'PUT', '*', '', ''),
(7012, 'p', 'role_1', '/api/sysDictItem/getByDictId/*', 'GET', '*', '', ''),
(7018, 'p', 'role_1', '/api/sysGen/*', 'DELETE', '*', '', ''),
(6963, 'p', 'role_1', '/api/sysGen/*', 'GET', '*', '', ''),
(6948, 'p', 'role_1', '/api/sysGen/batchInsert', 'POST', '*', '', ''),
(6999, 'p', 'role_1', '/api/sysGen/list', 'GET', '*', '', ''),
(7017, 'p', 'role_1', '/api/sysGen/refreshFields', 'PUT', '*', '', ''),
(7006, 'p', 'role_1', '/api/sysGen/update', 'PUT', '*', '', ''),
(6994, 'p', 'role_1', '/api/sysMenu/add', 'POST', '*', '', ''),
(6987, 'p', 'role_1', '/api/sysMenu/apis/*', 'GET', '*', '', ''),
(6980, 'p', 'role_1', '/api/sysMenu/batchDelete', 'DELETE', '*', '', ''),
(7010, 'p', 'role_1', '/api/sysMenu/delete', 'DELETE', '*', '', ''),
(6968, 'p', 'role_1', '/api/sysMenu/edit', 'PUT', '*', '', ''),
(6992, 'p', 'role_1', '/api/sysMenu/export', 'GET', '*', '', ''),
(7022, 'p', 'role_1', '/api/sysMenu/getMenuList', 'GET', '*', '', ''),
(7007, 'p', 'role_1', '/api/sysMenu/getRouters', 'GET', '*', '', ''),
(7016, 'p', 'role_1', '/api/sysMenu/import', 'POST', '*', '', ''),
(7023, 'p', 'role_1', '/api/sysMenu/setApis', 'POST', '*', '', ''),
(7005, 'p', 'role_1', '/api/sysOperationLog/delete', 'DELETE', '*', '', ''),
(6946, 'p', 'role_1', '/api/sysOperationLog/export', 'GET', '*', '', ''),
(6965, 'p', 'role_1', '/api/sysOperationLog/list', 'GET', '*', '', ''),
(6967, 'p', 'role_1', '/api/sysRole/add', 'POST', '*', '', ''),
(7009, 'p', 'role_1', '/api/sysRole/addRoleMenu', 'POST', '*', '', ''),
(6953, 'p', 'role_1', '/api/sysRole/dataScope', 'PUT', '*', '', ''),
(6978, 'p', 'role_1', '/api/sysRole/delete', 'DELETE', '*', '', ''),
(7020, 'p', 'role_1', '/api/sysRole/edit', 'PUT', '*', '', ''),
(7019, 'p', 'role_1', '/api/sysRole/getRoles', 'GET', '*', '', ''),
(6979, 'p', 'role_1', '/api/sysRole/getUserPermission/*', 'GET', '*', '', ''),
(6937, 'p', 'role_1', '/api/sysTenant/*', 'DELETE', '*', '', ''),
(6940, 'p', 'role_1', '/api/sysTenant/*', 'GET', '*', '', ''),
(6947, 'p', 'role_1', '/api/sysTenant/add', 'POST', '*', '', ''),
(6959, 'p', 'role_1', '/api/sysTenant/edit', 'PUT', '*', '', ''),
(6961, 'p', 'role_1', '/api/sysTenant/list', 'GET', '*', '', ''),
(6962, 'p', 'role_1', '/api/sysUserTenant/batchAdd', 'POST', '*', '', ''),
(6971, 'p', 'role_1', '/api/sysUserTenant/batchDelete', 'DELETE', '*', '', ''),
(6970, 'p', 'role_1', '/api/sysUserTenant/get', 'GET', '*', '', ''),
(6996, 'p', 'role_1', '/api/sysUserTenant/getRolesAll', 'GET', '*', '', ''),
(6997, 'p', 'role_1', '/api/sysUserTenant/getUserRoleIDs', 'GET', '*', '', ''),
(6941, 'p', 'role_1', '/api/sysUserTenant/list', 'GET', '*', '', ''),
(6943, 'p', 'role_1', '/api/sysUserTenant/setUserRoles', 'POST', '*', '', ''),
(6942, 'p', 'role_1', '/api/sysUserTenant/userListAll', 'GET', '*', '', ''),
(6985, 'p', 'role_1', '/api/users/*', 'GET', '*', '', ''),
(7001, 'p', 'role_1', '/api/users/add', 'POST', '*', '', ''),
(6960, 'p', 'role_1', '/api/users/delete', 'DELETE', '*', '', ''),
(6957, 'p', 'role_1', '/api/users/edit', 'PUT', '*', '', ''),
(7021, 'p', 'role_1', '/api/users/list', 'GET', '*', '', ''),
(6973, 'p', 'role_1', '/api/users/logout', 'POST', '*', '', ''),
(6974, 'p', 'role_1', '/api/users/profile', 'GET', '*', '', ''),
(6952, 'p', 'role_1', '/api/users/updateAccount', 'PUT', '*', '', ''),
(6998, 'p', 'role_1', '/api/users/updateBasicInfo', 'PUT', '*', '', ''),
(6939, 'p', 'role_1', '/api/users/uploadAvatar', 'POST', '*', '', ''),
(4148, 'p', 'role_10', '/api/config/get', 'GET', '*', '', ''),
(4155, 'p', 'role_10', '/api/config/update', 'PUT', '*', '', ''),
(4162, 'p', 'role_10', '/api/config/viewCache', 'GET', '*', '', ''),
(4168, 'p', 'role_10', '/api/sysAffix/list', 'GET', '*', '', ''),
(4125, 'p', 'role_10', '/api/sysApi/*', 'GET', '*', '', ''),
(4175, 'p', 'role_10', '/api/sysApi/add', 'POST', '*', '', ''),
(4179, 'p', 'role_10', '/api/sysApi/delete', 'DELETE', '*', '', ''),
(4153, 'p', 'role_10', '/api/sysApi/edit', 'PUT', '*', '', ''),
(4158, 'p', 'role_10', '/api/sysApi/list', 'GET', '*', '', ''),
(4176, 'p', 'role_10', '/api/sysDepartment/add', 'POST', '*', '', ''),
(4133, 'p', 'role_10', '/api/sysDepartment/delete', 'DELETE', '*', '', ''),
(4167, 'p', 'role_10', '/api/sysDepartment/edit', 'PUT', '*', '', ''),
(4122, 'p', 'role_10', '/api/sysDepartment/getDivision', 'GET', '*', '', ''),
(4136, 'p', 'role_10', '/api/sysDict/add', 'POST', '*', '', ''),
(4144, 'p', 'role_10', '/api/sysDict/delete', 'DELETE', '*', '', ''),
(4137, 'p', 'role_10', '/api/sysDict/edit', 'PUT', '*', '', ''),
(4184, 'p', 'role_10', '/api/sysDict/getAllDicts', 'GET', '*', '', ''),
(4139, 'p', 'role_10', '/api/sysDict/list', 'GET', '*', '', ''),
(4146, 'p', 'role_10', '/api/sysDictItem/add', 'POST', '*', '', ''),
(4154, 'p', 'role_10', '/api/sysDictItem/delete', 'DELETE', '*', '', ''),
(4147, 'p', 'role_10', '/api/sysDictItem/edit', 'PUT', '*', '', ''),
(4141, 'p', 'role_10', '/api/sysDictItem/getByDictId/*', 'GET', '*', '', ''),
(4174, 'p', 'role_10', '/api/sysMenu/add', 'POST', '*', '', ''),
(4145, 'p', 'role_10', '/api/sysMenu/apis/*', 'GET', '*', '', ''),
(4124, 'p', 'role_10', '/api/sysMenu/delete', 'DELETE', '*', '', ''),
(4123, 'p', 'role_10', '/api/sysMenu/edit', 'PUT', '*', '', ''),
(4172, 'p', 'role_10', '/api/sysMenu/export', 'GET', '*', '', ''),
(4177, 'p', 'role_10', '/api/sysMenu/getMenuList', 'GET', '*', '', ''),
(4150, 'p', 'role_10', '/api/sysMenu/getRouters', 'GET', '*', '', ''),
(4126, 'p', 'role_10', '/api/sysMenu/import', 'POST', '*', '', ''),
(4161, 'p', 'role_10', '/api/sysMenu/setApis', 'POST', '*', '', ''),
(4134, 'p', 'role_10', '/api/sysOperationLog/delete', 'DELETE', '*', '', ''),
(4156, 'p', 'role_10', '/api/sysOperationLog/export', 'GET', '*', '', ''),
(4131, 'p', 'role_10', '/api/sysOperationLog/list', 'GET', '*', '', ''),
(4128, 'p', 'role_10', '/api/sysRole/add', 'POST', '*', '', ''),
(4135, 'p', 'role_10', '/api/sysRole/addRoleMenu', 'POST', '*', '', ''),
(4151, 'p', 'role_10', '/api/sysRole/dataScope', 'PUT', '*', '', ''),
(4140, 'p', 'role_10', '/api/sysRole/delete', 'DELETE', '*', '', ''),
(4166, 'p', 'role_10', '/api/sysRole/edit', 'PUT', '*', '', ''),
(4130, 'p', 'role_10', '/api/sysRole/getRoles', 'GET', '*', '', ''),
(4132, 'p', 'role_10', '/api/sysRole/getUserPermission/*', 'GET', '*', '', ''),
(4163, 'p', 'role_10', '/api/sysTenant/*', 'DELETE', '*', '', ''),
(4142, 'p', 'role_10', '/api/sysTenant/*', 'GET', '*', '', ''),
(4180, 'p', 'role_10', '/api/sysTenant/add', 'POST', '*', '', ''),
(4157, 'p', 'role_10', '/api/sysTenant/edit', 'PUT', '*', '', ''),
(4173, 'p', 'role_10', '/api/sysTenant/list', 'GET', '*', '', ''),
(4164, 'p', 'role_10', '/api/sysUserTenant/batchAdd', 'POST', '*', '', ''),
(4169, 'p', 'role_10', '/api/sysUserTenant/batchDelete', 'DELETE', '*', '', ''),
(4149, 'p', 'role_10', '/api/sysUserTenant/get', 'GET', '*', '', ''),
(4182, 'p', 'role_10', '/api/sysUserTenant/getRolesAll', 'GET', '*', '', ''),
(4152, 'p', 'role_10', '/api/sysUserTenant/getUserRoleIDs', 'GET', '*', '', ''),
(4165, 'p', 'role_10', '/api/sysUserTenant/list', 'GET', '*', '', ''),
(4129, 'p', 'role_10', '/api/sysUserTenant/setUserRoles', 'POST', '*', '', ''),
(4181, 'p', 'role_10', '/api/sysUserTenant/userListAll', 'GET', '*', '', ''),
(4127, 'p', 'role_10', '/api/users/*', 'GET', '*', '', ''),
(4159, 'p', 'role_10', '/api/users/add', 'POST', '*', '', ''),
(4160, 'p', 'role_10', '/api/users/delete', 'DELETE', '*', '', ''),
(4178, 'p', 'role_10', '/api/users/edit', 'PUT', '*', '', ''),
(4143, 'p', 'role_10', '/api/users/list', 'GET', '*', '', ''),
(4170, 'p', 'role_10', '/api/users/logout', 'POST', '*', '', ''),
(4183, 'p', 'role_10', '/api/users/profile', 'GET', '*', '', ''),
(4138, 'p', 'role_10', '/api/users/updateAccount', 'PUT', '*', '', ''),
(4171, 'p', 'role_10', '/api/users/uploadAvatar', 'POST', '*', '', ''),
(6869, 'p', 'role_2', '/api/codegen/generate', 'POST', '*', '', ''),
(6907, 'p', 'role_2', '/api/codegen/insertmenuandapi', 'POST', '*', '', ''),
(6914, 'p', 'role_2', '/api/codegen/preview', 'GET', '*', '', ''),
(6922, 'p', 'role_2', '/api/codegen/tables', 'GET', '*', '', ''),
(6861, 'p', 'role_2', '/api/config/get', 'GET', '*', '', ''),
(6867, 'p', 'role_2', '/api/config/update', 'PUT', '*', '', ''),
(6921, 'p', 'role_2', '/api/config/viewCache', 'GET', '*', '', ''),
(6924, 'p', 'role_2', '/api/plugins/example/*', 'GET', '*', '', ''),
(6854, 'p', 'role_2', '/api/plugins/example/add', 'POST', '*', '', ''),
(6904, 'p', 'role_2', '/api/plugins/example/delete', 'DELETE', '*', '', ''),
(6866, 'p', 'role_2', '/api/plugins/example/edit', 'PUT', '*', '', ''),
(6878, 'p', 'role_2', '/api/plugins/example/list', 'GET', '*', '', ''),
(6894, 'p', 'role_2', '/api/pluginsmanager/export', 'POST', '*', '', ''),
(6887, 'p', 'role_2', '/api/pluginsmanager/exports', 'GET', '*', '', ''),
(6915, 'p', 'role_2', '/api/pluginsmanager/import', 'POST', '*', '', ''),
(6895, 'p', 'role_2', '/api/pluginsmanager/uninstall', 'DELETE', '*', '', ''),
(6923, 'p', 'role_2', '/api/sysAffix/delete', 'DELETE', '*', '', ''),
(6860, 'p', 'role_2', '/api/sysAffix/download/*', 'GET', '*', '', ''),
(6899, 'p', 'role_2', '/api/sysAffix/list', 'GET', '*', '', ''),
(6913, 'p', 'role_2', '/api/sysAffix/updateName', 'PUT', '*', '', ''),
(6917, 'p', 'role_2', '/api/sysAffix/upload', 'POST', '*', '', ''),
(6865, 'p', 'role_2', '/api/sysApi/*', 'GET', '*', '', ''),
(6902, 'p', 'role_2', '/api/sysApi/add', 'POST', '*', '', ''),
(6931, 'p', 'role_2', '/api/sysApi/delete', 'DELETE', '*', '', ''),
(6911, 'p', 'role_2', '/api/sysApi/edit', 'PUT', '*', '', ''),
(6927, 'p', 'role_2', '/api/sysApi/list', 'GET', '*', '', ''),
(6859, 'p', 'role_2', '/api/sysDepartment/add', 'POST', '*', '', ''),
(6849, 'p', 'role_2', '/api/sysDepartment/delete', 'DELETE', '*', '', ''),
(6912, 'p', 'role_2', '/api/sysDepartment/edit', 'PUT', '*', '', ''),
(6881, 'p', 'role_2', '/api/sysDepartment/getDivision', 'GET', '*', '', ''),
(6909, 'p', 'role_2', '/api/sysDict/add', 'POST', '*', '', ''),
(6903, 'p', 'role_2', '/api/sysDict/delete', 'DELETE', '*', '', ''),
(6890, 'p', 'role_2', '/api/sysDict/edit', 'PUT', '*', '', ''),
(6856, 'p', 'role_2', '/api/sysDict/getAllDicts', 'GET', '*', '', ''),
(6882, 'p', 'role_2', '/api/sysDict/list', 'GET', '*', '', ''),
(6871, 'p', 'role_2', '/api/sysDictItem/add', 'POST', '*', '', ''),
(6850, 'p', 'role_2', '/api/sysDictItem/delete', 'DELETE', '*', '', ''),
(6929, 'p', 'role_2', '/api/sysDictItem/edit', 'PUT', '*', '', ''),
(6877, 'p', 'role_2', '/api/sysDictItem/getByDictId/*', 'GET', '*', '', ''),
(6920, 'p', 'role_2', '/api/sysGen/*', 'DELETE', '*', '', ''),
(6853, 'p', 'role_2', '/api/sysGen/*', 'GET', '*', '', ''),
(6893, 'p', 'role_2', '/api/sysGen/batchInsert', 'POST', '*', '', ''),
(6880, 'p', 'role_2', '/api/sysGen/list', 'GET', '*', '', ''),
(6919, 'p', 'role_2', '/api/sysGen/refreshFields', 'PUT', '*', '', ''),
(6886, 'p', 'role_2', '/api/sysGen/update', 'PUT', '*', '', ''),
(6936, 'p', 'role_2', '/api/sysMenu/add', 'POST', '*', '', ''),
(6858, 'p', 'role_2', '/api/sysMenu/apis/*', 'GET', '*', '', ''),
(6898, 'p', 'role_2', '/api/sysMenu/batchDelete', 'DELETE', '*', '', ''),
(6870, 'p', 'role_2', '/api/sysMenu/delete', 'DELETE', '*', '', ''),
(6875, 'p', 'role_2', '/api/sysMenu/edit', 'PUT', '*', '', ''),
(6932, 'p', 'role_2', '/api/sysMenu/export', 'GET', '*', '', ''),
(6857, 'p', 'role_2', '/api/sysMenu/getMenuList', 'GET', '*', '', ''),
(6862, 'p', 'role_2', '/api/sysMenu/getRouters', 'GET', '*', '', ''),
(6933, 'p', 'role_2', '/api/sysMenu/import', 'POST', '*', '', ''),
(6876, 'p', 'role_2', '/api/sysMenu/setApis', 'POST', '*', '', ''),
(6851, 'p', 'role_2', '/api/sysOperationLog/delete', 'DELETE', '*', '', ''),
(6879, 'p', 'role_2', '/api/sysOperationLog/export', 'GET', '*', '', ''),
(6900, 'p', 'role_2', '/api/sysOperationLog/list', 'GET', '*', '', ''),
(6928, 'p', 'role_2', '/api/sysRole/add', 'POST', '*', '', ''),
(6916, 'p', 'role_2', '/api/sysRole/addRoleMenu', 'POST', '*', '', ''),
(6883, 'p', 'role_2', '/api/sysRole/dataScope', 'PUT', '*', '', ''),
(6897, 'p', 'role_2', '/api/sysRole/delete', 'DELETE', '*', '', ''),
(6864, 'p', 'role_2', '/api/sysRole/edit', 'PUT', '*', '', ''),
(6935, 'p', 'role_2', '/api/sysRole/getRoles', 'GET', '*', '', ''),
(6889, 'p', 'role_2', '/api/sysRole/getUserPermission/*', 'GET', '*', '', ''),
(6885, 'p', 'role_2', '/api/sysTenant/*', 'DELETE', '*', '', ''),
(6930, 'p', 'role_2', '/api/sysTenant/*', 'GET', '*', '', ''),
(6884, 'p', 'role_2', '/api/sysTenant/add', 'POST', '*', '', ''),
(6891, 'p', 'role_2', '/api/sysTenant/edit', 'PUT', '*', '', ''),
(6852, 'p', 'role_2', '/api/sysTenant/list', 'GET', '*', '', ''),
(6892, 'p', 'role_2', '/api/sysUserTenant/batchAdd', 'POST', '*', '', ''),
(6926, 'p', 'role_2', '/api/sysUserTenant/batchDelete', 'DELETE', '*', '', ''),
(6868, 'p', 'role_2', '/api/sysUserTenant/get', 'GET', '*', '', ''),
(6906, 'p', 'role_2', '/api/sysUserTenant/getRolesAll', 'GET', '*', '', ''),
(6872, 'p', 'role_2', '/api/sysUserTenant/getUserRoleIDs', 'GET', '*', '', ''),
(6925, 'p', 'role_2', '/api/sysUserTenant/list', 'GET', '*', '', ''),
(6918, 'p', 'role_2', '/api/sysUserTenant/setUserRoles', 'POST', '*', '', ''),
(6905, 'p', 'role_2', '/api/sysUserTenant/userListAll', 'GET', '*', '', ''),
(6896, 'p', 'role_2', '/api/users/*', 'GET', '*', '', ''),
(6863, 'p', 'role_2', '/api/users/add', 'POST', '*', '', ''),
(6901, 'p', 'role_2', '/api/users/delete', 'DELETE', '*', '', ''),
(6888, 'p', 'role_2', '/api/users/edit', 'PUT', '*', '', ''),
(6908, 'p', 'role_2', '/api/users/list', 'GET', '*', '', ''),
(6873, 'p', 'role_2', '/api/users/logout', 'POST', '*', '', ''),
(6910, 'p', 'role_2', '/api/users/profile', 'GET', '*', '', ''),
(6855, 'p', 'role_2', '/api/users/updateAccount', 'PUT', '*', '', ''),
(6934, 'p', 'role_2', '/api/users/updateBasicInfo', 'PUT', '*', '', ''),
(6874, 'p', 'role_2', '/api/users/uploadAvatar', 'POST', '*', '', ''),
(2966, 'p', 'role_4', '/api/sysAffix/list', 'GET', '*', '', ''),
(2971, 'p', 'role_4', '/api/sysDict/getAllDicts', 'GET', '*', '', ''),
(2970, 'p', 'role_4', '/api/sysMenu/getRouters', 'GET', '*', '', ''),
(2969, 'p', 'role_4', '/api/users/*', 'GET', '*', '', ''),
(2967, 'p', 'role_4', '/api/users/logout', 'POST', '*', '', ''),
(2968, 'p', 'role_4', '/api/users/profile', 'GET', '*', '', ''),
(2965, 'p', 'role_4', '/api/users/uploadAvatar', 'POST', '*', '', '');

-- 设置序列起始值
SELECT setval('sys_casbin_rule_id_seq', 7025, false);

-- 创建唯一索引
CREATE UNIQUE INDEX idx_casbin_rule ON sys_casbin_rule (ptype, v0, v1, v2, v3, v4, v5);
CREATE UNIQUE INDEX idx_sys_casbin_rule ON sys_casbin_rule (ptype, v0, v1, v2, v3, v4, v5);

-- 表: sys_department
DROP TABLE IF EXISTS sys_department;
CREATE TABLE sys_department (
    id SERIAL PRIMARY KEY,
    parent_id INTEGER DEFAULT 0,
    name VARCHAR(255),
    status SMALLINT,
    leader VARCHAR(255),
    phone VARCHAR(255),
    email VARCHAR(255),
    sort INTEGER DEFAULT 0,
    describe VARCHAR(255),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    created_by INTEGER,
    tenant_id INTEGER DEFAULT 0
);

COMMENT ON TABLE sys_department IS '部门表';
COMMENT ON COLUMN sys_department.parent_id IS '父级';
COMMENT ON COLUMN sys_department.name IS '部门名称';
COMMENT ON COLUMN sys_department.status IS '状态： 0 停用 1 启用';
COMMENT ON COLUMN sys_department.leader IS '负责人';
COMMENT ON COLUMN sys_department.phone IS '联系电话';
COMMENT ON COLUMN sys_department.email IS '邮箱';
COMMENT ON COLUMN sys_department.sort IS '排序';
COMMENT ON COLUMN sys_department.describe IS '描述';
COMMENT ON COLUMN sys_department.created_at IS '创建时间';
COMMENT ON COLUMN sys_department.updated_at IS '更新时间';
COMMENT ON COLUMN sys_department.deleted_at IS '删除时间';
COMMENT ON COLUMN sys_department.created_by IS '创建人';
COMMENT ON COLUMN sys_department.tenant_id IS '租户ID字段';

INSERT INTO sys_department (id, parent_id, name, status, leader, phone, email, sort, describe, created_at, updated_at, deleted_at, created_by, tenant_id) VALUES
(1, 0, '总部', 1, '张明', '13800000001', 'headquarters@company.com', 1, '公司总部管理部门', '2023-01-15 09:00:00', '2025-10-31 17:05:24', NULL, 1, 0);

SELECT setval('sys_department_id_seq', 2, false);

-- 表: sys_dict
DROP TABLE IF EXISTS sys_dict;
CREATE TABLE sys_dict (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    code VARCHAR(255),
    status SMALLINT,
    description VARCHAR(500),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    created_by INTEGER
);

COMMENT ON TABLE sys_dict IS '字典表';
COMMENT ON COLUMN sys_dict.id IS 'ID';
COMMENT ON COLUMN sys_dict.name IS '字典名称';
COMMENT ON COLUMN sys_dict.code IS '字典编码';
COMMENT ON COLUMN sys_dict.status IS '状态';
COMMENT ON COLUMN sys_dict.description IS '描述';
COMMENT ON COLUMN sys_dict.created_at IS '创建时间';
COMMENT ON COLUMN sys_dict.updated_at IS '更新时间';
COMMENT ON COLUMN sys_dict.deleted_at IS '删除时间';
COMMENT ON COLUMN sys_dict.created_by IS '创建人';

INSERT INTO sys_dict (id, name, code, status, description, created_at, updated_at, deleted_at, created_by) VALUES
(1, '性别', 'gender', 1, '这是一个性别字典', '2024-07-01 10:00:00', NULL, NULL, 1),
(2, '状态', 'status', 1, '状态字段可以用这个', '2024-07-01 10:00:00', NULL, NULL, 1),
(3, '岗位', 'post', 1, '岗位字段', '2024-07-01 10:00:00', NULL, NULL, 1),
(4, '任务状态', 'taskStatus', 1, '任务状态字段可以用它', '2024-07-01 10:00:00', NULL, NULL, 1);

SELECT setval('sys_dict_id_seq', 5, false);

-- 表: sys_dict_item
DROP TABLE IF EXISTS sys_dict_item;
CREATE TABLE sys_dict_item (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    value VARCHAR(255),
    status SMALLINT,
    dict_id INTEGER
);

COMMENT ON TABLE sys_dict_item IS '字典项表';
COMMENT ON COLUMN sys_dict_item.id IS 'ID';
COMMENT ON COLUMN sys_dict_item.name IS '名称';
COMMENT ON COLUMN sys_dict_item.value IS '值';
COMMENT ON COLUMN sys_dict_item.status IS '状态';
COMMENT ON COLUMN sys_dict_item.dict_id IS '字典ID';

INSERT INTO sys_dict_item (id, name, value, status, dict_id) VALUES
(11, '男', '1', 1, 1),
(12, '女', '0', 1, 1),
(13, '其它', '2', 1, 1),
(21, '禁用', '0', 1, 2),
(22, '启用', '1', 1, 2),
(31, '总经理', '1', 1, 3),
(32, '总监', '2', 1, 3),
(33, '人事主管', '3', 1, 3),
(34, '开发部主管', '4', 1, 3),
(35, '普通职员', '5', 1, 3),
(36, '其它', '999', 1, 3),
(41, '失败', '0', 1, 4),
(42, '成功', '1', 1, 4);

SELECT setval('sys_dict_item_id_seq', 43, false);

-- 表: sys_gen
DROP TABLE IF EXISTS sys_gen;
CREATE TABLE sys_gen (
    id SERIAL PRIMARY KEY,
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
    is_cover SMALLINT DEFAULT 0,
    is_menu SMALLINT DEFAULT 0
);

COMMENT ON TABLE sys_gen IS '代码生成配置表';
COMMENT ON COLUMN sys_gen.id IS 'ID';
COMMENT ON COLUMN sys_gen.db_type IS '数据库类型';
COMMENT ON COLUMN sys_gen.database IS '数据库';
COMMENT ON COLUMN sys_gen.name IS '数据库表名';
COMMENT ON COLUMN sys_gen.module_name IS '模块名称';
COMMENT ON COLUMN sys_gen.file_name IS '文件名称';
COMMENT ON COLUMN sys_gen.describe IS '描述';
COMMENT ON COLUMN sys_gen.created_at IS '创建时间';
COMMENT ON COLUMN sys_gen.updated_at IS '修改时间';
COMMENT ON COLUMN sys_gen.deleted_at IS '删除时间';
COMMENT ON COLUMN sys_gen.created_by IS '创建人';
COMMENT ON COLUMN sys_gen.is_cover IS '是否覆盖';
COMMENT ON COLUMN sys_gen.is_menu IS '是否生成菜单';

INSERT INTO sys_gen (id, db_type, database, name, module_name, file_name, describe, created_at, updated_at, deleted_at, created_by, is_cover, is_menu) VALUES
(23, 'mysql', 'gin-fast-tenant', 'demo_students', 'test_school', 'demo_students', '学员管理', '2025-11-13 15:17:27', '2025-11-17 16:31:43', NULL, 1, 1, 1),
(24, 'mysql', 'gin-fast-tenant', 'demo_teacher', 'test_school', 'demo_teacher', '教师表', '2025-11-13 15:17:27', '2025-11-17 17:29:28', NULL, 1, 1, 1);

SELECT setval('sys_gen_id_seq', 25, false);

-- 表: sys_gen_field
DROP TABLE IF EXISTS sys_gen_field;
CREATE TABLE sys_gen_field (
    id SERIAL PRIMARY KEY,
    gen_id INTEGER,
    data_name VARCHAR(255),
    data_type VARCHAR(255),
    data_comment VARCHAR(255),
    data_extra VARCHAR(255),
    data_column_key VARCHAR(255),
    data_unsigned SMALLINT DEFAULT 0,
    is_primary SMALLINT DEFAULT 0,
    go_type VARCHAR(255),
    front_type VARCHAR(255),
    custom_name VARCHAR(255) DEFAULT '',
    require SMALLINT DEFAULT 0,
    list_show SMALLINT DEFAULT 0,
    form_show SMALLINT DEFAULT 0,
    query_show SMALLINT DEFAULT 0,
    query_type VARCHAR(255),
    form_type VARCHAR(255),
    dict_type VARCHAR(255),
    gorm_tag VARCHAR(255)
);

COMMENT ON TABLE sys_gen_field IS '代码生成字段配置表';
COMMENT ON COLUMN sys_gen_field.id IS 'ID';
COMMENT ON COLUMN sys_gen_field.gen_id IS '生成配置ID';
COMMENT ON COLUMN sys_gen_field.data_name IS '列名';
COMMENT ON COLUMN sys_gen_field.data_type IS '数据类型';
COMMENT ON COLUMN sys_gen_field.data_comment IS '列注释';
COMMENT ON COLUMN sys_gen_field.data_extra IS '额外信息';
COMMENT ON COLUMN sys_gen_field.data_column_key IS '列键信息';
COMMENT ON COLUMN sys_gen_field.data_unsigned IS '是否为无符号类型';
COMMENT ON COLUMN sys_gen_field.is_primary IS '是否主键';
COMMENT ON COLUMN sys_gen_field.go_type IS 'go类型';
COMMENT ON COLUMN sys_gen_field.front_type IS '前端类型';
COMMENT ON COLUMN sys_gen_field.custom_name IS '自定义字段名称';
COMMENT ON COLUMN sys_gen_field.require IS '是否必填';
COMMENT ON COLUMN sys_gen_field.list_show IS '列表显示';
COMMENT ON COLUMN sys_gen_field.form_show IS '表单显示';
COMMENT ON COLUMN sys_gen_field.query_show IS '查询显示';
COMMENT ON COLUMN sys_gen_field.query_type IS '查询方式';
COMMENT ON COLUMN sys_gen_field.form_type IS '表单类型';
COMMENT ON COLUMN sys_gen_field.dict_type IS '关联的字典';
COMMENT ON COLUMN sys_gen_field.gorm_tag IS 'gorm标签';

INSERT INTO sys_gen_field (id, gen_id, data_name, data_type, data_comment, data_extra, data_column_key, data_unsigned, is_primary, go_type, front_type, custom_name, require, list_show, form_show, query_show, query_type, form_type, dict_type, gorm_tag) VALUES
(185, 23, 'student_id', 'int', 'ID', 'auto_increment', 'PRI', 1, 1, 'uint', 'number', 'stu_id', 1, 0, 0, 1, 'EQ', '', '', 'column:student_id;primaryKey;not null;autoIncrement'),
(186, 23, 'student_name', 'varchar', '姓名', '', '', 0, 0, 'string', 'string', 'stu_name', 1, 1, 1, 1, 'LIKE', 'textarea', '', 'column:student_name;not null'),
(187, 23, 'age', 'int', '年龄', '', '', 0, 0, 'int', 'number', 'age', 1, 1, 1, 1, 'LIKE', '', '', 'column:age;not null;default:18'),
(188, 23, 'gender', 'varchar', '性别', '', '', 0, 0, 'string', 'string', 'gender', 1, 1, 1, 1, 'BETWEEN', 'radio', 'gender', 'column:gender;not null;default:'''''),
(189, 23, 'class_name', 'varchar', '班级名称', '', '', 0, 0, 'string', 'string', 'class_name', 0, 1, 1, 0, '', 'checkbox', 'class', 'column:class_name;not null'),
(190, 23, 'admission_date', 'datetime', '入学日期', '', '', 0, 0, 'time.Time', 'string', 'admission_date', 0, 0, 1, 0, '', '', '', 'column:admission_date;not null'),
(191, 23, 'email', 'varchar', '邮箱', '', 'UNI', 0, 0, 'string', 'string', 'email', 0, 0, 1, 1, '', 'checkbox', 'status', 'column:email;uniqueIndex'),
(192, 23, 'phone', 'varchar', '电话号码', '', '', 0, 0, 'string', 'string', 'phone', 0, 0, 0, 0, '', '', '', 'column:phone'),
(193, 23, 'address', 'text', '地址', '', '', 0, 0, 'string', 'string', 'address', 0, 0, 1, 1, '', 'select', 'status', 'column:address'),
(194, 23, 'created_at', 'datetime', '创建时间', '', '', 0, 0, 'time.Time', 'string', 'created_at', NULL, NULL, 1, 1, 'BETWEEN', '', '', 'column:created_at'),
(195, 23, 'updated_at', 'datetime', '更新时间', '', '', 0, 0, 'time.Time', 'string', 'updated_at', NULL, NULL, 1, NULL, '', '', '', 'column:updated_at'),
(196, 23, 'deleted_at', 'datetime', '删除时间', '', '', 0, 0, 'time.Time', 'string', 'deleted_at', NULL, NULL, 1, NULL, '', '', '', 'column:deleted_at'),
(197, 23, 'created_by', 'int', '创建人', '', '', 1, 0, 'uint', 'number', 'created_by', NULL, NULL, 1, NULL, '', '', '', 'column:created_by'),
(198, 23, 'tenant_id', 'int', '租户ID字段', '', '', 1, 0, 'uint', 'number', 'tenant_id', NULL, NULL, 1, 1, '', '', '', 'column:tenant_id'),
(199, 24, 'id', 'int', '主键ID', 'auto_increment', 'PRI', 1, 1, 'uint', 'number', 'tc_id', 1, 1, 1, 1, '', '', '', 'column:id;primaryKey;not null;autoIncrement'),
(200, 24, 'name', 'varchar', '教师姓名', '', '', 0, 0, 'string', 'string', 'tc_name', 1, 1, 1, 1, 'LIKE', 'input', '', 'column:name;not null'),
(201, 24, 'employee_id', 'varchar', '工号', '', '', 0, 0, 'string', 'string', 'employee_id', 1, 1, 1, 1, 'BETWEEN', '', '', 'column:employee_id'),
(202, 24, 'gender', 'tinyint', '性别', '', '', 0, 0, 'int', 'number', 'gender', 1, 1, 1, 1, 'EQ', 'select', 'gender', 'column:gender;default:0'),
(203, 24, 'phone', 'varchar', '手机号', '', '', 0, 0, 'string', 'string', 'phone', 1, 1, 1, 1, 'GT', '', '', 'column:phone'),
(204, 24, 'email', 'varchar', '邮箱', '', '', 0, 0, 'string', 'string', 'email', 1, 1, 1, 1, 'NE', '', '', 'column:email'),
(205, 24, 'subject', 'varchar', '所教学科', '', '', 0, 0, 'string', 'string', 'subject', 1, 1, 1, 1, '', '', '', 'column:subject'),
(206, 24, 'title', 'varchar', '职称', '', '', 0, 0, 'string', 'string', 'title', 1, 1, 1, 1, '', '', '', 'column:title'),
(207, 24, 'status', 'tinyint', '状态', '', '', 0, 0, 'int', 'number', 'status', 1, 1, 1, 1, '', 'select', 'status', 'column:status;default:1'),
(208, 24, 'hire_date', 'date', '入职日期', '', '', 0, 0, 'time.Time', 'string', 'hire_date', 1, 1, 1, 1, 'BETWEEN', '', '', 'column:hire_date'),
(209, 24, 'birth_date', 'date', '出生日期', '', '', 0, 0, 'time.Time', 'string', 'birth_date', 1, 1, 1, 1, '', 'select', 'test_date', 'column:birth_date'),
(210, 24, 'created_at', 'datetime', '创建时间', '', '', 0, 0, 'time.Time', 'string', 'created_at', NULL, NULL, NULL, NULL, '', '', '', 'column:created_at'),
(211, 24, 'updated_at', 'datetime', '更新时间', '', '', 0, 0, 'time.Time', 'string', 'updated_at', NULL, NULL, NULL, NULL, '', '', '', 'column:updated_at'),
(212, 24, 'deleted_at', 'datetime', '删除时间', '', '', 0, 0, 'time.Time', 'string', 'deleted_at', NULL, NULL, NULL, NULL, '', '', '', 'column:deleted_at'),
(213, 24, 'created_by', 'int', '创建人', '', '', 1, 0, 'uint', 'number', 'created_by', NULL, NULL, NULL, NULL, '', '', '', 'column:created_by');

SELECT setval('sys_gen_field_id_seq', 214, false);

-- 表: sys_menu
DROP TABLE IF EXISTS sys_menu;
CREATE TABLE sys_menu (
    id SERIAL PRIMARY KEY,
    parent_id INTEGER NOT NULL DEFAULT 0,
    path VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    redirect VARCHAR(255),
    component VARCHAR(255),
    title VARCHAR(100),
    is_full SMALLINT DEFAULT 0,
    hide SMALLINT DEFAULT 0,
    disable SMALLINT DEFAULT 0,
    keep_alive SMALLINT DEFAULT 0,
    affix SMALLINT DEFAULT 0,
    link VARCHAR(500) DEFAULT '',
    iframe SMALLINT DEFAULT 0,
    svg_icon VARCHAR(100) DEFAULT '',
    icon VARCHAR(100) DEFAULT '',
    sort INTEGER DEFAULT 0,
    type SMALLINT DEFAULT 2,
    is_link SMALLINT DEFAULT 0,
    permission VARCHAR(255) DEFAULT '',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    created_by INTEGER
);

COMMENT ON TABLE sys_menu IS '系统菜单路由表';
COMMENT ON COLUMN sys_menu.id IS '路由ID';
COMMENT ON COLUMN sys_menu.parent_id IS '父级路由ID，顶层为0';
COMMENT ON COLUMN sys_menu.path IS '路由路径';
COMMENT ON COLUMN sys_menu.name IS '路由名称';
COMMENT ON COLUMN sys_menu.redirect IS '重定向';
COMMENT ON COLUMN sys_menu.component IS '组件文件路径';
COMMENT ON COLUMN sys_menu.title IS '菜单标题，国际化key';
COMMENT ON COLUMN sys_menu.is_full IS '是否全屏显示：0-否，1-是';
COMMENT ON COLUMN sys_menu.hide IS '是否隐藏：0-否，1-是';
COMMENT ON COLUMN sys_menu.disable IS '是否停用：0-否，1-是';
COMMENT ON COLUMN sys_menu.keep_alive IS '是否缓存：0-否，1-是';
COMMENT ON COLUMN sys_menu.affix IS '是否固定：0-否，1-是';
COMMENT ON COLUMN sys_menu.link IS '外链地址';
COMMENT ON COLUMN sys_menu.iframe IS '是否内嵌：0-否，1-是';
COMMENT ON COLUMN sys_menu.svg_icon IS 'svg图标名称';
COMMENT ON COLUMN sys_menu.icon IS '普通图标名称';
COMMENT ON COLUMN sys_menu.sort IS '排序字段';
COMMENT ON COLUMN sys_menu.type IS '类型：1-目录，2-菜单，3-按钮';
COMMENT ON COLUMN sys_menu.is_link IS '是否外链';
COMMENT ON COLUMN sys_menu.permission IS '权限标识';
COMMENT ON COLUMN sys_menu.created_at IS '创建时间';
COMMENT ON COLUMN sys_menu.updated_at IS '更新时间';
COMMENT ON COLUMN sys_menu.deleted_at IS '删除时间';
COMMENT ON COLUMN sys_menu.created_by IS '创建人';

CREATE INDEX idx_parent_id ON sys_menu (parent_id);
CREATE INDEX idx_sort ON sys_menu (sort);
CREATE INDEX idx_type ON sys_menu (type);

INSERT INTO sys_menu (id, parent_id, path, name, redirect, component, title, is_full, hide, disable, keep_alive, affix, link, iframe, svg_icon, icon, sort, type, is_link, permission, created_at, updated_at, deleted_at, created_by) VALUES
(1, 0, '/home', 'home', NULL, 'home/home', 'home', 0, 0, 0, 0, 1, '', 0, 'home', '', 0, 2, 0, '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', NULL, 1),
(10, 0, '/system', 'system', NULL, NULL, 'system', 0, 0, 0, 1, 0, '', 0, 'set', '', 0, 1, 0, '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', NULL, 1),
(1001, 10, '/system/account', 'account', '', 'system/account/account', 'account', 0, 0, 0, 1, 0, '', 0, '', 'IconUser', 0, 2, 0, '', '2025-08-27 09:09:44', '2025-10-11 15:37:41', NULL, 1),
(1002, 10, '/system/role', 'role', '', 'system/role/role', 'role', 0, 0, 0, 1, 0, '', 0, '', 'IconUserGroup', 0, 2, 0, '', '2025-08-27 09:09:44', '2025-10-11 16:16:08', NULL, 1),
(1003, 10, '/system/menu', 'menu', NULL, 'system/menu/menu', 'menu', 0, 0, 0, 1, 0, '', 0, '', 'icon-menu', 0, 2, 0, '', '2025-08-27 09:09:44', '2025-08-27 09:09:44', NULL, 1),
(1004, 10, '/system/division', 'division', '', 'system/division/division', 'division', 0, 0, 0, 1, 0, '', 0, '', 'IconMindMapping', 0, 2, 0, '', '2025-08-27 09:09:44', '2025-10-11 16:23:14', NULL, 1),
(1005, 10, '/system/dictionary', 'dictionary', '', 'system/dictionary/dictionary', 'dictionary', 0, 0, 0, 1, 0, '', 0, '', 'IconBook', 0, 2, 0, '', '2025-08-27 09:09:44', '2025-10-11 16:23:47', NULL, 1),
(1006, 10, '/system/log', 'log', '', 'system/log/log', 'log', 0, 0, 0, 1, 0, '', 0, '', 'IconCommon', 0, 2, 0, '', '2025-08-27 09:09:44', '2025-10-20 17:14:19', NULL, 1),
(1007, 10, '/system/userinfo', 'userinfo', '', 'system/userinfo/userinfo', 'userinfo', 0, 1, 0, 1, 0, '', 0, '', 'icon-menu', 0, 2, 0, '', '2025-08-27 09:09:44', '2025-09-17 11:19:11', NULL, 1),
(140213, 10, '/system/api', 'SystemApi', '', 'system/sysapi/sysapi', 'api-management', 0, 0, 0, 1, 0, '', 0, '', 'IconFile', 0, 2, 0, '', '2025-09-03 10:53:57', '2025-10-16 08:53:42', NULL, 1),
(140214, 1001, '', '', '', '', '新增', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:account:add', '2025-09-03 16:11:58', '2025-09-03 16:11:58', NULL, 1),
(140215, 1001, '', '', '', '', '编辑', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:account:edit', '2025-09-03 17:11:24', '2025-09-03 17:11:24', NULL, 1),
(140216, 1001, '', '', '', '', '删除', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:account:delete', '2025-09-03 17:12:22', '2025-09-03 17:12:22', NULL, 1),
(140218, 1002, '', '', '', '', '新增', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:role:add', '2025-09-04 16:43:54', '2025-09-04 16:43:54', NULL, 1),
(140219, 1002, '', '', '', '', '编辑', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:role:edit', '2025-09-04 16:47:15', '2025-09-04 16:47:15', NULL, 1),
(140220, 1002, '', '', '', '', '删除', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:role:delete', '2025-09-04 16:50:19', '2025-09-04 16:50:19', NULL, 1),
(140221, 1002, '', '', '', '', '分配权限', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:role:addRoleMenu', '2025-09-04 16:53:09', '2025-09-04 16:53:09', NULL, 1),
(140222, 1003, '', '', '', '', '新增', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:menu:add', '2025-09-04 17:07:16', '2025-09-04 17:07:16', NULL, 1),
(140223, 1003, '', '', '', '', '编辑', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:menu:edit', '2025-09-04 17:11:51', '2025-09-04 17:11:51', NULL, 1),
(140224, 1003, '', '', '', '', '删除', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:menu:delete', '2025-09-04 17:12:24', '2025-09-04 17:12:24', NULL, 1),
(140225, 1003, '', '', '', '', '分配权限', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:menu:setMenuApis', '2025-09-04 17:20:09', '2025-09-04 17:20:09', NULL, 1),
(140226, 140213, '', '', '', '', '新增', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:api:add', '2025-09-04 17:30:56', '2025-09-04 17:30:56', NULL, 1),
(140227, 140213, '', '', '', '', '编辑', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:api:edit', '2025-09-04 17:31:20', '2025-09-04 17:31:20', NULL, 1),
(140228, 140213, '', '', '', '', '删除', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:api:delete', '2025-09-04 17:31:38', '2025-09-04 17:31:38', NULL, 1),
(140229, 1004, '', '', '', '', '新增部门', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:division:add', '2025-09-12 14:50:55', '2025-09-12 14:50:55', NULL, 1),
(140230, 1004, '', '', '', '', '编辑部门', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:division:edit', '2025-09-12 14:51:17', '2025-09-12 14:51:17', NULL, 1),
(140231, 1004, '', '', '', '', '删除部门', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:division:delete', '2025-09-12 14:51:51', '2025-09-12 14:51:51', NULL, 1),
(140232, 1005, '', '', '', '', '新增', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:dict:add', '2025-09-16 16:38:06', '2025-09-16 16:38:06', NULL, 1),
(140233, 1005, '', '', '', '', '编辑', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:dict:edit', '2025-09-16 16:39:58', '2025-09-16 16:39:58', NULL, 1),
(140234, 1005, '', '', '', '', '删除', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:dict:delete', '2025-09-16 16:40:19', '2025-09-16 16:40:19', NULL, 1),
(140235, 1005, '', '', '', '', '字典项管理', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:dictitem:list', '2025-09-16 17:09:58', '2025-09-16 17:31:35', NULL, 1),
(140236, 1005, '', '', '', '', '新增字典项', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:dictitem:add', '2025-09-16 17:32:06', '2025-09-16 17:32:06', NULL, 1),
(140237, 1005, '', '', '', '', '编辑字典项', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:dictitem:edit', '2025-09-16 17:33:16', '2025-09-16 17:33:16', NULL, 1),
(140238, 1005, '', '', '', '', '删除字典项', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:dictitem:delete', '2025-09-16 17:33:41', '2025-09-16 17:33:41', NULL, 1),
(140239, 10, '/system/affix', 'SystemAffix', '', 'system/affix/affix', 'file-manager', 0, 0, 0, 1, 0, '', 0, '', 'IconFolder', 0, 2, 0, '', '2025-09-25 15:17:00', '2025-10-15 18:14:16', NULL, 1),
(140240, 140239, '', '', '', '', '文件上传', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:affix:upload', '2025-09-25 15:45:29', '2025-09-25 15:46:29', NULL, 1),
(140241, 140239, '', '', '', '', '删除文件', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:affix:delete', '2025-09-25 15:46:52', '2025-09-25 15:46:52', NULL, 1),
(140242, 140239, '', '', '', '', '修改文件名', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:affix:updateName', '2025-09-25 15:47:41', '2025-09-25 15:47:41', NULL, 1),
(140243, 140239, '', '', '', '', '下载文件', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:affix:download', '2025-09-25 15:48:56', '2025-09-25 15:48:56', NULL, 1),
(140244, 1002, '', '', '', '', '数据权限', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:role:dataScope', '2025-09-26 17:07:16', '2025-09-26 17:07:16', NULL, 1),
(140245, 10, '/system/sysconfig', 'SystemSysconfig', '', 'system/sysconfig/sysconfig', 'system-config', 0, 0, 0, 1, 0, '', 0, '', 'IconSettings', 0, 2, 0, '', '2025-10-09 16:15:21', '2025-10-15 18:10:54', NULL, 1),
(140246, 140245, '', '', '', '', '修改系统配置', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:config:update', '2025-10-09 16:24:33', '2025-10-09 16:24:33', NULL, 1),
(140247, 0, '/demo', 'Demo', '', '', 'plugin-example', 0, 0, 0, 1, 0, '', 0, 'more', '', 0, 1, 0, '', '2025-10-13 14:38:38', '2025-10-16 08:55:06', NULL, 1),
(140248, 140247, '/plugins/example', 'PluginsExample', '', 'plugins/example/views/examplelist', 'plugin-example', 0, 0, 0, 1, 0, '', 0, '', 'IconMenu', 0, 2, 0, '', '2025-10-13 15:19:20', '2025-10-16 08:55:19', NULL, 1),
(140249, 140248, '', '', '', '', '新增', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'plugins:example:add', '2025-10-14 11:02:42', '2025-10-14 11:02:42', NULL, 1),
(140250, 140248, '', '', '', '', '编辑', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'plugins:example:edit', '2025-10-14 11:03:08', '2025-10-14 11:03:08', NULL, 1),
(140251, 140248, '', '', '', '', '删除', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'plugins:example:delete', '2025-10-14 11:03:25', '2025-10-14 11:03:25', NULL, 1),
(140252, 1007, '', '', '', '', '修改密码、手机号等', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:userinfo:updateAccount', '2025-10-17 11:12:56', '2025-10-17 11:12:56', NULL, 1),
(140254, 140239, '', '', '', '', '复制链接', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:affix:copy', '2025-10-17 11:38:09', '2025-10-17 11:38:09', NULL, 1),
(140255, 1006, '', '', '', '', '导出', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:log:export', '2025-10-20 10:16:51', '2025-10-20 10:16:51', NULL, 1),
(140256, 1006, '', '', '', '', '删除', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:log:delete', '2025-10-20 10:17:19', '2025-10-20 10:17:19', NULL, 1),
(140257, 1003, '', '', '', '', '导出', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:menu:export', '2025-10-20 17:18:01', '2025-10-20 17:18:13', NULL, 1),
(140258, 1003, '', '', '', '', '导入', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:menu:import', '2025-10-21 11:29:45', '2025-10-21 11:29:45', NULL, 1),
(140259, 10, '/system/systenant', 'SystemSystenant', '', 'system/tenant/tenant', 'tenant', 0, 0, 0, 1, 0, '', 0, '', 'IconTags', 0, 2, 0, '', '2025-10-24 09:11:32', '2025-10-24 09:20:59', NULL, 1),
(140260, 140259, '', '', '', '', '新增租户', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:tenant:add', '2025-10-24 09:14:25', '2025-10-24 09:14:25', NULL, 1),
(140261, 140259, '', '', '', '', '修改租户', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:tenant:edit', '2025-10-24 09:14:50', '2025-10-24 09:14:50', NULL, 1),
(140262, 140259, '', '', '', '', '删除租户', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:tenant:delete', '2025-10-24 09:15:07', '2025-10-24 09:15:07', NULL, 1),
(140263, 140259, '', '', '', '', '分配用户', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:tenant:assignUser', '2025-10-27 18:03:07', '2025-10-27 18:03:07', NULL, 1),
(140264, 1007, '', '', '', '', '修改用户基本信息', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:userinfo:updateBasicInfo', '2025-10-31 09:26:42', '2025-10-31 09:26:42', NULL, 1),
(140265, 10, '/system/codegen', 'SystemCodegen', '', 'system/codegen/codegen', 'codegen', 0, 0, 0, 1, 0, '', 0, '', 'IconCode', 0, 2, 0, '', '2025-11-04 11:45:49', '2025-11-04 11:45:49', NULL, 1),
(140329, 140265, '', '', '', '', '导入表', 0, 0, 0, 1, 0, '', 0, '', '', 1, 3, 0, 'system:codegen:batchInsert', '2025-11-17 15:32:25', '2025-11-17 15:32:25', NULL, 1),
(140330, 140265, '', '', '', '', '配置', 0, 0, 0, 1, 0, '', 0, '', '', 1, 3, 0, 'system:codegen:update', '2025-11-17 15:33:57', '2025-11-17 15:33:57', NULL, 1),
(140331, 140265, '', '', '', '', '预览', 0, 0, 0, 1, 0, '', 0, '', '', 1, 3, 0, 'system:codegen:preview', '2025-11-17 15:34:24', '2025-11-17 15:34:24', NULL, 1),
(140332, 140265, '', '', '', '', '生成代码文件', 0, 0, 0, 1, 0, '', 0, '', '', 1, 3, 0, 'system:codegen:generate', '2025-11-17 15:35:00', '2025-11-17 15:35:00', NULL, 1),
(140333, 140265, '', '', '', '', '同步数据库', 0, 0, 0, 1, 0, '', 0, '', '', 1, 3, 0, 'system:codegen:refreshFields', '2025-11-17 15:35:51', '2025-11-17 15:35:51', NULL, 1),
(140334, 140265, '', '', '', '', '删除', 0, 0, 0, 1, 0, '', 0, '', '', 1, 3, 0, 'system:codegen:delete', '2025-11-17 15:36:50', '2025-11-17 15:36:50', NULL, 1),
(140335, 140265, '', '', '', '', '生成菜单', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:codegen:insertmenuandapi', '2025-11-26 15:16:32', '2025-11-26 15:16:32', NULL, 1),
(140336, 10, '/system/pluginsmanager', 'SystemPluginsmanager', '', 'system/pluginsmanager/pluginsmanager', 'plugins-manager', 0, 0, 0, 1, 0, '', 0, '', 'IconApps', 0, 2, 0, '', '2025-12-05 17:59:34', '2025-12-05 17:59:34', NULL, 1),
(140338, 140336, '', '', '', '', '导出插件', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:pluginsmanager:export', '2025-12-08 16:33:32', '2025-12-08 16:33:32', NULL, 1),
(140339, 140336, '', '', '', '', '导入插件', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:pluginsmanager:import', '2025-12-08 16:33:51', '2025-12-08 16:33:51', NULL, 1),
(140340, 140336, '', '', '', '', '插件卸载', 0, 0, 0, 1, 0, '', 0, '', '', 0, 3, 0, 'system:pluginsmanager:uninstall', '2025-12-08 16:34:53', '2025-12-08 16:34:53', NULL, 1);

SELECT setval('sys_menu_id_seq', 140341, false);

-- 表: sys_menu_api
DROP TABLE IF EXISTS sys_menu_api;
CREATE TABLE sys_menu_api (
    menu_id INTEGER NOT NULL,
    api_id INTEGER NOT NULL,
    PRIMARY KEY (menu_id, api_id)
);

INSERT INTO sys_menu_api (menu_id, api_id) VALUES
(10, 5),
(10, 6),
(10, 7),
(10, 12),
(10, 27),
(10, 54),
(1001, 8),
(1001, 18),
(1001, 19),
(1002, 19),
(1003, 13),
(1004, 18),
(1005, 41),
(1006, 70),
(1007, 6),
(140213, 29),
(140214, 9),
(140215, 10),
(140216, 11),
(140218, 24),
(140219, 25),
(140220, 26),
(140221, 13),
(140221, 20),
(140221, 21),
(140222, 15),
(140223, 16),
(140224, 17),
(140224, 197),
(140225, 29),
(140225, 35),
(140225, 36),
(140226, 31),
(140227, 30),
(140227, 32),
(140228, 33),
(140229, 38),
(140230, 39),
(140231, 40),
(140232, 43),
(140233, 44),
(140234, 45),
(140235, 48),
(140236, 50),
(140237, 51),
(140238, 52),
(140239, 58),
(140240, 55),
(140241, 56),
(140242, 57),
(140243, 60),
(140244, 61),
(140245, 62),
(140245, 64),
(140246, 63),
(140248, 65),
(140248, 69),
(140249, 66),
(140250, 67),
(140251, 68),
(140252, 53),
(140254, 60),
(140255, 73),
(140256, 72),
(140257, 74),
(140258, 75),
(140259, 76),
(140260, 78),
(140261, 77),
(140261, 79),
(140262, 80),
(140263, 81),
(140263, 82),
(140263, 83),
(140263, 84),
(140263, 85),
(140263, 86),
(140263, 87),
(140263, 88),
(140264, 89),
(140265, 190),
(140329, 188),
(140329, 191),
(140330, 192),
(140330, 193),
(140331, 189),
(140332, 105),
(140333, 195),
(140334, 194),
(140335, 196),
(140336, 198),
(140338, 199),
(140339, 200),
(140340, 201);

-- 表: sys_operation_logs
DROP TABLE IF EXISTS sys_operation_logs;
CREATE TABLE sys_operation_logs (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMP(3),
    updated_at TIMESTAMP(3),
    deleted_at TIMESTAMP(3),
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
    tenant_id INTEGER DEFAULT 0
);

COMMENT ON TABLE sys_operation_logs IS '系统操作日志表';
COMMENT ON COLUMN sys_operation_logs.id IS 'ID';
COMMENT ON COLUMN sys_operation_logs.created_at IS '创建时间';
COMMENT ON COLUMN sys_operation_logs.updated_at IS '更新时间';
COMMENT ON COLUMN sys_operation_logs.deleted_at IS '删除时间';
COMMENT ON COLUMN sys_operation_logs.user_id IS '操作用户ID';
COMMENT ON COLUMN sys_operation_logs.username IS '操作用户名';
COMMENT ON COLUMN sys_operation_logs.module IS '操作模块';
COMMENT ON COLUMN sys_operation_logs.operation IS '操作类型';
COMMENT ON COLUMN sys_operation_logs.method IS '请求方法';
COMMENT ON COLUMN sys_operation_logs.path IS '请求路径';
COMMENT ON COLUMN sys_operation_logs.ip IS '客户端IP';
COMMENT ON COLUMN sys_operation_logs.user_agent IS '用户代理';
COMMENT ON COLUMN sys_operation_logs.request_data IS '请求参数';
COMMENT ON COLUMN sys_operation_logs.response_data IS '响应数据';
COMMENT ON COLUMN sys_operation_logs.status_code IS '响应状态码';
COMMENT ON COLUMN sys_operation_logs.duration IS '操作耗时(毫秒)';
COMMENT ON COLUMN sys_operation_logs.error_msg IS '错误信息';
COMMENT ON COLUMN sys_operation_logs.location IS '操作地点';
COMMENT ON COLUMN sys_operation_logs.tenant_id IS '租户ID字段';

CREATE INDEX idx_sys_operation_logs_deleted_at ON sys_operation_logs (deleted_at);
CREATE INDEX idx_user_id ON sys_operation_logs (user_id);

-- 表: sys_role
DROP TABLE IF EXISTS sys_role;
CREATE TABLE sys_role (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) DEFAULT '',
    sort INTEGER DEFAULT 0,
    status SMALLINT DEFAULT 0,
    description VARCHAR(255),
    parent_id INTEGER DEFAULT 0,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    created_by INTEGER,
    data_scope INTEGER DEFAULT 0,
    checked_depts VARCHAR(1000),
    tenant_id INTEGER DEFAULT 0
);

COMMENT ON TABLE sys_role IS '角色表';
COMMENT ON COLUMN sys_role.id IS 'ID';
COMMENT ON COLUMN sys_role.name IS '角色名称';
COMMENT ON COLUMN sys_role.sort IS '排序';
COMMENT ON COLUMN sys_role.status IS '状态';
COMMENT ON COLUMN sys_role.description IS '描述';
COMMENT ON COLUMN sys_role.parent_id IS '父级ID';
COMMENT ON COLUMN sys_role.created_at IS '创建时间';
COMMENT ON COLUMN sys_role.updated_at IS '更新时间';
COMMENT ON COLUMN sys_role.deleted_at IS '删除时间';
COMMENT ON COLUMN sys_role.created_by IS '创建人';
COMMENT ON COLUMN sys_role.data_scope IS '数据权限';
COMMENT ON COLUMN sys_role.checked_depts IS '数据权限关联的部门';
COMMENT ON COLUMN sys_role.tenant_id IS '租户ID字段';

INSERT INTO sys_role (id, name, sort, status, description, parent_id, created_at, updated_at, deleted_at, created_by, data_scope, checked_depts, tenant_id) VALUES
(1, '系统管理员', 0, 1, '最高权限管理员角色', 0, '2025-09-01 17:32:12', '2025-09-30 15:53:24', NULL, 1, 1, '', 0),
(2, '演示', 0, 1, '', 0, '2025-10-14 15:12:09', '2025-10-17 15:34:47', NULL, 1, 0, '', 0);

SELECT setval('sys_role_id_seq', 3, false);

-- 表: sys_role_menu
DROP TABLE IF EXISTS sys_role_menu;
CREATE TABLE sys_role_menu (
    role_id INTEGER NOT NULL,
    menu_id INTEGER NOT NULL,
    PRIMARY KEY (role_id, menu_id)
);

INSERT INTO sys_role_menu (role_id, menu_id) VALUES
(1, 1),
(1, 10),
(1, 1001),
(1, 1002),
(1, 1003),
(1, 1004),
(1, 1005),
(1, 1006),
(1, 1007),
(1, 140213),
(1, 140214),
(1, 140215),
(1, 140216),
(1, 140218),
(1, 140219),
(1, 140220),
(1, 140221),
(1, 140222),
(1, 140223),
(1, 140224),
(1, 140225),
(1, 140226),
(1, 140227),
(1, 140228),
(1, 140229),
(1, 140230),
(1, 140231),
(1, 140232),
(1, 140233),
(1, 140234),
(1, 140235),
(1, 140236),
(1, 140237),
(1, 140238),
(1, 140239),
(1, 140240),
(1, 140241),
(1, 140242),
(1, 140243),
(1, 140244),
(1, 140245),
(1, 140246),
(1, 140247),
(1, 140248),
(1, 140249),
(1, 140250),
(1, 140251),
(1, 140252),
(1, 140254),
(1, 140255),
(1, 140256),
(1, 140257),
(1, 140258),
(1, 140259),
(1, 140260),
(1, 140261),
(1, 140262),
(1, 140263),
(1, 140264),
(1, 140265),
(1, 140329),
(1, 140330),
(1, 140331),
(1, 140332),
(1, 140333),
(1, 140334),
(1, 140335),
(1, 140336),
(1, 140338),
(1, 140339),
(1, 140340),
(2, 1),
(2, 10),
(2, 1001),
(2, 1002),
(2, 1003),
(2, 1004),
(2, 1005),
(2, 1006),
(2, 1007),
(2, 140213),
(2, 140214),
(2, 140215),
(2, 140216),
(2, 140218),
(2, 140219),
(2, 140220),
(2, 140221),
(2, 140222),
(2, 140223),
(2, 140224),
(2, 140225),
(2, 140226),
(2, 140227),
(2, 140228),
(2, 140229),
(2, 140230),
(2, 140231),
(2, 140232),
(2, 140233),
(2, 140234),
(2, 140235),
(2, 140236),
(2, 140237),
(2, 140238),
(2, 140239),
(2, 140240),
(2, 140241),
(2, 140242),
(2, 140243),
(2, 140244),
(2, 140245),
(2, 140246),
(2, 140247),
(2, 140248),
(2, 140249),
(2, 140250),
(2, 140251),
(2, 140252),
(2, 140254),
(2, 140255),
(2, 140256),
(2, 140257),
(2, 140258),
(2, 140259),
(2, 140260),
(2, 140261),
(2, 140262),
(2, 140263),
(2, 140264),
(2, 140265),
(2, 140329),
(2, 140330),
(2, 140331),
(2, 140332),
(2, 140333),
(2, 140334),
(2, 140335),
(2, 140336),
(2, 140338),
(2, 140339),
(2, 140340);

-- 表: sys_tenants
DROP TABLE IF EXISTS sys_tenants;
CREATE TABLE sys_tenants (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    created_by INTEGER NOT NULL DEFAULT 0,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(50) NOT NULL,
    description VARCHAR(500),
    status SMALLINT NOT NULL DEFAULT 1,
    domain VARCHAR(255),
    platform_domain VARCHAR(255)
);

COMMENT ON TABLE sys_tenants IS '租户表';
COMMENT ON COLUMN sys_tenants.id IS 'ID';
COMMENT ON COLUMN sys_tenants.created_at IS '创建时间';
COMMENT ON COLUMN sys_tenants.updated_at IS '更新时间';
COMMENT ON COLUMN sys_tenants.deleted_at IS '删除时间';
COMMENT ON COLUMN sys_tenants.created_by IS '创建人';
COMMENT ON COLUMN sys_tenants.name IS '租户名称';
COMMENT ON COLUMN sys_tenants.code IS '租户编码';
COMMENT ON COLUMN sys_tenants.description IS '租户描述';
COMMENT ON COLUMN sys_tenants.status IS '状态 0停用 1启用';
COMMENT ON COLUMN sys_tenants.domain IS '租户域名';
COMMENT ON COLUMN sys_tenants.platform_domain IS '主域名';

CREATE UNIQUE INDEX sys_tenants_code_idx ON sys_tenants (code);
CREATE UNIQUE INDEX sys_tenants_domain_idx ON sys_tenants (domain);
CREATE INDEX idx_sys_tenants_deleted_at ON sys_tenants (deleted_at);

INSERT INTO sys_tenants (id, created_at, updated_at, deleted_at, created_by, name, code, description, status, domain, platform_domain) VALUES
(1, '2025-11-03 11:16:45', '2025-11-03 11:16:45', NULL, 1, '测试租户1', 'dom1', '', 1, '', NULL);

SELECT setval('sys_tenants_id_seq', 2, false);

-- 表: sys_users
DROP TABLE IF EXISTS sys_users;
CREATE TABLE sys_users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL DEFAULT '',
    password VARCHAR(255) NOT NULL DEFAULT '',
    email VARCHAR(100) DEFAULT '',
    status SMALLINT DEFAULT 1,
    dept_id INTEGER DEFAULT 0,
    phone VARCHAR(64) DEFAULT '',
    sex VARCHAR(64) DEFAULT '',
    nick_name VARCHAR(100) DEFAULT '',
    avatar VARCHAR(255) DEFAULT '',
    description VARCHAR(500),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    created_by INTEGER DEFAULT 0,
    tenant_id INTEGER DEFAULT 0
);

COMMENT ON TABLE sys_users IS '用户表';
COMMENT ON COLUMN sys_users.id IS 'ID';
COMMENT ON COLUMN sys_users.username IS '用户名';
COMMENT ON COLUMN sys_users.password IS '密码';
COMMENT ON COLUMN sys_users.email IS '邮箱';
COMMENT ON COLUMN sys_users.status IS '是否启用 0停用 1启用';
COMMENT ON COLUMN sys_users.dept_id IS '部门ID';
COMMENT ON COLUMN sys_users.phone IS '电话';
COMMENT ON COLUMN sys_users.sex IS '性别';
COMMENT ON COLUMN sys_users.nick_name IS '昵称';
COMMENT ON COLUMN sys_users.avatar IS '头像';
COMMENT ON COLUMN sys_users.description IS '描述';
COMMENT ON COLUMN sys_users.created_at IS '创建时间';
COMMENT ON COLUMN sys_users.updated_at IS '更新时间';
COMMENT ON COLUMN sys_users.deleted_at IS '删除时间';
COMMENT ON COLUMN sys_users.created_by IS '创建人';
COMMENT ON COLUMN sys_users.tenant_id IS '租户ID字段';

CREATE UNIQUE INDEX sys_users_username_idx ON sys_users (username);

INSERT INTO sys_users (id, username, password, email, status, dept_id, phone, sex, nick_name, avatar, description, created_at, updated_at, deleted_at, created_by, tenant_id) VALUES
(1, 'admin', '$2a$10$0aS9FxWlOz/PXiqzsBr7huy.Dqdwucyb795qiWcA6fsn0Lu.GLA.C', 'admin@example.com', 1, 1, '18800000006', '1', '超级管理员', '/public/uploads/2025-11-04/20251104_0945787a-8536-45fc-ba75-e94c8daaec06.jpeg', '超级管理员', '2025-08-18 14:55:05', '2025-11-17 17:38:01', NULL, 0, 0),
(4, 'demo', '$2a$10$yxq80jnZCRPn/hhQYUffheRnDopYjiq1AKGdgrg1oatLha7tc/.Qe', '', 1, 1, '', '1', '演示账号', '', '演示账号', '2025-10-17 15:38:37', '2025-10-31 16:32:34', NULL, 1, 0);

SELECT setval('sys_users_id_seq', 5, false);

-- 表: sys_user_role
DROP TABLE IF EXISTS sys_user_role;
CREATE TABLE sys_user_role (
    user_id INTEGER NOT NULL DEFAULT 0,
    role_id INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id, role_id)
);

COMMENT ON TABLE sys_user_role IS '用户角色关联表';
COMMENT ON COLUMN sys_user_role.user_id IS '用户ID';
COMMENT ON COLUMN sys_user_role.role_id IS '角色ID';

INSERT INTO sys_user_role (user_id, role_id) VALUES
(1, 1),
(4, 2);

-- 表: sys_user_tenant
DROP TABLE IF EXISTS sys_user_tenant;
CREATE TABLE sys_user_tenant (
    user_id INTEGER NOT NULL DEFAULT 0,
    tenant_id INTEGER NOT NULL DEFAULT 0,
    is_default SMALLINT DEFAULT 0,
    created_at TIMESTAMP,
    PRIMARY KEY (user_id, tenant_id)
);

COMMENT ON TABLE sys_user_tenant IS '用户及租户关联表';
COMMENT ON COLUMN sys_user_tenant.user_id IS '用户ID';
COMMENT ON COLUMN sys_user_tenant.tenant_id IS '租户id';
COMMENT ON COLUMN sys_user_tenant.is_default IS '是否默认租户';
COMMENT ON COLUMN sys_user_tenant.created_at IS '创建时间';

-- 启用外键检查
SET session_replication_role = DEFAULT;