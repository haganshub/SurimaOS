#!/bin/bash
#
# SurimaOS build: 8.75. Vim-9.2.0078
# Run INSIDE chroot. Usage: ./73-vim.sh [--force]
#
# NOTE: Vim was deliberately excluded from the original source
# manifest (its version is a moving target per the book). This script
# downloads it directly using the URL/checksum captured from the
# original Chapter 3 package list. If a newer Vim has since been
# adopted by the book, update VIM_VERSION/VIM_URL/VIM_MD5 below.
#
# NOTE: test suite runs as 'tester', outputs to a log file rather
# than the terminal directly (binary test data can corrupt terminal
# state otherwise). "ALL DONE" in that log means success. Two tests
# (Test_client_server_stopinsert, Test_popup_setbuf) are known to
# fail on some systems, not treated as fatal here.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-vim"

VIM_VERSION="9.2.0078"
VIM_URL="https://github.com/vim/vim/archive/v${VIM_VERSION}/vim-${VIM_VERSION}.tar.gz"
VIM_MD5="592819d17a5f76d39ddba5651912afe0"

echo "=== Building Vim ${VIM_VERSION} ==="

cd /sources

if [ ! -f "vim-${VIM_VERSION}.tar.gz" ] || [ "$(md5sum "vim-${VIM_VERSION}.tar.gz" | awk '{print $1}')" != "$VIM_MD5" ]; then
  echo "Downloading Vim ${VIM_VERSION}..."
  rm -f "vim-${VIM_VERSION}.tar.gz"
  wget -q --show-progress "$VIM_URL" -O "vim-${VIM_VERSION}.tar.gz"
  ACTUAL_MD5=$(md5sum "vim-${VIM_VERSION}.tar.gz" | awk '{print $1}')
  if [ "$ACTUAL_MD5" != "$VIM_MD5" ]; then
    echo "ERROR: Vim checksum mismatch (expected $VIM_MD5, got $ACTUAL_MD5)."
    echo "The book may have moved to a newer Vim version. Check"
    echo "https://github.com/vim/vim/tags and update this script."
    exit 1
  fi
fi

rm -rf "vim-${VIM_VERSION}"
tar xf "vim-${VIM_VERSION}.tar.gz"
cd "vim-${VIM_VERSION}"

echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h

time {
./configure --prefix=/usr

make
}

chown -R tester .
sed '/test_plugin_glvs/d' -i src/testdir/Make_all.mak

echo ""
echo "=== Running Vim test suite (this is long, output goes to a log"
echo "=== file, not the terminal, to avoid corrupting terminal state"
echo "=== from binary test data). ==="
set +e
su tester -c "TERM=xterm-256color LANG=en_US.UTF-8 make -j1 test" \
   &> /root/vim-test.log
set -e

if grep -q "ALL DONE" /root/vim-test.log; then
  echo "=== Vim tests: ALL DONE found in log, success. ==="
else
  echo "=== WARNING: 'ALL DONE' not found in /root/vim-test.log."
  echo "=== Review that log. Two known-flaky tests"
  echo "=== (Test_client_server_stopinsert, Test_popup_setbuf) can fail"
  echo "=== on some systems without indicating a real problem. ==="
fi
echo ""

make install

ln -sv vim /usr/bin/vi
for L in  /usr/share/man/{,*/}man1/vim.1; do
    ln -sv vim.1 $(dirname $L)/vi.1
done

ln -sv ../vim/vim92/doc /usr/share/doc/vim-${VIM_VERSION}

echo ""
echo "=== Writing default /etc/vimrc ==="
cat > /etc/vimrc << "EOF"
" Begin /etc/vimrc

" Ensure defaults are set before customizing settings, not after
source $VIMRUNTIME/defaults.vim
let skip_defaults_vim=1

set nocompatible
set backspace=2
set mouse=
syntax on
if (&term == "xterm") || (&term == "putty")
  set background=dark
endif

" End /etc/vimrc
EOF

mark_done "08-vim"
echo "=== Vim complete ==="
