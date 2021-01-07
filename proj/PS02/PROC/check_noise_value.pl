#!/usr/bin/perl

while (<>) {
#	if (m(^\s*VICTIM NET\s+\S+\s+\(\S+\)\s+\d+\.\d+\[\S+\]\s+(\d+\.\d+)%)i) {
#		print "match is OK and \$2 is $2";
	if (m(^\s*VICTIM RECEIVER\s+(\S+)\s+\(\S+\)\s+(\d+\.\d+)%)i) {
	    if ($3 > 35.00) {
		    $num +=1;
		    push @values, $3; 
		    push @vic_pins, $1;
	    }
	}
}
print "@values\n";
foreach (@vic_pins) {
	print "$_\t";
}
#foreach (@values) {
#	print "$_\t";
#	if ($max_value < $_) {
# 		$max_value = $_;
#	}
#
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
