#!/bin/bash
#
# SurimaOS build: 8.17. Tcl-8.6.17
# Run INSIDE chroot. Usage: ./15-tcl.sh [--force]
#
# NOTE: Tcl, Expect, and DejaGNU (next 3 packages) exist purely to
# support running test suites for Binutils, GCC, and others later.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-tcl"

echo "=== Building Tcl 8.6.17 ==="

cd /sources
rm -rf tcl8.6.17
tar xf tcl8.6.17-src.tar.gz
cd tcl8.6.17

SRCDIR=$(pwd)
cd unix

time {
./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --disable-rpath

make

sed -e "s|$SRCDIR/unix|/usr/lib|" \
    -e "s|$SRCDIR|/usr/include|"  \
    -i tclConfig.sh
sed -e "s|$SRCDIR/unix/pkgs/tdbc1.1.12|/usr/lib/tdbc1.1.12|" \
    -e "s|$SRCDIR/pkgs/tdbc1.1.12/generic|/usr/include|"     \
    -e "s|$SRCDIR/pkgs/tdbc1.1.12/library|/usr/lib/tcl8.6|"  \
    -e "s|$SRCDIR/pkgs/tdbc1.1.12|/usr/include|"             \
    -i pkgs/tdbc1.1.12/tdbcConfig.sh
sed -e "s|$SRCDIR/unix/pkgs/itcl4.3.4|/usr/lib/itcl4.3.4|" \
    -e "s|$SRCDIR/pkgs/itcl4.3.4/generic|/usr/include|"    \
    -e "s|$SRCDIR/pkgs/itcl4.3.4|/usr/include|"            \
    -i pkgs/itcl4.3.4/itclConfig.sh
unset SRCDIR

LC_ALL=C.UTF-8 make test

make install
chmod 644 /usr/lib/libtclstub8.6.a
}

chmod -v u+w /usr/lib/libtcl8.6.so

make install-private-headers

ln -sfv tclsh8.6 /usr/bin/tclsh

mv -v /usr/share/man/man3/{Thread,Tcl_Thread}.3

# Optional documentation install.
cd ..
tar -xf ../tcl8.6.17-html.tar.gz --strip-components=1
mkdir -v -p /usr/share/doc/tcl-8.6.17
cp -v -r  ./html/* /usr/share/doc/tcl-8.6.17

mark_done "08-tcl"
echo "=== Tcl complete ==="
