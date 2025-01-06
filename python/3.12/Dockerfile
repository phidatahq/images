# Use a python image with uv pre-installed
FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

# Set ARGs and ENVs
ARG TMP_DIR=/tmp
ARG MNT_DIR=/mnt
ARG SCRIPTS_DIR=/scripts
ARG USER_LOCAL_DIR=/usr/local
ARG BIN_DIR=${USER_LOCAL_DIR}/bin
ENV TMP_DIR=${TMP_DIR} \
    MNT_DIR=${MNT_DIR} \
    SCRIPTS_DIR=${SCRIPTS_DIR} \
    USER_LOCAL_DIR=${USER_LOCAL_DIR} \
    BIN_DIR=${BIN_DIR} \
    # Enable bytecode compilation
    UV_COMPILE_BYTECODE=1 \
    # Copy from the cache instead of linking since it's a mounted volume
    UV_LINK_MODE=copy

# Create directories and install base libraries
RUN set -ex \
    && mkdir -p ${TMP_DIR} ${MNT_DIR} ${SCRIPTS_DIR} \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        apt-utils bzip2 build-essential ca-certificates curl cmake git gcc gnupg \
        rsync ssh vim wget libevent-dev zsh \
    && pip install -U pip setuptools wheel pip-tools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install dockerize
ARG DOCKERIZE_VERSION=v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-alpine-linux-amd64-${DOCKERIZE_VERSION}.tar.gz -O ${TMP_DIR}/dockerize.tar.gz \
    && tar -xzvf ${TMP_DIR}/dockerize.tar.gz -C ${BIN_DIR} \
    && rm ${TMP_DIR}/dockerize.tar.gz

# Install oh-my-zsh and plugins
RUN wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O ${TMP_DIR}/zsh_install.sh \
    && sh ${TMP_DIR}/zsh_install.sh --unattended \
    && rm ${TMP_DIR}/zsh_install.sh \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Copy zsh theme and config
COPY dotfiles/phi.zsh-theme ${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}/themes/phi.zsh-theme
COPY dotfiles/.zshrc /root

# Final cleanup
RUN rm -rf /tmp/* /var/tmp/* /usr/share/man /usr/share/doc /usr/share/doc-base

WORKDIR /
CMD ["zsh"]
