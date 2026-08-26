#!/bin/bash
#
# BLFS build: Linux-PAM-1.7.2
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./33-linux-pam.sh [--force]
#
# This is the real fix for Xorg's PAM warning: Xorg without a
# PAM-enabled systemd either runs as root or malfunctions. This
# script installs PAM itself. Shadow and systemd both need a rebuild
# after this, that's the NEXT two scripts, not this one.
#
# Given how safety-critical this package is (it controls the entire
# login/auth stack), running the full test suite rather than skipping
# it, and following the book's exact configuration steps rather than
# trimming anything.
#
# docs=disabled: the man page build tries to validate XML against a
# DocBook schema over the network (xmllint --nonet, contradictorily),
# and fails without docbook-xml-5.0/libxslt installed, which we
# correctly skipped as optional. Confirmed the real option name by
# checking meson_options.txt directly rather than guessing.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-linux-pam" "$1"

echo "=== Building Linux-PAM 1.7.2 ==="

cd /root/src
rm -rf Linux-PAM-1.7.2
wget https://github.com/linux-pam/linux-pam/releases/download/v1.7.2/Linux-PAM-1.7.2.tar.xz
tar xf Linux-PAM-1.7.2.tar.xz
cd Linux-PAM-1.7.2

mkdir build
cd build

meson setup .. \
      --prefix=/usr \
      --buildtype=release \
      -D docs=disabled \
      -D docdir=/usr/share/doc/Linux-PAM-1.7.2

ninja

echo ""
echo "=== Setting up temporary PAM config for tests ==="
install -v -m755 -d /etc/pam.d
cat > /etc/pam.d/other << "EOF"
auth required pam_deny.so
account required pam_deny.so
password required pam_deny.so
session required pam_deny.so
EOF

echo ""
echo "=== Running the real PAM test suite, no skipping this one ==="
ninja test

echo ""
echo "=== Removing the temporary test config ==="
rm -fv /etc/pam.d/other

ninja install
chmod -v 4755 /usr/sbin/unix_chkpwd

echo ""
echo "=== Writing the real PAM configuration files ==="
install -vdm755 /etc/pam.d
cat > /etc/pam.d/system-account << "EOF"
# Begin /etc/pam.d/system-account

account required pam_unix.so

# End /etc/pam.d/system-account
EOF

cat > /etc/pam.d/system-auth << "EOF"
# Begin /etc/pam.d/system-auth

auth required pam_unix.so

# End /etc/pam.d/system-auth
EOF

cat > /etc/pam.d/system-session << "EOF"
# Begin /etc/pam.d/system-session

session required pam_unix.so

# End /etc/pam.d/system-session
EOF

cat > /etc/pam.d/system-password << "EOF"
# Begin /etc/pam.d/system-password

password required pam_unix.so yescrypt shadow try_first_pass

# End /etc/pam.d/system-password
EOF

cat > /etc/pam.d/other << "EOF"
# Begin /etc/pam.d/other

auth required pam_warn.so
auth required pam_deny.so
account required pam_warn.so
account required pam_deny.so
password required pam_warn.so
password required pam_deny.so
session required pam_warn.so
session required pam_deny.so

# End /etc/pam.d/other
EOF

echo ""
echo "=== Linux-PAM installed and configured ==="
echo "=== IMPORTANT: Shadow and systemd both need to be rebuilt next. ==="
echo "=== Do NOT log out or reboot until systemd is rebuilt with PAM ==="
echo "=== support, or login may not work correctly. ==="

mark_done "11-linux-pam"
echo "=== Linux-PAM complete ==="
