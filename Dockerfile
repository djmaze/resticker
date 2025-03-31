#
# Builder image
#
FROM golang:1.21.5-alpine3.17 AS builder

ARG RESTIC_VERSION=0.18.0
ARG RESTIC_SHA256_AMD64=98f6dd8bf5b59058d04bfd8dab58e196cc2a680666ccee90275a3b722374438e
ARG RESTIC_SHA256_ARM=a202b58cb23c7b40e2562d9b0804492f77278bd0d0bf043f5e02951f89c83eb5
ARG RESTIC_SHA256_ARM64=ce18179c25dc5f2e33e3c233ba1e580f9de1a4566d2977e8d9600210363ec209

ARG RCLONE_VERSION=1.68.2
# These are the checksums for the zip files
ARG RCLONE_SHA256_AMD64=0e6fa18051e67fc600d803a2dcb10ddedb092247fc6eee61be97f64ec080a13c
ARG RCLONE_SHA256_ARM=a244cc4d75abf10af576c0a4161fbe454c129658358ba2e6e27c9e97639ff0fb
ARG RCLONE_SHA256_ARM64=c6e9d4cf9c88b279f6ad80cd5675daebc068e404890fa7e191412c1bc7a4ac5f

ARG GO_CRON_VERSION=0.0.4
ARG GO_CRON_SHA256=6c8ac52637150e9c7ee88f43e29e158e96470a3aaa3fcf47fd33771a8a76d959

RUN apk add --no-cache curl

RUN case "$(uname -m)" in \
  x86_64 ) \
    echo amd64 >/tmp/ARCH \
    ;; \
  armv7l) \
    echo arm >/tmp/ARCH \
    ;; \
  aarch64) \
    echo arm64 >/tmp/ARCH \
    ;; \
  esac

RUN case "$(cat /tmp/ARCH)" in \
  amd64 ) \
    echo "${RESTIC_SHA256_AMD64}" > RESTIC_SHA256 ; \
    echo "${RCLONE_SHA256_AMD64}" > RCLONE_SHA256 ; \
    ;; \
  arm ) \
    echo "${RESTIC_SHA256_ARM}" > RESTIC_SHA256 ; \
    echo "${RCLONE_SHA256_ARM}" > RCLONE_SHA256 ; \
    ;; \
  arm64 ) \
    echo "${RESTIC_SHA256_ARM64}" > RESTIC_SHA256 ; \
    echo "${RCLONE_SHA256_ARM64}" > RCLONE_SHA256 ; \
    ;; \
  *) \
    echo "unknown architecture '$(cat /tmp/ARCH)'" ; \
    exit 1 ; \
    ;; \
 esac

RUN curl -sL --fail -o restic.bz2 https://github.com/restic/restic/releases/download/v${RESTIC_VERSION}/restic_${RESTIC_VERSION}_linux_$(cat /tmp/ARCH).bz2 \
 && echo "$(cat RESTIC_SHA256)  restic.bz2" | sha256sum -c - \
 && bzip2 -d -v restic.bz2 \
 && mv restic /usr/local/bin/restic \
 && chmod +x /usr/local/bin/restic

 RUN curl -sL --fail -o rclone.zip https://github.com/rclone/rclone/releases/download/v${RCLONE_VERSION}/rclone-v${RCLONE_VERSION}-linux-$(cat /tmp/ARCH).zip \
 && echo "$(cat RCLONE_SHA256)  rclone.zip" | sha256sum -c - \
 && unzip rclone.zip \
 && mv rclone-v${RCLONE_VERSION}-linux-$(cat /tmp/ARCH)/rclone /usr/local/bin/rclone \
 && chmod +x /usr/local/bin/rclone \
 && rm -rf rclone-v${RCLONE_VERSION}-linux-$(cat /tmp/ARCH) \
 && rm rclone.zip

RUN curl -sL -o go-cron.tar.gz https://github.com/djmaze/go-cron/archive/v${GO_CRON_VERSION}.tar.gz \
 && echo "${GO_CRON_SHA256}  go-cron.tar.gz" | sha256sum -c - \
 && tar xzf go-cron.tar.gz \
 && cd go-cron-${GO_CRON_VERSION} \
 && go build \
 && mv go-cron /usr/local/bin/go-cron \
 && cd .. \
 && rm go-cron.tar.gz go-cron-${GO_CRON_VERSION} -fR


#
# Final image
#
FROM alpine:3.21

RUN apk add --update --no-cache ca-certificates fuse nfs-utils openssh tzdata bash curl docker-cli gzip tini

ENV RESTIC_REPOSITORY /mnt/restic

COPY --from=builder /usr/local/bin/* /usr/local/bin/
COPY backup prune check /usr/local/bin/
COPY entrypoint /

ENTRYPOINT ["/sbin/tini", "--", "/entrypoint"]
