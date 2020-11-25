#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# Uncomment to enable stub debug output:
# export BATS_MOCK_DETAIL=/dev/tty
# export ANKA_STUB_DEBUG=/dev/tty

export KEXSTAT_OUTPUT_PRESENT='120    0 0xffffff7f82aba000 0x17000    0x17000    com.veertu.filesystems.vtufs (3.11.0) 26F3D9BE-3B96-36B1-A2FA-5986EF0ADC2F <8 6 5 3 1>'
export KEXSTAT_OUTPUT_MISSING="191    0 0xffffff7f847c1000 0x19000    0x19000    com.github.kbfuse.filesystems.kbfuse (3.10.0) E0B603B0-D9BC-33D0-8DE4-58A76DC4990A <8 6 5 3 1>"

setup() {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="10.14"
  export BUILDKITE_COMMAND='command "a string"'
}

teardown() {
  unstub anka

  unset BUILDKITE_JOB_ID
  unset BUILDKITE_PLUGIN_ANKA_VM_NAME
  unset BUILDKITE_COMMAND
}

@test "Run BUILDKITE_COMMAND on machine with FUSE" {
  stub anka \
    "run --no-volume 10.14-UUID kextstat : echo '${KEXSTAT_OUTPUT_PRESENT}'" \
    "run --workdir /private/var/tmp/ankafs.0 10.14-UUID bash -c 'command \"a string\"' : echo 'ran command in anka'"

  run $PWD/hooks/command

  assert_success
  assert_output --partial "ran command in anka"
}

@test "Run BUILDKITE_COMMAND on machine without FUSE" {
   stub anka \
    "run --no-volume 10.14-UUID kextstat : echo '${KEXSTAT_OUTPUT_MISSING}'" \
    "cp -a . 10.14-UUID:/private/var/tmp/ankafs.0 : " \
    "run --workdir /private/var/tmp/ankafs.0 10.14-UUID bash -c 'command \"a string\"' : echo 'ran command in anka'"

  run $PWD/hooks/command

  assert_success
  assert_output --partial "ran command in anka"
}

@test "Run with BUILDKITE_COMMAND on a machine with FUSE and a custom workdir" {
  export BUILDKITE_PLUGIN_ANKA_WORKDIR="/workdir"

  stub anka \
    "run --no-volume 10.14-UUID kextstat : echo '${KEXSTAT_OUTPUT_PRESENT}'" \
    "run --workdir /workdir 10.14-UUID bash -c 'command \"a string\"' : echo 'ran command in anka'"

  run $PWD/hooks/command

  assert_success
  assert_output --partial "ran command in anka"

  unset BUILDKITE_PLUGIN_ANKA_WORKDIR
}

@test "Run with BUILDKITE_COMMAND on a machine without FUSE and a custom workdir" {
  export BUILDKITE_PLUGIN_ANKA_WORKDIR="/workdir"

  stub anka \
    "run --no-volume 10.14-UUID kextstat : echo '${KEXSTAT_OUTPUT_MISSING}'" \
    "cp -a . 10.14-UUID:/private/var/tmp/ankafs.0 : " \
    "run --workdir /workdir 10.14-UUID bash -c 'command \"a string\"' : echo 'ran command in anka'"

  run $PWD/hooks/command

  assert_success
  assert_output --partial "ran command in anka"

  unset BUILDKITE_PLUGIN_ANKA_WORKDIR
}


@test "Run with BUILDKITE_COMMAND, create the workdir first, then use --workdir" {
  export BUILDKITE_PLUGIN_ANKA_WORKDIR="/workdir"
  export BUILDKITE_PLUGIN_ANKA_WORKDIR_CREATE=true

  stub anka \
    "run --no-volume 10.14-UUID kextstat : echo '${KEXSTAT_OUTPUT_PRESENT}'" \
    "run 10.14-UUID mkdir -p /workdir : echo 'ran mkdir'" \
    "run --workdir /workdir 10.14-UUID bash -c 'command \"a string\"' : echo 'ran command in anka'"

  run $PWD/hooks/command

  assert_success
  assert_output --partial "ran command in anka"

  unset BUILDKITE_PLUGIN_ANKA_WORKDIR
  unset BUILDKITE_PLUGIN_ANKA_WORKDIR_CREATE
}

@test "Run with BUILDKITE_COMMAND on machine with FUSE with custom host volume" {
  export BUILDKITE_PLUGIN_ANKA_VOLUME="volume"

  stub anka \
    "run --no-volume 10.14-UUID kextstat : echo '${KEXSTAT_OUTPUT_PRESENT}'" \
    "run --volume volume --workdir /private/var/tmp/ankafs.0 10.14-UUID bash -c 'command \"a string\"' : echo 'ran command in anka'"

  run $PWD/hooks/command

  assert_success
  assert_output --partial "ran command in anka"

  unset BUILDKITE_PLUGIN_ANKA_VOLUME
}

@test "Run with BUILDKITE_COMMAND on machine without FUSE with custom host volume" {
  export BUILDKITE_PLUGIN_ANKA_VOLUME="volume"

  stub anka \
    "run --no-volume 10.14-UUID kextstat : echo '${KEXSTAT_OUTPUT_MISSING}'" \
    "cp -a volume 10.14-UUID:/private/var/tmp/ankafs.0 : " \
    "run --volume volume --workdir /private/var/tmp/ankafs.0 10.14-UUID bash -c 'command \"a string\"' : echo 'ran command in anka'"

  run $PWD/hooks/command

  assert_success
  assert_output --partial "ran command in anka"

  unset BUILDKITE_PLUGIN_ANKA_VOLUME
}

@test "Run with BUILDKITE_COMMAND and no volumes" {
  export BUILDKITE_PLUGIN_ANKA_NO_VOLUME="true"

  stub anka \
    "run --no-volume 10.14-UUID bash -c 'command \"a string\"' : echo 'ran command in anka'"

  run $PWD/hooks/command

  assert_success
  assert_output --partial "ran command in anka"

  unset BUILDKITE_PLUGIN_ANKA_NO_VOLUME
}

@test "Run with BUILDKITE_COMMAND and env vars from host" {
  export BUILDKITE_PLUGIN_ANKA_INHERIT_ENVIRONMENT_VARS="true"

  stub anka \
    "run --no-volume 10.14-UUID kextstat : echo '${KEXSTAT_OUTPUT_PRESENT}'" \
    "run --env --workdir /private/var/tmp/ankafs.0 10.14-UUID bash -c 'command \"a string\"' : echo 'ran command in anka'"

  run $PWD/hooks/command

  assert_success
  assert_output --partial "ran command in anka"

  unset BUILDKITE_PLUGIN_ANKA_INHERIT_ENVIRONMENT_VARS
}

@test "Run with BUILDKITE_COMMAND and env vars from file" {
  export BUILDKITE_PLUGIN_ANKA_ENVIRONMENT_FILE="./env-file"

  stub anka \
    "run --no-volume 10.14-UUID kextstat : echo '${KEXSTAT_OUTPUT_PRESENT}'" \
    "run --env-file ./env-file --workdir /private/var/tmp/ankafs.0 10.14-UUID bash -c 'command \"a string\"' : echo 'ran command in anka'"

  run $PWD/hooks/command

  assert_success
  assert_output --partial "ran command in anka"

  unset BUILDKITE_PLUGIN_ANKA_ENVIRONMENT_FILE
}

@test "Run with BUILDKITE_COMMAND and wait for network" {
  export BUILDKITE_PLUGIN_ANKA_WAIT_NETWORK="true"

  stub anka \
    "run --no-volume 10.14-UUID kextstat : echo '${KEXSTAT_OUTPUT_PRESENT}'" \
    "run --wait-network --workdir /private/var/tmp/ankafs.0 10.14-UUID bash -c 'command \"a string\"' : echo 'ran command in anka'"

  run $PWD/hooks/command

  assert_success
  assert_output --partial "ran command in anka"

  unset BUILDKITE_PLUGIN_ANKA_WAIT_NETWORK
}

@test "Run with BUILDKITE_COMMAND and wait for time" {
  export BUILDKITE_PLUGIN_ANKA_WAIT_TIME="true"

  stub anka \
    "run --no-volume 10.14-UUID kextstat : echo '${KEXSTAT_OUTPUT_PRESENT}'" \
    "run --wait-time --workdir /private/var/tmp/ankafs.0 10.14-UUID bash -c 'command \"a string\"' : echo 'ran command in anka'"

  run $PWD/hooks/command

  assert_success
  assert_output --partial "ran command in anka"

  unset BUILDKITE_PLUGIN_ANKA_WAIT_TIME
  unset BUILDKITE_COMMAND
  unset BUILDKITE_PLUGIN_ANKA_VM_NAME
  unset BUILDKITE_JOB_ID
}

@test "Run with BUILDKITE_COMMAND as yaml command list" {
  export BUILDKITE_COMMAND="ls -alht
env"

  stub anka \
    "run --no-volume 10.14-UUID kextstat : echo '${KEXSTAT_OUTPUT_PRESENT}'" \
    "run --workdir /private/var/tmp/ankafs.0 10.14-UUID bash -c \"ls -alht\" : echo 'ran ls command in anka'" \
    "run --workdir /private/var/tmp/ankafs.0 10.14-UUID bash -c \"env\" : echo 'ran env command in anka'"

  run $PWD/hooks/command

  assert_success
  assert_output --partial "ran ls command in anka"
  assert_output --partial "ran env command in anka"

  unset BUILDKITE_COMMAND
}

@test "Run with BUILDKITE_COMMAND with anka-debug" {
  export BUILDKITE_COMMAND="ls -alht
env"
  export BUILDKITE_PLUGIN_ANKA_ANKA_DEBUG=true

  stub anka \
    "run --no-volume 10.14-UUID kextstat : echo '${KEXSTAT_OUTPUT_PRESENT}'" \
    "--debug run --workdir /private/var/tmp/ankafs.0 10.14-UUID bash -c \"ls -alht\" : echo 'ran ls command in anka'" \
    "--debug run --workdir /private/var/tmp/ankafs.0 10.14-UUID bash -c \"env\" : echo 'ran env command in anka'"

  run $PWD/hooks/command

  assert_success
  assert_output --partial "ran ls command in anka"
  assert_output --partial "ran env command in anka"

  unset BUILDKITE_PLUGIN_ANKA_ANKA_DEBUG
  unset BUILDKITE_COMMAND
}

@test "Run with bash ops" {
  export BUILDKITE_COMMAND="ls -alht"
  export BUILDKITE_PLUGIN_ANKA_BASH_INTERACTIVE=true

  stub anka \
    "run --no-volume 10.14-UUID kextstat : echo '${KEXSTAT_OUTPUT_PRESENT}'" \
    "run --workdir /private/var/tmp/ankafs.0 10.14-UUID bash -i -c \"ls -alht\" : echo 'ran ls command in anka'" \

  run $PWD/hooks/command

  assert_success
  assert_output --partial "ran ls command in anka"

  unset BUILDKITE_PLUGIN_ANKA_BASH_INTERACTIVE
  unset BUILDKITE_COMMAND
}

@test "Run with pre-execute-sleep" {
  export BUILDKITE_COMMAND="ls -alht
env"
  export BUILDKITE_PLUGIN_ANKA_ALWAYS_PULL="true"
  export BUILDKITE_PLUGIN_ANKA_PRE_EXECUTE_SLEEP="5"

  stub anka \
    "run --no-volume 10.14-UUID kextstat : echo '${KEXSTAT_OUTPUT_PRESENT}'" \
    "run --workdir /private/var/tmp/ankafs.0 10.14-UUID bash -c \"sleep 5; ls -alht\" : echo ran command in anka" \
    "run --workdir /private/var/tmp/ankafs.0 10.14-UUID bash -c \"sleep 5; env\" : echo ran command in anka"

  run $PWD/hooks/command

  assert_success

  unset BUILDKITE_PLUGIN_ANKA_PRE_EXECUTE_SLEEP

  stub anka \
    "run --no-volume 10.14-UUID kextstat : echo '${KEXSTAT_OUTPUT_PRESENT}'" \
    "run --workdir /private/var/tmp/ankafs.0 10.14-UUID bash -c \"ls -alht\" : echo 'ran command in anka'" \
    "run --workdir /private/var/tmp/ankafs.0 10.14-UUID bash -c \"env\" : echo 'ran command in anka'"

  run $PWD/hooks/command

  assert_success

  unset BUILDKITE_COMMAND
}

@test "Run with pre-execute-ping-sleep" {
  export BUILDKITE_COMMAND="ls -alht
env"
  export BUILDKITE_PLUGIN_ANKA_PRE_EXECUTE_PING_SLEEP="8.8.8.8"

  stub anka \
    "run --no-volume 10.14-UUID kextstat : echo '${KEXSTAT_OUTPUT_PRESENT}'" \
    "run --workdir /private/var/tmp/ankafs.0 10.14-UUID bash -c \"while ! ping -c1 8.8.8.8 | grep -v '\\---'; do sleep 1; done;ls -alht\" : echo 'ran command in anka'" \
    "run --workdir /private/var/tmp/ankafs.0 10.14-UUID bash -c \"while ! ping -c1 8.8.8.8 | grep -v '\\---'; do sleep 1; done;env\" : echo r'an command in anka'"

  run $PWD/hooks/command

  assert_success

  unset BUILDKITE_PLUGIN_ANKA_PRE_EXECUTE_PING_SLEEP

  stub anka \
    "run --no-volume 10.14-UUID kextstat : echo '${KEXSTAT_OUTPUT_PRESENT}'" \
    "run --workdir /private/var/tmp/ankafs.0 10.14-UUID bash -c \"ls -alht\" : echo 'ran command in anka'" \
    "run --workdir /private/var/tmp/ankafs.0 10.14-UUID bash -c \"env\" : echo 'ran command in anka'"

  run $PWD/hooks/command

  assert_success

  unset BUILDKITE_COMMAND
}