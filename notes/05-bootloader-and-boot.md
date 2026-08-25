# 05 — Bootloader, UEFI, and the Real Deployment

This is the phase where the split between build host (ThinkCentre) and
target hardware (Latitude 7280) created the most friction. Most of LFS's
own GRUB chapter assumes you're building directly on the machine you'll
boot from. This project wasn't structured that way, which meant several
steps had to be deliberately deferred and done for real later.

## LFS's own GRUB chapter doesn't apply to a UEFI target

The book is explicit: if the target system is UEFI (confirmed for the
7280 via its BIOS setup screen), skip the LFS book's own GRUB installation
instructions and use BLFS's separate UEFI-specific page instead. The LFS
page's syntax/`grub.cfg` explanation is still useful background, just not
the actual commands to run.

## GRUB was built in chroot, but *not installed*, on purpose

Building the UEFI-capable GRUB binaries (`--with-platform=efi`, since the
GRUB built earlier in the base LFS chapter is BIOS-only) is safe to do
inside chroot on the build host. Actually running `grub-install` with real
EFI variable registration is not: `efivarfs` is a direct kernel interface
to the *physical machine's* firmware NVRAM, chroot cannot isolate or
virtualize it. Running the real install steps on the ThinkCentre would
have written persistent boot-entry data into the ThinkCentre's own UEFI
firmware, for a filesystem that isn't even the ThinkCentre's own disk.

The binaries were built and left ready; the actual `grub-install` and
`grub.cfg` creation were deferred to the real deployment onto the 7280.

## Real deployment: partitioning

The 7280 was partitioned for real by booting a Ventoy USB (already
carrying a live Linux environment) so the internal disk wasn't in use
during the wipe. Final scheme on the 256GB NVMe drive:

| Partition | Size | Type | Mount |
|---|---|---|---|
| `nvme0n1p1` | 1GB | FAT32 (ESP) | `/boot/efi` |
| `nvme0n1p2` | 8GB | swap | swap |
| `nvme0n1p3` | ~229GB | ext4 | `/` |

## Transferring the built system: the `/proc/kcore` trap

The built system was transferred from the ThinkCentre to the new root
partition via `rsync` over the network (Tailscale-reachable at this
point). The first attempt reported a transfer size of ~140 **terabytes**,
because the source path (`/mnt/lfs/proc`) was a *live, mounted* kernel
interface rather than a real directory of files. `/proc/kcore` in
particular is a virtual pseudo-file that reports its size as the entire
addressable memory space (~128-140TB on x86_64), it contains no real data,
but any tool that asks "how big is this" gets told that number.

Fix: explicitly exclude the live virtual filesystems from the transfer:

```bash
rsync -aHAXv --numeric-ids \
  --exclude=/dev/* --exclude=/proc/* --exclude=/sys/* --exclude=/run/* \
  --exclude=/tmp/* --exclude=/sources --exclude=/lost+found \
  connor@<source>:/mnt/lfs/ /mnt/target/
```

(`/sources` was also excluded deliberately: it's pure build scratch space,
every downloaded tarball and build directory, genuinely useless on the
deployed system.)

A second, subtler issue after fixing the above: the transfer under-reported
files because `rsync` was connecting as a non-root user, which correctly
couldn't read root-only source files (`/etc/shadow`, `/root`, etc.). Fixed
with `--rsync-path="sudo rsync"` so the *remote* process runs elevated,
combined with a scoped, temporary, single-command `NOPASSWD` sudo rule
(removed immediately after use) rather than a blanket one.

## GRUB install: no `efibootmgr`, used the fallback path instead

The book's real UEFI install flow normally registers a named boot entry
via `efibootmgr`. That package wasn't built (it has its own dependency
chain: `efivar`, `popt`), and building a 3-package chain just to register
a boot entry a specific way wasn't worth it for a single-machine build.
The book itself documents a fallback for exactly this situation, installing
GRUB to the hardcoded path nearly all UEFI firmware checks automatically:

```bash
grub-install --target=x86_64-efi --removable
```

This worked without any further configuration.

## First boot: root had no password

The very first successful boot reached a real login prompt, but the
`passwd root` step from the base system build had been flagged as a manual
step during the build and never actually confirmed complete. Recovery, done
entirely from the booted system itself, no rescue USB needed:

1. At the GRUB menu, press `e` on the boot entry, append `init=/bin/bash`
   to the kernel command line, boot.
2. `mount -o remount,rw /`
3. Interactive `passwd root` failed silently in this minimal environment
   (no full terminal/job control available). `echo "root:newpassword" |
   chpasswd` worked where the interactive prompt didn't.
4. `reboot -f` refused at first ("Running in chroot, ignoring request"),
   because `/proc` was never mounted in this bare `init=/bin/bash`
   environment and `reboot` assumed it must therefore be running inside a
   chroot. Fixed by mounting `/proc` and `/sys` first, then retrying.

After that, a normal reboot into the real boot chain (not the rescue
kernel parameter) confirmed root login worked correctly and persistently.
