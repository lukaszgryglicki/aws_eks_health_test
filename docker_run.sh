#!/bin/bash
if [ -z "${1}" ]
then
  echo "usage: ${0} docker_username"
  exit 1
fi
if [ -z "${EKS_HEALTH_PORT}" ]
then
  EKS_HEALTH_PORT=8888
fi
if [ -z "${PG_HOST}" ]
then
  if [ -z "${host}" ]
  then
    host=`docker run "${1}/ekshealthtest" ip route show | awk '/default/ {print $3}'`
  fi
  export PG_HOST="${host}"
fi
if [ -z "${ES_HOST}" ]
then
  if [ -z "${host}" ]
  then
    host=`docker run "${1}/ekshealthtest" ip route show | awk '/default/ {print $3}'`
  fi
  export ES_HOST="${host}"
fi
docker run -it -p "${EKS_HEALTH_PORT}:${EKS_HEALTH_PORT}" -e SKIP_HTTP="${SKIP_HTTP}" -e EKS_HEALTH_PORT="${EKS_HEALTH_PORT}" --env-file <(env | grep PG_) --env-file <(env | grep ES_) "${1}/ekshealthtest"
