#!/bin/bash
#
# BLFS build: xfce4-appfinder-4.20.0
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./31-xfce4-appfinder.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-xfce4-appfinder" "$1"

echo "=== Building xfce4-appfinder 4.20.0 ==="

cd /root/src
rm -rf xfce4-appfinder-4.20.0
wget https://archive.xfce.org/src/xfce/xfce4-appfinder/4.20/xfce4-appfinder-4.20.0.tar.bz2
tar xf xfce4-appfinder-4.20.0.tar.bz2
cd xfce4-appfinder-4.20.0

./configure --prefix=/usr
make

make install

mark_done "12-xfce4-appfinder"
echo "=== xfce4-appfinder complete ==="
