#!/bin/bash
#
# SurimaOS build: 6.3. Ncurses-6.6
# Usage: ./02-ncurses.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "06-ncurses"

echo "=== Building Ncurses 6.6 ==="

cd "$LFS/sources"
rm -rf ncurses-6.6
tar xf ncurses-6.6.tar.gz
cd ncurses-6.6

# First build 'tic' for the build host itself, installed into
# $LFS/tools so it's on PATH when needed later in this build.
mkdir build
pushd build
  ../configure --prefix=$LFS/tools AWK=gawk
  make -C include
  make -C progs tic
  install progs/tic $LFS/tools/bin
popd

time {
./configure --prefix=/usr                \
            --host=$LFS_TGT              \
            --build=$(./config.guess)    \
            --mandir=/usr/share/man      \
            --with-manpage-format=normal \
            --with-shared                \
            --without-normal             \
            --with-cxx-shared            \
            --without-debug              \
            --without-ada                \
            --disable-stripping          \
            AWK=gawk

make -j$JOBS

make DESTDIR=$LFS install
}

ln -sv libncursesw.so $LFS/usr/lib/libncurses.so
sed -e 's/^#if.*XOPEN.*$/#if 1/' \
    -i $LFS/usr/include/curses.h

mark_done "06-ncurses"
echo "=== Ncurses complete ==="
