FROM pgvector/pgvector:0.6.2-pg16

RUN mkdir -p /docker-entrypoint-initdb.d
COPY scripts/initdb-extensions.sh /docker-entrypoint-initdb.d/initdb-extensions.sh
