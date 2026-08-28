#!/bin/bash
#
# BLFS build: lightdm-1.32.0
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./47-lightdm.sh [--force]
#
# Real dependencies now all satisfied: Exo, libgcrypt, Intltool
# (base LFS), itstool, Linux-PAM, Xorg-Server.
#
# IMPORTANT: this combines our confirmed pinned version (1.32.0) with
# the confirmed real systemd-edition install flow. The book's generic
# "stable" (non-systemd) page includes a step to sed PAM configs from
# systemd to elogind, that is WRONG for us, we have real systemd, not
# elogind, and that sed would break the PAM/systemd integration built
# earlier this project. Confirmed via the actual systemd-edition page
# that no such step exists there, real systemd editions just install
# a proper .service unit via the separate blfs-systemd-units package
# instead. NOT running the elogind sed here.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-lightdm" "$1"

echo "=== Creating dedicated lightdm user/group ==="
if ! getent group lightdm >/dev/null; then
  groupadd -g 65 lightdm
fi
if ! getent passwd lightdm >/dev/null; then
  useradd -c "Lightdm Daemon" \
      -d /var/lib/lightdm \
      -u 65 -g lightdm \
      -s /bin/false lightdm
fi

echo "=== Building lightdm 1.32.0 ==="

cd /root/src
rm -rf lightdm-1.32.0
wget https://github.com/CanonicalLtd/lightdm/releases/download/1.32.0/lightdm-1.32.0.tar.xz
tar xf lightdm-1.32.0.tar.xz
cd lightdm-1.32.0

./configure --prefix=/usr \
            --libexecdir=/usr/lib/lightdm \
            --localstatedir=/var \
            --sbindir=/usr/bin \
            --sysconfdir=/etc \
            --disable-static \
            --disable-tests \
            --with-greeter-user=lightdm \
            --with-greeter-session=lightdm-gtk-greeter \
            --docdir=/usr/share/doc/lightdm-1.32.0
make

make install
cp tests/src/lightdm-session /usr/bin
sed -i '1 s/sh/bash --login/' /usr/bin/lightdm-session
rm -rf /etc/init
install -v -dm755 -o lightdm -g lightdm /var/lib/lightdm
install -v -dm755 -o lightdm -g lightdm /var/lib/lightdm-data
install -v -dm755 -o lightdm -g lightdm /var/cache/lightdm
install -v -dm770 -o lightdm -g lightdm /var/log/lightdm

echo ""
echo "=== Building the lightdm-gtk-greeter ==="
cd /root/src
rm -rf lightdm-gtk-greeter-2.0.9
wget https://github.com/Xubuntu/lightdm-gtk-greeter/releases/download/lightdm-gtk-greeter-2.0.9/lightdm-gtk-greeter-2.0.9.tar.gz
tar xf lightdm-gtk-greeter-2.0.9.tar.gz
cd lightdm-gtk-greeter-2.0.9

./configure --prefix=/usr \
            --libexecdir=/usr/lib/lightdm \
            --sbindir=/usr/bin \
            --sysconfdir=/etc \
            --with-libxklavier \
            --enable-kill-on-sigterm \
            --disable-libido \
            --disable-libindicator \
            --disable-static \
            --disable-maintainer-mode \
            --docdir=/usr/share/doc/lightdm-gtk-greeter-2.0.9
make

make install

mark_done "12-lightdm"
echo "=== lightdm + lightdm-gtk-greeter complete ==="
echo ""
echo "=== Still needed: the lightdm.service systemd unit, from the"
echo "=== separate blfs-systemd-units package. That's the next script. ==="
