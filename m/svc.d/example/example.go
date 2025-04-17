package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/spf13/cobra"

	root "github.com/defn/dev/m/command/root"
)

var rootCmd = &cobra.Command{
	Use:   "run",
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
		r.Run()
	},
}

func main() {
	root.ExecuteCommand(rootCmd)
}
