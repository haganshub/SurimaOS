# 01 — Toolchain (LFS Chapter 5)

The cross-toolchain build (binutils pass 1, GCC pass 1, Linux API headers,
glibc, libstdc++, and the rest of Chapter 5/6) followed the book closely with
no major deviations.

## Notable timings

- GCC Pass 1: ~42 minutes, single-threaded.
- Glibc sanity checks (program interpreter, start files, headers, linker
  paths, libc, dynamic linker): all 6 passed exactly on the first attempt.

## One real bug: directory layout skipped

Chapter 4.2's directory layout step (`mkdir -pv $LFS/{etc,var,lib64} ...` plus
the associated symlinks) was accidentally skipped on the first pass through.
This caused a Glibc symlink failure and misinstalled kernel headers later.

Fix: baked the directory layout and symlink creation directly into
`common.sh` (the shared setup script sourced by every build script from this
point forward), so it runs unconditionally at the start of every chapter,
not just once at the very beginning. This class of mistake shouldn't be
possible to repeat.

## Encoding gotcha

The GCC tarball ships with UTF-8 filenames. Extracting it under the wrong
locale corrupts them. Fix: always extract with `LC_ALL=C.utf8 tar xf
gcc-15.2.0.tar.xz`.
