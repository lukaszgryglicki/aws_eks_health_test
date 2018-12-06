#!/bin/bash
if [ -z "${1}" ]
then
  echo "usage: ${0} docker_username"
  exit 1
fi
docker login || exit 2
docker pull "${1}/ekshealthtest" || exit 3
