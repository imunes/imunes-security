# IP Divert socket example

Start the topology ipdivert.imn in IMUNES.

After the topology is started check for IP connectivity from the `pc` node to
the `test` node and leave the command running.
```console
root@pc:/ # ping 10.0.0.21
PING 10.0.0.21 (10.0.0.21): 56 data bytes
64 bytes from 10.0.0.21: icmp_seq=0 ttl=64 time=0.039 ms
64 bytes from 10.0.0.21: icmp_seq=1 ttl=64 time=0.050 ms
64 bytes from 10.0.0.21: icmp_seq=2 ttl=64 time=0.050 ms
64 bytes from 10.0.0.21: icmp_seq=3 ttl=64 time=0.048 ms
```

Start the [deploy.sh](deploy.sh) script from outside of the experiment. The
script will copy [ipdivert.py](ipdivert.py) to the `test` node and will start
diverting all incoming traffic to the python process. As a result the
responding ttl will change to 255. The responding packet is crafted by using
scapy. All non ICMP traffic will be forwarded normally but in a slower manner
because all the processing is done in the userspace.

```console
# ./deploy.sh
WARNING: No route found for IPv6 destination :: (no default route?)
Flushed all rules.
00100 divert 1234 ip from any to any in
acquired packet
.
Sent 1 packets.
sent custom packet
```

On the `pc` node we can see the change:
```console
64 bytes from 10.0.0.21: icmp_seq=14 ttl=64 time=0.047 ms
64 bytes from 10.0.0.21: icmp_seq=15 ttl=64 time=0.047 ms
64 bytes from 10.0.0.21: icmp_seq=16 ttl=64 time=0.049 ms
64 bytes from 10.0.0.21: icmp_seq=17 ttl=255 time=84.106 ms
64 bytes from 10.0.0.21: icmp_seq=18 ttl=255 time=17.619 ms
64 bytes from 10.0.0.21: icmp_seq=19 ttl=255 time=17.317 ms
64 bytes from 10.0.0.21: icmp_seq=20 ttl=255 time=17.187 ms
```
