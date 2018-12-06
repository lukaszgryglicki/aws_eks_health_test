package ekshealthtest

import (
	"database/sql"
	"fmt"
	"os"

	_ "github.com/lib/pq" // As suggested by lib/pq driver
)

func PgHealth() string {
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
  outStr += fmt.Sprintf("Connection result:\nConnection: '%+v'\nError: '%+v'\n", con, err)
	return outStr
}
