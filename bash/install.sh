#!/bin/bash


DRV_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/rtl8812AU_linux_v5.6.4.2_35491.20191025"

if [ "$EUID" != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

cd $DRV_PATH
echo Working dir $DRV_PATH

echo $'* Compiling... \n'
make >$(tty)

echo $'\n\n\n'
echo $'* Installing... \n'

#removing module
rmmod 8812au

#installing module
insmod ${DRV_PATH}/8812au.ko  >$(tty) &&
wait $! || { # catch 
    echo $'* Error found, retrying install. \n'
    echo $'* recompiling... \n'
    #recompiling
    make clean
    make all

    echo $'\n\n\n'
    echo $'* Installing... \n'
    insmod ${DRV_PATH}/8812au.ko >$(tty) 
}

echo $'\nToto Link wi-fi driver - installed Ok! \n'

echo $'\n\n\n'
read -p 'Press [Enter] key to continue...'

