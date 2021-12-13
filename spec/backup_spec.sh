IMAGE=restic:dev
DOCKER="sudo -E docker"

Describe "backup script"
  BeforeAll "setup"
  AfterAll "cleanup"
  After "cleanupEach"

  local container
  local extra_env

  docker_exec() {
    extra_args=""
    [[ -f "$extra_env" ]] && extra_args="--env-file $extra_env"
    
    $DOCKER exec -i \
      -e RESTIC_PASSWORD=test \
      $extra_args \
      "$container" \
      bash -c "$*; exit \$?"
  }

  setup() {
    $DOCKER build --build-arg ARCH="${ARCH:-amd64}" -t "$IMAGE" .
    container=$($DOCKER run -d --entrypoint bash "$IMAGE" -c "sleep 10000")
    extra_env="$(mktemp /tmp/extra.env.XXX)"
    docker_exec restic init
    docker_exec "mkdir -p /data && echo 1 >/data/dummy"
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
    The output should match pattern "*Added to the repo: 70? B*"
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

  It "Runs incomplete command if backup is incomplete"
    cat <<HERE >"$extra_env"
      RESTIC_BACKUP_SOURCES=/proc/self/mem
      POST_COMMANDS_INCOMPLETE=echo Partial failure!
      POST_COMMANDS_FAILURE=echo Total failure!
HERE
    When call docker_exec backup
    The stderr should not include "Fatal:"
    The output should not include "Total failure!"
    The output should include "Partial failure!"
    The status should eq 3
  End
End