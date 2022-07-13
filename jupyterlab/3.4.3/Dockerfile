FROM phidata/python:3.9.12
LABEL maintainer="Ashpreet Bedi <ashpreet@phidata.com>"

ARG USER_LOCAL_DIR=/usr/local
ARG BIN_DIR=${USER_LOCAL_DIR}/bin

# Define dirs
ARG USER=jupyter
ARG USER_LOCAL_DIR=/usr/local
ARG HOME_DIR=${USER_LOCAL_DIR}/${USER}
ARG AIRFLOW_HOME=${USER_LOCAL_DIR}/airflow
ENV AIRFLOW_HOME=${AIRFLOW_HOME}
RUN groupadd -g 61000 ${USER} \
  && useradd -g 61000 -u 61000 -ms /bin/bash -d ${HOME_DIR} ${USER}

# Install base libraries
ENV DEBIAN_FRONTEND=noninteractive
RUN set -x \
  && airflowBuildDeps=' \
  freetds-bin \
  krb5-user \
  ldap-utils \
  libffi6 \
  libsasl2-2 \
  libsasl2-modules \
  libssl1.1 \
  locales  \
  lsb-release \
  sasl2-bin \
  sqlite3 \
  unixodbc ' \
  && apt-get update \
  && apt-get -y install \
  nodejs \
  npm \
  yarn \
  postgresql-client \
  $airflowBuildDeps \
  # Needed for airflow: https://airflow.apache.org/docs/apache-airflow/stable/installation.html#installation-tools
  && pip install -U pip pip-tools setuptools wheel fsspec

# Install airflow
ARG AIRFLOW_VERSION=2.3.2
ENV AIRFLOW_VERSION=${AIRFLOW_VERSION}
ARG PYTHON_VERSION_ARG=3.9
ENV PYTHON_VERSION_ARG=${PYTHON_VERSION_ARG}
ARG CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION_ARG}.txt"
# Example: https://raw.githubusercontent.com/apache/airflow/constraints-2.2.4/constraints-3.9.txt
# Details: https://airflow.apache.org/docs/apache-airflow/stable/installation/installing-from-pypi.html#constraints-files
ARG AIRFLOW_EXTRAS="celery,redis,postgres,slack,crypto,google_auth"
ENV AIRFLOW_EXTRAS=${AIRFLOW_EXTRAS}
RUN pip install -U "apache-airflow[${AIRFLOW_EXTRAS}]==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"

# Install jupyterlab
ARG JUPYTERLAB_VERSION=3.4.3
ENV JUPYTERLAB_VERSION=${JUPYTERLAB_VERSION}
RUN pip install jupyterlab==${JUPYTERLAB_VERSION}

# Install jupyter notebooks
ARG NOTEBOOK_VERSION=6.4.12
ENV NOTEBOOK_VERSION=${NOTEBOOK_VERSION}
RUN pip install notebook==${NOTEBOOK_VERSION}

# Clean
RUN apt-get autoremove -y --purge \
  && apt-get clean \
  && rm -rf \
  /var/lib/apt/lists/* \
  /tmp/* \
  /var/tmp/* \
  /usr/share/man \
  /usr/share/doc \
  /usr/share/doc-base

# Create additional directories
ARG TMP_DIR=/tmp
ARG MNT_DIR=/mnt
ARG SCRIPTS_DIR=/scripts
ARG NOTEBOOKS_DIR=${MNT_DIR}/notebooks
ARG WORKSPACES_DIR=/workspaces

RUN mkdir -p ${TMP_DIR}
RUN mkdir -p ${MNT_DIR}
RUN mkdir -p ${SCRIPTS_DIR}
RUN mkdir -p ${NOTEBOOKS_DIR}
RUN mkdir -p ${WORKSPACES_DIR}

ENV TMP_DIR=${TMP_DIR}
ENV MNT_DIR=${MNT_DIR}
ENV SCRIPTS_DIR=${SCRIPTS_DIR}
ENV NOTEBOOKS_DIR=${NOTEBOOKS_DIR}
ENV WORKSPACES_DIR=${WORKSPACES_DIR}

COPY scripts ${SCRIPTS_DIR}
WORKDIR /

ENTRYPOINT ["/scripts/entrypoint.sh"]
CMD ["chill"]