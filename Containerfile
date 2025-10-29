# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# https://github.com/ublue-os/bazzite/pkgs/container/bazzite/533271084?tag=stable-42.20251002
FROM ghcr.io/ublue-os/bazzite:stable-43.20251028@sha256:948e826f332117c459390792dff651b64c55babe281b0d73ffd58673d17573ae

## Other possible base images include:
# FROM ghcr.io/ublue-os/bazzite:latest
# FROM ghcr.io/ublue-os/bluefin-nvidia:stable
# 
# ... and so on, here are more base images
# Universal Blue Images: https://github.com/orgs/ublue-os/packages
# Fedora base image: quay.io/fedora/fedora-bootc:41
# CentOS base images: quay.io/centos-bootc/centos-bootc:stream10

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh

