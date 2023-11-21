#!/usr/bin/bash

# Back up of ssh server original configuration file.

cp /etc/ssh/sshd_config /etc/ssh/sshd_config.$EPOCHSECONDS.bck

sed -i -e '/#Port 22/ s/#Port 22/Port 4242/' /etc/ssh/sshd_config
sed -i -e '/#PermitRootLogin/ s/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i -e '/^PermitRootLogin no/a AllowUsers luicasad' /etc/ssh/sshd_config
sed -i -e '/^#PasswordAuthentication/a ChallengeResponseAutenthication yes' /etc/ssh/sshd_config
sed -i -e '/#Banner none/ s/#Banner none/Banner \/etc\/ssh/global_banner.txt' /etc/ssh/sshd_config



#set up strong password policy.
cp /etc/login.defs /etc/login.defs$EPOCHSECONDS.bck

sed -i -e '/PASS_MAX_DAYS/ s/99999/30/' /etc/login.defs
sed -i -e '/PASS_MIN_DAYS/ s/0/2/' /etc/login.defs
sed -i -e '/PASS_WARN_AGE/ s/7/7/' /etc/login.defs
cp /etc/pam.d/common-password /etc/pam.d/common-password.$EPOCHSECONDS.bck



:q

# set up firewall rules.
ufw deny 22
ufw allow 4242
