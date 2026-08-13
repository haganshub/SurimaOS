#!/bin/bash
#
# SurimaOS build: 8.15. Bc-7.0.3
# Run INSIDE chroot. Usage: ./13-bc.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-bc"

echo "=== Building Bc 7.0.3 ==="

cd /sources
rm -rf bc-7.0.3
tar xf bc-7.0.3.tar.xz
cd bc-7.0.3

time {
CC='gcc -std=c99' ./configure --prefix=/usr -G -O3 -r

make

make test

make install
}

mark_done "08-bc"
echo "=== Bc complete ==="
