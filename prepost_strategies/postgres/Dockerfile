ARG BASE_IMAGE=

FROM ${BASE_IMAGE}

RUN apt-get update \
 && apt-get install -y --no-install-recommends postgresql-client \
 && rm -rf /var/lib/apt/lists/*

COPY postexecute /postexecute
COPY preexecute /preexecute
COPY utils /opt/volumerize
