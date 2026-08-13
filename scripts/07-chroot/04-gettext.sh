#!/bin/bash
#
# SurimaOS build: 7.7. Gettext-1.0
# Run INSIDE the chroot environment, as root.

set -e

if [ "$(whoami)" != "root" ]; then
  echo "ERROR: this must be run as root, currently running as $(whoami)."
  exit 1
fi

echo "=== Building Gettext 1.0 (partial install, chroot temp tools) ==="

cd /sources
rm -rf gettext-1.0
tar xf gettext-1.0.tar.xz
cd gettext-1.0

time {
./configure --disable-shared

make -j$(nproc)
}

# Only three binaries are needed for the temporary toolset, not a
# full install.
cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin

echo "=== Gettext complete ==="
