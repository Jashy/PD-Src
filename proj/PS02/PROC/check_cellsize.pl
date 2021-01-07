#!/usr/bin/perl

$size_max = 20 ;
$size_min = 1  ;
@exc_inst   = ("") ;

while (<>) {
	if( /^\s*module\s+([^\s\(\)]+)[\s\(\)]/ ) {
		( $module_name ) = /^\s*module\s+([^\s\(\)]+)[\s\(\)]/ ;
	}
	split ;
	if ($_[0] =~ /D([0-9]+)$/ || $_[0] =~ /D([0-9]+)HVT$/) {
		if ($1 > $size_max) {
			$err = 1 ;
			foreach $exc_inst (@exc_inst) {
				if ($_[1] =~ /$exc_inst/) {
					$err = 0 ;
					last ;
				}
			}
			if ($err) {
				printf( "Error: high driving cell ( > X$size_max ) found in module \"%s\". (L%d)\n", $module_name, $. ) ;
				print ;
				$count{"max-size-error"}++ ;
			}
		} elsif ($1 < $size_min) {
			$err = 1 ;
			foreach $exc_inst (@exc_inst) {
				if ($_[1] =~ /$exc_inst/) {
					$err = 0 ;
					last ;
				}
			}
			if ($err) {
				printf( "Error: weak driving cell ( < X$size_min ) found in module \"%s\". (L%d)\n", $module_name, $. ) ;
				print ;
				$count{"min-size-error"}++ ;
			}
		}
	}
}

print "\n" ;
@items = ("max-size-error", "min-size-error") ;
foreach $item ( @items ) {
	printf( " Number of %-8s = %6d\n", $item, $count{$item} ) ;
}
