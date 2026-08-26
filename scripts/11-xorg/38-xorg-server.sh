#!/bin/bash
#
# BLFS build: Xorg-Server-21.1.21
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./38-xorg-server.sh [--force]
#
# The actual goal of this entire detour (Mesa, the libclc/LLVM chain,
# Linux-PAM, Shadow, systemd). Real dependencies now all satisfied:
# libxcvt, Pixman, Xorg Fonts (font-util), libepoxy (for glamor),
# systemd rebuilt with PAM.
#
# -D secure-rpc=false: skipping libtirpc, same reasoning as skipping
# Vulkan/LLVM earlier, a real feature (Secure RPC support) we don't
# need, with a clean, book-documented flag to disable it, not a
# hidden hardwired requirement like libclc turned out to be.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-xorg-server" "$1"

echo "=== Building Xorg-Server 21.1.21 ==="

cd /root/src
rm -rf xorg-server-21.1.21
wget https://www.x.org/pub/individual/xserver/xorg-server-21.1.21.tar.xz
tar xf xorg-server-21.1.21.tar.xz
cd xorg-server-21.1.21

mkdir build
cd build

meson setup .. \
      --prefix=$XORG_PREFIX \
      --localstatedir=/var \
      -D glamor=true \
      -D secure-rpc=false \
      -D xkb_output_dir=/var/lib/xkb

ninja

ninja install
mkdir -pv /etc/X11/xorg.conf.d

mark_done "11-xorg-server"
echo "=== Xorg-Server complete ==="
echo ""
echo "=== That's the whole chain closed. Real Xorg server, built ==="
echo "=== for our real hardware, with a real PAM-integrated login. ==="
