#!/bin/bash

set -e

CURR_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO="phidata"
NAME="jupyterlab"
TAG="3.5.2"

# "Running: docker build -t $REPO/$NAME:$TAG $CURR_SCRIPT_DIR"
# docker build -t $REPO/$NAME:$TAG $CURR_SCRIPT_DIR

# Run docker buildx create --use before running this script
echo "Running: docker buildx build --platform=linux/amd64,linux/arm64 -t $REPO/$NAME:$TAG $CURR_SCRIPT_DIR"
docker buildx build --platform=linux/amd64,linux/arm64 -t $REPO/$NAME:$TAG $CURR_SCRIPT_DIR --push
