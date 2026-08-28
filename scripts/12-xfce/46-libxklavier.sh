#!/bin/bash
#
# BLFS build: libxklavier-5.4
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./46-libxklavier.sh [--force]
#
# Needed by the lightdm greeter. Real deps (GLib, ISO Codes, libxml2,
# Xorg Libraries) all satisfied. GObject introspection recommended,
# disabled per this project's standing rule.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-libxklavier" "$1"

echo "=== Building libxklavier 5.4 ==="

cd /root/src
rm -rf libxklavier-5.4
wget https://people.freedesktop.org/~svu/libxklavier-5.4.tar.bz2
tar xf libxklavier-5.4.tar.bz2
cd libxklavier-5.4

INTROSPECTION_FLAG=""
if ./configure --help | grep -q "enable-introspection"; then
  INTROSPECTION_FLAG="--enable-introspection=no"
fi

./configure --prefix=/usr --disable-static $INTROSPECTION_FLAG
make

make install

mark_done "12-libxklavier"
echo "=== libxklavier complete ==="
