# Changelog

## [1.8.0](https://github.com/djmaze/resticker/tree/1.8.0) (2025-04-21)

[Full Changelog](https://github.com/djmaze/resticker/compare/1.7.2...1.8.0)

**Implemented enhancements:**

- Add example for restarting containers to the readme [\#231](https://github.com/djmaze/resticker/pull/231) ([djmaze](https://github.com/djmaze))
- Update restic and rclone [\#227](https://github.com/djmaze/resticker/pull/227) ([dodgex](https://github.com/dodgex))
- Skip backup if already running [\#225](https://github.com/djmaze/resticker/pull/225) ([jljl1337](https://github.com/jljl1337))
- Update restic, rclone, alpine to latest versions [\#223](https://github.com/djmaze/resticker/pull/223) ([thueske](https://github.com/thueske))
- Update restic to v0.17.0 [\#210](https://github.com/djmaze/resticker/pull/210) ([djmaze](https://github.com/djmaze))

**Fixed bugs:**

- Backup job container restarting constantly [\#190](https://github.com/djmaze/resticker/issues/190)
- Race condition when startung multiple containers and repo does not exist -\> repo corrupt [\#188](https://github.com/djmaze/resticker/issues/188)
- Prevent the container entrypoint script from exiting on any error [\#230](https://github.com/djmaze/resticker/pull/230) ([djmaze](https://github.com/djmaze))
- Improve error message when operating mode is not specified [\#202](https://github.com/djmaze/resticker/pull/202) ([djmaze](https://github.com/djmaze))
- allow escaping of multiple spaces [\#192](https://github.com/djmaze/resticker/pull/192) ([marzzzello](https://github.com/marzzzello))

**Closed issues:**

- Problems with Repo Locks on several systems [\#221](https://github.com/djmaze/resticker/issues/221)
- Not working with VPN : TLS handshake timeout [\#219](https://github.com/djmaze/resticker/issues/219)
- open: s3.getCredentials: no credentials found. Use `-o s3.unsafe-anonymous-auth=true` for anonymous authentication [\#218](https://github.com/djmaze/resticker/issues/218)
- Rclone Update for Rclone Bug [\#196](https://github.com/djmaze/resticker/issues/196)

**Merged pull requests:**

- Update thegeeklab/drone-docker-buildx Docker tag to v24 [\#213](https://github.com/djmaze/resticker/pull/213) ([renovate-djmaze[bot]](https://github.com/apps/renovate-djmaze))
- Update golang Docker tag to v1.21.5 [\#211](https://github.com/djmaze/resticker/pull/211) ([renovate-djmaze[bot]](https://github.com/apps/renovate-djmaze))
- Update alpine Docker tag to v3.20 [\#207](https://github.com/djmaze/resticker/pull/207) ([renovate-djmaze[bot]](https://github.com/apps/renovate-djmaze))
- Add renovate.json to automate Dockerfile dependency updates [\#204](https://github.com/djmaze/resticker/pull/204) ([cz3k](https://github.com/cz3k))
- Update restic in Dockerfile [\#198](https://github.com/djmaze/resticker/pull/198) ([cz3k](https://github.com/cz3k))
- Update Rclone in Dockerfile [\#197](https://github.com/djmaze/resticker/pull/197) ([zaunza](https://github.com/zaunza))

## [1.7.2](https://github.com/djmaze/resticker/tree/1.7.2) (2024-02-27)

[Full Changelog](https://github.com/djmaze/resticker/compare/1.7.1...1.7.2)

**Implemented enhancements:**

- Update restic to 0.16.3 [\#182](https://github.com/djmaze/resticker/pull/182) ([cz3k](https://github.com/cz3k))

**Fixed bugs:**

- .ssh files copied to wrong location [\#184](https://github.com/djmaze/resticker/issues/184)
- Fix documentation & example for excludes [\#187](https://github.com/djmaze/resticker/pull/187) ([djmaze](https://github.com/djmaze))

**Closed issues:**

- Plans for a new release? [\#179](https://github.com/djmaze/resticker/issues/179)

**Merged pull requests:**

- Fix copying contents of $ssh\_config\_path into /root/.ssh [\#185](https://github.com/djmaze/resticker/pull/185) ([nerdlich](https://github.com/nerdlich))

## [1.7.1](https://github.com/djmaze/resticker/tree/1.7.1) (2023-12-20)

[Full Changelog](https://github.com/djmaze/resticker/compare/1.7.0...1.7.1)

**Implemented enhancements:**

- Update Restic to v1.16.2, RClone to v1.64.2 [\#176](https://github.com/djmaze/resticker/pull/176) ([CoordSpace](https://github.com/CoordSpace))
- Update restic to 0.16.0 [\#175](https://github.com/djmaze/resticker/pull/175) ([cz3k](https://github.com/cz3k))

**Closed issues:**

- Feature Request: Support for docker secrets [\#177](https://github.com/djmaze/resticker/issues/177)
- restic version update 0.16.0 [\#172](https://github.com/djmaze/resticker/issues/172)
- Backup fails with large folder [\#166](https://github.com/djmaze/resticker/issues/166)
- Not able to restore [\#163](https://github.com/djmaze/resticker/issues/163)

## [1.7.0](https://github.com/djmaze/resticker/tree/1.7.0) (2023-02-27)

[Full Changelog](https://github.com/djmaze/resticker/compare/1.6.0...1.7.0)

**Implemented enhancements:**

- restic 0.15.1 is out [\#157](https://github.com/djmaze/resticker/issues/157)
- Update Restic to v0.15.1 [\#159](https://github.com/djmaze/resticker/pull/159) ([djmaze](https://github.com/djmaze))
- Upgrade restic to 0.15.0 + upgrade go and rclone [\#151](https://github.com/djmaze/resticker/pull/151) ([chmey](https://github.com/chmey))
- Update Restic \(v0.14.0\) [\#144](https://github.com/djmaze/resticker/pull/144) ([matt-laird](https://github.com/matt-laird))
- Update example docker compose so services restart on crash [\#141](https://github.com/djmaze/resticker/pull/141) ([tobiasmuehl](https://github.com/tobiasmuehl))

**Fixed bugs:**

- cron not firing [\#155](https://github.com/djmaze/resticker/issues/155)
- POST\_COMMAND\_FAILURE triggering if backup completes [\#133](https://github.com/djmaze/resticker/issues/133)
- Fix incomplete backup handling [\#139](https://github.com/djmaze/resticker/pull/139) ([djmaze](https://github.com/djmaze))

**Closed issues:**

- Errors backing up with Docker Swarm [\#153](https://github.com/djmaze/resticker/issues/153)
- Issue with restic backup sources  [\#150](https://github.com/djmaze/resticker/issues/150)
- Cannot restore backup \(when using Git Bash\) [\#146](https://github.com/djmaze/resticker/issues/146)
- Big memory usage [\#137](https://github.com/djmaze/resticker/issues/137)

**Merged pull requests:**

- Document the versioning scheme [\#160](https://github.com/djmaze/resticker/pull/160) ([djmaze](https://github.com/djmaze))
- Update example Swarm file [\#154](https://github.com/djmaze/resticker/pull/154) ([ericvoshall](https://github.com/ericvoshall))

## [1.6.0](https://github.com/djmaze/resticker/tree/1.6.0) (2022-04-20)

[Full Changelog](https://github.com/djmaze/resticker/compare/1.5.0...1.6.0)

**Implemented enhancements:**

- Run tests in drone \(dind\) [\#131](https://github.com/djmaze/resticker/pull/131) ([djmaze](https://github.com/djmaze))
- Update restic to v0.13.1 and rclone to v1.58.0 [\#130](https://github.com/djmaze/resticker/pull/130) ([djmaze](https://github.com/djmaze))
- Build images with buildx [\#121](https://github.com/djmaze/resticker/pull/121) ([djmaze](https://github.com/djmaze))
- Add incomplete backup hook [\#109](https://github.com/djmaze/resticker/pull/109) ([djmaze](https://github.com/djmaze))
- Add tests [\#108](https://github.com/djmaze/resticker/pull/108) ([djmaze](https://github.com/djmaze))

**Fixed bugs:**

- Zombie processes left [\#105](https://github.com/djmaze/resticker/issues/105)
- Fix backup sources with spaces [\#120](https://github.com/djmaze/resticker/pull/120) ([djmaze](https://github.com/djmaze))
- Fix \#105: No more zombies by using proper init [\#110](https://github.com/djmaze/resticker/pull/110) ([smainz](https://github.com/smainz))

**Closed issues:**

- restic 0.13.0 [\#128](https://github.com/djmaze/resticker/issues/128)
- Implement POST\_COMMAND\_INCOMPLETE? [\#107](https://github.com/djmaze/resticker/issues/107)

## [1.5.0](https://github.com/djmaze/resticker/tree/1.5.0) (2021-09-20)

[Full Changelog](https://github.com/djmaze/resticker/compare/1.4.0...1.5.0)

**Implemented enhancements:**

- Switch to using the provided binaries instead of building everything from source [\#84](https://github.com/djmaze/resticker/issues/84)
- Skip repository check when unlock command is given [\#102](https://github.com/djmaze/resticker/pull/102) ([djmaze](https://github.com/djmaze))
- copy whole /run/secrets/.ssh into container instead of only ordinary files [\#100](https://github.com/djmaze/resticker/pull/100) ([smainz](https://github.com/smainz))
- feat: gzip added and version updates [\#97](https://github.com/djmaze/resticker/pull/97) ([schewara](https://github.com/schewara))
- allow to run forget before pruning [\#93](https://github.com/djmaze/resticker/pull/93) ([schewara](https://github.com/schewara))
- Add restic check handling [\#90](https://github.com/djmaze/resticker/pull/90) ([skimpax](https://github.com/skimpax))
- Do not install unnecessary build tools [\#88](https://github.com/djmaze/resticker/pull/88) ([smainz](https://github.com/smainz))
- Enable ssh key auth [\#87](https://github.com/djmaze/resticker/pull/87) ([smainz](https://github.com/smainz))
- Switch to using the provided binaries instead of building everything from source  [\#86](https://github.com/djmaze/resticker/pull/86) ([smainz](https://github.com/smainz))
- Allow mounting rclone.conf readonly / as a secret [\#83](https://github.com/djmaze/resticker/pull/83) ([djmaze](https://github.com/djmaze))

**Fixed bugs:**

- Prune does not work when RESTIC\_FORGET\_ARGS is not set [\#99](https://github.com/djmaze/resticker/issues/99)
- Error when using restic with rclone [\#30](https://github.com/djmaze/resticker/issues/30)
- Allow running prune without forget \(args\) [\#101](https://github.com/djmaze/resticker/pull/101) ([djmaze](https://github.com/djmaze))
- Fix arm builds [\#98](https://github.com/djmaze/resticker/pull/98) ([djmaze](https://github.com/djmaze))
- README: Fix post commands typo [\#89](https://github.com/djmaze/resticker/pull/89) ([jacobbaungard](https://github.com/jacobbaungard))

**Closed issues:**

- Several hosts for only one repository [\#95](https://github.com/djmaze/resticker/issues/95)
- Ssh configuration is sometimes not properly copied [\#94](https://github.com/djmaze/resticker/issues/94)
- Many docker containers + volumes; only want to back up specifics [\#85](https://github.com/djmaze/resticker/issues/85)
- Issues when using a SFTP repository [\#65](https://github.com/djmaze/resticker/issues/65)

## [1.4.0](https://github.com/djmaze/resticker/tree/1.4.0) (2021-02-25)

[Full Changelog](https://github.com/djmaze/resticker/compare/1.3.0...1.4.0)

**Implemented enhancements:**

- Restic v0.11.0 [\#58](https://github.com/djmaze/resticker/issues/58)
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
- Updated restic and rclone versions + hashes [\#59](https://github.com/djmaze/resticker/pull/59) ([LucaTNT](https://github.com/LucaTNT))
- Update go, rclone and restic versions [\#52](https://github.com/djmaze/resticker/pull/52) ([jlelse](https://github.com/jlelse))
- Replace repository checking logic [\#47](https://github.com/djmaze/resticker/pull/47) ([ThomDietrich](https://github.com/ThomDietrich))
- Add RESTIC\_PRUNE\_ARGS [\#46](https://github.com/djmaze/resticker/pull/46) ([PhasecoreX](https://github.com/PhasecoreX))
- Check for mutual exclusivity of cron expressions [\#41](https://github.com/djmaze/resticker/pull/41) ([ThomDietrich](https://github.com/ThomDietrich))
- Add better docker-compose example [\#40](https://github.com/djmaze/resticker/pull/40) ([ThomDietrich](https://github.com/ThomDietrich))
- Add RUN\_ON\_STARTUP for convenience and testing [\#39](https://github.com/djmaze/resticker/pull/39) ([ThomDietrich](https://github.com/ThomDietrich))
- Allow custom backup arguments using RESTIC\_BACKUP\_ARGS [\#38](https://github.com/djmaze/resticker/pull/38) ([djmaze](https://github.com/djmaze))
- Add prune support using a separate service and cron schedule [\#36](https://github.com/djmaze/resticker/pull/36) ([djmaze](https://github.com/djmaze))
- update rclone to 1.50.2 [\#25](https://github.com/djmaze/resticker/pull/25) ([panakour](https://github.com/panakour))

**Fixed bugs:**

- Fix unbound variable [\#45](https://github.com/djmaze/resticker/pull/45) ([PhasecoreX](https://github.com/PhasecoreX))
- Add missing `fi` [\#44](https://github.com/djmaze/resticker/pull/44) ([PhasecoreX](https://github.com/PhasecoreX))

**Closed issues:**

- Resticker Loop [\#60](https://github.com/djmaze/resticker/issues/60)
- Wrong image on docker hub [\#57](https://github.com/djmaze/resticker/issues/57)
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

As it turned out, the used version of **go-cron** did not work reliably any more. The image now includes a newer version which should fix those problems.

**Implemented enhancements:**

- Feature : Add curl to final image \(for Slack webhook\) [\#14](https://github.com/djmaze/resticker/pull/14) ([y3lousso](https://github.com/y3lousso))

**Fixed bugs:**

- Replace go-cron with crond from the already included BusyBox [\#11](https://github.com/djmaze/resticker/issues/11)

## [1.0.1](https://github.com/djmaze/resticker/tree/1.0.1) (2019-10-26)

[Full Changelog](https://github.com/djmaze/resticker/compare/1.0.0...1.0.1)

As it turned out, the used version of **go-cron** did not work reliably any more. The image now includes a newer version which should fix those problems.

**Implemented enhancements:**

- Update go-cron [\#12](https://github.com/djmaze/resticker/pull/12) ([djmaze](https://github.com/djmaze))

**Fixed bugs:**

- Replace go-cron with crond from the already included BusyBox [\#11](https://github.com/djmaze/resticker/issues/11)

## [1.0.0](https://github.com/djmaze/resticker/tree/1.0.0) (2019-10-24)

[Full Changelog](https://github.com/djmaze/resticker/compare/0.9.5...1.0.0)

In this release, there are a couple of new features. Also, Restic itself has not been updated in a while. So it makes sense to switch to our own versioning scheme now. In order to indicate this change, we are now continuing with 1.0.0.

The new version does not indicate any kind of stability or feature freeze. It is just a new numbering scheme which is now uncoupled from the Restic version in use. 

**Implemented enhancements:**

- Post commands [\#8](https://github.com/djmaze/resticker/pull/8) ([nikkoura](https://github.com/nikkoura))
- Support `rclone` [\#6](https://github.com/djmaze/resticker/pull/6) ([maximbaz](https://github.com/maximbaz))
- Fix various things & add support for precommands [\#3](https://github.com/djmaze/resticker/pull/3) ([jlelse](https://github.com/jlelse))

**Fixed bugs:**

- "syntax error: unexpected redirection" when using PRE\_COMMANDS [\#4](https://github.com/djmaze/resticker/issues/4)
- Fix PRE\_COMMANDS error \('unexpected redirection'\) [\#7](https://github.com/djmaze/resticker/pull/7) ([nikkoura](https://github.com/nikkoura))

**Closed issues:**

- NextCloud in and out of maintenance mode [\#9](https://github.com/djmaze/resticker/issues/9)

## [0.9.5](https://github.com/djmaze/resticker/tree/0.9.5) (2019-07-21)

[Full Changelog](https://github.com/djmaze/resticker/compare/0.9.3...0.9.5)

**Implemented enhancements:**

- Update alpine to 3.9 [\#2](https://github.com/djmaze/resticker/pull/2) ([jlelse](https://github.com/jlelse))

## [0.9.3](https://github.com/djmaze/resticker/tree/0.9.3) (2019-05-22)

[Full Changelog](https://github.com/djmaze/resticker/compare/6d9cfd3c141c373b77ceea418980f2b893222b86...0.9.3)



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
