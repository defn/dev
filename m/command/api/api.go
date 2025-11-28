package api

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/spf13/cobra"
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
	*base.BaseSubCommand
}

func NewCommand(lifecycle fx.Lifecycle) base.SubCommand {
	return &subCommand{
		BaseSubCommand: base.NewSubCommand(&cobra.Command{
			Use:   "api",
			Short: "Example API using Gin",
			Long:  `Example API using Gin`,
			Run: func(cmd *cobra.Command, args []string) {
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
				router.Run()
			},
		}),
	}
}
