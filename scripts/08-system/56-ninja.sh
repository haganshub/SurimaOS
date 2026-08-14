#!/bin/bash
#
# SurimaOS build: 8.58. Ninja-1.13.2
# Run INSIDE chroot. Usage: ./56-ninja.sh [--force]
#
# NOTE: tests can't run in chroot (require cmake, out of scope for
# LFS). The --bootstrap build (Ninja rebuilding itself) is treated as
# sufficient basic verification per the book.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-ninja"

echo "=== Building Ninja 1.13.2 ==="

cd /sources
rm -rf ninja-1.13.2
tar xf ninja-1.13.2.tar.gz
cd ninja-1.13.2

# Optional: let Ninja recognize NINJAJOBS env var to cap parallelism.
sed -i '/int Guess/a \
  int   j = 0;\
  char* jobs = getenv( "NINJAJOBS" );\
  if ( jobs != NULL ) j = atoi( jobs );\
  if ( j > 0 ) return j;\
' src/ninja.cc

time {
python3 configure.py --bootstrap --verbose
}

install -vm755 ninja /usr/bin/
install -vDm644 misc/bash-completion /usr/share/bash-completion/completions/ninja
install -vDm644 misc/zsh-completion  /usr/share/zsh/site-functions/_ninja

mark_done "08-ninja"
echo "=== Ninja complete ==="
