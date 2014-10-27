# GNS3 1.1 docker image with VPCS, IOU, QEMU and Wireshark

### News

2014-10-27 Added QEMU emulator

### Description

This image is based on Ubuntu 14.04 and includes GNS3, VPCS, IOU Support, QEMU and Wireshark. For IOU emulation no additional Virtual Machine is required.

VirtualBox is not included, there are some issues that I was not able to solve to run VirtualBox inside a Docker container.

On image startup a new user is created with same username and user id of current user with the purpose of sharing the same home directory that the user has on the Linux machine.

### Usage

To start the image use the `myrun.sh` script, you will get a standard linux prompt, launch gns3 issuing the `gns3` command, you will have access to your home directory. The `myrun.sh` is avilable on my GitHub repository for [gns3-large](https://github.com/digiampietro/gns3-large):

```
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
```

* `-h gns3-large` gives the hostname to the docker image
* `-v /tmp/.X11-unix:/tmp/.X11-unix` is needed to display the application
* `-v $HOME:$HOME` mount your home directory inside the docker image (the `$HOME` evniroment variable must be correctly set) 
* `-e DISPLAY=unix/$DISPLAY` is needed to display the application
* `-e ... ` these options set environment variables used by the startup script to add the current user to the docker image. The $HOME and $SHELL environment variables must be correctly set and must contain users's home directory and user's shell
* `-it digiampietro/gns3-large` starts the image with a controlling terminal

The docker image, each time that starts, has the virtual interface MAC address changed, for this reason the `iourc.txt` file, containing the IOU License, must be regenerated. The startup script take care of this but you have to put the script `keygen.py` in the `gns3-misc/` folder inside your home directory. The generated `iourc.txt` file is put in `/src/misc/iourc.txt` (in the image file system).

After image startup you have a standard linux prompt, type `gns3` to start the application or type exit to remain in the docker image with root access; to exit from the image type `exit` once more.

To complete the setup of GNS3, launch the application `gns3` at the linux prompt, go to *Edit -> Preferences ...*:

* in *General -> Console applications* replace the string _gnome-terminal_ with _lxterminal_ and then click on *Apply* and *OK*. This is needed because gnome-terminal can have some issues, related to dbus,  inside the docker image;
* in *IOS on UNIX -> General settings* put the string *`/src/misc/iourc.txt`* in *Path to IOURC (pushed to the server)* and then click on *Apply* and *OK* 
* in *Dynamips - IOS Routers* click _New_ and add your router images. For legal reasons these images cannot be bundled with the docker image, they have names like `c3725-adventerprisek9-mz.124-15.T14.image` or `c3640-jk9s-mz.124-16.image` or `c7200-adventerprisek9-mz.124-15.T14.image`. Google is your best friend
* in *IOS on UNIX - IOU Devices* click _New_ and add your IOU images. For legal reasons these images cannot be bundled with docker image, they have names like `i86bi-linux-l2-adventerprisek9-15.1a.bin` or `i86bi-linux-l3-adventerprisek9-15.4.1T.bin`. 


## License
(The MIT License)

Copyright (c) 2014 Valerio Di Giampietro [digiampietro.com](http://digiampietro.com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.