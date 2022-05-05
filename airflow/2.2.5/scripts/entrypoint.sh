#!/bin/bash

############################################################################
#
# Entrypoint script for the Airflow image
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

if [[ "$WAIT_FOR_DB" = true || "$WAIT_FOR_DB" = True ]]; then
  dockerize \
    -wait tcp://$DB_HOST:$DB_PORT \
    -timeout 300s
fi

if [[ "$WAIT_FOR_REDIS" = true || "$WAIT_FOR_REDIS" = True ]]; then
  dockerize \
    -wait tcp://$REDIS_HOST:$REDIS_PORT \
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
# Start the container
############################################################################

case "$1" in
  chill)
    ;;
  webserver)
    exec airflow webserver
    ;;
  scheduler)
    if [[ "$INIT_AIRFLOW_DB" = true || "$INIT_AIRFLOW_DB" = True ]]; then
      echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
      echo "Waiting 10 seconds for db to be initialized"
      sleep 10
      echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    fi
    exec airflow scheduler
    ;;
  worker)
    if [[ "$INIT_AIRFLOW_DB" = true || "$INIT_AIRFLOW_DB" = True ]]; then
      echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
      echo "Waiting 10 seconds for db to be initialized"
      sleep 10
      echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    fi
    exec airflow celery "$@" -q "$QUEUE_NAME"
    ;;
  flower)
    if [[ "$INIT_AIRFLOW_DB" = true || "$INIT_AIRFLOW_DB" = True ]]; then
      echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
      echo "Waiting 10 seconds for db to be initialized"
      sleep 10
      echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    fi
    exec airflow celery "$@"
    ;;
  *)
    exec "$@"
    ;;
esac


echo ">>> Welcome to Airflow!"
while true; do sleep 18000; done
