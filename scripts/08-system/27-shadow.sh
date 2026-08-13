#!/bin/bash
#
# SurimaOS build: 8.29. Shadow-4.19.3
# Run INSIDE chroot. Usage: ./27-shadow.sh [--force]
#
# NOTE: "passwd root" (setting the root password) is interactive and
# cannot be scripted. Run it manually after this script finishes, see
# the reminder printed at the end.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-shadow"

echo "=== Building Shadow 4.19.3 ==="

cd /sources
rm -rf shadow-4.19.3
tar xf shadow-4.19.3.tar.xz
cd shadow-4.19.3

# Coreutils already provides a better 'groups', and man pages already
# installed via Man-pages, avoid duplicate/conflicting installs.
sed -i 's/groups$(EXEEXT) //' src/Makefile.in
find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;
find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;

# Use YESCRYPT (stronger than default DES-based crypt), fix the mail
# spool location to the FHS-current path, and strip /bin and /sbin
# from PATH in login.defs (they're just symlinks to /usr equivalents).
sed -e 's:#ENCRYPT_METHOD DES:ENCRYPT_METHOD YESCRYPT:' \
    -e 's:/var/spool/mail:/var/mail:'                   \
    -e '/PATH=/{s@/sbin:@@;s@/bin:@@}'                  \
    -i etc/login.defs

touch /usr/bin/passwd

time {
./configure --sysconfdir=/etc   \
            --disable-static    \
            --with-{b,yes}crypt \
            --without-libbsd    \
            --disable-logind    \
            --with-group-name-max-length=32

make

# No test suite for this package.

make exec_prefix=/usr install
make -C man install-man
}

echo ""
echo "=== Configuring Shadow ==="
pwconv
grpconv

mkdir -p /etc/default
useradd -D --gid 999

mark_done "08-shadow"
echo "=== Shadow complete ==="
echo ""
echo "=== IMPORTANT MANUAL STEP: set the root password now with 'passwd root' ==="
echo "=== This is interactive and cannot be scripted. Do it before continuing. ==="
