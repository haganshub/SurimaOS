#!/bin/bash
#
# SurimaOS build: 6.4. Bash-5.3
# Usage: ./03-bash.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "06-bash"

echo "=== Building Bash 5.3 ==="

cd "$LFS/sources"
rm -rf bash-5.3
tar xf bash-5.3.tar.gz
cd bash-5.3

time {
./configure --prefix=/usr                      \
            --build=$(sh support/config.guess) \
            --host=$LFS_TGT                    \
            --without-bash-malloc

make -j$JOBS

make DESTDIR=$LFS install
}

ln -sv bash $LFS/bin/sh

mark_done "06-bash"
echo "=== Bash complete ==="
