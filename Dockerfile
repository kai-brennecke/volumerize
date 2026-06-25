FROM debian:trixie-20260623

LABEL maintainer="Kai Brennecke <229121123+kai-brennecke@users.noreply.github.com>"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        lftp \
        openssl \
        par2 \
        rclone \
        rsync \
        rdiff \
        tzdata \
        docker-cli \
        bash \
        tini \
        gzip \
        gettext \
        tar \
        wget \
        curl \
        gnupg \
        duplicity \
    && rm -rf /var/lib/apt/lists/* \
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
COPY postexecute/ /postexecute
ENTRYPOINT ["/usr/bin/tini","--","/opt/volumerize/docker-entrypoint.sh"]
CMD ["volumerize"]
