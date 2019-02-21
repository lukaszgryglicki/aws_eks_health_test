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
AWS_PROFILE=lfproduct-dev kubectl run -i --tty ekshealthtest --restart=Never --rm --image=lukaszgryglicki/ekshealthtest --env='SKIP_HTTP=1' --env="ES_PROTO=${ES_PROTO}" --env="ES_HOST=${ES_HOST}" --env="ES_PORT=${ES_PORT}" --command './ekshealthtest'
