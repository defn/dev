package api

import (
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	"go.uber.org/fx"

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
		Short: "Example API using Gin",
		Long:  `Example API using Gin - demonstrates Viper config hierarchy`,
		Args:  cobra.NoArgs,
		Run: func(cmd *cobra.Command, args []string) {
			// Get port from viper (checks: flag > ENV > config files)
			sub.port = viper.GetInt("api.port")
			if sub.port == 0 {
				sub.port = 8080 // default port
			}

			if err := sub.Main(); err != nil {
				fmt.Printf("Error: %v\n", err)
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
	fmt.Printf("Starting API server on port %d\n", s.port)
	fmt.Printf("Port can be configured via:\n")
	fmt.Printf("  1. --port flag\n")
	fmt.Printf("  2. DEFN_API_PORT environment variable\n")
	fmt.Printf("  3. api.port in defn.yaml\n")
	fmt.Printf("  4. api.port in ~/.defn.yaml\n\n")

	router := gin.Default()
	router.SetTrustedProxies(nil)
	router.GET("/", func(ctx *gin.Context) {
		ctx.JSON(http.StatusOK, gin.H{
			"message": "hello!",
		})
	})
	router.GET("/api", func(ctx *gin.Context) {
		ctx.JSON(http.StatusOK, gin.H{
			"message": `["hello"]`,
		})
	})
	return router.Run(fmt.Sprintf(":%d", s.port))
}
