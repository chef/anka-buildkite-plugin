#!/bin/bash

version=$(cat VERSION)

# Update the README to reflect the latest version
file-mod find-and-replace "(anka\\#)(\S+)$" "\${1}$version\\:" README.md
