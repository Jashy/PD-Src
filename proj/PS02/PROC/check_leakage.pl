#! /usr/bin/perl 

printf( "%s\n", $ARGV[0] ) ;

 @lib_dir = qw# /proj/ARM926EJS/WORK_ATILE/simonw/templates/lib/sc/timing_power_noise/CCS/tcbn45gsbwp12thvt_120c/ #;
 #@lib_dir = qw# /proj/Pezy-1/LIB/SC/TSMCHOME/digital/Front_End/timing_power_noise/NLDM /proj/Pezy-1/LIB/MULTI_DRIVER/CKMULTIDRIVER/synopsys /proj/Pezy-1/LIB/MULTI_DRIVER/MULTIBUF/synopsys#;
 
 foreach $lib_root (@lib_dir) {
 foreach $lib_file ( split( /\s+/, `find $lib_root -name "*ml.lib" | grep -v /bk/` ) ) {
   printf( STDERR "Checking file '%s'.\n", $lib_file ) ;
   open( LIB, "< $lib_file" ) ;
   while( <LIB> ) {
     if( /^\s*cell\s*\(\s*([^\s\(\)]+)\s*\)/ ) {
       ( $cell ) = /^\s*cell\s*\(\s*([^\s\(\)]+)\s*\)/ ;
       $leakage_end = 0;
       $is_basic_cell{$cell} = 1 ;
       $cell_type{$cell} = "NVT" ;
       $cell_type{$cell} = "HVT" if( $cell =~ /HVT/ ) ;
       $cell_type{$cell} = "LVT" if( $cell =~ /LVT/ ) ;
     }
     if( /^\s*area\s*:\s*(\d+\.*\d*)\s*;/ ) {
       ( $cell_area{$cell} ) =
         /^\s*area\s*:\s*(\d+\.*\d*)\s*;/ ;
 #$cell_area{$cell} = 0 if( $cell =~ /^TIE/ ) ;
     }
     if( /^\s*cell_leakage_power\s*:\s*(\d+\.\d+)\s*;/ ) {
       ( $cell_leakage_power{$cell} ) = /^\s*cell_leakage_power\s*:\s*(\d+\.\d+)\s*;/ ;
     }
     if( /^\s*leakage_power\s*\(\s*\)\s*{/ && $leakage_end eq "0" ) {
 	$leakage_start = 1 ;
     }
     if(/^\s*value\s*:\s*(\d+\.\d+)\s*;/ && $leakage_start eq "1" && $leakage_end eq "0") {
       #( $cell_leakage_power{$cell} ) = /^\s*cell_leakage_power\s*:\s*(\d+\.\d+)\s*;/ ;
       ( $cell_leakage_power{$cell} ) = /^\s*value\s*:\s*(\d+\.\d+)\s*;/ ;
 	$leakge_start = 0;
 	$leakage_end = 1 ;
 #	print "$cell $cell_leakage_power{$cell} \n";
     }
   }
   close( LIB ) ;
 }
 }
 
 #foreach $cell ( sort( keys( %is_basic_cell ) ) ) {
 #  printf( "%s %.3f\n", $cell, $cell_area{$cell} ) if( $cell_area{$cell} == 0 ) ;
 #}
 
 $/ = ";" ;
 
 
 # foreach $lib_root (@lib_dir) {
 # foreach $lib_file ( split( /\s+/, `find $lib_root -name "*wcl.lib" | grep -v /bk/` ) ) {
 #   printf( STDERR "Checking file '%s'.\n", $lib_file ) ;
 #   open( LIB, "< $lib_file" ) ;
 #   while( <LIB> ) {
 #     if( /^\s*cell\s*\(\s*([^\s\(\)]+)\s*\)/ ) {
 #       ( $cell ) = /^\s*cell\s*\(\s*([^\s\(\)]+)\s*\)/ ;
 # 	$leakage_end = 0 ;
 #       $is_basic_cell{$cell} = 1 ;
 #       $cell_type{$cell} = "NVT" ;
 #       $cell_type{$cell} = "HVT" if( $cell =~ /HVT/ ) ;
 #       $cell_type{$cell} = "LVT" if( $cell =~ /LVT/ ) ;
 #     }
 #     if( /^\s*area\s*:\s*(\d+\.*\d*)\s*;/ ) {
 #       ( $cell_area{$cell} ) =
 #         /^\s*area\s*:\s*(\d+\.*\d*)\s*;/ ;
 # #$cell_area{$cell} = 0 if( $cell =~ /^TIE/ ) ;
 # 	print "aaa\n";
 #     }
 #     #if( /^\s*leakage_power\s*\(\s*\)\s*{/ && $leakage_end == 0 ) {
 #     if( /^\s*leakage_power\s*\(\s*\)\s*{/ ) {
 # 	$leakage_start = 1 ;
 # 	print "aaa\n";
 #     }
 #     if(/^\s*value\s*:\s*(\d+\.\d+)\s*;/ && $leakage_start == 1) {
 #       #( $cell_leakage_power{$cell} ) = /^\s*cell_leakage_power\s*:\s*(\d+\.\d+)\s*;/ ;
 #       ( $cell_leakage_power{$cell} ) = /^\s*value\s*:\s*(\d+\.\d+)\s*;/ ;
 # 	$leakge_start = 0;
 # 	$leakage_end = 1 ;
 # 	print "$cell $cell_leakage_power{$cell} \n";
 #     }
 #   }
 #   close( LIB ) ;
 # }
 # }
 
 #foreach $cell ( sort( keys( %is_basic_cell ) ) ) {
 #  printf( "%s %.3f\n", $cell, $cell_area{$cell} ) if( $cell_area{$cell} == 0 ) ;
 #}
 
 $/ = ";" ;
 
 while( <> ) {
   if( /^\s*(\S+)\s+([^\s\(\)]+)\s*/ ) {
     ( $cell, $instance ) = /^\s*(\S+)\s+([^\s\(\)]+)\s*/ ;
     if( $is_basic_cell{$cell} == 1 ) {
 #printf( "%s %s\n", $cell, $instance ) ;
 #printf( "%s %s\n", $cell, $instance ) if( $cell_type{$cell} eq "NVT" ) ;
 #next if( $cell =~ /^TIE/ ) ;
       $total_cell_count{"total"} ++ ;
 
       $total_cell_count{"LVT"} ++ if( $cell_type{$cell} eq "LVT" ) ;
 #print "$total_cell_count{LVT}\n";
       $total_cell_count{"NVT"} ++ if( $cell_type{$cell} eq "NVT" ) ;
       $total_cell_count{"HVT"} ++ if( $cell_type{$cell} eq "HVT" ) ;
       $total_cell_area{"total"} = $total_cell_area{"total"} + $cell_area{$cell} ;
       $total_cell_area{"LVT"} = $total_cell_area{"LVT"} + $cell_area{$cell} if( $cell_type{$cell} eq "LVT" ) ;
       $total_cell_area{"NVT"} = $total_cell_area{"NVT"} + $cell_area{$cell} if( $cell_type{$cell} eq "NVT" ) ;
       $total_cell_area{"HVT"} = $total_cell_area{"HVT"} + $cell_area{$cell} if( $cell_type{$cell} eq "HVT" ) ;
       $total_cell_leakage_power{"total"} = $total_cell_leakage_power{"total"} + $cell_leakage_power{$cell} ;
       $total_cell_leakage_power{"LVT"} = $total_cell_leakage_power{"LVT"} + $cell_leakage_power{$cell} if( $cell_type{$cell} eq "LVT" ) ;
       $total_cell_leakage_power{"NVT"} = $total_cell_leakage_power{"NVT"} + $cell_leakage_power{$cell} if( $cell_type{$cell} eq "NVT" ) ;
       $total_cell_leakage_power{"HVT"} = $total_cell_leakage_power{"HVT"} + $cell_leakage_power{$cell} if( $cell_type{$cell} eq "HVT" ) ;
     }
   }
 }
 
 printf( "  Cell type        Count (%%)                Area (%%)               Leakage (%%)\n" ) ;
 printf( "  ----------  --------------------  ----------------------  ------------------------\n" ) ;
 printf( "  LVT         %10d (%6.2f%%)  %12.3f (%6.2f%%)  %14.3f (%6.2f%%)\n",
   $total_cell_count{"LVT"}, $total_cell_count{"LVT"} / $total_cell_count{"total"} * 100,
   $total_cell_area{"LVT"}, $total_cell_area{"LVT"} / $total_cell_area{"total"} * 100,
   $total_cell_leakage_power{"LVT"}, $total_cell_leakage_power{"LVT"} / $total_cell_leakage_power{"total"} * 100 ) ;
 
 printf( "  NVT         %10d (%6.2f%%)  %12.3f (%6.2f%%)  %14.3f (%6.2f%%)\n",
   $total_cell_count{"NVT"}, $total_cell_count{"NVT"} / $total_cell_count{"total"} * 100,
   $total_cell_area{"NVT"}, $total_cell_area{"NVT"} / $total_cell_area{"total"} * 100,
   $total_cell_leakage_power{"NVT"}, $total_cell_leakage_power{"NVT"} / $total_cell_leakage_power{"total"} * 100 ) ;
 
 printf( "  HVT         %10d (%6.2f%%)  %12.3f (%6.2f%%)  %14.3f (%6.2f%%)\n",
   $total_cell_count{"HVT"}, $total_cell_count{"HVT"} / $total_cell_count{"total"} * 100,
   $total_cell_area{"HVT"}, $total_cell_area{"HVT"} / $total_cell_area{"total"} * 100,
   $total_cell_leakage_power{"HVT"}, $total_cell_leakage_power{"HVT"} / $total_cell_leakage_power{"total"} * 100 ) ;
 
 printf( "  ----------  --------------------  ----------------------  ------------------------\n" ) ;
 
 printf( "  Total       %10d (%6.2f%%)  %12.3f (%6.2f%%)  %14.3f (%6.2f%%)\n",
   $total_cell_count{"total"}, $total_cell_count{"total"} / $total_cell_count{"total"} * 100,
   $total_cell_area{"total"}, $total_cell_area{"total"} / $total_cell_area{"total"} * 100,
   $total_cell_leakage_power{"total"}, $total_cell_leakage_power{"total"} / $total_cell_leakage_power{"total"} * 100 ) ;
 
 
