#!/bin/bash
#
# BLFS build: HarfBuzz-12.3.2
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./02-harfbuzz.sh [--force]
#
# graphite2=disabled: the book's example command uses
# graphite2=enabled, but that's only needed for texlive/LibreOffice,
# neither of which we're building, and we don't have Graphite2
# installed. Forcing "enabled" without the dependency present would
# hard-fail, same trap as several packages tonight. Disabling it
# explicitly instead.
#
# Cairo is already built (pass 1), so HarfBuzz should auto-detect it
# and build the cairo integration bits.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-harfbuzz" "$1"

echo "=== Building HarfBuzz 12.3.2 ==="

cd /root/src
rm -rf harfbuzz-12.3.2
wget https://github.com/harfbuzz/harfbuzz/releases/download/12.3.2/harfbuzz-12.3.2.tar.xz
tar xf harfbuzz-12.3.2.tar.xz
cd harfbuzz-12.3.2

mkdir build
cd build

meson setup .. \
      --prefix=/usr \
      --buildtype=release \
      -D graphite2=disabled

ninja

ninja install

mark_done "12-harfbuzz"
echo "=== HarfBuzz complete ==="
echo "=== REMINDER: rebuild Cairo again now that HarfBuzz exists. ==="
