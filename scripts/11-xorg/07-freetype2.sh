#!/bin/bash
#
# BLFS build: FreeType-2.14.1
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./07-freetype2.sh [--force]
#
# NOTE: harfBuzz and libpng are "Recommended," not "Required." Building
# without them for now, --with-harfbuzz=dynamic avoids the circular
# dependency (HarfBuzz itself often depends on FreeType too).

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-freetype2" "$1"

echo "=== Building FreeType 2.14.1 ==="

cd /root/src
rm -rf freetype-2.14.1
wget https://downloads.sourceforge.net/freetype/freetype-2.14.1.tar.xz
tar xf freetype-2.14.1.tar.xz
cd freetype-2.14.1

sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg
sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" \
    -i include/freetype/config/ftoption.h

./configure --prefix=/usr            \
            --disable-static         \
            --enable-freetype-config \
            --with-harfbuzz=dynamic

make

make install

mark_done "11-freetype2"
echo "=== FreeType complete ==="
