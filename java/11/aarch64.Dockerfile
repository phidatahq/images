FROM phidata/python:3.9.12

# Install Java 11 from https://github.com/corretto/corretto-11/releases
ARG CORRETO_VERSION=11.0.18.10.1
ARG CORETTO_ARTIFACT=amazon-corretto-${CORRETO_VERSION}-linux-aarch64
ARG CORETTO_TAR=${CORETTO_ARTIFACT}.tar.gz
ARG CORETTO_URL=https://corretto.aws/downloads/resources/${CORRETO_VERSION}/${CORETTO_TAR}
RUN wget ${CORETTO_URL} -O ${TMP_DIR}/${CORETTO_TAR} --progress=bar:force \
  && tar -xzvf ${TMP_DIR}/${CORETTO_TAR} -C ${BIN_DIR} \
  && rm ${TMP_DIR}/${CORETTO_TAR}

ENV PATH=${PATH}:${BIN_DIR}/${CORETTO_ARTIFACT}/bin
ENV JAVA_HOME=${BIN_DIR}/${CORETTO_ARTIFACT}