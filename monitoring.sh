#!/usr/bin/bash

# Operating system
KERNEL_RELEASE=`uname --kernel-release`
KERNEL_VERSION=`uname --kernel-version`
OPERATING_SYSTEM=`uname --operating-system`

# Architecture and CPUS
MACHINE_ARCHITECTURE=`uname --machine`
CPUS=`grep "physical id" /proc/cpuinfo | sort | uniq | wc -l `
PHYSICAL_CORES=`grep "cpu cores" /proc/cpuinfo | uniq | sed 's/cpu cores *\t: //'`
VIRTUAL_CORES=`grep "^processor" /proc/cpuinfo | sort | uniq | wc -l `

# Memory usage
TOTALRAM=$(free -m | awk '$1 == "Mem:" {print $2}')
USED_RAM=$(free -m | awk '$1 == "Mem:" {print $3}')
USED_RAM_PERC=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')

#CPU USAGE
CPU_USAGE_RATE=$(cat /proc/stat | grep 'cpu ' | sed 's/cpu  //g' | awk  '{split($0,t," "); for(i=NF;i>0;i--) s = s + $i } END {printf ("%.2f"),(1 - ($4/s)) }')

# Disk usage
DISK_TOT=`df -m | grep "/dev/" | awk '{disks_size += $2} END {printf ("%.2fGB"), disks_size/1024}'`
DISK_USE=`df -m | grep "/dev/" | awk '{disks_size += $3} END {printf ("%.2fGB"), disks_size/1024}'`
DISK_PER=`df -m | grep "/dev/" | awk '{disks_t += $2} {disks_u += $3} END {printf ("%.2f"), 100*disks_u/disks_t}'`



# Boot time
LAST_BOOT=`who -b | sed 's/[a-z ]*//'`

# Logic volumen manager
LVM_IN_USE=$(if [ $(lsblk | grep 'lvm' | wc -l) -gt 0 ]; then echo YES; else echo NO; fi)


# Connections
ACTIVE_CONNECTIONS=`ss -Hlt | wc -l`
 
# Users logged
LOGGED_USERS=`who | wc -l`

# Network
IP_ADDRESS=`hostname -I`
MAC_ADDRESS=`ip link | grep ether | awk '{print $2}'`

# sudo commands
SUDO_COMMANDS=`journalctl  /usr/bin/sudo | grep COMMAND | wc -l`


wall "Aprendiendo cron
Arquitecture           :$MACHINE_ARCHITECTURE
Operating system       :$OPERATING_SYSTEM
Kernel Release         :$KERNEL_RELEASE
Kernel version         :$KERNEL_VERSION
Operating system       :$OPERATING_SYSTEM
CPUS                   :$CPUS
Physical cores         :$PHYSICAL_CORES
virtual cores          :$VIRTUAL_CORES
Total memory           :$TOTALRAM MB
Used memory            :$USED_RAM MB  ($USED_RAM_PERC %)
Disk usage             :$DISK_USE /$DISK_TOT ($DISK_PER %)
CPU load               :$CPU_USAGE_RATE %
Last boot time         :$LAST_BOOT
LVM in use             :$LVM_IN_USE
TCP active connections :$ACTIVE_CONNECTIONS
Looged users           :$LOGGED_USERS
IP(v4) address         :$IP_ADDRESS ($MAC_ADDRESS)
Sudo commands executed :$SUDO_COMMANDS comandos."
"

