#!/bin/bash
#
# SurimaOS build: 8.74. Texinfo-7.2 (final install)
# Run INSIDE chroot. Usage: ./72-texinfo.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-texinfo"

echo "=== Building Texinfo 7.2 (final) ==="

cd /sources
rm -rf texinfo-7.2
tar xf texinfo-7.2.tar.xz
cd texinfo-7.2

# Fix a warning shown by perl-5.42+.
sed 's/! $output_file eq/$output_file ne/' -i tp/Texinfo/Convert/*.pm

time {
./configure --prefix=/usr

make

make check

make install

make TEXMF=/usr/share/texmf install-tex
}

mark_done "08-texinfo"
echo "=== Texinfo complete ==="
