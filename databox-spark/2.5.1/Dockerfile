FROM phidata/airflow-spark:2.5.1
LABEL maintainer="Ashpreet Bedi <ashpreet@phidata.com>"

# Create user and home dir
ARG USER=databox
ARG HOME_DIR=${USER_LOCAL_DIR}/${USER}

RUN groupadd -g 61001 ${USER} \
  && useradd -g 61001 -u 61001 -ms /bin/bash -d ${HOME_DIR} ${USER}

# Give databox user permissions to AIRFLOW_HOME
# RUN chown -R ${USER}:${USER} ${AIRFLOW_HOME}

COPY scripts ${SCRIPTS_DIR}

WORKDIR ${HOME_DIR}
ENTRYPOINT ["/scripts/entrypoint.sh"]
CMD ["chill"]
