#!/usr/bin/perl

use Getopt::Long ;
GetOptions(
	'imp_vnet=s' => \$imp_vnet ,
	'ref_vnet=s' => \$ref_vnet
) ;

if ( $imp_vnet && $ref_vnet ) {
	open( IMP, $imp_vnet ) || die( "Error: Can't open the implemented vnet $imp_vnet\n" ) ;
	open( REF, $ref_vnet ) || die( "Error: Can't open the reference vnet $ref_vnet\n" ) ;
} elsif ( $imp_vnet ) {
	open( IMP, $imp_vnet ) || die( "Error: Can't open the implemented vnet $imp_vnet\n" ) ;
} elsif ( !$imp_vnet && !$ref_vnet && $ARGV[0] ) {
	$imp_vnet = $ARGV[0] ;
	open( IMP, $imp_vnet ) || die( "Error: Can't open the implemented vnet $imp_vnet\n" ) ;
} else {
	die( "Error: Please specify the corrent command options '-r ref_vnet -i imp_vnet\n" ) ;
}

if ( $ref_vnet ) {
	while( <REF> ) {
		if( /^\s*module\s+([^\s\(\)]+)[\s\(\)]/ ) {
			( $module_name ) = /^\s*module\s+([^\s\(\)]+)[\s\(\)]/ ;
			$ref_module{$module_name} = 1 ;
		}
	}
	close REF ;
}

while( <IMP> ) {
	if( /^\s*module\s+([^\s\(\)]+)[\s\(\)]/ ) {
		( $module_name ) = /^\s*module\s+([^\s\(\)]+)[\s\(\)]/ ;
		$imp_module{$module_name} = 1 ;
	}
	if( /^\s*assign\s+/ ) {
		( $item ) = /^\s*(assign)\s+/ ;
		printf( "Error: %s statement exists in module \"%s\". (L%d)\n", $item, $module_name, $. ) ;
		print ;
		$count{$item}++ ;
	}
	if( /(1'b[01])/ ) {
		( $item ) = /(1'b[01])/ ;
		printf( "Error: Direct constant connection %s exists in module \"%s\". (L%d)\n", $item, $module_name, $. ) ;
		print ; 
		$count{$item}++ ;
	}
	if( /^\s*(supply[01])\s+/ ) {
		( $item ) = /^\s*(supply[01])\s+/ ;
		printf( "Error: Constant net %s exists in module \"%s\". (L%d)\n", $item, $module_name, $. ) ;
		print ;
		$count{$item}++ ;
	}
	if( /^\s*(tri|wand|wor)\s+/ ) {
		( $item ) = /^\s*(tri|wand|wor)\s+/ ;
		printf( "Error: Non-structural construct %s exists in module \"%s\". (L%d)\n", $item, $module_name, $. ) ;
		print ;
		$count{$item}++ ;
	}
	if( /\\/ ) {
		( $item ) = ( "b-slash" ) ;
		printf( "Error: Back-slash exists in module \"%s\". (L%d)\n", $module_name, $. ) ;
		print ;
		$count{$item}++ ;
	}
#  if( /inout/ )  
	if( /inout\s+/ ) {
		( $item ) = ( "inout" ) ;
		printf( "Error: 'inout' exists in module \"%s\". (L%d)\n", $module_name, $. ) ;
		print ;
		$count{$item}++ ;
	}
}
close IMP ;

foreach $module_name (keys %ref_module) {
	unless ( $imp_module{$module_name} ) {
		$count{"maintain"}++ ;
		printf( "Error: module \"%s\" has disappeared in implementated netlist\n", $module_name ) ;
	}
}
print "\n" ;

@items = split( /\s+/, "assign 1'b0 1'b1 supply0 supply1 tri wand wor b-slash inout maintain" ) ;
#@items = keys( %count ) ;
foreach $item ( @items ) {
	printf( " Number of %-8s = %6d\n", $item, $count{$item} ) ;
}
