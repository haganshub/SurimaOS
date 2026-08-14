#!/bin/bash
#
# SurimaOS build: 8.70. Libpipeline-1.5.8
# Run INSIDE chroot. Usage: ./68-libpipeline.sh [--force]
#
# NOTE: tests require the Check library, which was removed from LFS,
# no test suite run here.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-libpipeline"

echo "=== Building Libpipeline 1.5.8 ==="

cd /sources
rm -rf libpipeline-1.5.8
tar xf libpipeline-1.5.8.tar.gz
cd libpipeline-1.5.8

time {
./configure --prefix=/usr

make

make install
}

mark_done "08-libpipeline"
echo "=== Libpipeline complete ==="
