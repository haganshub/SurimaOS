#!/bin/bash
#
# BLFS build: XKeyboardConfig-2.46
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./32-xkeyboard-config.sh [--force]
#
# Skipping the "upgrading from 2.44 or earlier" cleanup step, this is
# a fresh install, that directory won't exist yet. Also skipping tests
# (optional deps libxkbcommon/pytest not installed).

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-xkeyboard-config" "$1"

echo "=== Building XKeyboardConfig 2.46 ==="

cd /root/src
rm -rf xkeyboard-config-2.46
wget https://www.x.org/pub/individual/data/xkeyboard-config/xkeyboard-config-2.46.tar.xz
tar xf xkeyboard-config-2.46.tar.xz
cd xkeyboard-config-2.46

mkdir build
cd build

meson setup --prefix=$XORG_PREFIX --buildtype=release ..
ninja

ninja install

mark_done "11-xkeyboard-config"
echo "=== XKeyboardConfig complete ==="
