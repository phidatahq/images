#!/bin/bash

set -e

CURR_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO="phidata"
NAME="fastapi"
TAG="0.96"

# Run docker buildx create --use before running this script
echo "Running: docker buildx build --platform=linux/amd64,linux/arm64,linux/arm/v8 -t $REPO/$NAME:$TAG $CURR_SCRIPT_DIR --push"
docker buildx build --platform=linux/amd64,linux/arm64,linux/arm/v8 -t $REPO/$NAME:$TAG $CURR_SCRIPT_DIR --push
