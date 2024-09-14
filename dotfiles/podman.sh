#!/bin/bash

# shellcheck disable=SC1091
. "${HOME}/dotfiles/github_install.sh"

# install podman cli
download_and_install_pkg_from_github "containers/podman" "podman-installer-macos-arm64.pkg"
PODMAN_CMD="/opt/podman/bin/podman"
if ! "$PODMAN_CMD" machine inspect podman-machine-default; then 
	"$PODMAN_CMD" machine init --disk-size 30 --memory 4096 podman-machine-default
fi
