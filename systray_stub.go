//go:build !systray

package main

import (
	"fmt"
	"os"
)

func initSystray(sigChan chan os.Signal) {
	fmt.Println("Warning: System tray support not available in this build")
	fmt.Println("To enable system tray, build with: go build -tags systray or make native")
	os.Exit(1)
}
