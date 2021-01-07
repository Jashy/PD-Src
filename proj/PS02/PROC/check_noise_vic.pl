#!/usr/bin/perl
my %receiver;
while (<>) {
	if (m(^\s*VICTIM RECEIVER\s+(\S+)\s+\(\S+\)\s+(\d+\.\d+)%)i) {
	$t = $3;
		if ($t > 36.00) {
			@pins = keys %receiver;
			while (@pins) {
				$pin = pop @pins;
			        if ($pin eq $1) {
					#very important: is "$pin eq $1" not "$pin == $1"
					$flag = 1;
					if ($t < $receiver{$pin}) {
						$t = $receiver{$pin};
					}
			        }
			}
			if ( $flag == 1 ) {
				$flag = 0;
			} else {
				$num +=1;
				$receiver{$1} = $t; 
		        }
		}
	}
}
@pin_vic = keys %receiver;
@value = values %receiver;
#print "@pin_vic\n";
print "@value\n";
%inverse_receiver = reverse %receiver;
foreach (@value) {
	if ($max_value < $_) {
 		$max_value = $_;
		$max_value_pin = $inverse_receiver{$_};
	}
}

print "the numbers of noise larger than 35% is $num\n";
print "the Worst noise is $max_value%\n";
print "the receiver of the Worst noise is $max_value_pin\n";
