#!/usr/local/bin/perl

## 080202
## remove assign net1 = 1'bx; 
## change to eg. TIE U1 (.Z(net1));

use strict;
use warnings;

my $debug = 0;

my $num = 0;

my $input_netlist = shift @ARGV;

open (in_netlist, "$input_netlist") || die "$input_netlist : $!";
open (OUT, ">${input_netlist}_noassign") || die "${input_netlist}_noassign : $!";

while ( <in_netlist> ) {
	if($_=~/^\s*assign\s+(\S+)\s*=\s*1'b(\S+)\s*;/) {
		$num = $num + 1;
		my $net = $1;
		my $value = $2;
		print OUT "\/\/$_";
                print "\/\/$_";
 		if ( $value == 0 ) {
			print OUT "PULL0 U_ASSIGN_TIE_${num} \( \.Z\($net\)\)\;\n";
                        print "PULL0 U_ASSIGN_TIE_${num} \( \.Z\($net\)\)\;\n";
		} else {
			print OUT "PULL1 U_ASSIGN_TIE_${num} \( \.Z\($net\)\)\;\n";
                        print "PULL1 U_ASSIGN_TIE_${num} \( \.Z\($net\)\)\;\n";
		}
	} elsif ($_=~/^\s*assign\s+(\S+)\s*=\s*(\S+)\s*;/){
                print OUT "\/\/$_";
                print "\/\/$_";
		$num = $num + 1;
		print OUT "BUFV4 U_ASSIGN_BUF_${num} \( \.I\($2\), \.Z($1) \)\;\n";
		print "BUFV4 U_ASSIGN_BUF_${num} \( \.I\($2\), \.Z($1) \)\;\n";
	} else {
		print OUT "$_";
	}
}

close OUT;
close in_netlist;
