package ekshealthtest

import (
	"database/sql"
  "fmt"
	_ "github.com/lib/pq" // As suggested by lib/pq driver
)

func PgConn() *sql.DB {
  connectionString := ""
	//connectionString := "client_encoding=UTF8 sslmode='" + ctx.PgSSL + "' host='" + ctx.PgHost + "' port=" + ctx.PgPort + " dbname='" + ctx.PgDB + "' user='" + ctx.PgUser + "' password='" + ctx.PgPass + "'"
	con, err := sql.Open("postgres", connectionString)
  fmt.Printf("err: %+v\n", err)
	return con
}
