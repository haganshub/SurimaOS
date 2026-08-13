#!/bin/bash
#
# SurimaOS build: 8.56. Wheel-0.46.3
# Run INSIDE chroot. Usage: ./54-wheel.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-wheel"

echo "=== Building Wheel 0.46.3 ==="

cd /sources
rm -rf wheel-0.46.3
tar xf wheel-0.46.3.tar.gz
cd wheel-0.46.3

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD

pip3 install --no-index --find-links dist wheel

mark_done "08-wheel"
echo "=== Wheel complete ==="
