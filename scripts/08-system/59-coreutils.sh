#!/bin/bash
#
# SurimaOS build: 8.61. Coreutils-9.10 (final install)
# Run INSIDE chroot. Usage: ./59-coreutils.sh [--force]
#
# NOTE: test suite runs in two phases: root-only tests, then a
# larger set as the 'tester' user via su. A temporary 'dummy' group
# is created so multi-group tests aren't skipped, then removed after.
# The stdin redirect (< /dev/null) on the tester run is specifically
# required in SSH/chroot setups like ours per the book, without it
# some tests can break because the host's PTY isn't accessible from
# inside chroot.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-coreutils"

echo "=== Building Coreutils 9.10 (final) ==="

cd /sources
rm -rf coreutils-9.10
tar xf coreutils-9.10.tar.xz
cd coreutils-9.10

patch -Np1 -i ../coreutils-9.10-i18n-1.patch

time {
autoreconf -fv
automake -af
FORCE_UNSAFE_CONFIGURE=1 ./configure \
            --prefix=/usr

make
}

echo ""
echo "=== Running Coreutils root-only tests ==="
set +e
make NON_ROOT_USERNAME=tester check-root 2>&1 | tee /root/coreutils-check-root-results.log
set -e
echo ""

groupadd -g 102 dummy -U tester
chown -R tester .

echo ""
echo "=== Running Coreutils tester-user tests (this is the larger suite) ==="
set +e
su tester -c "PATH=$PATH make -k RUN_EXPENSIVE_TESTS=yes check" \
   < /dev/null 2>&1 | tee /root/coreutils-check-results.log
set -e
echo ""
echo "=== Review /root/coreutils-check-root-results.log and"
echo "=== /root/coreutils-check-results.log for details. ==="
echo ""

groupdel dummy

make install

mv -v /usr/bin/chroot /usr/sbin
mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/' /usr/share/man/man8/chroot.8

mark_done "08-coreutils"
echo "=== Coreutils complete ==="
