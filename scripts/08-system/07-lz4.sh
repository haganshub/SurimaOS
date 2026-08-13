#!/bin/bash
#
# SurimaOS build: 8.9. Lz4-1.10.0
# Run INSIDE chroot. Usage: ./07-lz4.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-lz4"

echo "=== Building Lz4 1.10.0 ==="

cd /sources
rm -rf lz4-1.10.0
tar xf lz4-1.10.0.tar.gz
cd lz4-1.10.0

time {
make BUILD_STATIC=no PREFIX=/usr

# Book specifies -j1 for the test suite specifically, not the build.
make -j1 check

make BUILD_STATIC=no PREFIX=/usr install
}

mark_done "08-lz4"
echo "=== Lz4 complete ==="
