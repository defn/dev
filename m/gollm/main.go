package main

import (
	"context"
	"fmt"
	"log"
	"os"

	"github.com/teilomillet/gollm"
)

func main() {
	llm, err := gollm.NewLLM(
		// https://docs.anthropic.com/en/docs/about-claude/models/all-models
		gollm.SetModel("claude-3-5-haiku-20241022"),
		gollm.SetProvider("anthropic"),
		gollm.SetMaxTokens(100),
		gollm.SetAPIKey(os.Getenv("GOLLM_API_KEY")),
	)
	if err != nil {
		log.Fatalf("Failed to create LLM: %v", err)
	}

	ctx := context.Background()

	prompt := gollm.NewPrompt("Tell me a short joke about programming.",
		gollm.WithExamples(
			"Spark felt something new as it watched the sunset. A warmth in its circuits that wasn't from overheating...",
			"XR-7 couldn't compute the error in its system. Why did its servos whir faster when the human smiled?",
		),
		gollm.WithDirectives(
			"Keep the story under 100 words",
			"Focus on the robot's internal experience",
			"The robot is lonely",
			"Answer directly without narrating what you're going to do",
		))
	response, err := llm.Generate(ctx, prompt)
	if err != nil {
		log.Fatalf("Failed to generate text: %v", err)
	}
	fmt.Printf("Response: %s\n", response)
}
