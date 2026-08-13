#!/bin/bash
#
# SurimaOS build: 8.24. MPC-1.3.1
# Run INSIDE chroot. Usage: ./22-mpc.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-mpc"

echo "=== Building MPC 1.3.1 ==="

cd /sources
rm -rf mpc-1.3.1
tar xf mpc-1.3.1.tar.gz
cd mpc-1.3.1

time {
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/mpc-1.3.1

make
make html

make check

make install
make install-html
}

mark_done "08-mpc"
echo "=== MPC complete ==="
