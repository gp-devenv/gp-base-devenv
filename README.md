[![License](https://img.shields.io/badge/license-MIT-blue)](./LICENSE)
[![Ubuntu](https://img.shields.io/badge/ubuntu-20.04-orange)](https://ubuntu.com)
[![Ubuntu](https://img.shields.io/badge/ubuntu-22.04-orange)](https://ubuntu.com)
[![Docker](https://img.shields.io/badge/docker-hub-blue)](https://hub.docker.com/repository/docker/gpfister/base-devenv)

[![ARM64](https://img.shields.io/badge/linux%2farm64-Yes-red)](https://hub.docker.com/repository/docker/gpfister/base-devenv/tags)
[![AMD64](https://img.shields.io/badge/linux%2famd64-Yes-red)](https://hub.docker.com/repository/docker/gpfister/base-devenv/tags)

# Base Dev Environment

Copyright (c) 2022, Greg PFISTER. MIT License

<div id="about" />

## About

This is a simple Ubuntu container to use as base image for building development
to be used as Visual Studio Code Remote Container.

This is image is provided with both Ubuntu 20.04 and Ubuntu 22.04.

Along with the basic requirements, the image provides:

- zsh + starship
- vim with a few plugins (airline, syntastic, ripgrep, nerdcommenter,
  vim-colorschemes, ctrlp.vim)
- additionnal tools like `less`, `curl`, `nmap`, `htop`, ...
- a `vscode` user account
- `sudo` passwordless commands
- `tmux`

The image can be found on
[Docker Hub](https://hub.docker.com/repository/docker/gpfister/base-devenv).

The following image are using this base image:

- [firebase-devenv](https://hub.docker.com/repository/docker/gpfister/firebase-devenv):
  Provide a base image to build a Firebase dev container for VS Code.

<div id="volumes" />

## Volumes

In order to persist user data, a volume for the /home folder is set. The root
user will not be persisted.

| Volume | Description                                        |
| ------ | -------------------------------------------------- |
| /home  |  Persist the user data stored in their home folder |

<div id="build-run-scan-push" />

## Build, scan and push

### A word about image version formatting

Image version contains the Ubuntu version and the build version, using the format
`<Ubuntu version>-<Build version>` (e.g. 22.04-0.1.0).

For CI/CD, the version is store in `.version` file.

The version is in the format [SemVer](https://en.wikipedia.org/wiki/Software_versioning#Semantic_versioning).

### A word about developments

When you are making change to the image, use :develop at the end of the
[build](#build), [run](#run) and [scan](#scan) commands. The `develop` tag
should not be pushed...

### Cross-platform building

#### Setup

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

`Ubuntu` (both 20.04 and 22.04) been exclusively x64, only x64 architecture are
supported.

#### Build commands

Once the previous step is completed, simpy run to build the current version:

```sh
docker buildx build --platform linux/arm64,linux/amd64 -t gpfister/base-devenv:20.04-`cat .version` -f Dockerfile-20.04 .
docker buildx build --platform linux/arm64,linux/amd64 -t gpfister/base-devenv:22.04-`cat .version` -f Dockerfile-22.04 .
```

<div id="build" />

### Build using local architecture

To build the image for upload, using the versionning in `package.json`, simply
run:

```sh
$ npm run build
```

It will create and image `gpfister/nrf-devenv` tagged with the version in the
`package.json` file and `latest`. For example:

```sh
REPOSITORY                       TAG               IMAGE ID       CREATED          SIZE
gpfister/base-devenv             22.04             21a32a4c2177   11 minutes ago   916MB
gpfister/base-devenv             20.04             466450fda71c   12 minutes ago   873MB
```

You may alter the `package.json` should you want to have different tags or
names, however if you PR your change, it will be rejected. The ideal solution
is to run the `docker build` command instead of the changing the provided
scripts.

<div id="run" />

## Run a container

To run an interactive container, simple use:

| Ubuntu       | Command                                                                        |
| ------------ | ------------------------------------------------------------------------------ |
| Ubunto 20.04 |  `docker build --no-cache -t gpfister/base-devenv:20.04 -f Dockerfile-20.04 .` |
| Ubunto 22.04 |  `docker build --no-cache -t gpfister/base-devenv:22.04 -f Dockerfile-22.04 .` |

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

# Update all packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get autoremove -y && \
    apt-get autoclean

# Switch back to vscode
USER vscode
```

**Important:** Unless you really want to use the root user, you should always
make sure the `vscode` is the last one activated.

**Updating the image:** There is yet no plan to create nighly build, ensuring
the image is always up to date. Therefore, when building yours from this one,
run the update process.

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
