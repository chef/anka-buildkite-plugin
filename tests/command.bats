#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# Uncomment to enable stub debug output:
# export ANKA_STUB_DEBUG=/dev/tty


@test "Run with BUILDKITE_COMMAND when VM is missing" {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="macos-base-10.14"
  export BUILDKITE_COMMAND='command "a string"'

  stub anka \
    "list ${BUILDKITE_PLUGIN_ANKA_VM_NAME} : exit 1" \
    "registry pull ${BUILDKITE_PLUGIN_ANKA_VM_NAME} : echo pulled vm in anka" \
    "clone ${BUILDKITE_PLUGIN_ANKA_VM_NAME} ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo cloned vm in anka" \
    "run ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -c \"$BUILDKITE_COMMAND\" : echo ran command in anka"

  run $PWD/hooks/command

  assert_success
  assert_output --partial "ran command in anka"

  unstub anka
  unset BUILDKITE_COMMAND
  unset BUILDKITE_PLUGIN_ANKA_VM_NAME
  unset BUILDKITE_JOB_ID
}

@test "Run with BUILDKITE_COMMAND when VM is missing and has tag" {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="macos-base-10.14"
  export BUILDKITE_COMMAND='command "a string"'
  export BUILDKITE_PLUGIN_ANKA_VM_REGISTRY_TAG="my-tag"

  stub anka \
    "list ${BUILDKITE_PLUGIN_ANKA_VM_NAME} : exit 1" \
    "registry pull --tag my-tag ${BUILDKITE_PLUGIN_ANKA_VM_NAME} : echo pulled vm in anka" \
    "clone ${BUILDKITE_PLUGIN_ANKA_VM_NAME} ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo cloned vm in anka" \
    "run ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -c \"$BUILDKITE_COMMAND\" : echo ran command in anka"

  run $PWD/hooks/command

  assert_success
  assert_output --partial "ran command in anka"

  unstub anka
  unset BUILDKITE_PLUGIN_ANKA_VM_REGISTRY_TAG
  unset BUILDKITE_COMMAND
  unset BUILDKITE_PLUGIN_ANKA_VM_NAME
  unset BUILDKITE_JOB_ID
}


@test "Run with BUILDKITE_COMMAND when VM is missing and has version" {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="macos-base-10.14"
  export BUILDKITE_COMMAND='command "a string"'
  export BUILDKITE_PLUGIN_ANKA_VM_REGISTRY_VERSION="1"

  stub anka \
    "list ${BUILDKITE_PLUGIN_ANKA_VM_NAME} : exit 1" \
    "registry pull --version 1 ${BUILDKITE_PLUGIN_ANKA_VM_NAME} : echo pulled vm in anka" \
    "clone ${BUILDKITE_PLUGIN_ANKA_VM_NAME} ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo cloned vm in anka" \
    "run ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -c \"$BUILDKITE_COMMAND\" : echo ran command in anka"

  run $PWD/hooks/command

  assert_success
  assert_output --partial "ran command in anka"

  unstub anka
  unset BUILDKITE_PLUGIN_ANKA_VM_REGISTRY_VERSION
  unset BUILDKITE_COMMAND
  unset BUILDKITE_PLUGIN_ANKA_VM_NAME
  unset BUILDKITE_JOB_ID
}

@test "Run with BUILDKITE_COMMAND when VM is always pulled" {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="macos-base-10.14"
  export BUILDKITE_COMMAND='command "a string"'
  export BUILDKITE_PLUGIN_ANKA_ALWAYS_PULL="true"

  stub anka \
    "list ${BUILDKITE_PLUGIN_ANKA_VM_NAME} : exit 0" \
    "registry pull ${BUILDKITE_PLUGIN_ANKA_VM_NAME} : echo pulled vm in anka" \
    "clone ${BUILDKITE_PLUGIN_ANKA_VM_NAME} ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo cloned vm in anka" \
    "run ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -c \"$BUILDKITE_COMMAND\" : echo ran command in anka"

  run $PWD/hooks/command

  assert_success
  assert_output --partial "ran command in anka"

  unstub anka
  unset BUILDKITE_PLUGIN_ANKA_ALWAYS_PULL
  unset BUILDKITE_COMMAND
  unset BUILDKITE_PLUGIN_ANKA_VM_NAME
  unset BUILDKITE_JOB_ID
}

@test "Run with BUILDKITE_COMMAND when VM is always pulled (shrink)" {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="macos-base-10.14"
  export BUILDKITE_COMMAND='command "a string"'
  export BUILDKITE_PLUGIN_ANKA_ALWAYS_PULL="shrink"

  stub anka \
    "list ${BUILDKITE_PLUGIN_ANKA_VM_NAME} : exit 0" \
    "registry pull -s ${BUILDKITE_PLUGIN_ANKA_VM_NAME} : echo pulled vm in anka" \
    "clone ${BUILDKITE_PLUGIN_ANKA_VM_NAME} ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo cloned vm in anka" \
    "run ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -c \"$BUILDKITE_COMMAND\" : echo ran command in anka"

  run $PWD/hooks/command

  assert_success
  assert_output --partial "ran command in anka"

  unstub anka
  unset BUILDKITE_PLUGIN_ANKA_ALWAYS_PULL
  unset BUILDKITE_COMMAND
  unset BUILDKITE_PLUGIN_ANKA_VM_NAME
  unset BUILDKITE_JOB_ID
}

@test "Run with BUILDKITE_COMMAND with custom workdir" {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="macos-base-10.14"
  export BUILDKITE_COMMAND='command "a string"'
  export BUILDKITE_PLUGIN_ANKA_WORKDIR="/workdir"

  stub anka \
    "list ${BUILDKITE_PLUGIN_ANKA_VM_NAME} : exit 1" \
    "registry pull ${BUILDKITE_PLUGIN_ANKA_VM_NAME} : echo pulled vm in anka" \
    "clone ${BUILDKITE_PLUGIN_ANKA_VM_NAME} ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo cloned vm in anka" \
    "run --workdir /workdir ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -c \"$BUILDKITE_COMMAND\" : echo ran command in anka"

  run $PWD/hooks/command

  assert_success
  assert_output --partial "ran command in anka"

  unstub anka
  unset BUILDKITE_PLUGIN_ANKA_WORKDIR
  unset BUILDKITE_COMMAND
  unset BUILDKITE_PLUGIN_ANKA_VM_NAME
  unset BUILDKITE_JOB_ID
}

@test "Run with BUILDKITE_COMMAND with custom host volume" {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="macos-base-10.14"
  export BUILDKITE_COMMAND='command "a string"'
  export BUILDKITE_PLUGIN_ANKA_VOLUME="volume"

  stub anka \
    "list ${BUILDKITE_PLUGIN_ANKA_VM_NAME} : exit 1" \
    "registry pull ${BUILDKITE_PLUGIN_ANKA_VM_NAME} : echo pulled vm in anka" \
    "clone ${BUILDKITE_PLUGIN_ANKA_VM_NAME} ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo cloned vm in anka" \
    "run --volume volume ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -c \"$BUILDKITE_COMMAND\" : echo ran command in anka"

  run $PWD/hooks/command

  assert_success
  assert_output --partial "ran command in anka"

  unstub anka
  unset BUILDKITE_PLUGIN_ANKA_VOLUME
  unset BUILDKITE_COMMAND
  unset BUILDKITE_PLUGIN_ANKA_VM_NAME
  unset BUILDKITE_JOB_ID
}

@test "Run with BUILDKITE_COMMAND with no volumes" {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="macos-base-10.14"
  export BUILDKITE_COMMAND='command "a string"'
  export BUILDKITE_PLUGIN_ANKA_NO_VOLUME="true"

  stub anka \
    "list ${BUILDKITE_PLUGIN_ANKA_VM_NAME} : exit 1" \
    "registry pull ${BUILDKITE_PLUGIN_ANKA_VM_NAME} : echo pulled vm in anka" \
    "clone ${BUILDKITE_PLUGIN_ANKA_VM_NAME} ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo cloned vm in anka" \
    "run --no-volume ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -c \"$BUILDKITE_COMMAND\" : echo ran command in anka"

  run $PWD/hooks/command

  assert_success
  assert_output --partial "ran command in anka"

  unstub anka
  unset BUILDKITE_PLUGIN_ANKA_NO_VOLUME
  unset BUILDKITE_COMMAND
  unset BUILDKITE_PLUGIN_ANKA_VM_NAME
  unset BUILDKITE_JOB_ID
}

@test "Run with BUILDKITE_COMMAND with env vars from host" {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="macos-base-10.14"
  export BUILDKITE_COMMAND='command "a string"'
  export BUILDKITE_PLUGIN_ANKA_INHERIT_ENVIRONMENT_VARS="true"

  stub anka \
    "list ${BUILDKITE_PLUGIN_ANKA_VM_NAME} : exit 1" \
    "registry pull ${BUILDKITE_PLUGIN_ANKA_VM_NAME} : echo pulled vm in anka" \
    "clone ${BUILDKITE_PLUGIN_ANKA_VM_NAME} ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo cloned vm in anka" \
    "run --env ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -c \"$BUILDKITE_COMMAND\" : echo ran command in anka"

  run $PWD/hooks/command

  assert_success
  assert_output --partial "ran command in anka"

  unstub anka
  unset BUILDKITE_PLUGIN_ANKA_INHERIT_ENVIRONMENT_VARS
  unset BUILDKITE_COMMAND
  unset BUILDKITE_PLUGIN_ANKA_VM_NAME
  unset BUILDKITE_JOB_ID
}

@test "Run with BUILDKITE_COMMAND with env vars from file" {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="macos-base-10.14"
  export BUILDKITE_COMMAND='command "a string"'
  export BUILDKITE_PLUGIN_ANKA_ENVIRONMENT_FILE="./env-file"

  stub anka \
    "list ${BUILDKITE_PLUGIN_ANKA_VM_NAME} : exit 1" \
    "registry pull ${BUILDKITE_PLUGIN_ANKA_VM_NAME} : echo pulled vm in anka" \
    "clone ${BUILDKITE_PLUGIN_ANKA_VM_NAME} ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo cloned vm in anka" \
    "run --env-file ./env-file ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -c \"$BUILDKITE_COMMAND\" : echo ran command in anka"

  run $PWD/hooks/command

  assert_success
  assert_output --partial "ran command in anka"

  unstub anka
  unset BUILDKITE_PLUGIN_ANKA_ENVIRONMENT_FILE
  unset BUILDKITE_COMMAND
  unset BUILDKITE_PLUGIN_ANKA_VM_NAME
  unset BUILDKITE_JOB_ID
}

@test "Run with BUILDKITE_COMMAND and wait for network" {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="macos-base-10.14"
  export BUILDKITE_COMMAND='command "a string"'
  export BUILDKITE_PLUGIN_ANKA_WAIT_NETWORK="true"

  stub anka \
    "list ${BUILDKITE_PLUGIN_ANKA_VM_NAME} : exit 1" \
    "registry pull ${BUILDKITE_PLUGIN_ANKA_VM_NAME} : echo pulled vm in anka" \
    "clone ${BUILDKITE_PLUGIN_ANKA_VM_NAME} ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo cloned vm in anka" \
    "run --wait-network ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -c \"$BUILDKITE_COMMAND\" : echo ran command in anka"

  run $PWD/hooks/command

  assert_success
  assert_output --partial "ran command in anka"

  unstub anka
  unset BUILDKITE_PLUGIN_ANKA_WAIT_NETWORK
  unset BUILDKITE_COMMAND
  unset BUILDKITE_PLUGIN_ANKA_VM_NAME
  unset BUILDKITE_JOB_ID
}

@test "Run with BUILDKITE_COMMAND with yaml command list" {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="macos-base-10.14"
  export BUILDKITE_COMMAND="ls -alht
env"

  stub anka \
    "list ${BUILDKITE_PLUGIN_ANKA_VM_NAME} : exit 0" \
    "clone ${BUILDKITE_PLUGIN_ANKA_VM_NAME} ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo cloned vm in anka" \
    "run ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -c \"ls -alht\" : echo ran command in anka" \
    "run ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -c \"env\" : echo ran command in anka"
  
  run $PWD/hooks/command

  assert_success
  assert_output --partial "ran command in anka"

  unstub anka
  unset BUILDKITE_COMMAND
  unset BUILDKITE_PLUGIN_ANKA_VM_NAME
  unset BUILDKITE_JOB_ID
  unset BUILDKITE_PLUGIN_ANKA_CLEANUP
}

# You can't really test pre-exit properly, since it's a buildkite hook, but we can make sure pre-exit does what it should.

@test "Cleanup pre-exit runs properly (delete)" {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="macos-base-10.14"
  export BUILDKITE_COMMAND="ls -alht"

  stub anka \
    "delete --yes ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo deleted vm in anka"

  run $PWD/hooks/pre-exit

  assert_success
  assert_output --partial "deleted vm in anka"

  unstub anka
  unset BUILDKITE_COMMAND
  unset BUILDKITE_PLUGIN_ANKA_VM_NAME
  unset BUILDKITE_JOB_ID
}

@test "Cleanup pre-exit runs properly (suspend)" {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="macos-base-10.14"
  export BUILDKITE_COMMAND="ls -alht"
  export BUILDKITE_PLUGIN_ANKA_CLEANUP=false

  stub anka \
    "suspend ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo suspended vm in anka"
  
  run $PWD/hooks/pre-exit

  assert_success
  assert_output --partial "suspended vm in anka"

  unstub anka
  unset BUILDKITE_COMMAND
  unset BUILDKITE_PLUGIN_ANKA_VM_NAME
  unset BUILDKITE_JOB_ID
  unset BUILDKITE_PLUGIN_ANKA_CLEANUP

}