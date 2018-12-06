#!/bin/bash
if [ -z "${1}" ]
then
  echo "usage: ${0} docker_username"
  exit 1
fi
make || exit 2
docker login || exit 3
docker build -t "${1}/ekshealthtest" . || exit 4
docker tag "${1}/ekshealthtest" "${1}/ekshealthtest" || exit 5
docker push "${1}/ekshealthtest" || exit 6
