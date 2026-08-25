#!/bin/bash
#
# BLFS build: Xorg Libraries (31 packages in one bundle)
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./09-xorg-libraries.sh [--force]
#
# Implements the book's own per-package build loop directly, simplified
# since we're always running as root already (no as_root wrapper
# needed). Test suites are skipped by default, matching the book's own
# default (the do_test call is commented out in the book's script too).

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-xorg-libraries" "$1"

echo "=== Xorg Libraries: downloading all 31 packages first ==="

mkdir -p /root/src/xorg-libs
cd /root/src/xorg-libs

cat > lib-7.md5 << "EOF"
6ad67d4858814ac24e618b8072900664  xtrans-1.6.0.tar.xz
b617a053d2003cc81309f4e13d01379c  libX11-1.8.13.tar.xz
ea8149187a26e9df6dbd94a60b3d8da0  libXext-1.3.7.tar.xz
c5cc0942ed39c49b8fcd47a427bd4305  libFS-1.0.10.tar.xz
d1ffde0a07709654b20bada3f9abdd16  libICE-1.1.2.tar.xz
3aeeea05091db1c69e6f768e0950a431  libSM-1.2.6.tar.xz
ec09c90a1cfd2c0630321d366a5e7203  libXScrnSaver-1.2.5.tar.xz
9acd189c68750b5028cf120e53c68009  libXt-1.3.1.tar.xz
1ef8065f0284e76c2238770365012ab2  libXmu-1.3.1.tar.xz
d22b838e42ac0229ddf5a3afaf23910c  libXpm-3.5.18.tar.xz
2a9793533224f92ddad256492265dd82  libXaw-1.0.16.tar.xz
baa39ada682dd524491a165bb0dfc708  libXfixes-6.0.2.tar.xz
132816d5efccb883bbc2bf45eb905770  libXcomposite-0.4.7.tar.xz
4c54dce455d96e3bdee90823b0869f89  libXrender-0.9.12.tar.xz
5ce55e952ec2d84d9817169d5fdb7865  libXcursor-1.2.3.tar.xz
72bb73f2a07f81784ad69a39d7df1da2  libXdamage-1.1.7.tar.xz
3cba344d6b351cf308114865afa0d91e  libfontenc-1.1.9.tar.xz
66e03e3405d923dfaf319d6f2b47e3da  libXfont2-2.0.7.tar.xz
d378be0fcbd1f689f9a132e0d642bc4b  libXft-2.3.9.tar.xz
95a960c1692a83cc551979f7ffe28cf4  libXi-1.8.2.tar.xz
5f3f5754a40730d1518233a60ba5c48e  libXinerama-1.1.6.tar.xz
b550dfa388292a821aecdd52acecc94c  libXrandr-1.5.5.tar.xz
5014282a08b54ec0edfa73c5cf9ae2c1  libXres-1.2.3.tar.xz
b62dc44d8e63a67bb10230d54c44dcb7  libXtst-1.2.5.tar.xz
8a26503185afcb1bbd2c65e43f775a67  libXv-1.0.13.tar.xz
de4227c5722a8f5ca5748f3ef524aeee  libXvMC-1.0.15.tar.xz
543164f1239fbe92cc0a9128d8da88e9  libXxf86dga-1.1.7.tar.xz
bea9e3707fae6c3275769e771006fa0f  libXxf86vm-1.1.7.tar.xz
57c7efbeceedefde006123a77a7bc825  libpciaccess-0.18.1.tar.xz
fa0faa5b6a8e726186c535d73712ccea  libxkbfile-1.2.0.tar.xz
9805be7e18f858bed9938542ed2905dc  libxshmfence-1.3.3.tar.xz
53b72ce969745f8d3e41175d6549ce0b  libXpresent-1.0.2.tar.xz
EOF

mkdir -p lib
cd lib
grep -v '^#' ../lib-7.md5 | awk '{print $2}' | wget -i- -c \
    -B https://www.x.org/pub/individual/lib/
md5sum -c ../lib-7.md5

echo ""
echo "=== All 31 packages verified. Building each in turn. ==="
echo ""

for package in $(grep -v '^#' ../lib-7.md5 | awk '{print $2}')
do
  packagedir=${package%.tar.?z*}
  echo "--- Building $packagedir ---"

  tar -xf $package
  pushd $packagedir
  docdir="--docdir=$XORG_PREFIX/share/doc/$packagedir"

  do_build() { make; }
  do_install() { make install; }

  case $packagedir in
    libXfont2-[0-9]* )
      ./configure $XORG_CONFIG $docdir --disable-devel-docs
    ;;

    libXt-[0-9]* )
      ./configure $XORG_CONFIG $docdir \
                  --with-appdefaultdir=/etc/X11/app-defaults
    ;;

    libXpm-[0-9]* )
      ./configure $XORG_CONFIG $docdir --disable-open-zfile
    ;;

    libpciaccess* | libxkbfile* )
      meson setup --prefix=$XORG_PREFIX --buildtype=release build
      do_build()   { ninja -C build; }
      do_install() { ninja -C build install; }
    ;;

    * )
      ./configure $XORG_CONFIG $docdir
    ;;
  esac

  do_build
  do_install
  unset do_build do_install

  popd
  rm -rf $packagedir
  /sbin/ldconfig
done

echo ""
echo "=== All 31 Xorg Libraries packages built and installed ==="

mark_done "11-xorg-libraries"
echo "=== Xorg Libraries bundle complete ==="
