# SurimaOS

SurimaOS is a Linux distribution built from source, following the Linux From Scratch (LFS) and Beyond Linux From Scratch (BLFS) methodology. The kernel and userland are compiled from upstream source, not repackaged from another distro.

**Status: early development.** This is a personal project, not a production-ready distro. Expect rough edges. It's shared publicly so friends and anyone curious can follow along or try it, not as a general recommendation for daily use yet.

## What SurimaOS is

- Built from source, kernel through desktop environment
- systemd for init
- A minimal RPM-based package stack, aiming for a `dnf`-style package management experience
- No Snap packages, no Snap infrastructure
- XFCE as the initial desktop environment
- Design philosophy: aim for the ease of use associated with distros like Linux Mint and Debian, without their common pain points

## What SurimaOS is not

- Not a fork or remaster of another distro's binaries
- Not aiming for wide hardware support or a large user base
- Not stable or feature-complete yet

## Getting a copy

Releases (ISO images) are published under the [Releases](../../releases) tab of this repo. To grab the latest one from the terminal:

```bash
wget https://github.com/haganshub/SurimaOS/releases/latest/download/surimaos.iso
```

(Exact filename will be updated here once the first release is published.)

## Repo layout

```
/docs/     - build documentation and design notes
/scripts/  - build automation scripts
/config/   - kernel config, package version lists
/notes/    - troubleshooting logs and known issues
```

## Background

SurimaOS takes inspiration from the day-to-day usability of Linux Mint, Debian, and OpenMandriva, without copying their packages or infrastructure directly. Everything here is built from upstream source.

## License

TBD.
