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
  if [ -f "$REQUIREMENTS_FILE_PATH" ]; then
    echo "Installing requirements from $REQUIREMENTS_FILE_PATH"
    pip install -r $REQUIREMENTS_FILE_PATH
  else
    echo "$REQUIREMENTS_FILE_PATH unavailable"
  fi
  echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
fi

############################################################################
# Start the service
############################################################################

case "$1" in
  chill)
    ;;
  lab)
    jupyter lab
    ;;
  notebook)
    jupyter notebook
    ;;
  *)
    echo "Running command: $@"
    exec "$@"
    ;;
esac

echo ">>> Welcome to JupyterLab!"
while true; do sleep 18000; done
