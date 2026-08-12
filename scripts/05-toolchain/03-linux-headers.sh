#!/bin/bash
#
# SurimaOS build: 5.4. Linux-6.18.10 API Headers
# Usage: ./03-linux-headers.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "03-linux-headers"

echo "=== Installing Linux 6.18.10 API Headers ==="

cd "$LFS/sources"
rm -rf linux-6.18.10
tar xf linux-6.18.10.tar.xz
cd linux-6.18.10

make mrproper
make headers
find usr/include -type f ! -name '*.h' -delete
mkdir -pv $LFS/usr/include
cp -rv usr/include/. $LFS/usr/include/

mark_done "03-linux-headers"
echo "=== Linux API Headers complete ==="
