#!/bin/bash
#
# BLFS build: thunar-volman-4.20.0
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./29-thunar-volman.sh [--force]
#
# Real deps confirmed: Exo, libgudev (both have now). libnotify and
# Gvfs shown alongside but likely optional/recommended, skipping for
# now and reacting if configure demands one.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-thunar-volman" "$1"

echo "=== Building thunar-volman 4.20.0 ==="

cd /root/src
rm -rf thunar-volman-4.20.0
wget https://archive.xfce.org/src/xfce/thunar-volman/4.20/thunar-volman-4.20.0.tar.bz2
tar xf thunar-volman-4.20.0.tar.bz2
cd thunar-volman-4.20.0

./configure --prefix=/usr
make

make install

mark_done "12-thunar-volman"
echo "=== thunar-volman complete ==="
