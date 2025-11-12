#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOST_KEYS_DIR="${SCRIPT_DIR}/host_keys"

mkdir -p "${HOST_KEYS_DIR}"

ssh-keygen -t rsa -b 4096 -f "${HOST_KEYS_DIR}/ssh_host_rsa_key" -N "" -C ""
ssh-keygen -t ecdsa -b 521 -f "${HOST_KEYS_DIR}/ssh_host_ecdsa_key" -N "" -C ""
ssh-keygen -t ed25519 -f "${HOST_KEYS_DIR}/ssh_host_ed25519_key" -N "" -C ""

chmod 600 "${HOST_KEYS_DIR}"/ssh_host_*_key
chmod 644 "${HOST_KEYS_DIR}"/ssh_host_*_key.pub
