#!/bin/bash
#
# SurimaOS build: 8.55. Packaging-26.0
# Run INSIDE chroot. Usage: ./53-packaging.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-packaging"

echo "=== Building Packaging 26.0 ==="

cd /sources
rm -rf packaging-26.0
tar xf packaging-26.0.tar.gz
cd packaging-26.0

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD

pip3 install --no-index --find-links dist packaging

mark_done "08-packaging"
echo "=== Packaging complete ==="
