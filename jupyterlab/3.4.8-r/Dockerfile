FROM phidata/python:3.9.12
LABEL maintainer="Ashpreet Bedi <ashpreet@phidata.com>"

# Create user and home dir
ARG USER=jupyter
ARG HOME_DIR=${USER_LOCAL_DIR}/${USER}

RUN groupadd -g 61001 ${USER} \
  && useradd -g 61001 -u 61001 -ms /bin/bash -d ${HOME_DIR} ${USER}

# Create CONDA_DIR
ARG CONDA_DIR=/opt/conda
ENV CONDA_DIR=${CONDA_DIR}
RUN mkdir -p ${CONDA_DIR}
# Give jupyter user permissions
RUN chown -R ${USER}:${USER} ${CONDA_DIR}
# Add CONDA_DIR to PATH
ENV PATH=${CONDA_DIR}/bin:${PATH}

# Install base libraries
ENV DEBIAN_FRONTEND=noninteractive
RUN set -x \
  && apt-get update \
  && apt-get -y install \
  nodejs \
  npm \
  yarn \
  postgresql-client \
  fonts-dejavu \
  unixodbc \
  unixodbc-dev \
  r-cran-rodbc \
  gfortran \
  gcc \
  && pip install -U pip pip-tools setuptools wheel fsspec

# Copy .condarc
COPY .condarc ${CONDA_DIR}

# Download and install micromamba and initialize conda prefix.
WORKDIR /tmp
RUN set -x && \
  # Get arch
  arch=$(uname -m) && \
  if [ "${arch}" = "aarch64" ]; then \
  arch="aarch64"; \
  elif [ "${arch}" = "ppc64le" ]; then \
  arch="ppc64le"; \
  else arch="64"; \
  fi && \
  # Get micromamba
  wget -qO /tmp/micromamba.tar.bz2 \
  "https://micromamba.snakepit.net/api/micromamba/linux-${arch}/latest" && \
  tar -xvjf /tmp/micromamba.tar.bz2 --strip-components=1 bin/micromamba && \
  rm /tmp/micromamba.tar.bz2 && \
  # Install the packages
  ./micromamba install \
  --root-prefix="${CONDA_DIR}" \
  --prefix="${CONDA_DIR}" \
  --yes \
  'mamba' \
  'jupyter_core' && \
  rm micromamba && \
  # Pin major.minor version of python
  # mamba list python | grep '^python ' | tr -s ' ' | cut -d ' ' -f 1,2 >> "${CONDA_DIR}/conda-meta/pinned" && \
  mamba clean --all -f -y

# Install r pre-requisites

# Install jupyterlab
ARG JUPYTERLAB_VERSION=3.4.8
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

