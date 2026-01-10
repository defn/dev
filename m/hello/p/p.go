// Package p provides greeting utilities for the hello command.
package p

import "strings"

// Greet formats a greeting with the given name.
func Greet(name string) string {
	return "Hello, " + name
}

// Uppercase returns the string in uppercase.
func Uppercase(s string) string {
	return strings.ToUpper(s)
}

// Decorate adds decoration around a greeting.
func Decorate(greeting string) string {
	return "*** " + greeting + " ***"
}
