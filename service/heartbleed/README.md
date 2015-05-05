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

### Executing the attack

