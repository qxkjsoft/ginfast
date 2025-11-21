package models

import (
	"database/sql/driver"
	"encoding/json"
	"time"
)

// JSONTime 自定义时间类型，支持多种 JSON 格式的解析
// 支持格式: 2006-01-02, 2006-01-02 15:04:05, RFC3339 (2006-01-02T15:04:05Z07:00)
type JSONTime struct {
	time.Time
}

func NewJSONTime(t time.Time) JSONTime {
	return JSONTime{Time: t}
}

func (jt JSONTime) ToTime() time.Time {
	return jt.Time
}

// UnmarshalJSON 实现 JSON 反序列化
func (jt *JSONTime) UnmarshalJSON(b []byte) error {
	var s string
	if err := json.Unmarshal(b, &s); err != nil {
		return err
	}

	if s == "" || s == "null" {
		jt.Time = time.Time{}
		return nil
	}

	// 尝试多种日期格式
	formats := []string{
		"2006-01-02",                // 日期格式
		"2006-01-02 15:04:05",       // 日期时间格式
		"2006-01-02T15:04:05Z07:00", // RFC3339 with timezone
		"2006-01-02T15:04:05Z",      // RFC3339 UTC
		"2006-01-02T15:04:05.000Z",  // RFC3339 with milliseconds
		time.RFC3339,                // 标准 RFC3339
		time.RFC3339Nano,            // RFC3339Nano
	}

	var parseErr error
	for _, format := range formats {
		if t, err := time.Parse(format, s); err == nil {
			jt.Time = t
			return nil
		} else {
			parseErr = err
		}
	}

	return parseErr
}

// MarshalJSON 实现 JSON 序列化
func (jt JSONTime) MarshalJSON() ([]byte, error) {
	if jt.Time.IsZero() {
		return json.Marshal(nil)
	}
	return json.Marshal(jt.Time.Format("2006-01-02 15:04:05"))
}

// Value 实现 driver.Valuer 接口，用于数据库写入
func (jt JSONTime) Value() (driver.Value, error) {
	if jt.Time.IsZero() {
		return nil, nil
	}
	return jt.Time, nil
}

// Scan 实现 sql.Scanner 接口，用于数据库读取
func (jt *JSONTime) Scan(value interface{}) error {
	if value == nil {
		jt.Time = time.Time{}
		return nil
	}

	switch v := value.(type) {
	case time.Time:
		jt.Time = v
	case string:
		t, err := time.Parse("2006-01-02 15:04:05", v)
		if err != nil {
			return err
		}
		jt.Time = t
	case []byte:
		t, err := time.Parse("2006-01-02 15:04:05", string(v))
		if err != nil {
			return err
		}
		jt.Time = t
	}
	return nil
}
