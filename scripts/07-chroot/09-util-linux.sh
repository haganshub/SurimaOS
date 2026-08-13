#!/bin/bash
#
# SurimaOS build: 7.12. Util-linux-2.41.3
# Run INSIDE the chroot environment, as root.

set -e

if [ "$(whoami)" != "root" ]; then
  echo "ERROR: this must be run as root, currently running as $(whoami)."
  exit 1
fi

echo "=== Building Util-linux 2.41.3 ==="

mkdir -pv /var/lib/hwclock

cd /sources
rm -rf util-linux-2.41.3
tar xf util-linux-2.41.3.tar.xz
cd util-linux-2.41.3

time {
./configure --libdir=/usr/lib     \
            --runstatedir=/run    \
            --disable-chfn-chsh   \
            --disable-login       \
            --disable-nologin     \
            --disable-su          \
            --disable-setpriv     \
            --disable-runuser     \
            --disable-pylibmount  \
            --disable-static      \
            --disable-liblastlog2 \
            --without-python      \
            ADJTIME_PATH=/var/lib/hwclock/adjtime \
            --docdir=/usr/share/doc/util-linux-2.41.3

make -j$(nproc)

make install
}

echo "=== Util-linux complete ==="
echo ""
echo "=== All Chapter 7 temporary tool packages are now built. ==="
echo "=== Next: 7.13, Cleaning up and Saving the Temporary System. ==="
