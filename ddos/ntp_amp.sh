#!/bin/sh

# send a total of 1 000 000 * 10 packets using tcp replay
sudo himage Attacker tcpreplay -i eth0 -l 1000000 ntp.pcap
