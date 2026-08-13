#!/bin/bash
#
# SurimaOS build: 8.49. OpenSSL-3.6.1
# Run INSIDE chroot. Usage: ./47-openssl.sh [--force]
#
# NOTE: test 30-test_afalg.t is known to fail if the host kernel
# lacks certain crypto API config options, safe to ignore per the
# book. Not treated as fatal here.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-openssl"

echo "=== Building OpenSSL 3.6.1 ==="

cd /sources
rm -rf openssl-3.6.1
tar xf openssl-3.6.1.tar.gz
cd openssl-3.6.1

time {
./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic

make
}

echo ""
echo "=== Running OpenSSL test suite. 30-test_afalg.t may fail depending"
echo "=== on host kernel crypto config, safe to ignore per the book. ==="
echo ""
set +e
HARNESS_JOBS=$(nproc) make test 2>&1 | tee /root/openssl-check-results.log
set -e
echo ""

sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
make MANSUFFIX=ssl install

mv -v /usr/share/doc/openssl /usr/share/doc/openssl-3.6.1
cp -vfr doc/* /usr/share/doc/openssl-3.6.1

mark_done "08-openssl"
echo "=== OpenSSL complete ==="
