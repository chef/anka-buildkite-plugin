#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# Uncomment to enable stub debug output:
# export BUILDKITE_AGENT_STUB_DEBUG=/dev/tty

@test "Execute with PRE_COMMANDS (yaml list)" {
  export BUILDKITE_PLUGIN_ANKA_PRE_COMMANDS="echo 123 && echo 456
echo got 123 && echo \" got 456 \"
buildkite-agent artifact download \"build.tar.gz\" . --step \":aws: Amazon Linux 1 Build\"
buildkite-agent artifact download \"build.tar.gz\" . --step \":aws: Amazon Linux 2 Build\""

  stub buildkite-agent \
    'artifact download "build.tar.gz" . --step ":aws: Amazon Linux 1 Build" : echo "downloaded artifact 1"' \
    'artifact download "build.tar.gz" . --step ":aws: Amazon Linux 2 Build" : echo "downloaded artifact 2"'

  run $PWD/hooks/pre-command

  assert_success
  assert_output --partial "123"
  assert_output --partial "456"
  assert_output --partial "got 123"
  assert_output --partial " got 456"
  assert_output --partial "downloaded artifact 1"
  assert_output --partial "downloaded artifact 2"

  unstub buildkite-agent
  unset BUILDKITE_PLUGIN_ANKA_PRE_COMMANDS
}
