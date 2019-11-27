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

### Restoring

In order to restore files on a host where the container is already running via Docker Compose, you can use `exec`:

```bash
# Find the latest snapshot for the current host (note the ID)
docker-compose exec app snapshots -H <HOSTNAME>
# Restore the given file on the host
docker-compose exec app restore --include /path/to/file <ID>
```

When using Swarm mode, you need to manually SSH into the host and run `docker exec -it ..` accordingly.

### Advanced usage

You can use the same config to run any restic command with the given configuration.

When using the Docker Compose setup:

    docker-compose run --rm app <RESTIC ARGS>

E.g.

    docker-compose run --rm app snapshots

## Configuration options

* `BACKUP_CRON` - A cron expression for when to run the backup. E.g. `0 30 3 * * *` in order to run every night at 3:30 am. See [the go-cron documentation](https://godoc.org/github.com/robfig/cron) for details on the expression format
* `RESTIC_REPOSITORY` - location of the restic repository. You can use [any target supported by restic](https://restic.readthedocs.io/en/stable/030_preparing_a_new_repo.html). Default `/mnt/restic`
* `RESTIC_BACKUP_SOURCES` - source directory to backup. Make sure to mount this into the container as a volume (see the example configs). Default `/data`
* `RESTIC_PASSWORD` - password for the restic repository. Will also be used to initialize the repository if it is not yet initialized
* `RESTIC_BACKUP_TAGS` - Optional. Tags to set on each snapshot, separated by commas. E.g. `swarm,docker-volumes`
* `RESTIC_FORGET_ARGS` - Optional. If specified `restic forget` is run with the given arguments after each backup. E.g. `--prune --keep-last 14 --keep-daily 1`
* (Additional variables as needed for the chosen backup target. E.g. `B2_ACCOUNT_ID` and `B2_ACCOUNT_KEY` for Backblaze B2.)
* `TZ` - Optional. Set your timezone for the correct cron execution time.

### Using `rclone` repository type

In order to use `rclone` repository type, you need to prepare a `rclone.conf` file and mount it inside the container to `/root/.config/rclone/rclone.conf`.

## Execute commands prior to backup

It's possible to optionally execute commands (like database dumps, or stopping a running container to avoid inconsistent backup data) before the actual backup starts. If you want to execute `docker` commands on the host, mount the Docker socket to the container. To do that add the following volume to the compose or swarm configuration:

    - /var/run/docker.sock:/var/run/docker.sock

You can add one or multiple commands by specifying the following environment variable:

    PRE_COMMANDS: |-
                docker exec nextcloud-postgres pg_dumpall -U nextcloud -f /data/nextcloud.sql
                docker exec other-postgres pg_dumpall -U other -f /data/other.sql
                docker stop my_container

The commands specified in `PRE_COMMANDS` are executed one by one.

## Execute commands after backup

It's possible to optionally execute commands (like restarting a temporarily stopped container, send a mail...) once the actual backup has finished. Like for pre-backup commands, if you want to execute `docker` commands on the host, mount the Docker socket to the container.

You can add one or multiple commands by specifying the following environment variables:

    POST_COMMANDS_SUCCESS: |-
		/my/scripts/mail-success.sh

    POST_COMMANDS_FAILURE: |-
		/my/scripts/mail-failure.sh

    POST_COMMANDS_EXIT: |-
		docker start my_container

The commands specified are executed one by one.

* `POST_COMMANDS_SUCCESS` commands will be executed after a successful backup run.
* `POST_COMMANDS_FAILURE` commande will be executed after a failed backup run.
* `POST_COMMANDS_EXIT` will always be executed, after both successful or failed backup runs.

## Build instructions

Use the supplied [Makefile](Makefile) in order to build your own image:

    make image IMAGE=myuser/restic

You can also push images and build on a different architecture:

    make image IMAGE=myuser/restic ARCH=arm

For more targets, see the Makefile.

## Credits

[restic-backup-docker](https://github.com/Lobaro/restic-backup-docker) was used as a starting point. Thanks!
