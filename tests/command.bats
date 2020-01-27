#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# Uncomment to enable stub debug output:
# export ANKA_STUB_DEBUG=/dev/tty
# export BUILDKITE_PLUGIN_ANKA_DEBUG=true

export BUILDKITE_BUILD_URL="https://buildkite.com/repo/name/builds/12034"

@test "Run with BUILDKITE_COMMAND when VM is missing" {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="macos-base-10.14"
  export BUILDKITE_COMMAND="command \\\"a string\\\""

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
  export BUILDKITE_COMMAND="command \\\"a string\\\""
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
  export BUILDKITE_COMMAND="command \\\"a string\\\""
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
  export BUILDKITE_COMMAND="command \\\"a string\\\""
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
  export BUILDKITE_COMMAND="command \\\"a string\\\""
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

@test "Run with BUILDKITE_COMMAND and custom workdir" {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="macos-base-10.14"
  export BUILDKITE_COMMAND="command \\\"a string\\\""
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

@test "Run with BUILDKITE_COMMAND, create the workdir first, then use --workdir" {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="macos-base-10.14"
  export BUILDKITE_COMMAND="command \\\"a string\\\""
  export BUILDKITE_PLUGIN_ANKA_WORKDIR="/workdir"
  export BUILDKITE_PLUGIN_ANKA_WORKDIR_CREATE=true

  stub anka \
    "list ${BUILDKITE_PLUGIN_ANKA_VM_NAME} : exit 1" \
    "registry pull ${BUILDKITE_PLUGIN_ANKA_VM_NAME} : echo pulled vm in anka" \
    "clone ${BUILDKITE_PLUGIN_ANKA_VM_NAME} ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo cloned vm in anka" \
    "run ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} mkdir -p $BUILDKITE_PLUGIN_ANKA_WORKDIR : echo ran mkdir" \
    "run --workdir $BUILDKITE_PLUGIN_ANKA_WORKDIR ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -c \"$BUILDKITE_COMMAND\" : echo ran command in anka"

  run $PWD/hooks/command

  assert_success
  assert_output --partial "ran command in anka"

  unstub anka
  unset BUILDKITE_PLUGIN_ANKA_WORKDIR
  unset BUILDKITE_COMMAND
  unset BUILDKITE_PLUGIN_ANKA_WORKDIR_CREATE
  unset BUILDKITE_PLUGIN_ANKA_VM_NAME
  unset BUILDKITE_JOB_ID
}

@test "Run with BUILDKITE_COMMAND and custom host volume" {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="macos-base-10.14"
  export BUILDKITE_COMMAND="command \\\"a string\\\""
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

@test "Run with BUILDKITE_COMMAND and no volumes" {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="macos-base-10.14"
  export BUILDKITE_COMMAND="command \\\"a string\\\""
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

@test "Run with BUILDKITE_COMMAND and env vars from host" {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="macos-base-10.14"
  export BUILDKITE_COMMAND="command \\\"a string\\\""
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

@test "Run with BUILDKITE_COMMAND and env vars from file" {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="macos-base-10.14"
  export BUILDKITE_COMMAND="command \\\"a string\\\""
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
  export BUILDKITE_COMMAND="command \\\"a string\\\""
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

@test "Run with BUILDKITE_COMMAND as yaml command list" {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="macos-base-10.14"
  export BUILDKITE_COMMAND="ls -alht
env"

  stub anka \
    "list ${BUILDKITE_PLUGIN_ANKA_VM_NAME} : exit 0" \
    "clone ${BUILDKITE_PLUGIN_ANKA_VM_NAME} ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo cloned vm in anka" \
    "run ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -c \"ls -alht\" : echo ran ls command in anka" \
    "run ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -c \"env\" : echo ran env command in anka"

  run $PWD/hooks/command

  assert_success
  assert_output --partial "ran ls command in anka"
  assert_output --partial "ran env command in anka"

  unstub anka
  unset BUILDKITE_COMMAND
  unset BUILDKITE_PLUGIN_ANKA_VM_NAME
  unset BUILDKITE_JOB_ID
  unset BUILDKITE_PLUGIN_ANKA_CLEANUP
}

@test "Run with BUILDKITE_COMMAND with anka-debug" {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="macos-base-10.14"
  export BUILDKITE_COMMAND="ls -alht
env"
  export BUILDKITE_PLUGIN_ANKA_ANKA_DEBUG=true

  stub anka \
    "--debug list ${BUILDKITE_PLUGIN_ANKA_VM_NAME} : exit 0" \
    "--debug clone ${BUILDKITE_PLUGIN_ANKA_VM_NAME} ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo cloned vm in anka" \
    "--debug run ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -c \"ls -alht\" : echo ran ls command in anka" \
    "--debug run ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -c \"env\" : echo ran env command in anka"

  run $PWD/hooks/command

  assert_success
  assert_output --partial "cloned vm in anka"
  assert_output --partial "ran ls command in anka"
  assert_output --partial "ran env command in anka"

  unstub anka
  unset BUILDKITE_PLUGIN_ANKA_ANKA_DEBUG
  unset BUILDKITE_COMMAND
  unset BUILDKITE_PLUGIN_ANKA_VM_NAME
  unset BUILDKITE_JOB_ID
  unset BUILDKITE_PLUGIN_ANKA_CLEANUP
}

@test "Run with PRE_COMMANDS (yaml list)" {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="macos-base-10.14"
  export BUILDKITE_COMMAND="ls -alht"
  export BUILDKITE_PLUGIN_ANKA_PRE_COMMANDS="echo 123 && echo 456
echo got 123 && echo \" got 456 \"
buildkite-agent artifact download \"build.tar.gz\" . --step \":aws: Amazon Linux 1 Build\"
buildkite-agent artifact download \"build.tar.gz\" . --step \":aws: Amazon Linux 2 Build\""

  stub buildkite-agent \
    'artifact download "build.tar.gz" . --step ":aws: Amazon Linux 1 Build" : echo downloaded artifact 1' \
    'artifact download "build.tar.gz" . --step ":aws: Amazon Linux 2 Build" : echo downloaded artifact 2'

  stub anka \
    "list ${BUILDKITE_PLUGIN_ANKA_VM_NAME} : exit 0" \
    "clone ${BUILDKITE_PLUGIN_ANKA_VM_NAME} ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo cloned vm in anka" \
    "run ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -c \"ls -alht\" : echo ran ls command in anka" \

  run $PWD/hooks/command

  assert_success
  assert_output --partial "123"
  assert_output --partial "456"
  assert_output --partial "got 123"
  assert_output --partial " got 456"
  assert_output --partial "downloaded artifact 1"
  assert_output --partial "downloaded artifact 2"
  assert_output --partial "cloned vm in anka"
  assert_output --partial "ran ls command in anka"

  unstub anka
  unstub buildkite-agent
  unset BUILDKITE_PLUGIN_ANKA_PRE_COMMANDS
  unset BUILDKITE_COMMAND
  unset BUILDKITE_PLUGIN_ANKA_VM_NAME
  unset BUILDKITE_JOB_ID
  unset BUILDKITE_PLUGIN_ANKA_CLEANUP
}

@test "Run with START_DEVICES (yaml list)" {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="macos-base-10.14"
  export BUILDKITE_COMMAND="ls -alht"
  export BUILDKITE_PLUGIN_ANKA_START_DEVICES="iphone1
iphone2"

  stub anka \
    "list ${BUILDKITE_PLUGIN_ANKA_VM_NAME} : exit 0" \
    "clone ${BUILDKITE_PLUGIN_ANKA_VM_NAME} ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo cloned vm" \
    "list ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} | grep suspended : exit 0" \
    "stop ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo stopped" \
    "start -d iphone1 -d iphone2 ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo started with devices" \
    "run ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -c \"ls -alht\" : echo ran ls command in anka" \
    
  run $PWD/hooks/command

  assert_success
  assert_output --partial "cloned vm"
  assert_output --partial "stopped"
  assert_output --partial "started with devices"
  assert_output --partial "ran ls command in anka"

  unstub anka
  unset BUILDKITE_PLUGIN_ANKA_START_DEVICES
  unset BUILDKITE_COMMAND
  unset BUILDKITE_PLUGIN_ANKA_VM_NAME
  unset BUILDKITE_JOB_ID
  unset BUILDKITE_PLUGIN_ANKA_CLEANUP
}


@test "Run with POST_COMMANDS (yaml list)" {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="macos-base-10.14"
  export BUILDKITE_COMMAND="ls -alht"
  export BUILDKITE_PLUGIN_ANKA_POST_COMMANDS="echo 123 && echo 456
echo got 123 && echo \" got 456 \"
buildkite-agent artifact upload \"build.tar.gz\"
buildkite-agent artifact upload \"build.tar.gz\""

  stub buildkite-agent \
    'artifact upload "build.tar.gz" : echo upload artifact 1' \
    'artifact upload "build.tar.gz" : echo upload artifact 2'

  stub anka \
    "list ${BUILDKITE_PLUGIN_ANKA_VM_NAME} : exit 0" \
    "clone ${BUILDKITE_PLUGIN_ANKA_VM_NAME} ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo cloned vm in anka" \
    "run ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -c \"ls -alht\" : echo ran ls command in anka" \

  run $PWD/hooks/command

  assert_success
  assert_output --partial "123"
  assert_output --partial "456"
  assert_output --partial "got 123"
  assert_output --partial " got 456"
  assert_output --partial "upload artifact 1"
  assert_output --partial "upload artifact 2"
  assert_output --partial "cloned vm in anka"
  assert_output --partial "ran ls command in anka"

  unstub anka
  unstub buildkite-agent
  unset BUILDKITE_PLUGIN_ANKA_POST_COMMANDS
  unset BUILDKITE_COMMAND
  unset BUILDKITE_PLUGIN_ANKA_VM_NAME
  unset BUILDKITE_JOB_ID
  unset BUILDKITE_PLUGIN_ANKA_CLEANUP
}

@test "Run with bash ops" {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="macos-base-10.14"
  export BUILDKITE_COMMAND="ls -alht"
  export BUILDKITE_PLUGIN_ANKA_BASH_INTERACTIVE=true

  stub anka \
    "list ${BUILDKITE_PLUGIN_ANKA_VM_NAME} : exit 0" \
    "clone ${BUILDKITE_PLUGIN_ANKA_VM_NAME} ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo cloned vm in anka" \
    "run ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -i -c \"ls -alht\" : echo ran ls command in anka" \

  run $PWD/hooks/command

  assert_success
  assert_output --partial "ran ls command in anka"

  unstub anka
  unset BUILDKITE_PLUGIN_ANKA_BASH_INTERACTIVE
  unset BUILDKITE_COMMAND
  unset BUILDKITE_PLUGIN_ANKA_VM_NAME
  unset BUILDKITE_JOB_ID
  unset BUILDKITE_PLUGIN_ANKA_CLEANUP
}


@test "Run with registry-failover" {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="macos-base-10.14"
  export BUILDKITE_COMMAND="command"
  export BUILDKITE_PLUGIN_ANKA_ALWAYS_PULL="true"
  export BUILDKITE_PLUGIN_ANKA_FAILOVER_REGISTRIES='registry_1
registry_2
registry_3'

  stub anka \
    "registry list : echo -" \
    "list $BUILDKITE_PLUGIN_ANKA_VM_NAME : exit 0" \
    "registry pull $BUILDKITE_PLUGIN_ANKA_VM_NAME : echo pulled vm in anka" \
    "clone $BUILDKITE_PLUGIN_ANKA_VM_NAME ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo cloned vm in anka" \
    "run ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -c \"$BUILDKITE_COMMAND\" : echo ran command in anka"

  run $PWD/hooks/command

  assert_success

  unstub anka

  stub anka \
    "registry list : exit 30" \
    "registry list-repos -d : echo '| id     | registry_1  |'" \
    "registry -r registry_2 list : echo -" \
    "list $BUILDKITE_PLUGIN_ANKA_VM_NAME : exit 0" \
    "registry -r registry_2 pull $BUILDKITE_PLUGIN_ANKA_VM_NAME : echo pulled vm in anka" \
    "clone $BUILDKITE_PLUGIN_ANKA_VM_NAME ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo cloned vm in anka" \
    "run ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -c \"$BUILDKITE_COMMAND\" : echo ran command in anka"

  run $PWD/hooks/command

  assert_success

  unstub anka

  stub anka \
    "registry list : exit 30" \
    "registry list-repos -d : echo '| id     | registry_1  |'" \
    "registry -r registry_2 list : exit 30" \
    "registry -r registry_3 list : echo -" \
    "list $BUILDKITE_PLUGIN_ANKA_VM_NAME : exit 0" \
    "registry -r registry_3 pull $BUILDKITE_PLUGIN_ANKA_VM_NAME : echo pulled vm in anka" \
    "clone $BUILDKITE_PLUGIN_ANKA_VM_NAME ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo cloned vm in anka" \
    "run ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -c \"$BUILDKITE_COMMAND\" : echo ran command in anka"

  run $PWD/hooks/command

  assert_success

  unstub anka
  unset BUILDKITE_PLUGIN_ANKA_ALWAYS_PULL
  unset BUILDKITE_COMMAND
  unset BUILDKITE_PLUGIN_ANKA_VM_NAME
  unset BUILDKITE_JOB_ID
  unset BUILDKITE_PLUGIN_ANKA_FAILOVER_REGISTRIES
}

@test "Run with pre-execute-sleep" {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="macos-base-10.14"
  export BUILDKITE_COMMAND="ls -alht
env"
  export BUILDKITE_PLUGIN_ANKA_ALWAYS_PULL="true"
  export BUILDKITE_PLUGIN_ANKA_PRE_EXECUTE_SLEEP="5"

  stub anka \
    "list $BUILDKITE_PLUGIN_ANKA_VM_NAME : exit 0" \
    "registry pull $BUILDKITE_PLUGIN_ANKA_VM_NAME : echo pulled vm in anka" \
    "clone $BUILDKITE_PLUGIN_ANKA_VM_NAME ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo cloned vm in anka" \
    "run ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -c \"sleep ${BUILDKITE_PLUGIN_ANKA_PRE_EXECUTE_SLEEP}; ls -alht\" : echo ran command in anka" \
    "run ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -c \"sleep ${BUILDKITE_PLUGIN_ANKA_PRE_EXECUTE_SLEEP}; env\" : echo ran command in anka"

  run $PWD/hooks/command

  assert_success

  unstub anka
  unset BUILDKITE_PLUGIN_ANKA_PRE_EXECUTE_SLEEP

  stub anka \
    "list $BUILDKITE_PLUGIN_ANKA_VM_NAME : exit 0" \
    "registry pull $BUILDKITE_PLUGIN_ANKA_VM_NAME : echo pulled vm in anka" \
    "clone $BUILDKITE_PLUGIN_ANKA_VM_NAME ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo cloned vm in anka" \
    "run ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -c \"ls -alht\" : echo ran command in anka" \
    "run ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -c \"env\" : echo ran command in anka"

  run $PWD/hooks/command

  assert_success

  unset BUILDKITE_PLUGIN_ANKA_ALWAYS_PULL
  unset BUILDKITE_COMMAND
  unset BUILDKITE_PLUGIN_ANKA_VM_NAME
  unset BUILDKITE_JOB_ID
}

@test "Run with pre-execute-ping-sleep" {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="macos-base-10.14"
  export BUILDKITE_COMMAND="ls -alht
env"
  export BUILDKITE_PLUGIN_ANKA_ALWAYS_PULL="true"
  export BUILDKITE_PLUGIN_ANKA_PRE_EXECUTE_PING_SLEEP="8.8.8.8"

  stub anka \
    "list $BUILDKITE_PLUGIN_ANKA_VM_NAME : exit 0" \
    "registry pull $BUILDKITE_PLUGIN_ANKA_VM_NAME : echo pulled vm in anka" \
    "clone $BUILDKITE_PLUGIN_ANKA_VM_NAME ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo cloned vm in anka" \
    "run ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -c \"while ! ping -c1 ${BUILDKITE_PLUGIN_ANKA_PRE_EXECUTE_PING_SLEEP} | grep -v '\\---'; do sleep 1; done;ls -alht\" : echo ran command in anka" \
    "run ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -c \"while ! ping -c1 ${BUILDKITE_PLUGIN_ANKA_PRE_EXECUTE_PING_SLEEP} | grep -v '\\---'; do sleep 1; done;env\" : echo ran command in anka"

  run $PWD/hooks/command

  assert_success

  unstub anka
  unset BUILDKITE_PLUGIN_ANKA_PRE_EXECUTE_PING_SLEEP

  stub anka \
    "list $BUILDKITE_PLUGIN_ANKA_VM_NAME : exit 0" \
    "registry pull $BUILDKITE_PLUGIN_ANKA_VM_NAME : echo pulled vm in anka" \
    "clone $BUILDKITE_PLUGIN_ANKA_VM_NAME ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo cloned vm in anka" \
    "run ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -c \"ls -alht\" : echo ran command in anka" \
    "run ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -c \"env\" : echo ran command in anka"

  run $PWD/hooks/command

  assert_success

  unset BUILDKITE_PLUGIN_ANKA_ALWAYS_PULL
  unset BUILDKITE_COMMAND
  unset BUILDKITE_PLUGIN_ANKA_VM_NAME
  unset BUILDKITE_JOB_ID
}


@test "Modify" {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="macos-base-10.14"
  export BUILDKITE_COMMAND="ls -alht"
  export BUILDKITE_PLUGIN_ANKA_MODIFY_CPU="6"
  export BUILDKITE_PLUGIN_ANKA_MODIFY_RAM="32"

  stub anka \
    "list ${BUILDKITE_PLUGIN_ANKA_VM_NAME} : exit 0" \
    "clone ${BUILDKITE_PLUGIN_ANKA_VM_NAME} ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo cloned vm" \
    "list ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} | grep suspended : exit 0" \
    "stop ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo stopped" \
    "modify ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} set cpu 6 : echo set cpu 6" \
    "modify ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} set ram 32G : echo set ram 32G" \
    "run ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -c \"ls -alht\" : echo ls command run"

  run $PWD/hooks/command
  assert_success
  assert_output --partial "cloned vm"
  assert_output --partial "stopped"
  assert_output --partial "set cpu 6"
  assert_output --partial "set ram 32G"
  assert_output --partial "ls command"

  unstub anka
  unset BUILDKITE_PLUGIN_ANKA_MODIFY_RAM
  unset BUILDKITE_PLUGIN_ANKA_MODIFY_CPU
  unset BUILDKITE_PLUGIN_ANKA_BASH_INTERACTIVE
  unset BUILDKITE_COMMAND
  unset BUILDKITE_PLUGIN_ANKA_VM_NAME
  unset BUILDKITE_JOB_ID
  unset BUILDKITE_PLUGIN_ANKA_CLEANUP
}


@test "Modify --force" {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="macos-base-10.14"
  export BUILDKITE_COMMAND="ls -alht"
  export BUILDKITE_PLUGIN_ANKA_MODIFY_CPU="6"
  export BUILDKITE_PLUGIN_ANKA_MODIFY_RAM="32"
  export FORCED=true

  stub anka \
    "list ${BUILDKITE_PLUGIN_ANKA_VM_NAME} : exit 0" \
    "clone ${BUILDKITE_PLUGIN_ANKA_VM_NAME} ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo cloned vm" \
    "stop --force ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo stopped" \
    "modify ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} set cpu 6 : echo set cpu 6" \
    "modify ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} set ram 32G : echo set ram 32" \
    "run ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -c \"ls -alht\" : echo ls command run"

  run $PWD/hooks/command
  assert_output --partial "stopped"

  unstub anka
  unset BUILDKITE_PLUGIN_ANKA_MODIFY_RAM
  unset BUILDKITE_PLUGIN_ANKA_MODIFY_CPU
  unset BUILDKITE_PLUGIN_ANKA_BASH_INTERACTIVE
  unset BUILDKITE_COMMAND
  unset BUILDKITE_PLUGIN_ANKA_VM_NAME
  unset BUILDKITE_JOB_ID
  unset BUILDKITE_PLUGIN_ANKA_CLEANUP
}


@test "Lock file is created and deleted" {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="macos-base-10.14"
  export BUILDKITE_COMMAND="command"
  export BUILDKITE_PLUGIN_ANKA_ALWAYS_PULL="true"
  export LOCK_FILE="/tmp/anka-buildkite-plugin-lock"

  stub anka \
    "list ${BUILDKITE_PLUGIN_ANKA_VM_NAME} : exit 0" \
    "registry pull ${BUILDKITE_PLUGIN_ANKA_VM_NAME} : echo pulled vm in anka" \
    "clone ${BUILDKITE_PLUGIN_ANKA_VM_NAME} ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo cloned vm in anka" \
    "run ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} bash -c \"$BUILDKITE_COMMAND\" : echo ran command in anka"

  run $PWD/hooks/command

  assert_success
  assert_output --partial "Created ${LOCK_FILE}"
  assert_output --partial "Deleted ${LOCK_FILE}"

  unstub anka
  unset LOCK_FILE
  unset BUILDKITE_PLUGIN_ANKA_ALWAYS_PULL
  unset BUILDKITE_COMMAND
  unset BUILDKITE_PLUGIN_ANKA_VM_NAME
  unset BUILDKITE_JOB_ID
}
