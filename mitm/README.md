## Check network connectivity
Start the experiment and open a shell on the PC virtual node.
Issue the ping command on the PC:
```
root@PC:/ # ping 10.0.1.10
PING 10.0.1.10 (10.0.1.10): 56 data bytes
64 bytes from 10.0.1.10: icmp_seq=0 ttl=63 time=0.043 ms
64 bytes from 10.0.1.10: icmp_seq=1 ttl=63 time=0.063 ms
```
Don't stop the command.

## Executing the attack
The attack is started through the script [mitm.sh](mitm.sh):
```
# ./mitm.sh
```
Now all traffic that is sent from the PC to the Router (i.e. all traffic going to the external network) is forwarded through the Attacker.
This can be seen by starting Wireshark (right click on the Attacker, *Wireshark->eth0(10.0.0.210/24)*) or tcpdump on the Attacker node (after getting a shell on the node):
```
root@Attacker:/ # tcpdump -ni eth0
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on eth0, link-type EN10MB (Ethernet), capture size 65535 bytes
15:15:16.690786 IP 10.0.0.20 > 10.0.1.10: ICMP echo request, id 3970, seq 25, length 64
15:15:16.690792 IP 10.0.0.20 > 10.0.1.10: ICMP echo request, id 3970, seq 25, length 64
15:15:16.690807 IP 10.0.1.10 > 10.0.0.20: ICMP echo reply, id 3970, seq 25, length 64
15:15:16.690808 IP 10.0.1.10 > 10.0.0.20: ICMP echo reply, id 3970, seq 25, length 64
15:15:17.116797 ARP, Reply 10.0.0.20 is-at 00:11:22:33:44:55, length 28
15:15:17.116802 ARP, Reply 10.0.0.1 is-at 00:11:22:33:44:55, length 28
```

The PC can also see a difference in the ping output:
```
64 bytes from 10.0.1.10: icmp_seq=66 ttl=63 time=0.060 ms
64 bytes from 10.0.1.10: icmp_seq=67 ttl=63 time=0.064 ms
64 bytes from 10.0.1.10: icmp_seq=68 ttl=62 time=0.071 ms
64 bytes from 10.0.1.10: icmp_seq=69 ttl=62 time=0.066 ms
```
