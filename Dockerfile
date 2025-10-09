FROM alpine:3.22.2

LABEL maintainer="Kai Brennecke <229121123+kai-brennecke@users.noreply.github.com>"

ARG JOBBER_VERSION=1.4.4

RUN apk add --no-cache \
      duplicity \
      apprise \
      docker-cli \
      rclone \
      bash \
      tini \
      su-exec \
      gzip \
      gettext \
      tar \
      wget \
      curl \
      openssh \
      openssl \
      gnupg \
      rsync && \
    mkdir -p /etc/volumerize /volumerize-cache /opt/volumerize /var/jobber/0 && \
    # Install Jobber
    wget --directory-prefix=/tmp https://github.com/dshearer/jobber/releases/download/v${JOBBER_VERSION}/jobber-${JOBBER_VERSION}-r0.apk && \
    apk add --allow-untrusted --no-scripts /tmp/jobber-${JOBBER_VERSION}-r0.apk && \
    # Cleanup
    apk del \
      curl \
      wget

ENV VOLUMERIZE_HOME=/etc/volumerize \
    VOLUMERIZE_CACHE=/volumerize-cache \
    VOLUMERIZE_SCRIPT_DIR=/opt/volumerize \
    PATH=$PATH:/etc/volumerize \
    GOOGLE_DRIVE_SETTINGS=/credentials/cred.file \
    GOOGLE_DRIVE_CREDENTIAL_FILE=/credentials/googledrive.cred \
    GPG_TTY=/dev/console

USER root
WORKDIR /etc/volumerize
VOLUME ["/volumerize-cache"]
COPY imagescripts/ /opt/volumerize/
COPY scripts/ /etc/volumerize/
COPY postexecute/ /postexecute
ENTRYPOINT ["/sbin/tini","--","/opt/volumerize/docker-entrypoint.sh"]
CMD ["volumerize"]
