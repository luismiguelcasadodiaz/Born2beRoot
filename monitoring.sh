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
TOTAL_RAM=`cat  /proc/meminfo |grep MemTotal | sed 's/MemTotal:       //'| sed 's/ kB//'`
USED_RAM=`cat  /proc/meminfo |grep MemTotal | sed 's/MemTotal:       //'| sed 's/ kB//'`


echo -e "${WHITE}Arquitecture     :${GREEN}$MACHINE_ARCHITECTURE"
echo -e "${WHITE}Operating system :${GREEN}$OPERATING_SYSTEM"
echo -e "${WHITE}Kernel Release   :${GREEN}$KERNEL_RELEASE"
echo -e "${WHITE}Kernel version   :${GREEN}$KERNEL_VERSION"
echo -e "${WHITE}Operating system :${GREEN}$OPERATING_SYSTEM"
echo -e "${WHITE}CPUS             :${GREEN}$CPUS"
echo -e "${WHITE}Physical cores   :${GREEN}$PHYSICAL_CORES"
echo -e "${WHITE}virtual cores    :${GREEN}$VIRTUAL_CORES"
echo -e "${ENDCOLOR}"

