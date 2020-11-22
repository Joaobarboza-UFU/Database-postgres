package main

import (
	"database/sql"
	"fmt"

	_ "github.com/lib/pq"
)

const (
	host     = "localhost"
	port     = 5432
	user     = "postgres"
	password = "postgres"
	dbname   = "postgres"
)

func main() {
	psqlInfo := fmt.Sprintf("host=%s port=%d user=%s "+
		"password=%s dbname=%s sslmode=disable",
		host, port, user, password, dbname)
	db, err := sql.Open("postgres", psqlInfo)
	if err != nil {
		panic(err)
	}
	defer db.Close()


	sqlStatement := `CREATE TABLE if not exists users (
		id SERIAL PRIMARY KEY,
		age INT,
		first_name TEXT,
		last_name TEXT,
		email TEXT UNIQUE NOT NULL
	  )`
	_, err = db.Exec(sqlStatement)
	if err != nil {
		panic(err)
	}

}
