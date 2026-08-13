#!/bin/bash
#
# SurimaOS build: 8.45. XML::Parser-2.47
# Run INSIDE chroot. Usage: ./43-xml-parser.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-xml-parser"

echo "=== Building XML::Parser 2.47 ==="

cd /sources
rm -rf XML-Parser-2.47
tar xf XML-Parser-2.47.tar.gz
cd XML-Parser-2.47

time {
perl Makefile.PL

make

make test

make install
}

mark_done "08-xml-parser"
echo "=== XML::Parser complete ==="
