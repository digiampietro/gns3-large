#!/bin/sh
sudo docker run -h gns3-large \
                -v /tmp/.X11-unix:/tmp/.X11-unix  \
                -v $HOME:$HOME \
                -e DISPLAY=unix/$DISPLAY \
                -e GUSERNAME=`id -u -n`  \
                -e GUID=`id -u`          \
                -e GGROUP=`id -g -n`     \
                -e GGID=`id -g`         \
                -e GHOME=$HOME           \
                -e GSHELL=$SHELL         \
                -it digiampietro/gns3-large

