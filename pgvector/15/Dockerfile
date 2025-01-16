FROM pgvector/pgvector:pg15

RUN mkdir -p /docker-entrypoint-initdb.d
COPY scripts/initdb-extensions.sh /docker-entrypoint-initdb.d/initdb-extensions.sh
