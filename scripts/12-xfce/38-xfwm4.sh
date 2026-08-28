#!/bin/bash
#
# BLFS build: Xfwm4-4.20.0
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./38-xfwm4.sh [--force]
#
# The window manager itself. No new dependency surfaced in research,
# built entirely on the GTK3/libxfce4ui/libwnck/Xfconf stack already
# in place.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-xfwm4" "$1"

echo "=== Building Xfwm4 4.20.0 ==="

cd /root/src
rm -rf xfwm4-4.20.0
wget https://archive.xfce.org/src/xfce/xfwm4/4.20/xfwm4-4.20.0.tar.bz2
tar xf xfwm4-4.20.0.tar.bz2
cd xfwm4-4.20.0

./configure --prefix=/usr --sysconfdir=/etc
make

make install

mark_done "12-xfwm4"
echo "=== Xfwm4 complete ==="
