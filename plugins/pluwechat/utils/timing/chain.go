package timing

import (
	"fmt"
	"runtime"
	"sync"
	"time"
)

type JobWrapper func(Job, interface{}) Job

type Chain struct {
	wrappers []JobWrapper
}

func NewChain(c ...JobWrapper) Chain {
	return Chain{c}
}

func (c Chain) Then(j Job, payload interface{}) Job {
	for i := range c.wrappers {
		j = c.wrappers[len(c.wrappers)-i-1](j, payload)
	}
	return j
}

func Recover(logger Logger) JobWrapper {
	return func(j Job, payload interface{}) Job {
		return FuncJob(func(payload interface{}) {
			defer func() {
				if r := recover(); r != nil {
					const size = 64 << 10
					buf := make([]byte, size)
					buf = buf[:runtime.Stack(buf, false)]
					err, ok := r.(error)
					if !ok {
						err = fmt.Errorf("%v", r)
					}
					logger.Error(err, "panic", "stack", "...\n"+string(buf))
				}
			}()
			j.Run(payload)
		})

	}
}

// DelayIfStillRunning serializes jobs, delaying subsequent runs until the
// previous one is complete. Jobs running after a delay of more than a minute
// have the delay logged at Info.
func DelayIfStillRunning(logger Logger) JobWrapper {
	return func(j Job, payload interface{}) Job {
		var mu sync.Mutex
		return FuncJob(func(payload interface{}) {
			start := time.Now()
			mu.Lock()
			defer mu.Unlock()
			if dur := time.Since(start); dur > time.Minute {
				logger.Info("delay", "duration", dur)
			}
			j.Run(payload)
		})
	}
}

// SkipIfStillRunning skips an invocation of the Job if a previous invocation is
// still running. It logs skips to the given logger at Info level.
func SkipIfStillRunning(logger Logger) JobWrapper {
	var ch = make(chan struct{}, 1)
	ch <- struct{}{}
	return func(j Job, payload interface{}) Job {
		return FuncJob(func(payload interface{}) {
			select {
			case v := <-ch:
				j.Run(payload)
				ch <- v
			default:
				logger.Info("skip")
			}
		})
	}
}
