#
# Builder image
#
FROM golang:1.21.5-alpine3.17 AS builder

ARG RESTIC_VERSION=0.17.0
ARG RESTIC_SHA256_AMD64=fec7ade9f12c30bd6323568dbb0f81a3f98a3c86acc8161590235c0f18194022
ARG RESTIC_SHA256_ARM=d0f33de8e813474ae320912f13a929d763aa012d38c706fb76a46d9c7212f7f5
ARG RESTIC_SHA256_ARM64=f9ad4d91c181da2968ccdecb5238bf872f824fe1e40253f3347c4025192f19c9

ARG RCLONE_VERSION=1.67.0
# These are the checksums for the zip files
ARG RCLONE_SHA256_AMD64=07c23d21a94d70113d949253478e13261c54d14d72023bb14d96a8da5f3e7722
ARG RCLONE_SHA256_ARM=02032f5eb062c4bd0631329f1d4b4841ae773dfa3b8c7f8fd60d35f256c86532
ARG RCLONE_SHA256_ARM64=2b44981a1a7d1f432c53c0f2f0b6bcdd410f6491c47dc55428fdac0b85c763f1

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
FROM alpine:3.20

RUN apk add --update --no-cache ca-certificates jq fuse nfs-utils openssh tzdata bash curl docker-cli gzip tini

ENV RESTIC_REPOSITORY /mnt/restic

COPY --from=builder /usr/local/bin/* /usr/local/bin/
COPY backup prune check notify /usr/local/bin/
COPY entrypoint /

ENTRYPOINT ["/sbin/tini", "--", "/entrypoint"]
