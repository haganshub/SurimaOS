#!/bin/bash
#
# SurimaOS build: 10.3. Linux-6.18.10 (Part 2 of 2)
# Run INSIDE chroot, from /sources/linux-6.18.10, AFTER menuconfig
# and config-fixup.sh have both been completed and verified.
# Usage: ./02-kernel-part2.sh [--force]

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "10-kernel-part2"

cd /sources/linux-6.18.10

if [ ! -f .config ]; then
  echo "ERROR: no .config found. Run 01-kernel-part1.sh and menuconfig first."
  exit 1
fi

echo "=== Building kernel image and modules (this will take a while) ==="

time {
make

make modules_install
}

echo ""
echo "=== Installing kernel files to /boot ==="

cp -iv arch/x86/boot/bzImage /boot/vmlinuz-6.18.10-lfs-13.0-systemd
cp -iv System.map /boot/System.map-6.18.10
cp -iv .config /boot/config-6.18.10

cp -r Documentation -T /usr/share/doc/linux-6.18.10

echo ""
echo "=== Setting kernel source tree ownership to root (retaining it"
echo "=== for future BLFS kernel config updates, per the book) ==="
chown -R 0:0 /sources/linux-6.18.10

echo ""
echo "=== Configuring USB module load order ==="
install -v -m755 -d /etc/modprobe.d
cat > /etc/modprobe.d/usb.conf << "EOF"
# Begin /etc/modprobe.d/usb.conf

install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true

# End /etc/modprobe.d/usb.conf
EOF

mark_done "10-kernel-part2"
echo "=== Kernel build and install complete ==="
echo ""
echo "=== Next: GRUB, to actually make this bootable. ==="
