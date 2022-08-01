package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/joho/godotenv"

	"github.com/thiduzz/vinyl-catalog/cmd/vinyl_catalog/handlers"
)

func getEnv(key, fallback string) string {
	if value, ok := os.LookupEnv(key); ok {
		return value
	}
	return fallback
}

func main() {
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}
	containerPort := getEnv("CONTAINER_PORT", "8080")
	log.Print("\n" + "Starting server at port " + containerPort + "\n" + "url: http://localhost:" + containerPort + "\n")

	http.HandleFunc("/db", handlers.DbHandler)

	http.HandleFunc("/up", handlers.UpHandler)

	if err := http.ListenAndServe(fmt.Sprintf(":%s", containerPort), nil); err != nil {
		log.Fatal(err)
	}
}
