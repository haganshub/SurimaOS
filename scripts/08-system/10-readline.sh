#!/bin/bash
#
# SurimaOS build: 8.12. Readline-8.3
# Run INSIDE chroot. Usage: ./10-readline.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-readline"

echo "=== Building Readline 8.3 ==="

cd /sources
rm -rf readline-8.3
tar xf readline-8.3.tar.gz
cd readline-8.3

# Avoid a ldconfig linking bug triggered by reinstalling Readline.
sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install

# Don't hardcode rpath into the shared libraries, not needed for a
# standard-location install and can cause unwanted effects.
sed -i 's/-Wl,-rpath,[^ ]*//' support/shobj-conf

# Upstream fix specific to this Readline version.
sed -e '270a\
     else\
       chars_avail = 1;'      \
    -e '288i\   result = -1;' \
    -i.orig input.c

time {
./configure --prefix=/usr    \
            --disable-static \
            --with-curses    \
            --docdir=/usr/share/doc/readline-8.3

make SHLIB_LIBS="-lncursesw"

# No test suite for this package.

make install
}

install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-8.3

mark_done "08-readline"
echo "=== Readline complete ==="
