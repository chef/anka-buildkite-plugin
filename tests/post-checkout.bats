#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# Uncomment to enable stub debug output:
# export ANKA_STUB_DEBUG=/dev/tty

setup() {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="10.14"
}

teardown() {
  unstub anka

  unset BUILDKITE_JOB_ID
  unset BUILDKITE_PLUGIN_ANKA_VM_NAME
}

@test "Run with START_DEVICES (yaml list)" {
  export BUILDKITE_PLUGIN_ANKA_START_DEVICES="iphone1
iphone2"

  stub anka \
    "clone 10.14 10.14-UUID : echo 'cloned vm'" \
    "list 10.14-UUID | grep suspended : exit 0" \
    "stop 10.14-UUID : echo 'stopped'" \
    "start -d iphone1 -d iphone2 10.14-UUID : echo 'started with devices'"

  run $PWD/hooks/post-checkout

  assert_success
  assert_output --partial "cloned vm"
  assert_output --partial "stopped"
  assert_output --partial "started with devices"

  unset BUILDKITE_PLUGIN_ANKA_START_DEVICES
}

@test "Modify" {
  export BUILDKITE_PLUGIN_ANKA_MODIFY_CPU="6"
  export BUILDKITE_PLUGIN_ANKA_MODIFY_RAM="32"
  export BUILDKITE_PLUGIN_ANKA_MODIFY_MAC="00:1B:44:11:3A:B7"

  stub anka \
    "clone 10.14 10.14-UUID : echo 'cloned vm'" \
    "list 10.14-UUID | grep suspended : exit 0" \
    "stop 10.14-UUID : echo 'stopped'" \
    "modify 10.14-UUID set cpu 6 : echo 'set cpu 6'" \
    "modify 10.14-UUID set ram 32G : echo 'set ram 32G'" \
    "modify 10.14-UUID set network-card --mac 00:1B:44:11:3A:B7 : echo 'set network-card mac address to 00:1B:44:11:3A:B7'"

  run $PWD/hooks/post-checkout

  assert_success
  assert_output --partial "cloned vm"
  assert_output --partial "stopped"
  assert_output --partial "set cpu 6"
  assert_output --partial "set ram 32G"
  assert_output --partial "set network-card mac address to 00:1B:44:11:3A:B7"

  unset BUILDKITE_PLUGIN_ANKA_MODIFY_MAC
  unset BUILDKITE_PLUGIN_ANKA_MODIFY_RAM
  unset BUILDKITE_PLUGIN_ANKA_MODIFY_CPU
}

@test "Modify CPU Failure" {
  export BUILDKITE_PLUGIN_ANKA_MODIFY_CPU="t"

  stub anka \
    "clone 10.14 10.14-UUID : echo 'cloned vm'" \
    "list 10.14-UUID | grep suspended : exit 0" \
    "stop 10.14-UUID : echo 'stopped'"

  run $PWD/hooks/post-checkout

  assert_failure
  assert_output --partial "cloned vm"
  assert_output --partial "stopped"
  assert_output --partial "Acceptable input"

  unset BUILDKITE_PLUGIN_ANKA_MODIFY_CPU
}

@test "Modify RAM Failure" {
  export BUILDKITE_PLUGIN_ANKA_MODIFY_RAM="t"

  stub anka \
    "clone 10.14 10.14-UUID : echo 'cloned vm'" \
    "list 10.14-UUID | grep suspended : exit 0" \
    "stop 10.14-UUID : echo 'stopped'"

  run $PWD/hooks/post-checkout

  assert_failure
  assert_output --partial "cloned vm"
  assert_output --partial "stopped"
  assert_output --partial "Acceptable input"

  unset BUILDKITE_PLUGIN_ANKA_MODIFY_RAM
}

@test "Modify MAC Failure" {
  export BUILDKITE_PLUGIN_ANKA_MODIFY_MAC="192.14"

  stub anka \
    "clone 10.14 10.14-UUID : echo 'cloned vm'" \
    "list 10.14-UUID | grep suspended : exit 0" \
    "stop 10.14-UUID : echo 'stopped'"

  run $PWD/hooks/post-checkout

  assert_failure
  assert_output --partial "cloned vm"
  assert_output --partial "stopped"
  assert_output --partial "Acceptable input"

  unset BUILDKITE_PLUGIN_ANKA_MODIFY_MAC
}

@test "Modify --force" {
  export BUILDKITE_PLUGIN_ANKA_MODIFY_CPU="6"
  export BUILDKITE_PLUGIN_ANKA_MODIFY_RAM="32"
  export FORCED=true

  stub anka \
    "clone 10.14 10.14-UUID : echo 'cloned vm'" \
    "stop --force 10.14-UUID : echo 'stopped'" \
    "modify 10.14-UUID set cpu 6 : echo 'set cpu 6'" \
    "modify 10.14-UUID set ram 32G : echo 'set ram 32'"

  run $PWD/hooks/post-checkout

  assert_output --partial "stopped"

  unset BUILDKITE_PLUGIN_ANKA_MODIFY_RAM
  unset BUILDKITE_PLUGIN_ANKA_MODIFY_CPU
  unset FORCED
}
