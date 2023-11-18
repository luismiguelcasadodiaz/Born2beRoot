#!/usr/bin/bash
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.$EPOCHSECONDS.bck

sed -i -e '/#Port 22/ s/#Port 22/Port 4242/' /etc/ssh/sshd_config
sed -i -e '/#PermitRootLogin/ s/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i -e '/^PermitRootLogin no/a AllowUsers luicasad' /etc/ssh/sshd_config
sed -i -e '/^#PasswordAuthentication/a ChallengeResponseAutenthication yes' /etc/ssh/sshd_config
sed -i -e '/#Banner none/ s/#Banner none/Banner \/etc\/ssh/global_banner.txt' /etc/ssh/sshd_config

ufw deny 22
ufw allow 4242
