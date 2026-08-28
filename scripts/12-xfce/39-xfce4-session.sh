#!/bin/bash
#
# BLFS build: xfce4-session-4.20.3
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./39-xfce4-session.sh [--force]
#
# The final XFCE core component. Real optional runtime deps
# (desktop-file-utils, xfce4-screensaver/XScreenSaver, polkit-gnome)
# skipped for now, shared-mime-info already have. --disable-legacy-sm
# per the book, not needed on a modern system.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-xfce4-session" "$1"

echo "=== Building xfce4-session 4.20.3 ==="

cd /root/src
rm -rf xfce4-session-4.20.3
wget https://archive.xfce.org/src/xfce/xfce4-session/4.20/xfce4-session-4.20.3.tar.bz2
tar xf xfce4-session-4.20.3.tar.bz2
cd xfce4-session-4.20.3

./configure --prefix=/usr --sysconfdir=/etc --disable-legacy-sm
make

make install

echo "=== Updating desktop/mime databases for the new applications ==="
update-desktop-database
update-mime-database /usr/share/mime

mark_done "12-xfce4-session"
echo "=== xfce4-session complete ==="
echo ""
echo "=== That's every core XFCE component built. Real graphical"
echo "=== login (lightdm) and the first boot into X are next. ==="
