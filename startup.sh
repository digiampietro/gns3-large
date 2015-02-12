#!/bin/sh
#
# add current user and user's primary group
#
groupadd -g $GGID $GGROUP
useradd -u $GUID -s $GSHELL -c $GUSERNAME -g $GGID -M -d $GHOME $GUSERNAME
usermod -a -G sudo $GUSERNAME
echo $GUSERNAME:docker | chpasswd
#
# generate IOU License
#
if [ -e $GHOME/gns3-misc/keygen.py ]
then 
    cp $GHOME/gns3-misc/keygen.py /src/misc/
    cd /src/misc
    ./keygen.py  | egrep "license|`hostname`" > iourc.txt 
else
    echo "IOU License File generator keygen.py not found"
    echo "please put keygen.py in"
    echo "$GHOME/gns3-misc/keygen.py"
fi
#
# create the tap device owned by current user
# assign it an IP address, enable IP routing and NAT
#
echo "-------------------------------------------------------------------"
echo "tap0 has address $GTAPIP netmask $GTAPMASK"
echo "if yuou use the cloud symbol to connect to the physical network"
echo "use an address on the same subnet, and, on the cloud symbol,"
echo "select the  \"NIO TAP\" tab and add the \"tap0\" device"
echo "-------------------------------------------------------------------"
chmod 0666 /dev/net/tun
chmod +s /usr/local/bin/iouyap
tunctl -u $GUSERNAME
ifconfig tap0 $GTAPIP netmask $GTAPMASK up
echo 1 > /proc/sys/net/ipv4/ip_forward
if [ "$GTAPNATENABLE" = "1" ]
then
    echo "--- Enabling NAT on incoming ip on tap0 device"
    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    iptables -A FORWARD -i tap0 -j ACCEPT
    iptables -A INPUT -i tap0 -j ACCEPT
fi
if [ "$GROUTE2GNS3" = "1" ]
then 
    route add -net $GNS3NETWORK netmask $GNS3NETMASK gw $GTAPIP
fi
if [ "$GRUNXTERM" = "1" ]
then
    # become the current user and start a shell
    su -l -c lxterminal $GUSERNAME
    # another root shel
    lxterminal
else
    # become the current user and start a shell
    su -l $GUSERNAME
    # another root shell
    /bin/bash
fi



