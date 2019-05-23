#!/usr/bin/env bats

. "lib/shared.bash"

@test "Run with failure" {
  run plugin_prompt_and_run builddude
  # assert_output --partial "echo downloaded artifact2"
  [[ $status -eq 127 ]] || ( echo "Status must be 127" >&3 && exit 1 )
  run exit 5
  # assert_output --partial "echo downloaded artifact2"
  [[ $status -eq 5 ]] || ( echo "Status must be 5" >&3 && exit 1 )
}
