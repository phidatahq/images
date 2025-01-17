#!/bin/bash

############################################################################
#
# Entrypoint script for Django
#
############################################################################

set -e  # Exit immediately if a command exits with a non-zero status.

############################################################################
# Print Environment Variables (optional)
############################################################################

if [[ "$PRINT_ENV_ON_LOAD" = true || "$PRINT_ENV_ON_LOAD" = True ]]; then
  echo "=================================================="
  echo "Environment Variables:"
  printenv
  echo "=================================================="
fi

############################################################################
# Wait for Services (e.g., Database, Redis)
############################################################################

if [[ "$WAIT_FOR_DB" = true || "$WAIT_FOR_DB" = True ]]; then
  echo "Waiting for database at $DB_HOST:$DB_PORT..."
  dockerize \
    -wait tcp://$DB_HOST:$DB_PORT \
    -timeout 300s
fi

if [[ "$WAIT_FOR_REDIS" = true || "$WAIT_FOR_REDIS" = True ]]; then
  echo "Waiting for Redis at $REDIS_HOST:$REDIS_PORT..."
  dockerize \
    -wait tcp://$REDIS_HOST:$REDIS_PORT \
    -timeout 300s
fi

############################################################################
# Install Python Dependencies
############################################################################

if [[ "$INSTALL_REQUIREMENTS" = true || "$INSTALL_REQUIREMENTS" = True ]]; then
  echo "Installing Python dependencies from $REQUIREMENTS_FILE_PATH..."
  pip3 install --no-cache-dir -r $REQUIREMENTS_FILE_PATH
fi

############################################################################
# Run Django Migrations (optional)
############################################################################

if [[ "$RUN_MIGRATIONS" = true || "$RUN_MIGRATIONS" = True ]]; then
  echo "Running Django migrations..."
  python manage.py migrate --noinput
fi

############################################################################
# Collect Static Files (optional)
############################################################################

if [[ "$COLLECT_STATIC" = true || "$COLLECT_STATIC" = True ]]; then
  echo "Collecting static files..."
  python manage.py collectstatic --noinput
fi

############################################################################
# Start Django Application
############################################################################

case "$1" in
  runserver)
    echo "Starting Django development server..."
    exec python manage.py runserver 0.0.0.0:$DJANGO_PORT
    ;;
  gunicorn)
    echo "Starting Gunicorn server..."
    exec gunicorn $DJANGO_WSGI_MODULE \
      --bind 0.0.0.0:$DJANGO_PORT \
      --workers $GUNICORN_WORKERS \
      --threads $GUNICORN_THREADS \
      --timeout $GUNICORN_TIMEOUT
    ;;
  *)
    echo "Executing custom command: $@"
    exec "$@"
    ;;
esac

echo "Entrypoint script completed."