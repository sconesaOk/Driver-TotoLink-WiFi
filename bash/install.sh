#!/bin/bash

RED='\e[1;31m '
YELLOW='\e[1;33m '
GREEN='\e[1;32m '
RESET='\e[0m '
LightBlue='\e[1;34m '


DRV_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/rtl8812AU_linux_v5.6.4.2_35491.20191025"

if [ "$EUID" != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

cd $DRV_PATH
echo -e "\n\n\n"
echo -e "${LightBlue} Working dir: ${DRV_PATH}"

echo -e "\n\n\n"
echo -e "${YELLOW}* Compiling... \n ${RESET}"
make >$(tty)

echo -e "\n\n\n"
echo -e "${YELLOW}* Installing... \n ${RESET}"

#removing module
rmmod 8812au

#installing module
insmod ${DRV_PATH}/8812au.ko  >$(tty) &&
wait $! || { # catch 
    echo -e "${YELLOW}* ${RED}Error found, retrying install. \n ${RESET}"
    echo -e "${YELLOW}* recompiling... \n ${RESET}"
    #recompiling
    make clean
    make all

    echo -e "\n\n\n"
    echo -e "${YELLOW}* Installing... \n ${RESET}"
    insmod ${DRV_PATH}/8812au.ko >$(tty) 
}

echo -e "\n${GREEN}Toto Link wi-fi driver - installed Ok! \n ${RESET}"

echo -e "\n\n\n"
read -p "Press [Enter] key to continue..."

