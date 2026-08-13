#!/bin/bash
#
# SurimaOS build: 8.39. GDBM-1.26
# Run INSIDE chroot. Usage: ./37-gdbm.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-gdbm"

echo "=== Building GDBM 1.26 ==="

cd /sources
rm -rf gdbm-1.26
tar xf gdbm-1.26.tar.gz
cd gdbm-1.26

time {
./configure --prefix=/usr    \
            --disable-static \
            --enable-libgdbm-compat

make

make check

make install
}

mark_done "08-gdbm"
echo "=== GDBM complete ==="
