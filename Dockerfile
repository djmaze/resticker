#
# Builder image
#
FROM golang:1.15-alpine3.12 AS builder

ARG RESTIC_VERSION=0.11.0
ARG RESTIC_SHA256=73cf434ec93e2e20aa3d593dc5eacb221a71d5ae0943ca59bdffedeaf238a9c6
ARG GO_CRON_VERSION=0.0.4
ARG GO_CRON_SHA256=6c8ac52637150e9c7ee88f43e29e158e96470a3aaa3fcf47fd33771a8a76d959
ARG RCLONE_VERSION=1.53.3
ARG RCLONE_SHA256=f1e213bc6fb7c46f9a4cc8604ae0856718434bdafe07fa3ce449ae9a510a5763

RUN apk add --no-cache binutils-gold curl gcc musl-dev

RUN curl -sL -o go-cron.tar.gz https://github.com/djmaze/go-cron/archive/v${GO_CRON_VERSION}.tar.gz \
 && echo "${GO_CRON_SHA256}  go-cron.tar.gz" | sha256sum -c - \
 && tar xzf go-cron.tar.gz \
 && cd go-cron-${GO_CRON_VERSION} \
 && go build \
 && mv go-cron /usr/local/bin/go-cron \
 && cd .. \
 && rm go-cron.tar.gz go-cron-${GO_CRON_VERSION} -fR

RUN curl -sL -o rclone.tar.gz https://github.com/rclone/rclone/releases/download/v${RCLONE_VERSION}/rclone-v${RCLONE_VERSION}.tar.gz \
 && echo "${RCLONE_SHA256}  rclone.tar.gz" | sha256sum -c - \
 && tar xzf rclone.tar.gz \
 && cd rclone-v${RCLONE_VERSION} \
 && CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' . \
 && mv rclone /usr/local/bin/rclone \
 && cd .. \
 && rm rclone.tar.gz rclone-v${RCLONE_VERSION} -fR

RUN curl -sL -o restic.tar.gz https://github.com/restic/restic/releases/download/v${RESTIC_VERSION}/restic-${RESTIC_VERSION}.tar.gz \
 && echo "${RESTIC_SHA256}  restic.tar.gz" | sha256sum -c - \
 && tar xzf restic.tar.gz \
 && cd restic-${RESTIC_VERSION} \
 && go run build.go \
 && mv restic /usr/local/bin/restic \
 && cd .. \
 && rm restic.tar.gz restic-${RESTIC_VERSION} -fR

#
# Final image
#
FROM alpine:3.12

RUN apk add --update --no-cache ca-certificates fuse nfs-utils openssh tzdata bash curl docker-cli

ENV RESTIC_REPOSITORY /mnt/restic

COPY --from=builder /usr/local/bin/* /usr/local/bin/
COPY backup prune /usr/local/bin/
COPY entrypoint /

ENTRYPOINT ["/entrypoint"]
