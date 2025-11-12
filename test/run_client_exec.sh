#!/usr/bin/env bash

set -euo pipefail

SSH="$(git rev-parse --show-toplevel)/result/bin/ssh"
WORKDIR="$(git rev-parse --show-toplevel)/test"

cd $WORKDIR
$SSH -o Ciphers=none -p 2222 root@localhost 'whoami'
