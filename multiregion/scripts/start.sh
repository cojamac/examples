#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

${DIR}/stop.sh

docker-compose up -d

echo "Sleeping 30 seconds"
sleep 30

${DIR}/validate_connectivity.sh
if [[ $? != 0 ]]; then
  echo "Please troubleshoot"
  exit 1
fi

${DIR}/latency_docker.sh

echo "Sleeping 30 seconds"
sleep 30

${DIR}/validate_connectivity.sh
if [[ $? != 0 ]]; then
  echo "Please see the Troubleshooting section of the README"
  exit 1
fi

${DIR}/create-topics.sh

echo "Sleeping 10 seconds"
sleep 10

${DIR}/describe-topics.sh

echo "Sleeping 10 seconds"
sleep 10

${DIR}/start-producer.sh

echo "Sleeping 30 seconds"
sleep 30

${DIR}/start-consumer.sh

echo "Sleeping 5 seconds"
sleep 5

${DIR}/jmx_metrics.sh

