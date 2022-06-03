#!/bin/bash

############################################################################
#
# Manager script for the Airflow image
# This script helps execute admin tasks like creating a user, upgrading db etc
#
############################################################################

if [[ "$PRINT_ENV_ON_LOAD" = true || "$PRINT_ENV_ON_LOAD" = True ]]; then
  echo "=================================================="
  printenv
  echo "=================================================="
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

echo ">>> Welcome to Airflow Manager!"
while true; do sleep 18000; done
