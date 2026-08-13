#!/bin/bash
#
# SurimaOS build: 8.46. Intltool-0.51.0
# Run INSIDE chroot. Usage: ./44-intltool.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-intltool"

echo "=== Building Intltool 0.51.0 ==="

cd /sources
rm -rf intltool-0.51.0
tar xf intltool-0.51.0.tar.gz
cd intltool-0.51.0

# Fix a warning caused by perl-5.22+.
sed -i 's:\\\${:\\\$\\{:' intltool-update.in

time {
./configure --prefix=/usr

make

make check

make install
}

install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO

mark_done "08-intltool"
echo "=== Intltool complete ==="
