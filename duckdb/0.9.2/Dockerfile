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
RUN cd duckdb && GEN=ninja BUILD_HTTPFS=1 BUILD_JSON=1 BUILD_PYTHON=1 make release

# Remove duckdb source
RUN rm -rf duckdb

# Clean up
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /
CMD ["zsh"]
