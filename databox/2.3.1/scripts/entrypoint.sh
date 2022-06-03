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

############################################################################
# Upgrade database
############################################################################

if [[ "$UPGRADE_AIRFLOW_DB" = true || "$UPGRADE_AIRFLOW_DB" = True ]]; then
  echo "Upgrading Airflow DB"
  airflow db upgrade
  echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
fi

############################################################################
# Create airflow admin user
############################################################################

if [[ "$CREATE_AIRFLOW_ADMIN_USER" = true || "$CREATE_AIRFLOW_ADMIN_USER" = True ]]; then
  echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  echo "Creating airflow user"
  # Use defaults if variables are not set.
  AF_USER_NAME=${AF_USER_NAME:="admin"}
  AF_USER_PASSWORD=${AF_USER_PASSWORD:="admin"}
  AF_USER_FIRST_NAME=${AF_USER_FIRST_NAME:="admin"}
  AF_USER_LAST_NAME=${AF_USER_LAST_NAME:="admin"}
  AF_USER_ROLE=${AF_USER_ROLE:="Admin"}
  AF_USER_EMAIL=${AF_USER_EMAIL:="admin@admin.com"}
  airflow users create \
    --username ${AF_USER_NAME} \
    --password ${AF_USER_PASSWORD} \
    --firstname ${AF_USER_FIRST_NAME} \
    --lastname ${AF_USER_LAST_NAME} \
    --role ${AF_USER_ROLE} \
    --email ${AF_USER_EMAIL}
  echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
fi

############################################################################
# Run the required service
############################################################################

if [[ "$INIT_AIRFLOW_STANDALONE" = true || "$INIT_AIRFLOW_STANDALONE" = True ]]; then
  echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  echo "Running: airflow standalone"
  airflow standalone
  echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
fi

if [[ "$INIT_AIRFLOW_SCHEDULER" = true || "$INIT_AIRFLOW_SCHEDULER" = True ]]; then
  echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  echo "Running: airflow scheduler --deamon"
  airflow scheduler --daemon
  echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
fi

if [[ "$INIT_AIRFLOW_WEBSERVER" = true || "$INIT_AIRFLOW_WEBSERVER" = True ]]; then
  echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  echo "Running: airflow webserver"
  airflow webserver
  echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
fi

############################################################################
# Start the databox
############################################################################

case "$1" in
  chill)
    ;;
  *)
    exec "$@"
    ;;
esac

echo ">>> Welcome to Databox!"
while true; do sleep 18000; done
