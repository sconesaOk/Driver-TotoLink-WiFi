#!/bin/bash


DRV_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/rtl8812AU_linux_v5.6.4.2_35491.20191025"

if [ "$EUID" != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

cd $DRV_PATH
echo Working dir $DRV_PATH

RED='\033[0;31m'
YELLOW='\033[1;33'
GREEN='\033[1;32'

echo -e $'${YELLOW}* Compiling... \n'
make >$(tty)

echo $'\n\n\n'
echo -e $'${YELLOW}* Installing... \n'

#removing module
rmmod 8812au

#installing module
insmod ${DRV_PATH}/8812au.ko  >$(tty) &&
wait $! || { # catch 
    echo -e $'${YELLOW}* ${RED}Error found, retrying install. \n'
    echo -e $'${YELLOW}* recompiling... \n'
    #recompiling
    make clean
    make all

    echo $'\n\n\n'
    echo -e $'${YELLOW}* Installing... \n'
    insmod ${DRV_PATH}/8812au.ko >$(tty) 
}

echo -e '\n${GREEN}Toto Link wi-fi driver - installed Ok! \n'

echo $'\n\n\n'
read -p 'Press [Enter] key to continue...'

