## Starting the experiment
From shell:
```
# imunes -b mitm.imn
```
or from GUI:
```
# imunes mitm.sh
```
and then *Experiment -> Execute*.

## Check network connectivity
Open a shell on the PC node by double clicking in the GUI or by using the [himage](http://imunes.tel.fer.hr/trac/wiki/WikiImunesExamples#himage) command from shell.
```
# himage PC
```
Issue the ping command on the PC:
```
root@PC:/ # ping 10.0.1.10
```
