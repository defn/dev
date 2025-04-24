package command

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/spf13/cobra"

	root "github.com/defn/dev/m/command/root"
)

func init() {
	root.RootCmd.AddCommand(&cobra.Command{
		Use:   "api",
		Short: "A brief description of your command",
		Long:  `Something longer`,
		Run: func(cmd *cobra.Command, args []string) {
			r := gin.Default()
			r.SetTrustedProxies(nil)
			r.GET("/", func(c *gin.Context) {
				c.JSON(http.StatusOK, gin.H{
					"message": "hello!",
				})
			})
			r.GET("/api", func(c *gin.Context) {
				c.JSON(http.StatusOK, gin.H{
					"message": `["hello"]`,
				})
			})
			r.Run() // listen and serve on 0.0.0.0:8080 (for windows "localhost:8080")
		},
	})
}
