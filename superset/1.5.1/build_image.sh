#!/bin/bash

set -e

CURR_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO="phidata"
NAME="superset"
TAG="1.5.1"

echo "Running: docker build -t $REPO/$NAME:$TAG $CURR_SCRIPT_DIR"
docker build -t $REPO/$NAME:$TAG $CURR_SCRIPT_DIR
docker push $REPO/$NAME:$TAG
