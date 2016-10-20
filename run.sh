#!/bin/bash

HOST=http://localhost
NUM_CLIENTS=5
NUM_REQUESTS=$(($NUM_CLIENTS * 5))
HATCH_RATE=$NUM_CLIENTS

set -e

docker build -t perf-test .
docker run --rm perf-test -H $HOST --no-web -c $NUM_CLIENTS -r $HATCH_RATE -n $NUM_REQUESTS --only-summary
