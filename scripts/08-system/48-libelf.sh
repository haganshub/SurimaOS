#!/bin/bash
#
# SurimaOS build: 8.50. Libelf from Elfutils-0.194
# Run INSIDE chroot. Usage: ./48-libelf.sh [--force]
#
# NOTE: only libelf is built here, not the full elfutils package.
# Test suite deliberately skipped, the book notes it fails to build
# against glibc-2.43+.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-libelf"

echo "=== Building Libelf (from Elfutils 0.194) ==="

cd /sources
rm -rf elfutils-0.194
tar xf elfutils-0.194.tar.bz2
cd elfutils-0.194

time {
./configure --prefix=/usr        \
            --disable-debuginfod \
            --enable-libdebuginfod=dummy

make -C lib
make -C libelf

make -C libelf install
}

install -vm644 config/libelf.pc /usr/lib/pkgconfig
rm /usr/lib/libelf.a

mark_done "08-libelf"
echo "=== Libelf complete ==="
