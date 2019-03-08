#!/bin/bash

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