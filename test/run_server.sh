#!/usr/bin/env bash

set -euo pipefail

SSHD="$(git rev-parse --show-toplevel)/result/bin/sshd"
WORKDIR="$(git rev-parse --show-toplevel)/test"

cd $WORKDIR
sudo $SSHD -D -ddd -e -f sshd_config
