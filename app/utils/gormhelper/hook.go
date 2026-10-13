package gormhelper

import (
	"gin-fast/app/global/app"
	"gin-fast/app/global/myerrors"
	"reflect"
	"strings"

	"gorm.io/gorm"
)

// 这里的函数都是gorm的hook函数，拦截一些官方我们认为不合格的操作行为，提升项目整体的完美性

// MaskNotDataError 解决gorm v2 包在查询无数据时，报错问题（record not found），但是官方认为报错是应该是，我们认为查询无数据，代码一切ok，不应该报错
func MaskNotDataError(gormDB *gorm.DB) {
	gormDB.Statement.RaiseErrorOnNotFound = false
}

// InterceptCreatePramsNotPtrError 拦截 create 函数参数如果是非指针类型的错误,新用户最容犯此错误

func CreateBeforeHook(gormDB *gorm.DB) {
	if reflect.TypeOf(gormDB.Statement.Dest).Kind() != reflect.Ptr {
		app.ZapLog.Warn(myerrors.ErrorsGormDBCreateParamsNotPtr)
	} else {
		destValueOf := reflect.ValueOf(gormDB.Statement.Dest).Elem()
		if destValueOf.Type().Kind() == reflect.Slice || destValueOf.Type().Kind() == reflect.Array {
			inLen := destValueOf.Len()
			for i := 0; i < inLen; i++ {
				row := destValueOf.Index(i)
				if row.Type().Kind() == reflect.Struct {
					// 检查是否有TenantID字段，如果有则自动设置
					if b, column := structHasSpecialField("TenantID", row); b {
						// 从上下文中获取租户ID
						if tenantID := GetTenantIDFromContext(gormDB.Statement.Context); tenantID > 0 {
							destValueOf.Index(i).FieldByName(column).Set(reflect.ValueOf(tenantID))
						}
					}
					// 检查是否有CreatedBy字段，如果有则自动设置
					if b, column := structHasSpecialField("CreatedBy", row); b {
						// 从上下文中获取用户ID
						if userID := GetCurrentUserIDFromContext(gormDB.Statement.Context); userID > 0 {
							destValueOf.Index(i).FieldByName(column).Set(reflect.ValueOf(userID))
						}
					}
				} else if row.Type().Kind() == reflect.Map {
					// 检查是否有TenantID字段，如果有则自动设置
					if b, column := structHasSpecialField("tenant_id", row); b {
						// 从上下文中获取租户ID
						if tenantID := GetTenantIDFromContext(gormDB.Statement.Context); tenantID > 0 {
							row.SetMapIndex(reflect.ValueOf(column), reflect.ValueOf(tenantID))
						}
					}
					// 检查是否有CreatedBy字段，如果有则自动设置
					if b, column := structHasSpecialField("created_by", row); b {
						// 从上下文中获取用户ID
						if userID := GetCurrentUserIDFromContext(gormDB.Statement.Context); userID > 0 {
							row.SetMapIndex(reflect.ValueOf(column), reflect.ValueOf(userID))
						}
					}
				}
			}
		} else if destValueOf.Type().Kind() == reflect.Struct {
			// 检查是否有TenantID字段，如果有则自动设置
			if b, column := structHasSpecialField("TenantID", gormDB.Statement.Dest); b {
				// 从上下文中获取租户ID
				if tenantID := GetTenantIDFromContext(gormDB.Statement.Context); tenantID > 0 {
					gormDB.Statement.SetColumn(column, tenantID)
				}
			}
			// 检查是否有CreatedBy字段，如果有则自动设置
			if b, column := structHasSpecialField("CreatedBy", gormDB.Statement.Dest); b {
				// 从上下文中获取用户ID
				if userID := GetCurrentUserIDFromContext(gormDB.Statement.Context); userID > 0 {
					gormDB.Statement.SetColumn(column, userID)
				}
			}
		} else if destValueOf.Type().Kind() == reflect.Map {
			// 检查是否有TenantID字段，如果有则自动设置
			if b, column := structHasSpecialField("tenant_id", gormDB.Statement.Dest); b {
				// 从上下文中获取租户ID
				if tenantID := GetTenantIDFromContext(gormDB.Statement.Context); tenantID > 0 {
					destValueOf.SetMapIndex(reflect.ValueOf(column), reflect.ValueOf(tenantID))
				}
			}
			// 检查是否有CreatedBy字段，如果有则自动设置
			if b, column := structHasSpecialField("created_by", gormDB.Statement.Dest); b {
				// 从上下文中获取用户ID
				if userID := GetCurrentUserIDFromContext(gormDB.Statement.Context); userID > 0 {
					destValueOf.SetMapIndex(reflect.ValueOf(column), reflect.ValueOf(userID))
				}
			}
		}
	}
}

// UpdateBeforeHook
// InterceptUpdatePramsNotPtrError 拦截 save、update 函数参数如果是非指针类型的错误
// 对于开发者来说，以结构体形式更新数，只需要在 update 、save 函数的参数前面添加 & 即可
// 最终就可以完美兼支持、兼容 gorm 的所有回调函数
// 但是如果是指定字段更新，例如： UpdateColumn 函数则只传递值即可，不需要做校验
func UpdateBeforeHook(gormDB *gorm.DB) {
	if reflect.TypeOf(gormDB.Statement.Dest).Kind() == reflect.Struct {
		//_ = gormDB.AddError(errors.New(my_errors.ErrorsGormDBUpdateParamsNotPtr))
		app.ZapLog.Warn(myerrors.ErrorsGormDBUpdateParamsNotPtr)
	} else if reflect.TypeOf(gormDB.Statement.Dest).Kind() == reflect.Map {
		// 如果是调用了 gorm.Update 、updates 函数 , 在参数没有传递指针的情况下，无法触发回调函数

	}
}

// DeleteBeforeHook 删除前Hook
func DeleteBeforeHook(gormDB *gorm.DB) {
	// GORM 会自动处理 DeletedAt 字段（软删除）
}

// structHasSpecialField  检查结构体是否有特定字段
func structHasSpecialField(fieldName string, anyStructPtr interface{}) (bool, string) {
	if reflect.TypeOf(anyStructPtr).Kind() == reflect.Ptr && reflect.ValueOf(anyStructPtr).Elem().Kind() == reflect.Map {
		destValueOf := reflect.ValueOf(anyStructPtr).Elem()
		for _, item := range destValueOf.MapKeys() {
			if item.String() == fieldName {
				return true, fieldName
			}
		}
	} else if reflect.TypeOf(anyStructPtr).Kind() == reflect.Ptr && reflect.ValueOf(anyStructPtr).Elem().Kind() == reflect.Struct {
		return findFieldInStruct(reflect.ValueOf(anyStructPtr).Elem().Type(), fieldName, 0)
	} else if reflect.Indirect(anyStructPtr.(reflect.Value)).Type().Kind() == reflect.Struct {
		// 处理结构体
		destValueOf := anyStructPtr.(reflect.Value)
		return findFieldInStruct(destValueOf.Type(), fieldName, 0)
	} else if reflect.Indirect(anyStructPtr.(reflect.Value)).Type().Kind() == reflect.Map {
		destValueOf := anyStructPtr.(reflect.Value)
		for _, item := range destValueOf.MapKeys() {
			if item.String() == fieldName {
				return true, fieldName
			}
		}
	}
	return false, ""
}

// findFieldInStruct 在结构体类型中查找指定字段（TenantID/CreatedBy 自动注入用）。
// 探测范围与 GORM 的字段提升语义一致：
//   - 顶层普通字段按名命中；
//   - **匿名内嵌字段沿嵌套链递归深入**（任意深度，Go 的字段提升本就跨层级生效，
//     修复前只探一层、深层嵌套模型会静默漏注入租户）；
//   - 非匿名的 Struct 字段是关联（不属于本表列），不深入，避免关联体里的同名字段被误命中；
//   - depth 上限防御匿名指针内嵌自引用（如 type A struct{ *A }）导致的无限递归。
func findFieldInStruct(t reflect.Type, fieldName string, depth int) (bool, string) {
	if t.Kind() != reflect.Struct || depth > maxEmbeddedFieldDepth {
		return false, ""
	}
	for i := 0; i < t.NumField(); i++ {
		f := t.Field(i)
		ft := f.Type
		isEmbeddedPtr := ft.Kind() == reflect.Ptr && ft.Elem().Kind() == reflect.Struct
		if f.Anonymous && (ft.Kind() == reflect.Struct || isEmbeddedPtr) {
			// 匿名内嵌：沿提升链递归（指针内嵌深入其 Elem 类型）
			target := ft
			if isEmbeddedPtr {
				target = ft.Elem()
			}
			if b, column := findFieldInStruct(target, fieldName, depth+1); b {
				return b, column
			}
		} else if f.Name == fieldName {
			return true, getColumnNameFromGormTag(fieldName, f.Tag.Get("gorm"))
		}
		// 其余情况（非匿名 Struct 关联、名字不匹配的普通字段）跳过
	}
	return false, ""
}

// maxEmbeddedFieldDepth 匿名内嵌字段递归探测的最大深度
const maxEmbeddedFieldDepth = 8

// getColumnNameFromGormTag 从 gorm 标签中获取字段名
// @defaultColumn 如果没有 gorm：column 标签为字段重命名，则使用默认字段名
// @TagValue 字段中含有的gorm："column:created_at" 标签值，可能的格式：1. column:created_at    、2. default:null;  column:created_at  、3.  column:created_at; default:null
func getColumnNameFromGormTag(defaultColumn, TagValue string) (str string) {
	pos1 := strings.Index(TagValue, "column:")
	if pos1 == -1 {
		str = defaultColumn
		return
	} else {
		TagValue = TagValue[pos1+7:]
	}
	pos2 := strings.Index(TagValue, ";")
	if pos2 == -1 {
		str = TagValue
	} else {
		str = TagValue[:pos2]
	}
	return strings.ReplaceAll(str, " ", "")
}
