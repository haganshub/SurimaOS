#!/bin/bash
#
# BLFS build: xfce4-panel-4.20.6
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./26-xfce4-panel.sh [--force]
#
# Real deps confirmed earlier: Cairo, Exo, Garcon, libwnck,
# libxfce4windowing, all satisfied.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-xfce4-panel" "$1"

echo "=== Building xfce4-panel 4.20.6 ==="

cd /root/src
rm -rf xfce4-panel-4.20.6
wget https://archive.xfce.org/src/xfce/xfce4-panel/4.20/xfce4-panel-4.20.6.tar.bz2
tar xf xfce4-panel-4.20.6.tar.bz2
cd xfce4-panel-4.20.6

INTROSPECTION_FLAG=""
if ./configure --help | grep -q "enable-introspection"; then
  INTROSPECTION_FLAG="--enable-introspection=no"
fi

./configure --prefix=/usr --sysconfdir=/etc $INTROSPECTION_FLAG

make

make install

mark_done "12-xfce4-panel"
echo "=== xfce4-panel complete ==="
