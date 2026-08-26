#!/bin/bash
#
# BLFS build: xcursor-themes-1.0.7
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./30-xcursor-themes.sh [--force]
#
# Book explicitly uses --prefix=/usr here rather than $XORG_CONFIG, so
# non-Xorg desktop environments can find the cursor themes too. Matches
# our setup anyway since XORG_PREFIX is already /usr.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-xcursor-themes" "$1"

echo "=== Building xcursor-themes 1.0.7 ==="

cd /root/src
rm -rf xcursor-themes-1.0.7
wget https://www.x.org/pub/individual/data/xcursor-themes-1.0.7.tar.xz
tar xf xcursor-themes-1.0.7.tar.xz
cd xcursor-themes-1.0.7

./configure --prefix=/usr
make

make install

mark_done "11-xcursor-themes"
echo "=== xcursor-themes complete ==="
