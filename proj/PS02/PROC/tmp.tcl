#!/usr/bin/perl
my %receiver;
while (<>) {
#	if (m(^\s*VICTIM NET\s+\S+\s+\(\S+\)\s+\d+\.\d+\[\S+\]\s+(\d+\.\d+)%)i) {
#		print "match is OK and \$2 is $2";
	if (m(^\s*VICTIM RECEIVER\s+(\S+)\s+\(\S+\)\s+(\d+\.\d+)%)i) {
	    $t = $3;
	    if ($t > 35.00) {
	            @pins = keys %receiver;
#		    print @pins;
		    while (@pins) {
#			    $pin = pop @pins;
			    print "$pin\n";
			     if ($pin == $1) {
				    $flag = 1;
				    if ($t < $receiver{$pin}) {
					  $t = $receiver{$pin};
					    print "\$flag is $flag\n";
				    }
			    }
		    }
		    $receiver{$1} = $t; 
#		    if ($flag == 1) {
#			    $flag = 0;
#		    } else {
		    $num +=1;
#	            }
             }
	}
        @pin_vic = keys %receiver;
	@value = values %receiver;
}
#	print "@pin_vic\n";
	print "@value\n";
foreach (@value) {
	if ($max_value < $_) {
 		$max_value = $_;
	}
}

#}
##OR
#while (@values) {
#	$value = pop @values;
#	print "$value\t";
#	if ($max_value < $value) {
#		$max_value = $value;
#	}
#}
print "the numbers of noise larger than 35% is $num\n";
print "the Worst noise is $max_value%\n";
