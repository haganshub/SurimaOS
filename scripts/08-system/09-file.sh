#!/bin/bash
#
# SurimaOS build: 8.11. File-5.46 (final install, simpler than the
# Chapter 6 temporary two-stage build)
# Run INSIDE chroot. Usage: ./09-file.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-file"

echo "=== Building File 5.46 (final) ==="

cd /sources
rm -rf file-5.46
tar xf file-5.46.tar.gz
cd file-5.46

time {
./configure --prefix=/usr

make

make check

make install
}

mark_done "08-file"
echo "=== File complete ==="
