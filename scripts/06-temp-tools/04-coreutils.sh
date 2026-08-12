#!/bin/bash
#
# SurimaOS build: 6.5. Coreutils-9.10
# Usage: ./04-coreutils.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "06-coreutils"

echo "=== Building Coreutils 9.10 ==="

cd "$LFS/sources"
rm -rf coreutils-9.10
tar xf coreutils-9.10.tar.xz
cd coreutils-9.10

time {
./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --enable-install-program=hostname \
            --enable-no-install-program=kill,uptime

make -j$JOBS

make DESTDIR=$LFS install
}

# Move programs to their final expected locations, some other
# programs hardcode these paths even in the temporary environment.
mv -v $LFS/usr/bin/chroot              $LFS/usr/sbin
mkdir -pv $LFS/usr/share/man/man8
mv -v $LFS/usr/share/man/man1/chroot.1 $LFS/usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/'                    $LFS/usr/share/man/man8/chroot.8

mark_done "06-coreutils"
echo "=== Coreutils complete ==="
