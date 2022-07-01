FROM apache/superset:1.5.1
LABEL maintainer="Ashpreet Bedi <ashpreet@phidata.com>"

ARG TMP_DIR=/tmp
ARG WORKSPACES_DIR=/workspaces
ARG SCRIPTS_DIR=/scripts
ARG USER_LOCAL_DIR=/usr/local
ARG BIN_DIR=${USER_LOCAL_DIR}/bin

USER root
RUN mkdir -p ${TMP_DIR}
RUN mkdir -p ${WORKSPACES_DIR}
RUN mkdir -p ${SCRIPTS_DIR}

## Install base libraries
RUN set -x \
  && apt-get update \
  && apt-get install -y \
  apt-utils \
  git \
  ssh \
  vim \
  wget

## Install dockerize
ARG DOCKERIZE_VERSION=v0.6.1
ARG DOCKERIZE_TAR=dockerize-alpine-linux-amd64-${DOCKERIZE_VERSION}.tar.gz
ARG DOCKERIZE_URL=https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/${DOCKERIZE_TAR}

RUN wget ${DOCKERIZE_URL} -O ${TMP_DIR}/${DOCKERIZE_TAR} --progress=bar:force \
  && tar -xzvf ${TMP_DIR}/${DOCKERIZE_TAR} -C ${BIN_DIR} \
  && rm ${TMP_DIR}/${DOCKERIZE_TAR}

COPY scripts ${SCRIPTS_DIR}
WORKDIR ${WORKSPACES_DIR}

ENTRYPOINT ["/scripts/entrypoint.sh"]
CMD ["chill"]