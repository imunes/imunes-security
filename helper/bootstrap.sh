#!/bin/sh

VROOT=/var/imunes/vroot
SRCS="openssl lighttpd"

cp /etc/resolv.conf $VROOT/etc
# install missing packages
pkg -c $VROOT install dsniff scapy p0f nmap ettercap tcpreplay hping gmake
# fetch sources for boulding and extract them
for file in $SRCS; do
	fetch http://www.imunes.net/dl/$file.tar.gz
	tar xf $file.tar.gz -C $VROOT/tmp/
	rm $file.tar.gz
done
rm $VROOT/etc/resolv.conf

# compile and install openssl
cd $VROOT/tmp/openssl-1.0.1a && ./config && gmake && echo SUCCESS
chroot $VROOT make install -C /tmp/openssl-1.0.1a/
mv $VROOT/usr/bin/openssl $VROOT/usr/bin/openssl_bkp
chroot $VROOT ln -s /tmp/openssl-1.0.1a/apps/openssl /usr/bin/openssl
chroot $VROOT cp /tmp/openssl-1.0.1a/apps/openssl.cnf /usr/local/ssl
chroot $VROOT mkdir -p /usr/local/etc/lighttpd/certs

# compile and install lighttpd
cd $VROOT/tmp/lighttpd-1.4.17
./configure --with-openssl
make -j4
chroot $VROOT make install -C /tmp/lighttpd-1.4.17/
