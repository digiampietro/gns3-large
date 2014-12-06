#!/bin/bash
#
# this script has to be executed in windows after installing
# boot2docker, including MSYS-Git UNIX tools
# that installation supports execution of /bin/bash scripts
#
set -e
# clear the MSYS MOTD
clear
#
# to connect the emulated network to the external world
# we use a tap0 interface inside the docker container
# connected to the GNS3 emulated network through
# a GNS3 Cloud device attached to the tap0 interface
#
export GTAPIP=10.123.1.1           # the tap0 IP address
export GTAPMASK=255.255.255.0      # the tap0 IP netmask
export GTAPNATENABLE=1             # enable NAT on tap0 outgoing traffic (if 1 GROUTE2GNS3 must be 0)
export GNS3NETWORK=10.123.0.0      # IP network used inside the GNS3 emulated network
export GNS3NETMASK=255.255.0.0     # IP netmask used inside the GNS3 emulated network
export GROUTE2GNS3=0               # enable routing from the container eth0 to the emulated network
export GRUNXTERM=1                 # start lxtermina, useful in windows

# find main IP of Windows PC
PCIP=`ping $COMPUTERNAME -n 1 | grep $COMPUTERNAME | grep '\[' | sed 's/^.*\[//' | sed 's/\].*//'`
# if the home dir is /d/users/username modify to /c/users/username
# because boot2docker maps only c:/users/username in /c/Users/username in docker
GHOME=`echo $HOME | sed 's/^\/.\//\/c\//' | sed 's/users/Users/i'`
echo "HOME:         $HOME"
echo "GHOME:        $GHOME"
echo "computername: $COMPUTERNAME"
echo "IP:           $PCIP"

/c/Program\ Files/Boot2Docker\ for\ Windows/boot2docker.exe    \
                  ssh "docker run                              \
                              --rm                             \
                              -h gns3-large                    \
                              -v $GHOME:/home/gns3user         \
                              -e DISPLAY=$PCIP:0               \
                              -e GUSERNAME=gns3user            \
                              -e GUID=1100                     \
                              -e GGROUP=gns3user               \
                              -e GGID=1100                     \
                              -e GHOME=/home/gns3user          \
                              -e GSHELL=/bin/bash              \
                              -e GTAPIP=$GTAPIP                \
                              -e GTAPMASK=$GTAPMASK            \
                              -e GTAPNATENABLE=$GTAPNATENABLE  \
                              -e GNS3NETWORK=$GNS3NETWORK      \
                              -e GNS3NETMASK=$GNS3NETMASK      \
                              -e GROUTE2GNS3=$GROUTE2GNS3      \
                              -e GRUNXTERM=$GRUNXTERM          \
                              --privileged                     \
                              -it digiampietro/gns3-large"
