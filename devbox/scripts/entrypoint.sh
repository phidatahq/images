#!/bin/bash

############################################################################
#
# Entrypoint script for the Devbox image
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
# Wait for Services
############################################################################

if [[ "$WAIT_FOR_AIRFLOW_DB" = true || "$WAIT_FOR_AIRFLOW_DB" = True ]]; then
  dockerize \
    -wait tcp://$AIRFLOW_DB_HOST:$AIRFLOW_DB_PORT \
    -timeout 300s
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
# Install workspace
############################################################################

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Installing workspace"
pip3 install --no-deps --editable $PHI_WORKSPACE_ROOT
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

############################################################################
# Install phidata dev
############################################################################

if [[ "$INSTALL_PHIDATA_DEV" = true || "$INSTALL_PHIDATA_DEV" = True ]]; then
  echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  echo "Installing phidata"
  pip3 install --no-deps --editable $PHIDATA_DIR_PATH
  echo "Sleeping for 5 seconds..."
  sleep 5
  echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
fi

############################################################################
# Init database
############################################################################

if [[ "$INIT_AIRFLOW_DB" = true || "$INIT_AIRFLOW_DB" = True ]]; then
  echo "Initializing Airflow DB"
  airflow db init
  echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
fi

if [[ "$CREATE_AIRFLOW_TEST_USER" = true || "$CREATE_AIRFLOW_TEST_USER" = True ]]; then
  echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  echo "Creating airflow user"
  # Use defaults if variables are not set.
  AF_USER_NAME=${AF_USER_NAME:="test"}
  AF_USER_PASSWORD=${AF_USER_PASSWORD:="test"}
  AF_USER_FIRST_NAME=${AF_USER_FIRST_NAME:="test"}
  AF_USER_LAST_NAME=${AF_USER_LAST_NAME:="test"}
  AF_USER_ROLE=${AF_USER_ROLE:="User"}
  AF_USER_EMAIL=${AF_USER_EMAIL:="test@test.com"}
  airflow users create \
    --username ${AF_USER_NAME} \
    --password ${AF_USER_PASSWORD} \
    --firstname ${AF_USER_FIRST_NAME} \
    --lastname ${AF_USER_LAST_NAME} \
    --role ${AF_USER_ROLE} \
    --email ${AF_USER_EMAIL}
  echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
fi

if [[ "$INIT_AIRFLOW_SCHEDULER" = true || "$INIT_AIRFLOW_SCHEDULER" = True ]]; then
  echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  echo "Running: airflow scheduler --deamon"
  airflow scheduler --daemon
  echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
fi

############################################################################
# Start the devbox
############################################################################

if [[ "$INIT_AIRFLOW_WEBSERVER" = true || "$INIT_AIRFLOW_WEBSERVER" = True ]]; then
  echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  echo "Running: airflow webserver"
  airflow webserver
  echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
fi

case "$1" in
  chill)
    ;;
  *)
    exec "$@"
    ;;
esac


echo ">>> Welcome to Devbox!"
while true; do sleep 18000; done
