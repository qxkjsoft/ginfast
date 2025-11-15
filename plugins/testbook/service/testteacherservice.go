package service

import (
	"gin-fast/plugins/testbook/models"
	"github.com/gin-gonic/gin"
)

// TestTeacherService demo_teacher服务
type TestTeacherService struct{}

// NewTestTeacherService 创建demo_teacher服务
func NewTestTeacherService() *TestTeacherService {
	return &TestTeacherService{}
}

// Create 创建demo_teacher
func (s *TestTeacherService) Create(c *gin.Context, req models.TestTeacherCreateRequest) (*models.TestTeacher, error) {
	// 创建demo_teacher记录
	testTeacher := models.NewTestTeacher()
    testTeacher.TcName = req.TcName
    testTeacher.EmployeeId = req.EmployeeId
    testTeacher.Gender = req.Gender
    testTeacher.Phone = req.Phone
    testTeacher.Email = req.Email
    testTeacher.Subject = req.Subject
    testTeacher.Title = req.Title
    testTeacher.Status = req.Status
    testTeacher.HireDate = req.HireDate
    testTeacher.BirthDate = req.BirthDate
	// 保存到数据库
	if err := testTeacher.Create(c); err != nil {
		return nil, err
	}

	return testTeacher, nil
}

// Update 更新demo_teacher
func (s *TestTeacherService) Update(c *gin.Context, req models.TestTeacherUpdateRequest) error {
	// 查找demo_teacher记录
	testTeacher := models.NewTestTeacher()
	if err := testTeacher.GetByID(c, req.TcId); err != nil {
		return err
	}
	// 更新demo_teacher信息
    testTeacher.TcName = req.TcName
    testTeacher.EmployeeId = req.EmployeeId
    testTeacher.Gender = req.Gender
    testTeacher.Phone = req.Phone
    testTeacher.Email = req.Email
    testTeacher.Subject = req.Subject
    testTeacher.Title = req.Title
    testTeacher.Status = req.Status
    testTeacher.HireDate = req.HireDate
    testTeacher.BirthDate = req.BirthDate
	// 保存到数据库
	if err := testTeacher.Update(c); err != nil {
		return err
	}
	return nil
}

// Delete 删除demo_teacher
func (s *TestTeacherService) Delete(c *gin.Context, id uint) error {
	// 查找demo_teacher记录
	testTeacher := models.NewTestTeacher()
	if err := testTeacher.GetByID(c, id); err != nil {
		return err
	}

	// 删除数据库记录
	if err := testTeacher.Delete(c); err != nil {
		return err
	}

	return nil
}

// GetByID 根据ID获取demo_teacher
func (s *TestTeacherService) GetByID(c *gin.Context, id uint) (*models.TestTeacher, error) {
	// 查找demo_teacher记录
	testTeacher := models.NewTestTeacher()
	if err := testTeacher.GetByID(c, id); err != nil {
		return nil, err
	}

	return testTeacher, nil
}

// List demo_teacher列表（分页查询）
func (s *TestTeacherService) List(c *gin.Context, req models.TestTeacherListRequest) (*models.TestTeacherList, int64, error) {
	// 获取总数
	testTeacherList := models.NewTestTeacherList()
	total, err := testTeacherList.GetTotal(c, req.Handle())
	if err != nil {
		return nil, 0, err
	}

	// 获取分页数据
	err = testTeacherList.Find(c,req.Paginate(),req.Handle())
	if err != nil {
		return nil, 0, err
	}

	return testTeacherList, total, nil
}