#!/bin/bash
#
# BLFS build: xfce4-dev-tools-4.20.0
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./21-xfce4-dev-tools.sh [--force]
#
# Just a collection of build macros/tools for other Xfce packages, no
# real dependencies of its own, no introspection concerns.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-xfce4-dev-tools" "$1"

echo "=== Building xfce4-dev-tools 4.20.0 ==="

cd /root/src
rm -rf xfce4-dev-tools-4.20.0
wget https://archive.xfce.org/src/xfce/xfce4-dev-tools/4.20/xfce4-dev-tools-4.20.0.tar.bz2
tar xf xfce4-dev-tools-4.20.0.tar.bz2
cd xfce4-dev-tools-4.20.0

./configure --prefix=/usr
make

make install

mark_done "12-xfce4-dev-tools"
echo "=== xfce4-dev-tools complete ==="
