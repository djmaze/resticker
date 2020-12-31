# Resticker

[![Docker Pulls](https://img.shields.io/docker/pulls/mazzolino/restic.svg)](https://hub.docker.com/r/mazzolino/restic/)
[![Build status](https://ci.strahlungsfrei.de/api/badges/djmaze/resticker/status.svg)](https://ci.strahlungsfrei.de/djmaze/resticker)

Run automatic [restic](https://restic.github.io/) backups via a Docker container.

## Features

* run scheduled backups
* backup to any (local or remote) target supported by restic
* support for tags, exclude definitions, and all other optional restic options
* automatic forgetting of old backups
* prune backups on a schedule
* can be used as a (global) Docker swarm service in order to backup every cluster node
* multi-arch: the image `mazzolino/restic` runs on `amd64` as well as `armv7` (for now)

## Usage

Use the supplied example configs to set up a backup schedule.

The Compose files contain a *backup* and a *prune* service which can be scheduled independently of each other. Feel free to remove the *prune* service if you want to run the prune jobs manually.

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
docker-compose exec app restic snapshots -H <HOSTNAME>
# Restore the given file on the host
docker-compose exec app restic restore --include /path/to/file <ID>
```

When using Swarm mode, you need to manually SSH into the host and run `docker exec -it ..` accordingly.

### Advanced usage

You can use the same config to run any restic command with the given configuration.

When using the Docker Compose setup:

    docker-compose run --rm app <RESTIC ARGS>

E.g.

    docker-compose run --rm app snapshots

## Configuration options

*Note: `BACKUP_CRON` and `PRUNE_CRON` are mutually exclusive.*

* `BACKUP_CRON` - A cron expression for when to run the backup. E.g. `0 30 3 * *` in order to run every night at 3:30 am. See [the go-cron documentation](https://godoc.org/github.com/robfig/cron) for details on the expression format
* `PRUNE_CRON` - A cron expression for when to run the prune job. E.g. `0 0 4 * *` in order to run every night at 4:00 am. See [the go-cron documentation](https://godoc.org/github.com/robfig/cron) for details on the expression format
* `RUN_ON_STARTUP` - Set to `"true"` to execute a backup or prune job right on startup, in addition to the given cron expression. Disabled by default
* `RESTIC_REPOSITORY` - Location of the restic repository. You can use [any target supported by restic](https://restic.readthedocs.io/en/stable/030_preparing_a_new_repo.html). Default `/mnt/restic`
* `RESTIC_BACKUP_SOURCES` - Source directory to backup. Make sure to mount this into the container as a volume (see the example configs). Default `/data`
* `RESTIC_PASSWORD` - Password for the restic repository. Will also be used to initialize the repository if it is not yet initialized
* `RESTIC_BACKUP_ARGS` - If specified `restic backup` is run with the given arguments, e.g. for tags, exclude definitions, or verbose logging: `--tag docker-volumes --exclude-file='exclude.txt' --verbose`. See the [restic backup documentation](https://restic.readthedocs.io/en/stable/040_backup.html) for available options
* `RESTIC_BACKUP_TAGS` - *Deprecated*. Tags to set for each snapshot, separated by commas. This option will soon be removed. Please use `RESTIC_BACKUP_ARGS` to define tags.
* `RESTIC_FORGET_ARGS` - If specified `restic forget` is run with the given arguments after each backup, e.g. `--prune --keep-last 14 --keep-daily 1`. See the [restic forget documentation](https://restic.readthedocs.io/en/stable/060_forget.html) for available options
* `RESTIC_PRUNE_ARGS` - If specified `restic prune` is run with the given arguments, e.g. for B2 concurrent connection settings and verbose logging: `-o b2.connections=10 --verbose`.
* (Additional variables as needed for the chosen backup target. E.g. `B2_ACCOUNT_ID` and `B2_ACCOUNT_KEY` for Backblaze B2. See official restic documentation about [supported environment variables](https://restic.readthedocs.io/en/stable/040_backup.html#environment-variables).)
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

### Notification example

The Resticker docker image does not contain any tools for sending notifications, apart from `curl`. You should thus connect a second container for that purpose. For example, this is how mail notifications can be sent using [apprise-microservice](https://github.com/djmaze/apprise-microservice):

```yaml
services:              
  app:       
    image: mazzolino/restic:1.1
    environment:
      # ...
      POST_COMMANDS_FAILURE: |-
        curl -X POST --data "{\"title\": \"Backup failed\", \"body\": \"\"}" http://notify:5000
    networks:
      - notification

  notify:
    image: mazzolino/apprise-microservice:0.1
    environment:
      NOTIFICATION_URLS: mailto://...
    networks:
      - notification

networks:
  notification:
```

## Build instructions

Use the supplied [Makefile](Makefile) in order to build your own image:

    make image IMAGE=myuser/restic

You can also push images and build on a different architecture:

    make image IMAGE=myuser/restic ARCH=arm

For more targets, see the Makefile.

## Credits

[restic-backup-docker](https://github.com/Lobaro/restic-backup-docker) was used as a starting point. Thanks!
