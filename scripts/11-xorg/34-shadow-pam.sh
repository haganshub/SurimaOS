#!/bin/bash
#
# BLFS build: Shadow-4.19.3 (rebuild with Linux-PAM support)
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./34-shadow-pam.sh [--force]
#
# SAFETY CRITICAL. This rebuilds login/su/passwd support. The book's
# own instructions require a MANUAL verification step before doing
# anything further: open a second terminal and confirm login actually
# works. This script stops and prints that instruction rather than
# proceeding automatically, there is no way to safely automate a
# "did I just lock myself out" check.
#
# Recovery path if something's wrong (per the book): rebuild Shadow
# again adding --without-libpam, and restore
# /etc/login.defs.orig back to /etc/login.defs.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "11-shadow-pam" "$1"

echo "=== Rebuilding Shadow 4.19.3 with Linux-PAM support ==="

cd /root/src
rm -rf shadow-4.19.3
wget https://github.com/shadow-maint/shadow/releases/download/4.19.3/shadow-4.19.3.tar.xz
tar xf shadow-4.19.3.tar.xz
cd shadow-4.19.3

sed -i 's/groups$(EXEEXT) //' src/Makefile.in

find man -name Makefile.in -exec sed -i 's/groups\.1 / /' {} \;
find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
find man -name Makefile.in -exec sed -i 's/passwd\.5 / /' {} \;

sed -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD YESCRYPT@' \
    -e 's@/var/spool/mail@/var/mail@' \
    -e '/PATH=/{s@/sbin:@@;s@/bin:@@}' \
    -i etc/login.defs

./configure --sysconfdir=/etc \
            --disable-static  \
            --without-libbsd  \
            --with-{b,yes}crypt
make

make exec_prefix=/usr pamddir= install

echo ""
echo "=== Configuring /etc/login.defs for PAM ==="
install -v -m644 /etc/login.defs /etc/login.defs.orig
for FUNCTION in FAIL_DELAY \
                FAILLOG_ENAB \
                LASTLOG_ENAB \
                MAIL_CHECK_ENAB \
                OBSCURE_CHECKS_ENAB \
                PORTTIME_CHECKS_ENAB \
                QUOTAS_ENAB \
                CONSOLE MOTD_FILE \
                FTMP_FILE NOLOGINS_FILE \
                ENV_HZ PASS_MIN_LEN \
                SU_WHEEL_ONLY \
                PASS_CHANGE_TRIES \
                PASS_ALWAYS_WARN \
                CHFN_AUTH ENCRYPT_METHOD \
                ENVIRON_FILE
do
  sed -i "s/^${FUNCTION}/# &/" /etc/login.defs
done

echo ""
echo "=== Writing /etc/pam.d/login ==="
cat > /etc/pam.d/login << "EOF"
# Begin /etc/pam.d/login

auth optional pam_faildelay.so delay=3000000
auth requisite pam_nologin.so
#auth required pam_securetty.so
#auth optional pam_group.so
auth include system-auth

account required pam_access.so
account include system-account

session required pam_env.so
session required pam_limits.so
#session optional pam_motd.so
#session optional pam_mail.so standard quiet
session include system-session
password include system-password

# End /etc/pam.d/login
EOF

echo "=== Writing /etc/pam.d/passwd ==="
cat > /etc/pam.d/passwd << "EOF"
# Begin /etc/pam.d/passwd

password include system-password

# End /etc/pam.d/passwd
EOF

echo "=== Writing /etc/pam.d/su ==="
cat > /etc/pam.d/su << "EOF"
# Begin /etc/pam.d/su

auth sufficient pam_rootok.so
#auth sufficient pam_wheel.so trust use_uid
auth include system-auth
#auth required pam_wheel.so use_uid
account include system-account

session required pam_env.so
session include system-session

# End /etc/pam.d/su
EOF

echo "=== Writing /etc/pam.d/chpasswd and newusers ==="
cat > /etc/pam.d/chpasswd << "EOF"
# Begin /etc/pam.d/chpasswd

auth sufficient pam_rootok.so
auth include system-auth
account include system-account
password include system-password

# End /etc/pam.d/chpasswd
EOF

sed -e s/chpasswd/newusers/ /etc/pam.d/chpasswd > /etc/pam.d/newusers

echo "=== Writing /etc/pam.d/chage ==="
cat > /etc/pam.d/chage << "EOF"
# Begin /etc/pam.d/chage

auth sufficient pam_rootok.so
auth include system-auth
account include system-account

# End /etc/pam.d/chage
EOF

echo "=== Writing remaining shadow utility pam.d files ==="
for PROGRAM in chfn chgpasswd chsh groupadd groupdel \
               groupmems groupmod useradd userdel usermod
do
  install -v -m644 /etc/pam.d/chage /etc/pam.d/${PROGRAM}
  sed -i "s/chage/$PROGRAM/" /etc/pam.d/${PROGRAM}
done

echo "=== Renaming obsolete access/limits files ==="
if [ -f /etc/login.access ]; then mv -v /etc/login.access{,.NOUSE}; fi
if [ -f /etc/limits ]; then mv -v /etc/limits{,.NOUSE}; fi

echo ""
echo "################################################################"
echo "#  STOP. DO NOT LOG OUT OF THIS SESSION YET.                  #"
echo "#                                                              #"
echo "#  Open a SECOND terminal (new SSH session to the 7280) and   #"
echo "#  confirm you can actually log in, e.g.:                     #"
echo "#      ssh connor@100.64.101.57                               #"
echo "#      login                                                  #"
echo "#                                                              #"
echo "#  If that works with no errors, come back here and run:      #"
echo "#      touch /root/.markers/11-shadow-pam.done                #"
echo "#  to mark this step complete, then continue to the systemd   #"
echo "#  rebuild.                                                    #"
echo "#                                                              #"
echo "#  If it does NOT work, do NOT close this session. Rebuild    #"
echo "#  Shadow again adding --without-libpam to the configure      #"
echo "#  command, and restore /etc/login.defs.orig to               #"
echo "#  /etc/login.defs before doing anything else.                #"
echo "################################################################"
