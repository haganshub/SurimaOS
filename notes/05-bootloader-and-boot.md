# 05 - Bootloader, UEFI, and Deploying to the 7280

Building on one machine and deploying to another (see `00-preparation.md`)
caused the most friction of the whole project right here. Most of LFS's
GRUB chapter assumes you're building directly on the machine you'll boot
from. I wasn't, so several steps had to wait until the real deployment.

## LFS's GRUB chapter doesn't apply on UEFI

The book says: if the target is UEFI (confirmed for the 7280 in its BIOS
setup screen), skip the LFS book's own GRUB install instructions and use
BLFS's UEFI-specific page instead. The LFS page's grub.cfg syntax
explanation is still useful, just not the actual commands.

## Built GRUB in chroot, didn't install it

Building the UEFI-capable GRUB binaries (--with-platform=efi, since the
GRUB from the base LFS chapter is BIOS-only) is fine to do in chroot on
the build host. Running grub-install with real EFI variable registration
isn't: efivarfs is a direct interface to the physical machine's firmware
NVRAM, chroot can't isolate it. Doing that on the ThinkCentre would have
written boot-entry data into the ThinkCentre's own firmware, for a
filesystem that isn't even its disk.

Built the binaries, left the actual install for the real hardware.

## Partitioning the 7280

Booted a Ventoy USB with a live environment so the internal disk wasn't in
use during the wipe. Final layout on the 256GB NVMe:

| Partition | Size | Type | Mount |
|---|---|---|---|
| nvme0n1p1 | 1GB | FAT32 (ESP) | /boot/efi |
| nvme0n1p2 | 8GB | swap | swap |
| nvme0n1p3 | ~229GB | ext4 | / |

## The /proc/kcore trap

Transferred the built system over rsync (Tailscale-reachable at this
point). First attempt reported a transfer size of ~140 terabytes, because
the source path (/mnt/lfs/proc) was a live mounted kernel interface, not a
real directory. /proc/kcore reports its size as the entire addressable
memory space, no real data behind it, but any tool asking "how big is
this" gets told that number.

Fixed by excluding the live filesystems:

```bash
rsync -aHAXv --numeric-ids \
  --exclude=/dev/* --exclude=/proc/* --exclude=/sys/* --exclude=/run/* \
  --exclude=/tmp/* --exclude=/sources --exclude=/lost+found \
  connor@<source>:/mnt/lfs/ /mnt/target/
```

(/sources excluded too, pure build scratch space, no reason to bring it
along.)

Second issue after that: transfer under-reported files because rsync
connected as a non-root user, which correctly couldn't read root-only
files (/etc/shadow, /root). Fixed with --rsync-path="sudo rsync" so the
remote side runs elevated, plus a scoped, temporary NOPASSWD sudo rule
removed right after.

## GRUB install without efibootmgr

The book's normal UEFI flow registers a named boot entry via efibootmgr.
Didn't build it, its own dependency chain (efivar, popt) wasn't worth it
for one machine. The book documents a fallback for exactly this, installs
GRUB to the hardcoded path almost all UEFI firmware checks automatically:

```bash
grub-install --target=x86_64-efi --removable
```

Worked with no further config.

## First boot: no root password

First successful boot reached a real login prompt, but `passwd root` from
the base system build had been a manual step that never actually got
confirmed. Fixed from the booted system itself, no rescue USB:

1. At GRUB, press e, append init=/bin/bash to the kernel line, boot.
2. mount -o remount,rw /
3. Interactive passwd root failed silently in this bare environment (no
   terminal/job control). `echo "root:newpassword" | chpasswd` worked.
4. reboot -f refused at first ("Running in chroot, ignoring request"),
   because /proc was never mounted here and reboot assumed a chroot.
   Mounted /proc and /sys first, then it worked.

Normal reboot after that confirmed root login worked and stuck.
