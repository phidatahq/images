FROM phidata/airflow:2.3.3
LABEL maintainer="Ashpreet Bedi <ashpreet@phidata.com>"

# Create user and home dir
ARG USER=jupyter
ARG HOME_DIR=${USER_LOCAL_DIR}/${USER}

RUN groupadd -g 61001 ${USER} \
  && useradd -g 61001 -u 61001 -ms /bin/bash -d ${HOME_DIR} ${USER}

# Give jupyter user permissions to AIRFLOW_HOME
RUN chown -R ${USER}:${USER} ${AIRFLOW_HOME}

# Create notebooks mount
ARG NOTEBOOKS_DIR=${MNT_DIR}/notebooks
ENV NOTEBOOKS_DIR=${NOTEBOOKS_DIR}
RUN mkdir -p ${NOTEBOOKS_DIR}

# Install base libraries
ENV DEBIAN_FRONTEND=noninteractive
RUN set -x \
  && apt-get update \
  && apt-get -y install \
  nodejs \
  npm \
  yarn \
  && pip install -U pip pip-tools setuptools wheel fsspec

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

COPY scripts ${SCRIPTS_DIR}
WORKDIR /

ENTRYPOINT ["/scripts/entrypoint.sh"]
CMD ["chill"]

