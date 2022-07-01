#!/bin/bash

############################################################################
#
# Entrypoint script for the Databox image
# This script:
#   - Waits for services to be available if needed
#   - Installs libraries
#
############################################################################

if [[ "$PRINT_ENV_ON_LOAD" = true || "$PRINT_ENV_ON_LOAD" = True ]]; then
  echo "=================================================="
  printenv
  echo "=================================================="
fi

############################################################################
# Install dependencies
############################################################################

if [[ "$INSTALL_REQUIREMENTS" = true || "$INSTALL_REQUIREMENTS" = True ]]; then
  echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  echo "Installing requirements from $REQUIREMENTS_FILE_PATH"
  pip3 install -r $REQUIREMENTS_FILE_PATH
  echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
fi

############################################################################
# Start the service
############################################################################

case "$1" in
  chill)
    ;;
  *)
    exec "$@"
    ;;
esac

echo ">>> Welcome to Jupyter!"
while true; do sleep 18000; done
