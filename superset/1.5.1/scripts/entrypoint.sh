#!/bin/bash

############################################################################
#
# Entrypoint script for the Superset image
# This script:
#   - Waits for services to be available if needed
#   - Installs dependencies
#   - Starts the container based on the command
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
    -wait tcp://$DATABASE_HOST:$DATABASE_PORT \
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
  if [ -f "$REQUIREMENTS_FILE_PATH" ]; then
    echo "Installing requirements from $REQUIREMENTS_FILE_PATH"
    pip install -r $REQUIREMENTS_FILE_PATH
  else
    echo "$REQUIREMENTS_FILE_PATH unavailable"
  fi
  echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
fi

############################################################################
# Start the container
############################################################################

case "$1" in
  chill)
    ;;
  webserver)
    echo "Starting webserver..."
    /scripts/run-server.sh
    ;;
  app)
    echo "Starting flask app..."
    flask run -p 8088 --with-threads --reload --debugger --host=0.0.0.0
    ;;
  beat)
    echo "Starting celery beat..."
    celery --app=superset.tasks.celery_app:app beat --pidfile /tmp/celerybeat.pid -l INFO -s "${SUPERSET_HOME}"/celerybeat-schedule
    ;;
  worker)
    echo "Starting celery worker..."
    celery --app=superset.tasks.celery_app:app worker -Ofair -l INFO
    ;;
  *)
    exec "$@"
    ;;
esac

echo ">>> Welcome to Superset!"