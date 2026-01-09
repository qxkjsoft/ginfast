/*
Navicat SQL Server Data Transfer

Source Server         : ms
Source Server Version : 120000
Source Host           : localhost:1433
Source Database       : ginfast
Source Schema         : dbo

Target Server Type    : SQL Server
Target Server Version : 120000
File Encoding         : 65001

Date: 2025-12-10 10:52:00
*/


-- ----------------------------
-- Table structure for demo_students
-- ----------------------------
CREATE TABLE [dbo].[demo_students] (
[student_id] int NOT NULL IDENTITY(1,1) ,
[student_name] nvarchar(50) NOT NULL ,
[age] int NOT NULL DEFAULT ((18)) ,
[gender] nvarchar(50) NOT NULL DEFAULT '' ,
[class_name] nvarchar(20) NOT NULL ,
[admission_date] datetime NOT NULL ,
[email] nvarchar(100) NULL ,
[phone] nvarchar(20) NULL ,
[address] nvarchar(MAX) NULL ,
[created_at] datetime NULL ,
[updated_at] datetime NULL ,
[deleted_at] datetime NULL ,
[created_by] int NULL DEFAULT ((0)) ,
[tenant_id] int NULL DEFAULT ((0)) 
)


GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'demo_students', 
NULL, NULL)) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'学员管理'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_students'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'学员管理'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_students'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'demo_students', 
'COLUMN', N'student_name')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'姓名'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_students'
, @level2type = 'COLUMN', @level2name = N'student_name'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'姓名'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_students'
, @level2type = 'COLUMN', @level2name = N'student_name'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'demo_students', 
'COLUMN', N'age')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'年龄'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_students'
, @level2type = 'COLUMN', @level2name = N'age'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'年龄'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_students'
, @level2type = 'COLUMN', @level2name = N'age'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'demo_students', 
'COLUMN', N'gender')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'性别'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_students'
, @level2type = 'COLUMN', @level2name = N'gender'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'性别'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_students'
, @level2type = 'COLUMN', @level2name = N'gender'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'demo_students', 
'COLUMN', N'class_name')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'班级名称'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_students'
, @level2type = 'COLUMN', @level2name = N'class_name'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'班级名称'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_students'
, @level2type = 'COLUMN', @level2name = N'class_name'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'demo_students', 
'COLUMN', N'admission_date')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'入学日期'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_students'
, @level2type = 'COLUMN', @level2name = N'admission_date'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'入学日期'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_students'
, @level2type = 'COLUMN', @level2name = N'admission_date'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'demo_students', 
'COLUMN', N'email')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'邮箱'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_students'
, @level2type = 'COLUMN', @level2name = N'email'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'邮箱'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_students'
, @level2type = 'COLUMN', @level2name = N'email'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'demo_students', 
'COLUMN', N'phone')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'电话号码'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_students'
, @level2type = 'COLUMN', @level2name = N'phone'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'电话号码'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_students'
, @level2type = 'COLUMN', @level2name = N'phone'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'demo_students', 
'COLUMN', N'address')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'地址'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_students'
, @level2type = 'COLUMN', @level2name = N'address'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'地址'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_students'
, @level2type = 'COLUMN', @level2name = N'address'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'demo_students', 
'COLUMN', N'created_at')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'创建时间'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_students'
, @level2type = 'COLUMN', @level2name = N'created_at'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'创建时间'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_students'
, @level2type = 'COLUMN', @level2name = N'created_at'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'demo_students', 
'COLUMN', N'updated_at')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'更新时间'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_students'
, @level2type = 'COLUMN', @level2name = N'updated_at'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'更新时间'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_students'
, @level2type = 'COLUMN', @level2name = N'updated_at'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'demo_students', 
'COLUMN', N'deleted_at')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'删除时间'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_students'
, @level2type = 'COLUMN', @level2name = N'deleted_at'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'删除时间'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_students'
, @level2type = 'COLUMN', @level2name = N'deleted_at'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'demo_students', 
'COLUMN', N'created_by')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'创建人'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_students'
, @level2type = 'COLUMN', @level2name = N'created_by'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'创建人'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_students'
, @level2type = 'COLUMN', @level2name = N'created_by'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'demo_students', 
'COLUMN', N'tenant_id')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'租户ID字段'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_students'
, @level2type = 'COLUMN', @level2name = N'tenant_id'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'租户ID字段'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_students'
, @level2type = 'COLUMN', @level2name = N'tenant_id'
GO

-- ----------------------------
-- Records of demo_students
-- ----------------------------
SET IDENTITY_INSERT [dbo].[demo_students] ON
GO
SET IDENTITY_INSERT [dbo].[demo_students] OFF
GO

-- ----------------------------
-- Table structure for demo_teacher
-- ----------------------------
CREATE TABLE [dbo].[demo_teacher] (
[id] int NOT NULL IDENTITY(1,1) ,
[name] nvarchar(50) NOT NULL ,
[employee_id] nvarchar(20) NULL ,
[gender] tinyint NULL DEFAULT ((0)) ,
[phone] nvarchar(20) NULL ,
[email] nvarchar(100) NULL ,
[subject] nvarchar(50) NULL ,
[title] nvarchar(50) NULL ,
[status] tinyint NULL DEFAULT ((1)) ,
[hire_date] date NULL ,
[birth_date] date NULL ,
[created_at] datetime NULL ,
[updated_at] datetime NULL ,
[deleted_at] datetime NULL ,
[created_by] int NULL DEFAULT ((0)) 
)


GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'demo_teacher', 
NULL, NULL)) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'教师表'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_teacher'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'教师表'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_teacher'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'demo_teacher', 
'COLUMN', N'id')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'主键ID'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_teacher'
, @level2type = 'COLUMN', @level2name = N'id'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'主键ID'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_teacher'
, @level2type = 'COLUMN', @level2name = N'id'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'demo_teacher', 
'COLUMN', N'name')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'教师姓名'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_teacher'
, @level2type = 'COLUMN', @level2name = N'name'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'教师姓名'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_teacher'
, @level2type = 'COLUMN', @level2name = N'name'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'demo_teacher', 
'COLUMN', N'employee_id')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'工号'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_teacher'
, @level2type = 'COLUMN', @level2name = N'employee_id'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'工号'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_teacher'
, @level2type = 'COLUMN', @level2name = N'employee_id'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'demo_teacher', 
'COLUMN', N'gender')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'性别：0-未知 1-男 2-女'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_teacher'
, @level2type = 'COLUMN', @level2name = N'gender'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'性别：0-未知 1-男 2-女'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_teacher'
, @level2type = 'COLUMN', @level2name = N'gender'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'demo_teacher', 
'COLUMN', N'phone')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'手机号'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_teacher'
, @level2type = 'COLUMN', @level2name = N'phone'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'手机号'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_teacher'
, @level2type = 'COLUMN', @level2name = N'phone'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'demo_teacher', 
'COLUMN', N'email')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'邮箱'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_teacher'
, @level2type = 'COLUMN', @level2name = N'email'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'邮箱'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_teacher'
, @level2type = 'COLUMN', @level2name = N'email'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'demo_teacher', 
'COLUMN', N'subject')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'所教学科'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_teacher'
, @level2type = 'COLUMN', @level2name = N'subject'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'所教学科'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_teacher'
, @level2type = 'COLUMN', @level2name = N'subject'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'demo_teacher', 
'COLUMN', N'title')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'职称'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_teacher'
, @level2type = 'COLUMN', @level2name = N'title'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'职称'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_teacher'
, @level2type = 'COLUMN', @level2name = N'title'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'demo_teacher', 
'COLUMN', N'status')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'状态：0-离职 1-在职'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_teacher'
, @level2type = 'COLUMN', @level2name = N'status'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'状态：0-离职 1-在职'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_teacher'
, @level2type = 'COLUMN', @level2name = N'status'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'demo_teacher', 
'COLUMN', N'hire_date')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'入职日期'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_teacher'
, @level2type = 'COLUMN', @level2name = N'hire_date'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'入职日期'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_teacher'
, @level2type = 'COLUMN', @level2name = N'hire_date'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'demo_teacher', 
'COLUMN', N'birth_date')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'出生日期'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_teacher'
, @level2type = 'COLUMN', @level2name = N'birth_date'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'出生日期'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_teacher'
, @level2type = 'COLUMN', @level2name = N'birth_date'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'demo_teacher', 
'COLUMN', N'created_at')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'创建时间'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_teacher'
, @level2type = 'COLUMN', @level2name = N'created_at'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'创建时间'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_teacher'
, @level2type = 'COLUMN', @level2name = N'created_at'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'demo_teacher', 
'COLUMN', N'updated_at')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'更新时间'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_teacher'
, @level2type = 'COLUMN', @level2name = N'updated_at'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'更新时间'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_teacher'
, @level2type = 'COLUMN', @level2name = N'updated_at'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'demo_teacher', 
'COLUMN', N'deleted_at')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'删除时间'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_teacher'
, @level2type = 'COLUMN', @level2name = N'deleted_at'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'删除时间'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_teacher'
, @level2type = 'COLUMN', @level2name = N'deleted_at'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'demo_teacher', 
'COLUMN', N'created_by')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'创建人'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_teacher'
, @level2type = 'COLUMN', @level2name = N'created_by'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'创建人'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'demo_teacher'
, @level2type = 'COLUMN', @level2name = N'created_by'
GO

-- ----------------------------
-- Records of demo_teacher
-- ----------------------------
SET IDENTITY_INSERT [dbo].[demo_teacher] ON
GO
SET IDENTITY_INSERT [dbo].[demo_teacher] OFF
GO

-- ----------------------------
-- Table structure for example
-- ----------------------------
CREATE TABLE [dbo].[example] (
[id] int NOT NULL IDENTITY(1,1) ,
[name] nvarchar(255) NOT NULL ,
[description] nvarchar(255) NULL ,
[created_at] datetime NOT NULL ,
[updated_at] datetime NULL ,
[deleted_at] datetime NULL ,
[created_by] int NULL ,
[tenant_id] int NULL DEFAULT ((0)) 
)


GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'example', 
'COLUMN', N'name')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'名称'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'example'
, @level2type = 'COLUMN', @level2name = N'name'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'名称'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'example'
, @level2type = 'COLUMN', @level2name = N'name'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'example', 
'COLUMN', N'description')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'描述'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'example'
, @level2type = 'COLUMN', @level2name = N'description'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'描述'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'example'
, @level2type = 'COLUMN', @level2name = N'description'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'example', 
'COLUMN', N'tenant_id')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'租户ID字段'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'example'
, @level2type = 'COLUMN', @level2name = N'tenant_id'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'租户ID字段'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'example'
, @level2type = 'COLUMN', @level2name = N'tenant_id'
GO

-- ----------------------------
-- Records of example
-- ----------------------------
SET IDENTITY_INSERT [dbo].[example] ON
GO
SET IDENTITY_INSERT [dbo].[example] OFF
GO

-- ----------------------------
-- Table structure for sys_affix
-- ----------------------------
CREATE TABLE [dbo].[sys_affix] (
[id] int NOT NULL IDENTITY(1,1) ,
[name] nvarchar(255) NULL ,
[path] nvarchar(255) NULL ,
[url] nvarchar(255) NULL ,
[size] int NULL ,
[ftype] nvarchar(100) NULL ,
[created_at] datetime NULL ,
[updated_at] datetime NULL ,
[deleted_at] datetime NULL ,
[created_by] int NULL ,
[suffix] nvarchar(100) NULL ,
[tenant_id] int NULL DEFAULT ((0)) 
)


GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_affix', 
'COLUMN', N'id')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'ID'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_affix'
, @level2type = 'COLUMN', @level2name = N'id'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'ID'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_affix'
, @level2type = 'COLUMN', @level2name = N'id'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_affix', 
'COLUMN', N'name')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'文件名'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_affix'
, @level2type = 'COLUMN', @level2name = N'name'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'文件名'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_affix'
, @level2type = 'COLUMN', @level2name = N'name'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_affix', 
'COLUMN', N'path')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'路径'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_affix'
, @level2type = 'COLUMN', @level2name = N'path'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'路径'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_affix'
, @level2type = 'COLUMN', @level2name = N'path'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_affix', 
'COLUMN', N'url')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'文件url'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_affix'
, @level2type = 'COLUMN', @level2name = N'url'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'文件url'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_affix'
, @level2type = 'COLUMN', @level2name = N'url'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_affix', 
'COLUMN', N'size')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'文件大小'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_affix'
, @level2type = 'COLUMN', @level2name = N'size'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'文件大小'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_affix'
, @level2type = 'COLUMN', @level2name = N'size'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_affix', 
'COLUMN', N'ftype')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'文件类型'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_affix'
, @level2type = 'COLUMN', @level2name = N'ftype'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'文件类型'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_affix'
, @level2type = 'COLUMN', @level2name = N'ftype'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_affix', 
'COLUMN', N'suffix')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'文件后缀'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_affix'
, @level2type = 'COLUMN', @level2name = N'suffix'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'文件后缀'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_affix'
, @level2type = 'COLUMN', @level2name = N'suffix'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_affix', 
'COLUMN', N'tenant_id')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'租户ID字段'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_affix'
, @level2type = 'COLUMN', @level2name = N'tenant_id'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'租户ID字段'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_affix'
, @level2type = 'COLUMN', @level2name = N'tenant_id'
GO

-- ----------------------------
-- Records of sys_affix
-- ----------------------------
SET IDENTITY_INSERT [dbo].[sys_affix] ON
GO
SET IDENTITY_INSERT [dbo].[sys_affix] OFF
GO

-- ----------------------------
-- Table structure for sys_api
-- ----------------------------
CREATE TABLE [dbo].[sys_api] (
[id] int NOT NULL IDENTITY(1,1) ,
[title] nvarchar(255) NULL ,
[path] nvarchar(255) NULL ,
[method] nvarchar(32) NULL ,
[api_group] nvarchar(255) NULL ,
[created_at] datetime NULL ,
[updated_at] datetime NULL ,
[deleted_at] datetime NULL ,
[created_by] int NULL 
)


GO
DBCC CHECKIDENT(N'[dbo].[sys_api]', RESEED, 1005)
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_api', 
'COLUMN', N'title')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'权限名称'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_api'
, @level2type = 'COLUMN', @level2name = N'title'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'权限名称'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_api'
, @level2type = 'COLUMN', @level2name = N'title'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_api', 
'COLUMN', N'path')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'权限路径'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_api'
, @level2type = 'COLUMN', @level2name = N'path'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'权限路径'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_api'
, @level2type = 'COLUMN', @level2name = N'path'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_api', 
'COLUMN', N'method')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'请求方法'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_api'
, @level2type = 'COLUMN', @level2name = N'method'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'请求方法'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_api'
, @level2type = 'COLUMN', @level2name = N'method'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_api', 
'COLUMN', N'api_group')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'分组'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_api'
, @level2type = 'COLUMN', @level2name = N'api_group'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'分组'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_api'
, @level2type = 'COLUMN', @level2name = N'api_group'
GO

-- ----------------------------
-- Records of sys_api
-- ----------------------------
SET IDENTITY_INSERT [dbo].[sys_api] ON
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'1', N'用户登录', N'/api/login', N'POST', N'认证管理', N'2025-09-03 11:13:09.000', N'2025-09-03 11:13:09.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'2', N'刷新Token', N'/api/refreshToken', N'POST', N'认证管理', N'2025-09-03 11:13:09.000', N'2025-09-03 11:13:09.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'3', N'生成验证码ID', N'/api/captcha/id', N'GET', N'认证管理', N'2025-09-03 11:13:09.000', N'2025-09-03 11:13:09.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'4', N'获取验证码图片', N'/api/captcha/image', N'GET', N'认证管理', N'2025-09-03 11:13:09.000', N'2025-09-03 11:13:09.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'5', N'用户登出', N'/api/users/logout', N'POST', N'认证管理', N'2025-09-03 11:13:09.000', N'2025-09-03 11:13:09.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'6', N'获取当前用户信息', N'/api/users/profile', N'GET', N'用户管理', N'2025-09-03 11:13:09.000', N'2025-09-03 11:13:09.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'7', N'根据ID获取用户信息', N'/api/users/:id', N'GET', N'用户管理', N'2025-09-03 11:13:09.000', N'2025-09-03 11:13:09.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'8', N'用户列表', N'/api/users/list', N'GET', N'用户管理', N'2025-09-03 11:13:09.000', N'2025-09-03 11:13:09.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'9', N'新增用户', N'/api/users/add', N'POST', N'用户管理', N'2025-09-03 11:13:09.000', N'2025-09-03 11:13:09.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'10', N'更新用户信息', N'/api/users/edit', N'PUT', N'用户管理', N'2025-09-03 11:13:09.000', N'2025-09-03 11:13:09.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'11', N'删除用户', N'/api/users/delete', N'DELETE', N'用户管理', N'2025-09-03 11:13:09.000', N'2025-09-03 11:13:09.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'12', N'获取用户权限菜单', N'/api/sysMenu/getRouters', N'GET', N'菜单管理', N'2025-09-03 11:13:10.000', N'2025-09-03 11:13:10.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'13', N'获取完整菜单列表', N'/api/sysMenu/getMenuList', N'GET', N'菜单管理', N'2025-09-03 11:13:10.000', N'2025-09-03 11:13:10.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'14', N'根据ID获取菜单信息', N'/api/sysMenu/:id', N'GET', N'菜单管理', N'2025-09-03 11:13:10.000', N'2025-09-03 11:13:10.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'15', N'新增菜单', N'/api/sysMenu/add', N'POST', N'菜单管理', N'2025-09-03 11:13:10.000', N'2025-09-03 11:13:10.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'16', N'更新菜单', N'/api/sysMenu/edit', N'PUT', N'菜单管理', N'2025-09-03 11:13:10.000', N'2025-09-03 11:13:10.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'17', N'删除菜单', N'/api/sysMenu/delete', N'DELETE', N'菜单管理', N'2025-09-03 11:13:10.000', N'2025-09-03 11:13:10.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'18', N'获取部门列表', N'/api/sysDepartment/getDivision', N'GET', N'部门管理', N'2025-09-03 11:13:10.000', N'2025-09-03 11:13:10.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'19', N'获取所有角色数据', N'/api/sysRole/getRoles', N'GET', N'角色管理', N'2025-09-03 11:13:10.000', N'2025-09-03 11:13:10.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'20', N'根据角色ID获取角色菜单权限', N'/api/sysRole/getUserPermission/:roleId', N'GET', N'角色管理', N'2025-09-03 11:13:10.000', N'2025-09-03 11:13:10.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'21', N'添加角色的菜单权限', N'/api/sysRole/addRoleMenu', N'POST', N'角色管理', N'2025-09-03 11:13:10.000', N'2025-09-03 11:13:10.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'22', N'角色分页列表', N'/api/sysRole/list', N'GET', N'角色管理', N'2025-09-03 11:13:10.000', N'2025-09-03 11:13:10.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'23', N'根据ID获取角色信息', N'/api/sysRole/:id', N'GET', N'角色管理', N'2025-09-03 11:13:10.000', N'2025-09-03 11:13:10.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'24', N'新增角色', N'/api/sysRole/add', N'POST', N'角色管理', N'2025-09-03 11:13:10.000', N'2025-09-03 11:13:10.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'25', N'更新角色', N'/api/sysRole/edit', N'PUT', N'角色管理', N'2025-09-03 11:13:10.000', N'2025-09-03 11:13:10.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'26', N'删除角色', N'/api/sysRole/delete', N'DELETE', N'角色管理', N'2025-09-03 11:13:10.000', N'2025-09-03 11:13:10.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'27', N'获取所有字典数据', N'/api/sysDict/getAllDicts', N'GET', N'字典管理', N'2025-09-03 11:13:10.000', N'2025-09-03 11:13:10.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'28', N'根据字典编码获取字典', N'/api/sysDict/getByCode/:code', N'GET', N'字典管理', N'2025-09-03 11:13:10.000', N'2025-09-03 11:13:10.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'29', N'API列表', N'/api/sysApi/list', N'GET', N'API管理', N'2025-09-03 11:13:10.000', N'2025-09-03 11:13:10.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'30', N'根据ID获取API信息', N'/api/sysApi/:id', N'GET', N'API管理', N'2025-09-03 11:13:10.000', N'2025-09-03 11:13:10.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'31', N'新增API', N'/api/sysApi/add', N'POST', N'API管理', N'2025-09-03 11:13:10.000', N'2025-09-03 11:13:10.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'32', N'更新API', N'/api/sysApi/edit', N'PUT', N'API管理', N'2025-09-03 11:13:10.000', N'2025-09-03 11:13:10.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'33', N'删除API', N'/api/sysApi/delete', N'DELETE', N'API管理', N'2025-09-03 11:13:10.000', N'2025-09-03 11:13:10.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'34', N'测试11', N'/api/sysTest/test', N'POST', N'test', N'2025-09-03 11:14:23.000', N'2025-09-03 11:30:19.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'35', N'根据菜单ID获取API的ID集合', N'/api/sysMenu/apis/:id', N'GET', N'菜单管理', N'2025-09-04 17:25:14.000', N'2025-09-04 17:25:14.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'36', N'设置菜单API权限', N'/api/sysMenu/setApis', N'POST', N'菜单管理', N'2025-09-04 17:26:04.000', N'2025-09-04 17:26:04.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'37', N'根据ID获取部门信息', N'/api/sysDepartment/:id', N'GET', N'部门管理', N'2025-09-12 14:46:42.000', N'2025-09-12 14:46:42.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'38', N'新增部门', N'/api/sysDepartment/add', N'POST', N'部门管理', N'2025-09-12 14:47:27.000', N'2025-09-12 14:47:27.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'39', N'更新部门', N'/api/sysDepartment/edit', N'PUT', N'部门管理', N'2025-09-12 14:48:15.000', N'2025-09-12 14:48:27.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'40', N'删除部门', N'/api/sysDepartment/delete', N'DELETE', N'部门管理', N'2025-09-12 14:49:15.000', N'2025-09-12 14:49:15.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'41', N'字典分页列表', N'/api/sysDict/list', N'GET', N'字典管理', N'2025-09-16 16:31:15.000', N'2025-09-16 16:31:15.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'42', N'根据ID获取字典信息', N'/api/sysDict/:id', N'GET', N'字典管理', N'2025-09-16 16:31:15.000', N'2025-09-16 16:31:15.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'43', N'新增字典', N'/api/sysDict/add', N'POST', N'字典管理', N'2025-09-16 16:31:15.000', N'2025-09-16 16:31:15.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'44', N'更新字典', N'/api/sysDict/edit', N'PUT', N'字典管理', N'2025-09-16 16:31:15.000', N'2025-09-16 16:31:15.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'45', N'删除字典', N'/api/sysDict/delete', N'DELETE', N'字典管理', N'2025-09-16 16:31:15.000', N'2025-09-16 16:31:15.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'46', N'字典项列表', N'/api/sysDictItem/list', N'GET', N'字典项管理', N'2025-09-16 16:31:15.000', N'2025-09-16 16:31:15.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'47', N'根据ID获取字典项信息', N'/api/sysDictItem/:id', N'GET', N'字典项管理', N'2025-09-16 16:31:15.000', N'2025-09-16 16:31:15.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'48', N'根据字典ID获取字典项列表', N'/api/sysDictItem/getByDictId/:dictId', N'GET', N'字典项管理', N'2025-09-16 16:31:15.000', N'2025-09-16 16:31:15.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'49', N'根据字典编码获取字典项列表', N'/api/sysDictItem/getByDictCode/:dictCode', N'GET', N'字典项管理', N'2025-09-16 16:31:15.000', N'2025-09-16 16:31:15.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'50', N'新增字典项', N'/api/sysDictItem/add', N'POST', N'字典项管理', N'2025-09-16 16:31:15.000', N'2025-09-16 16:31:15.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'51', N'更新字典项', N'/api/sysDictItem/edit', N'PUT', N'字典项管理', N'2025-09-16 16:31:15.000', N'2025-09-16 16:31:15.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'52', N'删除字典项', N'/api/sysDictItem/delete', N'DELETE', N'字典项管理', N'2025-09-16 16:31:15.000', N'2025-09-16 16:31:15.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'53', N'修改用户密码、手机号及邮箱', N'/api/users/updateAccount', N'PUT', N'用户管理', N'2025-09-18 18:11:01.000', N'2025-09-18 18:11:01.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'54', N'头像上传', N'/api/users/uploadAvatar', N'POST', N'用户管理', N'2025-09-24 17:01:05.000', N'2025-09-24 17:01:05.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'55', N'上传文件', N'/api/sysAffix/upload', N'POST', N'文件管理', N'2025-09-25 15:51:04.000', N'2025-09-25 15:51:04.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'56', N'删除文件', N'/api/sysAffix/delete', N'DELETE', N'文件管理', N'2025-09-25 15:51:38.000', N'2025-09-25 15:51:38.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'57', N'修改文件名', N'/api/sysAffix/updateName', N'PUT', N'文件管理', N'2025-09-25 15:52:31.000', N'2025-09-25 15:52:31.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'58', N'文件列表', N'/api/sysAffix/list', N'GET', N'文件管理', N'2025-09-25 15:54:03.000', N'2025-09-25 15:54:03.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'59', N'获取文件详情', N'/api/sysAffix/:id', N'GET', N'文件管理', N'2025-09-25 15:54:55.000', N'2025-09-25 15:54:55.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'60', N'下载文件', N'/api/sysAffix/download/:id', N'GET', N'文件管理', N'2025-09-25 15:56:15.000', N'2025-09-25 15:58:06.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'61', N'设置数据权限', N'/api/sysRole/dataScope', N'PUT', N'角色管理', N'2025-09-26 17:04:15.000', N'2025-09-26 17:04:15.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'62', N'读取系统配置', N'/api/config/get', N'GET', N'系统配置', N'2025-10-09 16:21:29.000', N'2025-10-09 16:21:29.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'63', N'修改系统配置', N'/api/config/update', N'PUT', N'系统配置', N'2025-10-09 16:21:59.000', N'2025-10-09 16:22:09.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'64', N'查看内存缓存', N'/api/config/viewCache', N'GET', N'系统配置', N'2025-10-10 17:41:33.000', N'2025-10-10 17:41:33.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'65', N'列表查询', N'/api/plugins/example/list', N'GET', N'插件示例', N'2025-10-14 10:54:47.000', N'2025-10-14 10:54:47.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'66', N'新增', N'/api/plugins/example/add', N'POST', N'插件示例', N'2025-10-14 10:56:43.000', N'2025-10-14 10:56:43.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'67', N'修改', N'/api/plugins/example/edit', N'PUT', N'插件示例', N'2025-10-14 10:57:10.000', N'2025-10-14 10:57:17.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'68', N'删除', N'/api/plugins/example/delete', N'DELETE', N'插件示例', N'2025-10-14 10:58:03.000', N'2025-10-14 10:58:03.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'69', N'查询单条数据', N'/api/plugins/example/:id', N'GET', N'插件示例', N'2025-10-14 10:59:33.000', N'2025-10-14 10:59:33.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'70', N'日志列表', N'/api/sysOperationLog/list', N'GET', N'日志管理', N'2025-10-20 10:10:58.000', N'2025-10-20 10:10:58.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'71', N'日志统计', N'/api/sysOperationLog/stats', N'GET', N'日志管理', N'2025-10-20 10:12:01.000', N'2025-10-20 10:12:01.000', N'2025-10-20 10:45:07.000', N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'72', N'日志删除', N'/api/sysOperationLog/delete', N'DELETE', N'日志管理', N'2025-10-20 10:13:19.000', N'2025-10-20 10:13:19.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'73', N'日志导出', N'/api/sysOperationLog/export', N'GET', N'日志管理', N'2025-10-20 10:14:11.000', N'2025-10-20 10:14:11.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'74', N'导出菜单', N'/api/sysMenu/export', N'GET', N'菜单管理', N'2025-10-20 17:17:07.000', N'2025-10-20 17:17:07.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'75', N'导入菜单', N'/api/sysMenu/import', N'POST', N'菜单管理', N'2025-10-21 11:30:34.000', N'2025-10-24 08:59:44.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'76', N'租户列表', N'/api/sysTenant/list', N'GET', N'租户管理', N'2025-10-24 09:04:18.000', N'2025-10-24 09:04:18.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'77', N'根据ID获取租户信息', N'/api/sysTenant/:id', N'GET', N'租户管理', N'2025-10-24 09:05:23.000', N'2025-10-24 09:05:23.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'78', N'新增租户', N'/api/sysTenant/add', N'POST', N'租户管理', N'2025-10-24 09:06:10.000', N'2025-10-24 09:06:10.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'79', N'编辑租户', N'/api/sysTenant/edit', N'PUT', N'租户管理', N'2025-10-24 09:06:54.000', N'2025-10-24 09:06:54.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'80', N'删除租户', N'/api/sysTenant/:id', N'DELETE', N'租户管理', N'2025-10-24 09:07:47.000', N'2025-10-24 09:07:56.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'81', N'租户关联列表', N'/api/sysUserTenant/list', N'GET', N'租户管理', N'2025-10-27 17:51:52.000', N'2025-10-27 17:51:52.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'82', N'根据用户ID和租户ID获取用户租户关联信息', N'/api/sysUserTenant/get', N'GET', N'租户管理', N'2025-10-27 17:53:13.000', N'2025-10-27 17:53:13.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'83', N'批量新增用户租户关联', N'/api/sysUserTenant/batchAdd', N'POST', N'租户管理', N'2025-10-27 17:53:48.000', N'2025-10-27 17:53:48.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'84', N'批量删除用户租户关联', N'/api/sysUserTenant/batchDelete', N'DELETE', N'租户管理', N'2025-10-27 17:54:25.000', N'2025-10-27 17:54:25.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'85', N'用户列表(不限租户)', N'/api/sysUserTenant/userListAll', N'GET', N'用户管理', N'2025-10-28 09:41:19.000', N'2025-10-28 16:32:35.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'86', N'获取所有的角色数据(不限制租户)', N'/api/sysUserTenant/getRolesAll', N'GET', N'租户管理', N'2025-10-29 09:17:01.000', N'2025-10-29 09:17:01.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'87', N'设置用户角色(不限租户)', N'/api/sysUserTenant/setUserRoles', N'POST', N'租户管理 ', N'2025-10-29 09:17:50.000', N'2025-10-29 09:17:50.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'88', N'获取用户角色ID集合(不限租户)', N'/api/sysUserTenant/getUserRoleIDs', N'GET', N'租户管理', N'2025-10-29 09:18:51.000', N'2025-10-29 09:18:51.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'89', N'修改用户基本信息', N'/api/users/updateBasicInfo', N'PUT', N'用户管理', N'2025-10-31 09:05:00.000', N'2025-10-31 09:05:00.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'105', N'生成代码文件', N'/api/codegen/generate', N'POST', N'代码生成', N'2025-11-07 15:32:53.000', N'2025-11-07 15:32:53.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'106', N'获取表的字段信息', N'/api/codegen/columns', N'GET', N'代码生成', N'2025-11-07 15:33:52.000', N'2025-11-07 15:33:52.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'187', N'获取数据库列表', N'/api/codegen/databases', N'GET', N'代码生成', N'2025-11-17 15:12:26.000', N'2025-11-17 15:12:26.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'188', N'获取指定数据库中的表集合', N'/api/codegen/tables', N'GET', N'代码生成', N'2025-11-17 15:13:38.000', N'2025-11-17 15:13:38.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'189', N'代码预览', N'/api/codegen/preview', N'GET', N'代码生成', N'2025-11-17 15:14:25.000', N'2025-11-17 15:14:25.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'190', N'代码生成配置列表', N'/api/sysGen/list', N'GET', N'代码生成', N'2025-11-17 15:15:20.000', N'2025-11-17 15:15:20.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'191', N' 批量创建代码生成配置', N'/api/sysGen/batchInsert', N'POST', N'代码生成', N'2025-11-17 15:22:46.000', N'2025-11-17 15:22:46.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'192', N'获取代码生成配置详情', N'/api/sysGen/:id', N'GET', N'代码生成', N'2025-11-17 15:23:29.000', N'2025-11-17 15:23:29.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'193', N'更新代码生成配置和字段信息', N'/api/sysGen/update', N'PUT', N'代码生成', N'2025-11-17 15:24:41.000', N'2025-11-17 15:24:41.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'194', N'删除代码生成配置和字段信息', N'/api/sysGen/:id', N'DELETE', N'代码生成', N'2025-11-17 15:26:44.000', N'2025-11-17 15:26:44.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'195', N'刷新代码生成配置的字段信息', N'/api/sysGen/refreshFields', N'PUT', N'代码生成', N'2025-11-17 15:27:33.000', N'2025-11-17 15:27:33.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'196', N'生成菜单', N'/api/codegen/insertmenuandapi', N'POST', N'代码生成', N'2025-11-26 15:12:56.000', N'2025-11-26 15:12:56.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'197', N'批量删除', N'/api/sysMenu/batchDelete', N'DELETE', N'菜单管理', N'2025-12-05 17:48:52.000', N'2025-12-05 17:48:52.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'198', N'获取插件列表', N'/api/pluginsmanager/exports', N'GET', N'插件管理', N'2025-12-08 16:38:26.000', N'2025-12-08 16:38:26.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'199', N'导出插件', N'/api/pluginsmanager/export', N'POST', N'插件管理', N'2025-12-08 16:39:19.000', N'2025-12-08 16:44:36.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'200', N'导入插件', N'/api/pluginsmanager/import', N'POST', N'插件管理', N'2025-12-08 16:47:11.000', N'2025-12-08 16:47:11.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'201', N'卸载插件', N'/api/pluginsmanager/uninstall', N'DELETE', N'插件管理', N'2025-12-08 16:48:07.000', N'2025-12-08 16:48:07.000', null, N'1')
GO
GO
SET IDENTITY_INSERT [dbo].[sys_api] ON
GO
INSERT INTO [dbo].[sys_api] ([id], [title], [path], [method], [api_group], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'202', N'切换租户', N'/api/users/switchTenant/:tenantld', N'GET', N'用户管理', N'2026-01-09 16:29:37.000', N'2026-01-09 16:29:37.000', null, N'1')
GO
SET IDENTITY_INSERT [dbo].[sys_api] OFF
GO

-- ----------------------------
-- Table structure for sys_casbin_rule
-- ----------------------------
CREATE TABLE [dbo].[sys_casbin_rule] (
[id] int NOT NULL IDENTITY(1,1) ,
[ptype] nvarchar(100) NULL ,
[v0] nvarchar(100) NULL ,
[v1] nvarchar(100) NULL ,
[v2] nvarchar(100) NULL ,
[v3] nvarchar(100) NULL ,
[v4] nvarchar(100) NULL ,
[v5] nvarchar(100) NULL 
)


GO
DBCC CHECKIDENT(N'[dbo].[sys_casbin_rule]', RESEED, 90)
GO

-- ----------------------------
-- Records of sys_casbin_rule
-- ----------------------------
SET IDENTITY_INSERT [dbo].[sys_casbin_rule] ON
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'1', N'p', N'role_1', N'/api/sysDepartment/getDivision', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'2', N'p', N'role_1', N'/api/sysMenu/getMenuList', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'3', N'p', N'role_1', N'/api/sysRole/delete', N'DELETE', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'4', N'p', N'role_1', N'/api/sysMenu/delete', N'DELETE', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'5', N'p', N'role_1', N'/api/sysDict/add', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'6', N'p', N'role_1', N'/api/sysTenant/list', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7', N'p', N'role_1', N'/api/sysTenant/edit', N'PUT', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'8', N'p', N'role_1', N'/api/sysGen/*', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'9', N'p', N'role_1', N'/api/users/profile', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'10', N'p', N'role_1', N'/api/sysRole/getRoles', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'11', N'p', N'role_1', N'/api/sysRole/add', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'12', N'p', N'role_1', N'/api/sysMenu/apis/*', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'13', N'p', N'role_1', N'/api/sysDict/edit', N'PUT', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'14', N'p', N'role_1', N'/api/plugins/example/add', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'15', N'p', N'role_1', N'/api/sysTenant/add', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'16', N'p', N'role_1', N'/api/codegen/tables', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'17', N'p', N'role_1', N'/api/sysAffix/list', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'18', N'p', N'role_1', N'/api/sysAffix/download/*', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'19', N'p', N'role_1', N'/api/plugins/example/list', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'20', N'p', N'role_1', N'/api/sysUserTenant/getRolesAll', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'21', N'p', N'role_1', N'/api/sysUserTenant/getUserRoleIDs', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'22', N'p', N'role_1', N'/api/sysGen/batchInsert', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'23', N'p', N'role_1', N'/api/codegen/generate', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'24', N'p', N'role_1', N'/api/sysMenu/add', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'25', N'p', N'role_1', N'/api/sysDictItem/add', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'26', N'p', N'role_1', N'/api/sysDictItem/edit', N'PUT', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'27', N'p', N'role_1', N'/api/sysAffix/delete', N'DELETE', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'28', N'p', N'role_1', N'/api/config/viewCache', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'29', N'p', N'role_1', N'/api/plugins/example/edit', N'PUT', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'30', N'p', N'role_1', N'/api/sysOperationLog/export', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'31', N'p', N'role_1', N'/api/sysGen/list', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'32', N'p', N'role_1', N'/api/users/edit', N'PUT', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'33', N'p', N'role_1', N'/api/sysDictItem/delete', N'DELETE', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'34', N'p', N'role_1', N'/api/sysOperationLog/delete', N'DELETE', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'35', N'p', N'role_1', N'/api/sysGen/refreshFields', N'PUT', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'36', N'p', N'role_1', N'/api/pluginsmanager/import', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'37', N'p', N'role_1', N'/api/users/uploadAvatar', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'38', N'p', N'role_1', N'/api/users/add', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'39', N'p', N'role_1', N'/api/sysRole/edit', N'PUT', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'40', N'p', N'role_1', N'/api/config/update', N'PUT', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'41', N'p', N'role_1', N'/api/sysTenant/*', N'DELETE', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'42', N'p', N'role_1', N'/api/users/list', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'43', N'p', N'role_1', N'/api/sysDict/delete', N'DELETE', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'44', N'p', N'role_1', N'/api/users/updateAccount', N'PUT', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'45', N'p', N'role_1', N'/api/sysUserTenant/list', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'46', N'p', N'role_1', N'/api/pluginsmanager/exports', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'47', N'p', N'role_1', N'/api/pluginsmanager/export', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'48', N'p', N'role_1', N'/api/sysRole/addRoleMenu', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'49', N'p', N'role_1', N'/api/sysApi/edit', N'PUT', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'50', N'p', N'role_1', N'/api/sysDepartment/edit', N'PUT', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'51', N'p', N'role_1', N'/api/sysRole/dataScope', N'PUT', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'52', N'p', N'role_1', N'/api/plugins/example/*', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'53', N'p', N'role_1', N'/api/sysTenant/*', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'54', N'p', N'role_1', N'/api/sysDepartment/add', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'55', N'p', N'role_1', N'/api/sysDepartment/delete', N'DELETE', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'56', N'p', N'role_1', N'/api/sysDictItem/getByDictId/*', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'57', N'p', N'role_1', N'/api/sysUserTenant/get', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'58', N'p', N'role_1', N'/api/sysGen/*', N'DELETE', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'59', N'p', N'role_1', N'/api/sysMenu/edit', N'PUT', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'60', N'p', N'role_1', N'/api/sysMenu/import', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'61', N'p', N'role_1', N'/api/sysMenu/getRouters', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'62', N'p', N'role_1', N'/api/sysDict/list', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'63', N'p', N'role_1', N'/api/sysApi/list', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'64', N'p', N'role_1', N'/api/sysRole/getUserPermission/*', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'65', N'p', N'role_1', N'/api/sysApi/add', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'66', N'p', N'role_1', N'/api/sysAffix/updateName', N'PUT', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'67', N'p', N'role_1', N'/api/codegen/preview', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'68', N'p', N'role_1', N'/api/users/logout', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'69', N'p', N'role_1', N'/api/sysDict/getAllDicts', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'70', N'p', N'role_1', N'/api/sysOperationLog/list', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'71', N'p', N'role_1', N'/api/sysApi/*', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'72', N'p', N'role_1', N'/api/sysApi/delete', N'DELETE', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'73', N'p', N'role_1', N'/api/sysUserTenant/batchDelete', N'DELETE', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'74', N'p', N'role_1', N'/api/sysUserTenant/userListAll', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'75', N'p', N'role_1', N'/api/sysGen/update', N'PUT', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'76', N'p', N'role_1', N'/api/sysMenu/batchDelete', N'DELETE', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'77', N'p', N'role_1', N'/api/sysMenu/setApis', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'78', N'p', N'role_1', N'/api/config/get', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'79', N'p', N'role_1', N'/api/pluginsmanager/uninstall', N'DELETE', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'80', N'p', N'role_1', N'/api/users/delete', N'DELETE', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'81', N'p', N'role_1', N'/api/plugins/example/delete', N'DELETE', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'82', N'p', N'role_1', N'/api/users/updateBasicInfo', N'PUT', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'83', N'p', N'role_1', N'/api/users/*', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'84', N'p', N'role_1', N'/api/sysAffix/upload', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'85', N'p', N'role_1', N'/api/sysMenu/export', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'86', N'p', N'role_1', N'/api/sysUserTenant/batchAdd', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'87', N'p', N'role_1', N'/api/sysUserTenant/setUserRoles', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'88', N'p', N'role_1', N'/api/codegen/insertmenuandapi', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'90', N'g', N'user_1', N'role_1', N'*', N'', N'', N'')
GO
GO
SET IDENTITY_INSERT [dbo].[sys_casbin_rule] ON
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'4189', N'g', N'user_4', N'role_2', N'*', N'', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7118', N'p', N'role_2', N'/api/codegen/generate', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7132', N'p', N'role_2', N'/api/codegen/insertmenuandapi', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7183', N'p', N'role_2', N'/api/codegen/preview', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7117', N'p', N'role_2', N'/api/codegen/tables', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7129', N'p', N'role_2', N'/api/config/get', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7163', N'p', N'role_2', N'/api/config/update', N'PUT', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7188', N'p', N'role_2', N'/api/config/viewCache', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7130', N'p', N'role_2', N'/api/plugins/example/:id', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7147', N'p', N'role_2', N'/api/plugins/example/add', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7156', N'p', N'role_2', N'/api/plugins/example/delete', N'DELETE', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7155', N'p', N'role_2', N'/api/plugins/example/edit', N'PUT', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7149', N'p', N'role_2', N'/api/plugins/example/list', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7152', N'p', N'role_2', N'/api/pluginsmanager/export', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7126', N'p', N'role_2', N'/api/pluginsmanager/exports', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7136', N'p', N'role_2', N'/api/pluginsmanager/import', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7198', N'p', N'role_2', N'/api/pluginsmanager/uninstall', N'DELETE', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7196', N'p', N'role_2', N'/api/sysAffix/delete', N'DELETE', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7140', N'p', N'role_2', N'/api/sysAffix/download/:id', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7115', N'p', N'role_2', N'/api/sysAffix/list', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7162', N'p', N'role_2', N'/api/sysAffix/updateName', N'PUT', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7154', N'p', N'role_2', N'/api/sysAffix/upload', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7121', N'p', N'role_2', N'/api/sysApi/:id', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7128', N'p', N'role_2', N'/api/sysApi/add', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7187', N'p', N'role_2', N'/api/sysApi/delete', N'DELETE', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7145', N'p', N'role_2', N'/api/sysApi/edit', N'PUT', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7144', N'p', N'role_2', N'/api/sysApi/list', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7139', N'p', N'role_2', N'/api/sysDepartment/add', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7170', N'p', N'role_2', N'/api/sysDepartment/delete', N'DELETE', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7122', N'p', N'role_2', N'/api/sysDepartment/edit', N'PUT', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7173', N'p', N'role_2', N'/api/sysDepartment/getDivision', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7195', N'p', N'role_2', N'/api/sysDict/add', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7123', N'p', N'role_2', N'/api/sysDict/delete', N'DELETE', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7133', N'p', N'role_2', N'/api/sysDict/edit', N'PUT', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7119', N'p', N'role_2', N'/api/sysDict/getAllDicts', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7191', N'p', N'role_2', N'/api/sysDict/list', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7146', N'p', N'role_2', N'/api/sysDictItem/add', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7181', N'p', N'role_2', N'/api/sysDictItem/delete', N'DELETE', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7202', N'p', N'role_2', N'/api/sysDictItem/edit', N'PUT', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7134', N'p', N'role_2', N'/api/sysDictItem/getByDictId/:dictId', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7148', N'p', N'role_2', N'/api/sysGen/:id', N'DELETE', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7143', N'p', N'role_2', N'/api/sysGen/:id', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7197', N'p', N'role_2', N'/api/sysGen/batchInsert', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7135', N'p', N'role_2', N'/api/sysGen/list', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7169', N'p', N'role_2', N'/api/sysGen/refreshFields', N'PUT', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7172', N'p', N'role_2', N'/api/sysGen/update', N'PUT', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7194', N'p', N'role_2', N'/api/sysMenu/add', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7180', N'p', N'role_2', N'/api/sysMenu/apis/:id', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7186', N'p', N'role_2', N'/api/sysMenu/batchDelete', N'DELETE', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7175', N'p', N'role_2', N'/api/sysMenu/delete', N'DELETE', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7114', N'p', N'role_2', N'/api/sysMenu/edit', N'PUT', N'*', N'', N'')
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7141', N'p', N'role_2', N'/api/sysMenu/export', N'GET', N'*', N'', N'')
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7201', N'p', N'role_2', N'/api/sysMenu/getMenuList', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7184', N'p', N'role_2', N'/api/sysMenu/getRouters', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7131', N'p', N'role_2', N'/api/sysMenu/import', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7138', N'p', N'role_2', N'/api/sysMenu/setApis', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7189', N'p', N'role_2', N'/api/sysOperationLog/delete', N'DELETE', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7182', N'p', N'role_2', N'/api/sysOperationLog/export', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7120', N'p', N'role_2', N'/api/sysOperationLog/list', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7137', N'p', N'role_2', N'/api/sysRole/add', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7179', N'p', N'role_2', N'/api/sysRole/addRoleMenu', N'POST', N'*', '', N'')
GO
GO
INSERT INTO [Ndbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7176', N'p', N'role_2', N'/api/sysRole/dataScope', N'PUT', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7166', N'p', N'role_2', N'/api/sysRole/delete', N'DELETE', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7127', N'p', N'role_2', N'/api/sysRole/edit', N'PUT', N'*', N'', N'')
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7161', N'p', N'role_2', N'/api/sysRole/getRoles', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7174', N'p', N'role_2', N'/api/sysRole/getUserPermission/:roleId', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7190', N'p', N'role_2', N'/api/sysTenant/:id', N'DELETE', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7167', N'p', N'role_2', N'/api/sysTenant/:id', N'GET', N'*', N'', N'')
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7150', N'p', N'role_2', N'/api/sysTenant/add', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7164', N'p', N'role_2', N'/api/sysTenant/edit', N'PUT', N'*', N'', N'')
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7124', N'p', N'role_2', N'/api/sysTenant/list', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7151', N'p', N'role_2', N'/api/sysUserTenant/batchAdd', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7168', N'p', N'role_2', N'/api/sysUserTenant/batchDelete', N'DELETE', N'*', N'', N'')
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7177', N'p', N'role_2', N'/api/sysUserTenant/get', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7171', N'p', N'role_2', N'/api/sysUserTenant/getRolesAll', N'GET', N'*', N'', N'')
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7116', N'p', N'role_2', N'/api/sysUserTenant/getUserRoleIDs', N'GET', N'*', N'', N'')
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7125', N'p', N'role_2', N'/api/sysUserTenant/list', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7178', N'p', N'role_2', N'/api/sysUserTenant/setUserRoles', N'POST', N'*', N'', N'')
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7142', N'p', N'role_2', N'/api/sysUserTenant/userListAll', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7158', N'p', N'role_2', N'/api/users/:id', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7185', N'p', N'role_2', N'/api/users/add', N'POST', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7193', N'p', N'role_2', N'/api/users/delete', N'DELETE', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7192', N'p', N'role_2', N'/api/users/edit', N'PUT', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7153', N'p', N'role_2', N'/api/users/list', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7199', N'p', N'role_2', N'/api/users/logout', N'POST', N'*', N'', N'')
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7200', N'p', N'role_2', N'/api/users/profile', N'GET', N'*', N'', N'')
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7160', N'p', N'role_2', N'/api/users/switchTenant/:tenantld', N'GET', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7157', N'p', N'role_2', N'/api/users/updateAccount', N'PUT', N'*', N'', N'')
GO
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7165', N'p', N'role_2', N'/api/users/updateBasicInfo', N'PUT', N'*', N'', N'')
GO
INSERT INTO [dbo].[sys_casbin_rule] ([id], [ptype], [v0], [v1], [v2], [v3], [v4], [v5]) VALUES (N'7159', N'p', N'role_2', N'/api/users/uploadAvatar', N'POST', N'*', N'', N'')
GO
GO
SET IDENTITY_INSERT [dbo].[sys_casbin_rule] OFF
GO

-- ----------------------------
-- Table structure for sys_department
-- ----------------------------
CREATE TABLE [dbo].[sys_department] (
[id] int NOT NULL IDENTITY(1,1) ,
[parent_id] int NULL DEFAULT ((0)) ,
[name] nvarchar(255) NULL ,
[status] tinyint NULL ,
[leader] nvarchar(255) NULL ,
[phone] nvarchar(255) NULL ,
[email] nvarchar(255) NULL ,
[sort] int NULL DEFAULT ((0)) ,
[describe] nvarchar(255) NULL ,
[created_at] datetime NULL ,
[updated_at] datetime NULL ,
[deleted_at] datetime NULL ,
[created_by] int NULL ,
[tenant_id] int NULL DEFAULT ((0)) 
)


GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_department', 
'COLUMN', N'parent_id')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'父级'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_department'
, @level2type = 'COLUMN', @level2name = N'parent_id'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'父级'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_department'
, @level2type = 'COLUMN', @level2name = N'parent_id'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_department', 
'COLUMN', N'name')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'部门名称'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_department'
, @level2type = 'COLUMN', @level2name = N'name'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'部门名称'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_department'
, @level2type = 'COLUMN', @level2name = N'name'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_department', 
'COLUMN', N'status')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'状态： 0 停用 1 启用'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_department'
, @level2type = 'COLUMN', @level2name = N'status'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'状态： 0 停用 1 启用'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_department'
, @level2type = 'COLUMN', @level2name = N'status'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_department', 
'COLUMN', N'leader')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'负责人'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_department'
, @level2type = 'COLUMN', @level2name = N'leader'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'负责人'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_department'
, @level2type = 'COLUMN', @level2name = N'leader'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_department', 
'COLUMN', N'phone')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'联系电话'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_department'
, @level2type = 'COLUMN', @level2name = N'phone'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'联系电话'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_department'
, @level2type = 'COLUMN', @level2name = N'phone'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_department', 
'COLUMN', N'email')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'邮箱'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_department'
, @level2type = 'COLUMN', @level2name = N'email'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'邮箱'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_department'
, @level2type = 'COLUMN', @level2name = N'email'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_department', 
'COLUMN', N'sort')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'排序'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_department'
, @level2type = 'COLUMN', @level2name = N'sort'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'排序'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_department'
, @level2type = 'COLUMN', @level2name = N'sort'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_department', 
'COLUMN', N'describe')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'描述'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_department'
, @level2type = 'COLUMN', @level2name = N'describe'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'描述'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_department'
, @level2type = 'COLUMN', @level2name = N'describe'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_department', 
'COLUMN', N'tenant_id')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'租户ID字段'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_department'
, @level2type = 'COLUMN', @level2name = N'tenant_id'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'租户ID字段'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_department'
, @level2type = 'COLUMN', @level2name = N'tenant_id'
GO

-- ----------------------------
-- Records of sys_department
-- ----------------------------
SET IDENTITY_INSERT [dbo].[sys_department] ON
GO
SET IDENTITY_INSERT [dbo].[sys_department] OFF
GO

-- ----------------------------
-- Table structure for sys_dict
-- ----------------------------
CREATE TABLE [dbo].[sys_dict] (
[id] int NOT NULL IDENTITY(1,1) ,
[name] nvarchar(255) NULL ,
[code] nvarchar(255) NULL ,
[status] tinyint NULL ,
[description] nvarchar(500) NULL ,
[created_at] datetime NULL ,
[updated_at] datetime NULL ,
[deleted_at] datetime NULL ,
[created_by] int NULL 
)


GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_dict', 
'COLUMN', N'id')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'ID'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_dict'
, @level2type = 'COLUMN', @level2name = N'id'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'ID'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_dict'
, @level2type = 'COLUMN', @level2name = N'id'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_dict', 
'COLUMN', N'name')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'字典名称'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_dict'
, @level2type = 'COLUMN', @level2name = N'name'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'字典名称'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_dict'
, @level2type = 'COLUMN', @level2name = N'name'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_dict', 
'COLUMN', N'code')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'字典编码'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_dict'
, @level2type = 'COLUMN', @level2name = N'code'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'字典编码'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_dict'
, @level2type = 'COLUMN', @level2name = N'code'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_dict', 
'COLUMN', N'status')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'状态'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_dict'
, @level2type = 'COLUMN', @level2name = N'status'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'状态'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_dict'
, @level2type = 'COLUMN', @level2name = N'status'
GO

-- ----------------------------
-- Records of sys_dict
-- ----------------------------
SET IDENTITY_INSERT [dbo].[sys_dict] ON
GO
SET IDENTITY_INSERT [dbo].[sys_dict] OFF
GO

-- ----------------------------
-- Table structure for sys_dict_item
-- ----------------------------

CREATE TABLE [dbo].[sys_dict_item] (
[id] int NOT NULL IDENTITY(1,1) ,
[name] nvarchar(255) NULL ,
[value] nvarchar(255) NULL ,
[status] tinyint NULL ,
[dict_id] int NULL 
)


GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_dict_item', 
'COLUMN', N'status')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'状态'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_dict_item'
, @level2type = 'COLUMN', @level2name = N'status'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'状态'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_dict_item'
, @level2type = 'COLUMN', @level2name = N'status'
GO

-- ----------------------------
-- Records of sys_dict_item
-- ----------------------------
SET IDENTITY_INSERT [dbo].[sys_dict_item] ON
GO
SET IDENTITY_INSERT [dbo].[sys_dict_item] OFF
GO

-- ----------------------------
-- Table structure for sys_gen
-- ----------------------------

CREATE TABLE [dbo].[sys_gen] (
[id] int NOT NULL IDENTITY(1,1) ,
[db_type] nvarchar(255) NULL ,
[database] nvarchar(255) NULL ,
[name] nvarchar(255) NULL ,
[module_name] nvarchar(255) NULL ,
[file_name] nvarchar(255) NULL ,
[describe] nvarchar(1000) NULL ,
[created_at] datetime NULL ,
[updated_at] datetime NULL ,
[deleted_at] datetime NULL ,
[created_by] int NULL ,
[is_cover] tinyint NULL DEFAULT ((0)) ,
[is_menu] tinyint NULL DEFAULT ((0)) 
)


GO
DBCC CHECKIDENT(N'[dbo].[sys_gen]', RESEED, 2)
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_gen', 
'COLUMN', N'id')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'ID'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen'
, @level2type = 'COLUMN', @level2name = N'id'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'ID'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen'
, @level2type = 'COLUMN', @level2name = N'id'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_gen', 
'COLUMN', N'db_type')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'数据库类型'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen'
, @level2type = 'COLUMN', @level2name = N'db_type'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'数据库类型'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen'
, @level2type = 'COLUMN', @level2name = N'db_type'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_gen', 
'COLUMN', N'database')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'数据库'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen'
, @level2type = 'COLUMN', @level2name = N'database'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'数据库'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen'
, @level2type = 'COLUMN', @level2name = N'database'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_gen', 
'COLUMN', N'name')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'数据库表名'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen'
, @level2type = 'COLUMN', @level2name = N'name'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'数据库表名'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen'
, @level2type = 'COLUMN', @level2name = N'name'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_gen', 
'COLUMN', N'module_name')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'模块名称'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen'
, @level2type = 'COLUMN', @level2name = N'module_name'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'模块名称'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen'
, @level2type = 'COLUMN', @level2name = N'module_name'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_gen', 
'COLUMN', N'file_name')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'文件名称'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen'
, @level2type = 'COLUMN', @level2name = N'file_name'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'文件名称'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen'
, @level2type = 'COLUMN', @level2name = N'file_name'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_gen', 
'COLUMN', N'describe')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'描述'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen'
, @level2type = 'COLUMN', @level2name = N'describe'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'描述'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen'
, @level2type = 'COLUMN', @level2name = N'describe'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_gen', 
'COLUMN', N'created_at')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'创建时间'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen'
, @level2type = 'COLUMN', @level2name = N'created_at'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'创建时间'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen'
, @level2type = 'COLUMN', @level2name = N'created_at'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_gen', 
'COLUMN', N'updated_at')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'修改时间'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen'
, @level2type = 'COLUMN', @level2name = N'updated_at'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'修改时间'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen'
, @level2type = 'COLUMN', @level2name = N'updated_at'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_gen', 
'COLUMN', N'deleted_at')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'删除时间'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen'
, @level2type = 'COLUMN', @level2name = N'deleted_at'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'删除时间'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen'
, @level2type = 'COLUMN', @level2name = N'deleted_at'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_gen', 
'COLUMN', N'created_by')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'创建人'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen'
, @level2type = 'COLUMN', @level2name = N'created_by'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'创建人'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen'
, @level2type = 'COLUMN', @level2name = N'created_by'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_gen', 
'COLUMN', N'is_cover')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'是否覆盖'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen'
, @level2type = 'COLUMN', @level2name = N'is_cover'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'是否覆盖'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen'
, @level2type = 'COLUMN', @level2name = N'is_cover'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_gen', 
'COLUMN', N'is_menu')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'是否生成菜单'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen'
, @level2type = 'COLUMN', @level2name = N'is_menu'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'是否生成菜单'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen'
, @level2type = 'COLUMN', @level2name = N'is_menu'
GO

-- ----------------------------
-- Records of sys_gen
-- ----------------------------
SET IDENTITY_INSERT [dbo].[sys_gen] ON
GO
INSERT INTO [dbo].[sys_gen] ([id], [db_type], [database], [name], [module_name], [file_name], [describe], [created_at], [updated_at], [deleted_at], [created_by], [is_cover], [is_menu]) VALUES (N'1', N'sqlserver', N'ginfast', N'demo_students', N'demo_school', N'demo_students', N'学员管理', N'2025-12-10 10:19:37.000', N'2025-12-10 10:28:28.527', null, N'1', N'1', N'1')
GO
GO
INSERT INTO [dbo].[sys_gen] ([id], [db_type], [database], [name], [module_name], [file_name], [describe], [created_at], [updated_at], [deleted_at], [created_by], [is_cover], [is_menu]) VALUES (N'2', N'sqlserver', N'ginfast', N'demo_teacher', N'demo_teacher', N'demo_teacher', N'教师表', N'2025-12-10 10:19:37.000', N'2025-12-10 10:19:37.000', null, N'1', N'1', N'1')
GO
GO
SET IDENTITY_INSERT [dbo].[sys_gen] OFF
GO

-- ----------------------------
-- Table structure for sys_gen_field
-- ----------------------------

CREATE TABLE [dbo].[sys_gen_field] (
[id] int NOT NULL IDENTITY(1,1) ,
[gen_id] int NULL ,
[data_name] nvarchar(255) NULL ,
[data_type] nvarchar(255) NULL ,
[data_comment] nvarchar(255) NULL ,
[data_extra] nvarchar(255) NULL ,
[data_column_key] nvarchar(255) NULL ,
[data_unsigned] tinyint NULL DEFAULT ((0)) ,
[is_primary] tinyint NULL DEFAULT ((0)) ,
[go_type] nvarchar(255) NULL ,
[front_type] nvarchar(255) NULL ,
[custom_name] nvarchar(255) NULL DEFAULT '' ,
[require] tinyint NULL DEFAULT ((0)) ,
[list_show] tinyint NULL DEFAULT ((0)) ,
[form_show] tinyint NULL DEFAULT ((0)) ,
[query_show] tinyint NULL DEFAULT ((0)) ,
[query_type] nvarchar(255) NULL ,
[form_type] nvarchar(255) NULL ,
[dict_type] nvarchar(255) NULL ,
[gorm_tag] nvarchar(255) NULL 
)


GO
DBCC CHECKIDENT(N'[dbo].[sys_gen_field]', RESEED, 29)
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_gen_field', 
'COLUMN', N'data_name')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'列名'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'data_name'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'列名'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'data_name'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_gen_field', 
'COLUMN', N'data_type')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'数据类型'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'data_type'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'数据类型'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'data_type'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_gen_field', 
'COLUMN', N'data_comment')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'列注释'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'data_comment'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'列注释'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'data_comment'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_gen_field', 
'COLUMN', N'data_extra')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'额外信息'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'data_extra'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'额外信息'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'data_extra'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_gen_field', 
'COLUMN', N'data_column_key')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'列键信息'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'data_column_key'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'列键信息'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'data_column_key'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_gen_field', 
'COLUMN', N'data_unsigned')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'是否为无符号类型'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'data_unsigned'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'是否为无符号类型'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'data_unsigned'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_gen_field', 
'COLUMN', N'is_primary')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'是否主键'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'is_primary'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'是否主键'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'is_primary'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_gen_field', 
'COLUMN', N'go_type')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'go类型'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'go_type'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'go类型'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'go_type'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_gen_field', 
'COLUMN', N'front_type')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'前端类型'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'front_type'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'前端类型'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'front_type'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_gen_field', 
'COLUMN', N'custom_name')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'自定义字段名称'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'custom_name'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'自定义字段名称'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'custom_name'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_gen_field', 
'COLUMN', N'require')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'是否必填'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'require'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'是否必填'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'require'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_gen_field', 
'COLUMN', N'list_show')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'列表显示'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'list_show'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'列表显示'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'list_show'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_gen_field', 
'COLUMN', N'form_show')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'表单显示'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'form_show'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'表单显示'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'form_show'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_gen_field', 
'COLUMN', N'query_show')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'查询显示'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'query_show'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'查询显示'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'query_show'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_gen_field', 
'COLUMN', N'query_type')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'查询方式\r\nEQ  等于\r\nNE 不等于\r\nGT 大于\r\nGTE 大于等于\r\nLT 小于\r\nLTE 小于等于\r\nLIKE 包含\r\nBETWEEN 范围'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'query_type'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'查询方式\r\nEQ  等于\r\nNE 不等于\r\nGT 大于\r\nGTE 大于等于\r\nLT 小于\r\nLTE 小于等于\r\nLIKE 包含\r\nBETWEEN 范围'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'query_type'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_gen_field', 
'COLUMN', N'form_type')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'表单类型\r\ninput 文本框\r\ntextarea 文本域\r\nnumber 数字输入框\r\nselect 下拉框\r\nradio 单选框\r\ncheckbox 复选框\r\ndatetime 日期时间'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'form_type'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'表单类型\r\ninput 文本框\r\ntextarea 文本域\r\nnumber 数字输入框\r\nselect 下拉框\r\nradio 单选框\r\ncheckbox 复选框\r\ndatetime 日期时间'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'form_type'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_gen_field', 
'COLUMN', N'dict_type')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'关联的字典'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'dict_type'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'关联的字典'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'dict_type'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_gen_field', 
'COLUMN', N'gorm_tag')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'gorm标签'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'gorm_tag'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'gorm标签'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_gen_field'
, @level2type = 'COLUMN', @level2name = N'gorm_tag'
GO

-- ----------------------------
-- Records of sys_gen_field
-- ----------------------------
SET IDENTITY_INSERT [dbo].[sys_gen_field] ON
GO
INSERT INTO [dbo].[sys_gen_field] ([id], [gen_id], [data_name], [data_type], [data_comment], [data_extra], [data_column_key], [data_unsigned], [is_primary], [go_type], [front_type], [custom_name], [require], [list_show], [form_show], [query_show], [query_type], [form_type], [dict_type], [gorm_tag]) VALUES (N'1', N'1', N'student_id', N'int', N'', N'', N'PRI', N'0', N'1', N'int', N'number', N'student_id', N'1', N'1', N'1', N'1', N'', N'', N'', N'column:student_id;primaryKey;not null')
GO
GO
INSERT INTO [dbo].[sys_gen_field] ([id], [gen_id], [data_name], [data_type], [data_comment], [data_extra], [data_column_key], [data_unsigned], [is_primary], [go_type], [front_type], [custom_name], [require], [list_show], [form_show], [query_show], [query_type], [form_type], [dict_type], [gorm_tag]) VALUES (N'2', N'1', N'student_name', N'nvarchar', N'姓名', N'', N'', N'0', N'0', N'string', N'string', N'student_name', N'1', N'1', N'1', N'1', N'', N'select', N'', N'column:student_name;not null')
GO
GO
INSERT INTO [dbo].[sys_gen_field] ([id], [gen_id], [data_name], [data_type], [data_comment], [data_extra], [data_column_key], [data_unsigned], [is_primary], [go_type], [front_type], [custom_name], [require], [list_show], [form_show], [query_show], [query_type], [form_type], [dict_type], [gorm_tag]) VALUES (N'3', N'1', N'age', N'int', N'年龄', N'', N'', N'0', N'0', N'int', N'number', N'age', N'1', N'1', N'1', N'1', N'', N'number', N'', N'column:age;not null;default:((18))')
GO
GO
INSERT INTO [dbo].[sys_gen_field] ([id], [gen_id], [data_name], [data_type], [data_comment], [data_extra], [data_column_key], [data_unsigned], [is_primary], [go_type], [front_type], [custom_name], [require], [list_show], [form_show], [query_show], [query_type], [form_type], [dict_type], [gorm_tag]) VALUES (N'4', N'1', N'gender', N'nvarchar', N'性别', N'', N'', N'0', N'0', N'string', N'string', N'gender', N'1', N'1', N'1', N'1', N'', N'', N'', N'column:gender;not null;default:('''')')
GO
GO
INSERT INTO [dbo].[sys_gen_field] ([id], [gen_id], [data_name], [data_type], [data_comment], [data_extra], [data_column_key], [data_unsigned], [is_primary], [go_type], [front_type], [custom_name], [require], [list_show], [form_show], [query_show], [query_type], [form_type], [dict_type], [gorm_tag]) VALUES (N'5', N'1', N'class_name', N'nvarchar', N'班级名称', N'', N'', N'0', N'0', N'string', N'string', N'class_name', N'1', N'1', N'1', N'1', N'', N'', N'', N'column:class_name;not null')
GO
GO
INSERT INTO [dbo].[sys_gen_field] ([id], [gen_id], [data_name], [data_type], [data_comment], [data_extra], [data_column_key], [data_unsigned], [is_primary], [go_type], [front_type], [custom_name], [require], [list_show], [form_show], [query_show], [query_type], [form_type], [dict_type], [gorm_tag]) VALUES (N'6', N'1', N'admission_date', N'datetime', N'入学日期', N'', N'', N'0', N'0', N'time.Time', N'string', N'admission_date', N'1', N'1', N'1', N'1', N'', N'', N'', N'column:admission_date;not null')
GO
GO
INSERT INTO [dbo].[sys_gen_field] ([id], [gen_id], [data_name], [data_type], [data_comment], [data_extra], [data_column_key], [data_unsigned], [is_primary], [go_type], [front_type], [custom_name], [require], [list_show], [form_show], [query_show], [query_type], [form_type], [dict_type], [gorm_tag]) VALUES (N'7', N'1', N'email', N'nvarchar', N'邮箱', N'', N'', N'0', N'0', N'string', N'string', N'email', N'1', N'1', N'1', N'1', N'', N'', N'', N'column:email')
GO
GO
INSERT INTO [dbo].[sys_gen_field] ([id], [gen_id], [data_name], [data_type], [data_comment], [data_extra], [data_column_key], [data_unsigned], [is_primary], [go_type], [front_type], [custom_name], [require], [list_show], [form_show], [query_show], [query_type], [form_type], [dict_type], [gorm_tag]) VALUES (N'8', N'1', N'phone', N'nvarchar', N'电话号码', N'', N'', N'0', N'0', N'string', N'string', N'phone', N'1', N'1', N'1', N'1', N'', N'', N'', N'column:phone')
GO
GO
INSERT INTO [dbo].[sys_gen_field] ([id], [gen_id], [data_name], [data_type], [data_comment], [data_extra], [data_column_key], [data_unsigned], [is_primary], [go_type], [front_type], [custom_name], [require], [list_show], [form_show], [query_show], [query_type], [form_type], [dict_type], [gorm_tag]) VALUES (N'9', N'1', N'address', N'nvarchar', N'地址', N'', N'', N'0', N'0', N'string', N'string', N'address', N'1', N'1', N'1', N'1', N'', N'', N'', N'column:address')
GO
GO
INSERT INTO [dbo].[sys_gen_field] ([id], [gen_id], [data_name], [data_type], [data_comment], [data_extra], [data_column_key], [data_unsigned], [is_primary], [go_type], [front_type], [custom_name], [require], [list_show], [form_show], [query_show], [query_type], [form_type], [dict_type], [gorm_tag]) VALUES (N'10', N'1', N'created_at', N'datetime', N'创建时间', N'', N'', N'0', N'0', N'time.Time', N'string', N'created_at', null, null, null, null, N'', N'', N'', N'column:created_at')
GO
GO
INSERT INTO [dbo].[sys_gen_field] ([id], [gen_id], [data_name], [data_type], [data_comment], [data_extra], [data_column_key], [data_unsigned], [is_primary], [go_type], [front_type], [custom_name], [require], [list_show], [form_show], [query_show], [query_type], [form_type], [dict_type], [gorm_tag]) VALUES (N'11', N'1', N'updated_at', N'datetime', N'更新时间', N'', N'', N'0', N'0', N'time.Time', N'string', N'updated_at', null, null, null, null, N'', N'', N'', N'column:updated_at')
GO
GO
INSERT INTO [dbo].[sys_gen_field] ([id], [gen_id], [data_name], [data_type], [data_comment], [data_extra], [data_column_key], [data_unsigned], [is_primary], [go_type], [front_type], [custom_name], [require], [list_show], [form_show], [query_show], [query_type], [form_type], [dict_type], [gorm_tag]) VALUES (N'12', N'1', N'deleted_at', N'datetime', N'删除时间', N'', N'', N'0', N'0', N'time.Time', N'string', N'deleted_at', null, null, null, null, N'', N'', N'', N'column:deleted_at')
GO
GO
INSERT INTO [dbo].[sys_gen_field] ([id], [gen_id], [data_name], [data_type], [data_comment], [data_extra], [data_column_key], [data_unsigned], [is_primary], [go_type], [front_type], [custom_name], [require], [list_show], [form_show], [query_show], [query_type], [form_type], [dict_type], [gorm_tag]) VALUES (N'13', N'1', N'created_by', N'int', N'创建人', N'', N'', N'0', N'0', N'int', N'number', N'created_by', null, null, null, null, N'', N'', N'', N'column:created_by;default:((0))')
GO
GO
INSERT INTO [dbo].[sys_gen_field] ([id], [gen_id], [data_name], [data_type], [data_comment], [data_extra], [data_column_key], [data_unsigned], [is_primary], [go_type], [front_type], [custom_name], [require], [list_show], [form_show], [query_show], [query_type], [form_type], [dict_type], [gorm_tag]) VALUES (N'14', N'1', N'tenant_id', N'int', N'租户ID字段', N'', N'', N'0', N'0', N'int', N'number', N'tenant_id', null, null, null, null, N'', N'', N'', N'column:tenant_id;default:((0))')
GO
GO
INSERT INTO [dbo].[sys_gen_field] ([id], [gen_id], [data_name], [data_type], [data_comment], [data_extra], [data_column_key], [data_unsigned], [is_primary], [go_type], [front_type], [custom_name], [require], [list_show], [form_show], [query_show], [query_type], [form_type], [dict_type], [gorm_tag]) VALUES (N'15', N'2', N'id', N'int', N'主键ID', N'', N'PRI', N'0', N'1', N'int', N'number', N'id', N'1', N'1', N'1', N'1', N'', N'', N'', N'column:id;primaryKey;not null')
GO
GO
INSERT INTO [dbo].[sys_gen_field] ([id], [gen_id], [data_name], [data_type], [data_comment], [data_extra], [data_column_key], [data_unsigned], [is_primary], [go_type], [front_type], [custom_name], [require], [list_show], [form_show], [query_show], [query_type], [form_type], [dict_type], [gorm_tag]) VALUES (N'16', N'2', N'name', N'nvarchar', N'教师姓名', N'', N'', N'0', N'0', N'string', N'string', N'name', N'1', N'1', N'1', N'1', N'', N'', N'', N'column:name;not null')
GO
GO
INSERT INTO [dbo].[sys_gen_field] ([id], [gen_id], [data_name], [data_type], [data_comment], [data_extra], [data_column_key], [data_unsigned], [is_primary], [go_type], [front_type], [custom_name], [require], [list_show], [form_show], [query_show], [query_type], [form_type], [dict_type], [gorm_tag]) VALUES (N'17', N'2', N'employee_id', N'nvarchar', N'工号', N'', N'', N'0', N'0', N'string', N'string', N'employee_id', N'1', N'1', N'1', N'1', N'', N'', N'', N'column:employee_id')
GO
GO
INSERT INTO [dbo].[sys_gen_field] ([id], [gen_id], [data_name], [data_type], [data_comment], [data_extra], [data_column_key], [data_unsigned], [is_primary], [go_type], [front_type], [custom_name], [require], [list_show], [form_show], [query_show], [query_type], [form_type], [dict_type], [gorm_tag]) VALUES (N'18', N'2', N'gender', N'tinyint', N'性别：0-未知 1-男 2-女', N'', N'', N'0', N'0', N'int', N'number', N'gender', N'1', N'1', N'1', N'1', N'', N'', N'', N'column:gender;default:((0))')
GO
GO
INSERT INTO [dbo].[sys_gen_field] ([id], [gen_id], [data_name], [data_type], [data_comment], [data_extra], [data_column_key], [data_unsigned], [is_primary], [go_type], [front_type], [custom_name], [require], [list_show], [form_show], [query_show], [query_type], [form_type], [dict_type], [gorm_tag]) VALUES (N'19', N'2', N'phone', N'nvarchar', N'手机号', N'', N'', N'0', N'0', N'string', N'string', N'phone', N'1', N'1', N'1', N'1', N'', N'', N'', N'column:phone')
GO
GO
INSERT INTO [dbo].[sys_gen_field] ([id], [gen_id], [data_name], [data_type], [data_comment], [data_extra], [data_column_key], [data_unsigned], [is_primary], [go_type], [front_type], [custom_name], [require], [list_show], [form_show], [query_show], [query_type], [form_type], [dict_type], [gorm_tag]) VALUES (N'20', N'2', N'email', N'nvarchar', N'邮箱', N'', N'', N'0', N'0', N'string', N'string', N'email', N'1', N'1', N'1', N'1', N'', N'', N'', N'column:email')
GO
GO
INSERT INTO [dbo].[sys_gen_field] ([id], [gen_id], [data_name], [data_type], [data_comment], [data_extra], [data_column_key], [data_unsigned], [is_primary], [go_type], [front_type], [custom_name], [require], [list_show], [form_show], [query_show], [query_type], [form_type], [dict_type], [gorm_tag]) VALUES (N'21', N'2', N'subject', N'nvarchar', N'所教学科', N'', N'', N'0', N'0', N'string', N'string', N'subject', N'1', N'1', N'1', N'1', N'', N'', N'', N'column:subject')
GO
GO
INSERT INTO [dbo].[sys_gen_field] ([id], [gen_id], [data_name], [data_type], [data_comment], [data_extra], [data_column_key], [data_unsigned], [is_primary], [go_type], [front_type], [custom_name], [require], [list_show], [form_show], [query_show], [query_type], [form_type], [dict_type], [gorm_tag]) VALUES (N'22', N'2', N'title', N'nvarchar', N'职称', N'', N'', N'0', N'0', N'string', N'string', N'title', N'1', N'1', N'1', N'1', N'', N'', N'', N'column:title')
GO
GO
INSERT INTO [dbo].[sys_gen_field] ([id], [gen_id], [data_name], [data_type], [data_comment], [data_extra], [data_column_key], [data_unsigned], [is_primary], [go_type], [front_type], [custom_name], [require], [list_show], [form_show], [query_show], [query_type], [form_type], [dict_type], [gorm_tag]) VALUES (N'23', N'2', N'status', N'tinyint', N'状态：0-离职 1-在职', N'', N'', N'0', N'0', N'int', N'number', N'status', N'1', N'1', N'1', N'1', N'', N'', N'', N'column:status;default:((1))')
GO
GO
INSERT INTO [dbo].[sys_gen_field] ([id], [gen_id], [data_name], [data_type], [data_comment], [data_extra], [data_column_key], [data_unsigned], [is_primary], [go_type], [front_type], [custom_name], [require], [list_show], [form_show], [query_show], [query_type], [form_type], [dict_type], [gorm_tag]) VALUES (N'24', N'2', N'hire_date', N'date', N'入职日期', N'', N'', N'0', N'0', N'time.Time', N'string', N'hire_date', N'1', N'1', N'1', N'1', N'', N'', N'', N'column:hire_date')
GO
GO
INSERT INTO [dbo].[sys_gen_field] ([id], [gen_id], [data_name], [data_type], [data_comment], [data_extra], [data_column_key], [data_unsigned], [is_primary], [go_type], [front_type], [custom_name], [require], [list_show], [form_show], [query_show], [query_type], [form_type], [dict_type], [gorm_tag]) VALUES (N'25', N'2', N'birth_date', N'date', N'出生日期', N'', N'', N'0', N'0', N'time.Time', N'string', N'birth_date', N'1', N'1', N'1', N'1', N'', N'', N'', N'column:birth_date')
GO
GO
INSERT INTO [dbo].[sys_gen_field] ([id], [gen_id], [data_name], [data_type], [data_comment], [data_extra], [data_column_key], [data_unsigned], [is_primary], [go_type], [front_type], [custom_name], [require], [list_show], [form_show], [query_show], [query_type], [form_type], [dict_type], [gorm_tag]) VALUES (N'26', N'2', N'created_at', N'datetime', N'创建时间', N'', N'', N'0', N'0', N'time.Time', N'string', N'created_at', null, null, null, null, N'', N'', N'', N'column:created_at')
GO
GO
INSERT INTO [dbo].[sys_gen_field] ([id], [gen_id], [data_name], [data_type], [data_comment], [data_extra], [data_column_key], [data_unsigned], [is_primary], [go_type], [front_type], [custom_name], [require], [list_show], [form_show], [query_show], [query_type], [form_type], [dict_type], [gorm_tag]) VALUES (N'27', N'2', N'updated_at', N'datetime', N'更新时间', N'', N'', N'0', N'0', N'time.Time', N'string', N'updated_at', null, null, null, null, N'', N'', N'', N'column:updated_at')
GO
GO
INSERT INTO [dbo].[sys_gen_field] ([id], [gen_id], [data_name], [data_type], [data_comment], [data_extra], [data_column_key], [data_unsigned], [is_primary], [go_type], [front_type], [custom_name], [require], [list_show], [form_show], [query_show], [query_type], [form_type], [dict_type], [gorm_tag]) VALUES (N'28', N'2', N'deleted_at', N'datetime', N'删除时间', N'', N'', N'0', N'0', N'time.Time', N'string', N'deleted_at', null, null, null, null, N'', N'', N'', N'column:deleted_at')
GO
GO
INSERT INTO [dbo].[sys_gen_field] ([id], [gen_id], [data_name], [data_type], [data_comment], [data_extra], [data_column_key], [data_unsigned], [is_primary], [go_type], [front_type], [custom_name], [require], [list_show], [form_show], [query_show], [query_type], [form_type], [dict_type], [gorm_tag]) VALUES (N'29', N'2', N'created_by', N'int', N'创建人', N'', N'', N'0', N'0', N'int', N'number', N'created_by', null, null, null, null, N'', N'', N'', N'column:created_by;default:((0))')
GO
GO
SET IDENTITY_INSERT [dbo].[sys_gen_field] OFF
GO

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------

CREATE TABLE [dbo].[sys_menu] (
[id] int NOT NULL IDENTITY(1,1) ,
[parent_id] int  NOT NULL DEFAULT (0) ,
[path] nvarchar(255) NOT NULL ,
[name] nvarchar(100) NOT NULL ,
[redirect] nvarchar(255) NULL ,
[component] nvarchar(255) NULL ,
[title] nvarchar(100) NULL ,
[is_full] tinyint NULL DEFAULT ((0)) ,
[hide] tinyint NULL DEFAULT ((0)) ,
[disable] tinyint NULL DEFAULT ((0)) ,
[keep_alive] tinyint NULL DEFAULT ((0)) ,
[affix] tinyint NULL DEFAULT ((0)) ,
[link] nvarchar(500) NULL DEFAULT '' ,
[iframe] tinyint NULL DEFAULT ((0)) ,
[svg_icon] nvarchar(100) NULL DEFAULT '' ,
[icon] nvarchar(100) NULL DEFAULT '' ,
[sort] int NULL DEFAULT ((0)) ,
[type] tinyint NULL DEFAULT ((2)) ,
[is_link] tinyint NULL DEFAULT ((0)) ,
[permission] nvarchar(255) NULL DEFAULT '' ,
[created_at] datetime NULL DEFAULT (getdate()) ,
[updated_at] datetime NULL DEFAULT (getdate()) ,
[deleted_at] datetime NULL ,
[created_by] int NULL 
)


GO
DBCC CHECKIDENT(N'[dbo].[sys_menu]', RESEED, 140344)
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_menu', 
NULL, NULL)) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'系统菜单路由表'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'系统菜单路由表'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_menu', 
'COLUMN', N'id')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'路由ID'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'id'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'路由ID'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'id'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_menu', 
'COLUMN', N'parent_id')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'父级路由ID，顶层为0'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'parent_id'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'父级路由ID，顶层为0'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'parent_id'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_menu', 
'COLUMN', N'path')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'路由路径'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'path'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'路由路径'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'path'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_menu', 
'COLUMN', N'name')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'路由名称'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'name'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'路由名称'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'name'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_menu', 
'COLUMN', N'redirect')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'重定向'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'redirect'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'重定向'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'redirect'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_menu', 
'COLUMN', N'component')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'组件文件路径'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'component'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'组件文件路径'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'component'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_menu', 
'COLUMN', N'title')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'菜单标题，国际化key'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'title'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'菜单标题，国际化key'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'title'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_menu', 
'COLUMN', N'is_full')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'是否全屏显示：0-否，1-是'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'is_full'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'是否全屏显示：0-否，1-是'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'is_full'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_menu', 
'COLUMN', N'hide')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'是否隐藏：0-否，1-是'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'hide'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'是否隐藏：0-否，1-是'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'hide'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_menu', 
'COLUMN', N'disable')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'是否停用：0-否，1-是'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'disable'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'是否停用：0-否，1-是'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'disable'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_menu', 
'COLUMN', N'keep_alive')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'是否缓存：0-否，1-是'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'keep_alive'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'是否缓存：0-否，1-是'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'keep_alive'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_menu', 
'COLUMN', N'affix')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'是否固定：0-否，1-是'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'affix'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'是否固定：0-否，1-是'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'affix'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_menu', 
'COLUMN', N'link')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'外链地址'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'link'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'外链地址'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'link'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_menu', 
'COLUMN', N'iframe')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'是否内嵌：0-否，1-是'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'iframe'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'是否内嵌：0-否，1-是'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'iframe'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_menu', 
'COLUMN', N'svg_icon')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'svg图标名称'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'svg_icon'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'svg图标名称'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'svg_icon'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_menu', 
'COLUMN', N'icon')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'普通图标名称'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'icon'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'普通图标名称'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'icon'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_menu', 
'COLUMN', N'sort')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'排序字段'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'sort'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'排序字段'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'sort'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_menu', 
'COLUMN', N'type')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'类型：1-目录，2-菜单，3-按钮'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'type'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'类型：1-目录，2-菜单，3-按钮'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'type'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_menu', 
'COLUMN', N'is_link')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'是否外链'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'is_link'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'是否外链'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'is_link'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_menu', 
'COLUMN', N'permission')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'权限标识'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'permission'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'权限标识'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'permission'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_menu', 
'COLUMN', N'created_at')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'创建时间'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'created_at'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'创建时间'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'created_at'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_menu', 
'COLUMN', N'updated_at')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'更新时间'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'updated_at'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'更新时间'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_menu'
, @level2type = 'COLUMN', @level2name = N'updated_at'
GO

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
SET IDENTITY_INSERT [dbo].[sys_menu] ON
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'1', N'0', N'/home', N'home', null, N'home/home', N'home', N'0', N'0', N'0', N'0', N'1', N'', N'0', N'home', N'', N'0', N'2', N'0', N'', N'2025-08-27 09:09:44.000', N'2025-08-27 09:09:44.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'10', N'0', N'/system', N'system', null, null, N'system', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'set', N'', N'0', N'1', N'0', N'', N'2025-08-27 09:09:44.000', N'2025-08-27 09:09:44.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'1001', N'10', N'/system/account', N'account', N'', N'system/account/account', N'account', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'IconUser', N'0', N'2', N'0', N'', N'2025-08-27 09:09:44.000', N'2025-10-11 15:37:41.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'1002', N'10', N'/system/role', N'role', N'', N'system/role/role', N'role', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'IconUserGroup', N'0', N'2', N'0', N'', N'2025-08-27 09:09:44.000', N'2025-10-11 16:16:08.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'1003', N'10', N'/system/menu', N'menu', null, N'system/menu/menu', N'menu', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'icon-menu', N'0', N'2', N'0', N'', N'2025-08-27 09:09:44.000', N'2025-08-27 09:09:44.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'1004', N'10', N'/system/division', N'division', N'', N'system/division/division', N'division', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'IconMindMapping', N'0', N'2', N'0', N'', N'2025-08-27 09:09:44.000', N'2025-10-11 16:23:14.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'1005', N'10', N'/system/dictionary', N'dictionary', N'', N'system/dictionary/dictionary', N'dictionary', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'IconBook', N'0', N'2', N'0', N'', N'2025-08-27 09:09:44.000', N'2025-10-11 16:23:47.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'1006', N'10', N'/system/log', N'log', N'', N'system/log/log', N'log', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'IconCommon', N'0', N'2', N'0', N'', N'2025-08-27 09:09:44.000', N'2025-10-20 17:14:19.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'1007', N'10', N'/system/userinfo', N'userinfo', N'', N'system/userinfo/userinfo', N'userinfo', N'0', N'1', N'0', N'1', N'0', N'', N'0', N'', N'icon-menu', N'0', N'2', N'0', N'', N'2025-08-27 09:09:44.000', N'2025-09-17 11:19:11.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140213', N'10', N'/system/api', N'SystemApi', N'', N'system/sysapi/sysapi', N'api-management', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'IconFile', N'0', N'2', N'0', N'', N'2025-09-03 10:53:57.000', N'2025-10-16 08:53:42.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140214', N'1001', N'', N'', N'', N'', N'新增', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:account:add', N'2025-09-03 16:11:58.000', N'2025-09-03 16:11:58.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140215', N'1001', N'', N'', N'', N'', N'编辑', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:account:edit', N'2025-09-03 17:11:24.000', N'2025-09-03 17:11:24.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140216', N'1001', N'', N'', N'', N'', N'删除', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:account:delete', N'2025-09-03 17:12:22.000', N'2025-09-03 17:12:22.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140218', N'1002', N'', N'', N'', N'', N'新增', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:role:add', N'2025-09-04 16:43:54.000', N'2025-09-04 16:43:54.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140219', N'1002', N'', N'', N'', N'', N'编辑', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:role:edit', N'2025-09-04 16:47:15.000', N'2025-09-04 16:47:15.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140220', N'1002', N'', N'', N'', N'', N'删除', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:role:delete', N'2025-09-04 16:50:19.000', N'2025-09-04 16:50:19.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140221', N'1002', N'', N'', N'', N'', N'分配权限', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:role:addRoleMenu', N'2025-09-04 16:53:09.000', N'2025-09-04 16:53:09.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140222', N'1003', N'', N'', N'', N'', N'新增', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:menu:add', N'2025-09-04 17:07:16.000', N'2025-09-04 17:07:16.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140223', N'1003', N'', N'', N'', N'', N'编辑', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:menu:edit', N'2025-09-04 17:11:51.000', N'2025-09-04 17:11:51.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140224', N'1003', N'', N'', N'', N'', N'删除', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:menu:delete', N'2025-09-04 17:12:24.000', N'2025-09-04 17:12:24.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140225', N'1003', N'', N'', N'', N'', N'分配权限', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:menu:setMenuApis', N'2025-09-04 17:20:09.000', N'2025-09-04 17:20:09.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140226', N'140213', N'', N'', N'', N'', N'新增', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:api:add', N'2025-09-04 17:30:56.000', N'2025-09-04 17:30:56.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140227', N'140213', N'', N'', N'', N'', N'编辑', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:api:edit', N'2025-09-04 17:31:20.000', N'2025-09-04 17:31:20.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140228', N'140213', N'', N'', N'', N'', N'删除', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:api:delete', N'2025-09-04 17:31:38.000', N'2025-09-04 17:31:38.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140229', N'1004', N'', N'', N'', N'', N'新增部门', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:division:add', N'2025-09-12 14:50:55.000', N'2025-09-12 14:50:55.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140230', N'1004', N'', N'', N'', N'', N'编辑部门', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:division:edit', N'2025-09-12 14:51:17.000', N'2025-09-12 14:51:17.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140231', N'1004', N'', N'', N'', N'', N'删除部门', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:division:delete', N'2025-09-12 14:51:51.000', N'2025-09-12 14:51:51.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140232', N'1005', N'', N'', N'', N'', N'新增', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:dict:add', N'2025-09-16 16:38:06.000', N'2025-09-16 16:38:06.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140233', N'1005', N'', N'', N'', N'', N'编辑', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:dict:edit', N'2025-09-16 16:39:58.000', N'2025-09-16 16:39:58.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140234', N'1005', N'', N'', N'', N'', N'删除', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:dict:delete', N'2025-09-16 16:40:19.000', N'2025-09-16 16:40:19.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140235', N'1005', N'', N'', N'', N'', N'字典项管理', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:dictitem:list', N'2025-09-16 17:09:58.000', N'2025-09-16 17:31:35.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140236', N'1005', N'', N'', N'', N'', N'新增字典项', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:dictitem:add', N'2025-09-16 17:32:06.000', N'2025-09-16 17:32:06.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140237', N'1005', N'', N'', N'', N'', N'编辑字典项', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:dictitem:edit', N'2025-09-16 17:33:16.000', N'2025-09-16 17:33:16.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140238', N'1005', N'', N'', N'', N'', N'删除字典项', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:dictitem:delete', N'2025-09-16 17:33:41.000', N'2025-09-16 17:33:41.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140239', N'10', N'/system/affix', N'SystemAffix', N'', N'system/affix/affix', N'file-manager', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'IconFolder', N'0', N'2', N'0', N'', N'2025-09-25 15:17:00.000', N'2025-10-15 18:14:16.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140240', N'140239', N'', N'', N'', N'', N'文件上传', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:affix:upload', N'2025-09-25 15:45:29.000', N'2025-09-25 15:46:29.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140241', N'140239', N'', N'', N'', N'', N'删除文件', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:affix:delete', N'2025-09-25 15:46:52.000', N'2025-09-25 15:46:52.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140242', N'140239', N'', N'', N'', N'', N'修改文件名', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:affix:updateName', N'2025-09-25 15:47:41.000', N'2025-09-25 15:47:41.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140243', N'140239', N'', N'', N'', N'', N'下载文件', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:affix:download', N'2025-09-25 15:48:56.000', N'2025-09-25 15:48:56.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140244', N'1002', N'', N'', N'', N'', N'数据权限', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:role:dataScope', N'2025-09-26 17:07:16.000', N'2025-09-26 17:07:16.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140245', N'10', N'/system/sysconfig', N'SystemSysconfig', N'', N'system/sysconfig/sysconfig', N'system-config', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'IconSettings', N'0', N'2', N'0', N'', N'2025-10-09 16:15:21.000', N'2025-10-15 18:10:54.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140246', N'140245', N'', N'', N'', N'', N'修改系统配置', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:config:update', N'2025-10-09 16:24:33.000', N'2025-10-09 16:24:33.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140247', N'0', N'/demo', N'Demo', N'', N'', N'plugin-example', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'more', N'', N'0', N'1', N'0', N'', N'2025-10-13 14:38:38.000', N'2025-10-16 08:55:06.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140248', N'140247', N'/plugins/example', N'PluginsExample', N'', N'plugins/example/views/examplelist', N'plugin-example', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'IconMenu', N'0', N'2', N'0', N'', N'2025-10-13 15:19:20.000', N'2025-10-16 08:55:19.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140249', N'140248', N'', N'', N'', N'', N'新增', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'plugins:example:add', N'2025-10-14 11:02:42.000', N'2025-10-14 11:02:42.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140250', N'140248', N'', N'', N'', N'', N'编辑', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'plugins:example:edit', N'2025-10-14 11:03:08.000', N'2025-10-14 11:03:08.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140251', N'140248', N'', N'', N'', N'', N'删除', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'plugins:example:delete', N'2025-10-14 11:03:25.000', N'2025-10-14 11:03:25.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140252', N'1007', N'', N'', N'', N'', N'修改密码、手机号等', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:userinfo:updateAccount', N'2025-10-17 11:12:56.000', N'2025-10-17 11:12:56.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140254', N'140239', N'', N'', N'', N'', N'复制链接', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:affix:copy', N'2025-10-17 11:38:09.000', N'2025-10-17 11:38:09.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140255', N'1006', N'', N'', N'', N'', N'导出', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:log:export', N'2025-10-20 10:16:51.000', N'2025-10-20 10:16:51.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140256', N'1006', N'', N'', N'', N'', N'删除', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:log:delete', N'2025-10-20 10:17:19.000', N'2025-10-20 10:17:19.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140257', N'1003', N'', N'', N'', N'', N'导出', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:menu:export', N'2025-10-20 17:18:01.000', N'2025-10-20 17:18:13.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140258', N'1003', N'', N'', N'', N'', N'导入', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:menu:import', N'2025-10-21 11:29:45.000', N'2025-10-21 11:29:45.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140259', N'10', N'/system/systenant', N'SystemSystenant', N'', N'system/tenant/tenant', N'tenant', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'IconTags', N'0', N'2', N'0', N'', N'2025-10-24 09:11:32.000', N'2025-10-24 09:20:59.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140260', N'140259', N'', N'', N'', N'', N'新增租户', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:tenant:add', N'2025-10-24 09:14:25.000', N'2025-10-24 09:14:25.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140261', N'140259', N'', N'', N'', N'', N'修改租户', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:tenant:edit', N'2025-10-24 09:14:50.000', N'2025-10-24 09:14:50.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140262', N'140259', N'', N'', N'', N'', N'删除租户', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:tenant:delete', N'2025-10-24 09:15:07.000', N'2025-10-24 09:15:07.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140263', N'140259', N'', N'', N'', N'', N'分配用户', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:tenant:assignUser', N'2025-10-27 18:03:07.000', N'2025-10-27 18:03:07.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140264', N'1007', N'', N'', N'', N'', N'修改用户基本信息', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:userinfo:updateBasicInfo', N'2025-10-31 09:26:42.000', N'2025-10-31 09:26:42.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140265', N'10', N'/system/codegen', N'SystemCodegen', N'', N'system/codegen/codegen', N'codegen', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'IconCode', N'0', N'2', N'0', N'', N'2025-11-04 11:45:49.000', N'2025-11-04 11:45:49.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140329', N'140265', N'', N'', N'', N'', N'导入表', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'1', N'3', N'0', N'system:codegen:batchInsert', N'2025-11-17 15:32:25.000', N'2025-11-17 15:32:25.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140330', N'140265', N'', N'', N'', N'', N'配置', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'1', N'3', N'0', N'system:codegen:update', N'2025-11-17 15:33:57.000', N'2025-11-17 15:33:57.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140331', N'140265', N'', N'', N'', N'', N'预览', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'1', N'3', N'0', N'system:codegen:preview', N'2025-11-17 15:34:24.000', N'2025-11-17 15:34:24.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140332', N'140265', N'', N'', N'', N'', N'生成代码文件', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'1', N'3', N'0', N'system:codegen:generate', N'2025-11-17 15:35:00.000', N'2025-11-17 15:35:00.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140333', N'140265', N'', N'', N'', N'', N'同步数据库', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'1', N'3', N'0', N'system:codegen:refreshFields', N'2025-11-17 15:35:51.000', N'2025-11-17 15:35:51.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140334', N'140265', N'', N'', N'', N'', N'删除', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'1', N'3', N'0', N'system:codegen:delete', N'2025-11-17 15:36:50.000', N'2025-11-17 15:36:50.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140335', N'140265', N'', N'', N'', N'', N'生成菜单', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:codegen:insertmenuandapi', N'2025-11-26 15:16:32.000', N'2025-11-26 15:16:32.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140336', N'10', N'/system/pluginsmanager', N'SystemPluginsmanager', N'', N'system/pluginsmanager/pluginsmanager', N'plugins-manager', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'IconApps', N'0', N'2', N'0', N'', N'2025-12-05 17:59:34.000', N'2025-12-05 17:59:34.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140338', N'140336', N'', N'', N'', N'', N'导出插件', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:pluginsmanager:export', N'2025-12-08 16:33:32.000', N'2025-12-08 16:33:32.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140339', N'140336', N'', N'', N'', N'', N'导入插件', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:pluginsmanager:import', N'2025-12-08 16:33:51.000', N'2025-12-08 16:33:51.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140340', N'140336', N'', N'', N'', N'', N'插件卸载', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'system:pluginsmanager:uninstall', N'2025-12-08 16:34:53.000', N'2025-12-08 16:34:53.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140341', N'0', N'/plugins/demoschool/demostudentslist', N'Pluginsdemoschooldemostudents', N'', N'plugins/demoschool/views/demostudentslist', N'学员管理', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'IconMenu', N'0', N'2', N'0', N'', N'2025-12-10 10:28:36.000', N'2025-12-10 10:28:36.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140342', N'140341', N'', N'', N'', N'', N'新增', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'plugins:demoschooldemostudents:add', N'2025-12-10 10:28:36.000', N'2025-12-10 10:28:36.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140343', N'140341', N'', N'', N'', N'', N'编辑', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'plugins:demoschooldemostudents:edit', N'2025-12-10 10:28:36.000', N'2025-12-10 10:28:36.000', null, N'1')
GO
GO
INSERT INTO [dbo].[sys_menu] ([id], [parent_id], [path], [name], [redirect], [component], [title], [is_full], [hide], [disable], [keep_alive], [affix], [link], [iframe], [svg_icon], [icon], [sort], [type], [is_link], [permission], [created_at], [updated_at], [deleted_at], [created_by]) VALUES (N'140344', N'140341', N'', N'', N'', N'', N'删除', N'0', N'0', N'0', N'1', N'0', N'', N'0', N'', N'', N'0', N'3', N'0', N'plugins:demoschooldemostudents:delete', N'2025-12-10 10:28:36.000', N'2025-12-10 10:28:36.000', null, N'1')
GO
GO
SET IDENTITY_INSERT [dbo].[sys_menu] OFF
GO

-- ----------------------------
-- Table structure for sys_menu_api
-- ----------------------------

CREATE TABLE [dbo].[sys_menu_api] (
[menu_id] int NOT NULL ,
[api_id] int NOT NULL 
)


GO

-- ----------------------------
-- Records of sys_menu_api
-- ----------------------------
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'10', N'5')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'10', N'6')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'10', N'7')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'10', N'12')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'10', N'27')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'10', N'54')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'1001', N'8')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'1001', N'18')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'1001', N'19')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'1002', N'19')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'1003', N'13')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'1004', N'18')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'1005', N'41')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'1006', N'70')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'1007', N'6')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140213', N'29')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140214', N'9')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140215', N'10')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140216', N'11')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140218', N'24')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140219', N'25')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140220', N'26')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140221', N'13')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140221', N'20')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140221', N'21')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140222', N'15')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140223', N'16')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140224', N'17')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140224', N'197')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140225', N'29')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140225', N'35')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140225', N'36')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140226', N'31')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140227', N'30')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140227', N'32')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140228', N'33')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140229', N'38')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140230', N'39')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140231', N'40')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140232', N'43')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140233', N'44')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140234', N'45')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140235', N'48')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140236', N'50')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140237', N'51')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140238', N'52')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140239', N'58')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140240', N'55')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140241', N'56')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140242', N'57')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140243', N'60')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140244', N'61')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140245', N'62')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140245', N'64')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140246', N'63')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140248', N'65')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140248', N'69')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140249', N'66')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140250', N'67')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140251', N'68')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140252', N'53')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140254', N'60')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140255', N'73')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140256', N'72')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140257', N'74')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140258', N'75')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140259', N'76')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140260', N'78')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140261', N'77')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140261', N'79')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140262', N'80')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140263', N'81')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140263', N'82')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140263', N'83')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140263', N'84')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140263', N'85')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140263', N'86')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140263', N'87')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140263', N'88')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140264', N'89')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140265', N'190')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140329', N'188')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140329', N'191')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140330', N'192')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140330', N'193')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140331', N'189')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140332', N'105')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140333', N'195')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140334', N'194')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140335', N'196')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140336', N'198')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140338', N'199')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140339', N'200')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140340', N'201')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140341', N'1001')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140342', N'1002')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140343', N'1003')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140343', N'1005')
GO
GO
INSERT INTO [dbo].[sys_menu_api] ([menu_id], [api_id]) VALUES (N'140344', N'1004')
GO
GO

-- ----------------------------
-- Table structure for sys_operation_logs
-- ----------------------------

CREATE TABLE [dbo].[sys_operation_logs] (
[id] bigint NOT NULL IDENTITY(1,1) ,
[created_at] datetime NULL ,
[updated_at] datetime NULL ,
[deleted_at] datetime NULL ,
[user_id] bigint NULL ,
[username] nvarchar(50) NULL ,
[module] nvarchar(100) NULL ,
[operation] nvarchar(100) NULL ,
[method] nvarchar(10) NULL ,
[path] nvarchar(500) NULL ,
[ip] nvarchar(50) NULL ,
[user_agent] nvarchar(500) NULL ,
[request_data] nvarchar(MAX) NULL ,
[response_data] nvarchar(MAX) NULL ,
[status_code] int NULL ,
[duration] bigint NULL ,
[error_msg] nvarchar(MAX) NULL ,
[location] nvarchar(100) NULL ,
[tenant_id] int NULL DEFAULT ((0)) 
)


GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_operation_logs', 
NULL, NULL)) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'系统操作日志表'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_operation_logs'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'系统操作日志表'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_operation_logs'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_operation_logs', 
'COLUMN', N'user_id')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'操作用户ID'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_operation_logs'
, @level2type = 'COLUMN', @level2name = N'user_id'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'操作用户ID'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_operation_logs'
, @level2type = 'COLUMN', @level2name = N'user_id'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_operation_logs', 
'COLUMN', N'username')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'操作用户名'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_operation_logs'
, @level2type = 'COLUMN', @level2name = N'username'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'操作用户名'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_operation_logs'
, @level2type = 'COLUMN', @level2name = N'username'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_operation_logs', 
'COLUMN', N'module')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'操作模块'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_operation_logs'
, @level2type = 'COLUMN', @level2name = N'module'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'操作模块'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_operation_logs'
, @level2type = 'COLUMN', @level2name = N'module'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_operation_logs', 
'COLUMN', N'operation')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'操作类型'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_operation_logs'
, @level2type = 'COLUMN', @level2name = N'operation'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'操作类型'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_operation_logs'
, @level2type = 'COLUMN', @level2name = N'operation'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_operation_logs', 
'COLUMN', N'method')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'请求方法'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_operation_logs'
, @level2type = 'COLUMN', @level2name = N'method'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'请求方法'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_operation_logs'
, @level2type = 'COLUMN', @level2name = N'method'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_operation_logs', 
'COLUMN', N'path')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'请求路径'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_operation_logs'
, @level2type = 'COLUMN', @level2name = N'path'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'请求路径'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_operation_logs'
, @level2type = 'COLUMN', @level2name = N'path'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_operation_logs', 
'COLUMN', N'ip')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'客户端IP'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_operation_logs'
, @level2type = 'COLUMN', @level2name = N'ip'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'客户端IP'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_operation_logs'
, @level2type = 'COLUMN', @level2name = N'ip'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_operation_logs', 
'COLUMN', N'user_agent')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'用户代理'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_operation_logs'
, @level2type = 'COLUMN', @level2name = N'user_agent'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'用户代理'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_operation_logs'
, @level2type = 'COLUMN', @level2name = N'user_agent'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_operation_logs', 
'COLUMN', N'request_data')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'请求参数'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_operation_logs'
, @level2type = 'COLUMN', @level2name = N'request_data'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'请求参数'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_operation_logs'
, @level2type = 'COLUMN', @level2name = N'request_data'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_operation_logs', 
'COLUMN', N'response_data')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'响应数据'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_operation_logs'
, @level2type = 'COLUMN', @level2name = N'response_data'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'响应数据'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_operation_logs'
, @level2type = 'COLUMN', @level2name = N'response_data'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_operation_logs', 
'COLUMN', N'status_code')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'响应状态码'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_operation_logs'
, @level2type = 'COLUMN', @level2name = N'status_code'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'响应状态码'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_operation_logs'
, @level2type = 'COLUMN', @level2name = N'status_code'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_operation_logs', 
'COLUMN', N'duration')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'操作耗时(毫秒)'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_operation_logs'
, @level2type = 'COLUMN', @level2name = N'duration'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'操作耗时(毫秒)'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_operation_logs'
, @level2type = 'COLUMN', @level2name = N'duration'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_operation_logs', 
'COLUMN', N'error_msg')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'错误信息'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_operation_logs'
, @level2type = 'COLUMN', @level2name = N'error_msg'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'错误信息'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_operation_logs'
, @level2type = 'COLUMN', @level2name = N'error_msg'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_operation_logs', 
'COLUMN', N'location')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'操作地点'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_operation_logs'
, @level2type = 'COLUMN', @level2name = N'location'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'操作地点'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_operation_logs'
, @level2type = 'COLUMN', @level2name = N'location'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_operation_logs', 
'COLUMN', N'tenant_id')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'租户ID字段'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_operation_logs'
, @level2type = 'COLUMN', @level2name = N'tenant_id'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'租户ID字段'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_operation_logs'
, @level2type = 'COLUMN', @level2name = N'tenant_id'
GO

-- ----------------------------
-- Records of sys_operation_logs
-- ----------------------------
SET IDENTITY_INSERT [dbo].[sys_operation_logs] ON
GO
SET IDENTITY_INSERT [dbo].[sys_operation_logs] OFF
GO

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------

CREATE TABLE [dbo].[sys_role] (
[id] int NOT NULL IDENTITY(1,1) ,
[name] nvarchar(255) NULL DEFAULT '' ,
[sort] int NULL DEFAULT ((0)) ,
[status] tinyint NULL DEFAULT ((0)) ,
[description] nvarchar(255) NULL ,
[parent_id] int NULL DEFAULT ((0)) ,
[created_at] datetime NULL ,
[updated_at] datetime NULL ,
[deleted_at] datetime NULL ,
[created_by] int NULL ,
[data_scope] int NULL DEFAULT ((0)) ,
[checked_depts] nvarchar(1000) NULL ,
[tenant_id] int NULL DEFAULT ((0)) 
)


GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_role', 
'COLUMN', N'name')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'角色名称'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_role'
, @level2type = 'COLUMN', @level2name = N'name'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'角色名称'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_role'
, @level2type = 'COLUMN', @level2name = N'name'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_role', 
'COLUMN', N'sort')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'排序'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_role'
, @level2type = 'COLUMN', @level2name = N'sort'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'排序'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_role'
, @level2type = 'COLUMN', @level2name = N'sort'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_role', 
'COLUMN', N'status')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'状态'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_role'
, @level2type = 'COLUMN', @level2name = N'status'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'状态'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_role'
, @level2type = 'COLUMN', @level2name = N'status'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_role', 
'COLUMN', N'description')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'描述'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_role'
, @level2type = 'COLUMN', @level2name = N'description'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'描述'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_role'
, @level2type = 'COLUMN', @level2name = N'description'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_role', 
'COLUMN', N'data_scope')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'数据权限'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_role'
, @level2type = 'COLUMN', @level2name = N'data_scope'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'数据权限'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_role'
, @level2type = 'COLUMN', @level2name = N'data_scope'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_role', 
'COLUMN', N'checked_depts')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'数据权限关联的部门'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_role'
, @level2type = 'COLUMN', @level2name = N'checked_depts'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'数据权限关联的部门'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_role'
, @level2type = 'COLUMN', @level2name = N'checked_depts'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_role', 
'COLUMN', N'tenant_id')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'租户ID字段'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_role'
, @level2type = 'COLUMN', @level2name = N'tenant_id'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'租户ID字段'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_role'
, @level2type = 'COLUMN', @level2name = N'tenant_id'
GO

-- ----------------------------
-- Records of sys_role
-- ----------------------------
SET IDENTITY_INSERT [dbo].[sys_role] ON
GO
INSERT INTO [dbo].[sys_role] ([id], [name], [sort], [status], [description], [parent_id], [created_at], [updated_at], [deleted_at], [created_by], [data_scope], [checked_depts], [tenant_id]) VALUES (N'1', N'系统管理员', N'0', N'1', N'最高权限管理员角色', N'0', N'2025-09-01 17:32:12.000', N'2025-09-30 15:53:24.000', null, N'1', N'1', N'', N'0')
GO
GO
SET IDENTITY_INSERT [dbo].[sys_role] OFF
GO

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------

CREATE TABLE [dbo].[sys_role_menu] (
[role_id] int NOT NULL ,
[menu_id] int NOT NULL 
)


GO

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'1')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'10')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'1001')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140214')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140215')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140216')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'1002')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140218')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140219')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140220')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140221')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140244')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'1003')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140222')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140223')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140224')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140225')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140257')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140258')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'1004')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140229')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140230')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140231')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'1005')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140232')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140233')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140234')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140235')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140236')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140237')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140238')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'1006')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140255')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140256')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'1007')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140252')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140264')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140213')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140226')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140227')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140228')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140239')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140240')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140241')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140242')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140243')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140254')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140245')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140246')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140259')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140260')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140261')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140262')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140263')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140265')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140330')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140331')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140329')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140334')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140332')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140333')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140335')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140336')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140338')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140339')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140340')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140247')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140248')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140249')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140250')
GO
GO
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) VALUES (N'1', N'140251')
GO
GO

-- ----------------------------
-- Table structure for sys_tenants
-- ----------------------------

CREATE TABLE [dbo].[sys_tenants] (
[id] int NOT NULL IDENTITY(1,1) ,
[created_at] datetime NULL ,
[updated_at] datetime NULL ,
[deleted_at] datetime NULL ,
[created_by] int NOT NULL DEFAULT ((0)) ,
[name] nvarchar(100) NOT NULL ,
[code] nvarchar(50) NOT NULL ,
[description] nvarchar(500) NULL ,
[status] tinyint NOT NULL DEFAULT ((1)) ,
[domain] nvarchar(255) NULL ,
[platform_domain] nvarchar(255) NULL 
[menu_permission] nvarchar(1000) NULL 
)


GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_tenants', 
'COLUMN', N'created_by')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'创建人'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_tenants'
, @level2type = 'COLUMN', @level2name = N'created_by'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'创建人'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_tenants'
, @level2type = 'COLUMN', @level2name = N'created_by'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_tenants', 
'COLUMN', N'name')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'租户名称'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_tenants'
, @level2type = 'COLUMN', @level2name = N'name'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'租户名称'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_tenants'
, @level2type = 'COLUMN', @level2name = N'name'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_tenants', 
'COLUMN', N'code')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'租户编码'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_tenants'
, @level2type = 'COLUMN', @level2name = N'code'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'租户编码'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_tenants'
, @level2type = 'COLUMN', @level2name = N'code'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_tenants', 
'COLUMN', N'description')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'租户描述'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_tenants'
, @level2type = 'COLUMN', @level2name = N'description'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'租户描述'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_tenants'
, @level2type = 'COLUMN', @level2name = N'description'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_tenants', 
'COLUMN', N'status')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'状态 0停用 1启用'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_tenants'
, @level2type = 'COLUMN', @level2name = N'status'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'状态 0停用 1启用'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_tenants'
, @level2type = 'COLUMN', @level2name = N'status'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_tenants', 
'COLUMN', N'domain')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'租户域名'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_tenants'
, @level2type = 'COLUMN', @level2name = N'domain'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'租户域名'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_tenants'
, @level2type = 'COLUMN', @level2name = N'domain'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_tenants', 
'COLUMN', N'platform_domain')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'主域名'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_tenants'
, @level2type = 'COLUMN', @level2name = N'platform_domain'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'主域名'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_tenants'
, @level2type = 'COLUMN', @level2name = N'platform_domain'
GO

-- ----------------------------
-- Records of sys_tenants
-- ----------------------------
SET IDENTITY_INSERT [dbo].[sys_tenants] ON
GO
SET IDENTITY_INSERT [dbo].[sys_tenants] OFF
GO

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------

CREATE TABLE [dbo].[sys_user_role] (
[user_id] int NOT NULL DEFAULT ((0)) ,
[role_id] int NOT NULL DEFAULT ((0)) 
)


GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_user_role', 
'COLUMN', N'user_id')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'用户ID'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_user_role'
, @level2type = 'COLUMN', @level2name = N'user_id'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'用户ID'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_user_role'
, @level2type = 'COLUMN', @level2name = N'user_id'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_user_role', 
'COLUMN', N'role_id')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'角色ID'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_user_role'
, @level2type = 'COLUMN', @level2name = N'role_id'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'角色ID'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_user_role'
, @level2type = 'COLUMN', @level2name = N'role_id'
GO

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO [dbo].[sys_user_role] ([user_id], [role_id]) VALUES (N'1', N'1')
GO
GO

-- ----------------------------
-- Table structure for sys_user_tenant
-- ----------------------------

CREATE TABLE [dbo].[sys_user_tenant] (
[user_id] int NOT NULL DEFAULT ((0)) ,
[tenant_id] int NOT NULL DEFAULT ((0)) ,
[is_default] tinyint NULL DEFAULT ((0)) ,
[created_at] datetime NULL 
)


GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_user_tenant', 
NULL, NULL)) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'用户及租户关联表'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_user_tenant'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'用户及租户关联表'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_user_tenant'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_user_tenant', 
'COLUMN', N'user_id')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'用户ID'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_user_tenant'
, @level2type = 'COLUMN', @level2name = N'user_id'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'用户ID'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_user_tenant'
, @level2type = 'COLUMN', @level2name = N'user_id'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_user_tenant', 
'COLUMN', N'tenant_id')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'租户id'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_user_tenant'
, @level2type = 'COLUMN', @level2name = N'tenant_id'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'租户id'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_user_tenant'
, @level2type = 'COLUMN', @level2name = N'tenant_id'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_user_tenant', 
'COLUMN', N'is_default')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'是否默认租户'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_user_tenant'
, @level2type = 'COLUMN', @level2name = N'is_default'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'是否默认租户'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_user_tenant'
, @level2type = 'COLUMN', @level2name = N'is_default'
GO

-- ----------------------------
-- Records of sys_user_tenant
-- ----------------------------

-- ----------------------------
-- Table structure for sys_users
-- ----------------------------

CREATE TABLE [dbo].[sys_users] (
[id] int NOT NULL IDENTITY(1,1) ,
[username] nvarchar(50) NOT NULL DEFAULT '' ,
[password] nvarchar(255) NOT NULL DEFAULT '' ,
[email] nvarchar(100) NULL DEFAULT '' ,
[status] tinyint NULL DEFAULT ((1)) ,
[dept_id] int NULL DEFAULT ((0)) ,
[phone] nvarchar(64) NULL DEFAULT '' ,
[sex] nvarchar(64) NULL DEFAULT '' ,
[nick_name] nvarchar(100) NULL DEFAULT '' ,
[avatar] nvarchar(255) NULL DEFAULT '' ,
[description] nvarchar(500) NULL ,
[created_at] datetime NULL ,
[updated_at] datetime NULL ,
[deleted_at] datetime NULL ,
[created_by] int NULL DEFAULT ((0)) ,
[tenant_id] int NULL DEFAULT ((0)) 
)


GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_users', 
'COLUMN', N'username')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'用户名'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_users'
, @level2type = 'COLUMN', @level2name = N'username'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'用户名'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_users'
, @level2type = 'COLUMN', @level2name = N'username'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_users', 
'COLUMN', N'password')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'密码'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_users'
, @level2type = 'COLUMN', @level2name = N'password'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'密码'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_users'
, @level2type = 'COLUMN', @level2name = N'password'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_users', 
'COLUMN', N'email')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'邮箱'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_users'
, @level2type = 'COLUMN', @level2name = N'email'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'邮箱'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_users'
, @level2type = 'COLUMN', @level2name = N'email'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_users', 
'COLUMN', N'status')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'是否启用 0停用 1启用'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_users'
, @level2type = 'COLUMN', @level2name = N'status'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'是否启用 0停用 1启用'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_users'
, @level2type = 'COLUMN', @level2name = N'status'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_users', 
'COLUMN', N'dept_id')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'部门ID'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_users'
, @level2type = 'COLUMN', @level2name = N'dept_id'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'部门ID'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_users'
, @level2type = 'COLUMN', @level2name = N'dept_id'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_users', 
'COLUMN', N'phone')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'电话'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_users'
, @level2type = 'COLUMN', @level2name = N'phone'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'电话'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_users'
, @level2type = 'COLUMN', @level2name = N'phone'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_users', 
'COLUMN', N'sex')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'性别'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_users'
, @level2type = 'COLUMN', @level2name = N'sex'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'性别'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_users'
, @level2type = 'COLUMN', @level2name = N'sex'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_users', 
'COLUMN', N'nick_name')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'昵称'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_users'
, @level2type = 'COLUMN', @level2name = N'nick_name'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'昵称'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_users'
, @level2type = 'COLUMN', @level2name = N'nick_name'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_users', 
'COLUMN', N'avatar')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'头像'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_users'
, @level2type = 'COLUMN', @level2name = N'avatar'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'头像'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_users'
, @level2type = 'COLUMN', @level2name = N'avatar'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_users', 
'COLUMN', N'description')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'描述'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_users'
, @level2type = 'COLUMN', @level2name = N'description'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'描述'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_users'
, @level2type = 'COLUMN', @level2name = N'description'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_users', 
'COLUMN', N'created_by')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'创建人'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_users'
, @level2type = 'COLUMN', @level2name = N'created_by'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'创建人'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_users'
, @level2type = 'COLUMN', @level2name = N'created_by'
GO
IF ((SELECT COUNT(*) from fn_listextendedproperty('MS_Description', 
'SCHEMA', N'dbo', 
'TABLE', N'sys_users', 
'COLUMN', N'tenant_id')) > 0) 
EXEC sp_updateextendedproperty @name = N'MS_Description', @value = N'租户ID字段'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_users'
, @level2type = 'COLUMN', @level2name = N'tenant_id'
ELSE
EXEC sp_addextendedproperty @name = N'MS_Description', @value = N'租户ID字段'
, @level0type = 'SCHEMA', @level0name = N'dbo'
, @level1type = 'TABLE', @level1name = N'sys_users'
, @level2type = 'COLUMN', @level2name = N'tenant_id'
GO

-- ----------------------------
-- Records of sys_users
-- ----------------------------
SET IDENTITY_INSERT [dbo].[sys_users] ON
GO
INSERT INTO [dbo].[sys_users] ([id], [username], [password], [email], [status], [dept_id], [phone], [sex], [nick_name], [avatar], [description], [created_at], [updated_at], [deleted_at], [created_by], [tenant_id]) VALUES (N'1', N'admin', N'$2a$10$0aS9FxWlOz/PXiqzsBr7huy.Dqdwucyb795qiWcA6fsn0Lu.GLA.C', N'admin@example.com', N'1', N'1', N'18800000006', N'1', N'超级管理员', N'/public/uploads/2025-11-04/20251104_0945787a-8536-45fc-ba75-e94c8daaec06.jpeg', N'超级管理员', N'2025-08-18 14:55:05.000', N'2025-12-10 09:14:25.347', null, N'0', N'0')
GO
GO
SET IDENTITY_INSERT [dbo].[sys_users] OFF
GO

-- ----------------------------
-- Indexes structure for table demo_students
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table demo_students
-- ----------------------------
ALTER TABLE [dbo].[demo_students] ADD PRIMARY KEY ([student_id])
GO

-- ----------------------------
-- Indexes structure for table demo_teacher
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table demo_teacher
-- ----------------------------
ALTER TABLE [dbo].[demo_teacher] ADD PRIMARY KEY ([id])
GO

-- ----------------------------
-- Indexes structure for table example
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table example
-- ----------------------------
ALTER TABLE [dbo].[example] ADD PRIMARY KEY ([id])
GO

-- ----------------------------
-- Indexes structure for table sys_affix
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table sys_affix
-- ----------------------------
ALTER TABLE [dbo].[sys_affix] ADD PRIMARY KEY ([id])
GO

-- ----------------------------
-- Indexes structure for table sys_api
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table sys_api
-- ----------------------------
ALTER TABLE [dbo].[sys_api] ADD PRIMARY KEY ([id])
GO

-- ----------------------------
-- Indexes structure for table sys_casbin_rule
-- ----------------------------
CREATE UNIQUE INDEX [idx_sys_casbin_rule] ON [dbo].[sys_casbin_rule]
([ptype] ASC, [v0] ASC, [v1] ASC, [v2] ASC, [v3] ASC, [v4] ASC, [v5] ASC) 
WITH (IGNORE_DUP_KEY = ON)
GO
