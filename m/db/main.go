package main

import (
	"context"
	"fmt"
	"sort"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/riverqueue/river"
	"github.com/riverqueue/river/riverdriver/riverpgxv5"
)

type SortArgs struct {
	Strings []string `json:"strings"`
}

func (SortArgs) Kind() string { return "sort" }

type SortWorker struct {
	river.WorkerDefaults[SortArgs]
}

func (w *SortWorker) Work(ctx context.Context, job *river.Job[SortArgs]) error {
	sort.Strings(job.Args.Strings)
	fmt.Printf("Sorted strings: %+v\n", job.Args.Strings)
	return nil
}

func main() {
	ctx := context.Background()

	workers := river.NewWorkers()
	river.AddWorker(workers, &SortWorker{})

	dbPool, _ := pgxpool.New(ctx, "postgresql://postgres@/postgres")

	riverClient, err := river.NewClient(riverpgxv5.New(dbPool), &river.Config{
		Queues: map[string]river.QueueConfig{
			river.QueueDefault: {MaxWorkers: 100},
		},
		Workers: workers,
	})
	if err != nil {
		panic(err)
	}

	if err := riverClient.Start(ctx); err != nil {
		panic(err)
	}

	_, err = riverClient.Insert(ctx, SortArgs{
		Strings: []string{
			"whale", "tiger", "bear",
		},
	}, nil)

	if err != nil {
		panic(err)
	}

	time.Sleep(10 * time.Second)

	if err := riverClient.Stop(ctx); err != nil {
		panic(err)
	}
}
