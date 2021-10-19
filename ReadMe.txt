To instal driver TotoLink wifi
==============================

1) Compile driver

$ cd ~/Driver/WiFi_TotoLink/rtl8812AU_linux_v5.6.4.2_35491.20191025rx
$ sudo make 



2) Test driver

$ sudo insmod /home/sergio/Driver/WiFi_TotoLink/rtl8812AU_linux_v5.6.4.2_35491.20191025/8812au.ko



3) If fails msg: "could not insert module ... invalid module format", run this commands and retry 2)

$ sudo make clean
$ sudo make all



4) To autostart, create a file:

$ sudo cat << EOF > /etc/rc.local
#!/bin/sh -e

#wifi driver install:
insmod /home/sergio/Driver/WiFi_TotoLink/rtl8812AU_linux_v5.6.4.2_35491.20191025/8812au.ko

exit 0

EOF



5) Grant excecution.

$ sudo chmod +x /etc/rc.local




