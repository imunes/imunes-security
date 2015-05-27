#!/bin/sh

kldload -n ipfw ipdivert
hcp ipdivert.py test:/root
himage test /root/ipdivert.py
