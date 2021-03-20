# Change Log

## [1.4.0](https://github.com/djmaze/resticker/tree/1.4.0) (2021-02-25)
[Full Changelog](https://github.com/djmaze/resticker/compare/1.3.0...1.4.0)

**Implemented enhancements:**

- Update restic to 0.12.0 and rclone to 1.54.0 [\#73](https://github.com/djmaze/resticker/pull/73) ([jlelse](https://github.com/jlelse))
- Build test images for branches & PRs [\#70](https://github.com/djmaze/resticker/pull/70) ([djmaze](https://github.com/djmaze))
- drone: build branches & pull requests as well \(but don't push them\) [\#69](https://github.com/djmaze/resticker/pull/69) ([djmaze](https://github.com/djmaze))
- Added hint for seconds option of customized go-cron [\#64](https://github.com/djmaze/resticker/pull/64) ([MartinEnders](https://github.com/MartinEnders))

**Fixed bugs:**

- Initialization failed with sftp backend [\#72](https://github.com/djmaze/resticker/issues/72)
- Use correct arm docker plugin for arm builds [\#71](https://github.com/djmaze/resticker/pull/71) ([djmaze](https://github.com/djmaze))
- Fix arm rclone build [\#68](https://github.com/djmaze/resticker/pull/68) ([escoand](https://github.com/escoand))
- Build rclone in Dockerfile [\#67](https://github.com/djmaze/resticker/pull/67) ([escoand](https://github.com/escoand))

**Closed issues:**

- arm and arm64 compatibility [\#66](https://github.com/djmaze/resticker/issues/66)
- Issues when using a SFTP repository [\#65](https://github.com/djmaze/resticker/issues/65)

## [1.3.0](https://github.com/djmaze/resticker/tree/1.3.0) (2020-11-19)
[Full Changelog](https://github.com/djmaze/resticker/compare/1.2.0...1.3.0)

**Implemented enhancements:**

- Restic Prune Args [\#43](https://github.com/djmaze/resticker/issues/43)
- Halt if initialization fails [\#37](https://github.com/djmaze/resticker/issues/37)
- Restic v0.11.0 [\#58](https://github.com/djmaze/resticker/issues/58)
- Replace repository checking logic [\#47](https://github.com/djmaze/resticker/pull/47) ([ThomDietrich](https://github.com/ThomDietrich))
- Add RESTIC\_PRUNE\_ARGS [\#46](https://github.com/djmaze/resticker/pull/46) ([PhasecoreX](https://github.com/PhasecoreX))
- Check for mutual exclusivity of cron expressions [\#41](https://github.com/djmaze/resticker/pull/41) ([ThomDietrich](https://github.com/ThomDietrich))
- Add better docker-compose example [\#40](https://github.com/djmaze/resticker/pull/40) ([ThomDietrich](https://github.com/ThomDietrich))
- Add RUN\_ON\_STARTUP for convenience and testing [\#39](https://github.com/djmaze/resticker/pull/39) ([ThomDietrich](https://github.com/ThomDietrich))
- Updated restic and rclone versions + hashes [\#59](https://github.com/djmaze/resticker/pull/59) ([LucaTNT](https://github.com/LucaTNT))
- Update go, rclone and restic versions [\#52](https://github.com/djmaze/resticker/pull/52) ([jlelse](https://github.com/jlelse))

**Fixed bugs:**

- Fix unbound variable [\#45](https://github.com/djmaze/resticker/pull/45) ([PhasecoreX](https://github.com/PhasecoreX))
- Add missing `fi` [\#44](https://github.com/djmaze/resticker/pull/44) ([PhasecoreX](https://github.com/PhasecoreX))

**Closed issues:**

- Resticker Loop [\#60](https://github.com/djmaze/resticker/issues/60)
- Wrong image on docker hub [\#57](https://github.com/djmaze/resticker/issues/57)
- Best way to backup docker volumes [\#56](https://github.com/djmaze/resticker/issues/56)
- Restic seems to not exclude my dir [\#54](https://github.com/djmaze/resticker/issues/54)
- Sending mail on post backup [\#53](https://github.com/djmaze/resticker/issues/53)

## [1.2.0](https://github.com/djmaze/resticker/tree/1.2.0) (2020-06-07)
[Full Changelog](https://github.com/djmaze/resticker/compare/1.1.1...1.2.0)

**Implemented enhancements:**

- Allow custom backup arguments using RESTIC\_BACKUP\_ARGS [\#38](https://github.com/djmaze/resticker/pull/38) ([djmaze](https://github.com/djmaze))
- Add prune support using a separate service and cron schedule [\#36](https://github.com/djmaze/resticker/pull/36) ([djmaze](https://github.com/djmaze))
- update rclone to 1.50.2 [\#25](https://github.com/djmaze/resticker/pull/25) ([panakour](https://github.com/panakour))

**Fixed bugs:**

- PRE\_COMMANDS: Invalid interpolation format for "environment" option in service [\#31](https://github.com/djmaze/resticker/issues/31)

**Closed issues:**

- To check whether Cron job ran? PRE, POST, EXIT are executed? [\#34](https://github.com/djmaze/resticker/issues/34)
- Logs for PRE, EXIT & SUCCESS commands [\#32](https://github.com/djmaze/resticker/issues/32)
- Error when using restic with rclone [\#30](https://github.com/djmaze/resticker/issues/30)
- Restore not working [\#28](https://github.com/djmaze/resticker/issues/28)
- latest-tag does not represent the latest release [\#24](https://github.com/djmaze/resticker/issues/24)
- high speed restore [\#23](https://github.com/djmaze/resticker/issues/23)
- Allow prune to be on a different schedule [\#22](https://github.com/djmaze/resticker/issues/22)
- Pre- and post-backup commands won't execute [\#20](https://github.com/djmaze/resticker/issues/20)
- Question: Is it possible to add backup arguments to cron jobs? [\#19](https://github.com/djmaze/resticker/issues/19)

## [1.1.1](https://github.com/djmaze/resticker/tree/1.1.1) (2019-11-27)
[Full Changelog](https://github.com/djmaze/resticker/compare/1.1.0...1.1.1)

**Implemented enhancements:**

- Restic 0.9.6 release [\#17](https://github.com/djmaze/resticker/issues/17)
- doco and samples for restore [\#15](https://github.com/djmaze/resticker/issues/15)

**Fixed bugs:**

- Use proper sh semantics for the entrypoint [\#18](https://github.com/djmaze/resticker/pull/18) ([schue](https://github.com/schue))

## [1.1.0](https://github.com/djmaze/resticker/tree/1.1.0) (2019-10-30)
[Full Changelog](https://github.com/djmaze/resticker/compare/1.0.1...1.1.0)

**Implemented enhancements:**

- Feature : Add curl to final image \(for Slack webhook\) [\#14](https://github.com/djmaze/resticker/pull/14) ([y3lousso](https://github.com/y3lousso))

## [1.0.1](https://github.com/djmaze/resticker/tree/1.0.1) (2019-10-26)
[Full Changelog](https://github.com/djmaze/resticker/compare/1.0.0...1.0.1)

**Implemented enhancements:**

- Update go-cron [\#12](https://github.com/djmaze/resticker/pull/12) ([djmaze](https://github.com/djmaze))

**Fixed bugs:**

- Replace go-cron with crond from the already included BusyBox [\#11](https://github.com/djmaze/resticker/issues/11)

**Closed issues:**

- Release notes for 1.0.1 [\#13](https://github.com/djmaze/resticker/issues/13)

## [1.0.0](https://github.com/djmaze/resticker/tree/1.0.0) (2019-10-24)
[Full Changelog](https://github.com/djmaze/resticker/compare/0.9.5...1.0.0)

**Implemented enhancements:**

- Post commands [\#8](https://github.com/djmaze/resticker/pull/8) ([nikkoura](https://github.com/nikkoura))
- Support `rclone` [\#6](https://github.com/djmaze/resticker/pull/6) ([maximbaz](https://github.com/maximbaz))
- Fix various things & add support for precommands [\#3](https://github.com/djmaze/resticker/pull/3) ([jlelse](https://github.com/jlelse))

**Fixed bugs:**

- "syntax error: unexpected redirection" when using PRE\_COMMANDS [\#4](https://github.com/djmaze/resticker/issues/4)
- Fix PRE\_COMMANDS error \('unexpected redirection'\) [\#7](https://github.com/djmaze/resticker/pull/7) ([nikkoura](https://github.com/nikkoura))

**Closed issues:**

- NextCloud in and out of maintenance mode [\#9](https://github.com/djmaze/resticker/issues/9)
- Release notes for 1.0.0 [\#10](https://github.com/djmaze/resticker/issues/10)

## [0.9.5](https://github.com/djmaze/resticker/tree/0.9.5) (2019-07-21)
[Full Changelog](https://github.com/djmaze/resticker/compare/0.9.3...0.9.5)

**Implemented enhancements:**

- Update alpine to 3.9 [\#2](https://github.com/djmaze/resticker/pull/2) ([jlelse](https://github.com/jlelse))

## [0.9.3](https://github.com/djmaze/resticker/tree/0.9.3) (2019-05-22)


\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*