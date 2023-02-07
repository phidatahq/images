#!/bin/bash

set -e

CURR_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO="phidata"
NAME="java"
TAG="11"

# Run docker buildx create --use before running this script
echo "Running: docker buildx build --platform=linux/amd64 -t $REPO/$NAME:$TAG -f $CURR_SCRIPT_DIR/x64.Dockerfile $CURR_SCRIPT_DIR"
docker buildx build --platform=linux/amd64 -t $REPO/$NAME:$TAG -f $CURR_SCRIPT_DIR/x64.Dockerfile $CURR_SCRIPT_DIR --push