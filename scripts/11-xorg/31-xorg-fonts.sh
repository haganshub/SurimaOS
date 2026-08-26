#!/bin/bash
#
# BLFS build: Xorg Fonts (9 packages in one bundle)
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./31-xorg-fonts.sh [--force]
#
# The final symlink step is meant for non-/usr XORG_PREFIX setups.
# We're already on /usr, so it's technically redundant here, but
# harmless, kept in to match the book exactly.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-xorg-fonts" "$1"

echo "=== Xorg Fonts: downloading all 9 packages first ==="

mkdir -p /root/src/xorg-fonts
cd /root/src/xorg-fonts

cat > font-7.md5 << "EOF"
a6541d12ceba004c0c1e3df900324642  font-util-1.4.1.tar.xz
a56b1a7f2c14173f71f010225fa131f1  encodings-1.1.0.tar.xz
dd1a744b97eb6d388d4e78b17011193e  font-alias-1.0.6.tar.xz
546d17feab30d4e3abcf332b454f58ed  font-adobe-utopia-type1-1.0.5.tar.xz
063bfa1456c8a68208bf96a33f472bb1  font-bh-ttf-1.0.4.tar.xz
51a17c981275439b85e15430a3d711ee  font-bh-type1-1.0.4.tar.xz
00f64a84b6c9886040241e081347a853  font-ibm-type1-1.0.4.tar.xz
fe972eaf13176fa9aa7e74a12ecc801a  font-misc-ethiopic-1.0.5.tar.xz
3b47fed2c032af3a32aad9acc1d25150  font-xfree86-type1-1.0.5.tar.xz
EOF

mkdir -p font
cd font
grep -v '^#' ../font-7.md5 | awk '{print $2}' | wget -i- -c \
    -B https://www.x.org/pub/individual/font/
md5sum -c ../font-7.md5

echo ""
echo "=== All 9 packages verified. Building each in turn. ==="
echo ""

for package in $(grep -v '^#' ../font-7.md5 | awk '{print $2}')
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
echo "=== Linking TrueType font directories for Fontconfig ==="
install -v -d -m755 /usr/share/fonts
ln -svfn $XORG_PREFIX/share/fonts/X11/OTF /usr/share/fonts/X11-OTF
ln -svfn $XORG_PREFIX/share/fonts/X11/TTF /usr/share/fonts/X11-TTF

echo ""
echo "=== All 9 Xorg Fonts packages built and installed ==="

mark_done "11-xorg-fonts"
echo "=== Xorg Fonts bundle complete ==="
