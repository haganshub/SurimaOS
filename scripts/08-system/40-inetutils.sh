#!/bin/bash
#
# SurimaOS build: 8.42. Inetutils-2.7
# Run INSIDE chroot. Usage: ./40-inetutils.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-inetutils"

echo "=== Building Inetutils 2.7 ==="

cd /sources
rm -rf inetutils-2.7
tar xf inetutils-2.7.tar.gz
cd inetutils-2.7

# Build fix for gcc-14.1+.
sed -i 's/def HAVE_TERMCAP_TGETENT/ 1/' telnet/telnet.c

time {
./configure --prefix=/usr        \
            --bindir=/usr/bin    \
            --localstatedir=/var \
            --disable-logger     \
            --disable-whois      \
            --disable-rcp        \
            --disable-rexec      \
            --disable-rlogin     \
            --disable-rsh        \
            --disable-servers

make

make check

make install
}

mv -v /usr/{,s}bin/ifconfig

mark_done "08-inetutils"
echo "=== Inetutils complete ==="
