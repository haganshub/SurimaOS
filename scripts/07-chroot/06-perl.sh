#!/bin/bash
#
# SurimaOS build: 7.9. Perl-5.42.0
# Run INSIDE the chroot environment, as root.

set -e

if [ "$(whoami)" != "root" ]; then
  echo "ERROR: this must be run as root, currently running as $(whoami)."
  exit 1
fi

echo "=== Building Perl 5.42.0 ==="

cd /sources
rm -rf perl-5.42.0
tar xf perl-5.42.0.tar.xz
cd perl-5.42.0

time {
sh Configure -des                                         \
             -D prefix=/usr                               \
             -D vendorprefix=/usr                         \
             -D useshrplib                                \
             -D privlib=/usr/lib/perl5/5.42/core_perl     \
             -D archlib=/usr/lib/perl5/5.42/core_perl     \
             -D sitelib=/usr/lib/perl5/5.42/site_perl     \
             -D sitearch=/usr/lib/perl5/5.42/site_perl    \
             -D vendorlib=/usr/lib/perl5/5.42/vendor_perl \
             -D vendorarch=/usr/lib/perl5/5.42/vendor_perl

make -j$(nproc)

make install
}

echo "=== Perl complete ==="
