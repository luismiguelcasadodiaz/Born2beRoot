#!/usr/bin/bash
WHITE="\e[97m"
RED="\e[31m"
GREEN="\e[92m"
ENDCOLOR="\e[0m"

KERNEL_RELEASE=`uname --kernel-release`
KERNEL_VERSION=`uname --kernel-version`
OPERATING_SYSTEM=`uname --operating-system`
MACHINE_ARCHITECTURE=`uname --machine`
CPUS=`grep "physical id" /proc/cpuinfo |sort | uniq | wc -l `
PHYSICAL_CORES=`grep "cpu cores" /proc/cpuinfo | uniq | sed 's/cpu cores *\t: //'`
VIRTUAL_CORES=`grep "^processor" /proc/cpuinfo |sort | uniq | wc -l `
TOTAL_RAM=`cat  /proc/meminfo |grep MemTotal | sed 's/MemTotal://' | sed 's/ //g' | sed 's/kB//'`
AVAI_RAM=`cat  /proc/meminfo |grep MemAvailable | sed 's/MemAvailable://' | sed 's/ //g' | sed 's/kB//'`
USED_RAM=`bc <<< "scale=2; (${TOTAL_RAM} - ${AVAI_RAM}) / 1024 / 1024"`
TOTAL_RAM=`bc <<< "scale=2; ${TOTAL_RAM} / 1024 / 1024"`
USED_RAM_PERC=`bc <<< "scale=2; (${USED_RAM} / ${TOTAL_RAM}) * 100"`
CPU_USAGE_RATE=`cat /proc/stat | grep 'cpu ' | sed 's/cpu  //g' | awk  '{split($0,t," "); for(i=NF;i>0;i--) s = s + $i } END {print 1 - ($4/s) }' | sed 's/\,/\./'`
CPU_USAGE_PERC=`bc <<< "scale=2; 100 * ${CPU_USAGE_RATE}"`
LAST_BOOT=`who -b | sed 's/[a-z ]*//'`
LVM_IN_USE="NO"
if  [[ $(grep 'mapper' /etc/fstab | wc -l) -gt 0 ]];
then
	LVM_IN_USE="YES"
fi
ACTIVE_CONNECTIONS=`ss -Hlt | wc -l`
LOGGED_USERS=`who | wc -l`
IP_ADDRESS=`hostname -I`
SUDO_COMMANDS=`sudo journalctl  /usr/bin/sudo | grep COMMAND | wc -l`


echo -e "${WHITE}Arquitecture           :${GREEN}$MACHINE_ARCHITECTURE"
echo -e "${WHITE}Operating system       :${GREEN}$OPERATING_SYSTEM"
echo -e "${WHITE}Kernel Release         :${GREEN}$KERNEL_RELEASE"
echo -e "${WHITE}Kernel version         :${GREEN}$KERNEL_VERSION"
echo -e "${WHITE}Operating system       :${GREEN}$OPERATING_SYSTEM"
echo -e "${WHITE}CPUS                   :${GREEN}$CPUS"
echo -e "${WHITE}Physical cores         :${GREEN}$PHYSICAL_CORES"
echo -e "${WHITE}virtual cores          :${GREEN}$VIRTUAL_CORES"
echo -e "${WHITE}Total memory           :${GREEN}$TOTAL_RAM GB"
echo -e "${WHITE}Used memory            :${GREEN}$USED_RAM GB (${USED_RAM_PERC}%)"
echo -e "${WHITE}CPU usage              :${GREEN}$CPU_USAGE_RATE %"
echo -e "${WHITE}Last boot time         :${GREEN}$LAST_BOOT"
echo -e "${WHITE}LVM in use             :${GREEN}$LVM_IN_USE"
echo -e "${WHITE}TCP active connections :${GREEN}$ACTIVE_CONNECTIONS"
echo -e "${WHITE}Looged users           :${GREEN}$LOGGED_USERS"
echo -e "${WHITE}IP(v4) address         :${GREEN}$IP_ADDRESS"
echo -e "${WHITE}Sudo commands executed :${GREEN}$SUDO_COMMANDS"
echo -e "${ENDCOLOR}"

