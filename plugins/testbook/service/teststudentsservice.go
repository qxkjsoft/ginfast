package service

import (
	"gin-fast/plugins/testbook/models"
	"github.com/gin-gonic/gin"
)

// TestStudentsService demo_students服务
type TestStudentsService struct{}

// NewTestStudentsService 创建demo_students服务
func NewTestStudentsService() *TestStudentsService {
	return &TestStudentsService{}
}

// Create 创建demo_students
func (s *TestStudentsService) Create(c *gin.Context, req models.TestStudentsCreateRequest) (*models.TestStudents, error) {
	// 创建demo_students记录
	testStudents := models.NewTestStudents()
    testStudents.StuName = req.StuName
    testStudents.Age = req.Age
    testStudents.Gender = req.Gender
    testStudents.ClassName = req.ClassName
    testStudents.AdmissionDate = req.AdmissionDate
    testStudents.Address = req.Address
	// 保存到数据库
	if err := testStudents.Create(c); err != nil {
		return nil, err
	}

	return testStudents, nil
}

// Update 更新demo_students
func (s *TestStudentsService) Update(c *gin.Context, req models.TestStudentsUpdateRequest) error {
	// 查找demo_students记录
	testStudents := models.NewTestStudents()
	if err := testStudents.GetByID(c, req.StuId); err != nil {
		return err
	}
	// 更新demo_students信息
    testStudents.StuName = req.StuName
    testStudents.Age = req.Age
    testStudents.Gender = req.Gender
    testStudents.ClassName = req.ClassName
    testStudents.AdmissionDate = req.AdmissionDate
    testStudents.Address = req.Address
	// 保存到数据库
	if err := testStudents.Update(c); err != nil {
		return err
	}
	return nil
}

// Delete 删除demo_students
func (s *TestStudentsService) Delete(c *gin.Context, id uint) error {
	// 查找demo_students记录
	testStudents := models.NewTestStudents()
	if err := testStudents.GetByID(c, id); err != nil {
		return err
	}

	// 删除数据库记录
	if err := testStudents.Delete(c); err != nil {
		return err
	}

	return nil
}

// GetByID 根据ID获取demo_students
func (s *TestStudentsService) GetByID(c *gin.Context, id uint) (*models.TestStudents, error) {
	// 查找demo_students记录
	testStudents := models.NewTestStudents()
	if err := testStudents.GetByID(c, id); err != nil {
		return nil, err
	}

	return testStudents, nil
}

// List demo_students列表（分页查询）
func (s *TestStudentsService) List(c *gin.Context, req models.TestStudentsListRequest) (*models.TestStudentsList, int64, error) {
	// 获取总数
	testStudentsList := models.NewTestStudentsList()
	total, err := testStudentsList.GetTotal(c, req.Handle())
	if err != nil {
		return nil, 0, err
	}

	// 获取分页数据
	err = testStudentsList.Find(c,req.Paginate(),req.Handle())
	if err != nil {
		return nil, 0, err
	}

	return testStudentsList, total, nil
}