package api

import (
	"fmt"
	"net/http"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	"go.uber.org/fx"
	"go.uber.org/zap"

	"github.com/defn/dev/m/cmd/base"
)

var Module = fx.Module("SubCommandApi",
	fx.Provide(
		fx.Annotate(
			NewCommand,
			fx.ResultTags(`group:"subs"`),
		),
	),
)

type subCommand struct {
	*base.BaseCommand
	port int
}

func NewCommand(lifecycle fx.Lifecycle) base.Command {
	sub := &subCommand{}

	cmd := &cobra.Command{
		Use:   "api",
		Short: "Example API using Echo",
		Long:  `Example API using Echo - demonstrates Viper config hierarchy`,
		Args:  cobra.NoArgs,
		Run: func(cmd *cobra.Command, args []string) {
			// Get port from viper (checks: flag > ENV > config files)
			sub.port = viper.GetInt("api.port")
			if sub.port == 0 {
				sub.port = 8080 // default port
			}

			if err := sub.Main(); err != nil {
				base.Logger().Error("failed to run api command", zap.Error(err))
			}
		},
	}

	// Add --port flag and bind to viper
	cmd.Flags().IntP("port", "p", 8080, "Port to listen on")
	viper.BindPFlag("api.port", cmd.Flags().Lookup("port"))

	sub.BaseCommand = base.NewCommand(cmd)
	return sub
}

func (s *subCommand) Main() error {
	logger := base.Logger().With(zap.String("cmd", "api"))
	logger.Info("starting API server",
		zap.Int("port", s.port),
		zap.Strings("config_sources", []string{
			"--port flag",
			"DEFN_API_PORT environment variable",
			"api.port in defn.yaml",
			"api.port in ~/.defn.yaml",
		}),
	)

	e := echo.New()
	e.HideBanner = true
	e.Use(middleware.Logger())
	e.Use(middleware.Recover())

	e.GET("/", func(c echo.Context) error {
		logger.Debug("handling GET /")
		return c.JSON(http.StatusOK, map[string]string{
			"message": "hello!",
		})
	})
	e.GET("/api", func(c echo.Context) error {
		logger.Debug("handling GET /api")
		return c.JSON(http.StatusOK, map[string]string{
			"message": `["hello"]`,
		})
	})

	logger.Info("server listening", zap.String("address", fmt.Sprintf(":%d", s.port)))
	return e.Start(fmt.Sprintf(":%d", s.port))
}
