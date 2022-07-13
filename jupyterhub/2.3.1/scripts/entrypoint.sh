#!/bin/bash

############################################################################
#
# Entrypoint script for the JupyterLab image
# This script:
#   - Installs libraries
#   - Starts the appropriate service
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

echo "User: $(whoami)"

case "$1" in
  chill)
    ;;
  hub)
    echo "Running: jupyterhub"
    jupyterhub
    ;;
  *)
    echo "Running: $@"
    exec "$@"
    ;;
esac

echo ">>> Welcome to JupyterHub!"
while true; do sleep 18000; done
