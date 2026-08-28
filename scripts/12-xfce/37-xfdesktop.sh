#!/bin/bash
#
# BLFS build: Xfdesktop-4.20.1
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./37-xfdesktop.sh [--force]
#
# Uses xfce4-settings (just built) and Thunar libraries (have), no
# new dependency surfaced in research.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-xfdesktop" "$1"

echo "=== Building Xfdesktop 4.20.1 ==="

cd /root/src
rm -rf xfdesktop-4.20.1
wget https://archive.xfce.org/src/xfce/xfdesktop/4.20/xfdesktop-4.20.1.tar.bz2
tar xf xfdesktop-4.20.1.tar.bz2
cd xfdesktop-4.20.1

./configure --prefix=/usr --sysconfdir=/etc
make

make install

mark_done "12-xfdesktop"
echo "=== Xfdesktop complete ==="
