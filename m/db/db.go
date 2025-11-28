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
	"github.com/spf13/cobra"
	"go.uber.org/fx"
	"go.uber.org/zap"

	"github.com/defn/dev/m/cmd/base"
	"github.com/defn/dev/m/cmd/runner"
	"github.com/defn/dev/m/command/root"
)

func run() {
	runner.Run(runner.Config{
		Modules: []fx.Option{
			root.Module,
			Module,
		},
	})
}

func main() {
	run()
}

var Module = fx.Module("SubCommandDb",
	fx.Provide(
		fx.Annotate(
			NewCommand,
			fx.ResultTags(`group:"subs"`),
		),
	),
)

type subCommand struct {
	*base.BaseCommand
}

func NewCommand(lifecycle fx.Lifecycle) base.Command {
	sub := &subCommand{}

	cmd := &cobra.Command{
		Use:   "db",
		Short: "Database worker using River and PostgreSQL",
		Long:  `Database worker - demonstrates River job queue with PostgreSQL`,
		Args:  cobra.NoArgs,
		Run: func(cmd *cobra.Command, args []string) {
			if err := sub.Main(); err != nil {
				base.Logger().Error("failed to run db command", zap.Error(err))
			}
		},
	}

	sub.BaseCommand = base.NewCommand(cmd)
	return sub
}

func (s *subCommand) Main() error {
	logger := base.Logger().With(zap.String("cmd", "db"))
	logger.Debug("running db command")

	ctx := context.Background()

	// database
	db_pool, err := pgxpool.New(ctx, "postgresql://postgres@/postgres")
	if err != nil {
		return fmt.Errorf("failed to create database pool: %w", err)
	}

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
		return fmt.Errorf("failed to create river client: %w", err)
	}

	if err := server.Start(ctx); err != nil {
		return fmt.Errorf("failed to start server: %w", err)
	}

	// jobs
	_, err = server.Insert(ctx, SortTask{
		Things: []string{
			"whale", "tiger", "bear",
		},
	}, nil)

	if err != nil {
		return fmt.Errorf("failed to insert job: %w", err)
	}

	logger.Info("job inserted successfully")

	// idle until quit, interrupted
	sigs := make(chan os.Signal, 1)
	signal.Notify(sigs, syscall.SIGINT, syscall.SIGTERM)
	<-sigs

	logger.Info("shutting down gracefully")

	// exit gracefully
	if err := server.Stop(ctx); err != nil {
		return fmt.Errorf("failed to stop server: %w", err)
	}

	return nil
}

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
	logger := base.Logger().With(zap.String("worker", "sort"))
	sort.Strings(job.Args.Things)
	logger.Info("sorted strings", zap.Strings("things", job.Args.Things))
	return nil
}
