-- 本文件仅含表结构，不含数据。
-- 超管账号：首次启动时按 config.yml 的 server.initadmin 配置自动创建。
-- 菜单/API 数据：登录后通过系统【菜单管理-菜单恢复】功能，从 resource/database/menu_backup 备份导入。
-- SQL Server SQL 转换文件
-- 由 MySQL SQL 转换而来

SET NOCOUNT ON;

-- Table structure for demo_students
IF OBJECT_ID('demo_students', 'U') IS NOT NULL DROP TABLE [demo_students];
CREATE TABLE [demo_students] (
    [student_id] BIGINT IDENTITY(1,1) NOT NULL,
    [student_name] NVARCHAR(50) NOT NULL,
    [age] INT NOT NULL DEFAULT 18,
    [gender] NVARCHAR(50) NOT NULL DEFAULT '',
    [class_name] NVARCHAR(20) NOT NULL,
    [admission_date] DATETIME NOT NULL,
    [email] NVARCHAR(100),
    [phone] NVARCHAR(20),
    [address] NVARCHAR(MAX),
    [created_at] DATETIME,
    [updated_at] DATETIME,
    [deleted_at] DATETIME,
    [created_by] BIGINT DEFAULT 0,
    [tenant_id] BIGINT DEFAULT 0,
    PRIMARY KEY ([student_id])
);


-- Table structure for demo_teacher
IF OBJECT_ID('demo_teacher', 'U') IS NOT NULL DROP TABLE [demo_teacher];
CREATE TABLE [demo_teacher] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [name] NVARCHAR(50) NOT NULL,
    [employee_id] NVARCHAR(20),
    [gender] TINYINT DEFAULT 0,
    [phone] NVARCHAR(20),
    [email] NVARCHAR(100),
    [subject] NVARCHAR(50),
    [title] NVARCHAR(50),
    [status] TINYINT DEFAULT 1,
    [hire_date] DATE,
    [birth_date] DATE,
    [created_at] DATETIME,
    [updated_at] DATETIME,
    [deleted_at] DATETIME,
    [created_by] BIGINT DEFAULT 0,
    PRIMARY KEY ([id])
);


-- Table structure for example
IF OBJECT_ID('example', 'U') IS NOT NULL DROP TABLE [example];
CREATE TABLE [example] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [name] NVARCHAR(255) NOT NULL,
    [description] NVARCHAR(255),
    [created_at] DATETIME NOT NULL,
    [updated_at] DATETIME,
    [deleted_at] DATETIME,
    [created_by] INT,
    [tenant_id] BIGINT DEFAULT 0,
    PRIMARY KEY ([id])
);


-- Table structure for sys_affix
IF OBJECT_ID('sys_affix', 'U') IS NOT NULL DROP TABLE [sys_affix];
CREATE TABLE [sys_affix] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [name] NVARCHAR(255),
    [path] NVARCHAR(255),
    [url] NVARCHAR(255),
    [file_md5] NVARCHAR(32) DEFAULT '',
    [size] INT,
    [ftype] NVARCHAR(100),
    [created_at] DATETIME,
    [updated_at] DATETIME,
    [deleted_at] DATETIME,
    [created_by] INT,
    [suffix] NVARCHAR(100),
    [tenant_id] BIGINT DEFAULT 0,
    [thumbnail_path] NVARCHAR(255),
    [thumbnail_name] NVARCHAR(255),
    [thumbnail_url] NVARCHAR(255),
    PRIMARY KEY ([id])
);


-- Table structure for sys_affix_chunk
IF OBJECT_ID('sys_affix_chunk', 'U') IS NOT NULL DROP TABLE [sys_affix_chunk];
CREATE TABLE [sys_affix_chunk] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [upload_id] NVARCHAR(64) NOT NULL,
    [file_md5] NVARCHAR(32) NOT NULL,
    [file_name] NVARCHAR(255),
    [file_size] BIGINT,
    [chunk_size] INT,
    [total_chunks] INT,
    [chunk_index] INT NOT NULL,
    [chunk_path] NVARCHAR(255),
    [status] TINYINT DEFAULT 0,
    [created_at] DATETIME,
    [updated_at] DATETIME,
    [deleted_at] DATETIME,
    [created_by] INT,
    [tenant_id] BIGINT DEFAULT 0,
    PRIMARY KEY ([id])
);


-- Table structure for sys_api
IF OBJECT_ID('sys_api', 'U') IS NOT NULL DROP TABLE [sys_api];
CREATE TABLE [sys_api] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [title] NVARCHAR(255),
    [path] NVARCHAR(255),
    [method] NVARCHAR(32),
    [api_group] NVARCHAR(255),
    [created_at] DATETIME,
    [updated_at] DATETIME,
    [deleted_at] DATETIME,
    [created_by] BIGINT,
    PRIMARY KEY ([id])
);


-- Table structure for sys_casbin_rule
IF OBJECT_ID('sys_casbin_rule', 'U') IS NOT NULL DROP TABLE [sys_casbin_rule];
CREATE TABLE [sys_casbin_rule] (
    [id] INT IDENTITY(1,1) NOT NULL,
    [ptype] NVARCHAR(100),
    [v0] NVARCHAR(100),
    [v1] NVARCHAR(100),
    [v2] NVARCHAR(100),
    [v3] NVARCHAR(100),
    [v4] NVARCHAR(100),
    [v5] NVARCHAR(100),
    PRIMARY KEY ([id])
);


-- Table structure for sys_department
IF OBJECT_ID('sys_department', 'U') IS NOT NULL DROP TABLE [sys_department];
CREATE TABLE [sys_department] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [parent_id] BIGINT DEFAULT 0,
    [name] NVARCHAR(255),
    [status] TINYINT,
    [leader] NVARCHAR(255),
    [phone] NVARCHAR(255),
    [email] NVARCHAR(255),
    [sort] INT DEFAULT 0,
    [describe] NVARCHAR(255),
    [created_at] DATETIME,
    [updated_at] DATETIME,
    [deleted_at] DATETIME,
    [created_by] BIGINT,
    [tenant_id] BIGINT DEFAULT 0,
    PRIMARY KEY ([id])
);


-- Table structure for sys_dict
IF OBJECT_ID('sys_dict', 'U') IS NOT NULL DROP TABLE [sys_dict];
CREATE TABLE [sys_dict] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [name] NVARCHAR(255),
    [code] NVARCHAR(255),
    [status] TINYINT,
    [description] NVARCHAR(500),
    [created_at] DATETIME,
    [updated_at] DATETIME,
    [deleted_at] DATETIME,
    [created_by] BIGINT,
    PRIMARY KEY ([id])
);


-- Table structure for sys_dict_item
IF OBJECT_ID('sys_dict_item', 'U') IS NOT NULL DROP TABLE [sys_dict_item];
CREATE TABLE [sys_dict_item] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [name] NVARCHAR(255),
    [value] NVARCHAR(255),
    [status] TINYINT,
    [dict_id] BIGINT,
    PRIMARY KEY ([id])
);


-- Table structure for sys_gen
IF OBJECT_ID('sys_gen', 'U') IS NOT NULL DROP TABLE [sys_gen];
CREATE TABLE [sys_gen] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [db_type] NVARCHAR(255),
    [database] NVARCHAR(255),
    [name] NVARCHAR(255),
    [module_name] NVARCHAR(255),
    [file_name] NVARCHAR(255),
    [describe] NVARCHAR(1000),
    [created_at] DATETIME,
    [updated_at] DATETIME,
    [deleted_at] DATETIME,
    [created_by] BIGINT,
    [is_cover] TINYINT DEFAULT 0,
    [is_menu] TINYINT DEFAULT 0,
    [is_tree] TINYINT DEFAULT 0,
    [is_relation_tree] TINYINT DEFAULT 0,
    [relation_tree_table] BIGINT DEFAULT 0,
    [relation_field] BIGINT DEFAULT 0,
    PRIMARY KEY ([id])
);


-- Table structure for sys_gen_field
IF OBJECT_ID('sys_gen_field', 'U') IS NOT NULL DROP TABLE [sys_gen_field];
CREATE TABLE [sys_gen_field] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [gen_id] BIGINT,
    [data_name] NVARCHAR(255),
    [data_type] NVARCHAR(255),
    [data_comment] NVARCHAR(255),
    [data_extra] NVARCHAR(255),
    [data_column_key] NVARCHAR(255),
    [data_unsigned] BIGINT DEFAULT 0,
    [is_primary] TINYINT DEFAULT 0,
    [go_type] NVARCHAR(255),
    [front_type] NVARCHAR(255),
    [custom_name] NVARCHAR(255) DEFAULT '',
    [require] TINYINT DEFAULT 0,
    [list_show] TINYINT DEFAULT 0,
    [form_show] TINYINT DEFAULT 0,
    [query_show] TINYINT DEFAULT 0,
    [query_type] NVARCHAR(255),
    [form_type] NVARCHAR(255),
    [dict_type] NVARCHAR(255),
    [gorm_tag] NVARCHAR(255),
    PRIMARY KEY ([id])
);


-- Table structure for sys_jobs
IF OBJECT_ID('sys_jobs', 'U') IS NOT NULL DROP TABLE [sys_jobs];
CREATE TABLE [sys_jobs] (
    [id] NVARCHAR(255) NOT NULL,
    [group] NVARCHAR(100) NOT NULL,
    [name] NVARCHAR(200) NOT NULL,
    [description] NVARCHAR(MAX),
    [executor_name] NVARCHAR(100) NOT NULL,
    [execution_policy] TINYINT NOT NULL DEFAULT 1,
    [status] TINYINT NOT NULL DEFAULT 1,
    [cron_expression] NVARCHAR(100) NOT NULL,
    [parameters] NVARCHAR(MAX),
    [blocking_policy] TINYINT NOT NULL DEFAULT 0,
    [timeout] BIGINT NOT NULL DEFAULT 30000000000,
    [max_retry] INT NOT NULL DEFAULT 0,
    [retry_interval] BIGINT NOT NULL DEFAULT 10000000000,
    [parallel_num] INT NOT NULL DEFAULT 1,
    [running_count] INT NOT NULL DEFAULT 0,
    [created_at] DATETIME NOT NULL DEFAULT GETDATE(),
    [updated_at] DATETIME NOT NULL DEFAULT GETDATE(),
    [deleted_at] DATETIME,
    [created_by] BIGINT,
    PRIMARY KEY ([id])
);


-- Table structure for sys_job_results
IF OBJECT_ID('sys_job_results', 'U') IS NOT NULL DROP TABLE [sys_job_results];
CREATE TABLE [sys_job_results] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [job_id] NVARCHAR(255) NOT NULL,
    [status] NVARCHAR(20) NOT NULL,
    [error] NVARCHAR(MAX),
    [start_time] DATETIME NOT NULL,
    [end_time] DATETIME NOT NULL,
    [duration] BIGINT NOT NULL,
    [retry_count] INT NOT NULL DEFAULT 0,
    [created_at] DATETIME NOT NULL DEFAULT GETDATE(),
    PRIMARY KEY ([id]),
    [CONSTRAINT] NVARCHAR(MAX)
);


-- Table structure for sys_menu
IF OBJECT_ID('sys_menu', 'U') IS NOT NULL DROP TABLE [sys_menu];
CREATE TABLE [sys_menu] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [parent_id] BIGINT NOT NULL DEFAULT 0,
    [path] NVARCHAR(255) NOT NULL,
    [name] NVARCHAR(100) NOT NULL,
    [redirect] NVARCHAR(255),
    [component] NVARCHAR(255),
    [title] NVARCHAR(100),
    [is_full] TINYINT DEFAULT 0,
    [hide] TINYINT DEFAULT 0,
    [disable] TINYINT DEFAULT 0,
    [keep_alive] TINYINT DEFAULT 0,
    [affix] TINYINT DEFAULT 0,
    [link] NVARCHAR(500) DEFAULT '',
    [iframe] TINYINT DEFAULT 0,
    [svg_icon] NVARCHAR(100) DEFAULT '',
    [icon] NVARCHAR(100) DEFAULT '',
    [sort] INT DEFAULT 0,
    [type] TINYINT DEFAULT 2,
    [is_link] TINYINT DEFAULT 0,
    [permission] NVARCHAR(255) DEFAULT '',
    [created_at] DATETIME DEFAULT GETDATE(),
    [updated_at] DATETIME DEFAULT GETDATE(),
    [deleted_at] DATETIME,
    [created_by] BIGINT,
    PRIMARY KEY ([id])
);


-- Table structure for sys_menu_api
IF OBJECT_ID('sys_menu_api', 'U') IS NOT NULL DROP TABLE [sys_menu_api];
CREATE TABLE [sys_menu_api] (
    [menu_id] BIGINT NOT NULL,
    [api_id] BIGINT NOT NULL,
    PRIMARY KEY ([menu_id], [api_id])
);


-- Table structure for sys_operation_logs
IF OBJECT_ID('sys_operation_logs', 'U') IS NOT NULL DROP TABLE [sys_operation_logs];
CREATE TABLE [sys_operation_logs] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [created_at] DATETIME,
    [updated_at] DATETIME,
    [deleted_at] DATETIME,
    [user_id] BIGINT,
    [username] NVARCHAR(50),
    [module] NVARCHAR(100),
    [operation] NVARCHAR(100),
    [method] NVARCHAR(10),
    [path] NVARCHAR(500),
    [ip] NVARCHAR(50),
    [user_agent] NVARCHAR(500),
    [request_data] NVARCHAR(MAX),
    [response_data] NVARCHAR(MAX),
    [status_code] INT,
    [duration] BIGINT,
    [error_msg] NVARCHAR(MAX),
    [location] NVARCHAR(100),
    [tenant_id] BIGINT DEFAULT 0,
    PRIMARY KEY ([id])
);


-- Table structure for sys_role
IF OBJECT_ID('sys_role', 'U') IS NOT NULL DROP TABLE [sys_role];
CREATE TABLE [sys_role] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [name] NVARCHAR(255) DEFAULT '',
    [sort] INT DEFAULT 0,
    [status] TINYINT DEFAULT 0,
    [description] NVARCHAR(255),
    [parent_id] BIGINT DEFAULT 0,
    [created_at] DATETIME,
    [updated_at] DATETIME,
    [deleted_at] DATETIME,
    [created_by] BIGINT,
    [data_scope] INT DEFAULT 0,
    [checked_depts] NVARCHAR(1000),
    [tenant_id] BIGINT DEFAULT 0,
    PRIMARY KEY ([id])
);


-- Table structure for sys_role_menu
IF OBJECT_ID('sys_role_menu', 'U') IS NOT NULL DROP TABLE [sys_role_menu];
CREATE TABLE [sys_role_menu] (
    [role_id] BIGINT NOT NULL,
    [menu_id] BIGINT NOT NULL,
    PRIMARY KEY ([role_id], [menu_id])
);


-- Table structure for sys_tenants
IF OBJECT_ID('sys_tenants', 'U') IS NOT NULL DROP TABLE [sys_tenants];
CREATE TABLE [sys_tenants] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [created_at] DATETIME,
    [updated_at] DATETIME,
    [deleted_at] DATETIME,
    [created_by] BIGINT NOT NULL DEFAULT 0,
    [name] NVARCHAR(100) NOT NULL,
    [code] NVARCHAR(50) NOT NULL,
    [description] NVARCHAR(500),
    [status] TINYINT NOT NULL DEFAULT 1,
    [domain] NVARCHAR(255),
    [platform_domain] NVARCHAR(255),
    [menu_permission] NVARCHAR(1000),
    PRIMARY KEY ([id])
);


-- Table structure for sys_users
IF OBJECT_ID('sys_users', 'U') IS NOT NULL DROP TABLE [sys_users];
CREATE TABLE [sys_users] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [username] NVARCHAR(50) NOT NULL DEFAULT '',
    [password] NVARCHAR(255) NOT NULL DEFAULT '',
    [email] NVARCHAR(100) DEFAULT '',
    [status] TINYINT DEFAULT 1,
    [dept_id] BIGINT DEFAULT 0,
    [phone] NVARCHAR(64) DEFAULT '',
    [sex] NVARCHAR(64) DEFAULT '',
    [nick_name] NVARCHAR(100) DEFAULT '',
    [avatar] NVARCHAR(255) DEFAULT '',
    [description] NVARCHAR(500),
    [created_at] DATETIME,
    [updated_at] DATETIME,
    [deleted_at] DATETIME,
    [created_by] BIGINT DEFAULT 0,
    [tenant_id] BIGINT DEFAULT 0,
    PRIMARY KEY ([id])
);


-- Table structure for sys_user_role
IF OBJECT_ID('sys_user_role', 'U') IS NOT NULL DROP TABLE [sys_user_role];
CREATE TABLE [sys_user_role] (
    [user_id] BIGINT NOT NULL DEFAULT 0,
    [role_id] BIGINT NOT NULL DEFAULT 0,
    PRIMARY KEY ([user_id], [role_id])
);


-- Table structure for sys_user_tenant
IF OBJECT_ID('sys_user_tenant', 'U') IS NOT NULL DROP TABLE [sys_user_tenant];
CREATE TABLE [sys_user_tenant] (
    [user_id] BIGINT NOT NULL DEFAULT 0,
    [tenant_id] BIGINT NOT NULL DEFAULT 0,
    [is_default] TINYINT DEFAULT 0,
    [created_at] DATETIME,
    PRIMARY KEY ([user_id], [tenant_id])
);



-- Table structure for sys_param
IF OBJECT_ID('sys_param', 'U') IS NOT NULL DROP TABLE [sys_param];
CREATE TABLE [sys_param] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [name] NVARCHAR(255),
    [code] NVARCHAR(255) NOT NULL,
    [value] NVARCHAR(MAX),
    [status] TINYINT DEFAULT 1,
    [description] NVARCHAR(500),
    [created_at] DATETIME,
    [updated_at] DATETIME,
    [deleted_at] DATETIME,
    [created_by] BIGINT DEFAULT 0,
    PRIMARY KEY ([id])
);

CREATE UNIQUE INDEX [idx_sys_param_code] ON [sys_param] ([code]);
CREATE INDEX [idx_sys_param_deleted_at] ON [sys_param] ([deleted_at]);

-- 创建索引
CREATE INDEX [sys_jobs_idx_group] ON [sys_jobs] ([group]);
CREATE INDEX [sys_jobs_idx_status] ON [sys_jobs] ([status]);
CREATE INDEX [sys_jobs_idx_executor_name] ON [sys_jobs] ([executor_name]);
CREATE INDEX [sys_jobs_idx_created_at] ON [sys_jobs] ([created_at]);
CREATE INDEX [sys_job_results_idx_job_id] ON [sys_job_results] ([job_id]);
CREATE INDEX [sys_job_results_idx_status] ON [sys_job_results] ([status]);
CREATE INDEX [sys_job_results_idx_start_time] ON [sys_job_results] ([start_time]);
CREATE INDEX [sys_job_results_idx_created_at] ON [sys_job_results] ([created_at]);
CREATE INDEX [sys_operation_logs_idx_sys_operation_logs_deleted_at] ON [sys_operation_logs] ([deleted_at]);
CREATE INDEX [sys_operation_logs_idx_user_id] ON [sys_operation_logs] ([user_id]);
CREATE UNIQUE INDEX [sys_users_username] ON [sys_users] ([username]);
CREATE INDEX [sys_affix_idx_sys_affix_file_md5] ON [sys_affix] ([file_md5]);
CREATE UNIQUE INDEX [sys_casbin_rule_idx_casbin_rule] ON [sys_casbin_rule] ([ptype], [v0], [v1], [v2], [v3], [v4], [v5]);
CREATE INDEX [sys_affix_chunk_idx_upload_id] ON [sys_affix_chunk] ([upload_id]);
CREATE INDEX [sys_affix_chunk_idx_file_md5] ON [sys_affix_chunk] ([file_md5]);
CREATE INDEX [sys_menu_idx_parent_id] ON [sys_menu] ([parent_id]);
CREATE INDEX [sys_menu_idx_sort] ON [sys_menu] ([sort]);
CREATE INDEX [sys_menu_idx_type] ON [sys_menu] ([type]);
CREATE UNIQUE INDEX [sys_tenants_code] ON [sys_tenants] ([code]);
CREATE UNIQUE INDEX [sys_tenants_domain] ON [sys_tenants] ([domain]);
CREATE INDEX [sys_tenants_idx_sys_tenants_deleted_at] ON [sys_tenants] ([deleted_at]);

-- Table structure for sys_area
IF OBJECT_ID('sys_area', 'U') IS NOT NULL DROP TABLE [sys_area];
CREATE TABLE [sys_area] (
    [id] BIGINT IDENTITY(1,1) NOT NULL,
    [value] NVARCHAR(20) NOT NULL,
    [label] NVARCHAR(100) NOT NULL,
    [level] TINYINT,
    [parent] NVARCHAR(20) DEFAULT '',
    [sort] INT DEFAULT 0,
    [created_at] DATETIME,
    [updated_at] DATETIME,
    [deleted_at] DATETIME,
    CONSTRAINT [sys_area_pk] PRIMARY KEY ([id])
);
CREATE UNIQUE INDEX [sys_area_uk_value] ON [sys_area] ([value]);
CREATE INDEX [sys_area_idx_parent] ON [sys_area] ([parent]);

SET NOCOUNT OFF;
