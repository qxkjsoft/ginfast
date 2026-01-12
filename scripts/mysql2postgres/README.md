# MySQL 到 PostgreSQL SQL 转换工具

## 功能说明

这个工具可以将 MySQL 的 SQL 文件转换为 PostgreSQL 兼容的 SQL 文件。

## 使用方法

### 1. 编译程序

#### Windows 系统（推荐）

直接双击 `build.bat` 文件，或在命令行中执行：

```bash
cd scripts/mysql2postgres
build.bat
```

#### 使用 Go 命令编译

在项目根目录下执行：

```bash
go build -o scripts/mysql2postgres/mysql2postgres.exe scripts/mysql2postgres/main.go
```

或者进入目录后编译：

```bash
cd scripts/mysql2postgres
go build -o mysql2postgres.exe main.go
```

### 2. 运行转换

#### 指定输入和输出文件：

```bash
mysql2postgres.exe -input resource/database/gin-fast-tenant.sql -output resource/database/postgresql_converted.sql
```

#### 只指定输入文件（自动生成输出文件名）：

```bash
mysql2postgres.exe -input resource/database/gin-fast-tenant.sql
```

输出文件将自动命名为 `gin-fast-tenant_pg.sql`

### 3. 命令行参数

- `-input`: MySQL SQL 文件路径（必填）
- `-output`: PostgreSQL SQL 输出文件路径（可选，默认在输入文件名后加 `_pg.sql`）

## 转换规则

### 数据类型转换

| MySQL 类型 | PostgreSQL 类型 |
|-----------|----------------|
| int(11)   | INTEGER        |
| int(10)   | INTEGER        |
| bigint(20) | BIGINT         |
| tinyint(1) | SMALLINT       |
| tinyint(3) | SMALLINT       |
| varchar(n) | VARCHAR(n)     |
| text       | TEXT           |
| datetime   | TIMESTAMP      |
| datetime(3)| TIMESTAMP(3)  |
| date       | DATE           |

### 语法转换

1. **自增字段**: `AUTO_INCREMENT` → `SERIAL`
2. **反引号**: `` ` `` → 移除
3. **主键**: `PRIMARY KEY USING BTREE` → `PRIMARY KEY`
4. **索引**: `KEY` / `UNIQUE KEY` → `CREATE INDEX` / `CREATE UNIQUE INDEX`
5. **注释**: `COMMENT='xxx'` → `COMMENT ON TABLE/COLUMN IS 'xxx'`
6. **外键检查**: `SET FOREIGN_KEY_CHECKS=0` → `SET session_replication_role = replica`
7. **NULL 值**: `null` → `NULL`
8. **字符串转义**: `\'` → `''`
9. **INSERT 语句**: 支持多行 INSERT 语句转换
   - 移除反引号
   - 转换 NULL 值（小写 → 大写）
   - 转换字符串转义（`\'` → `''`）
   - 合并多行为单行

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

### 输出 (PostgreSQL)

```sql
DROP TABLE IF EXISTS demo_students;
CREATE TABLE demo_students (
    student_id SERIAL PRIMARY KEY,
    student_name VARCHAR(50) NOT NULL,
    age INTEGER NOT NULL DEFAULT 18
);

COMMENT ON TABLE demo_students IS '学员管理';
COMMENT ON COLUMN demo_students.student_id IS 'ID';
COMMENT ON COLUMN demo_students.student_name IS '姓名';
COMMENT ON COLUMN demo_students.age IS '年龄';
```

### INSERT 语句转换示例

#### 输入 (MySQL)

```sql
INSERT INTO `example` VALUES ('1', '项目管理系统', '用于管理项目进度和任务分配的系统', '2024-01-15 09:30:00', '2024-01-20 14:25:00', null, '1', '1');
INSERT INTO `example` VALUES ('2', '客户关系管理', '帮助企业维护客户关系的软件平台', '2024-01-16 10:15:00', '2024-01-22 11:40:00', null, '1', '1');
```

#### 输出 (PostgreSQL)

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

2. **序列值（SERIAL）**：
   - 需要根据实际数据手动设置序列起始值
   - 可以使用 `SELECT setval('table_id_seq', max_id, true);` 设置

3. **其他注意事项**：
   - 复杂的存储过程、触发器等需要手动转换
   - 某些 MySQL 特有函数可能需要替换为 PostgreSQL 等价函数
   - 转换后请仔细检查生成的 SQL 文件

## 许可证

MIT License
