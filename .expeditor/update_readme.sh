#!/bin/bash

version=$(cat VERSION)

# Update the README to reflect the latest version
file-mod find-and-replace "(?m)(chef\\/anka\\#)\S+$" "\${1}v${version}:" README.md
