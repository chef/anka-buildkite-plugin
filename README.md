# Anka Buildkite Plugin

A [Buildkite plugin](https://buildkite.com/docs/agent/v3/plugins) for running pipeline steps in [Anka](https://ankadoc.bitbucket.io/#introduction) virtual machines.

> At this time, this plugin does not automatically mount the `buildkite-agent` or inject any `BUILDKITE_` environment variables.

## Example

```yml
steps:
  - command: make test
    plugins:
      chef/anka#v0.1.1:
        vm-name: macos-base-10.14
```

## Configuration

### `vm-name` (required)

The name of the Anka virtual machine to use as the base. The plugin will create a step-specific clone prior to execution.

Example: `macos-base-10.14`

### `vm-registry-tag` (optional)

A tag associated with the VM you wish to pull from the Anka Registry.

Example: `latest`

### `vm-registry-version` (optional)

A version associated with the VM you wish to pull from the Anka Registry.

Example: `1`

### `always-pull` (optional)

By default, the `anka-buildkite-plugin` will only pull the VM from the Anka Registry is missing. Set this value to `true` if you wish to pull the VM for every step.

Example: `true`

### `inherit-environment-vars` (optional)

Set this to `true` to inject the environment variables set on your host into the Anka VM.

Example: `true`

### `environment-file` (optional)

The path to a file containing environment variables you wish to inject into you Anka VM.

Example: `./my-env.txt`

### `no-volume` (optional)

Set this to `true` if you do not wish to mount the current directory into the Anka VM.

Example: `true`

### `volume` (optional)

The path to a directory, other than the current directory, you wish to mount into the Anka VM.

Example: `/some/directory`

### `wait-network` (optional)

Set this to `true` if you wish to delay the execution of your `command` until networking has been established in the Anka VM.

Example: `true`

### `workdir` (optional)

The fully-qualified path of the working directory inside the Anka VM.

Example: `/some/directory`

### `debug` (optional)

Set this to `true` to enable debug output within the plugin.

Example: `true`

### `cleanup` (optional)

Set this to `false` to leave the cloned images in a failed build for investigation.

Example: `false`

## License

|                      |                                          |
|:---------------------|:-----------------------------------------|
| **Author:**          | Tom Duffield (<tom@chef.io>)
| **Copyright:**       | Copyright 2018, Chef Software, Inc.
| **License:**         | Apache License, Version 2.0

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
