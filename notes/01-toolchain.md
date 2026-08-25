# 01 - Toolchain (LFS Chapter 5)

Cross-toolchain build (binutils pass 1, GCC pass 1, Linux API headers,
glibc, libstdc++) followed the book with no major deviations.

Timings: GCC Pass 1 took about 42 minutes, single-threaded. Glibc sanity
checks (program interpreter, start files, headers, linker paths, libc,
dynamic linker) all passed on the first attempt.

## Skipped a directory layout step

Skipped Chapter 4.2's directory layout step (`mkdir -pv $LFS/{etc,var,lib64}
...` plus symlinks) the first time through. Caused a Glibc symlink failure
and misinstalled kernel headers later.

Fix: put the directory layout and symlink creation into common.sh, the
shared setup script every build script sources, so it runs at the start of
every chapter instead of once at the beginning.

## Encoding

The GCC tarball ships with UTF-8 filenames. Extracting under the wrong
locale corrupts them. Always extract with `LC_ALL=C.utf8 tar xf
gcc-15.2.0.tar.xz`.
