#!/bin/bash
#
# BLFS build: Fontconfig-2.17.1
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./08-fontconfig.sh [--force]
#
# NOTE: test suite needs internet access to fetch some font files, and
# one test is expected to fail if the kernel lacks user namespace
# support. Our trust store from make-ca means real internet tests can
# actually run this time, unlike most earlier "skip the tests" calls.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-fontconfig" "$1"

echo "=== Building Fontconfig 2.17.1 ==="

cd /root/src
rm -rf fontconfig-2.17.1
wget https://gitlab.freedesktop.org/api/v4/projects/890/packages/generic/fontconfig/2.17.1/fontconfig-2.17.1.tar.xz
tar xf fontconfig-2.17.1.tar.xz
cd fontconfig-2.17.1

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-docs       \
            --docdir=/usr/share/doc/fontconfig-2.17.1

make

echo ""
echo "=== Running Fontconfig test suite. One test may fail without"
echo "=== user namespace support, and some may fail if font downloads"
echo "=== time out, neither is treated as fatal here. ==="
echo ""
set +e
make check
set -e
echo ""

make install

install -v -dm755 \
        /usr/share/{man/man{1,3,5},doc/fontconfig-2.17.1}
install -v -m644 fc-*/*.1         /usr/share/man/man1
install -v -m644 doc/*.3          /usr/share/man/man3
install -v -m644 doc/fonts-conf.5 /usr/share/man/man5
install -v -m644 doc/*.{pdf,sgml,txt,html} \
                                  /usr/share/doc/fontconfig-2.17.1

mark_done "11-fontconfig"
echo "=== Fontconfig complete ==="
