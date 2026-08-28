#!/bin/bash
#
# BLFS build: gnome-icon-theme-3.12.0
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./35-gnome-icon-theme.sh [--force]
#
# xfce4-settings needs at least one real icon theme (gnome-icon-theme
# OR lxde-icon-theme). Chose gnome-icon-theme deliberately: despite
# the name, it's just a plain icon set with no dependency chain,
# unlike lxde-icon-theme, which itself needs oxygen-icons5, a KDE
# icon set, a real unwanted chain for no real benefit here.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-gnome-icon-theme" "$1"

echo "=== Building gnome-icon-theme 3.12.0 ==="

cd /root/src
rm -rf gnome-icon-theme-3.12.0
wget https://download.gnome.org/sources/gnome-icon-theme/3.12/gnome-icon-theme-3.12.0.tar.xz
tar xf gnome-icon-theme-3.12.0.tar.xz
cd gnome-icon-theme-3.12.0

./configure --prefix=/usr
make

make install

mark_done "12-gnome-icon-theme"
echo "=== gnome-icon-theme complete ==="
