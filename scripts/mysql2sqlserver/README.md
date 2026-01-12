# MySQL 到 SQL Server SQL 转换工具

## 功能说明

这个工具可以将 MySQL 的 SQL 文件转换为 SQL Server 兼容的 SQL 文件。

## 使用方法

### 1. 编译程序

#### Windows 系统（推荐）

直接双击 `build.bat` 文件，或在命令行中执行：

```bash
cd scripts/mysql2sqlserver
build.bat
```

#### 使用 Go 命令编译

在项目根目录下执行：

```bash
go build -o scripts/mysql2sqlserver/mysql2sqlserver.exe scripts/mysql2sqlserver/main.go
```

或者进入目录后编译：

```bash
cd scripts/mysql2sqlserver
go build -o mysql2sqlserver.exe main.go
```

### 2. 运行转换

#### 指定输入和输出文件：

```bash
mysql2sqlserver.exe -input resource/database/gin-fast-tenant.sql -output resource/database/sqlserver_converted.sql
```

#### 只指定输入文件（自动生成输出文件名）：

```bash
mysql2sqlserver.exe -input resource/database/gin-fast-tenant.sql
```

输出文件将自动命名为 `gin-fast-tenant_sqlserver.sql`

### 3. 命令行参数

- `-input`: MySQL SQL 文件路径（必填）
- `-output`: SQL Server SQL 输出文件路径（可选，默认在输入文件名后加 `_sqlserver.sql`）

## 转换规则

### 数据类型转换

| MySQL 类型 | SQL Server 类型 |
|-----------|----------------|
| int(11)   | INT            |
| int(10)   | INT            |
| bigint(20) | BIGINT         |
| tinyint(1) | TINYINT        |
| tinyint(3) | TINYINT        |
| varchar(n) | VARCHAR(n)     |
| varchar   | VARCHAR(MAX)   |
| text      | TEXT           |
| datetime  | DATETIME       |
| datetime(3)| DATETIME2(3)  |
| date      | DATE           |
| boolean   | BIT            |
| json      | NVARCHAR(MAX)  |
| enum      | NVARCHAR(255)  |

### 语法转换

1. **DROP TABLE**: `DROP TABLE IF EXISTS table_name` → `IF OBJECT_ID('table_name', 'U') IS NOT NULL DROP TABLE table_name`
2. **自增字段**: `AUTO_INCREMENT` → `IDENTITY(1,1)`
3. **反引号**: `` ` `` → 移除
4. **主键**: `PRIMARY KEY USING BTREE` → `PRIMARY KEY`
5. **索引**: `KEY` / `UNIQUE KEY` → `CREATE INDEX` / `CREATE UNIQUE INDEX`
6. **NULL 值**: `null` → `NULL`
7. **字符串转义**: `\'` → `''`
8. **INSERT 语句**: 支持多行 INSERT 语句转换
   - 移除反引号
   - 转换 NULL 值（小写 → 大写）
   - 转换字符串转义（`\'` → `''`）
   - 合并多行为单行
9. **函数转换**:
   - `NOW()` → `GETDATE()`
   - `CURRENT_TIMESTAMP` → `GETDATE()`
   - `CURRENT_DATE()` → `CAST(GETDATE() AS DATE)`

## 示例

### 输入 (MySQL)

```sql
DROP TABLE IF EXISTS `demo_students`;
CREATE TABLE `demo_students` (
  `student_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `student_name` varchar(50) COLLATE utf8_unicode_ci NOT NULL COMMENT '姓名',
  `age` int(11) NOT NULL DEFAULT '18' COMMENT '年龄',
  PRIMARY KEY (`student_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='学员管理';
```

### 输出 (SQL Server)

```sql
IF OBJECT_ID('demo_students', 'U') IS NOT NULL DROP TABLE demo_students;
CREATE TABLE demo_students (
    student_id INT IDENTITY(1,1) PRIMARY KEY,
    student_name VARCHAR(50) NOT NULL,
    age INT NOT NULL DEFAULT 18
);
```

### INSERT 语句转换示例

#### 输入 (MySQL)

```sql
INSERT INTO `example` VALUES ('1', '项目管理系统', '用于管理项目进度和任务分配的系统', '2024-01-15 09:30:00', '2024-01-20 14:25:00', null, '1', '1');
INSERT INTO `example` VALUES ('2', '客户关系管理', '帮助企业维护客户关系的软件平台', '2024-01-16 10:15:00', '2024-01-22 11:40:00', null, '1', '1');
```

#### 输出 (SQL Server)

```sql
INSERT INTO example VALUES (1, '项目管理系统', '用于管理项目进度和任务分配的系统', '2024-01-15 09:30:00', '2024-01-20 14:25:00', NULL, 1, 1);
INSERT INTO example VALUES (2, '客户关系管理', '帮助企业维护客户关系的软件平台', '2024-01-16 10:15:00', '2024-01-22 11:40:00', NULL, 1, 1);
```

## 注意事项

1. **INSERT 语句**：
   - 程序支持单行和多行 INSERT 语句转换
   - NULL 值会自动转换为大写 `NULL`
   - 字符串中的单引号转义 `\'` 会转换为 `''`
   - 反引号会被移除

2. **自增字段（IDENTITY）**：
   - SQL Server 使用 `IDENTITY(1,1)` 表示自增
   - 转换后需要根据实际数据手动设置种子值

3. **注释处理**：
   - SQL Server 不支持标准的 `COMMENT ON` 语法
   - 表注释和列注释在转换中被忽略
   - 如需添加注释，可以使用 `sp_addextendedproperty` 存储过程

4. **其他注意事项**：
   - 复杂的存储过程、触发器等需要手动转换
   - 某些 MySQL 特有函数可能需要替换为 SQL Server 等价函数
   - 转换后请仔细检查生成的 SQL 文件
   - 字符集和排序规则需要根据 SQL Server 环境调整

5. **SQL Server 特定语法**：
   - 使用 `SET NOCOUNT ON` 提高性能
   - 使用 `IF OBJECT_ID('table_name', 'U') IS NOT NULL` 检查表是否存在
   - 使用 `DATETIME2` 替代 `DATETIME` 以获得更高精度

## 许可证

MIT License