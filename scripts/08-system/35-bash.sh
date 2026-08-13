#!/bin/bash
#
# SurimaOS build: 8.37. Bash-5.3 (final install)
# Run INSIDE chroot. Usage: ./35-bash.sh [--force]
#
# IMPORTANT: the book's final step for this package is
# "exec /usr/bin/bash --login", which REPLACES the currently running
# shell process. That's meant to be run interactively at your own
# prompt, NOT embedded here, doing so would hijack this script's
# process and break the run-all.sh chain for later packages. This
# script stops short of that step deliberately, see the reminder
# printed at the end, run it yourself afterward.
#
# NOTE: known test failures per the book: 'run-builtins' may fail on
# some host distros (diff on lines 479/480), and some tests need the
# zh_TW.BIG5 and ja_JP.SJIS locales, which we did not install back in
# the Chapter 8 Glibc locale step (only the book's listed minimum set
# was installed). Not treated as fatal here.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-bash"

echo "=== Building Bash 5.3 (final) ==="

cd /sources
rm -rf bash-5.3
tar xf bash-5.3.tar.gz
cd bash-5.3

time {
./configure --prefix=/usr             \
            --without-bash-malloc     \
            --with-installed-readline \
            --docdir=/usr/share/doc/bash-5.3

make

chown -R tester .

set +e
LC_ALL=C.UTF-8 su -s /usr/bin/expect tester << "EOF" 2>&1 | tee /root/bash-check-results.log
set timeout -1
spawn make tests
expect eof
lassign [wait] _ _ _ value
exit $value
EOF
set -e

echo ""
echo "=== Bash test suite finished. Review /root/bash-check-results.log."
echo "=== Any diff output (lines starting with < or >) indicates a"
echo "=== failure, unless a message says it can be ignored. Known"
echo "=== issues: run-builtins may fail on some hosts (lines 479/480),"
echo "=== and some tests need zh_TW.BIG5/ja_JP.SJIS locales we didn't"
echo "=== install. ==="
echo ""

make install
}

mark_done "08-bash"
echo "=== Bash complete ==="
echo ""
echo "=== MANUAL STEP REQUIRED: run 'exec /usr/bin/bash --login' yourself"
echo "=== now, at your interactive prompt, to switch to the newly built"
echo "=== bash. Do NOT run it from inside another script. ==="
