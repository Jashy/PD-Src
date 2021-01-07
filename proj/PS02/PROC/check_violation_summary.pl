#!/usr/bin/perl

$check_clock_network_delay = 1 ;
$check_stage_count = 0 ;
$check_block = 1 ;
$min_clock_paths_derating_factor = 1.0 ;
$max_clock_paths_derating_factor = 1.0 ;
$resolution = "medium" ;
$resolution = "high" ;
$resolution = "step" ;

while( <> ) {
  split ;

  ########################################################################
  # check header
  #
  if( /^\**\s*Report  *: [tT]iming/ ) {
    $is_report_timing = 1 ;
  }
  if( /^Report : constraint/ ) {
    $is_report_timing = 1 ;
  }
  if( /-path full_clock/ ) {
    $check_clock_network_delay = 0 ;
  }
  if( /-nets/ ) {
    $check_stage_count = 1 ;
  }
  if( /^\**\s*Design\s*:\s*(\S+)/ ) {
    ( $design ) = /^\**\s*Design\s*:\s*(\S+)/ ;
  }

  ########################################################################
  # check header
  #
  if( /^\**\s*(Path|Delay) Type: (min|max)/ ) {
    ( $dummy, $path_type ) = /^\**\s*(Path|Delay) Type: (min|max)/ ;
    if( $path_type eq "min" ) {
     #$resolution = "high" ;
    }
  }
  if( /Derating Factor/ ) {
    $is_timing_derate = 1 ;
  }
  if( /^\**\s*Min Clock Paths Derating Factor : (\S+)/ ) {
    ( $min_clock_paths_derating_factor ) = /^\**\s*Min Clock Paths Derating Factor : (\S+)/ ;
  }
  if( /^\**\s*Max Clock Paths Derating Factor : (\S+)/ ) {
    ( $max_clock_paths_derating_factor ) = /^\**\s*Max Clock Paths Derating Factor : (\S+)/ ;
  }

  ########################################################################
  # get startpoint (instance)
  #
  if( /^\**\s*(Start|Begin)point:\s+(\S+)/ ) {
    ( $dummy, $startpoint ) = /^\s*(Start|Begin)point:\s+(\S+)/ ;
    $startpoint_clock = "" ;
    $startpoint_clock_root_arrival = "" ;
    $startpoint_derating_clock_network_delay = "" ;
    $endpoint = "" ;
    $endpoint_clock = "" ;
    $endpoint_clock_root_arrival = "" ;
    $endpoint_derating_clock_network_delay = "" ;

    $is_data_path = 0 ;
    $stage_count = 0 ;

    $startpoint_pattern = $startpoint ;
    $startpoint_pattern =~ s/([\[\]])/\\$1/g ;

    $delay_cell_found = 0 ;
  }

  ########################################################################
  # get path path group
  #
  if( /^\**\s*Path Group:\s+(\S+)/ ) {
    ( $path_group ) = /^\s*Path Group:\s+(\S+)/ ;
  }

  ########################################################################
  # get clock
  #
  if( /^\s*clock (\S+) \((\S+ edge|re|fe)\)\s+(\d*\.*\d+)\s+/ ) {
    if( ( $startpoint_clock eq "" ) && ( $endpoint_clock eq "" ) ) {
      ( $startpoint_clock, $dummy, $startpoint_clock_root_arrival ) = /^\s*clock (\S+) \((\S+ edge|re|fe)\)\s+(\d*\.*\d+)\s+/ ;
    } elsif( ( $startpoint_clock ne "" ) && ( $endpoint_clock eq "" ) ) {
      ( $endpoint_clock, $dummy, $endpoint_clock_root_arrival ) = /^\s*clock (\S+) \((\S+ edge|re|fe)\)\s+(\d*\.*\d+)\s+/ ;
      $clock{$endponit} = $endpoint_clock ;
      $clock_root_arrival{$endpoint} = $endpoint_clock_root_arrival ;

      $clock_group = sprintf( "%s-->%s", $startpoint_clock, $endpoint_clock ) ;
      if( $worst_slack_per_clock_group{$clock_group} eq "" ) {
         $worst_slack_per_clock_group{$clock_group} = 999999 ;
      }
    }
  }

  ########################################################################
  # get clock network delay
  #
  if( /^\**\s*clock (network|tree) delay \(propagated|ideal\)\s+(\S+)\s+/ ) {
    if( $startpoint_derating_clock_network_delay eq "" ) {
#     ( $startpoint_derating_clock_network_delay ) = /^\**\s*clock (network|tree) delay \(propagated|ideal\)\s+(\S+)\s+/ ;
      $startpoint_derating_clock_network_delay = $_[4] ;
    } elsif( $endpoint_derating_clock_network_delay eq "" ) {
#     ( $endpoint_derating_clock_network_delay ) = /^\**\s*clock (network|tree) delay \(propagated|ideal\)\s+(\S+)\s+/ ;
      $endpoint_derating_clock_network_delay = $_[4] ;
    }
  }

  ########################################################################
  # check pin for startpoint and endpoint
  #
  if( /^\**\s*(\S+) \((\S+)\)\s*/ ) {
    unless( /^\**\s*(\S+) \(net\)\s*/ ) {
      ( $pin, $cell ) = /^\**\s*(\S+)\s+\((\S+)\)\s*/ ;
    }
  }

  ########################################################################
  # check delay for stage count (exclude hierarchical pin)
  #
  if( /\s+(\d*\.*\d+)\s+\**\s+(\d*\.*\d+)\s+(r|f|R|F)\s*/ ) {
    unless( / \(net\) / ) {
      ( $delay ) = /\s+(\d*\.*\d+)\s+\**\s+(\d*\.*\d+)\s+(r|f|R|F)\s*/ ;
    }
  }

  ########################################################################
  # get startpoint (pin)
  #
  if( $is_data_path == 0 ) {
    if( ( $pin eq $startpoint ) || ( $pin =~ /^($startpoint_pattern)\// ) ) {
      $startpoint = $pin ;
      $clock{$startpoint} = $startpoint_clock ;
      $clock_root_arrival{$startpoint} = $startpoint_clock_root_arrival ;
  
      $is_data_path = 1 ;
  
  ##### ONLY FOR CINNAMON #####
      if( $design eq "cinnamon" ) {
        if( $startpoint =~ /renoir_core_cwr\/renoir_core_cwr\/laputa_pvc_top_cwr\/LAPUTA_0\// ) {
          if( $startpoint =~ /renoir_core_cwr\/renoir_core_cwr\/laputa_pvc_top_cwr\/LAPUTA_0\/cpu\// ) {
            $startpoint_block = "CPU" ;
          } elsif( $startpoint =~ /renoir_core_cwr\/renoir_core_cwr\/laputa_pvc_top_cwr\/LAPUTA_0\/vpp\// ) {
            $startpoint_block = "VPP" ;
          } else {
            $startpoint_block = "LAPUTA" ;
          }
        } elsif( $startpoint =~ /renoir_core_cwr\/renoir_core_cwr\/ARM926EJS_TCM/ ) {
          $startpoint_block = "ARM" ;
        } else {
          if( $startpoint =~ /iocells_cwr_/ ) {
            $startpoint_block = "IO" ;
          } elsif( $startpoint =~ /renoir_core_cwr\/renoir_core_cwr\/tgbe3\// ) {
            $startpoint_block = "TGBE3" ;
          } elsif( $startpoint =~ /renoir_core_cwr\/renoir_core_cwr\/tgfe3\// ) {
            $startpoint_block = "TGFE3" ;
          } else {
            $startpoint_block = "TOP" ;
          }
        }
      } elsif( $design eq "LAPUTA" ) {
        if( $startpoint =~ /^cpu\// ) {
          $startpoint_block = "CPU" ;
        } elsif( $startpoint =~ /^vpp\// ) {
          $startpoint_block = "VPP" ;
        } else {
          $startpoint_block = "LAPUTA" ;
        }
  ##### ONLY FOR K2 #####
      } elsif( $design eq "d2962" ) {
        $startpoint_block = $startpoint ;
        if( $startpoint !~ /\// ) {
          $startpoint_block = "in" ;
        } else {
          $startpoint_block = "misc"             if( $startpoint_block !~ /^top\// ) ;
          $startpoint_block = "CPU_MEDIA"        if( $startpoint_block =~ /^top\/me\/mcpu\// ) ;
          $startpoint_block = "A1RING"           if( $startpoint_block =~ /^top\/me\/mavc\// ) ;
          $startpoint_block = "VETOP"            if( $startpoint_block =~ /^top\/me\/mvme\// ) ;
          $startpoint_block = "me_misc"          if( $startpoint_block =~ /^top\/me\/me_misc\// ) ;
          $startpoint_block = "me"               if( $startpoint_block =~ /^top\/me\// ) ;

          $startpoint_block = "aw_a"             if( $startpoint_block =~ /^top\/sc\/saw_a\// ) ;
          $startpoint_block = "CPU_MAIN"         if( $startpoint_block =~ /^top\/sc\/scpu\// ) ;
          $startpoint_block = "ATA_SPOCK"        if( $startpoint_block =~ /^top\/sc\/sata\// ) ;
          $startpoint_block = "KIRK"             if( $startpoint_block =~ /^top\/sc\/skirk\// ) ;
          $startpoint_block = "sc_misc"          if( $startpoint_block =~ /^top\/sc\/sc_misc\// ) ;
          $startpoint_block = "EMC_DDR"          if( $startpoint_block =~ /^top\/sc\/semc1\// ) ; # 090904
          $startpoint_block = "sc"               if( $startpoint_block =~ /^top\/sc\// ) ;

          $startpoint_block = "pb_misc"          if( $startpoint_block =~ /^top\/pb\/pb_misc\// ) ;
          $startpoint_block = "mib"              if( $startpoint_block =~ /^top\/pb\/pmib\// ) ;
          $startpoint_block = "pb"               if( $startpoint_block =~ /^top\/pb\// ) ;

          $startpoint_block = "TACOBCON"         if( $startpoint_block =~ /^top\/TACOBCON\d+\// ) ;
          $startpoint_block = "TACOTAPC"         if( $startpoint_block =~ /^top\/TACOTAPC\// ) ;
          $startpoint_block = "booter"           if( $startpoint_block =~ /^top\/booter\// ) ;
          $startpoint_block = "top/misc"         if( $startpoint_block =~ /^top\// ) ;
        }
  ##### ONLY FOR DJIN #####
      } elsif( $design eq "DJINIO" ) {
        if( $startpoint !~ /\// ) {
          $startpoint_block = "in" ;
        } elsif( $startpoint =~ /\/SC900DRM[^\/]+\/[^\/]+$/i ) {
          $startpoint_block = "DRAM" ;           
        } elsif( $startpoint =~ /\/LV[12]P[^\/]+\/[^\/]+$/ ) {
          $startpoint_block = "SRAM" ;
        } elsif( $startpoint =~ /FUSEBOX/ ) {
          $startpoint_block = "FUSEBOX" ;
        } elsif( $startpoint =~ /_collar\/[^\/]+_FLOP_reg/ ) {
          $startpoint_block = "MBIST" ;
        } elsif( $startpoint =~ /\/[^\/]+reg[^\/]*\/[^\/]+$/ ) {
          $startpoint_block = "DFF" ;
        } elsif( $startpoint eq "djin_0/dadc_0/sc900xapaa00_0/CLKPcheckpin1" ) {
          $startpoint_block = "ADC" ;
        } else { 
          $startpoint_block = "?" ;
        }
  ##### ONLY FOR XT3 #####
      } elsif( $design eq "xt30_top" ) {
        if( $startpoint !~ /\// ) {
          $startpoint_block = "**in**" ;
        } elsif( $startpoint =~ /^xt30_m\/vmem[0-3]\/[^\/]+$/ ) {
          $startpoint_block = "**vmem**" ;
        } elsif( $startpoint =~ /^xt30_m\/pipeline_Vector[0-7]\/[^\/]+$/ ) {
          $startpoint_block = "**pipeline_Vector**" ;
        } else {
          $startpoint_block = $startpoint ;
          $startpoint_block =~ s/^xt30_m\/// ;
          $startpoint_block =~ s/\/.*$// ;
        }
  ##### ONLY FOR Garnet #####
      } elsif( $design eq "pxlw_arm926_v1_top" ) {
        if( $startpoint !~ /\// ) {
          $startpoint_block = "**in**" ;
        } else {
          $startpoint_block = "pxlw_arm926_v1_top" ;
        }
      } elsif( $design eq "ruby_top" ) {
        if( $startpoint !~ /\// ) {
          $startpoint_block = "**in**" ;
        } elsif ( $startpoint =~ /^UUruby_dft\/ruby_core\/image_proc.*$/ ) {
          $startpoint_block = "image_proc" ;
        } elsif ( $startpoint =~ /^UUruby_dft\/ruby_core\/arm926.*$/ ) {
          $startpoint_block = "arm926" ;
        } elsif ( $startpoint =~ /^UUruby_dft\/ruby_core\/ddr2_ddr3\/uniquify_phy.*/) {
          $startpoint_block = "DDR";
        } elsif ( $startpoint =~ /^UUruby_dft\/ruby_core\/ddr2_ddr3\/bridge_ocp2uniquify.*$/ ) {
          $startpoint_block = "bridge_ocp2uniquify";
        } else {
          $startpoint_block = "ruby_top" ;
        }
  ##### DEFAULT #####
      } else {
        $startpoint_block = $startpoint ;
        if( $startpoint !~ /\// ) {
          $startpoint_block = "in" ;
        } else {
          $startpoint_block =~ s/\/.*$// ;
        }
      }
    }
  }

  ########################################################################
  # get endpoint (pin)
  #
  if( ( /^\**\s*data arrival time / ) && ( $endpoint eq "" ) ) {
    $endpoint = $pin ;

  ##### ONLY FOR CINNAMON #####
    if( $design eq "cinnamon" ) {
      if( $endpoint =~ /renoir_core_cwr\/renoir_core_cwr\/laputa_pvc_top_cwr\/LAPUTA_0\// ) {
        if( $endpoint =~ /renoir_core_cwr\/renoir_core_cwr\/laputa_pvc_top_cwr\/LAPUTA_0\/cpu\// ) {
          $endpoint_block = "CPU" ;
        } elsif( $endpoint =~ /renoir_core_cwr\/renoir_core_cwr\/laputa_pvc_top_cwr\/LAPUTA_0\/vpp\// ) {
          $endpoint_block = "VPP" ;
        } else {
          $endpoint_block = "LAPUTA" ;
        }
      } elsif( $endpoint =~ /renoir_core_cwr\/renoir_core_cwr\/ARM926EJS_TCM/ ) {
        $endpoint_block = "ARM" ;
      } else {
        if( $endpoint =~ /iocells_cwr_/ ) {
          $endpoint_block = "IO" ;
        } elsif( $endpoint =~ /renoir_core_cwr\/renoir_core_cwr\/tgbe3\// ) {
          $endpoint_block = "TGBE3" ;
        } elsif( $endpoint =~ /renoir_core_cwr\/renoir_core_cwr\/tgfe3\// ) {
          $endpoint_block = "TGFE3" ;
        } else {
          $endpoint_block = "TOP" ;
        }
      }
    } elsif( $design eq "LAPUTA" ) { 
      if( $endpoint =~ /^cpu\// ) {
        $endpoint_block = "CPU" ;
      } elsif( $endpoint =~ /^vpp\// ) {
        $endpoint_block = "VPP" ;
      } else {
        $endpoint_block = "LAPUTA" ;
      }
  ##### ONLY FOR K2 #####
    } elsif( $design eq "d2962" ) {
      $endpoint_block = $endpoint ;
      if( $endpoint !~ /\// ) {
        $endpoint_block = "out" ;
      } else {
        $endpoint_block = "misc"             if( $endpoint_block !~ /^top\// ) ;
        $endpoint_block = "CPU_MEDIA"        if( $endpoint_block =~ /^top\/me\/mcpu\// ) ;
        $endpoint_block = "A1RING"           if( $endpoint_block =~ /^top\/me\/mavc\// ) ;
        $endpoint_block = "VETOP"            if( $endpoint_block =~ /^top\/me\/mvme\// ) ;
        $endpoint_block = "me_misc"          if( $endpoint_block =~ /^top\/me\/me_misc\// ) ;
        $endpoint_block = "me"               if( $endpoint_block =~ /^top\/me\// ) ;

        $endpoint_block = "aw_a"             if( $endpoint_block =~ /^top\/sc\/saw_a\// ) ;
        $endpoint_block = "CPU_MAIN"         if( $endpoint_block =~ /^top\/sc\/scpu\// ) ;
        $endpoint_block = "ATA_SPOCK"        if( $endpoint_block =~ /^top\/sc\/sata\// ) ;
        $endpoint_block = "KIRK"             if( $endpoint_block =~ /^top\/sc\/skirk\// ) ;
        $endpoint_block = "sc_misc"          if( $endpoint_block =~ /^top\/sc\/sc_misc\// ) ;
        $endpoint_block = "EMC_DDR"          if( $endpoint_block =~ /^top\/sc\/semc1\// ) ; # 090904
        $endpoint_block = "sc"               if( $endpoint_block =~ /^top\/sc\// ) ;

        $endpoint_block = "pb_misc"          if( $endpoint_block =~ /^top\/pb\/pb_misc\// ) ;
        $endpoint_block = "mib"              if( $endpoint_block =~ /^top\/pb\/pmib\// ) ;
        $endpoint_block = "pb"               if( $endpoint_block =~ /^top\/pb\// ) ;

        $endpoint_block = "TACOBCON"         if( $endpoint_block =~ /^top\/TACOBCON\d+\// ) ;
        $endpoint_block = "TACOTAPC"         if( $endpoint_block =~ /^top\/TACOTAPC\// ) ;
        $endpoint_block = "booter"           if( $endpoint_block =~ /^top\/booter\// ) ;
        $endpoint_block = "top/misc"         if( $endpoint_block =~ /^top\// ) ;
      }
  ##### ONLY FOR DJIN #####
    } elsif( $design eq "DJINIO" ) {
      if( $endpoint !~ /\// ) {
        $endpoint_block = "out" ;
      } elsif( $endpoint =~ /\/SC900DRM[^\/]+\/[^\/]+$/i ) {
        $endpoint_block = "DRAM" ;
      } elsif( $endpoint =~ /\/LV[12]P[^\/]+\/[^\/]+$/ ) {
        $endpoint_block = "SRAM" ;
      } elsif( $endpoint =~ /FUSEBOX/ ) {
        $endpoint_block = "FUSEBOX" ;
      } elsif( $endpoint =~ /\/(CL|PR)$/ ) {
        $endpoint_block = "**async_default**" ;
      } elsif( $endpoint =~ /_clockgating_[^\/]+\/EN$/ ) {
        $endpoint_block = "CG(EN)" ;
      } elsif( $endpoint =~ /_clockgating_[^\/]+\/T$/ ) {
        $endpoint_block = "CG(T)" ;
      } elsif( $endpoint =~ /\/[^\/]+_CG\/EN$/ ) {
        $endpoint_block = "CG(EN)" ;
      } elsif( $endpoint =~ /\/[^\/]+_CG\/T$/ ) {
        $endpoint_block = "CG(T)" ;
      } elsif( $endpoint =~ /\/SE$/ ) {
        $endpoint_block = "DRAM(SE)" ;
      } elsif( $endpoint =~ /\/[^\/]+reg[^\/]*\/S$/ ) {
        $endpoint_block = "DFF(SE)" ;
      } elsif( $endpoint =~ /\/SPARECELL_DFF[0-9][0-9]\/S$/ ) {
        $endpoint_block = "DFF(SE)" ;
      } elsif( $endpoint =~ /\/SCAN_DUMMY[0-9][0-9]\/S$/ ) {
        $endpoint_block = "DFF(SE)" ;
      } elsif( $endpoint =~ /\/[^\/]+reg[^\/]*\/SI$/ ) {
        $endpoint_block = "DFF(SI)" ;
      } elsif( $endpoint =~ /_collar\/[^\/]+_FLOP_reg/ ) {
        $endpoint_block = "DFF(MBIST)" ;
      } elsif( $endpoint =~ /\/[^\/]+reg[^\/]*\/EN$/ ) {
        $endpoint_block = "DFF(EN)" ;
      } elsif( $endpoint =~ /\/[^\/]+reg[^\/]*\/D$/ ) {
        $endpoint_block = "DFF" ;
      } else {
        $endpoint_block = "?" ;
      }
  ##### ONLY FOR XT3 #####
      } elsif( $design eq "xt30_top" ) {
        if( $endpoint !~ /\// ) {
          $endpoint_block = "**out**" ;
        } elsif( $endpoint =~ /^xt30_m\/vmem[0-3]\/[^\/]+$/ ) {
          $endpoint_block = "**vmem**" ;
        } elsif( $endpoint =~ /^xt30_m\/pipeline_Vector[0-7]\/[^\/]+$/ ) {
          $endpoint_block = "**pipeline_Vector**" ;
        } else {
          $endpoint_block = $endpoint ;
          $endpoint_block =~ s/^xt30_m\/// ;
          $endpoint_block =~ s/\/.*$// ;
        }
  ##### ONLY FOR Garnet #####
      } elsif( $design eq "pxlw_arm926_v1_top" ) {
        if( $endpoint !~ /\// ) {
          $endpoint_block = "**out**" ;
        } else {
          $endpoint_block = "pxlw_arm926_v1_top" ;
        }
      } elsif( $design eq "ruby_top" ) {
        if( $endpoint !~ /\// ) {
          $endpoint_block = "**out**" ;
        } elsif( $endpoint =~ /^UUruby_dft\/ruby_core\/image_proc.*$/ ) {
          $endpoint_block = "image_proc" ;
        } elsif( $endpoint =~ /^UUruby_dft\/ruby_core\/arm926.*$/ ) {
          $endpoint_block = "arm926" ;
        } elsif ( $endpoint =~ /^UUruby_dft\/ruby_core\/ddr2_ddr3\/uniquify_phy.*/ ) {
          $endpoint_block = "DDR";
        } elsif ( $endpoint =~ /^UUruby_dft\/ruby_core\/ddr2_ddr3\/bridge_ocp2uniquify.*$/ ) {
          $endpoint_block = "bridge_ocp2uniquify";
        } else {
          $endpoint_block = "ruby_top" ;
        }
  ##### DEFAULT #####
    } else {
      $endpoint_block = $endpoint ;
      if( $endpoint !~ /\// ) {
        $endpoint_block = "out" ;
      } else {
        $endpoint_block =~ s/\/.*$// ;
      } 
    }

    $block = sprintf( "%s-->%s", $startpoint_block, $endpoint_block ) ;
    if( $worst_slack{$block} eq "" ) {
      $worst_slack{$block} = 999999 ;
    }
  }

  ########################################################################
  # count stage
  #
  if( $check_stage_count == 1 ) {
    if( $is_data_path == 1 ) {
      if( ( / \(net\) / ) && ( $delay > 0.0 ) ) {
        $stage_count++ ;
      }
      if( /^\s*data arrival time / ) {
        $is_data_path = 0 ;
      }
    }
  }

  ########################################################################
  # check delay cells
  #
  if( $path_type eq "max" ) {
    if( $design eq "cinnamon" ) {
      if( /^\s+(\S+)\s+\(SU[NH]_DEL_R\d+_\d+\)\s+/ ) {
        $delay_cell_found = 1 ;
      }
    }
  }

  ########################################################################
  # check slack
  #
  if( /^\**\s*slack \((\S*).*\)/ ) {
    ( $slack ) = /slack \(\S+\)\s+(\S+)/ ;

    if( ( $path_slack{$startpoint,$endpoint} eq "" ) || ( $slack != $path_slack{$startpoint,$endpoint} ) ) {

      ##### check slack range #####
      if( $resolution eq "high" ) {
        if(      ( $slack <=  0.000 ) && ( $slack > -0.010 ) ) {
          $violation_count_per_range{"0000_0010"}++ ;
        } elsif( ( $slack <= -0.010 ) && ( $slack > -0.020 ) ) {
          $violation_count_per_range{"0010_0020"}++ ;
        } elsif( ( $slack <= -0.020 ) && ( $slack > -0.030 ) ) {
          $violation_count_per_range{"0020_0030"}++ ;
        } elsif( ( $slack <= -0.030 ) && ( $slack > -0.040 ) ) {
          $violation_count_per_range{"0030_0040"}++ ;
        } elsif( ( $slack <= -0.040 ) && ( $slack > -0.050 ) ) {
          $violation_count_per_range{"0040_0050"}++ ;
        } elsif( ( $slack <= -0.050 ) && ( $slack > -0.060 ) ) {
          $violation_count_per_range{"0050_0060"}++ ;
        } elsif( ( $slack <= -0.060 ) && ( $slack > -0.070 ) ) {
          $violation_count_per_range{"0060_0070"}++ ;
        } elsif( ( $slack <= -0.070 ) && ( $slack > -0.080 ) ) {
          $violation_count_per_range{"0070_0080"}++ ;
        } elsif( ( $slack <= -0.080 ) && ( $slack > -0.090 ) ) {
          $violation_count_per_range{"0080_0090"}++ ;
        } elsif( ( $slack <= -0.090 ) && ( $slack > -0.100 ) ) {
          $violation_count_per_range{"0090_0100"}++ ;
        } elsif( ( $slack <= -0.100 ) && ( $slack > -0.110 ) ) {
          $violation_count_per_range{"0100_0110"}++ ;
        } elsif( ( $slack <= -0.110 ) && ( $slack > -0.120 ) ) {
          $violation_count_per_range{"0110_0120"}++ ;
        } elsif( ( $slack <= -0.120 ) && ( $slack > -0.130 ) ) {
          $violation_count_per_range{"0120_0130"}++ ;
        } elsif( ( $slack <= -0.130 ) && ( $slack > -0.140 ) ) {
          $violation_count_per_range{"0130_0140"}++ ;
        } elsif( ( $slack <= -0.140 ) && ( $slack > -0.150 ) ) {
          $violation_count_per_range{"0140_0150"}++ ;
        } elsif( ( $slack <= -0.150 ) && ( $slack > -0.160 ) ) {
          $violation_count_per_range{"0150_0160"}++ ;
        } elsif( ( $slack <= -0.160 ) && ( $slack > -0.170 ) ) {
          $violation_count_per_range{"0160_0170"}++ ;
        } elsif( ( $slack <= -0.170 ) && ( $slack > -0.180 ) ) {
          $violation_count_per_range{"0170_0180"}++ ;
        } elsif( ( $slack <= -0.180 ) && ( $slack > -0.190 ) ) {
          $violation_count_per_range{"0180_0190"}++ ;
        } elsif( ( $slack <= -0.190 ) && ( $slack > -0.200 ) ) {
          $violation_count_per_range{"0190_0200"}++ ;
        } elsif( ( $slack <= -0.200 ) && ( $slack > -0.300 ) ) {
          $violation_count_per_range{"0200_0300"}++ ;
        } elsif( ( $slack <= -0.300 ) && ( $slack > -0.400 ) ) {
          $violation_count_per_range{"0300_0400"}++ ;
        } elsif( ( $slack <= -0.400 ) && ( $slack > -0.500 ) ) {
          $violation_count_per_range{"0400_0500"}++ ;
        } elsif( ( $slack <= -0.500 ) && ( $slack > -1.000 ) ) {
          $violation_count_per_range{"0500_1000"}++ ;
        } elsif( ( $slack <= -1.000 ) && ( $slack > -2.000 ) ) {
          $violation_count_per_range{"1000_2000"}++ ;
        } elsif( ( $slack <= -2.000 ) && ( $slack > -5.000 ) ) {
          $violation_count_per_range{"2000_5000"}++ ;
        } elsif( ( $slack <= -5.000 ) ) {
          $violation_count_per_range{"5000_"}++ ;
        }
      } elsif ( $resolution eq "step" ) {
        if(      ( $slack <=  0.000 ) && ( $slack > -0.050 ) ) {
          $violation_count_per_range{"0000_0050"}++ ;
        } elsif( ( $slack <= -0.050 ) && ( $slack > -0.100 ) ) {
          $violation_count_per_range{"0050_0100"}++ ;
        } elsif( ( $slack <= -0.100 ) && ( $slack > -0.150 ) ) {
          $violation_count_per_range{"0100_0150"}++ ;
        } elsif( ( $slack <= -0.150 ) && ( $slack > -0.200 ) ) {
          $violation_count_per_range{"0150_0200"}++ ;
        } elsif( ( $slack <= -0.200 ) && ( $slack > -0.250 ) ) {
          $violation_count_per_range{"0200_0250"}++ ;
        } elsif( ( $slack <= -0.250 ) && ( $slack > -0.300 ) ) {
          $violation_count_per_range{"0250_0300"}++ ;
        } elsif( ( $slack <= -0.300 ) && ( $slack > -0.350 ) ) {
          $violation_count_per_range{"0300_0350"}++ ;
        } elsif( ( $slack <= -0.350 ) && ( $slack > -0.400 ) ) {
          $violation_count_per_range{"0350_0400"}++ ;
        } elsif( ( $slack <= -0.400 ) && ( $slack > -0.450 ) ) {
          $violation_count_per_range{"0400_0450"}++ ;
        } elsif( ( $slack <= -0.450 ) && ( $slack > -0.500 ) ) {
          $violation_count_per_range{"0450_0500"}++ ;
        } elsif( ( $slack <= -0.5 ) && ( $slack > -1.0 ) ) {
          $violation_count_per_range{"0500_1000"}++ ;
        } elsif( ( $slack <= -1.0 ) && ( $slack > -2.0 ) ) {
          $violation_count_per_range{"1000_2000"}++ ;
        } elsif( ( $slack <= -2.0 ) && ( $slack > -5.0 ) ) {
          $violation_count_per_range{"2000_5000"}++ ;
        } elsif( ( $slack <= -5.0 ) ) {
          $violation_count_per_range{"5000_"}++ ;
        }
      } else {
        if(      ( $slack <=  0.0 ) && ( $slack > -0.1 ) ) {
          $violation_count_per_range{"0000_0100"}++ ;
        } elsif( ( $slack <= -0.1 ) && ( $slack > -0.2 ) ) {
          $violation_count_per_range{"0100_0200"}++ ;
        } elsif( ( $slack <= -0.2 ) && ( $slack > -0.5 ) ) {
          $violation_count_per_range{"0200_0500"}++ ;
        } elsif( ( $slack <= -0.5 ) && ( $slack > -1.0 ) ) {
          $violation_count_per_range{"0500_1000"}++ ;
        } elsif( ( $slack <= -1.0 ) && ( $slack > -2.0 ) ) {
          $violation_count_per_range{"1000_2000"}++ ;
        } elsif( ( $slack <= -2.0 ) && ( $slack > -5.0 ) ) {
          $violation_count_per_range{"2000_5000"}++ ;
        } elsif( ( $slack <= -5.0 ) ) {
          $violation_count_per_range{"5000_"}++ ;
        }
      }
      if( $slack <= 0.0 ) {
        $violation_count_per_range{total}++ ;
      }
      if( $worst_slack{total} eq "" ) {
        $worst_slack{total} = $slack ;
      } elsif( $slack < $worst_slack{total} ) {
        $worst_slack{total} = $slack ;
      }
  
      ##### check path group #####
      if( $slack <= 0.0 ) {
        $violation_count_per_path_group{$path_group}++ ;
        $violation_count_per_path_group{total}++ ;
      }
      if( $slack < $worst_slack_per_path_group{$path_group} ) {
        $worst_slack_per_path_group{$path_group} = $slack ;
        if( $slack < $worst_slack_per_path_group{total} ) {
          $worst_slack_per_path_group{total} = $slack ;
        }
      }
  
      ##### check clock group #####
      if( $slack <= 0.0 ) {
        $violation_count_per_clock_group{$clock_group}++ ;
        $violation_count_per_clock_group{total}++ ;
      }
      if( $slack < $worst_slack_per_clock_group{$clock_group} ) {
        $worst_slack_per_clock_group{$clock_group} = $slack ;
        if( $slack < $worst_slack_per_clock_group{total} ) {
          $worst_slack_per_clock_group{total} = $slack ;
        }
      }
  
      ##### check block #####
      if( $check_block == 1 ) {
        if( $slack <= 0.0 ) {
          $violation_count_per_block{$block}++ ;
          $violation_count_per_block{total}++ ;
        }
        if( $slack < $worst_slack_per_block{$block} ) {
          $worst_slack_per_block{$block} = $slack ;
          if( $slack < $worst_slack_per_block{total} ) {
            $worst_slack_per_block{total} = $slack ;
          }
        }
      }
  
      ##### check stage count #####
      if( $check_stage_count == 1 ) {
        $path_stage_count{$startpoint,$endpoint} = $stage_count ;
        if( $endpoint_stage_count{$endpoint} eq "" ) {
          $endpoint_stage_count{$endpoint} = $stage_count ;
        } elsif( $stage_count > $endpoint_stage_count{$endpoint} )  {
          $endpoint_stage_count{$endpoint} = $stage_count ;
        }
        if( $startpoint_stage_count{$startpoint} eq "" ) {
          $startpoint_stage_count{$startpoint} = $stage_count ;
        } elsif( $stage_count > $startpoint_stage_count{$startpoint} ) {
          $startpoint_stage_count{$startpoint} = $stage_count ;
        }
        if( $slack <= 0.0 ) {
          $violation_count_per_stage_count{$stage_count}++ ;
          $violation_count_per_stage_count{total}++ ;
        }
      }
  
      ##### check skew range #####
      if( $check_clock_network_delay == 1 ) {
  
        ##### check derating skew range #####
  
        $derating_clock_network_delay{$startpoint} = $startpoint_derating_clock_network_delay ;
        $derating_clock_network_delay{$endpoint} = $endpoint_derating_clock_network_delay ;
  
        $derating_skew = $derating_clock_network_delay{$endpoint} - $derating_clock_network_delay{$startpoint} ;
        if( $slack <= 0.0 ) {
          if(                                    ( $derating_skew < -5.0 ) ) {
            $violation_count_per_derating_skew_range{"_N5000"}++ ;
          } elsif( ( $derating_skew >= -5.0 ) && ( $derating_skew < -2.0 ) ) {
            $violation_count_per_derating_skew_range{"N5000_N2000"}++ ;
          } elsif( ( $derating_skew >= -2.0 ) && ( $derating_skew < -1.0 ) ) {
            $violation_count_per_derating_skew_range{"N2000_N1000"}++ ;
          } elsif( ( $derating_skew >= -1.0 ) && ( $derating_skew < -0.5 ) ) {
            $violation_count_per_derating_skew_range{"N1000_N0500"}++ ;
          } elsif( ( $derating_skew >= -0.5 ) && ( $derating_skew < -0.2 ) ) {
            $violation_count_per_derating_skew_range{"N0500_N0200"}++ ;
          } elsif( ( $derating_skew >= -0.2 ) && ( $derating_skew < -0.1 ) ) {
            $violation_count_per_derating_skew_range{"N0200_N0100"}++ ;
          } elsif( ( $derating_skew >= -0.1 ) && ( $derating_skew <  0.0 ) ) {
            $violation_count_per_derating_skew_range{"N0100_N0000"}++ ;
          } elsif( ( $derating_skew >=  0.0 ) && ( $derating_skew <  0.1 ) ) {
            $violation_count_per_derating_skew_range{"P0000_P0100"}++ ;
          } elsif( ( $derating_skew >=  0.1 ) && ( $derating_skew <  0.2 ) ) {
            $violation_count_per_derating_skew_range{"P0100_P0200"}++ ;
          } elsif( ( $derating_skew >=  0.2 ) && ( $derating_skew <  0.5 ) ) {
            $violation_count_per_derating_skew_range{"P0200_P0500"}++ ;
          } elsif( ( $derating_skew >=  0.5 ) && ( $derating_skew <  1.0 ) ) {
            $violation_count_per_derating_skew_range{"P0500_P1000"}++ ;
          } elsif( ( $derating_skew >=  1.0 ) && ( $derating_skew <  2.0 ) ) {
            $violation_count_per_derating_skew_range{"P1000_P2000"}++ ;
          } elsif( ( $derating_skew >=  2.0 ) && ( $derating_skew <  5.0 ) ) {
            $violation_count_per_derating_skew_range{"P2000_P5000"}++ ;
          } elsif( ( $derating_skew >=  5.0 ) ) {
            $violation_count_per_derating_skew_range{"P5000_"}++ ;
          }
  
          $violation_count_per_derating_skew_range{total}++ ;
        }
  
        ##### check original skew range #####
  
        if( $path_type eq "min" ) {
          $original_clock_network_delay{$startpoint} = $derating_clock_network_delay{$startpoint} / $min_clock_paths_derating_factor ;
        } else {
          $original_clock_network_delay{$startpoint} = $derating_clock_network_delay{$startpoint} / $max_clock_paths_derating_factor ;
        }
        if( $path_type eq "min" ) {
          $original_clock_network_delay{$endpoint} = $derating_clock_network_delay{$endpoint} / $max_clock_paths_derating_factor ;
        } else {
          $original_clock_network_delay{$endpoint} = $derating_clock_network_delay{$endpoint} / $min_clock_paths_derating_factor ;
        }
  
        $original_skew = $original_clock_network_delay{$endpoint} - $original_clock_network_delay{$startpoint} ;
        if( $slack <= 0.0 ) {
          if(                                    ( $original_skew < -5.0 ) ) {
            $violation_count_per_original_skew_range{"_N5000"}++ ;
          } elsif( ( $original_skew >= -5.0 ) && ( $original_skew < -2.0 ) ) {
            $violation_count_per_original_skew_range{"N5000_N2000"}++ ;
          } elsif( ( $original_skew >= -2.0 ) && ( $original_skew < -1.0 ) ) {
            $violation_count_per_original_skew_range{"N2000_N1000"}++ ;
          } elsif( ( $original_skew >= -1.0 ) && ( $original_skew < -0.5 ) ) {
            $violation_count_per_original_skew_range{"N1000_N0500"}++ ;
          } elsif( ( $original_skew >= -0.5 ) && ( $original_skew < -0.2 ) ) {
            $violation_count_per_original_skew_range{"N0500_N0200"}++ ;
          } elsif( ( $original_skew >= -0.2 ) && ( $original_skew < -0.1 ) ) {
            $violation_count_per_original_skew_range{"N0200_N0100"}++ ;
          } elsif( ( $original_skew >= -0.1 ) && ( $original_skew <  0.0 ) ) {
            $violation_count_per_original_skew_range{"N0100_N0000"}++ ;
          } elsif( ( $original_skew >=  0.0 ) && ( $original_skew <  0.1 ) ) {
            $violation_count_per_original_skew_range{"P0000_P0100"}++ ;
          } elsif( ( $original_skew >=  0.1 ) && ( $original_skew <  0.2 ) ) {
            $violation_count_per_original_skew_range{"P0100_P0200"}++ ;
          } elsif( ( $original_skew >=  0.2 ) && ( $original_skew <  0.5 ) ) {
            $violation_count_per_original_skew_range{"P0200_P0500"}++ ;
          } elsif( ( $original_skew >=  0.5 ) && ( $original_skew <  1.0 ) ) {
            $violation_count_per_original_skew_range{"P0500_P1000"}++ ;
          } elsif( ( $original_skew >=  1.0 ) && ( $original_skew <  2.0 ) ) {
            $violation_count_per_original_skew_range{"P1000_P2000"}++ ;
          } elsif( ( $original_skew >=  2.0 ) && ( $original_skew <  5.0 ) ) {
            $violation_count_per_original_skew_range{"P2000_P5000"}++ ;
          } elsif( ( $original_skew >=  5.0 ) ) {
            $violation_count_per_original_skew_range{"P5000_"}++ ;
          }
  
          $violation_count_per_original_skew_range{total}++ ;
        }
      }
  
      ##### check endpoints #####
      $clock{$startpoint} = $startpoint_clock ;
      $clock_root_arrival{$startpoint} = $startpoint_clock_root_arrival ;
      $clock{$endpoint} = $endpoint_clock ;
      $clock_root_arrival{$endpoint} = $endpoint_clock_root_arrival ;
  
      ##### check endpoints #####
      $endpoints_per_startpoint{$startpoint} = $endpoints_per_startpoint{$startpoint} . " " . $endpoint ;
      $path_slack{$startpoint,$endpoint} = $slack ;
      if( $endpoint_worst_slack{$endpoint} eq "" ) {
        $endpoint_worst_slack{$endpoint} = $slack ;
      } elsif( $slack < $endpoint_worst_slack{$endpoint} ) {
        $endpoint_worst_slack{$endpoint} = $slack ;
      }
      if( $startpoint_worst_slack{$startpoint} eq "" ) {
        $startpoint_worst_slack{$startpoint} = $slack ;
      } elsif( $slack < $startpoint_worst_slack{$startpoint} ) {
        $startpoint_worst_slack{$startpoint} = $slack ;
      }
  
      ##### check delay cell #####
      if( $path_type eq "max" ) {
        if( $delay_cell_found == 1 ) {
          $delay_cell_exist{$startpoint,$endpoint} = 1 ;
        }
      }

    }
  }
}

########################################################################
# check if timing report is correct
#
if( $is_report_timing != 1 ) {
  die( "Error: incomplete timing report.\n" ) ;
}

########################################################################
# print violations per range
#
if( $resolution eq "high" ) {
printf( "\n" ) ;
printf( " %-30s  %20s\n", "violation range", "# of violations" ) ;
printf( " %-30s  %20s\n", "------------------------------", "--------------------" ) ;
printf( " %-30s  %20d\n", "-0.000ns < -0.010ns", $violation_count_per_range{"0000_0010"} ) ;
printf( " %-30s  %20d\n", "-0.010ns < -0.020ns", $violation_count_per_range{"0010_0020"} ) ;
printf( " %-30s  %20d\n", "-0.020ns < -0.030ns", $violation_count_per_range{"0020_0030"} ) ;
printf( " %-30s  %20d\n", "-0.030ns < -0.040ns", $violation_count_per_range{"0030_0040"} ) ;
printf( " %-30s  %20d\n", "-0.040ns < -0.050ns", $violation_count_per_range{"0040_0050"} ) ;
printf( " %-30s  %20d\n", "-0.050ns < -0.060ns", $violation_count_per_range{"0050_0060"} ) ;
printf( " %-30s  %20d\n", "-0.060ns < -0.070ns", $violation_count_per_range{"0060_0070"} ) ;
printf( " %-30s  %20d\n", "-0.070ns < -0.080ns", $violation_count_per_range{"0070_0080"} ) ;
printf( " %-30s  %20d\n", "-0.080ns < -0.090ns", $violation_count_per_range{"0080_0090"} ) ;
printf( " %-30s  %20d\n", "-0.090ns < -0.100ns", $violation_count_per_range{"0090_0100"} ) ;
printf( " %-30s  %20d\n", "-0.100ns < -0.110ns", $violation_count_per_range{"0100_0110"} ) ;
printf( " %-30s  %20d\n", "-0.110ns < -0.120ns", $violation_count_per_range{"0110_0120"} ) ;
printf( " %-30s  %20d\n", "-0.120ns < -0.130ns", $violation_count_per_range{"0120_0130"} ) ;
printf( " %-30s  %20d\n", "-0.130ns < -0.140ns", $violation_count_per_range{"0130_0140"} ) ;
printf( " %-30s  %20d\n", "-0.140ns < -0.150ns", $violation_count_per_range{"0140_0150"} ) ;
printf( " %-30s  %20d\n", "-0.150ns < -0.160ns", $violation_count_per_range{"0150_0160"} ) ;
printf( " %-30s  %20d\n", "-0.160ns < -0.170ns", $violation_count_per_range{"0160_0170"} ) ;
printf( " %-30s  %20d\n", "-0.170ns < -0.180ns", $violation_count_per_range{"0170_0180"} ) ;
printf( " %-30s  %20d\n", "-0.180ns < -0.190ns", $violation_count_per_range{"0180_0190"} ) ;
printf( " %-30s  %20d\n", "-0.190ns < -0.200ns", $violation_count_per_range{"0190_0200"} ) ;
printf( " %-30s  %20d\n", "-0.200ns < -0.300ns", $violation_count_per_range{"0200_0300"} ) ;
printf( " %-30s  %20d\n", "-0.300ns < -0.400ns", $violation_count_per_range{"0300_0400"} ) ;
printf( " %-30s  %20d\n", "-0.400ns < -0.500ns", $violation_count_per_range{"0400_0500"} ) ;
printf( " %-30s  %20d\n", "-0.500ns < -1.000ns", $violation_count_per_range{"0500_1000"} ) ;
printf( " %-30s  %20d\n", "-1.000ns < -2.000ns", $violation_count_per_range{"1000_2000"} ) ;
printf( " %-30s  %20d\n", "-2.000ns < -5.000ns", $violation_count_per_range{"2000_5000"} ) ;
printf( " %-30s  %20d\n", "-5.000ns <         ", $violation_count_per_range{"5000_"} ) ;
printf( " %-30s  %20s\n", "------------------------------", "--------------------" ) ;
printf( " %-30s  %20d\n", "total              ", $violation_count_per_range{total} ) ;
} elsif ( $resolution eq "step" ) {
printf( "\n" ) ;
printf( " %-30s  %20s\n", "violation range", "# of violations" ) ;
printf( " %-30s  %20s\n", "------------------------------", "--------------------" ) ;
printf( " %-30s  %20d\n", "-0.000ns < -0.050ns", $violation_count_per_range{"0000_0050"} ) ;
printf( " %-30s  %20d\n", "-0.050ns < -0.100ns", $violation_count_per_range{"0050_0100"} ) ;
printf( " %-30s  %20d\n", "-0.100ns < -0.150ns", $violation_count_per_range{"0100_0150"} ) ;
printf( " %-30s  %20d\n", "-0.150ns < -0.200ns", $violation_count_per_range{"0150_0200"} ) ;
printf( " %-30s  %20d\n", "-0.200ns < -0.250ns", $violation_count_per_range{"0200_0250"} ) ;
printf( " %-30s  %20d\n", "-0.250ns < -0.300ns", $violation_count_per_range{"0250_0300"} ) ;
printf( " %-30s  %20d\n", "-0.300ns < -0.350ns", $violation_count_per_range{"0300_0350"} ) ;
printf( " %-30s  %20d\n", "-0.350ns < -0.400ns", $violation_count_per_range{"0350_0400"} ) ;
printf( " %-30s  %20d\n", "-0.400ns < -0.450ns", $violation_count_per_range{"0400_0450"} ) ;
printf( " %-30s  %20d\n", "-0.450ns < -0.500ns", $violation_count_per_range{"0450_0500"} ) ;
printf( " %-30s  %20d\n", "-0.500ns < -1.000ns", $violation_count_per_range{"0500_1000"} ) ;
printf( " %-30s  %20d\n", "-1.000ns < -2.000ns", $violation_count_per_range{"1000_2000"} ) ;
printf( " %-30s  %20d\n", "-2.000ns < -5.000ns", $violation_count_per_range{"2000_5000"} ) ;
printf( " %-30s  %20d\n", "-5.000ns <         ", $violation_count_per_range{"5000_"} ) ;
printf( " %-30s  %20s\n", "------------------------------", "--------------------" ) ;
printf( " %-30s  %20d\n", "total              ", $violation_count_per_range{total} ) ;
} else {
printf( "\n" ) ;
printf( " %-30s  %20s\n", "violation range", "# of violations" ) ;
printf( " %-30s  %20s\n", "------------------------------", "--------------------" ) ;
printf( " %-30s  %20d\n", "-0.0ns < -0.1ns", $violation_count_per_range{"0000_0100"} ) ;
printf( " %-30s  %20d\n", "-0.1ns < -0.2ns", $violation_count_per_range{"0100_0200"} ) ;
printf( " %-30s  %20d\n", "-0.2ns < -0.5ns", $violation_count_per_range{"0200_0500"} ) ;
printf( " %-30s  %20d\n", "-0.5ns < -1.0ns", $violation_count_per_range{"0500_1000"} ) ;
printf( " %-30s  %20d\n", "-1.0ns < -2.0ns", $violation_count_per_range{"1000_2000"} ) ;
printf( " %-30s  %20d\n", "-2.0ns < -5.0ns", $violation_count_per_range{"2000_5000"} ) ;
printf( " %-30s  %20d\n", "-5.0ns <       ", $violation_count_per_range{"5000_"} ) ;
printf( " %-30s  %20s\n", "------------------------------", "--------------------" ) ;
printf( " %-30s  %20d\n", "total          ", $violation_count_per_range{total} ) ;
}
#if( $violation_count_per_range{total} == 0 ) {
#  exit ;
#}

########################################################################
# print violations per derating skew range
#
if( $check_clock_network_delay == 1 ) {
if( $is_timing_derate == 1 ) {
printf( "\n" ) ;
printf( " %-30s  %20s\n", "derating skew range", "# of violations" ) ;
printf( " %-30s  %20s\n", "------------------------------", "--------------------" ) ;
printf( " %-30s  %20d\n", "       < -5.0ns", $violation_count_per_derating_skew_range{"_N5000"} ) ;
printf( " %-30s  %20d\n", "-5.0ns < -2.0ns", $violation_count_per_derating_skew_range{"N5000_N2000"} ) ;
printf( " %-30s  %20d\n", "-2.0ns < -1.0ns", $violation_count_per_derating_skew_range{"N2000_N1000"} ) ;
printf( " %-30s  %20d\n", "-1.0ns < -0.5ns", $violation_count_per_derating_skew_range{"N1000_N0500"} ) ;
printf( " %-30s  %20d\n", "-0.5ns < -0.2ns", $violation_count_per_derating_skew_range{"N0500_N0200"} ) ;
printf( " %-30s  %20d\n", "-0.2ns < -0.1ns", $violation_count_per_derating_skew_range{"N0200_N0100"} ) ;
printf( " %-30s  %20d\n", "-0.1ns <  0.0ns", $violation_count_per_derating_skew_range{"N0100_N0000"} ) ;
printf( " %-30s  %20d\n", " 0.0ns < +0.1ns", $violation_count_per_derating_skew_range{"P0000_P0100"} ) ;
printf( " %-30s  %20d\n", "+0.1ns < +0.2ns", $violation_count_per_derating_skew_range{"P0100_P0200"} ) ;
printf( " %-30s  %20d\n", "+0.2ns < +0.5ns", $violation_count_per_derating_skew_range{"P0200_P0500"} ) ;
printf( " %-30s  %20d\n", "+0.5ns < +1.0ns", $violation_count_per_derating_skew_range{"P0500_P1000"} ) ;
printf( " %-30s  %20d\n", "+1.0ns < +2.0ns", $violation_count_per_derating_skew_range{"P1000_P2000"} ) ;
printf( " %-30s  %20d\n", "+2.0ns < +5.0ns", $violation_count_per_derating_skew_range{"P2000_P5000"} ) ;
printf( " %-30s  %20d\n", "+5.0ns <       ", $violation_count_per_derating_skew_range{"P5000_"} ) ;
printf( " %-30s  %20s\n", "------------------------------", "--------------------" ) ;
printf( " %-30s  %20d\n", "total          ", $violation_count_per_derating_skew_range{total} ) ;
}

printf( "\n" ) ;
printf( " %-30s  %20s\n", "original skew range", "# of violations" ) ;
printf( " %-30s  %20s\n", "------------------------------", "--------------------" ) ;
printf( " %-30s  %20d\n", "       < -5.0ns", $violation_count_per_original_skew_range{"_N5000"} ) ;
printf( " %-30s  %20d\n", "-5.0ns < -2.0ns", $violation_count_per_original_skew_range{"N5000_N2000"} ) ;
printf( " %-30s  %20d\n", "-2.0ns < -1.0ns", $violation_count_per_original_skew_range{"N2000_N1000"} ) ;
printf( " %-30s  %20d\n", "-1.0ns < -0.5ns", $violation_count_per_original_skew_range{"N1000_N0500"} ) ;
printf( " %-30s  %20d\n", "-0.5ns < -0.2ns", $violation_count_per_original_skew_range{"N0500_N0200"} ) ;
printf( " %-30s  %20d\n", "-0.2ns < -0.1ns", $violation_count_per_original_skew_range{"N0200_N0100"} ) ;
printf( " %-30s  %20d\n", "-0.1ns <  0.0ns", $violation_count_per_original_skew_range{"N0100_N0000"} ) ;
printf( " %-30s  %20d\n", " 0.0ns < +0.1ns", $violation_count_per_original_skew_range{"P0000_P0100"} ) ;
printf( " %-30s  %20d\n", "+0.1ns < +0.2ns", $violation_count_per_original_skew_range{"P0100_P0200"} ) ;
printf( " %-30s  %20d\n", "+0.2ns < +0.5ns", $violation_count_per_original_skew_range{"P0200_P0500"} ) ;
printf( " %-30s  %20d\n", "+0.5ns < +1.0ns", $violation_count_per_original_skew_range{"P0500_P1000"} ) ;
printf( " %-30s  %20d\n", "+1.0ns < +2.0ns", $violation_count_per_original_skew_range{"P1000_P2000"} ) ;
printf( " %-30s  %20d\n", "+2.0ns < +5.0ns", $violation_count_per_original_skew_range{"P2000_P5000"} ) ;
printf( " %-30s  %20d\n", "+5.0ns <       ", $violation_count_per_original_skew_range{"P5000_"} ) ;
printf( " %-30s  %20s\n", "------------------------------", "--------------------" ) ;
printf( " %-30s  %20d\n", "total          ", $violation_count_per_original_skew_range{total} ) ;
}

########################################################################
# print violations per path group
#
printf( "\n" ) ;
printf( " %-30s  %20s  %20s\n", "path group", "# of violations", "worst slack" ) ;
printf( " %-30s  %20s  %20s\n", "------------------------------", "--------------------", "--------------------" ) ;
foreach $path_group ( sort( keys %violation_count_per_path_group ) ) {
  if( $worst_slack_per_path_group{$path_group} < 0 ) {
    if( $path_group ne "total" ) {
      printf( " %-30s  %20s  %20s\n", $path_group, $violation_count_per_path_group{$path_group}, $worst_slack_per_path_group{$path_group} ) ;
    }
  }
}
printf( " %-30s  %20s  %20s\n", "------------------------------", "--------------------", "--------------------" ) ;
printf( " %-30s  %20s  %20s\n", "*", $violation_count_per_path_group{total}, $worst_slack_per_path_group{total} ) ;

########################################################################
# print violations per clock group
#
printf( "\n" ) ;
printf( " %-20s  %-20s  %20s  %20s\n", "startpoint clock", "endpoint clock", "# of violations", "worst slack" ) ;
printf( " %-20s  %-20s  %20s  %20s\n", "--------------------", "--------------------", "--------------------", "--------------------" ) ;
foreach $clock_group ( sort( keys %violation_count_per_clock_group ) ) {
  if( $worst_slack_per_clock_group{$clock_group} < 0 ) {
    if( $clock_group ne "total" ) {
      $_ = $clock_group ;
      split( "-->", $_ ) ;
      $startpoint_clock = $_[0] ;
      $endpoint_clock = $_[1] ;
      printf( " %-20s  %-20s  %20s  %20s\n", $startpoint_clock, $endpoint_clock, $violation_count_per_clock_group{$clock_group}, $worst_slack_per_clock_group{$clock_group} ) ;
    }
  }
}
printf( " %-20s  %-20s  %20s  %20s\n", "--------------------", "--------------------", "--------------------", "--------------------" ) ;
printf( " %-20s  %-20s  %20s  %20s\n", "*", "*", $violation_count_per_clock_group{total}, $worst_slack_per_clock_group{total} ) ;

########################################################################
# print violations per block
#
if( $check_block == 1 ) {
printf( "\n" ) ;
printf( " %-20s  %-20s  %20s  %20s\n", "startpoint block", "endpoint block", "# of violations", "worst slack" ) ;
printf( " %-20s  %-20s  %20s  %20s\n", "--------------------", "--------------------", "--------------------", "--------------------" ) ;
foreach $block ( sort( keys %violation_count_per_block ) ) {
  if( $worst_slack_per_block{$block} < 0 ) {
    if( $block ne "total" ) {
      $_ = $block ;
      split( "-->", $_ ) ;
      $startpoint_block = $_[0] ;
      $endpoint_block = $_[1] ;
      printf( " %-20s  %-20s  %20s  %20s\n", $startpoint_block, $endpoint_block, $violation_count_per_block{$block}, $worst_slack_per_block{$block} ) ;
    }
  }
}
printf( " %-20s  %-20s  %20s  %20s\n", "--------------------", "--------------------", "--------------------", "--------------------" ) ;
printf( " %-20s  %-20s  %20s  %20s\n", "*", "*", $violation_count_per_block{total}, $worst_slack_per_block{total} ) ;
}

########################################################################
# print violations per stage count
#
printf( "\n" ) ;
printf( " %-30s  %20s\n", "stage count", "# of violations" ) ;
printf( " %-30s  %20s\n", "------------------------------", "--------------------" ) ;
foreach $stage_count ( sort { $a <=> $b } keys( %violation_count_per_stage_count ) ) {
  if( $stage_count ne "total" ) {
    printf( " %30d  %20d\n", $stage_count, $violation_count_per_stage_count{$stage_count} ) ;
  }
}
printf( " %-30s  %20s\n", "------------------------------", "--------------------" ) ;
printf( " %-30s  %20d\n", "total          ", $violation_count_per_stage_count{total} ) ;

########################################################################
# print endpoints per startpoint
#
printf( "\n" ) ;
printf( "<# of violations>\t<startpoint> <slack> (<stage_count>) (<clock>:<clock_network_delay>)\n" ) ;
printf( "\t\t\t<endpoint>   <slack> (<stage_count>) (<clock>:<clock_network_delay>) (<skew>)\n" ) ;
printf( "\n" ) ;
foreach $startpoint ( keys %endpoints_per_startpoint ) {
  @endpoints = split( " ", $endpoints_per_startpoint{$startpoint} ) ;
  printf( "%d\t%s %.3f", $#endpoints + 1, $startpoint, $startpoint_worst_slack{$startpoint} ) ;
  if( $check_stage_count == 1 ) {
    printf( " (%d)", $startpoint_stage_count{$startpoint} ) ;
  }
  if( $check_clock_network_delay == 1 ) {
    if( $is_timing_derate == 1 ) {
      printf( " (%s:%.3f->%.3f)",
        $clock{$startpoint}, $original_clock_network_delay{$startpoint}, $derating_clock_network_delay{$startpoint} ) ;
    } else {
      printf( " (%s:%.3f)",
        $clock{$startpoint}, $original_clock_network_delay{$startpoint} ) ;
    }
  }
  printf( "\n" ) ;

  foreach $endpoint ( @endpoints ) {
    printf( "\t%s %.3f", $endpoint, $path_slack{$startpoint,$endpoint} ) ;
    if( $check_stage_count == 1 ) {
      printf( " (%d)", $path_stage_count{$startpoint,$endpoint} ) ;
    }
    if( $check_clock_network_delay == 1 ) {
      if( $is_timing_derate == 1 ) {
        printf( " (%s:%.3f->%.3f)",
          $clock{$endpoint}, $original_clock_network_delay{$endpoint}, $derating_clock_network_delay{$endpoint} ) ;
        printf( " (%.3f->%.3f)",
          $original_clock_network_delay{$endpoint} - $original_clock_network_delay{$startpoint},
          $derating_clock_network_delay{$endpoint} - $derating_clock_network_delay{$startpoint} ) ;
      } else {
        printf( " (%s:%.3f)",
          $clock{$endpoint}, $original_clock_network_delay{$endpoint} ) ;
        printf( " (%.3f)",
          $original_clock_network_delay{$endpoint} - $original_clock_network_delay{$startpoint} ) ;
      }
    }
    printf( "\n" ) ;

    ##### WARNING #####
    if( ( $endpoint =~ /\/[ABS][0-9]*$/ ) && ( $endpoint !~ /_reg[^\/]*\/[^\/]+$/ ) ) {
if( ( $endpoint ne "djin_0/dram_test_0/DRAM_TEST_CLKGEN_0/PLL_EN_U1/S" ) &&
    ( $endpoint ne "djin_0/dram_test_0/DRAM_TEST_CLKGEN_0/PLL_EN_U2/S" ) &&
    ( $endpoint ne "djin_0/dram_test_0/DRAM_TEST_CLKGEN_0/EXT_EN_U1/S" ) &&
    ( $endpoint ne "djin_0/dram_test_0/DRAM_TEST_CLKGEN_0/EXT_EN_U2/S" ) &&
    ( $endpoint ne "djin_0/SCAN_DUMMY_0/COMP_REG/S" ) &&
    ( $endpoint ne "djin_0/SCAN_DUMMY_0/PAT_DELAY_U1/S" ) &&
    ( $endpoint ne "djin_0/dadc_0/AINCMEN_DMY_0/S" ) &&
    ( $endpoint !~ /\/SPARECELL_DFF[0-9][0-9]\/S$/ ) ) {
      printf( "Warning: clock gating check at combinational cell %s\n", $endpoint ) ;
      if( ( $path_type eq "min" ) && ( $clock_root_arrival{$startpoint} != $clock_root_arrival{$endpoint} ) ) {
        printf( "Warning: startpoint %s clocked at %s but endpoint %s clocked at %s\n",
          $startpoint, $clock_root_arrival{$startpoint}, $endpoint, $clock_root_arrival{$endpoint} ) ;
      }
}
    }

    ##### WARNING #####
    if( $path_type eq "max" ) {
      if( $delay_cell_exist{$startpoint,$endpoint} == 1 ) {
        printf( "Warning: delay cell(s) exist on path.\n" ) ;
      }
    }
  }
  printf( "\n" ) ;
}

