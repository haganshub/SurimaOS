#!/bin/bash
#
# SurimaOS build: 8.78. Systemd-259.1
# Run INSIDE chroot. Usage: ./76-systemd.sh [--force]
#
# NOTE: test suite runs inside a separate mount namespace (unshare -m)
# so a test's mount point gets auto-cleaned rather than lingering in
# /tmp. systemd:core / test-namespace is known to fail in chroot,
# other failures may depend on host kernel config. Not treated as
# fatal here.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "08-systemd"

echo "=== Building Systemd 259.1 ==="

cd /sources
rm -rf systemd-259.1
tar xf systemd-259.1.tar.gz
cd systemd-259.1

# Remove two unneeded groups from default udev rules.
sed -e 's/GROUP="render"/GROUP="video"/' \
    -e 's/GROUP="sgx", //'               \
    -i rules.d/50-udev-default.rules.in

rm -rf build
mkdir -p build
cd       build

time {
meson setup ..                \
      --prefix=/usr           \
      --buildtype=release     \
      -D default-dnssec=no    \
      -D firstboot=false      \
      -D install-tests=false  \
      -D ldconfig=false       \
      -D sysusers=false       \
      -D rpmmacrosdir=no      \
      -D homed=disabled       \
      -D man=disabled         \
      -D mode=release         \
      -D pamconfdir=no        \
      -D dev-kvm-mode=0660    \
      -D nobody-group=nogroup \
      -D sysupdate=disabled   \
      -D ukify=disabled       \
      -D docdir=/usr/share/doc/systemd-259.1

ninja
}

echo ""
echo "=== Running Systemd test suite in an isolated mount namespace ==="
echo "=== systemd:core / test-namespace is known to fail in chroot. ==="
echo ""
echo 'NAME="Linux From Scratch"' > /etc/os-release
set +e
unshare -m ninja test 2>&1 | tee /root/systemd-check-results.log
set -e
echo ""

ninja install

tar -xf ../../systemd-man-pages-259.1.tar.xz \
    --no-same-owner --strip-components=1     \
    -C /usr/share/man

systemd-machine-id-setup

systemctl preset-all

mark_done "08-systemd"
echo "=== Systemd complete ==="
