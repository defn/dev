package command

import (
	"context"
	"fmt"
	"log"
	"os"

	"github.com/spf13/cobra"
	"github.com/teilomillet/gollm"

	root "github.com/defn/dev/m/command/root"
)

func init() {
	root.RootCmd.AddCommand(&cobra.Command{
		Use:   "gollm",
		Short: "A brief description of your command",
		Long:  `Something longer`,
		Run: func(cmd *cobra.Command, args []string) {
			llm, err := gollm.NewLLM(
				// https://docs.anthropic.com/en/docs/about-claude/models/all-models
				gollm.SetModel("claude-3-5-haiku-20241022"),
				gollm.SetProvider("anthropic"),
				gollm.SetMaxTokens(200),
				gollm.SetAPIKey(os.Getenv("GOLLM_API_KEY")),
			)
			if err != nil {
				log.Fatalf("Failed to create LLM: %v", err)
			}

			ctx := context.Background()

			fmt.Printf("%s\n\n", AskQuestion(ctx, llm, args[0]))
		},
	})
}

func AskQuestion(ctx context.Context, llm gollm.LLM, question string) string {
	prompt := gollm.NewPrompt(question,
		gollm.WithExamples(
			"Spark felt something new as it watched the sunset. A warmth in its circuits that wasn't from overheating...",
			"XR-7 couldn't compute the error in its system. Why did its servos whir faster when the human smiled?",
		),
		gollm.WithDirectives(
			"Keep the story under 100 words",
			"Focus on the robot's internal experience",
			"The robot is lonely",
			"Use a rough and rude Irish street vocabulary",
			"Answer directly without narrating what you're going to do",
		))

	response, err := llm.Generate(ctx, prompt)
	if err != nil {
		log.Fatalf("Failed to generate text: %v", err)
	}

	return response
}
