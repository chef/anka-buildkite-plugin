#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# Uncomment to enable stub debug output:
# export BUILDKITE_PLUGIN_ANKA_DEBUG=true

@test "Execute POST_COMMANDS (yaml list)" {
  export BUILDKITE_PLUGIN_ANKA_POST_COMMANDS="echo 123 && echo 456
echo got 123 && echo \" got 456 \"
buildkite-agent artifact upload \"build.tar.gz\"
buildkite-agent artifact upload \"build.tar.gz\""

  stub buildkite-agent \
    'artifact upload "build.tar.gz" : echo "upload artifact 1"' \
    'artifact upload "build.tar.gz" : echo "upload artifact 2"'

  run $PWD/hooks/post-command

  assert_success
  assert_output --partial "123"
  assert_output --partial "456"
  assert_output --partial "got 123"
  assert_output --partial " got 456"
  assert_output --partial "upload artifact 1"
  assert_output --partial "upload artifact 2"

  unstub buildkite-agent
  unset BUILDKITE_PLUGIN_ANKA_POST_COMMANDS
}