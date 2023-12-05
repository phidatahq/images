FROM phidata/python:3.11.5
LABEL maintainer="Ashpreet Bedi <ashpreet@phidata.com>"

ARG TARGETPLATFORM
ARG BUILDPLATFORM

RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"

# Install libraries required to build duckdb
RUN set -x \
    && apt-get update \
    && apt-get install -y \
    git \
    g++ \
    cmake \
    ninja-build \
    libssl-dev

# Update pip
RUN pip install --upgrade pip

RUN if [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
    git clone --depth 1 --branch v0.9.2 https://github.com/duckdb/duckdb && \
    cd duckdb/tools/pythonpkg && BUILD_HTTPFS=1 python -m pip install . ; \
    elif [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
    pip install duckdb==0.9.2; \
    fi

# Remove duckdb source
RUN rm -rf duckdb

# Clean up
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN ["python", "-c", "import duckdb;print(duckdb.sql('select count(*) from read_csv_auto(\"https://raw.githubusercontent.com/duckdb/duckdb/main/data/csv/aws_locations.csv\")'))"]

WORKDIR /
CMD ["zsh"]
