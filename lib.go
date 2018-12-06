package ekshealthtest

import (
	"database/sql"
	"fmt"
	"os"
	"time"

	_ "github.com/lib/pq" // As suggested by lib/pq driver
)

func PgHealth() (string, int) {
	errs := 0
	expectedStr := "hello"
	pgHost := os.Getenv("PG_HOST")
	pgPort := os.Getenv("PG_PORT")
	pgDB := os.Getenv("PG_DB")
	pgUser := os.Getenv("PG_USER")
	pgPass := os.Getenv("PG_PASS")
	pgSSL := os.Getenv("PG_SSL")
	pgPassRedacted := fmt.Sprintf("len=%d", len(pgPass))
	connectionString := "client_encoding=UTF8 sslmode='" + pgSSL + "' host='" + pgHost + "' port=" + pgPort + " dbname='" + pgDB + "' user='" + pgUser + "' password='" + pgPass + "'"
	connectionStringRedacted := "client_encoding=UTF8 sslmode='" + pgSSL + "' host='" + pgHost + "' port=" + pgPort + " dbname='" + pgDB + "' user='" + pgUser + "' password='" + pgPassRedacted + "'"
	outStr := "Postgres connection string: " + connectionStringRedacted + "\n"
	con, err := sql.Open("postgres", connectionString)
	outStr += fmt.Sprintf("Connection result:\nConnection: '%+v'\n", con)
	if err != nil {
		outStr += fmt.Sprintf("Error: '%+v'\n", err)
		errs++
	}
	rows, err := con.Query("select now(), $1, usename from pg_user where usename = $2", expectedStr, pgUser)
	if err == nil {
		outStr += fmt.Sprintf("Query OK\nRows: '%+v'\n", err)
		var (
			now  time.Time
			str  string
			user string
		)
		for rows.Next() {
			err = rows.Scan(&now, &str, &user)
			if err != nil {
				outStr += fmt.Sprintf("Row scan error: '%+v'\n", err)
				errs++
			} else {
				outStr += fmt.Sprintf("Scanned: '%+v', %s, %s\n", now, str, user)
			}
		}
		if str != expectedStr {
			outStr += fmt.Sprintf("Error: expected to scan '%s', scanned '%s'\n", expectedStr, str)
			errs++
		}
		if user != pgUser {
			outStr += fmt.Sprintf("Error: expected to scan '%s', scanned '%s'\n", pgUser, user)
			errs++
		}
		err = rows.Err()
		if err != nil {
			outStr += fmt.Sprintf("Rows error: '%+v'\n", err)
			errs++
		}
		err = rows.Close()
		if err != nil {
			outStr += fmt.Sprintf("Rows close error: '%+v'\n", err)
			errs++
		}
	} else {
		outStr += fmt.Sprintf("Query error: '%+v'\n", err)
		errs++
	}
	return outStr, errs
}
