FROM python:3.13.1-alpine3.19

RUN apk add --no-cache coreutils

COPY entrypoint.py /entrypoint.py
ENTRYPOINT ["/entrypoint.py"]