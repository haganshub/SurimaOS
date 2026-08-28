#!/bin/bash
#
# BLFS build: Thunar-4.20.7
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./27-thunar.sh [--force]
#
# GTK-Doc, Gvfs, libexif, tumbler all optional/runtime enhancements
# (remote browsing, EXIF thumbnails), not core requirements. Real
# base deps (GTK3, libxfce4ui, Exo, libxfce4util) all satisfied.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-thunar" "$1"

echo "=== Building Thunar 4.20.7 ==="

cd /root/src
rm -rf thunar-4.20.7
wget https://archive.xfce.org/src/xfce/thunar/4.20/thunar-4.20.7.tar.bz2
tar xf thunar-4.20.7.tar.bz2
cd thunar-4.20.7

sed -i 's/\tinstall-systemd_userDATA/\t/' Makefile.in

INTROSPECTION_FLAG=""
if ./configure --help | grep -q "enable-introspection"; then
  INTROSPECTION_FLAG="--enable-introspection=no"
fi

./configure --prefix=/usr --sysconfdir=/etc \
            --docdir=/usr/share/doc/Thunar-4.20.7 \
            $INTROSPECTION_FLAG

make

make install

mark_done "12-thunar"
echo "=== Thunar complete ==="
