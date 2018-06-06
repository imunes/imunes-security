#!/usr/bin/env python2
import socket
import sys
import re
import os
from scapy.all import *

# define divert socket
if not socket.__dict__.has_key("IPPROTO_DIVERT"):
    socket.IPPROTO_DIVERT = 258

# define divert port
port=1234

# flush ipfw
os.system("ipfw -f flush")
# set divert socket rule for all incoming ip traffic
os.system("ipfw add divert " + str(port) + " ip from any to any in")

# create a divert socket
sock = socket.socket(socket.AF_INET, socket.SOCK_RAW, socket.IPPROTO_DIVERT)
# bind it on the defined port
sock.bind(("0.0.0.0", port))
# max buf size
bufsize = 65535
# set blocking
sock.setblocking(True)

while True:
    # receive packet
    buf, addr = sock.recvfrom(bufsize)
    print "acquired packet"
    
    # parse it using scapy
    p = IP(buf)

    # do something if it's ICMP
    if p.haslayer(ICMP):
	#p.show()
	# create a new packet with ttl 255 as an echo response with the same seq, id and payload
	newp = IP(src=p.dst,dst=p.src,ttl=255)/ICMP(type=0,seq=p.seq, id=p[1].id)/Raw(p[1].load)
	#newp.show()
	# send using scapy
	send(newp)
	print "sent custom packet"
	continue

    sock.sendto(buf,addr)
    print "released packet"
