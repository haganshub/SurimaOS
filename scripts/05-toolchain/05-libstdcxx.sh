#!/bin/bash
#
# SurimaOS build: 5.6. Libstdc++ from GCC-15.2.0
# Usage: ./05-libstdcxx.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "05-libstdcxx"

echo "=== Building Libstdc++ (from GCC 15.2.0 source) ==="

# Libstdc++ builds from the same GCC source tree already extracted
# during 02-gcc-pass1.sh, it just wasn't buildable yet at that point
# since it depends on Glibc, which didn't exist in the target dir yet.
cd "$LFS/sources/gcc-15.2.0"

rm -rf build
mkdir -v build
cd       build

time {
../libstdc++-v3/configure      \
    --host=$LFS_TGT            \
    --build=$(../config.guess) \
    --prefix=/usr              \
    --disable-multilib         \
    --disable-nls              \
    --disable-libstdcxx-pch    \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/15.2.0

make -j$JOBS

make DESTDIR=$LFS install
}

# Libtool archive files are harmful for cross-compilation, remove them.
rm -v $LFS/usr/lib/lib{stdc++{,exp,fs},supc++}.la

mark_done "05-libstdcxx"
echo "=== Libstdc++ complete ==="
echo ""
echo "=== Chapter 5 (Cross-Toolchain) is now fully complete. ==="
echo "=== Next: Chapter 6, Cross Compiling Temporary Tools. ==="
