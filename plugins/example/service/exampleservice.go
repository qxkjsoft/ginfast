package service

import (
	"gin-fast/plugins/example/models"

	"github.com/gin-gonic/gin"
)

// ExampleService 示例服务
type ExampleService struct{}

// NewExampleService 创建示例服务
func NewExampleService() *ExampleService {
	return &ExampleService{}
}

// Create 创建示例
func (s *ExampleService) Create(c *gin.Context, req models.CreateRequest) (*models.Example, error) {
	// 创建示例记录
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
		return err
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
		return err
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
