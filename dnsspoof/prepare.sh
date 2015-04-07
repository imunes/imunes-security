#!/bin/sh

dns_servers="aRootServer bRootServer cRootServer \
    dnsCom dnsOrg dnsHr \
    dnsFer \
    dnsTel dnsZpm"

http_servers="www rogueServer"

hosts="mm www pc attacker"

cd DNS_files

# Start DNS on all neccessary nodes
for i in $dns_servers
do
    # Stop named on all DNS servers
    himage ${i} killall -9 named 2> /dev/null
    himage $i mkdir -p /var/named/etc/namedb
    hcp $i/* $i:/var/named/etc/namedb
    # Start named on all DNS servers
    himage $i named
done

# Copy neccessary resolv.conf files
for i in $hosts
do
    hcp resolv.$i $i:/etc/resolv.conf
done

cd ..

# Start http servers
for h in $http_servers
do
    himage $h mkdir -p /usr/local/etc/lighttpd
    himage $h mkdir -p /var/log/lighttpd
    himage $h chown -R www:www /var/log/lighttpd

    hcp ${h}.lighttpd.conf $h:/usr/local/etc/lighttpd/lighttpd.conf
    himage $h chmod 755 /usr/local/etc/lighttpd/lighttpd.conf
    hcp -r www.$h $h:/root
    himage $h lighttpd -f /usr/local/etc/lighttpd/lighttpd.conf
done

# Send one DNS query to establish DNS hierarchy
echo 'send(IP(src="10.0.10.3", dst="10.0.10.2")/UDP(dport=53)/DNS\
(id=43322,qr=0,rd=1,\
qd=DNSQR(qname="dnsTel.tel.fer.hr")))
exit()' > /tmp/prepare_dnsspoof.scapy

#copy the scapy script to the attacker
hcp /tmp/prepare_dnsspoof.scapy attacker:

#execute the script
himage attacker scapy -c prepare_dnsspoof.scapy

sleep 10
echo "Finished preparing."
