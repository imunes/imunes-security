# imunes-security
Examples of security scenarios in IMUNES.

IMUNES is a lightweight network emulator that runs on top of the FreeBSD kernel
which is used to create a virtual network topology by using FreeBSD
[jails](https://www.freebsd.org/doc/handbook/jails.html) and
[netgraph](https://www.freebsd.org/cgi/man.cgi?netgraph%284%29).

All presented scenarios run on in the IMUNES virtual machine that can be
downloaded from: http://www.imunes.net/dl/IMUNES_security.ova.

The IMUNES manual is located [here](http://imunes.net/dl/imunes_user_guide.pdf).

To run the scenarios, after starting the virtual machine, just git pull the latest
version of the repository in /root/imunes-security:
```
# cd imunes-security
# git pull
```
## Starting experiments in IMUNES
From shell:
```
# imunes -b mitm.imn
```
or from GUI:
```
# imunes mitm.imn
```
and then select the menu *Experiment -> Execute*.

## Executing commands in virtual nodes
From shell (with the [himage](http://imunes.tel.fer.hr/trac/wiki/WikiImunesExamples#himage) command):
```
# himage node_name command
```
or from GUI:
* double-click on a virtual node in a running experiment
* right-click on a virtual node and select *Shell window -> csh* or *Shell window -> bash*

## Copying files from and to virtual nodes
This can be done only from shell by using the [hcp](http://imunes.tel.fer.hr/trac/wiki/WikiImunesExamples#hcp) command:
```
# hcp script.py node_name:
# hcp node_name:script.log .
# hcp n0:key.pem n1:
```

