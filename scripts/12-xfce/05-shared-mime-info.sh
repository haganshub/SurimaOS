#!/bin/bash
#
# BLFS build: shared-mime-info-2.4
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./05-shared-mime-info.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-shared-mime-info" "$1"

echo "=== Building shared-mime-info 2.4 ==="

cd /root/src
rm -rf shared-mime-info-2.4
wget https://gitlab.freedesktop.org/xdg/shared-mime-info/-/archive/2.4/shared-mime-info-2.4.tar.gz
tar xf shared-mime-info-2.4.tar.gz
cd shared-mime-info-2.4

mkdir build
cd build

meson setup --prefix=/usr --buildtype=release -D update-mimedb=true ..
ninja

ninja install

mark_done "12-shared-mime-info"
echo "=== shared-mime-info complete ==="
