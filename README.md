# Born2beRoot
## Prepare space for your virtual machine
Remember that the disk space we have in our 42 sessions is limited to 5 GB. It is enough for the mandatory part of this project. You can stop here and do nothing about it or, in case you plan to do the bonus part, you can use a permanent 30 GB disk quota you are entitled to in /sgoinfre/Perso. (see below conditions to use it without sad surprises)

It is permanent while you are using it. In case you don't use it within 60 days, your Personal disk quota will be removed. do not forget to chmod -R 700 to your personal folder. Keep contest belon 30 GB

```bash
mkdir /sgoinfre/Perso/yourusername
```
Then use this path to save the image of your virtual machine (VM).

Please consider that with 5 GB it is enough for this project including bonus. In my case 3.3GB was enough.

<img width="673" alt="image" src="https://github.com/luismiguelcasadodiaz/Born2beRoot/assets/19540140/e4470b72-9111-4b1d-ae21-571481019e6c">


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
Inside my script `instal.sh` there are all commands to install bonus required packages.

1.- a webserver `lighttpd`.
2.- a data base `mariadb`.
3.- a FRONT-END scripting languaje `php` with a bunch of modules.
4.- a content management environment `wordpress`.
5.- a ftp server `vsftpd`.

```bash
apt install -y wget
apt install -y unzip
apt install -y lighttpd
apt install -y php
apt install -y php-curl
apt install -y php-fpm
apt install -y php-bcmath
apt install -y php-gd
apt install -y php-soap
apt install -y php-zip
apt install -y php-mbstring
apt install -y php-mysqlnd
apt install -y php-cgi
apt install -y php-mysql
apt install -y php-xml
apt install -y php-intl
apt install -y mariadb-server
apt install -y mariadb-client
wget https://wordpress.org/latest.zip
apt install -y vsftpd
```

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

Either it is not required by the subject i added this restriction to allow only one user to connect through SSH. That is a challenge at evaluation time when new created user has to log in. Manually you will have to change `AllowUsers luicasad` by `AllowUsers luicasad thenewuserlogin` . DO NOT SEPARATE LOGINS WITH COMMAS BUT WHITESPACES.

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

During projec evaluation, you need to create a newuser. Manually add `nullok` after `pam_google_authenticator.so` to allow the new user connect  via ssh without a 2fa.

```bash
sed -i -e '/common-auth/a auth required pam_google_authenticator.so' /etc/pam.d/sshd
```


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
sed -i -e  '/pam_pwquality.so/ s/retry=3/retry=3 minlen=10/' /etc/pam.d/common-password
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

The crontab files edited with `crontab -u <user> -e` are located inside `/var/spool/cron/crontabs` folder.
A regular-user does not require sudo privileges for scheduling a task.
A regular user does not require to be logged for the task be executed on a regular basis.

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

#### 1.- a webserver `lighttpd`.

#### 2.- a data base `mariadb`.

#### 3.- a FRONT-END scripting languaje `php` with a bunch of modules.

#### 4.- a content management environment `wordpress`.

#### Config ftp server `vsftpd`.
To show this functionality i will allow a `guest` connection to vsftpd server service.

    1.- Create a directory for downloading files `mkdir -p /var/ftp/tothom` . The flag `-p` allows to create the path of intermediate directories if they do not exists.
    
    2.- Assign `nobody:nogroup` permission to download directory `chown nobody:nogroup /var/ftp/tothom`.
    These are special users and groups that are used to provide the most restrictive access permissions possible. The **nobody** user is a system account that does not have any shell access. It is typically used to run system services and daemons that do not require user interaction. The **nogroup** group is a group that does not have any members. It is typically used to group together system files and folders that should not be accessible to any users or groups.The reason for assigning the permissions "nobody:nogroup" to a folder is to make it as secure as possible. This is because the nobody user and the nogroup group have the least amount of privileges on the system. This means that only authorized users with special privileges will be able to access or modify the folder's contents.
    
    3.- Copy some files to the download directory.
    
    4.- Edit `/etc/vsftpd.config` and instruct the service to allow anonymous connection from guest users. Change `anonymous_enable=NO` by `anonymous_enable=YES. Avoid locar users to connect to this service changing `local_enable=YES` by `local_enable=NO`. Inform the server about which is the download directory `anon_root=/var/ftp/tothom`.

####### Conexion with Safari
<img width="669" alt="image" src="https://github.com/luismiguelcasadodiaz/Born2beRoot/assets/19540140/dfc687fc-9a53-437d-a388-97e33cb90ab6">

####### Login as guest/Anonymous

<img width="431" alt="image" src="https://github.com/luismiguelcasadodiaz/Born2beRoot/assets/19540140/d2736599-e11d-4572-9ea7-1d19221ef75e">

####### Finder visualization of `tothom` download directory
<img width="769" alt="image" src="https://github.com/luismiguelcasadodiaz/Born2beRoot/assets/19540140/73485346-bd6b-4f15-8a3b-d63b0f5a6e3b">

---
### What i Learnt from Alex (ade-tole) , Abel(abluis-m) and Martí(mpuig-ma).

##### signature verification

The `-c` flag in `shasum` command to check a signature file like this `362eeadd85368b4f4dcfd7480b574fa37a8b0650  luicasad42.vdi`,  when executed in the file's folder will show
either:

```bash
luicasad42.vdi: OK`
```
 or
 
```bash
luicasad42.vdi: FAILED
shasum: WARNING: 1 computed checksum did NOT match
```

##### partitions and numbers
Why you get `sda3` and the subject shows `sda5`? 

In the subject, there is an extended partion.  

The traditional DOS MBR partition table supports up to four primary partitions and an unlimited number of logical partitions within an extended partition. So sda1 .. sda4 are primary partitions. When you have a number higher than 4 you can infer any of the previous partitions was extended. 

However, the GPT partition table, which is more modern, supports a larger number of partitions. In GPT, the theoretical maximum number of partitions is 128, of which up to 32 can be primary partitions, while the rest must be logical partitions within an extended partition. 

[lsblk output comments](https://unix.stackexchange.com/questions/659652/meaning-of-the-output-from-lsblk-command) 
[parittion table visualization](https://recoverit.wondershare.com/partition-tips/linux-list-partitions.html)

##### Logged users is not the same that runing sessions.
Let's create this scenario: Root is logged in the main console and one user has two ssh conections:

`who` output is

```bash
luicasad@luicasad42:~$ who -H
NOMBRE   LÍNEA       TIEMPO           COMENTARIO
root     tty1         2023-12-14 10:14
luicasad pts/0        2023-12-14 10:17 (192.168.0.99)
luicasad pts/1        2023-12-14 10:18 (192.168.0.99)


```
`users` output is:

```bash
luicasad@luicasad42:~$ users
luicasad luicasad root
```

> [!IMPORTANT]
> The subjec request **The number of users using the server**

If you prefer `users` command, instead of `users | wc -w` is better `users | awk '{for(i=NF;i >0;i--) print $i}' | uniq | wc -l` .

if you prefer `who` commnad,  instead of `who | wc -l` is better `who  | awk '{print $1}' | uniq | wc -l`.

##### sudoreplay
To replay sudo session logs. 

The subject request us  "Each action using sudo has to be **archived, both inputs and outputs**. The log file
has to be saved in the /var/log/sudo/ folder." 

Do you wonder what is this usefull for?

To check if a privileged user has goodwill we can use this command:

```bash
sudoreplay -d /var/log/sudo -l user luicasad
dic 14 12:24:56 2023 : luicasad : HOST=luicasad42 ; TTY=pts/0 ; CWD=/home/luicasad/Born2beRoot ; USER=root ; TSID=000004 ; COMMAND=/usr/bin/cat /var/spool/cron/crontabs/root
dic 14 12:37:17 2023 : luicasad : HOST=luicasad42 ; TTY=pts/1 ; CWD=/home/luicasad ; USER=root ; TSID=000005 ; COMMAND=/usr/bin/mkdir /root/pulling_leg
dic 14 12:37:58 2023 : luicasad : HOST=luicasad42 ; TTY=pts/1 ; CWD=/home/luicasad ; USER=root ; TSID=000006 ; COMMAND=/usr/bin/touch /root/pulling_leg/goodmornign.txt
dic 14 12:39:20 2023 : luicasad : HOST=luicasad42 ; TTY=pts/1 ; CWD=/home/luicasad ; USER=root ; TSID=000007 ; COMMAND=/usr/bin/cp Born2beRoot/install.sh /root/pulling_leg
dic 14 12:39:53 2023 : luicasad : HOST=luicasad42 ; TTY=pts/1 ; CWD=/home/luicasad ; USER=root ; TSID=000008 ; COMMAND=/usr/bin/cat /root/pulling_leg/install.sh
dic 14 13:03:43 2023 : luicasad : HOST=luicasad42 ; TTY=pts/1 ; CWD=/home/luicasad ; USER=root ; TSID=000009 ; COMMAND=/root/Born2beRoot/config.sh
```
To replay command and see what the user saw, at the speed he saw it, we can use this command

```bash
root@luicasad42:~# sudoreplay -d /var/log/sudo 000009
Replaying sudo session: /root/Born2beRoot/config.sh
mkdir: no se puede crear el directorio «/var/log/sudo»: El fichero ya existe
Skipping adding existing rule
Skipping adding existing rule (v6)
Skipping adding existing rule
Skipping adding existing rule (v6)
addgroup: El grupo `user42' ya existe.
adduser: El usuario `luicasad' ya es un miembro de `user42'.
adduser: El usuario `luicasad' ya es un miembro de `sudo'.
sudo:x:27:luicasad
user42:x:1001:luicasad
Replay finished, press any key to restore the terminal.
root@luicasad42:~# 
```


##### Shebang/hashbang and crontab
My crontab line for executing monitoring script was:

```bash
*/10 * * * * sh /root/Born2beRoot/monitoring.sh >/dev/null 2>&1
```

and at the same time `monitoring.sh` file had this shebang `#!/usr/bin/bash
`
My intention was to use **bash** commands to monitor the system, but i was using **sh**ell to execute it.

> [!NOTE]
> Let's look carefully at the details of these commands:

```bash
root@luicasad42:~# which bash
/usr/bin/bash
root@luicasad42:~# which sh
/usr/bin/sh
root@luicasad42:~# which dash
/usr/bin/dash
root@luicasad42:~# cd /usr/bin
root@luicasad42:/usr/bin# ls -hal bash
-rwxr-xr-x 1 root root 1,3M abr 23  2023 bash
root@luicasad42:/usr/bin# ls -hal sh
lrwxrwxrwx 1 root root 4 ene  5  2023 sh -> dash
root@luicasad42:/usr/bin# ls -hal dash
-rwxr-xr-x 1 root root 123K ene  5  2023 dash
root@luicasad42:/usr/bin# 
```
OMG!!! I was instructing cron to execute a script that uses bash commands with dash. I notice that bash is 10 times bigger than dash. 
Now I start to understand, perhaps, the reason why cron was not executing  correctly and i spend 3 days changing my bash commands. 

I gave execution permission to monitoring and changed crontab line to 

```bash
*/10 * * * * /root/Born2beRoot/monitoring.sh >/dev/null 2>&1
```
##### locale warning when ssh connection
Inside /etc/ssh/sshd_config there is a directive ` AcceptEnv LANG LC_*` allowing client's terminals to pass therir local environment variables to the server.
The iterm2 in my Mac had not locale configuration. the ssh server warned me about it.

##### chage, changes user password expiry information.

During debian installation o created two users: root and luicasad.

After hardening password policy i changed both users passwords with `password`to fullfill new rules settled inside /etc/pam.d/common-password.

Then created a newuser with  `adduser`. Checking it with `chage`, i got:
```bash
luicasad@luicasad42:~$ sudo chage -l newuser
Último cambio de contraseña					:dic 14, 2023
La contraseña caduca					: ene 13, 2024
Contraseña inactiva					: nunca
La cuenta caduca						: nunca
Número de días mínimo entre cambio de contraseña		: 2
Número de días máximo entre cambio de contraseña		: 30
Número de días de aviso antes de que caduque la contraseña	: 7
luicasad@luicasad42:~$ 
```
I thought every thing was ok, **but it was not**. Again abluis-m openned my eyes.


I went to my evaluation with these conditions for users created at debian installation:

```bash
luicasad@luicasad42:~$ sudo chage -l luicasad
Último cambio de contraseña					:nov 10, 2023
La contraseña caduca					: nunca
Contraseña inactiva					: nunca
La cuenta caduca						: nunca
Número de días mínimo entre cambio de contraseña		: 0
Número de días máximo entre cambio de contraseña		: 99999
Número de días de aviso antes de que caduque la contraseña	: 7
luicasad@luicasad42:~$ 
```

Facing incorreclty a subject that requested us

1.-Your password has to expire every 30 days.

2.-The minimum number of days allowed before the modification of a password will be set to 2.

3.-The user has to receive a warning message 7 days before their password expires.


> [!NOTE]
> I learnt that : The `password` command do not takes information from `/etc/login.defs` as it does `adduser`

> [!IMPORTANT]
> The command `chage -m 2 -M 30 luicasad` solved my problem

```bash
luicasad@luicasad42:~$ sudo chage -l luicasad
Último cambio de contraseña					:dic 14, 2023
La contraseña caduca					: ene 13, 2024
Contraseña inactiva					: nunca
La cuenta caduca						: nunca
Número de días mínimo entre cambio de contraseña		: 2
Número de días máximo entre cambio de contraseña		: 30
Número de días de aviso antes de que caduque la contraseña	: 7
luicasad@luicasad42:~$
```



---
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

[message of the day](https://www.networkworld.com/article/964193/how-to-use-the-motd-file-to-get-linux-users-to-pay-attention.html)

[password hardning](https://www.zonasystem.com/2020/04/gestion-de-las-politicas-de-contrasenas-en-linux-logindefs-pam-pwquality-cracklib.html)

[ssh connectiviy issues](https://docs.digitalocean.com/support/how-to-troubleshoot-ssh-connectivity-issues/)

[vsftpd](https://hostadvice.com/how-to/web-hosting/ubuntu/how-to-install-and-configure-vsftpd-on-ubuntu-18-04/)

[vsftpd](https://www.digitalocean.com/community/tutorials/how-to-set-up-vsftpd-for-anonymous-downloads-on-ubuntu-16-04)

[apt vs aptitude](https://www.tecmint.com/difference-between-apt-and-aptitude/)

[Rocky vs Debian](https://amadla.medium.com/debian-linux-vs-rocky-os-exploring-the-best-choice-for-your-server-dfd6b3d80c1a)

#### to refresh my memory

##### apt
Install a specific package
i awk '{}'
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
remove
Create groups user42
adduser luicasad sudo    //logout and login

https://www.linuxtuto.com/how-to-install-wordpress-on-debian-12/



<img width="767" alt="image" src="https://github.com/luismiguelcasadodiaz/Born2beRoot/assets/19540140/d8f71edb-88bc-4600-af19-aa6f97bc3f84">
