#/bin/sh

for node in "InboundRouter"
do
    hcp $node.ipfw.rules $node:ipfw.rules
    himage $node sh /ipfw.rules
done
