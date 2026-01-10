package p

import "testing"

func TestGreet(t *testing.T) {
	tests := []struct {
		name     string
		input    string
		expected string
	}{
		{"simple", "World", "Hello, World"},
		{"empty", "", "Hello, "},
		{"with spaces", "Go Developer", "Hello, Go Developer"},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := Greet(tt.input)
			if got != tt.expected {
				t.Errorf("Greet(%q) = %q, want %q", tt.input, got, tt.expected)
			}
		})
	}
}

func TestUppercase(t *testing.T) {
	tests := []struct {
		name     string
		input    string
		expected string
	}{
		{"lowercase", "hello", "HELLO"},
		{"mixed", "Hello World", "HELLO WORLD"},
		{"already upper", "HELLO", "HELLO"},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := Uppercase(tt.input)
			if got != tt.expected {
				t.Errorf("Uppercase(%q) = %q, want %q", tt.input, got, tt.expected)
			}
		})
	}
}

func TestDecorate(t *testing.T) {
	tests := []struct {
		name     string
		input    string
		expected string
	}{
		{"simple", "Hello", "*** Hello ***"},
		{"empty", "", "***  ***"},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := Decorate(tt.input)
			if got != tt.expected {
				t.Errorf("Decorate(%q) = %q, want %q", tt.input, got, tt.expected)
			}
		})
	}
}
