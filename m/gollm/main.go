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

	prompt := gollm.NewPrompt("Tell me a short joke about programming.")
	response, err := llm.Generate(ctx, prompt)
	if err != nil {
		log.Fatalf("Failed to generate text: %v", err)
	}
	fmt.Printf("Response: %s\n", response)
}
