#!/bin/bash
#
# SurimaOS build: 8.40. Gperf-3.3
# Run INSIDE chroot. Usage: ./38-gperf.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-gperf"

echo "=== Building Gperf 3.3 ==="

cd /sources
rm -rf gperf-3.3
tar xf gperf-3.3.tar.gz
cd gperf-3.3

time {
./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.3

make

make check

make install
}

mark_done "08-gperf"
echo "=== Gperf complete ==="
