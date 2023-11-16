FROM phidata/python:3.11.5
LABEL maintainer="Ashpreet Bedi <ashpreet@phidata.com>"

# Create user and home dir
ARG USER=jupyter
ARG HOME_DIR=${USER_LOCAL_DIR}/${USER}
ENV HOME_DIR=${HOME_DIR}
# Add HOME_DIR to PYTHONPATH
ENV PYTHONPATH="${HOME_DIR}:${PYTHONPATH}"

RUN groupadd -g 61001 ${USER} \
  && useradd -g 61001 -u 61001 -ms /bin/bash -d ${HOME_DIR} ${USER}

# Install base libraries
ENV DEBIAN_FRONTEND=noninteractive
RUN set -x \
  && apt-get update \
  && apt-get -y install \
  gcc \
  gfortran \
  nodejs \
  npm \
  # pandoc is used to convert notebooks to html files
  pandoc \
  postgresql-client \
  unixodbc \
  unixodbc-dev \
  yarn \
  && pip install -U pip pip-tools setuptools wheel fsspec

# Install jupyterlab
ARG JUPYTERLAB_VERSION=4.0.5
ENV JUPYTERLAB_VERSION=${JUPYTERLAB_VERSION}
RUN pip install jupyterlab==${JUPYTERLAB_VERSION}

# Add jupyterlab config
COPY config /

# Copy scripts
COPY scripts ${SCRIPTS_DIR}

# Clean
RUN apt-get autoremove -y --purge \
  && apt-get clean \
  && rm -rf \
  /var/lib/apt/lists/* \
  /tmp/* \
  /var/tmp/* \
  /usr/share/man \
  /usr/share/doc \
  /usr/share/doc-base \
  && npm cache clean --force \
  && jupyter lab clean

WORKDIR ${HOME_DIR}

ENTRYPOINT ["/scripts/entrypoint.sh"]
CMD ["chill"]

