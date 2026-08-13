#!/bin/bash
#
# SurimaOS build: 7.13.1. Cleaning
# Run INSIDE the chroot environment, as root.

set -e

if [ "$(whoami)" != "root" ]; then
  echo "ERROR: this must be run as root, currently running as $(whoami)."
  exit 1
fi

echo "=== Cleaning temporary system ==="

rm -rf /usr/share/{info,man,doc}/*
find /usr/{lib,libexec} -name \*.la -delete
rm -rf /tools

echo "=== Cleanup complete. Temporary toolchain (/tools) removed, no longer needed. ==="
