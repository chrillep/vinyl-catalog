package main

import (
	"database/sql"
	"fmt"
	"github.com/thiduzz/vinyl-catalog/cmd/vinyl_catalog/handlers"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/go-sql-driver/mysql"
)

func getEnv(key, fallback string) string {
	if value, ok := os.LookupEnv(key); ok {
		return value
	}
	return fallback
}

func main() {
	containerPort := getEnv("CONTAINER_PORT", "8080")
	log.Print("\n" + "Starting server at port " + containerPort + "\n" + "url: http://localhost:" + containerPort + "\n")

	http.HandleFunc("/db", func(w http.ResponseWriter, r *http.Request) {
		config := mysql.NewConfig()
		config.User = os.Getenv("DB_USER_NAME")
		config.Passwd = os.Getenv("DB_USER_PASSWORD")
		config.Net = "tcp"
		config.Addr = fmt.Sprintf("%s:%s", os.Getenv("DB_HOST"), os.Getenv("DB_PORT"))
		config.DBName = os.Getenv("DB_SCHEMA_NAME")
		config.Params = map[string]string{"charset": "utf8"}
		config.Loc = time.UTC
		config.ParseTime = true
		db, err := sql.Open("mysql", config.FormatDSN())
		if err != nil {
			fmt.Fprintf(w, "Error when opening connection: %s", err.Error())
			return
		}
		db.SetConnMaxLifetime(time.Minute * 3)
		db.SetMaxOpenConns(10)
		db.SetMaxIdleConns(10)
		err = db.Ping()
		if err != nil {
			fmt.Fprintf(w, "Error when pinging database: %s", err.Error())
			return
		}
		fmt.Fprint(w, "Successfully reached AWS Database!")
	})

	http.HandleFunc("/up", handlers.UpHandler)

	if err := http.ListenAndServe(fmt.Sprintf(":%s", containerPort), nil); err != nil {
		log.Fatal(err)
	}
}
