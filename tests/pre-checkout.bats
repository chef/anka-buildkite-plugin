#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# Uncomment to enable stub debug output:
# export ANKA_STUB_DEBUG=/dev/tty

setup() {
  export BUILDKITE_BUILD_URL="https://buildkite.com/repo/name/builds/12034"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="10.14"
}

teardown() {
  unstub anka
  unset BUILDKITE_PLUGIN_ANKA_VM_NAME
}

@test "Pulls down VM when VM is missing" {
  stub anka \
    "list 10.14 : exit 1" \
    "registry pull 10.14 : echo 'pulled vm in anka'"

  run $PWD/hooks/pre-checkout

  assert_success
  assert_output --partial "pulled vm in anka"
}

@test "Pulls down VM when VM is missing and has tag" {
  export BUILDKITE_PLUGIN_ANKA_VM_REGISTRY_TAG="my-tag"

  stub anka \
    "list 10.14 : exit 1" \
    "registry pull --tag my-tag 10.14 : echo 'pulled vm in anka'"

  run $PWD/hooks/pre-checkout

  assert_success
  assert_output --partial "pulled vm in anka"

  unset BUILDKITE_PLUGIN_ANKA_VM_REGISTRY_TAG
}


@test "Pulls down VM when VM is missing and has version" {
  export BUILDKITE_PLUGIN_ANKA_VM_REGISTRY_VERSION="1"

  stub anka \
    "list 10.14 : exit 1" \
    "registry pull --version 1 10.14 : echo 'pulled vm in anka'"

  run $PWD/hooks/pre-checkout

  assert_success
  assert_output --partial "pulled vm in anka"

  unset BUILDKITE_PLUGIN_ANKA_VM_REGISTRY_VERSION
}

@test "Pulls down VM when VM is always pulled" {
  export BUILDKITE_PLUGIN_ANKA_ALWAYS_PULL="true"

  stub anka \
    "list 10.14 : exit 0" \
    "registry pull 10.14 : echo 'pulled vm in anka'"

  run $PWD/hooks/pre-checkout

  assert_success
  assert_output --partial "pulled vm in anka"

  unset BUILDKITE_PLUGIN_ANKA_ALWAYS_PULL
}

@test "Pulls down VM when VM is always pulled (shrink)" {
  export BUILDKITE_PLUGIN_ANKA_ALWAYS_PULL="shrink"

  stub anka \
    "list 10.14 : exit 0" \
    "registry pull -s 10.14 : echo 'pulled vm in anka'"

  run $PWD/hooks/pre-checkout

  assert_success
  assert_output --partial "pulled vm in anka"

  unset BUILDKITE_PLUGIN_ANKA_ALWAYS_PULL
}

@test "Lock file is created and deleted" {
  export BUILDKITE_PLUGIN_ANKA_ALWAYS_PULL="true"
  export LOCK_FILE="/tmp/anka-buildkite-plugin-lock"

  stub anka \
    "list 10.14 : exit 0" \
    "registry pull 10.14 : echo 'pulled vm in anka'"

  run $PWD/hooks/pre-checkout

  assert_success
  assert_output --partial "Created ${LOCK_FILE}"
  assert_output --partial "Deleted ${LOCK_FILE}"

  unset LOCK_FILE
  unset BUILDKITE_PLUGIN_ANKA_ALWAYS_PULL
}

@test "Run with registry-failover" {
  export BUILDKITE_PLUGIN_ANKA_ALWAYS_PULL="true"
  export BUILDKITE_PLUGIN_ANKA_FAILOVER_REGISTRIES='registry_1
registry_2
registry_3'

  stub anka \
    "registry list : echo -" \
    "list $BUILDKITE_PLUGIN_ANKA_VM_NAME : exit 0" \
    "registry pull $BUILDKITE_PLUGIN_ANKA_VM_NAME : echo 'pulled vm in anka'"

  run $PWD/hooks/pre-checkout

  assert_success

  stub anka \
    "registry list : exit 30" \
    "registry list-repos -d : echo '| id     | registry_1  |'" \
    "registry -r registry_2 list : echo -" \
    "list $BUILDKITE_PLUGIN_ANKA_VM_NAME : exit 0" \
    "registry -r registry_2 pull $BUILDKITE_PLUGIN_ANKA_VM_NAME : echo 'pulled vm in anka'"

  run $PWD/hooks/pre-checkout

  assert_success

  stub anka \
    "registry list : exit 30" \
    "registry list-repos -d : echo '| id     | registry_1  |'" \
    "registry -r registry_2 list : exit 30" \
    "registry -r registry_3 list : echo -" \
    "list $BUILDKITE_PLUGIN_ANKA_VM_NAME : exit 0" \
    "registry -r registry_3 pull $BUILDKITE_PLUGIN_ANKA_VM_NAME : echo 'pulled vm in anka'"

  run $PWD/hooks/pre-checkout

  assert_success

  unset BUILDKITE_PLUGIN_ANKA_ALWAYS_PULL
  unset BUILDKITE_PLUGIN_ANKA_FAILOVER_REGISTRIES
}
