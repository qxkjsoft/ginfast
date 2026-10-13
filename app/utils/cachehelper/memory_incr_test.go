package cachehelper

import (
	"context"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
)

// TestIncrWithExpire_NewKeyGetsTTL 新键首次自增后应获得 TTL（修复此前新键永不过期的问题）
func TestIncrWithExpire_NewKeyGetsTTL(t *testing.T) {
	cache := NewMemoryHelper()
	defer cache.Close()
	ctx := context.Background()

	// 首次计数，TTL 50ms
	v, err := cache.IncrWithExpire(ctx, "b07:new", 50*time.Millisecond)
	assert.NoError(t, err)
	assert.EqualValues(t, 1, v)

	// 未过期前键存在
	count, err := cache.Exists(ctx, "b07:new")
	assert.NoError(t, err)
	assert.EqualValues(t, 1, count)

	// 超过 TTL 后键应自行过期（若未设置 TTL 则会永不过期，此处即为失败）
	time.Sleep(150 * time.Millisecond)
	count, err = cache.Exists(ctx, "b07:new")
	assert.NoError(t, err)
	assert.EqualValues(t, 0, count)
}

// TestIncrWithExpire_ExistingKeepsTTL 已有计数沿用原过期时间：值累加但不重置 TTL（固定窗口语义）
func TestIncrWithExpire_ExistingKeepsTTL(t *testing.T) {
	cache := NewMemoryHelper()
	defer cache.Close()
	ctx := context.Background()

	// 首次计数，TTL 120ms（过期时间点为 t=120ms）
	v, err := cache.IncrWithExpire(ctx, "b07:win", 120*time.Millisecond)
	assert.NoError(t, err)
	assert.EqualValues(t, 1, v)

	// t=60ms 再次计数：值累加为 2，但不得重置 TTL（若误重置则过期点变为 t=180ms）
	time.Sleep(60 * time.Millisecond)
	v, err = cache.IncrWithExpire(ctx, "b07:win", 120*time.Millisecond)
	assert.NoError(t, err)
	assert.EqualValues(t, 2, v)

	// t=150ms：按固定窗口语义键应已过期
	time.Sleep(90 * time.Millisecond)
	count, err := cache.Exists(ctx, "b07:win")
	assert.NoError(t, err)
	assert.EqualValues(t, 0, count)
}

// TestIncrWithExpire_RecountAfterExpiry 键过期后重新计数应从 1 开始并重新获得 TTL
func TestIncrWithExpire_RecountAfterExpiry(t *testing.T) {
	cache := NewMemoryHelper()
	defer cache.Close()
	ctx := context.Background()

	v, err := cache.IncrWithExpire(ctx, "b07:re", 50*time.Millisecond)
	assert.NoError(t, err)
	assert.EqualValues(t, 1, v)

	// 等待过期
	time.Sleep(150 * time.Millisecond)

	// 过期后重新计数：从 1 开始（而非残留旧值 +1）
	v, err = cache.IncrWithExpire(ctx, "b07:re", time.Minute)
	assert.NoError(t, err)
	assert.EqualValues(t, 1, v)
}

// TestIncrWithExpire_ZeroValueKeySetTo1 已存在的零值键自增到 1 时同样获得 TTL（与 Redis v==1 语义一致）
func TestIncrWithExpire_ZeroValueKeySetTo1(t *testing.T) {
	cache := NewMemoryHelper()
	defer cache.Close()
	ctx := context.Background()

	// 先写入零值（expiration=0 表示永不过期）
	assert.NoError(t, cache.SetInt(ctx, "b07:zero", 0, 0))

	v, err := cache.IncrWithExpire(ctx, "b07:zero", 50*time.Millisecond)
	assert.NoError(t, err)
	assert.EqualValues(t, 1, v)

	// 短 TTL 到期后键应消失（证明 v==1 时 TTL 已设置，覆盖了键的"永不过期"属性）
	time.Sleep(150 * time.Millisecond)
	count, err := cache.Exists(ctx, "b07:zero")
	assert.NoError(t, err)
	assert.EqualValues(t, 0, count)
}
