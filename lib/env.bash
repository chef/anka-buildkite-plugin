#!/bin/bash


debug_mode='off'
if [[ "${BUILDKITE_PLUGIN_ANKA_DEBUG:-false}" =~ (true|on|1) ]] ; then
  debug_mode='on'
fi

job_image_name="${BUILDKITE_PLUGIN_ANKA_VM_NAME}-${BUILDKITE_JOB_ID}"

#
# Parse out all the run command options
#   anka run --help
#
args=()
# Working directory inside the VM
if [[ -n "${BUILDKITE_PLUGIN_ANKA_WORKDIR:-}" ]] ; then
  args+=("--workdir" "${BUILDKITE_PLUGIN_ANKA_WORKDIR:-.}")
fi
# Mount host directory (current directory by default)
if [[ -n "${BUILDKITE_PLUGIN_ANKA_VOLUME:-}" ]] ; then
  args+=("--volume" "${BUILDKITE_PLUGIN_ANKA_VOLUME:-}")
fi
# Prevent the mounting of the host directory
if [[ "${BUILDKITE_PLUGIN_ANKA_NO_VOLUME:-false}" =~ (true|on|1) ]] ; then
  args+=("--no-volume")
fi
# Inherit environment variables from host
if [[ "${BUILDKITE_PLUGIN_ANKA_INHERIT_ENVIRONMENT_VARS:-false}" =~ (true|on|1) ]] ; then
  args+=("--env")
fi
# Provide an environment variable file
if [[ -n "${BUILDKITE_PLUGIN_ANKA_ENVIRONMENT_FILE:-}" ]] ; then
  args+=("--env-file" "${BUILDKITE_PLUGIN_ANKA_ENVIRONMENT_FILE:-}")
fi
# Wait to start processing until network can be established
if [[ "${BUILDKITE_PLUGIN_ANKA_WAIT_NETWORK:-false}" =~ (true|on|1) ]] ; then
  args+=("--wait-network")
fi
args+=("$job_image_name")