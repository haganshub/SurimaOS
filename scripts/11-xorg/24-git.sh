#!/bin/bash
#
# BLFS build: Git-2.53.0
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./24-git.sh [--force]
#
# We only actually need this because meson's build system for
# libxml2/other packages unconditionally checks for a git binary, even
# when building from a tarball, not a real git checkout. Skipping the
# docs build (needs xmlto/asciidoc, which we don't have) and the test
# suite (notoriously long, not relevant to just having git exist).
# Also dropping --with-libpcre2 since we haven't confirmed pcre2 is
# built here, it's just a performance flag for git-grep, not essential.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-git" "$1"

echo "=== Building Git 2.53.0 ==="

cd /root/src
rm -rf git-2.53.0
wget https://www.kernel.org/pub/software/scm/git/git-2.53.0.tar.xz
tar xf git-2.53.0.tar.xz
cd git-2.53.0

./configure --prefix=/usr           \
            --with-gitconfig=/etc/gitconfig \
            --with-python=python3

make

make install

mark_done "11-git"
echo "=== Git complete ==="
