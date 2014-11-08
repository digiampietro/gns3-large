#!/bin/sh
export GNS3NETWORK=10.123.0.0
export GNS3NETMASK=255.255.0.0
export GROUTE2GNS3=1
sudo docker run -h gns3-large                     \
                -v /tmp/.X11-unix:/tmp/.X11-unix  \
                -v $HOME:$HOME                    \
                -e DISPLAY=unix/$DISPLAY          \
                -e GUSERNAME=`id -u -n`           \
                -e GUID=`id -u`                   \
                -e GGROUP=`id -g -n`              \
                -e GGID=`id -g`                   \
                -e GHOME=$HOME                    \
                -e GSHELL=$SHELL                  \
                -e GTAPIP=10.123.1.1              \
                -e GTAPMASK=255.255.255.0         \
                -e GTAPNATENABLE=0                \
                -e GNS3NETWORK=$GNS3NETWORK       \
                -e GNS3NETMASK=$GNS3NETMASK       \
                -e GROUTE2GNS3=$GROUTE2GNS3       \
                --privileged                      \
                -it digiampietro/gns3-large

