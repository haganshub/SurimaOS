# Custom Linux Distro - Roadmap & Direction Document

This file is the source of truth for this project. Update it as phases are completed. Every checkbox here should eventually be checked off, or explicitly marked as skipped with a reason.

## Project Overview

**Goal:** Build a personal-use Linux distribution from source, following the Linux From Scratch (LFS) and Beyond Linux From Scratch (BLFS) methodology. The kernel and every userland package are compiled from upstream source rather than copied as binaries from another distro. Conventions and defaults are inspired by Linux Mint, Debian, and OpenMandriva, but nothing is lifted wholesale from them.

**Not a goal:** Wide distribution, a polished public release, or replacing the daily driver setup that already works. This stays a personal project unless that changes later.

**Guinea pig hardware:** Dell Latitude 7280, repurposed from a prior refurb project.

**Build host:** A separate working Linux machine is required to cross-compile/build the new system (LFS is built from inside an existing Linux installation, then the result is transferred to the target hardware). This should be decided in Phase 0.

## Guardrails (do not violate these without a deliberate decision and a note here)

- No snap packages, no snap infrastructure.
- No wholesale copying of another distro's compiled binaries or packages. Source only.
- Kernel is upstream Linux source, configured and compiled by hand, not written from scratch.
- Package manager preference leans toward the `dnf`/RPM-style experience, but see the open decision below, this is not settled yet.
- Desktop environment starts with XFCE. Architecture should not lock out swapping to another DE later.

## Decisions (resolved)

- [x] **Package manager:** Minimal RPM stack, built via BLFS, aiming for a `dnf`-like experience.
- [x] **Distro name:** SurimaOS (Surima Linux).
- [x] **Init system:** systemd.
- [x] **Distribution format:** Bootable ISO (primary, for sharing with friends) plus the ability to test via direct transfer to the 7280 during development.
- [x] **Build host:** Spare Dell OptiPlex Micro (3060 or 3070), 128GB SSD, 8GB RAM. Powered on only during active build sessions, not a 24/7 machine. Disk/RAM are workable to start; consider upgrading either if it becomes a bottleneck around Phase 7-9.

## Repo Structure (GitHub)

```
/docs/            - this roadmap, build logs, architecture/decision notes
/scripts/         - build automation, meant to be wget-able and runnable standalone
/config/          - kernel .config, package version lists, build variables
/notes/           - troubleshooting logs, per-package gotchas
README.md         - project description, quick start, wget instructions
```

Actual bootable ISOs are NOT committed to the git history (too large, bad for repo size/history). They get attached as binary assets on GitHub Releases instead, with the README pointing to the latest release.

---

## Phase 0: Preparation

- [ ] Decide which machine is the build host (not the Latitude 7280, that's the target).
- [ ] Install/confirm a working Linux system on the build host with enough disk space (LFS recommends 30GB+ free for the build itself).
- [~] Read through the current LFS book (stable release) front to back once, no building yet, just to know what's coming. **In progress, using systemd edition: https://www.linuxfromscratch.org/lfs/view/stable-systemd/**
- [ ] Read the corresponding BLFS sections for Xorg + XFCE so Phase 7 isn't a surprise.
- [ ] Create the GitHub repo with the folder structure above.
- [ ] Write the initial README with project intent and this roadmap linked.
- [x] Back up anything currently on the Latitude 7280 that matters, then confirm it's safe to wipe. **Confirmed clean, currently running OM Cooker, nothing meaningful stored on it.**
- [ ] Set up the GitHub repo via CLI (git init, structure, README, first commit, push). In progress, see terminal steps below.

## Phase 1: Host Prep & Toolchain

- [ ] Verify build host meets LFS host requirements (compiler versions, bash, coreutils, etc. - the LFS book has a host requirements check script).
- [ ] Partition and mount the target LFS build filesystem (this can live on the build host initially, then be transferred, or be built in a spare partition/drive attached to the build host).
- [ ] Set required environment variables (`$LFS`, etc.).
- [ ] Build binutils and gcc pass 1 (cross-toolchain).
- [ ] Build Linux API headers.
- [ ] Build glibc.
- [ ] Build remaining pass 1 packages (libstdc++, m4, ncurses, bash, coreutils, etc. per the book).
- [ ] Log every package version used in `/config/` as you go.

## Phase 2: Temporary System / Chroot

- [ ] Build pass 2 toolchain packages inside the LFS environment.
- [ ] Enter the chroot.
- [ ] Build remaining temporary tools needed to build the final system.
- [ ] Note any deviations from the book here (version bumps, patches skipped, etc.) in `/notes/`.

## Phase 3: Base System Build

- [ ] Build the full LFS base system package set inside the chroot (this is the bulk of the compile time).
- [ ] Strip debugging symbols per the book's guidance to save space, if desired.
- [ ] Clean up the toolchain.
- [ ] **Checkpoint:** confirm you have a minimal bootable base system before moving on.
- [ ] Revisit the "Package manager" open decision now that the base system exists.

## Phase 4: Kernel

- [ ] Pull upstream kernel source (matching version choice to something well-documented and stable, not bleeding edge, for the first build).
- [ ] Configure the kernel (`make menuconfig` or similar) targeting the Latitude 7280's hardware (CPU, chipset, wifi/bluetooth chip, storage controller).
- [ ] Compile and install the kernel and modules.
- [ ] Document the working `.config` in `/config/`.

## Phase 5: Bootloader & Init

- [ ] Confirm init system decision (systemd assumed).
- [ ] Configure and install GRUB (or chosen bootloader).
- [ ] Set up fstab, hostname, basic networking config.
- [ ] Create a non-root user.
- [ ] **Checkpoint:** system should boot standalone at this point, text-mode only.

## Phase 6: Package Manager & Core Userland Extras

- [ ] Implement whatever was decided in the package manager open decision.
- [ ] Add core utilities not covered by base LFS but needed day-to-day (sudo, a text editor, networking tools, SSH).
- [ ] Confirm networking works end-to-end on the Latitude 7280 (wifi driver support is the most likely snag on this hardware).

## Phase 7: Desktop Environment (XFCE)

- [ ] Build Xorg per BLFS.
- [ ] Confirm display drivers work for the Latitude 7280's GPU.
- [ ] Build XFCE component stack per BLFS.
- [ ] Get a graphical login working (display manager choice - lightdm is a common, lighter pairing with XFCE).
- [ ] Basic theming/defaults pass.
- [ ] **Checkpoint:** graphical desktop boots and is usable for basic tasks.

## Phase 8: Personalization & Polish

- [ ] Pick and lock in the distro name (open decision above).
- [ ] Branding pass: wallpaper, login screen, distro identifier files (`/etc/os-release`, etc.).
- [ ] Default application set (browser, file manager, terminal, etc.).
- [ ] Config defaults that reflect the "easy like Mint/Debian, without the pitfalls" goal - sane out-of-box settings, no snap-equivalent friction.
- [ ] Sanity pass on package manager UX now that real usage is happening.

## Phase 9: Bootable Image & Distribution

- [ ] Resolve ISO vs. live-transfer open decision.
- [ ] Build a bootable ISO or USB image from the finished system.
- [ ] Test the image boots on a machine other than the original build host, ideally a clean boot on the Latitude 7280 from a fresh wipe.
- [ ] Write install instructions in the README (wget-friendly, matches the project goal of others being able to pull it down).
- [ ] Publish the first ISO as a GitHub Release.

## Phase 10: Testing & Stabilization

- [ ] Full clean install on the Latitude 7280 from the published image.
- [ ] Daily-use shakeout: does wifi survive sleep/resume, does the DE stay stable, are there missing drivers.
- [ ] Log every issue found in `/notes/`, fix or document as known-issue.
- [ ] Tag a stable release once the above is clean for a stretch of real use.

## Phase 11 (Future / Optional): DE Flexibility

- [ ] If/when swapping XFCE for another DE is wanted, document the process here rather than starting a new project from scratch. The base system built in Phases 1-6 should not need to be touched.

---

## Build Log

Use this section (or move it to `/notes/build-log.md` once it gets long) to keep a running dated log of sessions, what got done, what broke, what got fixed. Future you will thank present you.

- **[date]** - Project kicked off. Roadmap drafted.
