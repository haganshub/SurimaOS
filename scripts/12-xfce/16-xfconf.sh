#!/bin/bash
#
# BLFS build: Xfconf-4.20.0
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./16-xfconf.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-xfconf" "$1"

echo "=== Building Xfconf 4.20.0 ==="

cd /root/src
rm -rf xfconf-4.20.0
wget https://archive.xfce.org/src/xfce/xfconf/4.20/xfconf-4.20.0.tar.bz2
tar xf xfconf-4.20.0.tar.bz2
cd xfconf-4.20.0

./configure --prefix=/usr
make

make install

mark_done "12-xfconf"
echo "=== Xfconf complete ==="
