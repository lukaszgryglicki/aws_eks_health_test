#!/bin/bash
host=`docker run ekshealthtest ip route show | awk '/default/ {print $3}'`
if [ -z "${PG_HOST}" ]
then
  export PG_HOST="${host}"
fi
if [ -z "${ES_HOST}" ]
then
  export ES_HOST="${host}"
fi
docker run -it -p "${EKS_HEALTH_PORT}:${EKS_HEALTH_PORT}" -e SKIP_HTTP="${SKIP_HTTP}" -e EKS_HEALTH_PORT="${EKS_HEALTH_PORT}" --env-file <(env | grep PG_) --env-file <(env | grep ES_) ekshealthtest
