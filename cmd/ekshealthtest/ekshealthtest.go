package main

import (
	lib "ekshealthtest"
	"fmt"
	"net/http"
	"os"
)

type handlerContext struct {
	status string
}

func (hctx *handlerContext) getStatus(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte(hctx.status))
}

func outputStatus(status string) {
	var hctx handlerContext
	port := os.Getenv("EKS_HEALTH_PORT")
	if port == "" {
		port = "8888"
    fmt.Printf("EKS_HEALTH_PORT env variable is not set, using the default value: %s\n", port)
	}
	fmt.Printf("Status:\n%s\nCreating HTTP handler on %s\n", status, port)
	hctx.status = status
	http.HandleFunc("/", hctx.getStatus)
	err := http.ListenAndServe(":"+port, nil)
	if err != nil {
		fmt.Printf("Failed to create HTTP server: '%+v'\n", err)
	}
}

func main() {
	status := ""
	status += lib.PgHealth()
	outputStatus(status)
}
