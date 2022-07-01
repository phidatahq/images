#!/bin/bash

CURR_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPO="phidata"
NAME="jupyter"
TAG="3.4.3"

echo "Running: docker build -t $REPO/$NAME:$TAG $CURR_SCRIPT_DIR"
docker build -t $REPO/$NAME:$TAG $CURR_SCRIPT_DIR
docker push $REPO/$NAME:$TAG
