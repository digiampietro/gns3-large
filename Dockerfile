# Version: 0.7.1
FROM ubuntu:14.04
MAINTAINER Valerio Di Giampietro "valerio@digiampietro.com"
#
# increase the version to force recompilation of everything
#
ENV GNS3LARGEVERSION 0.7.2
#
# ------------------------------------------------------------------
# environment variables to avoid that dpkg-reconfigure 
# tries to ask the user any questions
#
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
#
# ----------------------------------------------------------------- 
# install needed packages to build and run gns3 and related sw
#
RUN apt-get update
RUN apt-get -y install git wget
RUN apt-get -y install libpcap-dev uuid-dev libelf-dev cmake
RUN apt-get -y install python3-setuptools python3-pyqt4 python3-ws4py
RUN apt-get -y install python3-netifaces python3-zmq python3-tornado python3-dev
RUN apt-get -y install bison flex
# 
# for iou install 32 bit libraries, python is needed to generate the license file
#
RUN apt-get -y install lib32z1 lib32ncurses5 lib32bz2-1.0
RUN apt-get -y install lxterminal telnet
RUN apt-get -y install python
RUN apt-get -y install wireshark cpulimit
#
# -----------------------------------------------------------------
# compile and install dynamips, gns3-server, gns3-gui
#
RUN mkdir /src
RUN cd /src; git clone https://github.com/GNS3/dynamips.git
RUN cd /src/dynamips ; git checkout v0.2.14
RUN mkdir /src/dynamips/build
RUN cd /src/dynamips/build ;  cmake .. ; make ; make install
#
RUN cd /src; git clone https://github.com/GNS3/gns3-gui.git
RUN cd /src; git clone https://github.com/GNS3/gns3-server.git
RUN cd /src/gns3-server ; git checkout v1.2.3 ; python3 setup.py install
RUN cd /src/gns3-gui ; git checkout v1.2.3 ; python3 setup.py install
#
#-----------------------------------------------------------------------
# compile and install vpcs, 64 bit version
#
RUN cd /src ; \
    wget -O - http://sourceforge.net/projects/vpcs/files/0.5/beta/vpcs-0.5b2-src.tbz/download \
    | bzcat | tar -xvf -
RUN cd /src/vpcs-*/src ; ./mk.sh 64
RUN cp /src/vpcs-*/src/vpcs /usr/local/bin/vpcs
#
# --------------------------------------------------------------------
# compile and install iniparser (needed for iouyap) and 
# iouyap (needed to run iou without additional virtual machine)
#
RUN cd /src ; git clone http://github.com/ndevilla/iniparser.git
RUN cd /src/iniparser ; make
RUN cd /src/iniparser ; cp libiniparser.* /usr/lib ; \
                        cp src/iniparser.h /usr/local/include/ ; \
                        cp src/dictionary.h /usr/local/include/
#
RUN cd /src ; git clone https://github.com/GNS3/iouyap.git
RUN cd /src/iouyap ; make
RUN cd /src/iouyap ; cp iouyap /usr/local/bin
#
# to run iou 32 bit support is needed so add i386 repository, cannot be done
# before compiling dynamips
#
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get -y install libssl-dev:i386
#
# ---------------------------------------------------------------------------
# install QEMU
#
RUN apt-get -y install qemu
#
# ---------------------------------------------------------------------------
# install uml-utilities e iptables to be able to  use tap0 device
# and NAT
#
RUN apt-get -y install uml-utilities iptables
#
# ---------------------------------------------------------------------------
# these links are needed to run IOU
#
RUN ln -s /usr/lib/i386-linux-gnu/libcrypto.so /usr/lib/i386-linux-gnu/libcrypto.so.4
#
#
# prepare startup files /src/misc
#
RUN mkdir /src/misc
#
# install gnome connection manager
#
RUN cd /src/misc; wget http://kuthulu.com/gcm/gnome-connection-manager_1.1.0_all.deb
#RUN cd /src/misc; wget http://va.ler.io/myfiles/deb/gnome-connection-manager_1.1.0_all.deb
RUN apt-get -y install expect python-vte python-glade2
RUN mkdir -p /usr/share/desktop-directories
RUN cd /src/misc; dpkg -i gnome-connection-manager_1.1.0_all.deb
RUN (while true;do echo;done) | perl -MCPAN -e 'install JSON::Tiny'
RUN (while true;do echo;done) | perl -MCPAN -e 'install File::Slurp'
#RUN cd /usr/local/bin; ln -s /usr/share/gnome-connection-manager/* .
ADD gcmconf /usr/local/bin/gcmconf
ADD startup.sh /src/misc/startup.sh
ADD iourc.sample /src/misc/iourc.txt
ADD gcm /usr/local/bin/gcm
# Set the locale
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8  
RUN chmod a+x /src/misc/startup.sh
ENTRYPOINT cd /src/misc ; ./startup.sh
