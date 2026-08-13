#!/bin/bash
#
# SurimaOS build: 8.43. Less-692
# Run INSIDE chroot. Usage: ./41-less.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-less"

echo "=== Building Less 692 ==="

cd /sources
rm -rf less-692
tar xf less-692.tar.gz
cd less-692

time {
./configure --prefix=/usr --sysconfdir=/etc

make

make check

make install
}

mark_done "08-less"
echo "=== Less complete ==="
