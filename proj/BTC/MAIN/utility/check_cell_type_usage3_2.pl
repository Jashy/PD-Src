#!/usr/bin/perl

$lib_root = "/proj/THP7312/LIB/CURRENT/SC/tcbn55lp*/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn55lp*/ ";

$corner = "ml" ;
#corner = "tc" ;

foreach $lib_file ( split( /\s+/, `find $lib_root -name "*${corner}.lib" | grep -v /bk/` ) ) {
  printf( "Checking file '%s'.\n", $lib_file ) ;
  open( LIB, "< $lib_file" ) ;
  while( <LIB> ) {
    if( /^\s*process\s*:\s*([^\s;]+)\s*;/ ) {
      ( $process ) =
        /^\s*process\s*:\s*([^\s;]+)\s*;/ ;
    }
    if( /^\s*temperature\s*:\s*([^\s;]+)\s*;/ ) {
      ( $temperature ) =
        /^\s*temperature\s*:\s*([^\s;]+)\s*;/ ;
    }
    if( /^\s*voltage\s*:\s*([^\s;]+)\s*;/ ) {
      ( $voltage ) =
        /^\s*voltage\s*:\s*([^\s;]+)\s*;/ ;
    }
    if( /^\s*leakage_power_unit\s*:\s*([^\s;]+)\s*;/ ) {
      ( $leakage_power_unit ) =
        /^\s*leakage_power_unit\s*:\s*([^\s;]+)\s*;/ ;
    }

    if( /^\s*cell\s*\(\s*([^\s\(\)]+)\s*\)/ ) {
      ( $cell ) = /^\s*cell\s*\(\s*([^\s\(\)]+)\s*\)/ ;
      $is_basic_cell{$cell} = 1 ;
      $cell_type{$cell} = "NVT" ;
      $cell_type{$cell} = "HVT" if( $cell =~ /HVT$/ ) ;
      $cell_type{$cell} = "LVT" if( $cell =~ /LVT$/ ) ;
    }
    if( /^\s*area\s*:\s*(\d+\.*\d*)\s*;/ ) {
      ( $cell_area{$cell} ) =
        /^\s*area\s*:\s*(\d+\.*\d*)\s*;/ ;
$cell_area{$cell} = 0 if( $cell =~ /^TIE/ ) ;
    }
    if( /^\s*cell_leakage_power\s*:\s*(\d+\.\d+)\s*;/ ) {
      ( $cell_leakage_power{$cell} ) = /^\s*cell_leakage_power\s*:\s*(\d+\.\d+)\s*;/ ;
    }

    if( /^\s*(\S+)\s*\(\s*\)/ ) {
      ( $section ) =
        /^\s*(\S+)\s*\(\s*\)/ ;
    }
    if( $section eq "leakage_power" ) {
      if( /^\s*value\s*:\s*(\d+\.*\d*)\s*/ ) {
        ( $leakage_power ) =
          /^\s*value\s*:\s*(\d+\.*\d*)\s*/ ;
     # print " $cell_leakage_power{$cell}\n" ;
     # print " $leakage_power\n" ;
        $cell_leakage_power{$cell} = $leakage_power if( $cell_leakage_power{$cell} eq "" ) ;
        $cell_leakage_power{$cell} = $leakage_power if( $cell_leakage_power{$cell} < $leakage_power ) ;
      }
    }

  }
  close( LIB ) ;
}

#$lib_root = "/proj/THP7312/LIB/CURRENT/MEM/*/RELEASE/NLDM/ /proj/THP7312/from_customer/20130422_512x32_Memory_Lib/THP7312_tsn55lpll2prf_512x32m2s_200a_lib_20130422/ ";
$lib_root = "/proj/THP7312/LIB/CURRENT/MEM/*/RELEASE/NLDM/ /proj/THP7312/from_customer/mem_from_customer/THP7312_tsn55lpll2prf_512x32m2s_200a_lib_20130422/ ";

$corner = "ff1p32v125c" ;
#corner = "tc" ;

foreach $lib_file ( split( /\s+/, `find $lib_root -name "*${corner}.lib" | grep -v /bk/` ) ) {
  printf( "Checking file '%s'.\n", $lib_file ) ;
  open( LIB, "< $lib_file" ) ;
  while( <LIB> ) {
    if( /^\s*process\s*:\s*([^\s;]+)\s*;/ ) {
      ( $process ) =
        /^\s*process\s*:\s*([^\s;]+)\s*;/ ;
    }
    if( /^\s*temperature\s*:\s*([^\s;]+)\s*;/ ) {
      ( $temperature ) =
        /^\s*temperature\s*:\s*([^\s;]+)\s*;/ ;
    }
    if( /^\s*voltage\s*:\s*([^\s;]+)\s*;/ ) {
      ( $voltage ) =
        /^\s*voltage\s*:\s*([^\s;]+)\s*;/ ;
    }
    if( /^\s*leakage_power_unit\s*:\s*([^\s;]+)\s*;/ ) {
      ( $leakage_power_unit ) =
        /^\s*leakage_power_unit\s*:\s*([^\s;]+)\s*;/ ;
    }

    if( /^\s*cell\s*\(\s*([^\s\(\)]+)\s*\)/ ) {
      ( $cell ) = /^\s*cell\s*\(\s*([^\s\(\)]+)\s*\)/ ;
      $is_basic_cell{$cell} = 1 ;
      $cell_type{$cell} = "MEM" if( $cell =~ /^sp/ ) ;
      $cell_type{$cell} = "MEM" if( $cell =~ /^dp/ ) ;
      $cell_type{$cell} = "MEM" if( $cell =~ /^rom/ ) ;
      $cell_type{$cell} = "MEM" if( $cell =~ /^TS1N/ ) ;
      $cell_type{$cell} = "MEM" if( $cell =~ /^TS3N/ ) ;
      $cell_type{$cell} = "MEM" if( $cell =~ /^TS6N/ ) ;
      $cell_type{$cell} = "MEM" if( $cell =~ /^RAMSP/ ) ;
      $cell_type{$cell} = "MEM" if( $cell =~ /^tsn55lpll2prf_512x32m2s/ ) ;
    }
    if( /^\s*area\s*:\s*(\d+\.*\d*)\s*;/ ) {
      ( $cell_area{$cell} ) =
        /^\s*area\s*:\s*(\d+\.*\d*)\s*;/ ;
$cell_area{$cell} = 0 if( $cell =~ /^TIE/ ) ;
    }
    if( /^\s*cell_leakage_power\s*:\s*(\d+\.\d+)\s*;/ ) {
      ( $cell_leakage_power{$cell} ) = /^\s*cell_leakage_power\s*:\s*(\d+\.\d+)\s*;/ ;
     #print " $cell_leakage_power{$cell}\n" ;
      $cell_leakage_power{$cell} = $cell_leakage_power{$cell} * 1000 ;
     #print " $cell_leakage_power{$cell}\n" ;
	
    }

    if( /^\s*(\S+)\s*\(\s*\)/ ) {
      ( $section ) =
        /^\s*(\S+)\s*\(\s*\)/ ;
    }
    if( $section eq "leakage_power" ) {
      if( /^\s*value\s*:\s*(\d+\.*\d*)\s*/ ) {
        ( $leakage_power ) =
          /^\s*value\s*:\s*(\d+\.*\d*)\s*/ ;
        $cell_leakage_power{$cell} = $leakage_power if( $cell_leakage_power{$cell} eq "" ) ;
        $cell_leakage_power{$cell} = $leakage_power if( $cell_leakage_power{$cell} < $leakage_power ) ;
      }
    }

  }
  close( LIB ) ;
}

#foreach $cell ( sort( keys( %is_basic_cell ) ) ) {
#  printf( "%s %.3f\n", $cell, $cell_area{$cell} ) if( $cell_area{$cell} == 0 ) ;
#}

$/ = ";" ;

printf( "Checking file '%s'.\n", $ARGV[0] ) ;
printf( "  %s\n", $ARGV[0] ) ;
printf( "\n", $ARGV[0] ) ;

while( <> ) {
  if( /^\s*(\S+)\s+([^\s\(\)]+)\s*/ ) {
    ( $cell, $instance ) = /^\s*(\S+)\s+([^\s\(\)]+)\s*/ ;
    if( $is_basic_cell{$cell} == 1 ) {
next if( $cell =~ /^TIE/ ) ;
      $total_cell_count{"total"} ++ ;
      $total_cell_count{"HVT"} ++ if( $cell_type{$cell} eq "HVT" ) ;
      $total_cell_count{"NVT"} ++ if( $cell_type{$cell} eq "NVT" ) ;
      $total_cell_count{"LVT"} ++ if( $cell_type{$cell} eq "LVT" ) ;
      $total_cell_count{"MEM"} ++ if( $cell_type{$cell} eq "MEM" ) ;
      $total_cell_area{"total"} = $total_cell_area{"total"} + $cell_area{$cell} ;
      $total_cell_area{"HVT"} = $total_cell_area{"HVT"} + $cell_area{$cell} if( $cell_type{$cell} eq "HVT" ) ;
      $total_cell_area{"NVT"} = $total_cell_area{"NVT"} + $cell_area{$cell} if( $cell_type{$cell} eq "NVT" ) ;
      $total_cell_area{"LVT"} = $total_cell_area{"LVT"} + $cell_area{$cell} if( $cell_type{$cell} eq "LVT" ) ;
      $total_cell_area{"MEM"} = $total_cell_area{"MEM"} + $cell_area{$cell} if( $cell_type{$cell} eq "MEM" ) ;
      $total_cell_leakage_power{"total"} = $total_cell_leakage_power{"total"} + $cell_leakage_power{$cell} ;
      $total_cell_leakage_power{"HVT"} = $total_cell_leakage_power{"HVT"} + $cell_leakage_power{$cell} if( $cell_type{$cell} eq "HVT" ) ;
      $total_cell_leakage_power{"NVT"} = $total_cell_leakage_power{"NVT"} + $cell_leakage_power{$cell} if( $cell_type{$cell} eq "NVT" ) ;
      $total_cell_leakage_power{"LVT"} = $total_cell_leakage_power{"LVT"} + $cell_leakage_power{$cell} if( $cell_type{$cell} eq "LVT" ) ;
      $total_cell_leakage_power{"MEM"} = $total_cell_leakage_power{"MEM"} + $cell_leakage_power{$cell} if( $cell_type{$cell} eq "MEM" ) ;
    }
  }
}

#printf( "total_cell_count{\"total\"} = %s\n", $total_cell_count{"total"} ) ;
#printf( "total_cell_area{\"total\"} = %s\n", $total_cell_area{"total"} ) ;
#printf( "total_cell_leakage_power{\"total\"} = %s\n", $total_cell_leakage_power{"total"} ) ;

printf( "  Cell type        Count (%%)                Area (%%)         Leakage power (%%)\n" ) ;
printf( "  ----------  --------------------  ----------------------  ------------------------\n" ) ;

printf( "  HVT         %10d (%6.2f%%)  %12.3f (%6.2f%%)  %14.3f (%6.2f%%)\n",
  $total_cell_count{"HVT"}, $total_cell_count{"HVT"} / $total_cell_count{"total"} * 100,
  $total_cell_area{"HVT"}, $total_cell_area{"HVT"} / $total_cell_area{"total"} * 100,
  $total_cell_leakage_power{"HVT"}, $total_cell_leakage_power{"HVT"} / $total_cell_leakage_power{"total"} * 100 ) ;

printf( "  NVT         %10d (%6.2f%%)  %12.3f (%6.2f%%)  %14.3f (%6.2f%%)\n",
  $total_cell_count{"NVT"}, $total_cell_count{"NVT"} / $total_cell_count{"total"} * 100,
  $total_cell_area{"NVT"}, $total_cell_area{"NVT"} / $total_cell_area{"total"} * 100,
  $total_cell_leakage_power{"NVT"}, $total_cell_leakage_power{"NVT"} / $total_cell_leakage_power{"total"} * 100 ) ;

printf( "  LVT         %10d (%6.2f%%)  %12.3f (%6.2f%%)  %14.3f (%6.2f%%)\n",
  $total_cell_count{"LVT"}, $total_cell_count{"LVT"} / $total_cell_count{"total"} * 100,
  $total_cell_area{"LVT"}, $total_cell_area{"LVT"} / $total_cell_area{"total"} * 100,
  $total_cell_leakage_power{"LVT"}, $total_cell_leakage_power{"LVT"} / $total_cell_leakage_power{"total"} * 100 ) ;

printf( "  MEM         %10d (%6.2f%%)  %12.3f (%6.2f%%)  %14.3f (%6.2f%%)\n",
  $total_cell_count{"MEM"}, $total_cell_count{"MEM"} / $total_cell_count{"total"} * 100,
  $total_cell_area{"MEM"}, $total_cell_area{"MEM"} / $total_cell_area{"total"} * 100,
  $total_cell_leakage_power{"MEM"}, $total_cell_leakage_power{"MEM"} / $total_cell_leakage_power{"total"} * 100 ) ;

printf( "  ----------  --------------------  ----------------------  ------------------------\n" ) ;

printf( "  Total       %10d (%6.2f%%)  %12.3f (%6.2f%%)  %14.3f (%6.2f%%)\n",
  $total_cell_count{"total"}, $total_cell_count{"total"} / $total_cell_count{"total"} * 100,
  $total_cell_area{"total"}, $total_cell_area{"total"} / $total_cell_area{"total"} * 100,
  $total_cell_leakage_power{"total"}, $total_cell_leakage_power{"total"} / $total_cell_leakage_power{"total"} * 100 ) ;

printf( "\n" ) ;
printf( "  process : %s\n", $process ) ;
printf( "  temperature : %s\n", $temperature ) ;
printf( "  voltage : %s\n", $voltage ) ;
printf( "  leakage_power_unit : %s\n", $leakage_power_unit ) ;

