#!/bin/bash
#
# SurimaOS build: 8.31. Ncurses-6.6 (final install)
# Run INSIDE chroot. Usage: ./29-ncurses.sh [--force]
#
# NOTE: this package overwrites a shared library currently in use by
# the running shell, hence the careful DESTDIR + --remove-destination
# dance below rather than a plain "make install".

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-ncurses"

echo "=== Building Ncurses 6.6 (final) ==="

cd /sources
rm -rf ncurses-6.6
tar xf ncurses-6.6.tar.gz
cd ncurses-6.6

time {
./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --with-shared           \
            --without-debug         \
            --without-normal        \
            --with-cxx-shared       \
            --enable-pc-files       \
            --with-pkg-config-libdir=/usr/lib/pkgconfig

make

# Test suite can only be run after install, skipped here per the
# book's own structure (it doesn't run it as part of this section).

make DESTDIR=$PWD/dest install
sed -e 's/^#if.*XOPEN.*$/#if 1/' \
    -i dest/usr/include/curses.h
cp --remove-destination -av dest/* /
}

# Trick applications still expecting non-wide-character library names
# into linking against the wide-character libraries via symlinks.
for lib in ncurses form panel menu ; do
    ln -sfv lib${lib}w.so /usr/lib/lib${lib}.so
    ln -sfv ${lib}w.pc    /usr/lib/pkgconfig/${lib}.pc
done

ln -sfv libncursesw.so /usr/lib/libcurses.so

cp -v -R doc -T /usr/share/doc/ncurses-6.6

mark_done "08-ncurses"
echo "=== Ncurses complete ==="
