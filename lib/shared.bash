#!/bin/bash

# Shows the command being run, and runs it
function plugin_prompt_and_run() {
  if [[ $(plugin_read_config DEBUG "false") =~ (true|on|1) ]] ; then
    echo -ne '\033[90m$\033[0m' >&2
    printf " %q" "$@" >&2
    echo >&2
  fi
  "$@"
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

function lock_file() {
  [[ -z "${1}" ]] && echo "lock_file function requires a single argument" && exit 1
  LOCK_FILE="/tmp/anka-buildkite-plugin-lock"
  if [[ $1 == "enable" ]]; then
    # Check if lock file already exists and prevent doing anything until it's deleted by the job which created it
    if [[ -f $LOCK_FILE ]]; then
      echo "Lock file found on host: Waiting for existing job ($(tail -1 $LOCK_FILE)) to remove lock file..."
      while [[ -f $LOCK_FILE ]]; do
        sleep 5
      done
    fi
    plugin_prompt_and_run echo $BUILDKITE_BUILD_URL > $LOCK_FILE
    echo "[Created ${LOCK_FILE}]"
  elif [[ $1 == "disable" ]]; then
    if [[ -f $LOCK_FILE ]]; then # Prevent echo and cleanup on pre-exit if it's not needed
      plugin_prompt_and_run rm -f $LOCK_FILE
      echo "[Deleted ${LOCK_FILE}]"
    fi
  else
    echo "Requires first argument is either 'enable' or 'disable'"
    exit 1
  fi
}

##############
# Anka --debug
export ANKA_DEBUG=${ANKA_DEBUG:-""}
export BUILDKITE_PLUGIN_ANKA_ANKA_DEBUG=$(plugin_read_config ANKA_DEBUG false)
$BUILDKITE_PLUGIN_ANKA_ANKA_DEBUG && export ANKA_DEBUG="--debug" || true
