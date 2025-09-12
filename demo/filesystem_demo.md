# Filesystem 工具使用演示

这是一个使用 filesystem 工具的演示文件。

## 项目信息

- **项目名称**: gin-fast
- **技术栈**: Go + Gin + GORM + JWT + Casbin
- **数据库**: MySQL、SQL Server、PostgreSQL

## 主要功能特性

✅ JWT 认证系统
✅ 基于 Casbin 的权限控制  
✅ 多数据库支持
✅ 配置管理
✅ 日志系统
✅ 缓存支持
✅ 性能监控

## 快速开始

```bash
# 安装依赖
go mod tidy

# 启动应用
go run main.go
```

这个文件是通过 filesystem 工具创建的演示文件。

创建时间: 2025年9月12日

## 使用的 Filesystem 工具

1. **mcp_filesystem_list_allowed_directories** - 列出允许访问的目录
2. **mcp_filesystem_list_directory** - 列出目录内容
3. **mcp_filesystem_directory_tree** - 查看目录树结构
4. **mcp_filesystem_read_text_file** - 读取文本文件
5. **mcp_filesystem_get_file_info** - 获取文件信息
6. **mcp_filesystem_search_files** - 搜索文件
7. **mcp_filesystem_read_multiple_files** - 批量读取文件
8. **mcp_filesystem_create_directory** - 创建目录
9. **mcp_filesystem_write_file** - 写入文件
10. **mcp_filesystem_edit_file** - 编辑文件