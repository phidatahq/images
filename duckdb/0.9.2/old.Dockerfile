FROM phidata/python:3.11.5
LABEL maintainer="Ashpreet Bedi <ashpreet@phidata.com>"

# Install libraries required to build duckdb
RUN set -x \
    && apt-get update \
    && apt-get install -y \
    cmake \
    git \
    g++ \
    ninja-build \
    libssl-dev

# Update pip
RUN pip install --upgrade pip

# Clone duckdb
RUN git clone --depth 1 --branch v0.9.2 https://github.com/duckdb/duckdb

# Build duckdb
ENV GEN=ninja
ENV BUILD_FTS=1
ENV BUILD_HTTPFS=1
ENV BUILD_JSON=1
ENV BUILD_PYTHON=1
RUN cd duckdb/tools/pythonpkg && python setup.py install

WORKDIR /
CMD ["zsh"]
