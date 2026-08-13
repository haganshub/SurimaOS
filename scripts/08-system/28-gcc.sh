#!/bin/bash
#
# SurimaOS build: 8.30. GCC-15.2.0 (final install)
# Run INSIDE chroot. Usage: ./28-gcc.sh [--force]
#
# NOTE: 45 SBU including tests, by far the largest single build in
# this entire project. STRONGLY recommend running inside tmux.
#
# NOTE: the test suite runs as the 'tester' user (created back in
# Chapter 7), not root, a first for this project. This is handled
# below via chown + su.
#
# NOTE: several test failures are known/expected per the book
# (pr90579.c x4, analyzer/strchr-1.c x5, libstdc++ badnames/names x4
# due to glibc-2.43 changes). Not treated as fatal here, same
# show-don't-gate pattern as Glibc/Binutils/GMP/MPFR.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-gcc"

echo "=== Building GCC 15.2.0 (final) ==="

cd /sources
rm -rf gcc-15.2.0
LC_ALL=C.utf8 tar xf gcc-15.2.0.tar.xz
cd gcc-15.2.0

# Fix required by glibc-2.43+.
sed -i 's/char [*]q/const &/' libgomp/affinity-fmt.c

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
esac

rm -rf build
mkdir -v build
cd       build

time {
../configure --prefix=/usr            \
             LD=ld                    \
             --enable-languages=c,c++ \
             --enable-default-pie     \
             --enable-default-ssp     \
             --enable-host-pie        \
             --disable-multilib       \
             --disable-bootstrap      \
             --disable-fixincludes    \
             --with-system-zlib

make
}

echo ""
echo "=== Preparing GCC test suite (runs as 'tester' user, not root) ==="

ulimit -s -H unlimited

# Remove a known-failing test.
sed -e '/cpython/d' -i ../gcc/testsuite/gcc.dg/plugin/plugin.exp

chown -R tester .

echo ""
echo "=== Running GCC test suite. This is the longest test run in the whole project. ==="
echo ""
set +e
su tester -c "PATH=$PATH make -k check" 2>&1 | tee /root/gcc-check-results.log
set -e

echo ""
echo "=== Test summary: ==="
../contrib/test_summary 2>&1 | grep -A7 Summ || echo "(summary extraction failed, review /root/gcc-check-results.log directly)"
echo ""
echo "=== Known/expected failures per the book: 4 tests related to"
echo "=== pr90579.c, 5 related to analyzer/strchr-1.c, and 4 in"
echo "=== libstdc++ (badnames.cc, names.cc, names_fortify.cc,"
echo "=== experimental/names.cc) due to glibc-2.43 changes. Compare"
echo "=== against https://www.linuxfromscratch.org/lfs/build-logs/13.0/"
echo "=== if results look meaningfully different from expected. ==="
echo ""

make install

# The build dir is owned by tester now, fix ownership of the
# installed header directory.
chown -v -R root:root \
    /usr/lib/gcc/$(gcc -dumpmachine)/15.2.0/include{,-fixed}

# FHS-required symlink.
ln -svr /usr/bin/cpp /usr/lib

# Man page symlink for the cc compatibility name.
ln -sv gcc.1 /usr/share/man/man1/cc.1

# LTO plugin compatibility symlink.
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/15.2.0/liblto_plugin.so \
        /usr/lib/bfd-plugins/

echo ""
echo "=== Running final toolchain sanity checks ==="
echo ""

echo 'int main(){}' | cc -x c - -v -Wl,--verbose &> dummy.log

echo "--- Program interpreter check ---"
readelf -l a.out | grep ': /lib'

echo ""
echo "--- Start files check ---"
grep -E -o '/usr/lib.*/S?crt[1in].*succeeded' dummy.log

echo ""
echo "--- Header search path check ---"
grep -B4 '^ /usr/include' dummy.log

echo ""
echo "--- Linker search path check ---"
grep 'SEARCH.*/usr/lib' dummy.log | sed 's|; |\n|g'

echo ""
echo "--- libc check ---"
grep "/lib.*/libc.so.6 " dummy.log

echo ""
echo "--- Dynamic linker check ---"
grep found dummy.log

echo ""
echo "=== Review the sanity check output above. If it doesn't match"
echo "=== expectations (see the book's GCC page for exact expected"
echo "=== output), something is seriously wrong, investigate before"
echo "=== continuing. ==="
echo ""

rm -v a.out dummy.log

mkdir -pv /usr/share/gdb/auto-load/usr/lib
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib

mark_done "08-gcc"
echo "=== GCC complete ==="
echo ""
echo "=== The final compiler toolchain is now fully in place. ==="
