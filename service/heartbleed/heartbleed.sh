#!/bin/sh

host="10.0.1.10"

# copy exploit script to the Attacker node
hcp heartbleed.py Attacker:
# start the exploit script
himage Attacker python heartbleed.py $host
