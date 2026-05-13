package timing

import (
	"bytes"
	"log"
	"strings"
	"sync"
	"testing"
	"time"
)

const OneSecond = 1*time.Second + 50*time.Millisecond

type syncWriter struct {
	wr bytes.Buffer
	m  sync.Mutex
}

func (sw *syncWriter) Write(data []byte) (n int, err error) {
	sw.m.Lock()
	n, err = sw.wr.Write(data)
	sw.m.Unlock()
	return
}

func (sw *syncWriter) String() string {
	sw.m.Lock()
	defer sw.m.Unlock()
	return sw.wr.String()
}

func newBufLogger(sw *syncWriter) Logger {
	return PrintfLogger(log.New(sw, "", log.LstdFlags))
}

func TestFuncPanicRecovery(t *testing.T) {
	var buf syncWriter
	cron := New(WithChain(Recover(newBufLogger(&buf))))
	cron.Start()
	defer cron.Stop()
	cron.AddFunc(time.Now().Add(time.Second), func(payload interface{}) {
		panic("YOLO")
	}, nil)

	select {
	case <-time.After(OneSecond * 2):
		if !strings.Contains(buf.String(), "YOLO") {
			t.Error("expected a panic to be logged, got none")
		}
		return
	}

}
