# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.177.0/containers/rust/.devcontainer/base.Dockerfile

FROM mcr.microsoft.com/vscode/devcontainers/rust:0-1

# [Optional] Uncomment this section to install additional packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends nasm qemu-system gdb python3-pip python3 python3-dev

RUN rustup toolchain install nightly && \
    rustup toolchain install nightly --component rust-src

RUN pip3 install setuptools wheel && \
    pip3 install pwntools
