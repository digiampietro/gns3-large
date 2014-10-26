#!/bin/sh
groupadd -g $GGID $GGROUP
useradd -u $GUID -s $GSHELL -c $GUSERNAME -g $GGID -M $GUSERNAME -d $GHOME
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
su -l $GUSERNAME
/bin/bash



