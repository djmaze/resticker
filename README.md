# Resticker

[![Docker Pulls](https://img.shields.io/docker/pulls/mazzolino/restic.svg)](https://hub.docker.com/r/mazzolino/restic/)
[![Build status](https://ci.strahlungsfrei.de/api/badges/djmaze/resticker/status.svg)](https://ci.strahlungsfrei.de/djmaze/resticker)

Run automatic [restic](https://restic.github.io/) backups via a Docker container.

## Features

* run scheduled backups
* backup to any (local or remote) target supported by restic
* add custom tags to backups
* automatic forgetting of old backups
* can be used as a (global) Docker swarm service in order to backup every cluster node
* multi-arch: the image `mazzolino/restic` runs on `amd64` as well as `armv7` (for now)

## Usage

Use the supplied example configs to set up a backup schedule.

### With Docker Compose

Adjust the supplied [docker-compose.yml](docker-compose.example.yml) as needed. Then run:

    docker-compose up -d

### With Docker Swarm mode

Adjust the supplied [docker-swarm.yml](docker-swarm.example.yml) as needed. Then deploy it as a stack:

    docker stack deploy -f docker-swarm.yml backup

### Advanced usage

You can use the same config to run any restic command with the given configuration.

When using the Docker Compose setup:

    docker-compose run --rm app <RESTIC ARGS>

E.g.

    docker-compose run --rm app snapshots

## Configuration options

* `BACKUP_CRON` - A cron expression for when to run the backup. E.g. `0 30 3 * * *` in order to run every night at 3:30 am. See [the go-cron documentation](https://godoc.org/github.com/robfig/cron) for details on the expression format
* `RESTIC_REPOSITORY` - location of the restic repository. You can use [any target supported by restic](https://restic.readthedocs.io/en/stable/manual.html#initialize-a-repository). Default `/mnt/restic`
* `RESTIC_BACKUP_SOURCES` - source directory to backup. Make sure to mount this into the container as a volume (see the example configs). Default `/data`
* `RESTIC_PASSWORD` - password for the restic repository. Will also be used to initialize the repository if it is not yet initialized
* `RESTIC_BACKUP_TAGS` - Optional. Tags to set on each snapshot, separated by commas. E.g. `swarm,docker-volumes`
* `RESTIC_FORGET_ARGS` - Optional. If specified `restic forget` is run with the given arguments after each backup. E.g. `--prune --keep-last 14 --keep-daily 1`
* (Additional variables as needed for the chosen backup target. E.g. `B2_ACCOUNT_ID` and `B2_ACCOUNT_KEY` for Backblaze B2.)

## Build instructions

Use the supplied [Makefile](Makefile) in order to build your own image:

    make image IMAGE=myuser/restic

You can also push images and build on a different architecture:

    make image IMAGE=myuser/restic ARCH=arm

For more targets, see the Makefile.

## Credits

[restic-backup-docker](https://github.com/Lobaro/restic-backup-docker) was used as a starting point. Thanks!
