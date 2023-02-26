IMAGE=restic:dev
DOCKER="docker"

Describe "backup script"
  BeforeAll "setup"
  AfterAll "cleanup"
  After "cleanupEach"

  local container
  local extra_env

  docker_exec() {
    extra_args=()
    [[ -f "$extra_env" ]] && extra_args=(--env-file "${extra_env[@]}")
    
    # shellcheck disable=SC2086
    $DOCKER exec -i \
      -e RESTIC_PASSWORD=test \
      "${extra_args[@]}" \
      "$container" \
      bash -c "$*; exit \$?"
  }

  setup() {
    $DOCKER build --build-arg ARCH="${ARCH:-amd64}" -t "$IMAGE" .
    container=$($DOCKER run -d --entrypoint bash "$IMAGE" -c "sleep 10000")
    extra_env="$(mktemp /tmp/extra.env.XXXXXXXX)"
    docker_exec restic init
    docker_exec "mkdir -p /data && echo 123 >/data/dummy && mkdir -p /my\ data && echo 123 >/my\ data/dummy && echo 456 >/my\ data/dreck"
  }

  cleanup() {
    $DOCKER rm -f "$container"
  }

  cleanupEach() {
    rm -f "$extra_env"
  }

  It "Runs a backup successfully"
    When call docker_exec backup
    The output should include "Backup successful"
    The output should match pattern "*processed 1 files*"
    The status should be success
  End

  It "Runs a backup on a path with spaces successfully"
    cat <<HERE >"$extra_env"
      RESTIC_BACKUP_SOURCES=/my\ data
      RESTIC_BACKUP_ARGS=--verbose=3 --exclude /my\ data/dreck
HERE
    When call docker_exec backup
    The output should include "Backup successful"
    The output should match pattern "*processed 1 files*"
    The status should be success
  End

  It "Runs success command after successful backup"
    cat <<HERE >"$extra_env"
      POST_COMMANDS_SUCCESS=echo Great success!
HERE
    When call docker_exec backup
    The output should include "Backup successful"
    The output should include "Great success!"
    The status should be success
  End

  It "Runs failure command if backup fails"
    cat <<HERE >"$extra_env"
      RESTIC_REPOSITORY=/nonexisting
      POST_COMMANDS_FAILURE=echo Total failure!
HERE
    When call docker_exec backup
    The stderr should include "Fatal:"
    The output should include "Total failure!"
    The status should eq 1
  End

  It "Runs failure command if backup is incomplete and incomplete command is not specified"
    cat <<HERE >"$extra_env"
      RESTIC_BACKUP_SOURCES=/proc/self/mem
      POST_COMMANDS_FAILURE=echo Total failure!
HERE
    When call docker_exec backup
    The stderr should not include "Fatal:"
    The output should include "Total failure!"
    The status should eq 3
  End

  It "Runs incomplete command if backup is incomplete and incomplete command is specified"
    cat <<HERE >"$extra_env"
      RESTIC_BACKUP_SOURCES=/data /proc/self/mem
      POST_COMMANDS_INCOMPLETE=echo Partial failure!
      POST_COMMANDS_FAILURE=echo Total failure!
HERE
    When call docker_exec backup
    The stderr should not include "Fatal:"
    The output should not include "Total failure!"
    The output should include "Partial failure!"
    The status should eq 3
  End

  It "Runs success command if backup is incomplete and \"success on incomplete backup\" is activated"
    cat <<HERE >"$extra_env"
      RESTIC_BACKUP_SOURCES=/data /proc/self/mem
      POST_COMMANDS_SUCCESS=echo Great success!
      POST_COMMANDS_FAILURE=echo Total failure!
      SUCCESS_ON_INCOMPLETE_BACKUP=true
HERE
    When call docker_exec backup
    The stderr should not include "Fatal:"
    The output should not include "Total failure!"
    The output should include "Great success!"
    The status should eq 3
  End

  It "Forgets old backups after backup"
    cat <<HERE >"$extra_env"
      RESTIC_FORGET_ARGS=--keep-last 1
HERE
    When call docker_exec "backup && backup"
    The status should be success
    The output should match pattern "*keep 1 snapshots*"
  End
End