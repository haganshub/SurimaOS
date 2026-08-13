#!/bin/bash
#
# SurimaOS build: 8.52. Sqlite-3510200
# Run INSIDE chroot. Usage: ./50-sqlite.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-sqlite"

echo "=== Building Sqlite 3510200 ==="

cd /sources
rm -rf sqlite-autoconf-3510200
tar xf sqlite-autoconf-3510200.tar.gz
cd sqlite-autoconf-3510200

tar -xf ../sqlite-doc-3510200.tar.xz

time {
./configure --prefix=/usr     \
            --disable-static  \
            --enable-fts{4,5} \
            CPPFLAGS="-D SQLITE_ENABLE_COLUMN_METADATA=1 \
                      -D SQLITE_ENABLE_UNLOCK_NOTIFY=1   \
                      -D SQLITE_ENABLE_DBSTAT_VTAB=1     \
                      -D SQLITE_SECURE_DELETE=1"

make LDFLAGS.rpath=""

# No test suite for this package.

make install
}

install -v -m755 -d /usr/share/doc/sqlite-3.51.2
cp -v -R sqlite-doc-3510200/* /usr/share/doc/sqlite-3.51.2

mark_done "08-sqlite"
echo "=== Sqlite complete ==="
