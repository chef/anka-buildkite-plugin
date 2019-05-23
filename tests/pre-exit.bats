#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# Uncomment to enable stub debug output:
# export ANKA_STUB_DEBUG=/dev/tty


@test "Cleanup of lock file" {
  export BUILDKITE_JOB_ID="UUID"
  export BUILDKITE_PLUGIN_ANKA_VM_NAME="macos-base-10.14"
  export BUILDKITE_COMMAND="ls -alht"

  stub anka \
    "delete --yes ${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID} : echo deleted vm in anka"
    
  touch /tmp/anka-buildkite-plugin-lock

  run $PWD/hooks/pre-exit

  assert_success
  assert_output --partial "Deleted /tmp/anka-buildkite-plugin-lock"

  unstub anka
  unset BUILDKITE_COMMAND
  unset BUILDKITE_PLUGIN_ANKA_VM_NAME
  unset BUILDKITE_JOB_ID
}

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
