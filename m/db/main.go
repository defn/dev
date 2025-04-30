package main

import (
	"context"
	"fmt"
	"os"
	"os/signal"
	"sort"
	"syscall"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/riverqueue/river"
	"github.com/riverqueue/river/riverdriver/riverpgxv5"
)

// job config
type SortConfig struct {
	Things []string `json:"strings"`
}

func (SortConfig) Kind() string { return "sort" }

// job worker
type SortWorker struct {
	river.WorkerDefaults[SortConfig]
}

func (w *SortWorker) Work(ctx context.Context, job *river.Job[SortConfig]) error {
	sort.Strings(job.Args.Things)
	fmt.Printf("Sorted strings: %+v\n", job.Args.Things)
	return nil
}

// main
func main() {
	ctx := context.Background()

	// database
	db_pool, _ := pgxpool.New(ctx, "postgresql://postgres@/postgres")

	// workers
	workers := river.NewWorkers()
	river.AddWorker(workers, &SortWorker{})

	// server
	server, err := river.NewClient(riverpgxv5.New(db_pool), &river.Config{
		Queues: map[string]river.QueueConfig{
			river.QueueDefault: {MaxWorkers: 100},
		},
		Workers: workers,
	})
	if err != nil {
		panic(err)
	}

	if err := server.Start(ctx); err != nil {
		panic(err)
	}

	// jobs
	_, err = server.Insert(ctx, SortConfig{
		Things: []string{
			"whale", "tiger", "bear",
		},
	}, nil)

	if err != nil {
		panic(err)
	}

	// idle until quit, interrupted
	sigs := make(chan os.Signal, 1)
	signal.Notify(sigs, syscall.SIGINT, syscall.SIGTERM)
	<-sigs

	// exit gracefully
	if err := server.Stop(ctx); err != nil {
		panic(err)
	}
}
