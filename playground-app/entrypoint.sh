#!/bin/bash

case "$1" in
  chill)
    ;;
  *)
    echo "Running: $@"
    exec "$@"
    ;;
esac

echo ">>> Hello World!"
while true; do sleep 18000; done
