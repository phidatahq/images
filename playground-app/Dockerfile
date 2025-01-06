# Use a python image with uv pre-installed
FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

# Set ARGs and ENVs
ARG USER=app
ARG TMP_DIR=/tmp
ARG SCRIPTS_DIR=/scripts
ARG APP_DIR=/app

ENV TMP_DIR=${TMP_DIR} \
    SCRIPTS_DIR=${SCRIPTS_DIR} \
    APP_DIR=${APP_DIR} \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    # Enable bytecode compilation
    UV_COMPILE_BYTECODE=1 \
    # Copy from the cache instead of linking since it's a mounted volume
    UV_LINK_MODE=copy

# Create directories and install base libraries
RUN set -ex \
    && mkdir -p ${TMP_DIR} ${SCRIPTS_DIR} ${APP_DIR} \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        apt-utils bzip2 build-essential ca-certificates curl cmake git gcc gnupg \
        rsync wget libevent-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Cleanup
RUN rm -rf /tmp/* /var/tmp/* /usr/share/man /usr/share/doc /usr/share/doc-base

# Create user and home directory in one layer
RUN groupadd -g 51001 ${USER} \
    && useradd -g 51001 -u 51001 -ms /bin/bash -d ${APP_DIR} ${USER}

# Give the user permissions to the /tmp and /scripts directories
RUN chown -R ${USER}:${USER} ${TMP_DIR} ${SCRIPTS_DIR} ${APP_DIR}

# Copy entrypoint.sh
COPY entrypoint.sh ${SCRIPTS_DIR}/entrypoint.sh

# Switch to non-root user
USER ${USER}

# Set the working directory
WORKDIR ${APP_DIR}

# Create a uv virtual environment
RUN uv venv

# Copy base-requirements
COPY base-requirements.txt ./

# Install base-requirements
RUN uv pip install -r ./base-requirements.txt

ENTRYPOINT ["/scripts/entrypoint.sh"]

CMD ["chill"]