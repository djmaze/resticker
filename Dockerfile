#
# Builder image
#
FROM golang:1.19.13-alpine3.18 AS builder

ARG RESTIC_VERSION=0.16.4
ARG RESTIC_SHA256_AMD64=3d4d43c169a9e28ea76303b1e8b810f0dcede7478555fdaa8959971ad499e324
ARG RESTIC_SHA256_ARM=c4677e4eaf38ceda97841c8cae883883e026751970b41bb1a3f5e0610e07a5b1
ARG RESTIC_SHA256_ARM64=9d2f44538ea0c6309426cb290d3a6b8b0b85de5de7f1496ff40c843b36bf8a8d

ARG RCLONE_VERSION=1.65.2
# These are the checksums for the zip files
ARG RCLONE_SHA256_AMD64=2155ea2c225272a6f78b2aa4547bb587c40b007586e73b41b31c59edba64f8fe
ARG RCLONE_SHA256_ARM=6be7a09e3e3bc55af0ee9f00ea17fafdd8a38541ef2de21b8e804729b41af298
ARG RCLONE_SHA256_ARM64=71938906831a2fbab00a0519cb8a1f6aaa31425d528df130e60ca371f0dd45ab

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
FROM alpine:3.18

RUN apk add --update --no-cache ca-certificates fuse nfs-utils openssh tzdata bash curl docker-cli gzip tini

ENV RESTIC_REPOSITORY /mnt/restic

COPY --from=builder /usr/local/bin/* /usr/local/bin/
COPY backup prune check /usr/local/bin/
COPY entrypoint /

ENTRYPOINT ["/sbin/tini", "--", "/entrypoint"]
