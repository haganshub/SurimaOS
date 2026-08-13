#!/bin/bash
#
# SurimaOS build: 8.48. Automake-1.18.1
# Run INSIDE chroot. Usage: ./46-automake.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-automake"

echo "=== Building Automake 1.18.1 ==="

cd /sources
rm -rf automake-1.18.1
tar xf automake-1.18.1.tar.xz
cd automake-1.18.1

time {
./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.18.1

make

# Book specifically wants at least 4 parallel jobs for the test suite,
# even on lower-core systems, due to internal per-test delays.
make -j$(($(nproc)>4?$(nproc):4)) check

make install
}

mark_done "08-automake"
echo "=== Automake complete ==="
