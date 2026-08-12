#!/bin/bash
#
# SurimaOS build: 6.6. Diffutils-3.12
# Usage: ./05-diffutils.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "06-diffutils"

echo "=== Building Diffutils 3.12 ==="

cd "$LFS/sources"
rm -rf diffutils-3.12
tar xf diffutils-3.12.tar.xz
cd diffutils-3.12

time {
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            gl_cv_func_strcasecmp_works=y \
            --build=$(./build-aux/config.guess)

make -j$JOBS

make DESTDIR=$LFS install
}

mark_done "06-diffutils"
echo "=== Diffutils complete ==="
