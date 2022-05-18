[![License](https://img.shields.io/badge/license-MIT-blue)](./LICENSE)
[![Ubuntu](https://img.shields.io/badge/ubuntu-20.04-orange)](https://ubuntu.com)
[![Ubuntu](https://img.shields.io/badge/ubuntu-22.04-orange)](https://ubuntu.com)

[![ARM64](https://img.shields.io/badge/linux%2farm64-Yes-red)](./LICENSE)
[![AMD64](https://img.shields.io/badge/linux%2famd64-Yes-red)](./LICENSE)
[![AMD64](https://img.shields.io/badge/linux%2farm%2fv7-Yes-red)](./LICENSE)

# NRF Dev Environment

Copyright (c) 2022, Greg PFISTER. MIT License

<div id="about" />

## About

This is a simple Ubuntu container to use as base image for building development
to be used as Visual Studio Code Remote Container.

This is image is provided with both Ubuntu 20.04 and Ubuntu 22.04.

Along with the basic requirements, the image provides:

- zsh
- vim with a few plugins (airline, syntastic, ripgrep, nerdcommenter,
  vim-colorschemes, ctrlp.vim)
- additionnal tools like `less`, `curl`, `nmap`, `htop`, ...
- a `vscode` user account
- `sudo` passwordless commands
- `tmux`

<div id="volumes" />

## Volumes

In order to persist user data, a volume for the /home folder is set. The root
user will not be persisted.

| Volume | Description                                        |
| ------ | -------------------------------------------------- |
| /home  |  Persist the user data stored in their home folder |

<div id="build-run-scan-push" />

## Build, scan and push

### A word about in progress developments

When you are making change to the image, use :develop at the end of the
[build](#build), [run](#run) and [scan](#scan) commands. The `develop` tag
should not be pushed...

### A word about cross-platform building

In order to build x-platform, `docker buildx` must be enabled (more info
[here](https://docs.docker.com/buildx/working-with-buildx/)). Then, instead of
`build` command, `buildx` command should be used (for example:
`npm run buildx:develop` will create a cross-platform image tagged `develop`).

You will need to create a multiarch builder:

```sh
$ docker buildx create --name multiarch
```

Then, prior to building, you need to use it (example output on Mac M1):

```sh
$ docker buildx use multiarch && docker buildx inspect --bootstrap

[+] Building 5.8s (1/1) FINISHED
 => [internal] booting buildkit                                             5.8s
 => => pulling image moby/buildkit:buildx-stable-1                            7s
 => => creating container buildx_buildkit_multiarch0                          1s
Name:   multiarch
Driver: docker-container

Nodes:
Name:      multiarch0
Endpoint:  unix:///var/run/docker.sock
Status:    running
Platforms: linux/arm64, linux/amd64, linux/amd64/v2, linux/riscv64,
           linux/ppc64le, linux/s390x, linux/386, linux/mips64le, linux/mips64,
           linux/arm/v7, linux/arm/v6
```

`Ubuntu 20.04` been exclusively x64, only x64 architecture must be considered.

<div id="build" />

### Build

To build the image for upload, using the versionning in `package.json`, simply
run:

```sh
$ npm run build
```

It will create and image `gpfister/nrf-devenv` tagged with the version in the
`package.json` file and `latest`. For example:

```sh
$ sdocker images
REPOSITORY                                                TAG       IMAGE ID       CREATED          SIZE
gpfister/nrf-devenv                                       0.1.0     5fe9772cc4d1   23 minutes ago   1.28GB
gpfister/nrf-devenv                                       latest    5fe9772cc4d1   23 minutes ago   1.28GB
```

You may alter the `package.json` should you want to have different tags or
names, however if you PR your change, it will be rejected. The ideal solution
is to run the `docker build` command instead of the changing the provided
scripts.

<div id="run" />

## Run a container

To run an interactive container, simple use:

```sh
$ npm run start
```

It should create a container and name it `nrf-devenv-<VERSION>-test`.

<div id="scan" />

### Scan

To scan the image, simple run:

```sh
npm run scan
```

<div id="build-from-this-image" />

## Build from this image

Should you want to make other changes, the ideal solution is to build from this
image. For example, here's the way to set the image to a different timezone than
"Europe/Paris" (the default one):

```Dockerfile
FROM gpfister/nrf-devenv:latest

ENV TZ="America/New_York"

# Switch to root
USER root

# Reconfigure tzdata
RUN dpkg-reconfigure -f noninteractive tzdata

# Switch back to vscode
USER vscode
```

**Important:** unless you really want to use the root user, you should always
make sure the `vscode` is the last one activate.

<div id="faq" />

## FAQ

1. [How to require password for sudo command ?](#faq1)

<div id="faq1" />

### 1. How to require password for sudo command ?

You will have to [build from this image](#build-from-this-image) to disable the
the password less sudo command. Typically create a `Dockerfile` like:

```Dockerfile
FROM gpfister/nrf-devenv:latest

ARG VSCODE_PASSWORD="dummy"

# Switch to root to make changes
USER root

# Remove the specific config for sudo and add to sudo group
RUN rm /etc/sudoers.d/vscode && \
    usermod -aG sudo vscode

# Change the password.
RUN usermod -p $VSCODE_PASSWORD vscode

# Switch back to vscode
USER vscode
```

If you simply want to get rid of `sudo`:

```Dockerfile

FROM gpfister/nrf-devenv:latest

# Switch to root to make changes
USER root

# Remove the specific config for sudo and add to sudo group
RUN rm /etc/sudoers.d/vscode && \
    apt-get purge -y sudo

# Switch back to vscode
USER vscode
```

<div id="contrib" />

## Contributions

See instructions [here](./CONTRIBUTING.md).

<div id="license" />

## License

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

See license [here](./LICENSE).
