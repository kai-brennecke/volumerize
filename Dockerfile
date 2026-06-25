FROM python:3.14.6

LABEL maintainer="Kai Brennecke <229121123+kai-brennecke@users.noreply.github.com>"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
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
        apprise \
        docker-cli \
        bash \
        tini \
        gzip \
        gettext \
        tar \
        wget \
        curl \
        gnupg \
        lftp \
        duplicity \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /etc/volumerize /volumerize-cache /opt/volumerize


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
ENTRYPOINT ["/sbin/tini","--","/opt/volumerize/docker-entrypoint.sh"]
CMD ["volumerize"]
