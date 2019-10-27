package main

import (
	"log"
	"net/http"
	"os"
	"shortly/pkg"
)

const defaultPort = "8080"

func main() {
	mux := (&server.HttpServer{}).NewMux()

	port := getPort()

	log.Printf("connect to http://localhost:%s/", port)
	log.Fatal(http.ListenAndServe(":"+port, mux))
}

func getPort() string {
	port := os.Getenv("PORT")
	if port == "" {
		port = defaultPort
	}
	return port
}
