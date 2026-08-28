#!/bin/bash
#
# BLFS build: xfce4-power-manager-4.20.0
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./34-xfce4-power-manager.sh [--force]
#
# Real deps confirmed: libnotify, UPower, xfce4-panel, all satisfied.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-xfce4-power-manager" "$1"

echo "=== Building xfce4-power-manager 4.20.0 ==="

cd /root/src
rm -rf xfce4-power-manager-4.20.0
wget https://archive.xfce.org/src/xfce/xfce4-power-manager/4.20/xfce4-power-manager-4.20.0.tar.bz2
tar xf xfce4-power-manager-4.20.0.tar.bz2
cd xfce4-power-manager-4.20.0

./configure --prefix=/usr --sysconfdir=/etc
make

make install

mark_done "12-xfce4-power-manager"
echo "=== xfce4-power-manager complete ==="
