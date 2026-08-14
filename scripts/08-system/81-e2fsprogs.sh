#!/bin/bash
#
# SurimaOS build: 8.83. E2fsprogs-1.47.3
# Run INSIDE chroot. Usage: ./81-e2fsprogs.sh [--force]
#
# NOTE: m_assume_storage_prezeroed is known to always fail.
# m_rootdir_acl is known to fail unless the LFS build filesystem is
# ext4, ours IS ext4 (the loop image was formatted with mkfs.ext4
# back in Phase 0), so this one should actually pass. Not treated as
# fatal regardless.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-e2fsprogs"

echo "=== Building E2fsprogs 1.47.3 ==="

cd /sources
rm -rf e2fsprogs-1.47.3
tar xf e2fsprogs-1.47.3.tar.gz
cd e2fsprogs-1.47.3

rm -rf build
mkdir -v build
cd       build

time {
../configure --prefix=/usr       \
             --sysconfdir=/etc   \
             --enable-elf-shlibs \
             --disable-libblkid  \
             --disable-libuuid   \
             --disable-uuidd     \
             --disable-fsck

make
}

echo ""
echo "=== Running E2fsprogs test suite. m_assume_storage_prezeroed is"
echo "=== known to always fail. m_rootdir_acl should pass here since"
echo "=== our build filesystem is ext4. ==="
echo ""
set +e
make check 2>&1 | tee /root/e2fsprogs-check-results.log
set -e
echo ""

make install

rm -fv /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a

gunzip -v /usr/share/info/libext2fs.info.gz
install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info

makeinfo -o      doc/com_err.info ../lib/et/com_err.texinfo
install -v -m644 doc/com_err.info /usr/share/info
install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info

mark_done "08-e2fsprogs"
echo "=== E2fsprogs complete ==="
echo ""
echo "=== That was the last real package in Chapter 8. Only the Cleaning"
echo "=== Up step remains (Stripping deliberately deferred). ==="
