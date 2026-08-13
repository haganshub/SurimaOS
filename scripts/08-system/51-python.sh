#!/bin/bash
#
# SurimaOS build: 8.53. Python-3.14.3 (final install)
# Run INSIDE chroot. Usage: ./51-python.sh [--force]
#
# NOTE: 2.6 SBU, with --enable-optimizations the interpreter builds
# TWICE (once to profile, once optimized), expect this to take longer
# than the SBU number alone suggests. Some tests are known to
# occasionally hang, hence the --timeout on the test suite.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-python"

echo "=== Building Python 3.14.3 (final) ==="

cd /sources
rm -rf Python-3.14.3
tar xf Python-3.14.3.tar.xz
cd Python-3.14.3

time {
./configure --prefix=/usr          \
            --enable-shared        \
            --with-system-expat    \
            --enable-optimizations \
            --without-static-libpython

make
}

echo ""
echo "=== Running Python test suite (2-minute per-test timeout, some"
echo "=== tests are known to occasionally hang and will auto-retry"
echo "=== once if they fail). ==="
echo ""
set +e
make test TESTOPTS="--timeout 120" 2>&1 | tee /root/python-check-results.log
set -e
echo ""

make install

# Suppress root-user and version-check pip warnings that don't apply
# to this build context (no package manager conflict, no network yet).
cat > /etc/pip.conf << EOF
[global]
root-user-action = ignore
disable-pip-version-check = true
EOF

# Optional documentation install.
install -v -dm755 /usr/share/doc/python-3.14.3/html

tar --strip-components=1  \
    --no-same-owner       \
    --no-same-permissions \
    -C /usr/share/doc/python-3.14.3/html \
    -xf ../python-3.14.3-docs-html.tar.bz2

mark_done "08-python"
echo "=== Python complete ==="
