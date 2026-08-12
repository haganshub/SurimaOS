#!/bin/bash
#
# SurimaOS build: 5.3. GCC-15.2.0 - Pass 1
# Usage: ./02-gcc-pass1.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "02-gcc-pass1"

echo "=== Building GCC 15.2.0 (Pass 1) ==="

cd "$LFS/sources"

rm -rf gcc-15.2.0
# GCC's own tarball contains a handful of files with UTF-8 filenames
# (testsuite samples). Extraction under the LC_ALL=POSIX locale set in
# .bashrc fails on those, so override the locale for this extraction
# only, everything else in the build stays under POSIX as intended.
LC_ALL=C.utf8 tar xf gcc-15.2.0.tar.xz
cd gcc-15.2.0

# GCC needs GMP, MPFR, and MPC. Unpack them into the GCC source tree
# and rename so GCC's build system picks them up automatically.
rm -rf mpfr gmp mpc
tar -xf ../mpfr-4.2.2.tar.xz
mv -v mpfr-4.2.2 mpfr
tar -xf ../gmp-6.3.0.tar.xz
mv -v gmp-6.3.0 gmp
tar -xf ../mpc-1.3.1.tar.gz
mv -v mpc-1.3.1 mpc

# On x86_64, set the default 64-bit library directory name to "lib"
# instead of "lib64".
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
../configure                  \
    --target=$LFS_TGT         \
    --prefix=$LFS/tools       \
    --with-glibc-version=2.43 \
    --with-sysroot=$LFS       \
    --with-newlib             \
    --without-headers         \
    --enable-default-pie      \
    --enable-default-ssp      \
    --disable-nls             \
    --disable-shared          \
    --disable-multilib        \
    --disable-threads         \
    --disable-libatomic       \
    --disable-libgomp         \
    --disable-libquadmath     \
    --disable-libssp          \
    --disable-libvtv          \
    --disable-libstdcxx       \
    --enable-languages=c,c++

make -j$JOBS

make install
}

# GCC pass 1 installs a partial internal limits.h. Build the full
# version now using the same method GCC's own build system uses.
cd ..
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include/limits.h

mark_done "02-gcc-pass1"
echo "=== GCC Pass 1 complete ==="
