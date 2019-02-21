#!/bin/bash
if [ -z "${AWS_PROFILE}" ]
then
  echo "$0: you need to set AWS_PROFILE=... to run this script"
  exit 1
fi
if [ -z "${ES_HOST}" ]
then
  echo "$0: you need to set ES_HOST=... to run this script (without port and protocol, example 'my-hostname.org')"
  exit 2
fi
if [ -z "${PG_HOST}" ]
then
  echo "$0: you need to set PG_HOST=... to run this script (without port and protocol, example 'my-hostname.org')"
  exit 3
fi
if [ -z "${PG_PASS}" ]
then
  echo "$0: you need to set PG_PASS=... to run this script"
  exit 4
fi
if [ -z "${ES_PROTO}" ]
then
  echo "$0: using default ES proto=http, you can change with ES_PROTO=..."
  export ES_PROTO=http
fi
if [ -z "${ES_PORT}" ]
then
  echo "$0: using default ES port=9200, you can change with ES_PORT=..."
  export ES_PORT=9200
fi
if [ -z "${PG_SSL}" ]
then
  echo "$0: using default PG_SSL=disable, you can change with PG_SSL=..."
  export PG_SSL=disable
fi
if [ -z "${PG_PORT}" ]
then
  echo "$0: using default PG_PORT=5432, you can change with PG_PORT=..."
  export PG_PORT=5432
fi
if [ -z "${PG_USER}" ]
then
  echo "$0: using default PG_USER=postgres, you can change with PG_USER=..."
  export PG_USER=postgres
fi
if [ -z "${PG_DB}" ]
then
  echo "$0: using default PG_DB=postgres, you can change with PG_DB=..."
  export PG_DB=postgres
fi

AWS_PROFILE=lfproduct-dev kubectl run -i --tty ekshealthtest --restart=Never --rm --image=lukaszgryglicki/ekshealthtest --env='SKIP_HTTP=1' --env="PG_SSL=${PG_SSL}" --env="PG_HOST=${PG_HOST}" --env="PG_PORT=${PG_PORT}" --env="PG_USER=${PG_USER}" --env="PG_DB=${PG_DB}" --env="PG_PASS=${PG_PASS}" --env="ES_PROTO=${ES_PROTO}" --env="ES_HOST=${ES_HOST}" --env="ES_PORT=${ES_PORT}" --command './ekshealthtest'
