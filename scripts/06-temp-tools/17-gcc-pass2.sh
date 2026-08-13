#!/bin/bash
#
# SurimaOS build: 6.18. GCC-15.2.0 - Pass 2
# Usage: ./17-gcc-pass2.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "06-gcc-pass2"

echo "=== Building GCC 15.2.0 (Pass 2) ==="

# The book calls for a fresh extraction of GCC for this pass, not a
# reuse of the Pass 1 source tree (which was configured differently
# and already has its own build/ directory state).
cd "$LFS/sources"
rm -rf gcc-15.2.0
# Same UTF-8 filename issue as Pass 1's extraction, scoped locale
# override for this one command only.
LC_ALL=C.utf8 tar xf gcc-15.2.0.tar.xz
cd gcc-15.2.0

tar -xf ../mpfr-4.2.2.tar.xz
mv -v mpfr-4.2.2 mpfr
tar -xf ../gmp-6.3.0.tar.xz
mv -v gmp-6.3.0 gmp
tar -xf ../mpc-1.3.1.tar.gz
mv -v mpc-1.3.1 mpc

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
esac

# Allow libgcc and libstdc++ to build with POSIX threads support.
sed '/thread_header =/s/@.*@/gthr-posix.h/' \
    -i libgcc/Makefile.in libstdc++-v3/include/Makefile.in

rm -rf build
mkdir -v build
cd       build

# Defensive: the book warns to unset any environment variables that
# override default optimization flags before this build. We haven't
# set any such vars anywhere in this build (no CFLAGS/CXXFLAGS
# exports), but unsetting explicitly here costs nothing and guards
# against picking up something from an interactive shell session.
unset CFLAGS CXXFLAGS

time {
../configure                   \
    --build=$(../config.guess) \
    --host=$LFS_TGT            \
    --target=$LFS_TGT          \
    --prefix=/usr               \
    --with-build-sysroot=$LFS  \
    --enable-default-pie       \
    --enable-default-ssp       \
    --disable-nls              \
    --disable-multilib         \
    --disable-libatomic        \
    --disable-libgomp          \
    --disable-libquadmath      \
    --disable-libsanitizer     \
    --disable-libssp           \
    --disable-libvtv           \
    --enable-languages=c,c++   \
    LDFLAGS_FOR_TARGET=-L$PWD/$LFS_TGT/libgcc

make -j$JOBS

make DESTDIR=$LFS install
}

ln -sv gcc $LFS/usr/bin/cc

mark_done "06-gcc-pass2"
echo "=== GCC Pass 2 complete ==="
echo ""
echo "=== Chapter 6 (Cross Compiling Temporary Tools) is now fully complete. ==="
echo "=== Next: Chapter 7, Entering the Chroot Environment. ==="
