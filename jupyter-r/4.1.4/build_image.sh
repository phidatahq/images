#!/bin/bash

set -e

CURR_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO="phidata"
NAME="jupyter-r"
TAG="4.1.4"

# Run docker buildx create --use before running this script
echo "Running: docker buildx build --platform=linux/amd64,linux/arm64 -t $REPO/$NAME:$TAG $CURR_SCRIPT_DIR"
docker buildx build --platform=linux/amd64,linux/arm64 -t $REPO/$NAME:$TAG $CURR_SCRIPT_DIR --push
