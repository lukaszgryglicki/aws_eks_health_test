package main

import (
	lib "ekshealthtest"
	"fmt"
	"net/http"
	"os"
	"time"
)

type handlerContext struct {
	status string
	errs   []int
}

func (hctx *handlerContext) getStatus(w http.ResponseWriter, r *http.Request) {
	str := fmt.Sprintf("%s\n\nPostgres errors: %d\nElasticSearch errors: %d\n", hctx.status, hctx.errs[0], hctx.errs[1])
	w.Write([]byte(str))
}

func outputStatus(status string, errs []int) {
	var hctx handlerContext
	port := os.Getenv("EKS_HEALTH_PORT")
	if port == "" {
		port = "8888"
		fmt.Printf("EKS_HEALTH_PORT env variable is not set, using the default value: %s\n", port)
	}
	fmt.Printf(
		"Status:\n%s\nPostgres errors: %d\nElasticSearch errors: %d\nCreating HTTP handler on %s\n",
		status, errs[0], errs[1], port,
	)
	skipHttp := os.Getenv("SKIP_HTTP")
	if skipHttp != "" {
		fmt.Printf("Skipped HTTP server due to SKIP_HTTP: %s\n", skipHttp)
		return
	}
	hctx.status = status
	hctx.errs = errs
	http.HandleFunc("/", hctx.getStatus)
	err := http.ListenAndServe(":"+port, nil)
	if err != nil {
		fmt.Printf("Failed to create HTTP server: '%+v'\n", err)
	}
}

func main() {
	ts := time.Now()
	status := ""
	errs := []int{}
	result, nerrs := lib.PgHealth()
	status += result
	errs = append(errs, nerrs)
	result, nerrs = lib.ESHealth()
	status += result
	errs = append(errs, nerrs)
	te := time.Now()
	status += fmt.Sprintf("Took: %v\n", te.Sub(ts))
	outputStatus(status, errs)
}
