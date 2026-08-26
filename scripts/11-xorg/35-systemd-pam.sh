#!/bin/bash
#
# BLFS build: Systemd-259.1 (rebuild with Linux-PAM support)
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./35-systemd-pam.sh [--force]
#
# THE RISKIEST STEP IN THIS PROJECT. This rebuilds and hot-swaps
# PID 1 on a live, running system via systemctl daemon-reexec.
#
# Prerequisites (already confirmed done): Linux-PAM installed,
# Shadow rebuilt with PAM support and genuinely tested via a real
# console login (not just SSH).
#
# Do this only when you're prepared to recover if something goes
# wrong. Keep this SSH session open throughout. Have physical/console
# access to the 7280 available in case a reboot is needed to recover.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-systemd-pam" "$1"

echo "=== Rebuilding systemd 259.1 with Linux-PAM support ==="

cd /root/src
rm -rf systemd-259.1
wget https://github.com/systemd/systemd/archive/v259.1/systemd-259.1.tar.gz
tar xf systemd-259.1.tar.gz
cd systemd-259.1

echo "=== Removing a service known to error on later boots ==="
rm -fv /usr/lib/systemd/system/systemd-update-utmp-runlevel.service

echo "=== Adjusting default udev group rules ==="
sed -i -e 's/GROUP="render"/GROUP="video"/' \
       -e 's/GROUP="sgx", //' rules.d/50-udev-default.rules.in

mkdir build
cd build

meson setup .. \
      --prefix=/usr \
      --buildtype=release \
      -D default-dnssec=no \
      -D firstboot=false \
      -D install-tests=false \
      -D ldconfig=false \
      -D man=auto \
      -D sysusers=false \
      -D rpmmacrosdir=no \
      -D homed=disabled \
      -D mode=release \
      -D pam=enabled \
      -D pamconfdir=/etc/pam.d \
      -D dev-kvm-mode=0660 \
      -D nobody-group=nogroup \
      -D sysupdate=disabled \
      -D ukify=disabled \
      -D docdir=/usr/share/doc/systemd-259.1

ninja

echo ""
echo "=== Installing the rebuilt systemd (binaries only, not yet live) ==="
ninja install

echo ""
echo "=== Adding PAM integration for systemd-logind ==="
grep 'pam_systemd' /etc/pam.d/system-session ||
cat >> /etc/pam.d/system-session << "EOF"
# Begin Systemd addition

session required pam_loginuid.so
session optional pam_systemd.so

# End Systemd addition
EOF

cat > /etc/pam.d/systemd-user << "EOF"
# Begin /etc/pam.d/systemd-user

account required pam_access.so
account include system-account

session required pam_env.so
session required pam_limits.so
session required pam_loginuid.so
session optional pam_keyinit.so force revoke
session optional pam_systemd.so

auth required pam_deny.so
password required pam_deny.so

# End /etc/pam.d/systemd-user
EOF

echo ""
echo "=== Setting up the environment generator for desktop sessions ==="
install -vdm755 /etc/systemd/user-environment-generators
cat > /etc/systemd/user-environment-generators/50-profile.sh << "EOF"
#!/usr/bin/env -S -i /usr/bin/bash
# SPDX-License-Identifier: MIT

. /etc/profile

unset XDG_RUNTIME_DIR
for i in $(locale); do
  unset ${i%=*}
done

unset SHLVL

for i in $(declare -pF | awk '{print $3}'); do
  unset -f $i
done

python3 << _EOF
import os
for var in os.environ:
    if var in ['LC_CTYPE', '_']:
        continue
    print(var + '=' + os.environ[var])
_EOF
EOF

chmod -v 755 /etc/systemd/user-environment-generators/50-profile.sh

echo ""
echo "################################################################"
echo "#  THE ACTUAL RISKY STEP IS NEXT: systemctl daemon-reexec      #"
echo "#  This hot-swaps the running PID 1 for the newly built one.  #"
echo "#                                                              #"
echo "#  This script does NOT run it automatically. Run it           #"
echo "#  yourself, in THIS session, when you're ready:               #"
echo "#      systemctl daemon-reexec                                #"
echo "#                                                              #"
echo "#  After that, per the book: Shadow must already be rebuilt   #"
echo "#  with PAM (confirmed done), then LOG OUT and LOG BACK IN     #"
echo "#  (a real console login, same as the Shadow verification)     #"
echo "#  to register this session with systemd-logind.               #"
echo "#                                                              #"
echo "#  Once daemon-reexec succeeds AND a fresh login works,       #"
echo "#  come back and run:                                          #"
echo "#      touch /root/.markers/11-systemd-pam.done                #"
echo "################################################################"
