#!/bin/bash
#
# SurimaOS build: 8.68. IPRoute2-6.18.0
# Run INSIDE chroot. Usage: ./66-iproute2.sh [--force]
#
# NOTE: no working test suite for this package.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-iproute2"

echo "=== Building IPRoute2 6.18.0 ==="

cd /sources
rm -rf iproute2-6.18.0
tar xf iproute2-6.18.0.tar.xz
cd iproute2-6.18.0

# arpd depends on Berkeley DB, not in LFS, prevent its dir/man page
# from being installed anyway.
sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8

time {
make NETNS_RUN_DIR=/run/netns

make SBINDIR=/usr/sbin install
}

install -vDm644 COPYING README* -t /usr/share/doc/iproute2-6.18.0

mark_done "08-iproute2"
echo "=== IPRoute2 complete ==="
