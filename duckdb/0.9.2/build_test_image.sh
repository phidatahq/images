#!/bin/bash

set -e

CURR_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOCKERFILE="${CURR_SCRIPT_DIR}/test.Dockerfile"
REPO="phidata"
NAME="duckdb-test"
TAG="0.9.2"

# Run docker buildx create --use before running this script
echo "Running: docker buildx build --platform=linux/amd64,linux/arm64 -t $REPO/$NAME:$TAG -f $DOCKERFILE $CURR_SCRIPT_DIR --push"
docker buildx build --platform=linux/amd64,linux/arm64 -t $REPO/$NAME:$TAG -f $DOCKERFILE $CURR_SCRIPT_DIR --push
