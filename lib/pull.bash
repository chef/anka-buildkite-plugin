#!/bin/bash
set -ueo pipefail

if ( ! anka list "$BUILDKITE_PLUGIN_ANKA_VM_NAME" ) || [[ "${BUILDKITE_PLUGIN_ANKA_ALWAYS_PULL:-false}" =~ (true|on|1) ]]; then
  pull_args=()
  if [[ -n "${BUILDKITE_PLUGIN_ANKA_VM_REGISTRY_TAG:-}" ]]; then
    pull_args+=("--tag" "${BUILDKITE_PLUGIN_ANKA_VM_REGISTRY_TAG:-}")
  fi
  if [[ -n "${BUILDKITE_PLUGIN_ANKA_VM_REGISTRY_VERSION:-}" ]]; then
    pull_args+=("--version" "${BUILDKITE_PLUGIN_ANKA_VM_REGISTRY_VERSION:-}")
  fi
  echo "--- :anka: Pulling $BUILDKITE_PLUGIN_ANKA_VM_NAME from Anka Registry"
  if [[ "${debug_mode:-off}" =~ (on) ]] ; then
    echo "$ anka registry pull ${pull_args[*]} $BUILDKITE_PLUGIN_ANKA_VM_NAME" >&2
  fi
  # || true so we don't cripple our pipelines should the registry be down
  eval "anka registry pull ${pull_args[*]} $BUILDKITE_PLUGIN_ANKA_VM_NAME || true"
else
  echo ":anka: $BUILDKITE_PLUGIN_ANKA_VM_NAME is already present on the host"
fi