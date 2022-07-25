FROM apache/superset:2.0.0rc2
LABEL maintainer="Ashpreet Bedi <ashpreet@phidata.com>"

USER root

ARG TMP_DIR=/tmp
ARG MNT_DIR=/mnt
ARG SCRIPTS_DIR=/scripts
ARG USER_LOCAL_DIR=/usr/local
ARG BIN_DIR=${USER_LOCAL_DIR}/bin

ENV TMP_DIR=${TMP_DIR}
ENV MNT_DIR=${MNT_DIR}
ENV SCRIPTS_DIR=${SCRIPTS_DIR}
ENV USER_LOCAL_DIR=${USER_LOCAL_DIR}
ENV BIN_DIR=${BIN_DIR}

RUN mkdir -p ${TMP_DIR}
RUN mkdir -p ${MNT_DIR}
RUN mkdir -p ${SCRIPTS_DIR}

# Install base libraries
ENV DEBIAN_FRONTEND=noninteractive
RUN set -x \
  && apt-get update \
  && apt-get install -y \
  apt-utils \
  git \
  ssh \
  vim \
  netcat \
  wget

# Install dockerize
ARG DOCKERIZE_VERSION=v0.6.1
ARG DOCKERIZE_TAR=dockerize-alpine-linux-amd64-${DOCKERIZE_VERSION}.tar.gz
ARG DOCKERIZE_URL=https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/${DOCKERIZE_TAR}

RUN wget ${DOCKERIZE_URL} -O ${TMP_DIR}/${DOCKERIZE_TAR} --progress=bar:force \
  && tar -xzvf ${TMP_DIR}/${DOCKERIZE_TAR} -C ${BIN_DIR} \
  && rm ${TMP_DIR}/${DOCKERIZE_TAR}

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