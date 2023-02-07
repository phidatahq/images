#!/bin/bash

############################################################################
#
# Entrypoint script for the Spark image
#
############################################################################

############################################################################
# Load spark environment variables
############################################################################

. "$SPARK_HOME/bin/load-spark-env.sh"

############################################################################
# Print environment variables
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
# Start the container
############################################################################

case "$1" in
  chill)
    ;;
  driver)
    echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "Starting Spark Driver"
    export SPARK_DRIVER_HOST=`hostname`
    SPARK_DRIVER_PORT=${SPARK_DRIVER_PORT:=7077}
    SPARK_WEBUI_PORT=${SPARK_WEBUI_PORT:=8080}
    echo "SPARK_DRIVER_HOST: $SPARK_DRIVER_HOST"
    echo "SPARK_DRIVER_PORT: $SPARK_DRIVER_PORT"
    echo "SPARK_WEBUI_PORT: $SPARK_WEBUI_PORT"
    echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    exec spark-class org.apache.spark.deploy.master.Master \
      --host $SPARK_DRIVER_HOST \
      --port $SPARK_DRIVER_PORT \
      --webui-port $SPARK_WEBUI_PORT >> $SPARK_DRIVER_LOG
    ;;
  worker)
    echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "Starting Spark Worker"
    SPARK_WORKER_PORT=${SPARK_WORKER_PORT:=7077}
    SPARK_WEBUI_PORT=${SPARK_WEBUI_PORT:=8080}
    echo "SPARK_WORKER_PORT: $SPARK_WORKER_PORT"
    echo "SPARK_WEBUI_PORT: $SPARK_WEBUI_PORT"
    echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    exec spark-class org.apache.spark.deploy.worker.Worker \
      --webui-port $SPARK_WEBUI_PORT \
      $SPARK_DRIVER_URL >> $SPARK_WORKER_LOG
    ;;
  *)
    exec "$@"
    ;;
esac

echo ">>> Welcome to Spark!"
while true; do sleep 18000; done
