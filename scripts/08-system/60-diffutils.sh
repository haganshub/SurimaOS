#!/bin/bash
#
# SurimaOS build: 8.62. Diffutils-3.12 (final install)
# Run INSIDE chroot. Usage: ./60-diffutils.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-diffutils"

echo "=== Building Diffutils 3.12 (final) ==="

cd /sources
rm -rf diffutils-3.12
tar xf diffutils-3.12.tar.xz
cd diffutils-3.12

time {
./configure --prefix=/usr

make

make check

make install
}

mark_done "08-diffutils"
echo "=== Diffutils complete ==="
