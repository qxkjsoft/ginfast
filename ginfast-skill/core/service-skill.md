---
name: service
description: 创建服务层时
modeSlugs:
  - code
  - architect
---

# 服务层开发指南

服务层（Service）负责处理业务逻辑，介于控制器和模型之间，实现业务逻辑的封装和复用。

## 目录

- [快速开始](#快速开始)
- [App 目录开发](#app-目录开发)
- [Plugin 目录开发](#plugin-目录开发)
- [最佳实践](#最佳实践)

---

## 快速开始

### 服务层基本结构

```go
package service

import (
    "github.com/gin-gonic/gin"
)

// ExampleService 示例服务
type ExampleService struct{}

// NewExampleService 创建示例服务
func NewExampleService() *ExampleService {
    return &ExampleService{}
}
```

### 服务层职责

- **业务逻辑处理**：实现复杂的业务规则和逻辑
- **数据验证**：在数据持久化前进行业务级别的验证
- **事务管理**：协调多个模型操作，确保数据一致性
- **外部服务调用**：调用第三方 API 或服务
- **数据转换**：将模型数据转换为控制器需要的格式

---

## App 目录开发

### 文件位置

```
app/service/
└── exampleservice.go
```

### 完整示例

```go
// app/service/exampleservice.go
package service

import (
    "errors"
    "gin-fast/app/models"

    "github.com/gin-gonic/gin"
    "gorm.io/gorm"
)

// ExampleService 示例服务
type ExampleService struct{}

// NewExampleService 创建示例服务
func NewExampleService() *ExampleService {
    return &ExampleService{}
}

// Create 创建示例
func (s *ExampleService) Create(c *gin.Context, req models.CreateRequest) (*models.Example, error) {
    // 业务验证
    if exists, err := s.checkNameExists(c, req.Name); err != nil {
        return nil, err
    } else if exists {
        return nil, errors.New("示例名称已存在")
    }

    // 创建模型实例
    example := models.NewExample()
    example.Name = req.Name
    example.Description = req.Description

    // 保存到数据库
    if err := example.Create(c); err != nil {
        return nil, err
    }

    return example, nil
}

// Update 更新示例
func (s *ExampleService) Update(c *gin.Context, req models.UpdateRequest) error {
    // 查找示例记录
    example := models.NewExample()
    if err := example.GetByID(c, req.ID); err != nil {
        if errors.Is(err, gorm.ErrRecordNotFound) {
            return errors.New("示例不存在")
        }
        return err
    }

    // 业务验证：检查名称是否被其他记录使用
    if example.Name != req.Name {
        if exists, err := s.checkNameExists(c, req.Name); err != nil {
            return err
        } else if exists {
            return errors.New("示例名称已存在")
        }
    }

    // 更新示例信息
    example.Name = req.Name
    example.Description = req.Description

    // 保存到数据库
    if err := example.Update(c); err != nil {
        return err
    }

    return nil
}

// Delete 删除示例
func (s *ExampleService) Delete(c *gin.Context, id uint) error {
    // 查找示例记录
    example := models.NewExample()
    if err := example.GetByID(c, id); err != nil {
        if errors.Is(err, gorm.ErrRecordNotFound) {
            return errors.New("示例不存在")
        }
        return err
    }

    // 业务验证：检查是否可以删除
    if s.isInUse(c, id) {
        return errors.New("示例正在使用中，无法删除")
    }

    // 删除数据库记录
    if err := example.Delete(c); err != nil {
        return err
    }

    return nil
}

// GetByID 根据ID获取示例
func (s *ExampleService) GetByID(c *gin.Context, id uint) (*models.Example, error) {
    // 查找示例记录
    example := models.NewExample()
    if err := example.GetByID(c, id); err != nil {
        if errors.Is(err, gorm.ErrRecordNotFound) {
            return nil, errors.New("示例不存在")
        }
        return nil, err
    }

    return example, nil
}

// List 示例列表（分页查询）
func (s *ExampleService) List(c *gin.Context, req models.ListRequest) (*models.ExampleList, int64, error) {
    // 获取总数
    exampleList := models.NewExampleList()
    total, err := exampleList.GetTotal(c, req.Handle())
    if err != nil {
        return nil, 0, err
    }

    // 获取分页数据
    err = exampleList.Find(c, req.Handle(), req.Paginate())
    if err != nil {
        return nil, 0, err
    }

    return exampleList, total, nil
}

// checkNameExists 检查名称是否存在
func (s *ExampleService) checkNameExists(c *gin.Context, name string) (bool, error) {
    example := models.NewExample()
    err := example.GetByName(c, name)
    if err != nil {
        if errors.Is(err, gorm.ErrRecordNotFound) {
            return false, nil
        }
        return false, err
    }
    return true, nil
}

// isInUse 检查示例是否正在使用中
func (s *ExampleService) isInUse(c *gin.Context, id uint) bool {
    // 实现业务逻辑：检查示例是否被其他记录引用
    // 这里只是一个示例，实际实现取决于业务需求
    return false
}
```

---

## Plugin 目录开发

### 文件位置

```
plugins/
└── example/
    └── service/
        └── exampleservice.go
```

### 完整示例

```go
// plugins/example/service/exampleservice.go
package service

import (
    "errors"
    "gin-fast/plugins/example/models"

    "github.com/gin-gonic/gin"
    "gorm.io/gorm"
)

// ExampleService 示例服务
type ExampleService struct{}

// NewExampleService 创建示例服务
func NewExampleService() *ExampleService {
    return &ExampleService{}
}

// Create 创建示例
func (s *ExampleService) Create(c *gin.Context, req models.CreateRequest) (*models.Example, error) {
    // 业务验证
    if exists, err := s.checkNameExists(c, req.Name); err != nil {
        return nil, err
    } else if exists {
        return nil, errors.New("示例名称已存在")
    }

    // 创建模型实例
    example := models.NewExample()
    example.Name = req.Name
    example.Description = req.Description

    // 保存到数据库
    if err := example.Create(c); err != nil {
        return nil, err
    }

    return example, nil
}

// Update 更新示例
func (s *ExampleService) Update(c *gin.Context, req models.UpdateRequest) error {
    // 查找示例记录
    example := models.NewExample()
    if err := example.GetByID(c, req.ID); err != nil {
        if errors.Is(err, gorm.ErrRecordNotFound) {
            return errors.New("示例不存在")
        }
        return err
    }

    // 业务验证：检查名称是否被其他记录使用
    if example.Name != req.Name {
        if exists, err := s.checkNameExists(c, req.Name); err != nil {
            return err
        } else if exists {
            return errors.New("示例名称已存在")
        }
    }

    // 更新示例信息
    example.Name = req.Name
    example.Description = req.Description

    // 保存到数据库
    if err := example.Update(c); err != nil {
        return err
    }

    return nil
}

// Delete 删除示例
func (s *ExampleService) Delete(c *gin.Context, id uint) error {
    // 查找示例记录
    example := models.NewExample()
    if err := example.GetByID(c, id); err != nil {
        if errors.Is(err, gorm.ErrRecordNotFound) {
            return errors.New("示例不存在")
        }
        return err
    }

    // 业务验证：检查是否可以删除
    if s.isInUse(c, id) {
        return errors.New("示例正在使用中，无法删除")
    }

    // 删除数据库记录
    if err := example.Delete(c); err != nil {
        return err
    }

    return nil
}

// GetByID 根据ID获取示例
func (s *ExampleService) GetByID(c *gin.Context, id uint) (*models.Example, error) {
    // 查找示例记录
    example := models.NewExample()
    if err := example.GetByID(c, id); err != nil {
        if errors.Is(err, gorm.ErrRecordNotFound) {
            return nil, errors.New("示例不存在")
        }
        return nil, err
    }

    return example, nil
}

// List 示例列表（分页查询）
func (s *ExampleService) List(c *gin.Context, req models.ListRequest) (*models.ExampleList, int64, error) {
    // 获取总数
    exampleList := models.NewExampleList()
    total, err := exampleList.GetTotal(c, req.Handle())
    if err != nil {
        return nil, 0, err
    }

    // 获取分页数据
    err = exampleList.Find(c, req.Handle(), req.Paginate())
    if err != nil {
        return nil, 0, err
    }

    return exampleList, total, nil
}

// checkNameExists 检查名称是否存在
func (s *ExampleService) checkNameExists(c *gin.Context, name string) (bool, error) {
    example := models.NewExample()
    err := example.GetByName(c, name)
    if err != nil {
        if errors.Is(err, gorm.ErrRecordNotFound) {
            return false, nil
        }
        return false, err
    }
    return true, nil
}

// isInUse 检查示例是否正在使用中
func (s *ExampleService) isInUse(c *gin.Context, id uint) bool {
    // 实现业务逻辑：检查示例是否被其他记录引用
    // 这里只是一个示例，实际实现取决于业务需求
    return false
}
```

---

## 最佳实践

### 1. 单一职责原则

每个服务方法只做一件事：

```go
// 好的做法：每个方法职责单一
func (s *ExampleService) Create(c *gin.Context, req models.CreateRequest) (*models.Example, error) {
    // 验证
    if err := s.validateCreate(c, req); err != nil {
        return nil, err
    }
    // 创建
    return s.doCreate(c, req)
}

// 不好的做法：一个方法做太多事情
func (s *ExampleService) CreateAndNotify(c *gin.Context, req models.CreateRequest) (*models.Example, error) {
    // 创建、发送通知、记录日志... 职责太多
}
```

### 2. 错误处理

统一错误处理和错误消息：

```go
func (s *ExampleService) GetByID(c *gin.Context, id uint) (*models.Example, error) {
    example := models.NewExample()
    if err := example.GetByID(c, id); err != nil {
        if errors.Is(err, gorm.ErrRecordNotFound) {
            return nil, errors.New("示例不存在")
        }
        return nil, errors.New("查询示例失败")
    }
    return example, nil
}
```

### 3. 业务验证

在服务层进行业务级别的验证：

```go
func (s *ExampleService) Create(c *gin.Context, req models.CreateRequest) (*models.Example, error) {
    // 业务验证：检查名称唯一性
    if exists, err := s.checkNameExists(c, req.Name); err != nil {
        return nil, err
    } else if exists {
        return nil, errors.New("示例名称已存在")
    }

    // 业务验证：检查业务规则
    if !s.isValidName(req.Name) {
        return nil, errors.New("示例名称不符合规范")
    }

    // 继续处理...
}
```

### 4. 事务处理

对于需要多个数据库操作的方法，使用事务：

```go
import (
    "gin-fast/app/global/app"
    "gorm.io/gorm"
)

func (s *ExampleService) CreateWithRelation(c *gin.Context, req models.CreateRequest) error {
    return app.DB().WithContext(c).Transaction(func(tx *gorm.DB) error {
        // 创建示例
        example := models.NewExample()
        example.Name = req.Name
        if err := tx.Create(example).Error; err != nil {
            return err
        }

        // 创建关联记录
        relation := models.NewRelation()
        relation.ExampleID = example.ID
        if err := tx.Create(relation).Error; err != nil {
            return err
        }

        return nil
    })
}
```

### 5. 私有辅助方法

将复杂的逻辑拆分为私有辅助方法：

```go
type ExampleService struct{}

// 公开方法
func (s *ExampleService) Create(c *gin.Context, req models.CreateRequest) (*models.Example, error) {
    if err := s.validateCreate(c, req); err != nil {
        return nil, err
    }
    return s.doCreate(c, req)
}

// 私有辅助方法
func (s *ExampleService) validateCreate(c *gin.Context, req models.CreateRequest) error {
    if req.Name == "" {
        return errors.New("名称不能为空")
    }
    return nil
}

func (s *ExampleService) doCreate(c *gin.Context, req models.CreateRequest) (*models.Example, error) {
    example := models.NewExample()
    example.Name = req.Name
    if err := example.Create(c); err != nil {
        return nil, err
    }
    return example, nil
}
```

### 6. 服务间调用

一个服务可以调用其他服务：

```go
import (
    "gin-fast/app/service"
)

type ExampleService struct{}

func (s *ExampleService) CreateWithUser(c *gin.Context, req models.CreateRequest) (*models.Example, error) {
    // 调用用户服务
    userService := service.NewUserService()
    user, err := userService.GetByID(c, req.UserID)
    if err != nil {
        return nil, errors.New("用户不存在")
    }

    // 创建示例
    example := models.NewExample()
    example.Name = req.Name
    example.CreatedBy = user.ID
    if err := example.Create(c); err != nil {
        return nil, err
    }

    return example, nil
}
```

### 7. 上下文传递

始终将 `gin.Context` 传递给模型方法：

```go
func (s *ExampleService) Create(c *gin.Context, req models.CreateRequest) (*models.Example, error) {
    example := models.NewExample()
    example.Name = req.Name

    // 将 context 传递给模型方法
    if err := example.Create(c); err != nil {
        return nil, err
    }

    return example, nil
}
```

### 8. 数据转换

在服务层进行数据转换：

```go
func (s *ExampleService) GetDetail(c *gin.Context, id uint) (*ExampleDetail, error) {
    // 获取示例
    example := models.NewExample()
    if err := example.GetByID(c, id); err != nil {
        return nil, err
    }

    // 获取关联数据
    userService := service.NewUserService()
    user, err := userService.GetByID(c, example.CreatedBy)
    if err != nil {
        return nil, err
    }

    // 转换为返回格式
    return &ExampleDetail{
        ID:          example.ID,
        Name:        example.Name,
        Description: example.Description,
        CreatedBy:   user.Username,
        CreatedAt:   example.CreatedAt,
    }, nil
}

// ExampleDetail 返回的数据结构
type ExampleDetail struct {
    ID          uint
    Name        string
    Description string
    CreatedBy   string
    CreatedAt   time.Time
}
```

---

## 参考资源

### 项目内部资源

- [`app/service/userservice.go`](../app/service/userservice.go) - 用户服务示例
- [`app/service/sysroleservice.go`](../app/service/sysroleservice.go) - 角色服务示例
- [`plugins/example/service/exampleservice.go`](../plugins/example/service/exampleservice.go) - 插件服务示例
