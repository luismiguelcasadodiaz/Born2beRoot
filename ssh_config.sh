#!/usr/bin/bash


sudo apt install -y openssh-server
sed -i -e '/#Port 22/ s/#Port 22/Port 4242/' /etc/ssh/sshd_config
sed -i -e '/#PermitRootLogin/ s/#PermitRootLogin prohibit-password/PermitRootLogin no/' sshd_config
sed -i -e '/^PermitRootLogin no/a AllowUsers luicasad' sshd_config
sudo systemctl status ssh
sudo systemctl start ssh
sudo systemctl enable ssh
