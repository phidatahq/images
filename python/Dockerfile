FROM python:3.9.12-slim-buster
LABEL maintainer="Ashpreet Bedi <ashpreet@phidata.com>"

ARG TMP_DIR=/tmp
ARG USER_LOCAL_DIR=/usr/local
ARG BIN_DIR=${USER_LOCAL_DIR}/bin

## Install base libraries
RUN set -x \
  && apt-get update \
  && apt-get install -y \
  apt-utils \
  git \
  gnupg \
  netcat \
  rsync \
  ssh \
  vim \
  wget \
  libevent-dev \
  libpq-dev \
  zsh \
  && pip install -U pip setuptools wheel pip-tools

## Install dockerize
ARG DOCKERIZE_VERSION=v0.6.1
ARG DOCKERIZE_TAR=dockerize-alpine-linux-amd64-${DOCKERIZE_VERSION}.tar.gz
ARG DOCKERIZE_URL=https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/${DOCKERIZE_TAR}

RUN wget ${DOCKERIZE_URL} -O ${TMP_DIR}/${DOCKERIZE_TAR} --progress=bar:force \
  && tar -xzvf ${TMP_DIR}/${DOCKERIZE_TAR} -C ${BIN_DIR} \
  && rm ${TMP_DIR}/${DOCKERIZE_TAR}

## Install oh_my_zsh
ARG OH_MY_ZSH_SCRIPT=zsh_install.sh
ARG OH_MY_ZSH_URL=https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
RUN wget ${OH_MY_ZSH_URL} -O ${TMP_DIR}/${OH_MY_ZSH_SCRIPT} --progress=bar:force \
  && sh ${TMP_DIR}/${OH_MY_ZSH_SCRIPT} \
  && rm ${TMP_DIR}/${OH_MY_ZSH_SCRIPT}
## zsh plugins
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
## zsh theme
COPY dotfiles/phi.zsh-theme ${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}/themes/phi.zsh-theme
# add zshrc
COPY dotfiles/.zshrc /root

## Clean
RUN apt-get autoremove -y --purge \
  && apt-get clean \
  && rm -rf \
  /var/lib/apt/lists/* \
  /tmp/* \
  /var/tmp/* \
  /usr/share/man \
  /usr/share/doc \
  /usr/share/doc-base

WORKDIR ${USER_LOCAL_DIR}
CMD ["zsh"]
