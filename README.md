# ekshealthtest

`ekshealthtest` is a health test for AWS EKS deployment - test connecting to other infra parts for use on K8s. You can run it manually/locally.

# Running locally

To run it locally you need to set all `PG_*`, `ES_*` and `EKS_HEALTH_PORT` environment variables manually:

- `make`
- `./ekshealthtest`
- Attempts to connect to postgres using `PG_SSL`, `PG_HOST`, `PG_PORT`, `PG_USER`, `PG_DB` and `PG_PASS` variables.
- It is not assuming any defaults for those variables, it needs all of them to be passed - this is to test infra ability to pass variables between moving parts.
- Stores results in the string and shows them on the console output and also available via HTTP on `localhost` port from `EKS_HEALTH_PORT` variable.
- Passwords are redacted, displays `len=N` instead (where N is password length).
- If no `EKS_HEALTH_PORT` is specified, default `8888` is used.
- So example local run can be: `SKIP_HTTP='' EKS_HEALTH_PORT=8088 PG_SSL=disable PG_HOST=localhost PG_PORT=5432 PG_USER=gha_admin PG_DB=devstats PG_PASS=...  ES_HOST=localhost ES_PORT=9200 ES_PROTO="http" ./ekshealthtest`, then go to `http://localhost:8088`.

# Running from the docker

To run from docker you need to set all `PG_*`, `ES_*` and `EKS_HEALTH_PORT` environment variables manually:

- Requires Linux and Go tools installed, need to be done once (or after any changes to go source code): `./build.sh your_docker_username`.
- Alternatively you can just pull ready image: `./pull.sh docker_username`.
- `SKIP_HTTP='' EKS_HEALTH_PORT=8880 PG_SSL=disable PG_PORT=5432 PG_USER=postgres PG_DB=postgres PG_PASS=... ES_PORT=9200 ES_PROTO="http" ./docker_run.sh docker_username`.
- Go to `http://localhost:8880`.
- Finally `docker container ls`, look for `ekshealthtest`, `docker stop ekshealthtest_container_id`.

# Running from docker from the AWS instance

- `SKIP_HTTP=1 PG_SSL=disable PG_HOST="aurora_db_url" PG_PORT=aurora_port PG_USER=sa PG_DB=postgres PG_PASS="aurora_db_pass" ES_HOST="es_host" ES_PORT=es_port ES_PROTO="https" ./docker_run.sh docker_username`

# Running from the EKS Kubernetes cluster

- `AWS_PROFILE=... ES_HOST=... PG_HOST=... PG_PASS=... PG_USER=... ./kubernetes_run.sh`.
