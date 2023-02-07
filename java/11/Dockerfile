FROM phidata/python:3.9.12

# Install Java 11 from https://github.com/corretto/corretto-11/releases
ARG JAVA_FOLDER=java-11
ARG CORRETO_VERSION=11.0.18.10.1
RUN set -x && \
  # Get arch
  arch=$(uname -m) && \
  if [ "${arch}" = "aarch64" ]; then \
  arch="aarch64"; \
  else arch="x64"; \
  fi \
  && CORETTO_ARTIFACT=amazon-corretto-${CORRETO_VERSION}-linux-${arch} \
  && CORETTO_TAR=${CORETTO_ARTIFACT}.tar.gz \
  && CORETTO_URL=https://corretto.aws/downloads/resources/${CORRETO_VERSION}/${CORETTO_TAR} \
  && wget ${CORETTO_URL} -O ${TMP_DIR}/${CORETTO_TAR} --progress=bar:force \
  && tar -xzvf ${TMP_DIR}/${CORETTO_TAR} -C ${BIN_DIR} \
  && mv ${BIN_DIR}/${CORETTO_ARTIFACT} ${BIN_DIR}/${JAVA_FOLDER} \
  && rm ${TMP_DIR}/${CORETTO_TAR}

ENV PATH=${PATH}:${BIN_DIR}/${JAVA_FOLDER}/bin
ENV JAVA_HOME=${BIN_DIR}/${JAVA_FOLDER}