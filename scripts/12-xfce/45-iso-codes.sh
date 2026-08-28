#!/bin/bash
#
# BLFS build: ISO Codes-4.20.1
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./45-iso-codes.sh [--force]
#
# Needed by libxklavier, needed by the lightdm greeter.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-iso-codes" "$1"

echo "=== Building ISO Codes 4.20.1 ==="

cd /root/src
rm -rf iso-codes-v4.20.1
wget https://salsa.debian.org/iso-codes-team/iso-codes/-/archive/v4.20.1/iso-codes-v4.20.1.tar.gz
tar xf iso-codes-v4.20.1.tar.gz
cd iso-codes-v4.20.1

mkdir build
cd build

meson setup --prefix=/usr --buildtype=release ..
ninja

ninja install

mark_done "12-iso-codes"
echo "=== ISO Codes complete ==="
