# ekshealthtest

`ekshealthtest` is a health test for AWS EKS deployment - test connecting to other infra parts for use on K8s. you can run it manually/locally.

# Running locally

To run it locally you need to set all `PG_*`, `ES_*` and `EKS_HEALTH_PORT` environment variables manually:

- `make`
- `./ekshealthtest`
- Attempts to connect to postgres using `PG_SSL`, `PG_HOST`, `PG_PORT`, `PG_USER`, `PG_DB` and `PG_PASS` variables.
- It is not assuming any defaults for those variables, it needs all of them to be passed - this is to test infra ability to pass variables between moving parts.
- Stores results in the string and shows them on the console output and also available via HTTP on `localhost` port from `EKS_HEALTH_PORT` variable.
- Passwords are redacted, displays `len=N` instead (where N is password length).
- If no `EKS_HEALTH_PORT` is specified, default `8888` is used.
- So exampel local run can be: `SKIP_HTTP='' EKS_HEALTH_PORT=8088 PG_SSL=disable PG_HOST=localhost PG_PORT=5432 PG_USER=gha_admin PG_DB=devstats PG_PASS=...  ES_HOST=localhost ES_PORT=9200 ./ekshealthtest`, then go to `http://localhost:8088
