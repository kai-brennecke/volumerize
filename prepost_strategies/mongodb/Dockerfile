ARG BASE_IMAGE=

FROM ${BASE_IMAGE}

RUN apt-get update \
 && install -d -m 0755 /etc/apt/keyrings \
 && curl -fsSL https://pgp.mongodb.com/server-8.0.asc \
    | gpg --dearmor -o /etc/apt/keyrings/mongodb-server-8.0.gpg \
 && echo "deb [ arch=amd64,arm64 signed-by=/etc/apt/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/debian bookworm/mongodb-org/8.0 main" \
    > /etc/apt/sources.list.d/mongodb-org-8.0.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends mongodb-mongosh mongodb-database-tools \
 && rm -rf /var/lib/apt/lists/*

COPY postexecute /postexecute
COPY preexecute /preexecute
COPY utils /opt/volumerize
