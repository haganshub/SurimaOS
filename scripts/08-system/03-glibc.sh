#!/bin/bash
#
# SurimaOS build: 8.5. Glibc-2.43 (final install, not the Chapter 5 cross-compile version)
# Run INSIDE chroot. Usage: ./03-glibc.sh [--force]
#
# NOTE: 12 SBU, the largest single build in the project so far. This
# INCLUDES the mandatory test suite (make check). The book is explicit
# that this test suite must not be skipped, but also explicit that a
# handful of failures out of 6000+ tests is normal. This script does
# NOT treat make check failures as fatal (it captures and shows the
# results instead), review the log against the book's known-safe-to-
# ignore list before trusting the result blindly.
#
# ASSUMPTION: defaults the system timezone to America/Detroit based on
# known location context. Override manually if wrong, see the
# ln -sfv /etc/localtime line below.
#
# Strongly recommend running this inside tmux given its length.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-glibc"

echo "=== Building Glibc 2.43 (final) ==="

cd /sources
rm -rf glibc-2.43
tar xf glibc-2.43.tar.xz
cd glibc-2.43

patch -Np1 -i ../glibc-fhs-1.patch

mkdir -v build
cd       build

echo "rootsbindir=/usr/sbin" > configparms

time {
../configure --prefix=/usr                   \
             --disable-werror                \
             --disable-nscd                  \
             libc_cv_slibdir=/usr/lib        \
             --enable-stack-protector=strong \
             --enable-kernel=5.4

make
}

echo ""
echo "=== Running Glibc test suite (mandatory, do not skip). This is long. ==="
echo ""
# Deliberately not using set -e semantics for this one command, a few
# failures are expected. Capture full output to a log for review.
set +e
make check 2>&1 | tee /root/glibc-check-results.log
set -e

echo ""
echo "=== Test suite finished. Review /root/glibc-check-results.log ==="
echo "=== Known-safe-to-ignore per the book: io/tst-lchmod failure is"
echo "=== expected in chroot. Timeout failures (nss/tst-nss-files-hosts-"
echo "=== multi, nptl/tst-thread-affinity*) are common under parallel"
echo "=== make and can be ignored. A handful of failures out of 6000+"
echo "=== tests total is normal. Investigate anything beyond that before"
echo "=== trusting this build. ==="
echo ""

touch /etc/ld.so.conf

# Skip an outdated sanity check that fails against modern Glibc.
sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile

make install

# Fix a hardcoded path to the executable loader in the ldd script.
sed '/RTLDLIST=/s@/usr@@g' -i /usr/bin/ldd

echo ""
echo "=== Installing locales (minimum set for optimal test coverage) ==="
localedef -i C -f UTF-8 C.UTF-8
localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8
localedef -i de_DE -f ISO-8859-1 de_DE
localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
localedef -i de_DE -f UTF-8 de_DE.UTF-8
localedef -i el_GR -f ISO-8859-7 el_GR
localedef -i en_GB -f ISO-8859-1 en_GB
localedef -i en_GB -f UTF-8 en_GB.UTF-8
localedef -i en_HK -f ISO-8859-1 en_HK
localedef -i en_PH -f ISO-8859-1 en_PH
localedef -i en_US -f ISO-8859-1 en_US
localedef -i en_US -f UTF-8 en_US.UTF-8
localedef -i es_ES -f ISO-8859-15 es_ES@euro
localedef -i es_MX -f ISO-8859-1 es_MX
localedef -i fa_IR -f UTF-8 fa_IR
localedef -i fr_FR -f ISO-8859-1 fr_FR
localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
localedef -i is_IS -f ISO-8859-1 is_IS
localedef -i is_IS -f UTF-8 is_IS.UTF-8
localedef -i it_IT -f ISO-8859-1 it_IT
localedef -i it_IT -f ISO-8859-15 it_IT@euro
localedef -i it_IT -f UTF-8 it_IT.UTF-8
localedef -i ja_JP -f EUC-JP ja_JP
localedef -i ja_JP -f UTF-8 ja_JP.UTF-8
localedef -i nl_NL@euro -f ISO-8859-15 nl_NL@euro
localedef -i ru_RU -f KOI8-R ru_RU.KOI8-R
localedef -i ru_RU -f UTF-8 ru_RU.UTF-8
localedef -i se_NO -f UTF-8 se_NO.UTF-8
localedef -i ta_IN -f UTF-8 ta_IN.UTF-8
localedef -i tr_TR -f UTF-8 tr_TR.UTF-8
localedef -i zh_CN -f GB18030 zh_CN.GB18030
localedef -i zh_HK -f BIG5-HKSCS zh_HK.BIG5-HKSCS
localedef -i zh_TW -f UTF-8 zh_TW.UTF-8

echo ""
echo "=== Configuring Glibc: nsswitch.conf ==="
cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files systemd
group: files systemd
shadow: files systemd

hosts: mymachines resolve [!UNAVAIL=return] files myhostname dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF

echo ""
echo "=== Configuring Glibc: time zone data ==="
tar -xf ../../tzdata2025c.tar.gz

ZONEINFO=/usr/share/zoneinfo
mkdir -pv $ZONEINFO/{posix,right}

for tz in etcetera southamerica northamerica europe africa antarctica  \
          asia australasia backward; do
    zic -L /dev/null   -d $ZONEINFO       ${tz}
    zic -L /dev/null   -d $ZONEINFO/posix ${tz}
    zic -L leapseconds -d $ZONEINFO/right ${tz}
done

cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
zic -d $ZONEINFO -p America/New_York
unset ZONEINFO tz

# ASSUMPTION: America/Detroit based on known location. Override this
# line manually if that's wrong before running the script.
ln -sfv /usr/share/zoneinfo/America/Detroit /etc/localtime

echo ""
echo "=== Configuring Glibc: dynamic loader ==="
cat > /etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf
/usr/local/lib
/opt/lib

EOF

cat >> /etc/ld.so.conf << "EOF"
# Add an include directory
include /etc/ld.so.conf.d/*.conf

EOF
mkdir -pv /etc/ld.so.conf.d

mark_done "08-glibc"
echo "=== Glibc complete ==="
