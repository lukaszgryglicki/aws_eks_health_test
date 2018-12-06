#!/bin/bash
if [ -z "${1}" ]
then
  echo "usage: ${0} docker_username"
  exit 1
fi
make || exit 2
docker login || exit 3
docker build -t ekshealthtest . || exit 4
docker tag ekshealthtest "${1}/ekshealthtest" || exit 5
docker push "${1}/ekshealthtest" || exit 6
