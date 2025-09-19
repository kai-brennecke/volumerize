FROM python:3.12.2-alpine3.19

RUN apk add --no-cache coreutils

COPY entrypoint.py /entrypoint.py
ENTRYPOINT ["/entrypoint.py"]