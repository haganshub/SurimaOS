#!/bin/bash
#
# SurimaOS build: 5.5. Glibc-2.43
# Usage: ./04-glibc.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "04-glibc"

echo "=== Building Glibc 2.43 ==="

cd "$LFS/sources"

# LSB compliance symlink, plus the x86_64 dynamic linker compat symlinks.
case $(uname -m) in
    i?86)   ln -sfv ld-linux.so.2 $LFS/lib/ld-lsb.so.3
    ;;
    x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64
            ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64/ld-lsb-x86-64.so.3
    ;;
esac

rm -rf glibc-2.43
tar xf glibc-2.43.tar.xz
cd glibc-2.43

# FHS-compliance patch, so runtime data goes to FHS-compliant locations
# instead of the non-FHS /var/db.
patch -Np1 -i ../glibc-fhs-1.patch

rm -rf build
mkdir -v build
cd       build

# Ensure ldconfig and sln land in /usr/sbin.
echo "rootsbindir=/usr/sbin" > configparms

../configure                             \
      --prefix=/usr                      \
      --host=$LFS_TGT                    \
      --build=$(../scripts/config.guess) \
      --disable-nscd                     \
      libc_cv_slibdir=/usr/lib           \
      --enable-kernel=5.4

# NOTE: Glibc has a known history of flaky parallel-make failures.
# Deliberately NOT using -j$JOBS here, plain single-threaded make,
# trading a few extra minutes for reliability on the one package
# everything else depends on.
make

make DESTDIR=$LFS install

# Fix a hardcoded path to the executable loader in the ldd script.
sed '/RTLDLIST=/s@/usr@@g' -i $LFS/usr/bin/ldd

echo ""
echo "=== Running toolchain sanity checks ==="
echo ""

echo 'int main(){}' | $LFS_TGT-gcc -x c - -v -Wl,--verbose &> dummy.log

echo "--- Program interpreter check (expect /lib64/ld-linux-x86-64.so.2, no \$LFS path) ---"
readelf -l a.out | grep ': /lib'

echo ""
echo "--- Start files check (expect three '... succeeded' lines) ---"
grep -E -o "$LFS/lib.*/S?crt[1in].*succeeded" dummy.log

echo ""
echo "--- Header search path check (expect three lines ending in .../include, .../include-fixed, \$LFS/usr/include) ---"
grep -B3 "^ $LFS/usr/include" dummy.log

echo ""
echo "--- Linker search path check ---"
grep 'SEARCH.*/usr/lib' dummy.log | sed 's|; |\n|g'

echo ""
echo "--- libc check (expect: attempt to open \$LFS/usr/lib/libc.so.6 succeeded) ---"
grep "/lib.*/libc.so.6 " dummy.log

echo ""
echo "--- Dynamic linker check (expect: found ld-linux-x86-64.so.2 at \$LFS/usr/lib/...) ---"
grep found dummy.log

echo ""
echo "=== Review the sanity check output above carefully before continuing. ==="
echo "=== Per the book: if these don't match expectations, STOP. Something is"
echo "=== wrong with Binutils, GCC, or Glibc, and every later package will"
echo "=== inherit the problem. Do not proceed to Chapter 6 until this is clean. ==="
echo ""

rm -v a.out dummy.log

mark_done "04-glibc"
echo "=== Glibc complete ==="
