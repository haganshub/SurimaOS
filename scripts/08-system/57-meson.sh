#!/bin/bash
#
# SurimaOS build: 8.59. Meson-1.10.1
# Run INSIDE chroot. Usage: ./57-meson.sh [--force]
#
# NOTE: test suite requires packages outside LFS scope, skipped per
# the book.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-meson"

echo "=== Building Meson 1.10.1 ==="

cd /sources
rm -rf meson-1.10.1
tar xf meson-1.10.1.tar.gz
cd meson-1.10.1

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD

pip3 install --no-index --find-links dist meson
install -vDm644 data/shell-completions/bash/meson /usr/share/bash-completion/completions/meson
install -vDm644 data/shell-completions/zsh/_meson /usr/share/zsh/site-functions/_meson

mark_done "08-meson"
echo "=== Meson complete ==="
