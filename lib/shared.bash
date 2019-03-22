#!/bin/bash

# Show a prompt for a command
function plugin_prompt() {
  if [[ $(plugin_read_config DEBUG "false") =~ (true|on|1) ]] ; then
    echo -ne '\033[90m$\033[0m' >&2
    printf " %q" "$@" >&2
    echo >&2
  fi
}

# Shows the command being run, and runs it
function plugin_prompt_and_run() {
  plugin_prompt "$@"
  "$@"
}

# Shows the command about to be run, and exits if it fails
function plugin_prompt_and_must_run() {
  plugin_prompt_and_run "$@" || exit
}

# Shorthand for reading env config
function plugin_read_config() {
  local var="BUILDKITE_PLUGIN_ANKA_${1}"
  local default="${2:-}"
  echo "${!var:-$default}"
}

# Reads either a value or a list from plugin config
function plugin_read_list() {
  prefix_read_list "BUILDKITE_PLUGIN_ANKA_$1"
}

# Reads either a value or a list from the given env prefix
function prefix_read_list() {
  local prefix="$1"
  local parameter="${prefix}_0"

  if [[ -n "${!parameter:-}" ]]; then
    local i=0
    local parameter="${prefix}_${i}"
    while [[ -n "${!parameter:-}" ]]; do
      echo "${!parameter}"
      i=$((i+1))
      parameter="${prefix}_${i}"
    done
  elif [[ -n "${!prefix:-}" ]]; then
    echo "${!prefix}"
  fi
}

function in_array() {
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}
