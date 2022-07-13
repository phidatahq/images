FROM phidata/jupyterlab:3.4.3
LABEL maintainer="Ashpreet Bedi <ashpreet@phidata.com>"

# Install jupyterhub
ARG JUPYTERHUB_VERSION=2.3.1
ENV JUPYTERHUB_VERSION=${JUPYTERHUB_VERSION}
RUN pip install jupyterhub==${JUPYTERHUB_VERSION}
RUN npm install -g configurable-http-proxy

COPY scripts ${SCRIPTS_DIR}
WORKDIR /

ENTRYPOINT ["/scripts/entrypoint.sh"]
CMD ["chill"]