#!/bin/sh

set -e

VROOT=/var/imunes/vroot
SRCS="openssl nginx"
PKGS="dsniff scapy p0f nmap ettercap tcpreplay hping gmake gcc wget"

cp /etc/resolv.conf $VROOT/etc
# install missing packages
pkg -c $VROOT update
pkg -c $VROOT install -y $PKGS # fetch sources for boulding and extract them
for file in $SRCS; do
	fetch http://www.imunes.net/dl/$file.tar.gz
	tar xf $file.tar.gz -C $VROOT/tmp/
	rm $file.tar.gz
done
rm $VROOT/etc/resolv.conf

# gcc must be available for openssl
if ! test -e /usr/bin/gcc; then
    chroot $VROOT ln -fs /usr/local/bin/gcc48 /usr/local/bin/gcc
fi

# compile and install nginx which installs openssl
cd $VROOT/tmp/nginx-1.9.2
./configure --with-openssl=/tmp/openssl-1.0.1a/ --with-http_ssl_module
chroot $VROOT sed -i "" -e "s/install LIBDIR=lib/install_sw LIBDIR=lib/" /tmp/nginx-1.9.2/objs/Makefile
chroot $VROOT make install -C /tmp/nginx-1.9.2
