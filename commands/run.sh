#!/bin/bash
set -ueo pipefail

echo "--- :anka: Cloning $BUILDKITE_PLUGIN_ANKA_VM_NAME to $job_image_name"

if [[ "${debug_mode:-off}" =~ (on) ]] ; then
  echo "$ anka clone $BUILDKITE_PLUGIN_ANKA_VM_NAME $job_image_name" >&2
fi
anka clone "$BUILDKITE_PLUGIN_ANKA_VM_NAME" "$job_image_name"

# Support for yaml command lists: https://github.com/chef/anka-buildkite-plugin/issues/4
O_IFS=$IFS
IFS=$'\n' 
BUILDKITE_COMMANDS=($(echo "$BUILDKITE_COMMAND"))
IFS=$O_IFS
for COMMAND in "${BUILDKITE_COMMANDS[@]}"; do  
  echo "+++ Executing $COMMAND in $job_image_name"
  if [[ "${debug_mode:-off}" =~ (on) ]] ; then echo "$ anka run ${args[*]} $COMMAND" >&2; fi
  eval "anka run ${args[*]} bash -c \"${COMMAND}\""
done


