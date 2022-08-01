package handlers

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/go-sql-driver/mysql"
)

func UpHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	resp := make(map[string]string)
	resp["message"] = "I'm up!"
	jsonResp, err := json.Marshal(resp)
	if err != nil {
		log.Fatalf("Error happened in JSON marshal. Err: %s", err)
	}
	w.Write(jsonResp)
	return
}

func DbHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
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
		w.WriteHeader(http.StatusBadGateway)
		fmt.Fprintf(w, `{"error": "Error when opening connection: %s"}`, err.Error())
		return
	}
	db.SetConnMaxLifetime(time.Minute * 3)
	db.SetMaxOpenConns(10)
	db.SetMaxIdleConns(10)
	err = db.Ping()
	if err != nil {
		w.WriteHeader(http.StatusBadGateway)
		fmt.Fprintf(w, `{"error": "Error when pinging database: %s"}`, err.Error())
		return
	}
	w.WriteHeader(http.StatusOK)
	fmt.Fprint(w, `{"status": "Successfully reached AWS Database!"}`)
}
