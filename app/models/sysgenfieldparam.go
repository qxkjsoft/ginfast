package models

// BatchInsertResult 批量插入结果结构
type BatchInsertResult struct {
	SuccessCount  int               `json:"successCount"`
	SuccessTables []string          `json:"successTables"`
	FailedCount   int               `json:"failedCount"`
	FailedTables  map[string]string `json:"failedTables"`
}
