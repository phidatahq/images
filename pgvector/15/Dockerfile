FROM ankane/pgvector:v0.4.2

RUN mkdir -p /docker-entrypoint-initdb.d
COPY scripts/initdb-extensions.sh /docker-entrypoint-initdb.d/initdb-extensions.sh
