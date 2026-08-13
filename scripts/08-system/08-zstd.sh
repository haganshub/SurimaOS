#!/bin/bash
#
# SurimaOS build: 8.10. Zstd-1.5.7
# Run INSIDE chroot. Usage: ./08-zstd.sh [--force]
#
# NOTE: the book warns the test output will show many lines containing
# the word "failed" in lowercase, these are normal/expected. Only a
# line that says exactly "FAIL" (uppercase) is a real test failure.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-zstd"

echo "=== Building Zstd 1.5.7 ==="

cd /sources
rm -rf zstd-1.5.7
tar xf zstd-1.5.7.tar.gz
cd zstd-1.5.7

time {
make prefix=/usr

make check

make prefix=/usr install
}

rm -v /usr/lib/libzstd.a

mark_done "08-zstd"
echo "=== Zstd complete ==="
