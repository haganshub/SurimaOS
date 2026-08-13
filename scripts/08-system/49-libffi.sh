#!/bin/bash
#
# SurimaOS build: 8.51. Libffi-3.5.2
# Run INSIDE chroot. Usage: ./49-libffi.sh [--force]
#
# NOTE: like GMP, this builds with CPU-specific optimizations via
# --with-gcc-arch=native. Fine for this single-machine build (build
# host and target are the same physical CPU), but if this system is
# ever cloned to different hardware later, this is a spot to revisit
# (the book suggests --without-gcc-arch for a generic/portable build).

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-libffi"

echo "=== Building Libffi 3.5.2 ==="

cd /sources
rm -rf libffi-3.5.2
tar xf libffi-3.5.2.tar.gz
cd libffi-3.5.2

time {
./configure --prefix=/usr    \
            --disable-static \
            --with-gcc-arch=native

make

make check

make install
}

mark_done "08-libffi"
echo "=== Libffi complete ==="
