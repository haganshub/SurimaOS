# 02 - Temporary System and Chroot (LFS Chapters 6-7)

Scripts staged in build-scripts/ on the host side, copied into
/root/scripts/ inside the chroot. Every package got its own numbered
script, run through a run-all.sh that stops on the first failure and
tracks completion via marker files in /sources/.markers/.

## SSH drops kill non-tmux processes

Building GCC, Glibc, etc. takes long enough that SSH will drop mid-build.
Anything not running inside tmux dies with the connection. Found out the
hard way on a 2.4GB Glibc backup, had to restart it inside tmux. Everything
long-running from that point on ran in tmux.

## Ownership gap, found much later

Chapter 7's ownership fix (`chown --from lfs -R root:root
$LFS/{usr,var,etc,tools,lib64}`) only covers those named directories. It
doesn't touch the top-level $LFS directory itself, or the bin/sbin/lib
symlinks from the initial setup. Those four paths kept the temporary lfs
build user's UID/GID all the way through the build. Didn't catch it until
a filesystem audit during the real deployment (`find` on -uid/-gid turned
it up).

Not a security issue, symlink ownership is cosmetic, the kernel checks the
target's permissions, not the link's. Fixed by adding this right after the
book's chown command:

```bash
chown -h root:root $LFS $LFS/bin $LFS/sbin $LFS/lib
```

## Chroot entry

Standard entry, worked fine once /dev, /dev/pts, /proc, /sys, /run were
bind-mounted per the book. These have to be redone every time you re-enter
chroot after a reboot, they don't persist.
