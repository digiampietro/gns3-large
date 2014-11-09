#!/bin/sh

export GDISPLAY=unix/$DISPLAY      # forward X11 display to the host machine
export GUSERNAME=`id -u -n`        # current user's username
export GUID=`id -u`                # current user's user id
export GGROUP=`id -g -n`           # current user's primary group name
export GGID=`id -g`                # current user's primary group id
export GHOME=$HOME                 # current user's home directory
export GSHELL=$SHELL               # current user's shell
#
# to connect the emulated network to the external world
# we use a tap0 interface inside the docker container
# connected to the GNS3 emulated network through
# a GNS3 Cloud device attached to the tap0 interface
#
export GTAPIP=10.123.1.1           # the tap0 IP address
export GTAPMASK=255.255.255.0      # the tap0 IP netmask
export GTAPNATENABLE=0             # enable NAT on tap0 outgoing traffic (if 1 GROUTE2GNS3 must be 0)
export GNS3NETWORK=10.123.0.0      # IP network used inside the GNS3 emulated network
export GNS3NETMASK=255.255.0.0     # IP netmask used inside the GNS3 emulated network
export GROUTE2GNS3=1               # enable routing from the container eth0 to the emulated network

sudo docker run -h gns3-large                     \
                -v /tmp/.X11-unix:/tmp/.X11-unix  \
                -v $HOME:$HOME                    \
                -e DISPLAY=$GDISPLAY              \
                -e GUSERNAME=$GUSERNAME           \
                -e GUID=$GUID                     \
                -e GGROUP=$GGROUP                 \
                -e GGID=$GGID                     \
                -e GHOME=$HOME                    \
                -e GSHELL=$SHELL                  \
                -e GTAPIP=$GTAPIP                 \
                -e GTAPMASK=$GTAPMASK             \
                -e GTAPNATENABLE=$GTAPNATENABLE   \
                -e GNS3NETWORK=$GNS3NETWORK       \
                -e GNS3NETMASK=$GNS3NETMASK       \
                -e GROUTE2GNS3=$GROUTE2GNS3       \
                --privileged                      \
                -it digiampietro/gns3-large

