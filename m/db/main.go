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

// see https://pkg.go.dev/github.com/riverqueue/river#example-package-InsertAndWork

// task
type SortTask struct {
	Things []string `json:"strings"`
}

func (SortTask) Kind() string { return "sort" }

// worker
type SortWorker struct {
	river.WorkerDefaults[SortTask]
}

func (w *SortWorker) Work(ctx context.Context, job *river.Job[SortTask]) error {
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
	_, err = server.Insert(ctx, SortTask{
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
