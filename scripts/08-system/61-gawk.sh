#!/bin/bash
#
# SurimaOS build: 8.63. Gawk-5.3.2 (final install)
# Run INSIDE chroot. Usage: ./61-gawk.sh [--force]
#
# NOTE: test suite runs as 'tester' user, same pattern as GCC/Sed.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-gawk"

echo "=== Building Gawk 5.3.2 (final) ==="

cd /sources
rm -rf gawk-5.3.2
tar xf gawk-5.3.2.tar.xz
cd gawk-5.3.2

sed -i 's/extras//' Makefile.in

time {
./configure --prefix=/usr

make

chown -R tester .
su tester -c "PATH=$PATH make check"

# Remove the Chapter 6 temporary hard link so it gets updated here.
rm -f /usr/bin/gawk-5.3.2
make install
}

ln -sv gawk.1 /usr/share/man/man1/awk.1

install -vDm644 doc/{awkforai.txt,*.{eps,pdf,jpg}} -t /usr/share/doc/gawk-5.3.2

mark_done "08-gawk"
echo "=== Gawk complete ==="
