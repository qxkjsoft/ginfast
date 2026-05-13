package timing

import (
	"container/heap"
	"context"
	"sync"
	"time"
)

type Cron struct {
	entries   EntryHeap
	chain     Chain
	stop      chan struct{}
	add       chan *Entry
	update    chan *Entry
	remove    chan EntryID
	snapshot  chan chan []Entry
	running   bool
	logger    Logger
	runningMu sync.Mutex
	location  *time.Location
	nextID    EntryID
	jobWaiter sync.WaitGroup
}

func New(opts ...Option) *Cron {
	c := &Cron{
		entries:   nil,
		chain:     NewChain(),
		stop:      make(chan struct{}),
		add:       make(chan *Entry),
		update:    make(chan *Entry),
		remove:    make(chan EntryID),
		snapshot:  make(chan chan []Entry),
		running:   false,
		logger:    DefaultLogger,
		runningMu: sync.Mutex{},
		location:  time.Local,
	}
	for _, opt := range opts {
		opt(c)
	}
	return c
}

// now returns current time in c location
func (c *Cron) now() time.Time {
	return time.Now().In(c.location)
}

// Start the cron scheduler in its own goroutine, or no-op if already started.
func (c *Cron) Start() {
	c.runningMu.Lock()
	defer c.runningMu.Unlock()
	if c.running {
		return
	}
	c.running = true
	go c.run()
}

func (c *Cron) run() {
	c.logger.Info("start")
	now := c.now()
	for {
		var timer *time.Timer
		if len(c.entries) == 0 || c.entries[0].Next.IsZero() {
			// If there are no entries yet, just sleep - it still handles new entries
			// and stop requests.
			timer = time.NewTimer(100000 * time.Hour)
		} else {
			timer = time.NewTimer(c.entries[0].Next.Sub(now))
		}

		for {
			select {
			case now = <-timer.C:
				now = now.In(c.location)
				c.logger.Info("wake", "now", now)

				for c.entries.Len() > 0 {
					first := c.entries[0]
					if first.Next.After(now) || first.Next.IsZero() {
						break
					}
					first = heap.Pop(&c.entries).(*Entry)
					c.startJob(first.WrappedJob, first.Payload)
					c.logger.Info("run", "now", now, "entry", first.ID)
				}

			case newEntry := <-c.add:
				timer.Stop()
				now = c.now()
				heap.Push(&c.entries, newEntry)
				c.logger.Info("added", "now", now, "entry", newEntry.ID, "next", newEntry.Next)
			case replyChan := <-c.snapshot:
				replyChan <- c.entrySnapshot()
				continue
			case <-c.stop:
				timer.Stop()
				c.logger.Info("stop")
				return
			case id := <-c.remove:
				timer.Stop()
				now = c.now()
				c.removeEntry(id)
				c.logger.Info("removed", "entry", id)
			case entry := <-c.update:
				timer.Stop()
				now = c.now()
				c.updateEntry(entry)
				c.logger.Info("update", "entry", entry.ID)
			}

			break
		}
	}
}

// Entries returns a snapshot of the cron entries.
func (c *Cron) Entries() []Entry {
	c.runningMu.Lock()
	defer c.runningMu.Unlock()
	if c.running {
		replyChan := make(chan []Entry, 1)
		c.snapshot <- replyChan
		return <-replyChan
	}
	return c.entrySnapshot()
}

func (c *Cron) First(fn func(payload interface{}) bool) *Entry {
	es := c.Filter(fn)
	if len(es) > 0 {
		return &es[0]
	}
	return nil
}

func (c *Cron) Filter(fn func(payload interface{}) bool) (entrys []Entry) {
	entries := c.Entries()
	for _, item := range entries {
		if fn(item.Payload) {
			entrys = append(entrys, item)
		}
	}
	return entrys
}

// Location gets the time zone location
func (c *Cron) Location() *time.Location {
	return c.location
}

// Entry returns a snapshot of the given entry, or nil if it couldn't be found.
func (c *Cron) Entry(id EntryID) Entry {
	for _, entry := range c.Entries() {
		if id == entry.ID {
			return entry
		}
	}
	return Entry{}
}

func (c *Cron) AddFunc(next time.Time, cmd func(payload interface{}), payload ...interface{}) EntryID {
	if len(payload) > 0 {
		return c.AddJob(next, FuncJob(cmd), payload[0])
	}
	return c.AddJob(next, FuncJob(cmd), nil)
}

func (c *Cron) AddJob(next time.Time, cmd Job, payload interface{}) EntryID {
	c.runningMu.Lock()
	defer c.runningMu.Unlock()
	c.nextID++
	entry := &Entry{
		ID:         c.nextID,
		Next:       next,
		WrappedJob: c.chain.Then(cmd, payload),
		Payload:    payload,
	}
	if !c.running {
		heap.Push(&c.entries, entry)
	} else {
		c.add <- entry
	}
	return entry.ID
}

func (c *Cron) UpdateFunc(id EntryID, next time.Time, cmd func(payload interface{}), payload interface{}) {
	c.UpdateJob(id, next, FuncJob(cmd), payload)
}

func (c *Cron) UpdateJob(id EntryID, next time.Time, cmd Job, payload interface{}) {
	c.runningMu.Lock()
	defer c.runningMu.Unlock()
	entry := &Entry{
		ID:         id,
		Next:       next,
		WrappedJob: c.chain.Then(cmd, payload),
		Payload:    payload,
	}
	if c.running {
		c.update <- entry
	} else {
		c.updateEntry(entry)
	}
}

func (c *Cron) RemoveByFn(fn func(payload interface{}) bool) {
	ens := c.Filter(fn)
	for _, item := range ens {
		c.Remove(item.ID)
	}
}

func (c *Cron) Remove(id EntryID) {
	c.runningMu.Lock()
	defer c.runningMu.Unlock()
	if c.running {
		c.remove <- id
	} else {
		c.removeEntry(id)
	}
}

func (c *Cron) Stop() context.Context {
	c.runningMu.Lock()
	defer c.runningMu.Unlock()
	if c.running {
		c.stop <- struct{}{}
		c.running = false
	}
	ctx, cancel := context.WithCancel(context.Background())
	go func() {
		c.jobWaiter.Wait()
		cancel()
	}()
	return ctx
}

func (c *Cron) entrySnapshot() []Entry {
	var entries = make([]Entry, len(c.entries))
	for i, e := range c.entries {
		entries[i] = *e
	}
	return entries
}

func (c *Cron) startJob(j Job, payload interface{}) {
	c.jobWaiter.Add(1)
	go func() {
		defer c.jobWaiter.Done()
		j.Run(payload)
	}()
}

func (c *Cron) removeEntry(id EntryID) {
	for i, e := range c.entries {
		if e.ID == id {
			heap.Remove(&c.entries, i)
			break
		}
	}
}

func (c *Cron) updateEntry(entry *Entry) {
	for i, e := range c.entries {
		if e.ID == entry.ID {
			c.entries[i] = entry
			heap.Fix(&c.entries, i)
			break
		}
	}
}

type Job interface {
	Run(payload interface{})
}

type FuncJob func(payload interface{})

func (f FuncJob) Run(payload interface{}) { f(payload) }

type EntryID int
type Entry struct {
	ID         EntryID     `json:"id"`
	Next       time.Time   `json:"next"`
	WrappedJob Job         `json:"-"`
	Payload    interface{} `json:"payload"`
}

type EntryHeap []*Entry

func (h EntryHeap) Len() int { return len(h) }
func (h EntryHeap) Less(i, j int) bool {
	if h[i].Next.IsZero() {
		return false
	}
	if h[j].Next.IsZero() {
		return true
	}
	return h[i].Next.Before(h[j].Next)
}
func (h EntryHeap) Swap(i, j int) { h[i], h[j] = h[j], h[i] }
func (h *EntryHeap) Push(x interface{}) {

	*h = append(*h, x.(*Entry))
}
func (h *EntryHeap) Pop() interface{} {
	old := *h
	n := len(old)
	x := old[n-1]
	*h = old[0 : n-1]
	return x
}
