#!/bin/bash
#
# BLFS build: xfce4-settings-4.20.3
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./36-xfce4-settings.sh [--force]
#
# Real required deps: Exo, Garcon (have), plus an icon theme
# (gnome-icon-theme, just built). Recommended (libcanberra,
# libnotify, libxklavier) and optional (colord, libinput, UPower)
# skipped/partial, reacting to real errors if they show up.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-xfce4-settings" "$1"

echo "=== Building xfce4-settings 4.20.3 ==="

cd /root/src
rm -rf xfce4-settings-4.20.3
wget https://archive.xfce.org/src/xfce/xfce4-settings/4.20/xfce4-settings-4.20.3.tar.bz2
tar xf xfce4-settings-4.20.3.tar.bz2
cd xfce4-settings-4.20.3

./configure --prefix=/usr --sysconfdir=/etc
make

make install

mark_done "12-xfce4-settings"
echo "=== xfce4-settings complete ==="
