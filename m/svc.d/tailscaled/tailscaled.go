package main

import (
	"log"
	"os"
	"os/exec"
	"syscall"

	"github.com/joho/godotenv"
)

func main() {
	if _, err := os.Stat("/dev/net/tun"); os.IsNotExist(err) {
		log.Println("/dev/net/tun not found, sleeping forever...")
		select {} // Blocks forever
		os.Exit(1)
	}

	err := godotenv.Load(".env")
	if err != nil {
		log.Fatalf("load .env failed: %v", err)
	}

	args := []string{"sudo", "tailscaled"}

	fname, err := exec.LookPath(args[0])
	if err != nil {
		log.Fatalf("lookup failed: %v", err)
	}

	env := os.Environ()
	if err := syscall.Exec(fname, args, env); err != nil {
		log.Fatalf("exec failed: %v", err)
	}
}
