#!/bin/bash
#
# BLFS build: XCB Utilities (5 packages in one bundle)
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./12-xcb-utilities.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-xcb-utilities" "$1"

echo "=== XCB Utilities: downloading all 5 packages first ==="

mkdir -p /root/src/xcb-utils
cd /root/src/xcb-utils

cat > xcb-utils.md5 << "EOF"
a67bfac2eff696170259ef1f5ce1b611  xcb-util-image-0.4.1.tar.xz
fbdc05f86f72f287ed71b162f1a9725a  xcb-util-keysyms-0.4.1.tar.xz
193b890e2a89a53c31e2ece3afcbd55f  xcb-util-renderutil-0.3.10.tar.xz
581b3a092e3c0c1b4de6416d90b969c3  xcb-util-wm-0.4.2.tar.xz
e85bccd1993992be07232f8b80a814c8  xcb-util-cursor-0.1.6.tar.xz
EOF

mkdir -p xcb-utils
cd xcb-utils
grep -v '^#' ../xcb-utils.md5 | awk '{print $2}' | wget -i- -c \
     -B https://xorg.freedesktop.org/archive/individual/lib/
md5sum -c ../xcb-utils.md5

echo ""
echo "=== All 5 packages verified. Building each in turn. ==="
echo ""

for package in $(grep -v '^#' ../xcb-utils.md5 | awk '{print $2}')
do
  packagedir=${package%.tar.?z*}
  echo "--- Building $packagedir ---"

  tar -xf $package
  pushd $packagedir
  ./configure $XORG_CONFIG
  make
  make install
  popd
  rm -rf $packagedir
done

echo ""
echo "=== All 5 XCB Utilities packages built and installed ==="

mark_done "11-xcb-utilities"
echo "=== XCB Utilities bundle complete ==="
