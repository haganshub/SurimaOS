#!/bin/bash
#
# SurimaOS build: 8.82. Util-linux-2.41.3 (final install)
# Run INSIDE chroot. Usage: ./80-util-linux.sh [--force]
#
# NOTE: test suite runs as 'tester'. Hardlink tests may fail depending
# on host kernel crypto config (CONFIG_CRYPTO_USER_API_HASH / SHA256
# support), lsfd:inotify may fail without CONFIG_NETLINK_DIAG. Not
# treated as fatal here.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-util-linux"

echo "=== Building Util-linux 2.41.3 (final) ==="

cd /sources
rm -rf util-linux-2.41.3
tar xf util-linux-2.41.3.tar.xz
cd util-linux-2.41.3

time {
./configure --bindir=/usr/bin     \
            --libdir=/usr/lib     \
            --runstatedir=/run    \
            --sbindir=/usr/sbin   \
            --disable-chfn-chsh   \
            --disable-login       \
            --disable-nologin     \
            --disable-su          \
            --disable-setpriv     \
            --disable-runuser     \
            --disable-pylibmount  \
            --disable-liblastlog2 \
            --disable-static      \
            --without-python      \
            ADJTIME_PATH=/var/lib/hwclock/adjtime \
            --docdir=/usr/share/doc/util-linux-2.41.3

make
}

touch /etc/fstab
chown -R tester .
set +e
su tester -c "make -k check" 2>&1 | tee /root/util-linux-check-results.log
set -e

make install

mark_done "08-util-linux"
echo "=== Util-linux complete ==="
