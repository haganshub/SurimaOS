#!/bin/bash
#
# SurimaOS build: 8.33. Psmisc-23.7
# Run INSIDE chroot. Usage: ./31-psmisc.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-psmisc"

echo "=== Building Psmisc 23.7 ==="

cd /sources
rm -rf psmisc-23.7
tar xf psmisc-23.7.tar.xz
cd psmisc-23.7

time {
./configure --prefix=/usr

make

make check

make install
}

mark_done "08-psmisc"
echo "=== Psmisc complete ==="
