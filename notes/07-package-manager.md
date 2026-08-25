# 07 - Package Manager: Why Not DNF

## The original plan

Started with a goal of a minimal RPM stack for a dnf-like day-to-day
experience, similar to the OpenMandriva systems already in use for this
build's own tooling.

## What changed it

Turns out neither RPM nor DNF is documented anywhere in BLFS. The only
"RPM on an LFS-family system" resource out there is a third-party project
that uses a container-based staged build, a different approach than the
direct chroot-and-boot method used here. Same kind of gap hit earlier with
iwd (`04-kernel.md`), an assumption about what a "normal" distro provides
that didn't match what the book actually documents.

Building RPM plus DNF5 unguided means a large dependency chain (DNF5 pulls
in C++, Python, and Ruby tooling) with no version-pinned reference to
follow. Not worth the risk for what it'd get.

## Pacman instead

Went with pacman, Arch's package manager. Real dependency resolution, a
real local package database, and a smaller dependency chain than DNF's.

One limitation worth being clear about: this doesn't give access to
Arch's actual repos. Their .pkg.tar.zst files are built against Arch's own
library versions and would hit the same binary-incompatibility wall that
already ruled out copying binaries from any other distro onto this system
(see `06-networking-and-remote-access.md`). What pacman gives here is
local, dependency-tracked package management for software built from
source on this system, not a shortcut to prebuilt Arch packages.

## Build chain

Three packages that are actually in BLFS, no issues:

- libarchive-3.8.5
- libpsl-0.21.5
- curl-8.18.0

Then two unguided builds, no BLFS page for either:

- pacman v7.0.0, built from Arch's own source via meson
  (crypto=openssl, curl=enabled, gpgme/doc/file-seccomp disabled to keep
  scope minimal). Compiled clean first try, 291/291 targets.
- fakeroot 2.1.4, needed by makepkg so an unprivileged user can build
  packages containing root-owned files. Meson-based too. Found the right
  version by checking Debian's actual current package pool rather than
  trusting an old search result pointing at a version already superseded.

## Local repo

No upstream to point at, so I made one:

```
[surima]
SigLevel = Never
Server = file:///srv/surima-repo
```

SigLevel = Never, not the more common Optional TrustAll, because gpgme
was disabled at build time. This pacman binary has no signature
verification code compiled in, not just a lenient policy toward it.
Optional TrustAll still assumes signature machinery exists to be lenient
about, and won't parse without it.

## Proving it works

Wrote a PKGBUILD for nano (already built manually earlier), built it with
makepkg -s as the regular user (makepkg refuses to run as root), added it
to the repo with repo-add, installed with pacman -S nano.

Caught a real conflict on the first attempt: the manually-built nano files
already existed on disk, outside pacman's tracking, and it refused to
overwrite them. Fixed with pacman -S nano --overwrite '*' to adopt the
existing files, after which pacman -Qi nano showed correct package
metadata.

## The wrapper

/usr/local/bin/sos execs straight through to pacman. Landed on "sos"
after trying a handful of names, short to type, and a small pun (SurimaOS
initials plus the actual word). Pacman itself and its config are
untouched, just a personalized command name.
