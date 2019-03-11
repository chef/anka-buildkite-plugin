#!/bin/bash
## Make sure this file is loaded before env.bash (for pull support)

cleanup() {
  if [[ $1 == "on" ]]; then
    echo "--- :anka: Cleaning up images"
    anka delete --yes "$job_image_name"
    echo "$job_image_name has been deleted"
  else
    echo "--- :anka: Suspending VM"
    anka suspend $job_image_name
    echo "$job_image_name has been suspended"
  fi
}

pull() {
  echo "--- :anka: Pulling $BUILDKITE_PLUGIN_ANKA_VM_NAME from Anka Registry"
  if [[ "${debug_mode:-off}" =~ (on) ]] ; then
    echo "$ anka registry pull ${pull_args[*]} $BUILDKITE_PLUGIN_ANKA_VM_NAME" >&2
  fi
  # || true so we don't cripple our pipelines should the registry be down
  eval "anka registry pull ${pull_args[*]} $BUILDKITE_PLUGIN_ANKA_VM_NAME || true"
}