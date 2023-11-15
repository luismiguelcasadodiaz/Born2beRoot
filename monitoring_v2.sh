# /usr/bin/bash
WHITE="\e[97m"
RED="\e[31m"
GREEN="\e[92m"
ENDCOLOR="\e[0m"

# Operating system
KERNEL_RELEASE=`uname --kernel-release`
KERNEL_VERSION=`uname --kernel-version`
OPERATING_SYSTEM=`uname --operating-system`

# Architecture and CPUS
MACHINE_ARCHITECTURE=`uname --machine`
CPUS=`grep "physical id" /proc/cpuinfo |sort | uniq | wc -l `
PHYSICAL_CORES=`grep "cpu cores" /proc/cpuinfo | uniq | sed 's/cpu cores *\t: //'`
VIRTUAL_CORES=`grep "^processor" /proc/cpuinfo |sort | uniq | wc -l `

# Memory usage
TOTAL_RAM=`cat  /proc/meminfo |grep MemTotal | sed 's/MemTotal://' | sed 's/ //g' | sed 's/kB//'`
AVAI_RAM=`cat  /proc/meminfo |grep MemAvailable | sed 's/MemAvailable://' | sed 's/ //g' | sed 's/kB//'`
USED_RAM=`bc <<< "scale=2; (${TOTAL_RAM} - ${AVAI_RAM}) / 1024 / 1024"`
TOTAL_RAM=`bc <<< "scale=2; ${TOTAL_RAM} / 1024 / 1024"`
USED_RAM_PERC=`bc <<< "scale=2; (${USED_RAM} / ${TOTAL_RAM}) * 100"`
printf -v USED_RAM "%4.2f" $USED_RAM 

# CPU usage 
CPU_USAGE_RATE=`cat /proc/stat | grep 'cpu ' | sed 's/cpu  //g' | awk  '{split($0,t," "); for(i=NF;i>0;i--) s = s + $i } END {print 1 - ($4/s) }' | sed 's/\,/\./'`
CPU_USAGE_PERC=`bc <<< "scale=2; 100 * ${CPU_USAGE_RATE}"`
CPU_USAGE_PERC=`echo $CPU_USAGE_PERC | sed 's/\./\,/'`
printf -v CPU_USAGE_PERC "%4.2f" $CPU_USAGE_PERC 
# Disk usage
DISK_TOT=`df -m | grep "/dev/" | awk '{disks_size += $2} END {print disks_size}'`
DISK_USE=`df -m | grep "/dev/" | awk '{disks_size += $3} END {print disks_size}'`
DISK_PER=`bc <<< "scale=2; 100 * $DISK_USE / $DISK_TOT"`

# Boot time
LAST_BOOT=`who -b | sed 's/[a-z ]*//'`

# Logic volumen manager
LVM_IN_USE="NO"
if  [[ $(grep 'mapper' /etc/fstab | wc -l) -gt 0 ]];
then
	LVM_IN_USE="YES"
fi

# Connections
ACTIVE_CONNECTIONS=`ss -Hlt | wc -l`
 
# Users logged
LOGGED_USERS=`who | wc -l`

# Network
IP_ADDRESS=`hostname -I`
MAC_ADDRESS=`ip link | grep ether | awk '{print $2}'`

# sudo commands
SUDO_COMMANDS=`sudo journalctl  /usr/bin/sudo | grep COMMAND | wc -l`


wall  "Arquitecture           :$MACHINE_ARCHITECTURE
Operating system       :$OPERATING_SYSTEM
Kernel Release         :$KERNEL_RELEASE
Kernel version         :$KERNEL_VERSION
Operating system       :$OPERATING_SYSTEM
CPUS                   :$CPUS
Physical cores         :$PHYSICAL_CORES
virtual cores          :$VIRTUAL_CORES
Total memory           :$TOTAL_RAM GB
Used memory            :$USED_RAM GB (${USED_RAM_PERC}%)
Disk usage             :$DISK_USE MB/$DISK_TOT MB($DISK_PER %)
CPU load               :$CPU_USAGE_PERC %
Last boot time         :$LAST_BOOT
LVM in use             :$LVM_IN_USE
TCP active connections :$ACTIVE_CONNECTIONS
Looged users           :$LOGGED_USERS
IP(v4) address         :$IP_ADDRESS ($MAC_ADDRESS)
Sudo commands executed :$SUDO_COMMANDS"

