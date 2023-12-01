# Born2beRoot
## Prepare space for your virtual machine
Remember that the disk space we have in our 42 sessions is limited to 5 GB. It is enough for the mandatory part of this project. You can stop here and do nothing about it or, in case you plan to do the bonus part, you can use a permanent 30 GB disk quota you are entitled to in /sgoinfre/Perso. (see below conditions to use it without sad surprises)

It is permanent while you are using it. In case you don't use it within 60 days, your Personal disk quota will be removed. do not forget to chmod -R 700 to your personal folder. Keep contest belon 30 GB

```bash
mkdir /sgoinfre/Perso/yourusername
```
Then use this path to save the image of your virtual machine (VM).

## Virtual box network configuration 

An important decision for this project is about virtual machine connectivity. Virtualbox offers several options.
I selected Bridget cause I want to access Born2beRoot from other computers in my network 
[In this instructions] (https://www.virtualbox.org/manual/ch06.html) you find a summary table with in/out connectivity possibilities offered by each option

|Mode      | VM-->Host | VM<--Host  |VM1<-->VM2|VM-->Net/LAN|VM<--Net/LAN|
|:---------|:---------:|:----------:|:--------:|:----------:|:----------:|
|Host-only |+          |+           |+         |–           |–           |
|Internal  |–          |–           |+         |–           |–           |
|Bridged   |+          |+           |+         |+           |+           |
|NAT       |+          |Port forward|–         |+           |Port forward|
|NATservice|+          |Port forward|+         |+           |Port forward|

Bridge connection

![image](https://github.com/luismiguelcasadodiaz/Born2beRoot/assets/19540140/719c2a59-267d-40d9-af8d-a1bc2ace4f1d)

In the middle of this project we got a message from our staff informing about VirtualBox general removal in our campus dueto technical  problems.
I tried to configure a UEFI machine but i desisted. i got problems installing grub loader when encrypted de logical volumen. I changed my mind in order to be ready for my deadline.


### Partition time
WAIT!!!! Mandatory or bonus??? watch the subject to see the partition scheme. Worth parting VM's hard disk as the bonus request to avoid configuring a new machine for the bonus later.

<img width="819" alt="image" src="https://github.com/luismiguelcasadodiaz/Born2beRoot/assets/19540140/679210af-50b8-4d28-9f84-fa176d85550b">

During the partition, if manual .... first create 3 primary partitions, then encrypt one (it will take time to overwrite it with random data, later use LVM.


## Minimal installation

[debian-12.2.0-amd64-netinst.iso of size 658 MB](https://www.debian.org/CD/netinst/) was my election. 
One time-consuming task in this project is the VM setup. The bigger the iso image, the longer to set up.
It is true that I got an almost bare metal that forced me to install the required packages for this project individually one by one. 
25 seconds to download 628 MB. I moved the image to my /sgoinfre/Perso/ directory

At installation time I opted to install nothing


<img width="782" alt="image" src="https://github.com/luismiguelcasadodiaz/Born2beRoot/assets/19540140/294d6cb0-708d-43fb-81f8-8ecc15459e55">

## Mandatory project installation

### sudo

```bash
apt install sudo
```

### ssh-server
```bash
apt install openssh-server
```

### firewall
```bash
apt install ufw
```
### to improve password rules
```bash
apt install libpam-pwquality
```

### basic calculator (i need to for the script)
```bash
apt install bc
```

## bonus installation

### wget nzip nginx 

### php php-curl php-fpm php-bcmath php-gd php-soap php-zip php-mbstring php-mysqlnd php-xml php-intl

### mariadb-server mariadb-client

### wordpress wget https://wordpress.org/latest.zip

### ftp server

<img width="595" alt="image" src="https://github.com/luismiguelcasadodiaz/Born2beRoot/assets/19540140/f3f5a8a2-f758-4e4f-8885-7177b4a6d118">

<img width="595" alt="image" src="https://github.com/luismiguelcasadodiaz/Born2beRoot/assets/19540140/7a6d1dac-0a56-406e-9a45-97e5bc17c876">


## Additional Installation

### git installation

I decided to keep the script to configure the server as requested in de project in a git repository.

```bash
apt-get install git
```



## Configuration

---

##### firewall

You have to configure your operating system with the UFW (or Firewalla for Rocky) firewall and thus leave only port 4242 open. 
I also set up a restriction to avoid connections on port 22.

```bash
ufw deny 22
ufw allow 4242
```

---

##### ssh
I only have to change some lines in `/etc/ssh/sshd_config` file. This file configures the server that answers incoming ssh connections to my virtual machine.

There is an additional `/etc/ssh/ssh_config` file that relates to outgoing connections from my virtual machine to another server. I do not touch this client side of the OpenSSH package.

An SSH service will be running on port 4242 only.

```bash
sed -i -e '/#Port 22/ s/#Port 22/Port 4242/' /etc/ssh/sshd_config
```

For security reasons, it must not be possible to connect using SSH as root.

```bash
sed -i -e '/#PermitRootLogin/ s/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
```

Either it is not required by the subject i added this restriction to allow only one user to connect through SSH

```bash
sed -i -e '/^PermitRootLogin no/a AllowUsers luicasad' /etc/ssh/sshd_config
```

I set a banner to welcome an ssh connection

```bash
sed -i -e '/#Banner none/ s/#Banner none/Banner \/etc\/ssh\/global_banner.txt' /etc/ssh/sshd_config
```

Gathering all ssh settings results this:

```bash
sed -i -e '/#Port 22/ s/#Port 22/Port 4242/' /etc/ssh/sshd_config
sed -i -e '/#PermitRootLogin/ s/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i -e '/^PermitRootLogin no/a AllowUsers luicasad' /etc/ssh/sshd_config
sed -i -e '/#Banner none/ s/#Banner none/Banner \/etc\/ssh\/global_banner.txt/' /etc/ssh/sshd_config
cp /root/Born2beRoot/global_banner.txt /etc/ssh
```

---

##### ssh 2FA
Another improvement I wanted to try was to implement a 2FA. 

I installed a Google authenticator library. 

```bash
apt install -y libpam-google-authenticator
```
Locally it will generate  a time-based token. The token is generated using a local key for the local user plus a UTC timestamp.

I have to pass the local key to my smartphone Google Authenticator app. I do that with an SSH connection from my host machine to the virtual machine. I do that cause the screen of the virtual machine running in Virtualbox does not draw a readable QR for my smartphone. I did not manage to do it, so I logged through SSH for configuration purposes. The command to generate QR for the local key to transfer to your smartphone is:

```bash
google-authenticator
````

Once the Google Authenticator app in my Smartphone reads my local key QR, starts to generate time-based tokens. 


Add these lines to `\etc\ssh\sshd_config` and ssh will ask for tokens after a correct password.

```bash
sed -i -e '/^#PasswordAuthentication/ a ChallengeResponseAuthentication yes' /etc/ssh/sshd_config
```

`sed -i -e '/#UsePAM/ s/#UsePAM yes/UsePAM yes/' /etc/ssh/sshd_config` is requested in case that openssh-server default configuration did not use PAM as authentication method.

Add this line to `/etc/pam.d/sshd`

```bash
sed -i -e '/common-auth/a auth required pam_google_authenticator.so' /etc/pam.d/sshd
```


Create groups user42
adduser luicasad sudo    //logout and login

---

##### passwords policy

Your password has to expire every 30 days. We change `PASS_MAX_DAYS` form `99999` to `30`.

```bash
sed -i -e '/PASS_MAX_DAYS/ s/99999/30/' /etc/login.defs
```

The minimum number of days allowed before the modification of a password will be set to 2. We change `PASS_MIN_DAYS` form `0` to `2`.

```bash
sed -i -e '/PASS_MIN_DAYS/ s/0/2/' /etc/login.defs
```

The user has to receive a warning message 7 days before their password expires. This is the default value defined by  `PASS_WARN_AGE`

In former days, inside `/etc/login.def` password length's settings min and max were configurable. When pluggable authentication modules (PAM) started to be used in the late 1990s those parameters became obsolete. So it is inside `etc/pam.d/common-password` 

Your password must be at least 10 characters long.
```bash
sed -i -e  '/pam_pwquality.so/ s/retry=3/retry=3 minlen=10/' /etc/pam.d/common-password
```

It must contain an uppercase letter.

```bash
sed -i -e  '/pam_pwquality.so/ s/retry=3/retry=3 ucredit=-1 /' /etc/pam.d/common-password
```

It must contain  a lowercase letter.

```bash
sed -i -e  '/pam_pwquality.so/ s/retry=3/retry=3 lcredit=-1 /' /etc/pam.d/common-password
```

It must contain a number.

```bash
sed -i -e  '/pam_pwquality.so/ s/retry=3/retry=3 dcredit=-1 /' /etc/pam.d/common-password
```

It must not contain more than 3 consecutive identical characters.

```bash
sed -i -e  '/pam_pwquality.so/ s/retry=3/retry=3 maxrepeat=3 /' /etc/pam.d/common-password
```

The password must not include the name of the user.

```bash
sed -i -e  '/pam_pwquality.so/ s/retry=3/retry=3 reject_username /' /etc/pam.d/common-password
```

The password must have at least 7 characters that are not part of the former password.

```bash
sed -i -e  '/pam_pwquality.so/ s/retry=3/retry=3 difok=7 /' /etc/pam.d/common-password
```

The root password has to comply with this policy.

```bash
sed -i -e  '/pam_pwquality.so/ s/retry=3/retry=3 enforce_for_rootedr /' /etc/pam.d/common-password
```

Gathering all password restrictions settings results in this:

```bash
sed -i -e '/PASS_MAX_DAYS/ s/99999/30/' /etc/login.defs
sed -i -e '/PASS_MIN_DAYS/ s/0/2/' /etc/login.defs
sed -i -e '/PASS_WARN_AGE/ s/7/7/' /etc/login.defs
sed -i -e '/pam_pwquality.so/ s/retry=3/retry=3 enforce_for_root/' /etc/pam.d/common-password
sed -i -e '/pam_pwquality.so/ s/retry=3/retry=3 difok=7 /' /etc/pam.d/common-password
sed -i -e '/pam_pwquality.so/ s/retry=3/retry=3 reject_username /' /etc/pam.d/common-password
sed -i -e '/pam_pwquality.so/ s/retry=3/retry=3 maxrepeat=3 /' /etc/pam.d/common-password
sed -i -e '/pam_pwquality.so/ s/retry=3/retry=3 dcredit=-1 /' /etc/pam.d/common-password
sed -i -e '/pam_pwquality.so/ s/retry=3/retry=3 lcredit=-1 /' /etc/pam.d/common-password
sed -i -e '/pam_pwquality.so/ s/retry=3/retry=3 ucredit=-1 /' /etc/pam.d/common-password
```

--- 

##### sudo group policy
According to what we read when we execute `visudo` command, we have to create a `configuration` file,  inside `/etc/sudoers.d` folder, where we will insert a set of directives.

To know which editor is configured as `visudo` you can execute 
```bash
sudo update-alternatives --config editor
```

Authentication using sudo has to be limited to 3 attempts in the event of an incorrect password.

```bash
echo "Defaults  passwd_tries=3" >  /etc/sudoers.d/configuration
```

A custom message of your choice has to be displayed if an error due to a wrong password occurs when using sudo. Be aware of the inverte usage of `'` and `"` in this command. This is due to the fact of sudo requires the error message to be between quotes.

```bash
echo 'Defaults  badpass_message="Password for luicasad42 virtual machine sudo mode INCORRECT"' >> /etc/sudoers.d/configuration
```

Each action using sudo has to be archived, both inputs and outputs. By default, all sudo incidents will be logged in /var/log/auth.log. However, it is not dedicated to sudo logs. 

I create a `logfile` for logging either input and output messages to/from sudo. I create the file in folder `/var/log/sudo`.

```bash
mkdir /var/log/sudo
touch /var/log/sudo/logfile
echo "Defaults iolog_dir=/var/log/sudo" >> /etc/sudoers.d/configuration
echo "Defaults logfile=/var/log/sudo/logfile" >> /etc/sudoers.d/configuration
echo "Defaults log_input, log_output" >> /etc/sudoers.d/configuration
```

A security setting is to force to have a tty connection to the machine to be entitled to use sudo command. This will avoid that a simple cron script upscales privileges.

```bash
echo "Defaults requiretty" >> /etc/sudoers.d/configuration
```

The TTY mode has to be enabled for security reasons. With this only user logged in a terminal can use sudo privileges. A cron job would not be entitled to gain privileges when requiretty is present.

```bash
echo "Defaults requiretty" >> /etc/sudoers.d/configuration
```

Another security setting is to restrict the path to commands that a sudoer can use.

```bash
echo "Defaults secure_path='/usr/sbin:/usr/bin:/sbin:/bin'" >> /etc/sudoers.d/configuration
```

Gathering all sudo configuration instruction results in this:

```bash
mkdir /var/log/sudo
touch /var/log/sudo/logfile
echo "Defaults passwd_tries=3" >  /etc/sudoers.d/configuration
echo "Defaults badpass_message='INCORRECT Password for sudo mode'" >> /etc/sudoers.d/configuration
echo "Defaults iolog_dir=/var/log/sudo" >> /etc/sudoers.d/configuration
echo "Defaults logfile=/var/log/sudo/logfile" >> /etc/sudoers.d/configuration
echo "Defaults log_input, log_output" >> /etc/sudoers.d/configuration
echo "Defaults requiretty" >> /etc/sudoers.d/configuration
echo "Defaults secure_path='/usr/sbin:/usr/bin:/sbin:/bin'" >> /etc/sudoers.d/configuration
```

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

---

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

I used this [reference] (https://www.kernel.org/doc/Documentation/filesystems/proc.txt) to learn about.
All  of  the numbers reported  in  this file are  aggregates since the system first booted.

|    |Usr|nice|sys|idl   |iow |irq|softirq|steal|guest|guest_nice|
|----|---|----|---|------|----|---|-------|-----|-----|----------|
|cpu |882|1   |817|483007|3082|0  |396    |0    |0    |0         |
|cpu0|238|0   |195|120874|754 |0  |60     |0    |0    |0         |
|cpu1|206|1   |130|120920|368 |0  |297    |0    |0    |0         |
|cpu2|210|0   |226|120325|1309|0  |25     |0    |0    |0         |
|cpu3|226|0   |265|120887|650 |0  |13     |0    |0    |0         |

The sum of all numerical values in a row gives total time since boot. Utilization rate is the complementary of twiddling thumbs rate.

```bash
CPU_USAGE_RATE=`cat /proc/stat | grep 'cpu ' | sed 's/cpu  //g' | awk  '{split($0,t," "); for(i=NF;i>0;i--) s = s + $i; print $i } END {print 1 - ($4/s) }'
```



• The date and time of the last reboot.

`-b` option in `who` command show last boot timestamp.

```bash
LAST_BOOT=`who -b | sed 's/[a-z ]*//'`
```


• Whether LVM is active or not.

Inside `/etc/fstab` the path of logic volumes managed by the device mapper start by `/dev/mapper. I count the number of lines in fstab containing the word `mapper`. If count is greater than zero then i set the flag to YES.

```bash
LVM_IN_USE="NO"
if  [[ $(grep 'mapper' /etc/fstab | wc -l) -gt 0 ]];
then
    LVM_IN_USE="YES"
fi
```


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

---

### Bonus configuration


## Sgoinfre usage conditions

Copy pasted from our intranet

- If you want to use sgoinfre, you must create a directory in `/sgoinfre/Perso/your42login` .If the name of a folder is different from a login, it will be deleted.

- A quota of 30GB/dir. If more, it will be deleted.

- You can give the rights you want to your dir, but we strongly recommend a chmod -R 700

- This share is not intended to have a high level of availability, durability, or performance. It is there to help you out, and we recommend that you use another storage media for your important data.

- The data on this share may be deleted without any notice.

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

##### dpkg

`dpkg -l` list all installed packages and its status

|Syntax|Description|Example|
|------|------------|--------|
|dpkg -i {.deb package}|Install the package|dpkg -i zip_2.31-3_i386.deb|
|dpkg -i {.deb package}|Upgrade package if it is installed else install a fresh copy of package|dpkg -i zip_2.31-3_i386.deb|
|dpkg -R {Directory-name}|Install all packages recursively from directory|dpkg -R /tmp/downloads|
|dpkg -r {package}|Remove/Delete an installed package except configuration files|dpkg -r zip|
|dpkg -P {package}|Remove/Delete everything including configuration files|dpkg -P apache-perl|
|dpkg -l|List all installed packages, along with package version and short description|dpkg -l<br>dokg -l\|less<br>dpkg -l '*apache*'<br>dpkg -l \| grep -i 'sudo'|
|dpkg -l {package}|List individual installed packages, along with package version and short description|dpkg -l apache-perl|
|dpkg -L {package}|Find out files are provided by the installed package i.e. list where files were installed|dpkg -L apache-perl<br>dpkg -L perl|
|dpkg -c {.Deb package}|List files provided (or owned) by the package i.e. List all files inside debian .deb package file, very useful to find where files would be installed|dpkg -c dc_1.06-19_i386.deb|
|dpkg -S {/path/to/file}|Find what package owns the file i.e. find out what package does file belong|dpkg -S /bin/netstat<br>dpkg -S /sbin/ippool|
|dpkg -p {package}|Display details about package package group, version, maintainer, Architecture, display depends packages, description etc|dpkg -p lsof|
|dpkg -s {package}\| grep Status|Find out if Debian package is installed or not (status)|dpkg -s lsof \| grep Status|

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


https://www.linuxtuto.com/how-to-install-wordpress-on-debian-12/



<img width="767" alt="image" src="https://github.com/luismiguelcasadodiaz/Born2beRoot/assets/19540140/d8f71edb-88bc-4600-af19-aa6f97bc3f84">
