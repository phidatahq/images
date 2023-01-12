#!/bin/bash

set -e

CURR_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO="phidata"
NAME="superset"
TAG="2.0.1"

# echo "Running: docker build -t $REPO/$NAME:$TAG $CURR_SCRIPT_DIR"
# docker build -t $REPO/$NAME:$TAG $CURR_SCRIPT_DIR
# docker push $REPO/$NAME:$TAG

# Run docker buildx create --use before running this script
echo "Running: docker buildx build --platform=linux/amd64,linux/arm64,linux/arm/v8 -t $REPO/$NAME:$TAG $CURR_SCRIPT_DIR"
docker buildx build --platform=linux/amd64,linux/arm64,linux/arm/v8 -t $REPO/$NAME:$TAG $CURR_SCRIPT_DIR --push
