#!/usr/bin/bash
WHITE="\e[97m"
RED="\e[31m"
GREEN="\e[92m"
ENDCOLOR="\e[0m"

KERNEL_RELEASE=`uname --kernel-release`
KERNEL_VERSION=`uname --kernel-version`
OPERATING_SYSTEM=`uname --operating-system`
MACHINE_ARCHITECTURE=`uname --machine`


echo -e "${WHITE}Kernel Release   :${GREEN}$KERNEL_RELEASE"
echo -e "${WHITE}Kernel version   :${GREEN}$KERNEL_VERSION"
echo -e "${WHITE}Operating system :${GREEN}$OPERATING_SYSTEM"
echo -e "${WHITE}Arquitecture     :${GREEN}$MACHINE_ARCHITECTURE"
