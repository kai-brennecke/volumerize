FROM debian:bookworm-20260803

LABEL maintainer="Kai Brennecke <229121123+kai-brennecke@users.noreply.github.com>"

ENV PIPX_HOME=/opt/pipx
ENV PIPX_BIN_DIR=/usr/local/bin
ENV PATH="/usr/local/bin:${PATH}"

ARG DOCKER_VERSION=28.5.2

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        pipx \
        tzdata \
        bash \
        curl \
        ca-certificates \
        gnupg \
        build-essential \
        intltool \
        lftp \
        librsync-dev \
        libffi-dev \
        libssl-dev \
        openssl \
        par2 \
        python3-dev \
        python3-lxml \
        python3-pip \
        python3-venv \
        python3 \
        rclone \
        rsync \
        rdiff \
        tzdata \
    # Install Docker CLI
    && curl -fsSL "https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz" -o /tmp/docker.tgz \
    && export DOCKER_SHA=6ce6d9dd99413e77c992d5b9e0a898dd1ed63ef9 \
    && echo 'Calculated checksum: '$(sha1sum /tmp/docker.tgz) \
    && echo "$DOCKER_SHA  /tmp/docker.tgz" | sha1sum -c - \
	&&  tar -xzvf /tmp/docker.tgz -C /tmp \
	&&  cp /tmp/docker/docker /usr/local/bin/ \
    # Cleanup
    && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/* \
    && pipx install duplicity \
    && mkdir -p /etc/volumerize /volumerize-cache /opt/volumerize

# Latest releases available at https://github.com/aptible/supercronic/releases
ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.2.46/supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=5bcefed628e32adc08e32634db2d10e9230dbca0 \
    SUPERCRONIC=supercronic-linux-amd64

RUN curl -fsSLO "$SUPERCRONIC_URL" \
 && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
 && chmod +x "$SUPERCRONIC" \
 && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
 && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic

ENV VOLUMERIZE_HOME=/etc/volumerize \
    VOLUMERIZE_CACHE=/volumerize-cache \
    VOLUMERIZE_SCRIPT_DIR=/opt/volumerize \
    PATH=$PATH:/etc/volumerize \
    GPG_TTY=/dev/console

USER root
WORKDIR /etc/volumerize
VOLUME ["/volumerize-cache"]
COPY imagescripts/ /opt/volumerize/
COPY scripts/ /etc/volumerize/
COPY preexecute/ /preexecute
COPY postexecute/ /postexecute
ENTRYPOINT ["bash", "/opt/volumerize/docker-entrypoint.sh"]
CMD ["volumerize"]
