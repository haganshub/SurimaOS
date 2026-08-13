#!/bin/bash
#
# SurimaOS build: 8.7. Bzip2-1.0.8
# Run INSIDE chroot. Usage: ./05-bzip2.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-bzip2"

echo "=== Building Bzip2 1.0.8 ==="

cd /sources
rm -rf bzip2-1.0.8
tar xf bzip2-1.0.8.tar.gz
cd bzip2-1.0.8

patch -Np1 -i ../bzip2-1.0.8-install_docs-1.patch
sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile

time {
make -f Makefile-libbz2_so
make clean

make

make PREFIX=/usr install
}

cp -av libbz2.so.* /usr/lib
ln -sfv libbz2.so.1.0.8 /usr/lib/libbz2.so
# Compatibility symlink, some packages (e.g. Kbd) expect this name.
ln -sfv libbz2.so.1.0.8 /usr/lib/libbz2.so.1

cp -v bzip2-shared /usr/bin/bzip2
for i in /usr/bin/{bzcat,bunzip2}; do
  ln -sfv bzip2 $i
done

rm -fv /usr/lib/libbz2.a

mark_done "08-bzip2"
echo "=== Bzip2 complete ==="
