#!/usr/bin/bash

# Back up of ssh server original configuration file.

cp /etc/ssh/sshd_config /etc/ssh/sshd_config.$EPOCHSECONDS.bck

sed -i -e '/#Port 22/ s/#Port 22/Port 4242/' /etc/ssh/sshd_config
sed -i -e '/#PermitRootLogin/ s/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i -e '/^PermitRootLogin no/a AllowUsers luicasad' /etc/ssh/sshd_config
sed -i -e '/^#PasswordAuthentication/a ChallengeResponseAutenthication yes' /etc/ssh/sshd_config
sed -i -e '/#Banner none/ s/#Banner none/Banner \/etc\/ssh\/global_banner.txt/' /etc/ssh/sshd_config

#set up a sudo group strong configuration
mkdir /var/log/sudo
touch /var/log/sudo/logfile

echo "Defaults passwd_tries=3" >  /etc/sudoers.d/configuration
echo "Defaults badpass_message='INCORRECT Password for sudo mode'" >> /etc/sudoers.d/configuration
echo "Defaults iolog_dir=/var/log/sudo" >> /etc/sudoers.d/configuration
echo "Defaults logfile=/var/log/sudo/logfile" >> /etc/sudoers.d/configuration
echo "Defaults log_input, log_output" >> /etc/sudoers.d/configuration


#set up strong password policy.

cp /etc/login.defs /etc/login.defs$EPOCHSECONDS.bck

sed -i -e '/PASS_MAX_DAYS/ s/99999/30/' /etc/login.defs
sed -i -e '/PASS_MIN_DAYS/ s/0/2/' /etc/login.defs
sed -i -e '/PASS_WARN_AGE/ s/7/7/' /etc/login.defs
cp /etc/pam.d/common-password /etc/pam.d/common-password.$EPOCHSECONDS.bck
sed -i -e '/pam_pwquality.so/ s/retry=3/retry=3 enforce_for_root/' /etc/pam.d/common-password
sed -i -e '/pam_pwquality.so/ s/retry=3/retry=3 difok=7 /' /etc/pam.d/common-password
sed -i -e '/pam_pwquality.so/ s/retry=3/retry=3 reject_username /' /etc/pam.d/common-password
sed -i -e '/pam_pwquality.so/ s/retry=3/retry=3 maxrepeat=3 /' /etc/pam.d/common-password
sed -i -e '/pam_pwquality.so/ s/retry=3/retry=3 dcredit=-1 /' /etc/pam.d/common-password
sed -i -e '/pam_pwquality.so/ s/retry=3/retry=3 lcredit=-1 /' /etc/pam.d/common-password
sed -i -e '/pam_pwquality.so/ s/retry=3/retry=3 ucredit=-1 /' /etc/pam.d/common-password


# set up firewall rules.
ufw deny 22
ufw allow 4242
