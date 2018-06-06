#!/bin/sh

kldload -n ipfw ipdivert
himage pc ipfw add 10 allow ip from any to any
hcp ipdivert.py test:/root
himage test /root/ipdivert.py
