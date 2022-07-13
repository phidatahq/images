FROM phidata/python:3.9.12
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

RUN pip install -U pip setuptools wheel pip-tools
RUN pip install -U phidata

COPY scripts ${SCRIPTS_DIR}
WORKDIR ${WORKSPACES_DIR}

ENTRYPOINT ["/scripts/entrypoint.sh"]
CMD ["chill"]