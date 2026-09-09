-- 本文件仅含表结构，不含数据。
-- 超管账号：首次启动时按 config.yml 的 server.initadmin 配置自动创建。
-- 菜单/API 数据：登录后通过系统【菜单管理-菜单恢复】功能，从 resource/database/menu_backup 备份导入。
-- PostgreSQL SQL 转换文件
-- 由 MySQL SQL 转换而来

SET session_replication_role = replica;
SET client_min_messages TO WARNING;

-- Table structure for demo_students
DROP TABLE IF EXISTS demo_students;
CREATE TABLE demo_students (
    student_id SERIAL,
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
    tenant_id INTEGER DEFAULT 0,
    PRIMARY KEY (student_id)
);

COMMENT ON COLUMN demo_students.student_name IS '姓名';
COMMENT ON COLUMN demo_students.age IS '年龄';
COMMENT ON COLUMN demo_students.gender IS '性别';
COMMENT ON COLUMN demo_students.admission_date IS '入学日期';
COMMENT ON COLUMN demo_students.email IS ' 邮箱';
COMMENT ON COLUMN demo_students.phone IS '电话号码';
COMMENT ON COLUMN demo_students.created_at IS '创建时间';
COMMENT ON COLUMN demo_students.updated_at IS '更新时间';
COMMENT ON COLUMN demo_students.class_name IS '班级名称';
COMMENT ON COLUMN demo_students.address IS '地址';
COMMENT ON COLUMN demo_students.deleted_at IS '删除时间';
COMMENT ON COLUMN demo_students.created_by IS '创建人';
COMMENT ON COLUMN demo_students.tenant_id IS '租户ID字段';

-- Table structure for demo_teacher
DROP TABLE IF EXISTS demo_teacher;
CREATE TABLE demo_teacher (
    id SERIAL,
    name VARCHAR(50) NOT NULL,
    employee_id VARCHAR(20),
    gender BOOLEAN DEFAULT false,
    phone VARCHAR(20),
    email VARCHAR(100),
    subject VARCHAR(50),
    title VARCHAR(50),
    status BOOLEAN DEFAULT true,
    hire_date DATE,
    birth_date DATE,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    created_by INTEGER DEFAULT 0,
    PRIMARY KEY (id)
);

COMMENT ON COLUMN demo_teacher.phone IS '手机号';
COMMENT ON COLUMN demo_teacher.status IS '状态：0-离职 1-在职';
COMMENT ON COLUMN demo_teacher.hire_date IS '入职日期';
COMMENT ON COLUMN demo_teacher.updated_at IS '更新时间';
COMMENT ON COLUMN demo_teacher.created_by IS '创建人';
COMMENT ON COLUMN demo_teacher.id IS '主键ID';
COMMENT ON COLUMN demo_teacher.title IS '职称';
COMMENT ON COLUMN demo_teacher.birth_date IS '出生日期';
COMMENT ON COLUMN demo_teacher.deleted_at IS '删除时间';
COMMENT ON COLUMN demo_teacher.gender IS '性别：0-未知 1-男 2-女';
COMMENT ON COLUMN demo_teacher.email IS '邮箱';
COMMENT ON COLUMN demo_teacher.subject IS '所教学科';
COMMENT ON COLUMN demo_teacher.created_at IS '创建时间';
COMMENT ON COLUMN demo_teacher.name IS '教师姓名';
COMMENT ON COLUMN demo_teacher.employee_id IS '工号';

-- Table structure for example
DROP TABLE IF EXISTS example;
CREATE TABLE example (
    id SERIAL,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    created_by INTEGER,
    tenant_id INTEGER DEFAULT 0,
    PRIMARY KEY (id)
);

COMMENT ON COLUMN example.name IS '名称';
COMMENT ON COLUMN example.description IS '描述';
COMMENT ON COLUMN example.tenant_id IS '租户ID字段';

-- Table structure for sys_affix
DROP TABLE IF EXISTS sys_affix;
CREATE TABLE sys_affix (
    id SERIAL,
    name VARCHAR(255),
    path VARCHAR(255),
    url VARCHAR(255),
    file_md5 VARCHAR(32) DEFAULT '',
    size INTEGER,
    ftype VARCHAR(100),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    created_by INTEGER,
    suffix VARCHAR(100),
    tenant_id INTEGER DEFAULT 0,
    thumbnail_path VARCHAR(255),
    thumbnail_name VARCHAR(255),
    thumbnail_url VARCHAR(255),
    PRIMARY KEY (id)
);

COMMENT ON COLUMN sys_affix.name IS '文件名';
COMMENT ON COLUMN sys_affix.path IS '路径';
COMMENT ON COLUMN sys_affix.url IS '文件url';
COMMENT ON COLUMN sys_affix.ftype IS '文件类型';
COMMENT ON COLUMN sys_affix.suffix IS '文件后缀';
COMMENT ON COLUMN sys_affix.tenant_id IS '租户ID字段';
COMMENT ON COLUMN sys_affix.thumbnail_url IS '缩略图URL';
COMMENT ON COLUMN sys_affix.file_md5 IS '文件MD5(秒传检测)';
COMMENT ON COLUMN sys_affix.size IS '文件大小';
COMMENT ON COLUMN sys_affix.thumbnail_path IS '缩略图路径';
COMMENT ON COLUMN sys_affix.thumbnail_name IS '缩略图名称';
COMMENT ON COLUMN sys_affix.id IS 'ID';

-- Table structure for sys_affix_chunk
DROP TABLE IF EXISTS sys_affix_chunk;
CREATE TABLE sys_affix_chunk (
    id SERIAL,
    upload_id VARCHAR(64) NOT NULL,
    file_md5 VARCHAR(32) NOT NULL,
    file_name VARCHAR(255),
    file_size BIGINT,
    chunk_size INTEGER,
    total_chunks INTEGER,
    chunk_index INTEGER NOT NULL,
    chunk_path VARCHAR(255),
    status SMALLINT DEFAULT 0,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    created_by INTEGER,
    tenant_id INTEGER DEFAULT 0,
    PRIMARY KEY (id)
);

COMMENT ON COLUMN sys_affix_chunk.file_size IS '文件总大小';
COMMENT ON COLUMN sys_affix_chunk.chunk_index IS '当前分片序号';
COMMENT ON COLUMN sys_affix_chunk.chunk_path IS '分片文件路径';
COMMENT ON COLUMN sys_affix_chunk.status IS '0-上传中 1-已合并 2-已取消';
COMMENT ON COLUMN sys_affix_chunk.tenant_id IS '租户ID';
COMMENT ON COLUMN sys_affix_chunk.file_name IS '原始文件名';
COMMENT ON COLUMN sys_affix_chunk.chunk_size IS '分片大小';
COMMENT ON COLUMN sys_affix_chunk.total_chunks IS '总分片数';
COMMENT ON COLUMN sys_affix_chunk.created_by IS '创建者ID';
COMMENT ON COLUMN sys_affix_chunk.id IS 'ID';
COMMENT ON COLUMN sys_affix_chunk.upload_id IS '上传会话ID';
COMMENT ON COLUMN sys_affix_chunk.file_md5 IS '文件MD5';

-- Table structure for sys_api
DROP TABLE IF EXISTS sys_api;
CREATE TABLE sys_api (
    id SERIAL,
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

-- Table structure for sys_casbin_rule
DROP TABLE IF EXISTS sys_casbin_rule;
CREATE TABLE sys_casbin_rule (
    id SERIAL,
    ptype VARCHAR(100),
    v0 VARCHAR(100),
    v1 VARCHAR(100),
    v2 VARCHAR(100),
    v3 VARCHAR(100),
    v4 VARCHAR(100),
    v5 VARCHAR(100),
    PRIMARY KEY (id)
);


-- Table structure for sys_department
DROP TABLE IF EXISTS sys_department;
CREATE TABLE sys_department (
    id SERIAL,
    parent_id INTEGER DEFAULT 0,
    name VARCHAR(255),
    status BOOLEAN,
    leader VARCHAR(255),
    phone VARCHAR(255),
    email VARCHAR(255),
    sort INTEGER DEFAULT 0,
    describe VARCHAR(255),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    created_by INTEGER,
    tenant_id INTEGER DEFAULT 0,
    PRIMARY KEY (id)
);

COMMENT ON COLUMN sys_department.status IS '状态： 0 停用 1 启用';
COMMENT ON COLUMN sys_department.email IS '邮箱';
COMMENT ON COLUMN sys_department.sort IS '排序';
COMMENT ON COLUMN sys_department.tenant_id IS '租户ID字段';
COMMENT ON COLUMN sys_department.parent_id IS '父级';
COMMENT ON COLUMN sys_department.leader IS '负责人';
COMMENT ON COLUMN sys_department.phone IS '联系电话';
COMMENT ON COLUMN sys_department.describe IS '描述';
COMMENT ON COLUMN sys_department.name IS '部门名称';

-- Table structure for sys_dict
DROP TABLE IF EXISTS sys_dict;
CREATE TABLE sys_dict (
    id SERIAL,
    name VARCHAR(255),
    code VARCHAR(255),
    status BOOLEAN,
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

-- Table structure for sys_dict_item
DROP TABLE IF EXISTS sys_dict_item;
CREATE TABLE sys_dict_item (
    id SERIAL,
    name VARCHAR(255),
    value VARCHAR(255),
    status BOOLEAN,
    dict_id INTEGER,
    PRIMARY KEY (id)
);

COMMENT ON COLUMN sys_dict_item.status IS '状态';

-- Table structure for sys_gen
DROP TABLE IF EXISTS sys_gen;
CREATE TABLE sys_gen (
    id SERIAL,
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
    is_menu SMALLINT DEFAULT 0,
    is_tree SMALLINT DEFAULT 0,
    is_relation_tree SMALLINT DEFAULT 0,
    relation_tree_table INTEGER DEFAULT 0,
    relation_field INTEGER DEFAULT 0,
    PRIMARY KEY (id)
);

COMMENT ON COLUMN sys_gen.created_at IS '创建时间';
COMMENT ON COLUMN sys_gen.is_cover IS '是否覆盖';
COMMENT ON COLUMN sys_gen.db_type IS '数据库类型';
COMMENT ON COLUMN sys_gen.module_name IS '模块名称';
COMMENT ON COLUMN sys_gen.file_name IS '文件名称';
COMMENT ON COLUMN sys_gen.is_relation_tree IS '是否关联树形分类';
COMMENT ON COLUMN sys_gen.relation_field IS '关联的字段ID';
COMMENT ON COLUMN sys_gen.name IS '数据库表名';
COMMENT ON COLUMN sys_gen.is_menu IS '是否生成菜单';
COMMENT ON COLUMN sys_gen.relation_tree_table IS '关联的树形表';
COMMENT ON COLUMN sys_gen.id IS 'ID';
COMMENT ON COLUMN sys_gen.database IS '数据库';
COMMENT ON COLUMN sys_gen.describe IS '描述';
COMMENT ON COLUMN sys_gen.updated_at IS '修改时间';
COMMENT ON COLUMN sys_gen.deleted_at IS '删除时间';
COMMENT ON COLUMN sys_gen.created_by IS '创建人';

-- Table structure for sys_gen_field
DROP TABLE IF EXISTS sys_gen_field;
CREATE TABLE sys_gen_field (
    id SERIAL,
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
    gorm_tag VARCHAR(255),
    PRIMARY KEY (id)
);

COMMENT ON COLUMN sys_gen_field.dict_type IS '关联的字典';
COMMENT ON COLUMN sys_gen_field.gorm_tag IS 'gorm标签';
COMMENT ON COLUMN sys_gen_field.data_name IS '列名';
COMMENT ON COLUMN sys_gen_field.data_comment IS '列注释';
COMMENT ON COLUMN sys_gen_field.data_extra IS '额外信息';
COMMENT ON COLUMN sys_gen_field.data_unsigned IS '是否为无符号类型';
COMMENT ON COLUMN sys_gen_field.front_type IS '前端类型';
COMMENT ON COLUMN sys_gen_field.is_primary IS '是否主键';
COMMENT ON COLUMN sys_gen_field.require IS '是否必填';
COMMENT ON COLUMN sys_gen_field.query_show IS '查询显示';
COMMENT ON COLUMN sys_gen_field.custom_name IS '自定义字段名称';
COMMENT ON COLUMN sys_gen_field.list_show IS '列表显示';
COMMENT ON COLUMN sys_gen_field.data_type IS '数据类型';
COMMENT ON COLUMN sys_gen_field.data_column_key IS '列键信息';
COMMENT ON COLUMN sys_gen_field.go_type IS 'go类型';
COMMENT ON COLUMN sys_gen_field.form_show IS '表单显示';
COMMENT ON COLUMN sys_gen_field.query_type IS '查询方式\r\nEQ  等于\r\nNE 不等于\r\nGT 大于\r\nGTE 大于等于\r\nLT 小于\r\nLTE 小于等于\r\nLIKE 包含\r\nBETWEEN 范围';
COMMENT ON COLUMN sys_gen_field.form_type IS '表单类型\r\ninput 文本框\r\ntextarea 文本域\r\nnumber 数字输入框\r\nselect 下拉框\r\nradio 单选框\r\ncheckbox 复选框\r\ndatetime 日期时间';

-- Table structure for sys_jobs
DROP TABLE IF EXISTS sys_jobs;
CREATE TABLE sys_jobs (
    id VARCHAR(255) NOT NULL,
    group VARCHAR(100) NOT NULL,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    executor_name VARCHAR(100) NOT NULL,
    execution_policy SMALLINT NOT NULL DEFAULT 1,
    status SMALLINT NOT NULL DEFAULT 1,
    cron_expression VARCHAR(100) NOT NULL,
    parameters JSON,
    blocking_policy SMALLINT NOT NULL DEFAULT 0,
    timeout BIGINT NOT NULL DEFAULT 30000000000,
    max_retry INTEGER NOT NULL DEFAULT 0,
    retry_interval BIGINT NOT NULL DEFAULT 10000000000,
    parallel_num INTEGER NOT NULL DEFAULT 1,
    running_count INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    created_by INTEGER,
    PRIMARY KEY (id)
);

COMMENT ON COLUMN sys_jobs.description IS '任务描述';
COMMENT ON COLUMN sys_jobs.max_retry IS '最大重试次数';
COMMENT ON COLUMN sys_jobs.parallel_num IS '并行数';
COMMENT ON COLUMN sys_jobs.created_at IS '创建时间';
COMMENT ON COLUMN sys_jobs.id IS '任务ID';
COMMENT ON COLUMN sys_jobs.name IS '任务名称';
COMMENT ON COLUMN sys_jobs.updated_at IS '更新时间';
COMMENT ON COLUMN sys_jobs.executor_name IS '执行器名称';
COMMENT ON COLUMN sys_jobs.parameters IS '任务参数(JSON格式)';
COMMENT ON COLUMN sys_jobs.timeout IS '超时时间(纳秒)';
COMMENT ON COLUMN sys_jobs.running_count IS '当前运行中的任务数';
COMMENT ON COLUMN sys_jobs.group IS '任务分组名称';
COMMENT ON COLUMN sys_jobs.execution_policy IS '执行策略: 0=单次执行, 1=重复执行';
COMMENT ON COLUMN sys_jobs.status IS '任务状态: 0=禁用, 1=启用';
COMMENT ON COLUMN sys_jobs.cron_expression IS 'Cron表达式';
COMMENT ON COLUMN sys_jobs.blocking_policy IS '阻塞策略: 0=丢弃, 1=覆盖, 2=并行';
COMMENT ON COLUMN sys_jobs.retry_interval IS '重试间隔(纳秒)';

-- Table structure for sys_job_results
DROP TABLE IF EXISTS sys_job_results;
CREATE TABLE sys_job_results (
    id BIGSERIAL,
    job_id VARCHAR(255) NOT NULL,
    status VARCHAR(20) NOT NULL,
    error TEXT,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    duration BIGINT NOT NULL,
    retry_count INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT TEXT
);

COMMENT ON COLUMN sys_job_results.id IS '自增主键';
COMMENT ON COLUMN sys_job_results.error IS '错误信息';
COMMENT ON COLUMN sys_job_results.duration IS '执行时长(纳秒)';
COMMENT ON COLUMN sys_job_results.retry_count IS '重试次数';
COMMENT ON COLUMN sys_job_results.created_at IS '记录创建时间';
COMMENT ON COLUMN sys_job_results.job_id IS '任务ID';
COMMENT ON COLUMN sys_job_results.status IS '执行状态: SUCCESS, FAILED, PANIC';
COMMENT ON COLUMN sys_job_results.start_time IS '开始时间';
COMMENT ON COLUMN sys_job_results.end_time IS '结束时间';

-- Table structure for sys_menu
DROP TABLE IF EXISTS sys_menu;
CREATE TABLE sys_menu (
    id SERIAL,
    parent_id INTEGER NOT NULL DEFAULT 0,
    path VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    redirect VARCHAR(255),
    component VARCHAR(255),
    title VARCHAR(100),
    is_full BOOLEAN DEFAULT false,
    hide BOOLEAN DEFAULT false,
    disable BOOLEAN DEFAULT false,
    keep_alive BOOLEAN DEFAULT false,
    affix BOOLEAN DEFAULT false,
    link VARCHAR(500) DEFAULT '',
    iframe BOOLEAN DEFAULT false,
    svg_icon VARCHAR(100) DEFAULT '',
    icon VARCHAR(100) DEFAULT '',
    sort INTEGER DEFAULT 0,
    type BOOLEAN DEFAULT 2,
    is_link BOOLEAN DEFAULT false,
    permission VARCHAR(255) DEFAULT '',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    created_by INTEGER,
    PRIMARY KEY (id)
);

COMMENT ON COLUMN sys_menu.id IS '路由ID';
COMMENT ON COLUMN sys_menu.path IS '路由路径';
COMMENT ON COLUMN sys_menu.redirect IS '重定向';
COMMENT ON COLUMN sys_menu.created_at IS '创建时间';
COMMENT ON COLUMN sys_menu.parent_id IS '父级路由ID，顶层为0';
COMMENT ON COLUMN sys_menu.iframe IS '是否内嵌：0-否，1-是';
COMMENT ON COLUMN sys_menu.sort IS '排序字段';
COMMENT ON COLUMN sys_menu.updated_at IS '更新时间';
COMMENT ON COLUMN sys_menu.disable IS '是否停用：0-否，1-是';
COMMENT ON COLUMN sys_menu.affix IS '是否固定：0-否，1-是';
COMMENT ON COLUMN sys_menu.name IS '路由名称';
COMMENT ON COLUMN sys_menu.component IS '组件文件路径';
COMMENT ON COLUMN sys_menu.title IS '菜单标题，国际化key';
COMMENT ON COLUMN sys_menu.is_full IS '是否全屏显示：0-否，1-是';
COMMENT ON COLUMN sys_menu.hide IS '是否隐藏：0-否，1-是';
COMMENT ON COLUMN sys_menu.svg_icon IS 'svg图标名称';
COMMENT ON COLUMN sys_menu.keep_alive IS '是否缓存：0-否，1-是';
COMMENT ON COLUMN sys_menu.link IS '外链地址';
COMMENT ON COLUMN sys_menu.icon IS '普通图标名称';
COMMENT ON COLUMN sys_menu.type IS '类型：1-目录，2-菜单，3-按钮';
COMMENT ON COLUMN sys_menu.is_link IS '是否外链';
COMMENT ON COLUMN sys_menu.permission IS '权限标识';

-- Table structure for sys_menu_api
DROP TABLE IF EXISTS sys_menu_api;
CREATE TABLE sys_menu_api (
    menu_id INTEGER NOT NULL,
    api_id INTEGER NOT NULL,
    PRIMARY KEY (menu_id,api_id)
);


-- Table structure for sys_operation_logs
DROP TABLE IF EXISTS sys_operation_logs;
CREATE TABLE sys_operation_logs (
    id BIGSERIAL,
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
    tenant_id INTEGER DEFAULT 0,
    PRIMARY KEY (id)
);

COMMENT ON COLUMN sys_operation_logs.user_agent IS '用户代理';
COMMENT ON COLUMN sys_operation_logs.error_msg IS '错误信息';
COMMENT ON COLUMN sys_operation_logs.user_id IS '操作用户ID';
COMMENT ON COLUMN sys_operation_logs.module IS '操作模块';
COMMENT ON COLUMN sys_operation_logs.method IS '请求方法';
COMMENT ON COLUMN sys_operation_logs.path IS '请求路径';
COMMENT ON COLUMN sys_operation_logs.response_data IS '响应数据';
COMMENT ON COLUMN sys_operation_logs.ip IS '客户端IP';
COMMENT ON COLUMN sys_operation_logs.status_code IS '响应状态码';
COMMENT ON COLUMN sys_operation_logs.location IS '操作地点';
COMMENT ON COLUMN sys_operation_logs.tenant_id IS '租户ID字段';
COMMENT ON COLUMN sys_operation_logs.username IS '操作用户名';
COMMENT ON COLUMN sys_operation_logs.request_data IS '请求参数';
COMMENT ON COLUMN sys_operation_logs.duration IS '操作耗时(毫秒)';
COMMENT ON COLUMN sys_operation_logs.operation IS '操作类型';

-- Table structure for sys_role
DROP TABLE IF EXISTS sys_role;
CREATE TABLE sys_role (
    id SERIAL,
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
    tenant_id INTEGER DEFAULT 0,
    PRIMARY KEY (id)
);

COMMENT ON COLUMN sys_role.name IS '角色名称';
COMMENT ON COLUMN sys_role.sort IS '排序';
COMMENT ON COLUMN sys_role.status IS '状态';
COMMENT ON COLUMN sys_role.description IS '描述';
COMMENT ON COLUMN sys_role.data_scope IS '数据权限';
COMMENT ON COLUMN sys_role.checked_depts IS '数据权限关联的部门';
COMMENT ON COLUMN sys_role.tenant_id IS '租户ID字段';

-- Table structure for sys_role_menu
DROP TABLE IF EXISTS sys_role_menu;
CREATE TABLE sys_role_menu (
    role_id INTEGER NOT NULL,
    menu_id INTEGER NOT NULL,
    PRIMARY KEY (role_id,menu_id)
);


-- Table structure for sys_tenants
DROP TABLE IF EXISTS sys_tenants;
CREATE TABLE sys_tenants (
    id SERIAL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    created_by INTEGER NOT NULL DEFAULT 0,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(50) NOT NULL,
    description VARCHAR(500),
    status SMALLINT NOT NULL DEFAULT 1,
    domain VARCHAR(255),
    platform_domain VARCHAR(255),
    menu_permission VARCHAR(1000),
    PRIMARY KEY (id)
);

COMMENT ON COLUMN sys_tenants.code IS '租户编码';
COMMENT ON COLUMN sys_tenants.description IS '租户描述';
COMMENT ON COLUMN sys_tenants.status IS '状态 0停用 1启用';
COMMENT ON COLUMN sys_tenants.domain IS '租户域名';
COMMENT ON COLUMN sys_tenants.platform_domain IS '主域名';
COMMENT ON COLUMN sys_tenants.menu_permission IS '菜单权限';
COMMENT ON COLUMN sys_tenants.created_by IS '创建人';
COMMENT ON COLUMN sys_tenants.name IS '租户名称';

-- Table structure for sys_users
DROP TABLE IF EXISTS sys_users;
CREATE TABLE sys_users (
    id SERIAL,
    username VARCHAR(50) NOT NULL DEFAULT '',
    password VARCHAR(255) NOT NULL DEFAULT '',
    email VARCHAR(100) DEFAULT '',
    status BOOLEAN DEFAULT true,
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
    tenant_id INTEGER DEFAULT 0,
    PRIMARY KEY (id)
);

COMMENT ON COLUMN sys_users.phone IS '电话';
COMMENT ON COLUMN sys_users.sex IS '性别';
COMMENT ON COLUMN sys_users.description IS '描述';
COMMENT ON COLUMN sys_users.created_by IS '创建人';
COMMENT ON COLUMN sys_users.username IS '用户名';
COMMENT ON COLUMN sys_users.email IS '邮箱';
COMMENT ON COLUMN sys_users.nick_name IS '昵称';
COMMENT ON COLUMN sys_users.avatar IS '头像';
COMMENT ON COLUMN sys_users.tenant_id IS '租户ID字段';
COMMENT ON COLUMN sys_users.password IS '密码';
COMMENT ON COLUMN sys_users.status IS '是否启用 0停用 1启用';
COMMENT ON COLUMN sys_users.dept_id IS '部门ID';

-- Table structure for sys_user_role
DROP TABLE IF EXISTS sys_user_role;
CREATE TABLE sys_user_role (
    user_id INTEGER NOT NULL DEFAULT 0,
    role_id INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id,role_id)
);

COMMENT ON COLUMN sys_user_role.user_id IS '用户ID';
COMMENT ON COLUMN sys_user_role.role_id IS '角色ID';

-- Table structure for sys_user_tenant
DROP TABLE IF EXISTS sys_user_tenant;
CREATE TABLE sys_user_tenant (
    user_id INTEGER NOT NULL DEFAULT 0,
    tenant_id INTEGER NOT NULL DEFAULT 0,
    is_default BOOLEAN DEFAULT false,
    created_at TIMESTAMP,
    PRIMARY KEY (user_id,tenant_id)
);

COMMENT ON COLUMN sys_user_tenant.tenant_id IS '租户id';
COMMENT ON COLUMN sys_user_tenant.is_default IS '是否默认租户';
COMMENT ON COLUMN sys_user_tenant.user_id IS '用户ID';


-- Table structure for sys_param
DROP TABLE IF EXISTS sys_param;
CREATE TABLE sys_param (
    id BIGSERIAL,
    name VARCHAR(255),
    code VARCHAR(255) NOT NULL,
    value TEXT,
    status SMALLINT DEFAULT 1,
    description VARCHAR(500),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    created_by INTEGER DEFAULT 0,
    PRIMARY KEY (id)
);

COMMENT ON COLUMN sys_param.id IS 'ID';
COMMENT ON COLUMN sys_param.name IS '参数名称';
COMMENT ON COLUMN sys_param.code IS '参数唯一标识';
COMMENT ON COLUMN sys_param.value IS '参数值';
COMMENT ON COLUMN sys_param.status IS '状态(0禁用/1启用)';
COMMENT ON COLUMN sys_param.description IS '描述';
COMMENT ON COLUMN sys_param.created_by IS '创建人';

CREATE UNIQUE INDEX idx_sys_param_code ON sys_param (code);
CREATE INDEX idx_sys_param_deleted_at ON sys_param (deleted_at);

-- 创建索引
CREATE INDEX sys_jobs_idx_group ON sys_jobs ("group");
CREATE INDEX sys_jobs_idx_status ON sys_jobs (status);
CREATE INDEX sys_jobs_idx_executor_name ON sys_jobs (executor_name);
CREATE INDEX sys_jobs_idx_created_at ON sys_jobs (created_at);
CREATE INDEX sys_job_results_idx_job_id ON sys_job_results (job_id);
CREATE INDEX sys_job_results_idx_status ON sys_job_results (status);
CREATE INDEX sys_job_results_idx_start_time ON sys_job_results (start_time);
CREATE INDEX sys_job_results_idx_created_at ON sys_job_results (created_at);
CREATE INDEX sys_menu_idx_parent_id ON sys_menu (parent_id);
CREATE INDEX sys_menu_idx_sort ON sys_menu (sort);
CREATE INDEX sys_menu_idx_type ON sys_menu (type);
CREATE UNIQUE INDEX sys_tenants_code ON sys_tenants (code);
CREATE UNIQUE INDEX sys_tenants_domain ON sys_tenants (domain);
CREATE INDEX sys_tenants_idx_sys_tenants_deleted_at ON sys_tenants (deleted_at);
CREATE UNIQUE INDEX sys_users_username ON sys_users (username);
CREATE INDEX sys_affix_idx_sys_affix_file_md5 ON sys_affix (file_md5);
CREATE UNIQUE INDEX sys_casbin_rule_idx_casbin_rule ON sys_casbin_rule (ptype, v0, v1, v2, v3, v4, v5);
CREATE UNIQUE INDEX sys_casbin_rule_idx_sys_casbin_rule ON sys_casbin_rule (ptype, v0, v1, v2, v3, v4, v5);
CREATE INDEX sys_affix_chunk_idx_upload_id ON sys_affix_chunk (upload_id);
CREATE INDEX sys_affix_chunk_idx_file_md5 ON sys_affix_chunk (file_md5);
CREATE INDEX sys_operation_logs_idx_sys_operation_logs_deleted_at ON sys_operation_logs (deleted_at);
CREATE INDEX sys_operation_logs_idx_user_id ON sys_operation_logs (user_id);

-- 设置序列值
SELECT setval('sys_department_id_seq', 1, true);
SELECT setval('sys_gen_id_seq', 24, true);
-- 表 demo_teacher 的列 id 没有数据，序列 demo_teacher_id_seq 将保持默认起始值
-- 表 sys_affix_chunk 的列 id 没有数据，序列 sys_affix_chunk_id_seq 将保持默认起始值
SELECT setval('sys_dict_id_seq', 4, true);
SELECT setval('sys_dict_item_id_seq', 42, true);
-- 表 sys_operation_logs 的列 id 没有数据，序列 sys_operation_logs_id_seq 将保持默认起始值
-- 表 sys_job_results 的列 id 没有数据，序列 sys_job_results_id_seq 将保持默认起始值
SELECT setval('sys_gen_field_id_seq', 213, true);
SELECT setval('sys_menu_id_seq', 140349, true);
SELECT setval('sys_tenants_id_seq', 1, true);
SELECT setval('sys_role_id_seq', 2, true);
SELECT setval('sys_users_id_seq', 4, true);
-- 表 demo_students 的列 student_id 没有数据，序列 demo_students_student_id_seq 将保持默认起始值
SELECT setval('example_id_seq', 15, true);
-- 表 sys_affix 的列 id 没有数据，序列 sys_affix_id_seq 将保持默认起始值
SELECT setval('sys_api_id_seq', 216, true);
SELECT setval('sys_casbin_rule_id_seq', 7560, true);
SELECT setval('sys_param_id_seq', 4, true);


-- Table structure for sys_area
DROP TABLE IF EXISTS sys_area;
CREATE TABLE sys_area (
    id SERIAL,
    value VARCHAR(20) NOT NULL,
    label VARCHAR(100) NOT NULL,
    level SMALLINT,
    parent VARCHAR(20) DEFAULT '',
    sort INTEGER DEFAULT 0,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP
);
CREATE UNIQUE INDEX sys_area_uk_value ON sys_area (value);
CREATE INDEX sys_area_idx_parent ON sys_area (parent);

SET session_replication_role = DEFAULT;
SET client_min_messages TO NOTICE;
