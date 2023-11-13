# Born2beRoot
## Prepare space for your virtual machine
Remember that disk space we have in our 42 sessions is limited to 5 GB. It is enough for the mandatory part of this proyect. You can stop here and do nothing about it or, in case you plan to do the bonus part, you can use a permanent 30 GB disk quota you are entitled to in /sgoinfre/Perso.

It is permanent while you are using it. In case you don use it during 60 day, your Personal disk quota will be removed.

```bash
mkdir /sgoinfre/Perso/yourusername
```
Then use this path to save the image of your virtual machine (VM).

## Virtual box network configuration 

An important decision for this proyect is about virtual machine conectivity. Virtualbox offers several option.
I selected bridget cause i want to access Born2beRoot from other computers in my network 
[In this instructions] (https://www.virtualbox.org/manual/ch06.html) you find a summary table wiht in/out connectivity posibilities offered by each option

|Mode      | VM-->Host | VM<--Host  |VM1<-->VM2|VM-->Net/LAN|VM<--Net/LAN|
|:---------|:---------:|:----------:|:--------:|:----------:|:----------:|
|Host-only |+          |+           |+         |–           |–           |
|Internal  |–          |–           |+         |–           |–           |
|Bridged   |+          |+           |+         |+           |+           |
|NAT       |+          |Port forward|–         |+           |Port forward|
|NATservice|+          |Port forward|+         |+           |Port forward|

Bridge connection

![image](https://github.com/luismiguelcasadodiaz/Born2beRoot/assets/19540140/719c2a59-267d-40d9-af8d-a1bc2ace4f1d)



## Minimal installation

[debian-12.2.0-amd64-netinst.iso of size 658 MB](https://www.debian.org/CD/netinst/) was my election. 
One time consuming task in this proyect is the VM setup. The bigger the iso image, the longer to setup.
It is true that i get an almost bare metal tha forces me to install one by one required utilities for this project. 
25 seconds to download 628 MB. I moved the image to my /sgoinfre/Perso/ directory

At installation time i opted for install nothing


<img width="782" alt="image" src="https://github.com/luismiguelcasadodiaz/Born2beRoot/assets/19540140/294d6cb0-708d-43fb-81f8-8ecc15459e55">

### Partition time
WAIT!!!! Mandatory or bonus??? watch the subjec to see partition scheme. Worth to part VM's harddisk as bonus request to avoid configure a new machine for the bonus later.

<img width="819" alt="image" src="https://github.com/luismiguelcasadodiaz/Born2beRoot/assets/19540140/679210af-50b8-4d28-9f84-fa176d85550b">


## Additional Instalation
### git installation

I decide to keep in a git repository the script to configure de server as requested in de proyect

```bash
apt install sudo
adduser luicasad sudo    //logout and login
```


`apt-get install git`

### ssh-server
```bash
sudo apt update
sudo apt install openssh-server
```

### firewall
```bash
apt install ufw
```

### basic calculator
```bash
apt install bc
```


## Configuration

##### firewall

You have to configure your operating system with the UFW (or firewalld for Rocky) firewall and thus leave only port 4242 open.

```bash
ufw allow 4242
```



##### ssh

A SSH service will be running on port 4242 only. 
```bash
sed -i -e '/#Port 22/ s/#Port 22/Port 4242/' /etc/ssh/sshd_config
```

For security reasons, it must not be possible to connect using SSH as root.

```bash
sed -i -e '/#PermitRootLogin/ s/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
```

Either it is nor required by the subjec i added this restricction to allow only one user to connect thru ssh

```bash
sed -i -e '/^PermitRootLogin no/a AllowUsers luicasad' /etc/ssh/sshd_config
```

Another improvement i wanted to try was implement a 2FA. Add this line.

```bash
sed -i -e '/^#PasswordAuthentication/ a ChallengeResponseAuthentication yes' /etc/ssh/sshd_config
```

Create groups user42
##### passwords policy

Your password has to expire every 30 days.

• The minimum number of days allowed before the modification of a password will be set to 2.
• The user has to receive a warning message 7 days before their password expires.
• Your password must be at least 10 characters long. 
It must contain an uppercase letter.
it must contain  a lowercase letter.
it must contain a number.
it must not contain more than 3 consecutive identical characters.
The password must not include the name of the user.

• The following rule does not apply to the root password: The password must have at least 7 characters that are not part of the former password.
• Of course, your root password has to comply with this policy.

##### sudo group policy
Authentication using sudo has to be limited to 3 attempts in the event of an incorrect password.

A custom message of your choice has to be displayed if an error due to a wrong password occurs when using sudo.

• Each action using sudo has to be archived, both inputs and outputs. The log file has to be saved in the /var/log/sudo/ folder.

• The TTY mode has to be enabled for security reasons.

• For security reasons too, the paths that can be used by sudo must be restricted. Example: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin


##### Cron


#### Execution

```bash
sudo systemctl status ssh
sudo systemctl start ssh
sudo systemctl enable ssh
```



sudo apt install ufw
sudo ufw enable
sudo ufw limit ssh

`ip addr show`

#### Monitoring Script

Your script must always be able to display the following information

• The architecture of your operating system and its kernel version.

```bash
KERNEL_RELEASE=`uname --kernel-release`
KERNEL_VERSION=`uname --kernel-version`
OPERATING_SYSTEM=`uname --operating-system`
MACHINE_ARCHITECTURE=`uname --machine`
```
• The number of physical and virtual processors.

```bash
CPUS=`grep "physical id" /proc/cpuinfo |sort | uniq | wc -l `
PHYSICAL_CORES=`grep "cpu cores" /proc/cpuinfo | uniq | sed 's/cpu cores *\t: //'`
VIRTUAL_CORES=`grep "^processor" /proc/cpuinfo |sort | uniq | wc -l `
```

• The current available RAM on your server and its utilization rate as a percentage. 

```bash

TOTAL_RAM=`cat  /proc/meminfo |grep MemTotal | sed 's/MemTotal://' | sed 's/ //g' | sed 's/kB//'`
AVAI_RAM=`cat  /proc/meminfo |grep MemAvailable | sed 's/MemAvailable://' | sed 's/ //g' | sed 's/kB//'`
USED_RAM=`bc <<< "scale=2; (${TOTAL_RAM} - ${AVAI_RAM}) / 1024 / 1024"`
TOTAL_RAM=`bc <<< "scale=2; ${TOTAL_RAM} / 1024 / 1024"`
USED_RAM_PERC=`bc <<< "scale=2; (${USED_RAM} / ${TOTAL_RAM}) * 100"`
```

• The current available memory on your server and its utilization rate as a percentage. 

MEM_TOTAL= `cat /


• The current utilization rate of your processors as a percentage.

• The date and time of the last reboot.

• Whether LVM is active or not.

• The number of active connections.

I use `ss command`. Socket statisitics command.  Option H shows no header. Option t shows tcp sockets. Option a show all sockets , listening or no.

```bash
ACTIVE_CONNECTIONS=`ss -Hta | grep ESTAB | wc -l`
```

• The number of users using the server.

`who` does not print headers.

```bash
LOGGED_USERS=`who | wc -l`
```

• The IPv4 address of your server and its MAC (Media Access Control) address. 

`-I` does not depend on name resolution. Display all network addresseses configures on all network interfaces.


```bash
IP_ADDRESS=`hostname -I`
```

• The number of commands executed with the sudo program.

```bash
SUDO_COMMANDS=`sudo journalctl  /usr/bin/sudo | grep COMMAND | wc -l`
```



## References
[cpu info](https://www.networkworld.com/article/2715970/counting-processors-on-your-linux-box.html)

[memory usage](https://www.cyberciti.biz/faq/linux-check-memory-usage/)

#### to refresh my memory

##### apt
Install a specific package

```bash
apt install [package-name] 
```

Remove a specific package

```bash
apt remove [package-name] 
```

Remove all the data, application and configuration files,

```bash
apt remove --purge [package-name] 
```

Remove orphaned dependencies from system
```bash
apt autoremove
```

##### ufw
Delete rule
```bash
ufw status numbered
ufw delete [number] 
```

Add negative rule
```bash
ufw deny 22
```

Add positive rule
```bash
ufw allow 4242
```
