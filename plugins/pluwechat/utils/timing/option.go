package timing

import "time"

type Option func(*Cron)

func WithLocation(loc *time.Location) Option {
	return func(c *Cron) {
		c.location = loc
	}
}

func WithChain(wrappers ...JobWrapper) Option {
	return func(c *Cron) {
		c.chain = NewChain(wrappers...)
	}
}

// WithLogger uses the provided logger.
func WithLogger(logger Logger) Option {
	return func(c *Cron) {
		c.logger = logger
	}
}
