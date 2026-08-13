#!/bin/bash
#
# SurimaOS build: 8.27. Libcap-2.77
# Run INSIDE chroot. Usage: ./25-libcap.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-libcap"

echo "=== Building Libcap 2.77 ==="

cd /sources
rm -rf libcap-2.77
tar xf libcap-2.77.tar.xz
cd libcap-2.77

sed -i '/install -m.*STA/d' libcap/Makefile

time {
make prefix=/usr lib=lib

make test

make prefix=/usr lib=lib install
}

mark_done "08-libcap"
echo "=== Libcap complete ==="
