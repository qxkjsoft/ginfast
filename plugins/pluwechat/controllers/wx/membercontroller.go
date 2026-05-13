package wx

import (
	"gin-fast/app/controllers"
	"gin-fast/app/global/app"
	sysModel "gin-fast/app/models"
	"gin-fast/app/utils/common"
	"gin-fast/app/utils/filehelper"

	"gin-fast/plugins/pluwechat/middleware"
	"gin-fast/plugins/pluwechat/models"
	"gin-fast/plugins/pluwechat/utils"

	"gin-fast/plugins/pluwechat/utils/tokeneasy"
	"gin-fast/plugins/pluwechat/utils/wxhelper"
	"time"

	"github.com/gin-gonic/gin"
)

type MemberController struct {
	controllers.Common
}

func NewMemberController() *MemberController {
	return &MemberController{}
}

// Login 微信小程序登录
func (c *MemberController) Login(ctx *gin.Context) {
	var req models.WxLoginRequest
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, err.Error(), err)
	}

	// 获取手机号
	miniProgram, err := wxhelper.GetMiniProgram()
	if err != nil {
		c.FailAndAbort(ctx, "获取小程序实例失败", err)
	}
	res, err := miniProgram.PhoneNumber.GetUserPhoneNumber(ctx, req.PhoneCode)
	if err != nil {
		c.FailAndAbort(ctx, "获取手机号失败", err)
	}
	phone := res.PhoneInfo.PhoneNumber

	// 获取session和openid
	session, err := miniProgram.Auth.Session(ctx, req.Code)
	if err != nil {
		c.FailAndAbort(ctx, "登录失败", err)
	}
	openID := session.OpenID

	// 根据手机号查询会员
	member := models.NewMember()
	err = member.GetByPhone(ctx, phone)

	if err != nil {
		c.FailAndAbort(ctx, "查询会员失败", err)
	}

	// 如果会员不存在，创建新会员
	if member.IsEmpty() {
		member.Phone = phone
		member.OpenID = openID
		member.Status = 1                        // 启用状态
		member.Username = "wx_" + phone          // 使用手机号作为用户名前缀
		member.NickName = utils.MaskPhone(phone) // 使用脱敏后的手机号作为昵称
		if err := member.Create(ctx); err != nil {
			c.FailAndAbort(ctx, "创建会员失败", err)
		}
	} else {
		// 会员已存在，检查openid是否一致
		if member.OpenID != openID {
			member.OpenID = openID
			if err := member.Update(ctx); err != nil {
				c.FailAndAbort(ctx, "更新会员OpenID失败", err)
			}
		}

		// 更新登录信息
		member.LastLoginAt = sysModel.NewJSONTime(time.Now())
		member.LastLoginIP = ctx.ClientIP()
		member.LoginCount += 1
		if err := member.Update(ctx); err != nil {
			c.FailAndAbort(ctx, "更新登录信息失败", err)
		}
	}

	if member.Status != 1 {
		c.FailAndAbort(ctx, "会员已被禁用", nil)
	}

	// 生成token
	claimsUser := &app.ClaimsUser{
		UserID:   member.ID,
		Username: member.Username,
	}

	token, err := tokeneasy.GetTokenService().GenerateTokenWithCache(claimsUser)
	if err != nil {
		c.FailAndAbort(ctx, "生成token失败", err)
	}
	claims, err := tokeneasy.GetTokenService().ParseToken(token)
	if err != nil {
		c.FailAndAbort(ctx, "解析token失败", err)
	}
	// 返回token和用户信息
	c.Success(ctx, map[string]interface{}{
		"token":              token,
		"accessTokenExpires": claims.ExpiresAt,
		"user": models.WxMemberInfoResponse{
			ID:       member.ID,
			Username: member.Username,
			NickName: member.NickName,
			Avatar:   member.Avatar,
			Phone:    member.Phone,
		},
	})
}

func (ac *MemberController) Logout(c *gin.Context) {
	// 撤销 access token
	tokenString, err := common.GetAccessToken(c)
	if err == nil && tokenString != "" {
		// 尝试撤销access token，即使失败也继续执行
		tokeneasy.GetTokenService().RevokeTokenWithCache(tokenString)
	}

	ac.Success(c, gin.H{
		"message": "登出成功",
	})
}

func (c *MemberController) LoginByCode(ctx *gin.Context) {
	var req models.WxLoginByCodeRequest
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, err.Error(), err)
	}
	miniProgramApp, err := wxhelper.GetMiniProgramApp()
	if err != nil {
		c.FailAndAbort(ctx, "小程序实例未初始化", err)
	}
	miniProgram, err := miniProgramApp.GetMiniProgram()
	if err != nil {
		c.FailAndAbort(ctx, "获取小程序实例失败", err)
	}

	// 获取session和openid
	session, err := miniProgram.Auth.Session(ctx, req.Code)
	if err != nil {
		c.FailAndAbort(ctx, "登录失败", err)
	}
	openID := session.OpenID

	// 根据openid查询会员
	member := models.NewMember()
	err = member.GetByOpenID(ctx, openID)

	if err != nil {
		c.FailAndAbort(ctx, "查询会员失败", err)
	}

	// 如果会员不存在，返回错误
	if member.IsEmpty() {
		c.FailAndAbort(ctx, "会员不存在，请先绑定手机号", nil)
	}

	// 检查会员状态
	if member.Status != 1 {
		c.FailAndAbort(ctx, "会员已被禁用", nil)
	}

	// 更新登录信息
	member.LastLoginAt = sysModel.NewJSONTime(time.Now())
	member.LastLoginIP = ctx.ClientIP()
	member.LoginCount += 1
	if err := member.Update(ctx); err != nil {
		c.FailAndAbort(ctx, "更新登录信息失败", err)
	}

	// 生成token
	claimsUser := &app.ClaimsUser{
		UserID:   member.ID,
		Username: member.Username,
	}

	token, err := tokeneasy.GetTokenService().GenerateTokenWithCache(claimsUser)
	if err != nil {
		c.FailAndAbort(ctx, "生成token失败", err)
	}
	claims, err := tokeneasy.GetTokenService().ParseToken(token)
	if err != nil {
		c.FailAndAbort(ctx, "解析token失败", err)
	}
	// 返回token和用户信息
	c.Success(ctx, map[string]interface{}{
		"token":              token,
		"accessTokenExpires": claims.ExpiresAt,
		"user": models.WxMemberInfoResponse{
			ID:       member.ID,
			Username: member.Username,
			NickName: member.NickName,
			Avatar:   member.Avatar,
			Phone:    member.Phone,
		},
	})
}

// UserInfo 获取当前登录会员的信息
func (c *MemberController) UserInfo(ctx *gin.Context) {
	// 从上下文获取会员信息
	claims := middleware.GetWxMemberClaims(ctx)
	if claims == nil {
		c.FailAndAbort(ctx, "未认证", nil)
	}

	// 根据用户ID查询会员信息
	member := models.NewMember()
	err := member.GetByID(ctx, claims.UserID)
	if err != nil {
		c.FailAndAbort(ctx, "查询会员信息失败", err)
	}

	// 检查会员是否存在
	if member.IsEmpty() {
		c.FailAndAbort(ctx, "会员不存在", nil)
	}

	// 检查会员状态
	if member.Status != 1 {
		c.FailAndAbort(ctx, "会员已被禁用", nil)
	}

	// 返回会员信息
	c.Success(ctx, map[string]interface{}{
		"user": models.WxMemberInfoResponse{
			ID:       member.ID,
			Username: member.Username,
			NickName: member.NickName,
			Avatar:   member.Avatar,
			Phone:    member.Phone,
		},
	})
}

// ValidateToken 验证token是否有效
func (c *MemberController) ValidateToken(ctx *gin.Context) {
	tokenString, err := common.GetAccessToken(ctx)
	if err != nil {
		c.FailAndAbort(ctx, "获取token失败", err)
	}

	// 验证token
	claims, err := tokeneasy.GetTokenService().ValidateTokenWithCache(tokenString)
	if err != nil {
		c.FailAndAbort(ctx, "token无效", err)
	}

	// 返回验证结果和用户信息
	c.Success(ctx, map[string]interface{}{
		"valid": true,
		"user": map[string]interface{}{
			"userID":   claims.UserID,
			"username": claims.Username,
		},
	})
}

// UpdateProfile 更新用户昵称及头像
func (c *MemberController) UpdateProfile(ctx *gin.Context) {
	var req models.WxUpdateProfileRequest
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, err.Error(), err)
	}
	if req.NickName == "" && req.Avatar == "" {
		c.FailAndAbort(ctx, "昵称和头像不能为空", nil)
	}
	// 从上下文获取会员信息
	claims := middleware.GetWxMemberClaims(ctx)
	if claims == nil {
		c.FailAndAbort(ctx, "未认证", nil)
	}
	// 根据用户ID查询会员信息
	member := models.NewMember()
	err := member.GetByID(ctx, claims.UserID)
	if err != nil {
		c.FailAndAbort(ctx, "查询会员信息失败", err)
	}

	// 检查会员是否存在
	if member.IsEmpty() {
		c.FailAndAbort(ctx, "会员不存在", nil)
	}

	// 检查会员状态
	if member.Status != 1 {
		c.FailAndAbort(ctx, "会员已被禁用", nil)
	}

	// 更新昵称和头像
	if req.NickName != "" {
		member.NickName = req.NickName
	}
	if req.Avatar != "" {
		member.Avatar = req.Avatar
	}

	// 保存更新
	if err := member.Update(ctx); err != nil {
		c.FailAndAbort(ctx, "更新会员信息失败", err)
	}

	// 返回更新后的会员信息
	c.Success(ctx, map[string]interface{}{
		"user": models.WxMemberInfoResponse{
			ID:       member.ID,
			Username: member.Username,
			NickName: member.NickName,
			Avatar:   member.Avatar,
			Phone:    member.Phone,
		},
	})
}

// 文件上传
func (c *MemberController) Upload(ctx *gin.Context) {
	var req models.WxFileUploadRequest
	if err := req.Validate(ctx); err != nil {
		c.FailAndAbort(ctx, err.Error(), err)
	}

	// 处理文件上传
	response, err := app.UploadService.HandleUpload(ctx, "file")
	if err != nil {
		c.FailAndAbort(ctx, err.Error(), err)
	}

	// 创建文件记录
	affix := sysModel.NewSysAffix()
	affix.Name = response.FileName
	affix.Path = response.Path
	affix.Url = response.Url
	affix.Size = int(response.Size)
	affix.Suffix = response.FileType
	affix.Ftype = filehelper.GetFileTypeBySuffix(response.FileType) // 根据后缀判断文件类型

	// 保存到数据库
	if err := affix.Create(ctx); err != nil {
		c.FailAndAbort(ctx, "保存文件记录失败", err)
		return
	}

	// 返回成功响应
	c.Success(ctx, gin.H{
		"id":    affix.ID,
		"name":  affix.Name,
		"path":  affix.Path,
		"size":  affix.Size,
		"ftype": affix.Ftype,
		"url":   affix.Url,
	})
}
