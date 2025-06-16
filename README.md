# Resticker

[![Docker Pulls](https://img.shields.io/docker/pulls/mazzolino/restic.svg)](https://hub.docker.com/r/mazzolino/restic/)
[![Build status](https://ci.strahlungsfrei.de/api/badges/djmaze/resticker/status.svg)](https://ci.strahlungsfrei.de/djmaze/resticker)

Run automatic [restic](https://restic.github.io/) backups via a Docker container.

## Features

- run scheduled backups
- backup to any (local or remote) target supported by restic
- support for tags, exclude definitions, and all other optional restic options
- automatic forgetting of old backups
- prune backups on a schedule
- remove a stale repository lock
- can be used as a (global) Docker swarm service in order to backup every cluster node
- multi-arch: the image `mazzolino/restic` runs on `amd64` as well as `armv7` (for now)

## Usage

Use the supplied example configs to set up a backup schedule.

The Compose files contain a _backup_, a _prune_ and a _check_ service which can be scheduled independently of each other. Feel free to remove the _prune_ and/or _check_ service if you want to run the prune jobs manually.

If you have multiple services configured for the same repository, make sure, that at most one service is allowed to initialize the repository or a newly created repository might become corrupt.

To do so, add a `SKIP_INIT=true` environment variable to the other services.

### With Docker Compose

Adjust the supplied [docker-compose.yml](docker-compose.example.yml) as needed. Then run:

    docker-compose up -d

### With Docker Swarm mode

Adjust the supplied [docker-swarm.yml](docker-swarm.example.yml) as needed. Then deploy it as a stack:

    docker stack deploy -f docker-swarm.yml backup

### Versioning scheme

This project uses [semantic versioning](https://semver.org/). The docker images (under [`mazzolino/restic`](https://hub.docker.com/r/mazzolino/restic/)) are tagged accordingly:

- `latest` - built from the latest `master` commit
- `1.6.0` - one tag for each patch release
- `1.6`, `1` - points to the latest patch release below that minor / major version (in this case `1.6.0`)

It is recommended to pin to the latest patch version (e.g. `1.6.0`) and update the version manually (or using an automated process like [Renovate](https://docs.renovatebot.com/)).

Look at the [CHANGELOG](CHANGELOG.md) or Github releases to find the latest version.

Also, an image will be generated for each pull request. The tags are labeled `pr-xxx` where `xxx` is the id of the pull request.

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

When given the `unlock` command, the repository check will be skipped (because it will fail on a locked repository either way).

## Configuration options

_Note: `BACKUP_CRON`, `PRUNE_CRON` and `CHECK_CRON` are mutually exclusive._

- `BACKUP_CRON` - A cron expression for when to run the backup. E.g. `0 30 3 * * *` in order to run every night at 3:30 am. See [the go-cron documentation](https://godoc.org/github.com/robfig/cron) for details on the expression format (a [customized go-cron](https://github.com/djmaze/go-cron/) is used which allows the definition of seconds as first parameter).
- `PRUNE_CRON` - A cron expression for when to run the prune job. E.g. `0 0 4 * * *` in order to run every night at 4:00 am. See [the go-cron documentation](https://godoc.org/github.com/robfig/cron) for details on the expression format (a [customized go-cron](https://github.com/djmaze/go-cron/) is used which allows the definition of seconds as first parameter).
- `CHECK_CRON` - A cron expression for when to run the check job. E.g. `0 15 5 * * *` in order to run every night at 5:15 am. See [the go-cron documentation](https://godoc.org/github.com/robfig/cron) for details on the expression format (a [customized go-cron](https://github.com/djmaze/go-cron/) is used which allows the definition of seconds as first parameter).
- `RUN_ON_STARTUP` - Set to `"true"` to execute a backup or prune job right on startup, in addition to the given cron expression. Disabled by default
- `RESTIC_REPOSITORY` - Location of the restic repository. You can use [any target supported by restic](https://restic.readthedocs.io/en/stable/030_preparing_a_new_repo.html). Default `/mnt/restic`
- `RESTIC_BACKUP_SOURCES` - Source directory to backup. Make sure to mount this into the container as a volume (see the example configs). Default `/data`
- `RESTIC_PASSWORD` - Password for the restic repository. Will also be used to initialize the repository if it is not yet initialized
- `RESTIC_BACKUP_ARGS` - If specified `restic backup` is run with the given arguments, e.g. for tags, exclude definitions, or verbose logging: `--tag docker-volumes --exclude-file exclude.txt --verbose`. Make sure **not** to use the `=` form of assignment, but use spaces between parameter and value, and escape spaces using backslash (`\`). See the [restic backup documentation](https://restic.readthedocs.io/en/stable/040_backup.html) for available options and [docker-compose.example.yml](docker-compose.example.yml) for an adjusted example.
- `RESTIC_BACKUP_TAGS` - _Deprecated_. Tags to set for each snapshot, separated by commas. This option will soon be removed. Please use `RESTIC_BACKUP_ARGS` to define tags.
- `RESTIC_FORGET_ARGS` - If specified `restic forget` is run with the given arguments after each backup or before every prune, e.g. `--prune --keep-last 14 --keep-daily 1`. See the [restic forget documentation](https://restic.readthedocs.io/en/stable/060_forget.html) for available options
- `RESTIC_PRUNE_ARGS` - If specified `restic prune` is run with the given arguments, e.g. for B2 concurrent connection settings and verbose logging: `-o b2.connections=10 --verbose`.
- `RESTIC_CHECK_ARGS` - If specified `restic check` is run with the given arguments, e.g. `--read-data-subset=10%` to check a randomly choosen subset (10%) of the repository pack files. Without option, only the structure of the repository is checked. The option `--read-data-subset` will also check data, at the cost of transfering them from the repository.; e.g. for B2 concurrent connection settings and verbose logging: `-o b2.connections=10 --verbose`.
- (Additional variables as needed for the chosen backup target. E.g. `B2_ACCOUNT_ID` and `B2_ACCOUNT_KEY` for Backblaze B2. See official restic documentation about [supported environment variables](https://restic.readthedocs.io/en/stable/040_backup.html#environment-variables).)
- `TZ` - Optional. Set your timezone for the correct cron execution time.
- `SKIP_INIT` - Skip initialization of the restic repository, even if it can not be accessed.
- `SKIP_INIT_CHECK`- Do not fail, if initialization of the restic repository fails for whatever reason.

### Using the `rclone` repository type

In order to use the `rclone` repository type, you need to prepare an `rclone.conf` file and use it as a _Docker secret_:

Example for Docker Compose/Swarm:

```yaml
services:
  backup:
    # ...
    secrets:
      - rclone.conf

secrets:
  rclone.conf:
    file: ./rclone.conf
```

#### Note for backends with token-based access

If you are using rclone backends which make use of oauth refresh tokens (B2, OneDrive, Google) the `rclone.conf` needs to be writable inside the container. That means you need to directly mount a *directory* (r/w) which contains the config file to the final config directory inside the container.

Example for Docker Compose:

```yaml
services:
  backup:
    # ...
    volumes:
      - ./rclone:/root/.config/rclone
```

Where `./rclone` should be a local directory which contains your `rclone.conf`.

### Using `sftp` repository type

In order to use the `sftp` repository type, you need to prepare a `.ssh` directory with your private ssh key(s), `known_hosts` (and an optional `config` file) and mount it inside the container at `/run/secrets/.ssh`.

Example for Docker Compose:

```yaml
services:
  backup:
    # ...
    volumes:
      - ./.ssh:/run/secrets/.ssh:ro
```

## Using `restic mount`

If you want to mount your backup repository *inside the container* using `restic mount`, you need to [give the container SYS_ADMIN privilege and allow the fuse device](https://stackoverflow.com/a/49021109).

Example for Docker Compose:

```yaml
services:
  backup:
    # ...
    cap_add:
      - SYS_ADMIN
    devices:
      - /dev/fuse
```

Also the fuse kernel module should be loaded (`modprobe fuse`).

## Execute commands prior to backup

It's possible to optionally execute commands (like database dumps, or stopping a running container to avoid inconsistent backup data) before the actual backup starts. If you want to execute `docker` commands on the host, mount the Docker socket to the container. To do that add the following volume to the compose or swarm configuration:

```yaml
  - /var/run/docker.sock:/var/run/docker.sock:ro
```

You can add one or multiple commands by specifying the following environment variable:

```yaml
PRE_COMMANDS: |-
  docker exec nextcloud-postgres pg_dumpall -U nextcloud -f /data/nextcloud.sql
  docker exec other-postgres pg_dumpall -U other -f /data/other.sql
  docker stop my_container
```

The commands specified in `PRE_COMMANDS` are executed one by one.

## Execute commands after backup

It's possible to optionally execute commands (like restarting a temporarily stopped container, send a mail...) once the actual backup has finished. Like for pre-backup commands, if you want to execute `docker` commands on the host, mount the Docker socket to the container.

You can add one or multiple commands by specifying the following environment variables:

```yaml
POST_COMMANDS_SUCCESS: |-
 	/my/scripts/mail-success.sh

POST_COMMANDS_FAILURE: |-
 	/my/scripts/mail-failure.sh

POST_COMMANDS_INCOMPLETE: |-
 	/my/scripts/mail-incomplete.sh

POST_COMMANDS_EXIT: |-
 	docker start my_container
```

The commands specified are executed one by one.

- `POST_COMMANDS_SUCCESS` commands will be executed after a fully successful backup run (i.e. all files could be read).
- `POST_COMMANDS_FAILURE` commands will be executed after a failed backup run.
- `POST_COMMANDS_INCOMPLETE` commands will be executed if the backup is incomplete (i.e. one or more files could not be read).
- `POST_COMMANDS_EXIT` will always be executed, after both successful or failed backup runs.

By default, when any file could not be backed up, the commands from `POST_COMMANDS_FAILURE` will be executed. When `SUCCESS_ON_INCOMPLETE_BACKUP` is set to `"true"`, the commands from `POST_COMMANDS_INCOMPLETE` will be executed instead. Unless those are not configured – then the commands from `POST_COMMANDS_SUCCESS` will be executed.

### Example: Stopping & starting other containers

To stop and start containers running on the host system before and after the backup, even if they are usually stopped and started using Docker Compose, set the following environment variables and mount the docker socket into the container as follows:

```yaml
services:
  backup:
    # ...
    environment:
      # ...
      PRE_COMMANDS: |-
        docker stop containername
      POST_COMMANDS_SUCCESS: |-
        docker start containername
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
```

### Example: Send notifications

The Resticker docker image does not contain any tools for sending notifications, apart from `curl`. You should thus connect a second container for that purpose. For example, this is how mail notifications can be sent using [apprise-microservice](https://github.com/djmaze/apprise-microservice):

```yaml
services:
  backup:
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

## Testing

There are automated tests for the scripts running in the container. You need to install [shellspec](https://github.com/shellspec/shellspec/) to run them.

The test suite can be executed by running the following in the resticker source directory:

```bash
shellspec
```

This will build the image, create a container and run the tests inside the container.

## Credits

[restic-backup-docker](https://github.com/Lobaro/restic-backup-docker) was used as a starting point. Thanks!
