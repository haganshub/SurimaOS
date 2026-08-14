#!/bin/bash
#
# SurimaOS build: 8.81. Procps-ng-4.0.6
# Run INSIDE chroot. Usage: ./79-procps-ng.sh [--force]
#
# NOTE: test suite runs as 'tester'. One test (ps with bsdtime,cputime,
# etime,etimes flags) is known to fail if the host kernel lacks
# CONFIG_BSD_PROCESS_ACCT. Not treated as fatal here.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-procps-ng"

echo "=== Building Procps-ng 4.0.6 ==="

cd /sources
rm -rf procps-ng-4.0.6
tar xf procps-ng-4.0.6.tar.xz
cd procps-ng-4.0.6

time {
./configure --prefix=/usr                           \
            --docdir=/usr/share/doc/procps-ng-4.0.6 \
            --disable-static                        \
            --disable-kill                          \
            --enable-watch8bit                      \
            --with-systemd

make
}

chown -R tester .
echo ""
echo "=== Running Procps-ng test suite. One 'ps' test with"
echo "=== bsdtime,cputime,etime,etimes flags is known to fail if the"
echo "=== host kernel lacks CONFIG_BSD_PROCESS_ACCT, safe to ignore. ==="
echo ""
set +e
su tester -c "PATH=$PATH make check" 2>&1 | tee /root/procps-ng-check-results.log
set -e
echo ""

make install

mark_done "08-procps-ng"
echo "=== Procps-ng complete ==="
