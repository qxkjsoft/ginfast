package service

import (
	"context"
	"encoding/json"
	"fmt"
	"strings"
	"sync"

	"gin-fast/app/global/app"
	"gin-fast/app/models"
	"gin-fast/app/utils/ginhelper"
	"gin-fast/docs/swagger"

	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"gorm.io/gorm"
)

// SysApiService 系统API服务
type SysApiService struct{}

// NewSysApiService 创建系统API服务
func NewSysApiService() *SysApiService {
	return &SysApiService{}
}

// SyncOption 路由同步选项
type SyncOption struct {
	// Overwrite 是否覆盖已存在记录的 Title/ApiGroup
	// false（默认幂等模式）：仅插入新增，已存在的按 path+method 跳过，保留用户手工修改
	// true：用代码推导值覆盖已存在记录的 Title/ApiGroup
	Overwrite bool
	// IncludePlugins 是否纳入 /api/plugins/* 路由
	IncludePlugins bool
	// GroupByPlugin 插件路由分组是否带 plugins/ 前缀
	// true：/api/plugins/example/list -> "plugins/example"
	// false：/api/plugins/example/list -> "example"
	GroupByPlugin bool
	// DryRun true=仅计算并返回结果，不写库
	DryRun bool
	// SelectedKeys 仅同步用户勾选的路由，格式为 "path|method"
	// 为空时同步全部候选（兼容旧行为）
	// 注意：DryRun=true 的预览阶段应留空，以返回完整明细供用户勾选
	SelectedKeys []string
}

// SyncItem 单条路由同步明细
type SyncItem struct {
	Path     string `json:"path"`
	Method   string `json:"method"`
	Title    string `json:"title"`
	ApiGroup string `json:"apiGroup"`
	Handler  string `json:"handler"`
	// Action 同步动作：insert 新增 / update 更新 / skip 跳过
	Action string `json:"action"`
}

// SyncResult 路由同步结果
type SyncResult struct {
	Total      int        `json:"total"`      // 代码中符合条件的路由总数（=Inserted+Updated+Skipped）
	Inserted   int        `json:"inserted"`   // 新增条数
	Updated    int        `json:"updated"`    // 更新条数（Overwrite=true 时才可能 >0）
	Skipped    int        `json:"skipped"`    // 已存在且未覆盖的条数
	Filtered   int        `json:"filtered"`   // 被过滤规则排除的数量（不在 Total 内）
	Details    []SyncItem `json:"details"`    // 将要新增/更新/跳过的明细
	OrphanList []SyncItem `json:"orphanList"` // DB 有但代码无（仅返回提示，不操作）
}

// swaggerSummaryCache swagger summary 缓存（path -> method -> summary）
var swaggerSummaryCache map[string]map[string]string
var swaggerSummaryOnce sync.Once

// loadSwaggerSummary 加载并缓存 swagger 文档中的 summary
// 通过解析 docs/swagger/docs.go 生成的 SwaggerInfo.ReadDoc() JSON 提取每个 path+method 的 summary
func loadSwaggerSummary() map[string]map[string]string {
	swaggerSummaryOnce.Do(func() {
		swaggerSummaryCache = make(map[string]map[string]string)
		// SwaggerInfo.ReadDoc() 返回完整 swagger JSON
		doc := swaggerReadDoc()
		if doc == "" {
			return
		}
		var spec struct {
			Paths map[string]map[string]struct {
				Summary string `json:"summary"`
			} `json:"paths"`
		}
		if err := json.Unmarshal([]byte(doc), &spec); err != nil {
			app.ZapLog.Warn("解析 swagger 文档失败，Title 将回退到规则推导", zap.Error(err))
			return
		}
		for path, methods := range spec.Paths {
			if swaggerSummaryCache[path] == nil {
				swaggerSummaryCache[path] = make(map[string]string)
			}
			for method, info := range methods {
				if info.Summary != "" {
					swaggerSummaryCache[path][strings.ToUpper(method)] = info.Summary
				}
			}
		}
	})
	return swaggerSummaryCache
}

// swaggerReadDoc 安全读取 swagger 文档字符串
// 通过解析 docs/swagger/docs.go 生成的 SwaggerInfo.ReadDoc() 获取完整 swagger JSON
// 使用 recover 防止 swagger 未初始化时 panic
func swaggerReadDoc() string {
	defer func() {
		if r := recover(); r != nil {
			app.ZapLog.Warn("读取 swagger 文档 panic，Title 将回退到规则推导", zap.Any("panic", r))
		}
	}()
	if swagger.SwaggerInfo == nil {
		return ""
	}
	return swagger.SwaggerInfo.ReadDoc()
}

// actionKeywordMap 路径末段关键词 -> 中文名 映射，用于 Title 兜底推导
var actionKeywordMap = map[string]string{
	"list":              "列表",
	"add":               "新增",
	"create":            "新增",
	"edit":              "编辑",
	"update":            "更新",
	"delete":            "删除",
	"remove":            "删除",
	"batchdelete":       "批量删除",
	"batchadd":          "批量新增",
	"getbyid":           "详情",
	"get":               "详情",
	"profile":           "个人信息",
	"info":              "详情",
	"detail":            "详情",
	"tree":              "树形列表",
	"getrouters":        "路由树",
	"getmenulist":       "菜单列表",
	"getroles":          "角色列表",
	"getallDicts":       "全部字典",
	"getbycode":         "按编码查询",
	"getbydictid":       "按字典ID查询",
	"getbydictcode":     "按字典编码查询",
	"export":            "导出",
	"import":            "导入",
	"login":             "登录",
	"logout":            "登出",
	"refreshtoken":      "刷新令牌",
	"upload":            "上传",
	"download":          "下载",
	"verify":            "校验",
	"captcha":           "验证码",
	"uploadavatar":      "上传头像",
	"updatebasicinfo":   "更新基本信息",
	"updateaccount":     "更新账户",
	"switchtenant":      "切换租户",
	"setapis":           "分配API",
	"setstatus":         "设置状态",
	"executenow":        "立即执行",
	"executors":         "执行器列表",
	"initdata":          "初始化数据",
	"children":          "子节点列表",
	"search":            "搜索",
	"dat Scope":         "数据权限",
	"datascope":         "数据权限",
	"setuserroles":      "设置用户角色",
	"userlistall":       "用户列表(全部)",
	"getrolesall":       "角色列表(全部)",
	"getuserroleids":    "用户角色ID集合",
	"getuserpermission": "用户权限",
	"addrolemenu":       "分配角色菜单",
	"refreshfields":     "刷新字段",
	"batchinsert":       "批量新增",
	"databases":         "数据库列表",
	"tables":            "数据表列表",
	"columns":           "字段列表",
	"generate":          "生成代码",
	"preview":           "预览代码",
	"insertmenuandapi":  "生成菜单",
	"exports":           "插件导出配置",
	"uninstall":         "卸载",
	"getdivision":       "部门列表",
	"getconfig":         "获取配置",
	"updateconfig":      "更新配置",
}

// deriveTitle 推导 Title（API中文名称）
// 优先级：1. swagger summary  2. 路径末段关键词中文映射  3. Handler 末段名
func deriveTitle(path, method, handler string) string {
	summaryMap := loadSwaggerSummary()
	if m, ok := summaryMap[path]; ok {
		if title, ok := m[strings.ToUpper(method)]; ok && title != "" {
			return title
		}
	}
	// 取路径最后一段并归一化
	segments := strings.Split(strings.Trim(path, "/"), "/")
	if len(segments) > 0 {
		last := strings.ToLower(strings.TrimSpace(segments[len(segments)-1]))
		if last != "" {
			if cn, ok := actionKeywordMap[last]; ok {
				return cn
			}
		}
	}
	// 兜底用 Handler 名最后一段
	if handler != "" {
		if idx := strings.LastIndex(handler, "."); idx >= 0 && idx < len(handler)-1 {
			return handler[idx+1:]
		}
		return handler
	}
	return path
}

// deriveApiGroup 推导 ApiGroup
// /api/users/list -> "users"
// /api/plugins/example/list -> "plugins/example"（GroupByPlugin=true）或 "example"（GroupByPlugin=false）
func deriveApiGroup(path string, includePlugins, groupByPlugin bool) string {
	// 去掉 query 参数和尾部斜杠
	cleanPath := strings.SplitN(path, "?", 2)[0]
	cleanPath = strings.Trim(cleanPath, "/")
	segments := strings.Split(cleanPath, "/")

	// 移除开头的 "api"
	if len(segments) > 0 && strings.EqualFold(segments[0], "api") {
		segments = segments[1:]
	}

	// 判断是否为插件路由
	isPlugin := len(segments) > 0 && strings.EqualFold(segments[0], "plugins")
	if isPlugin {
		if !includePlugins {
			return ""
		}
		// segments[0]="plugins", segments[1]=插件名
		if groupByPlugin {
			// plugins/example
			if len(segments) >= 3 {
				return segments[0] + "/" + segments[1]
			}
			return strings.Join(segments, "/")
		}
		// 仅插件名
		if len(segments) >= 2 {
			return segments[1]
		}
		return "plugins"
	}

	// 普通路由：取第一个业务段（如 users / sysMenu / sysApi）
	if len(segments) > 0 {
		return segments[0]
	}
	return ""
}

// shouldFilter 判断是否应被过滤掉
func shouldFilter(route gin.RouteInfo) bool {
	// 跳过 OPTIONS / HEAD
	method := strings.ToUpper(route.Method)
	if method == "OPTIONS" || method == "HEAD" {
		return true
	}
	path := route.Path
	// 仅保留 /api/ 前缀（核心业务路由）
	if !strings.HasPrefix(path, "/api/") && path != "/api" {
		return true
	}
	// 跳过 swagger、pprof、缓存查看等调试/文档路由
	if strings.HasPrefix(path, "/api/swagger") ||
		strings.HasPrefix(path, "/api/debug") ||
		strings.HasPrefix(path, "/api/viewCache") {
		return true
	}
	return false
}

// handlerName 从 gin.RouteInfo.Handler 中提取 Handler 函数名
// 格式形如 gin-fast/app/controllers.(*SysApiController).List-fm
func handlerName(route gin.RouteInfo) string {
	h := route.Handler
	if h == "" {
		return ""
	}
	// 去掉 -fm 后缀
	if idx := strings.LastIndex(h, "-"); idx > 0 {
		h = h[:idx]
	}
	return h
}

// SyncRoutes 路由同步主入口
// 遍历全局 engine 已注册的路由，按规则推导 Title/ApiGroup，按 path+method 去重写入 sys_api 表
// 返回 SyncResult 描述本次将/已执行的明细
func (s *SysApiService) SyncRoutes(ctx context.Context, opt SyncOption) (*SyncResult, error) {
	// 从 ginhelper 取回启动时由 main.go 通过 SetEngine 注入的全局 Gin 引擎实例
	engine := ginhelper.GetSavedEngine()
	// 引擎未注入则无法读取已注册路由，直接报错中止
	if engine == nil {
		return nil, fmt.Errorf("全局 Gin 引擎实例尚未注入，请确认 main.go 已调用 ginhelper.SetEngine")
	}

	// 初始化返回结果，预分配 Details（同步明细）与 OrphanList（孤儿 API）切片
	result := &SyncResult{
		Details:    make([]SyncItem, 0), // 每个候选路由的处理明细（insert/update/skip）
		OrphanList: make([]SyncItem, 0), // DB 中存在但代码已无的 API（orphan）
	}

	// 1. 遍历所有已注册路由，过滤并推导
	// candidate 仅为包装 SyncItem，保留结构体形式便于后续扩展（如携带额外标记）
	type candidate struct {
		item SyncItem
	}
	// candidates 收集所有通过过滤的候选路由
	candidates := make([]candidate, 0)
	// engine.Routes() 返回所有已注册的路由信息（path/method/handler）
	for _, route := range engine.Routes() {
		// shouldFilter 按内置规则过滤非业务路由（如健康检查、pprof、swagger 等）
		if shouldFilter(route) {
			result.Filtered++ // 计入被过滤数量，便于统计
			continue          // 跳过该路由，不参与同步
		}
		// 插件路由过滤：路径中含 "/plugins/" 视为插件路由
		isPlugin := strings.Contains(route.Path, "/plugins/")
		// 若是插件路由且选项未要求包含插件，则过滤掉
		if isPlugin && !opt.IncludePlugins {
			result.Filtered++ // 计入被过滤数量
			continue          // 跳过插件路由
		}
		// 根据路径推导 API 分组（系统接口按路径分段，插件接口按 GroupByPlugin 决定是否单独成组）
		group := deriveApiGroup(route.Path, opt.IncludePlugins, opt.GroupByPlugin)
		// 同步预览时若 includePlugins=false 导致 group 为空，仍保留记录但 group 为空
		// 由路径/方法/handler 名推导人类可读的接口标题
		title := deriveTitle(route.Path, route.Method, handlerName(route))
		// 将推导结果加入候选集合
		candidates = append(candidates, candidate{
			item: SyncItem{
				Path:     route.Path,                    // 接口路径
				Method:   strings.ToUpper(route.Method), // 方法统一大写，保证去重 key 一致
				Title:    title,                         // 接口标题
				ApiGroup: group,                         // 接口分组
				Handler:  route.Handler,                 // handler 字符串（形如 "pkg.func"），便于排查
			},
		})
	}

	// SelectedKeys 过滤：仅保留用户勾选的路由（格式 "path|method"）
	// 注意：仅在非 DryRun（执行同步）阶段生效；DryRun 预览应返回完整明细供用户勾选
	if !opt.DryRun && len(opt.SelectedKeys) > 0 {
		// 将用户勾选的 key 集合放入 set 便于 O(1) 查询
		selectedSet := make(map[string]bool, len(opt.SelectedKeys))
		for _, k := range opt.SelectedKeys {
			selectedSet[k] = true // 标记该 key 被勾选
		}
		// 重新构造候选集合，仅保留被勾选的路由
		filtered := make([]candidate, 0, len(selectedSet))
		for _, c := range candidates {
			// 以 "path|method" 作为唯一标识判断是否被勾选
			if selectedSet[c.item.Path+"|"+c.item.Method] {
				filtered = append(filtered, c) // 保留被勾选项
			}
		}
		candidates = filtered // 用过滤后的结果覆盖候选集合
	}

	// 统计最终参与处理的候选数量
	result.Total = len(candidates)

	if result.Total == 0 { // 没有候选路由时无需后续 DB 操作，直接返回
		return result, nil
	}

	// 2. 加载 DB 已存在的 sys_api（path+method -> SysApi）
	// 取当前配置的 DB 连接并绑定上下文（便于超时/取消传播）
	db := app.DB().WithContext(ctx)
	// 查询库中所有未删除的 API，构造 path|method -> *SysApi 映射，用于判断 insert/update
	existMap, err := s.loadExistApiMap(db)
	if err != nil { // 加载失败直接返回错误
		return nil, fmt.Errorf("加载已存在 API 失败: %v", err)
	}

	// 3. 计算每个 candidate 的 Action
	for _, c := range candidates {
		it := c.item                        // 取出候选项（值拷贝，避免修改到原切片元素）
		key := it.Path + "|" + it.Method    // 构造与 existMap 一致的唯一 key
		if exist, ok := existMap[key]; ok { // 库中已存在相同 path+method
			// 已存在
			if opt.Overwrite { // 用户选择允许覆盖已存在记录
				// 判断是否真的需要更新（Title 或 ApiGroup 不同）
				if exist.Title != it.Title || exist.ApiGroup != it.ApiGroup { // 标题或分组有变化才更新
					it.Action = "update" // 标记为更新
					result.Updated++     // 更新计数 +1
				} else { // 内容一致无需变更
					it.Action = "skip" // 标记为跳过
					result.Skipped++   // 跳过计数 +1
				}
			} else { // 不允许覆盖，已存在的一律跳过
				it.Action = "skip" // 标记为跳过
				result.Skipped++   // 跳过计数 +1
			}
		} else { // 库中不存在，需要新增
			it.Action = "insert" // 标记为新增
			result.Inserted++    // 新增计数 +1
		}
		result.Details = append(result.Details, it) // 将判定结果写入明细，供预览/写库使用
	}

	// 4. 计算 OrphanList（DB 有但代码无）
	// 先构造代码侧现有路由的 key 集合
	codeKeySet := make(map[string]bool, len(candidates))
	for _, c := range candidates {
		codeKeySet[c.item.Path+"|"+c.item.Method] = true // 标记该路由在代码中存在
	}
	// 遍历库中所有 API，凡不在代码 key 集合中的即为"孤儿"
	for key, api := range existMap {
		if !codeKeySet[key] { // 代码中无此接口，可能是已删除的路由
			result.OrphanList = append(result.OrphanList, SyncItem{
				Path:     api.Path,     // 孤儿 API 的路径
				Method:   api.Method,   // 孤儿 API 的方法
				Title:    api.Title,    // 孤儿 API 的标题
				ApiGroup: api.ApiGroup, // 孤儿 API 的分组
				Handler:  "",           // 代码已无该 handler，故置空
				Action:   "orphan",     // 标记为孤儿，供前端决定是否清理
			})
		}
	}

	// 5. DryRun 模式直接返回，不写库
	if opt.DryRun { // 预演模式：仅返回明细与统计，不产生任何写操作
		return result, nil
	}

	// 6. 执行写库（事务）
	tx := db.Begin()     // 开启事务，保证 insert/update 原子性
	if tx.Error != nil { // 开启事务失败
		return nil, fmt.Errorf("开始事务失败: %v", tx.Error)
	}
	// 兜底：若执行过程中 panic，确保事务回滚，避免脏数据
	defer func() {
		if r := recover(); r != nil {
			tx.Rollback()
		}
	}()

	// 逐条按 Action 写库；skip 不操作
	for _, it := range result.Details {
		switch it.Action {
		case "insert": // 新增：构造 SysApi 并写入
			api := &models.SysApi{
				Title:    it.Title,    // 标题
				Path:     it.Path,     // 路径
				Method:   it.Method,   // 方法
				ApiGroup: it.ApiGroup, // 分组
			}
			if err := tx.Create(api).Error; err != nil { // 插入失败回滚并返回
				tx.Rollback()
				return nil, fmt.Errorf("插入 API 失败 (path=%s method=%s): %v", it.Path, it.Method, err)
			}
		case "update": // 更新：仅刷新 title 与 api_group，保留原有 ID 等
			key := it.Path + "|" + it.Method // 取对应库记录
			exist := existMap[key]           // 已存在记录指针（含 ID）
			if err := tx.Model(&models.SysApi{}).
				Where("id = ?", exist.ID).      // 按主键定位
				Updates(map[string]interface{}{ // 仅更新有变化的字段
					"title":     it.Title,    // 更新标题
					"api_group": it.ApiGroup, // 更新分组
				}).Error; err != nil { // 更新失败回滚并返回
				tx.Rollback()
				return nil, fmt.Errorf("更新 API 失败 (path=%s method=%s): %v", it.Path, it.Method, err)
			}
		}
		// skip 不操作
	}

	// 提交事务，使本次 insert/update 永久生效
	if err := tx.Commit().Error; err != nil {
		return nil, fmt.Errorf("提交事务失败: %v", err)
	}

	// 返回完整结果（含统计与明细），供调用方展示同步报告
	return result, nil
}

// loadExistApiMap 加载所有未删除的 sys_api，构造 path|method -> *SysApi 映射
func (s *SysApiService) loadExistApiMap(db *gorm.DB) (map[string]*models.SysApi, error) {
	var list models.SysApiList
	if err := db.Find(&list).Error; err != nil {
		return nil, err
	}
	m := make(map[string]*models.SysApi, len(list))
	for _, api := range list {
		key := api.Path + "|" + api.Method
		m[key] = api
	}
	return m, nil
}
