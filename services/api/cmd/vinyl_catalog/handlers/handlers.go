package handlers

import (
	"database/sql"
	"fmt"
	"io"
	"net/http"
	"os"
	"time"

	"github.com/go-sql-driver/mysql"
)

func UpHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	io.WriteString(w, `{"status": "I'm up!"}`)
}

func DbHandler(w http.ResponseWriter, r *http.Request) {
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
}
