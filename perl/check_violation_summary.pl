#!/usr/bin/perl

$check_clock_network_delay = 0 ;
$check_stage_count = 0 ;
$check_block = 1 ;
$min_clock_paths_derating_factor = 1.0 ;
$max_clock_paths_derating_factor = 1.0 ;
$resolution = "high" ;

while(<>) {
  split ;

  ########################################################################
  # check header
  #
  if( /^\**\s*Report  *: [tT]iming/ ) {
    $is_report_timing = 1 ;
  }
  if( /^Report : [tT]iming/ ) {
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
  if( /^\s+(Path|Delay) Type: (min|max)/ ) {
    ( $dummy, $path_type ) = /^\**\s*(Path|Delay) Type: (min|max)/ ;
    if( $path_type eq "min" ) {
      $resolution = "high" ;
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
  if( /^\s+(Start|Begin)point:\s+(\S+)/ ) {
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
  if( /^\s+Path Group:\s+(\S+)/ ) {
    ( $path_group ) = /^\s*Path\s+Group:\s+(\S+)/ ;
  }

  ########################################################################
  # get clock
  #
  if( /^\s+clock\s+(\S+)\s+\((\S+ edge|re|fe)\)\s+(\d*\.*\d+)\s+/ ) {
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
      } elsif( $design eq "gbv493" ) {
        $startpoint_block = $startpoint ;
        if( $startpoint !~ /\// ) {
          $startpoint_block = "in" ;
        } else {
	  if( $startpoint_block =~ /^u_core\/u_3d\// ) {
          	$startpoint_block = "3D";
	  } elsif ( $startpoint_block =~ /^u_core\/u_dsp\// ) {
            $startpoint_block = "DSP";
  	  } elsif ( $startpoint_block =~ /^u_core\/u_on2en\// ) {
            $startpoint_block = "ENC";
  	  } elsif ( $startpoint_block =~ /^u_core\/u_on2de\// ) {
            $startpoint_block = "DEC"; 
  	  } elsif ( $startpoint_block =~ /^u_core\/u_rc\/u_disp\// ) {
            $startpoint_block = "DISP"; 
  	  } elsif ( $startpoint_block =~ /^u_core\/u_ca8\/pzone_b\/u_pzone_b_core\/u_arm_core\/u_CORTEXA8\// ) {
            $startpoint_block = "CA8";
  	  } else {
            $startpoint_block = "TOP";
          }
  	}
  ##### ONLY FOR DJIN #####
      } elsif( $design eq "sunny10d_chip" ) {
        if( $startpoint !~ /\// ) {
          $startpoint_block = "in" ;
        } elsif( $startpoint =~ /^core_0\/pd_live_0\// ) {
          $startpoint_block = "pd_live" ;           
        } elsif( $startpoint =~ /^core_0\/normal_arc_0\/base_arc_s9_0\// ) {
          $startpoint_block = "base_arc_s9" ;  
        } else { 
          $startpoint_block = "top" ;
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
    } elsif( $design eq "gbv493" ) {
      $endpoint_block = $endpoint ;
      if( $endpoint !~ /\// ) {
        $endpoint_block = "out" ;
      } else {
	  if( $endpoint_block =~ /^u_core\/u_3d\// ) {
          	$endpoint_block = "3D";
	  } elsif ( $endpoint_block =~ /^u_core\/u_dsp\// ) {
            $endpoint_block = "DSP";
  	  } elsif ( $endpoint_block =~ /^u_core\/u_on2en\// ) {
            $endpoint_block = "ENC";
  	  } elsif ( $endpoint_block =~ /^u_core\/u_on2de\// ) {
            $endpoint_block = "DEC"; 
  	  } elsif ( $endpoint_block =~ /^u_core\/u_rc\/u_disp\// ) {
            $endpoint_block = "DISP"; 
  	  } elsif ( $endpoint_block =~ /^u_core\/u_ca8\/pzone_b\/u_pzone_b_core\/u_arm_core\/u_CORTEXA8\// ) {
            $endpoint_block = "CA8";
  	  } else {
            $endpoint_block = "TOP";
          }
      }
  ##### ONLY FOR DJIN #####
    } elsif( $design eq "sunny10d_chip" ) {
      if( $endpoint !~ /\// ) {
        $endpoint_block = "out" ;
      } elsif( $endpoint =~ /^core_0\/pd_live_0\// ) {
        $endpoint_block = "pd_live" ;
      } elsif( $startpoint =~ /^core_0\/normal_arc_0\/base_arc_s9_0\// ) {
        $startpoint_block = "base_arc_s9" ;  
      } else {
        $endpoint_block = "top" ;
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
        if(      ( $slack <=  00 ) && ( $slack > -10 ) ) {
          $violation_count_per_range{"0000_0010"}++ ;
        } elsif( ( $slack <= -10 ) && ( $slack > -20 ) ) {
          $violation_count_per_range{"0010_0020"}++ ;
        } elsif( ( $slack <= -20 ) && ( $slack > -30 ) ) {
          $violation_count_per_range{"0020_0030"}++ ;
        } elsif( ( $slack <= -30 ) && ( $slack > -40 ) ) {
          $violation_count_per_range{"0030_0040"}++ ;
        } elsif( ( $slack <= -40 ) && ( $slack > -50 ) ) {
          $violation_count_per_range{"0040_0050"}++ ;
        } elsif( ( $slack <= -50 ) && ( $slack > -60 ) ) {
          $violation_count_per_range{"0050_0060"}++ ;
        } elsif( ( $slack <= -60 ) && ( $slack > -70 ) ) {
          $violation_count_per_range{"0060_0070"}++ ;
        } elsif( ( $slack <= -70 ) && ( $slack > -80 ) ) {
          $violation_count_per_range{"0070_0080"}++ ;
        } elsif( ( $slack <= -80 ) && ( $slack > -90 ) ) {
          $violation_count_per_range{"0080_0090"}++ ;
        } elsif( ( $slack <= -90 ) && ( $slack > -100 ) ) {
          $violation_count_per_range{"0090_0100"}++ ;
        } elsif( ( $slack <= -100 ) && ( $slack > -110 ) ) {
          $violation_count_per_range{"0100_0110"}++ ;
        } elsif( ( $slack <= -110 ) && ( $slack > -120 ) ) {
          $violation_count_per_range{"0110_0120"}++ ;
        } elsif( ( $slack <= -120 ) && ( $slack > -130 ) ) {
          $violation_count_per_range{"0120_0130"}++ ;
        } elsif( ( $slack <= -130 ) && ( $slack > -140 ) ) {
          $violation_count_per_range{"0130_0140"}++ ;
        } elsif( ( $slack <= -140 ) && ( $slack > -150 ) ) {
          $violation_count_per_range{"0140_0150"}++ ;
        } elsif( ( $slack <= -150 ) && ( $slack > -160 ) ) {
          $violation_count_per_range{"0150_0160"}++ ;
        } elsif( ( $slack <= -160 ) && ( $slack > -170 ) ) {
          $violation_count_per_range{"0160_0170"}++ ;
        } elsif( ( $slack <= -170 ) && ( $slack > -180 ) ) {
          $violation_count_per_range{"0170_0180"}++ ;
        } elsif( ( $slack <= -180 ) && ( $slack > -190 ) ) {
          $violation_count_per_range{"0180_0190"}++ ;
        } elsif( ( $slack <= -190 ) && ( $slack > -200 ) ) {
          $violation_count_per_range{"0190_0200"}++ ;
        } elsif( ( $slack <= -200 ) && ( $slack > -300 ) ) {
          $violation_count_per_range{"0200_0300"}++ ;
        } elsif( ( $slack <= -300 ) && ( $slack > -400 ) ) {
          $violation_count_per_range{"0300_0400"}++ ;
        } elsif( ( $slack <= -400 ) && ( $slack > -500 ) ) {
          $violation_count_per_range{"0400_0500"}++ ;
        } elsif( ( $slack <= -500 ) && ( $slack > -1000 ) ) {
          $violation_count_per_range{"0500_1000"}++ ;
        } elsif( ( $slack <= -1000 ) && ( $slack > -2000 ) ) {
          $violation_count_per_range{"1000_2000"}++ ;
        } elsif( ( $slack <= -2000 ) && ( $slack > -5000 ) ) {
          $violation_count_per_range{"2000_5000"}++ ;
        } elsif( ( $slack <= -5000 ) ) {
          $violation_count_per_range{"5000_"}++ ;
        }
      } else {
        if(      ( $slack <=  0 ) && ( $slack > -1 ) ) {
          $violation_count_per_range{"0000_0100"}++ ;
        } elsif( ( $slack <= -1 ) && ( $slack > -2 ) ) {
          $violation_count_per_range{"0100_0200"}++ ;
        } elsif( ( $slack <= -2 ) && ( $slack > -5 ) ) {
          $violation_count_per_range{"0200_0500"}++ ;
        } elsif( ( $slack <= -5 ) && ( $slack > -10 ) ) {
          $violation_count_per_range{"0500_1000"}++ ;
        } elsif( ( $slack <= -10 ) && ( $slack > -20 ) ) {
          $violation_count_per_range{"1000_2000"}++ ;
        } elsif( ( $slack <= -20 ) && ( $slack > -50 ) ) {
          $violation_count_per_range{"2000_5000"}++ ;
        } elsif( ( $slack <= -50 ) ) {
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
printf( " %-30s  %20d\n", "-0000ps < -0010ps", $violation_count_per_range{"0000_0010"} ) ;
printf( " %-30s  %20d\n", "-0010ps < -0020ps", $violation_count_per_range{"0010_0020"} ) ;
printf( " %-30s  %20d\n", "-0020ps < -0030ps", $violation_count_per_range{"0020_0030"} ) ;
printf( " %-30s  %20d\n", "-0030ps < -0040ps", $violation_count_per_range{"0030_0040"} ) ;
printf( " %-30s  %20d\n", "-0040ps < -0050ps", $violation_count_per_range{"0040_0050"} ) ;
printf( " %-30s  %20d\n", "-0050ps < -0060ps", $violation_count_per_range{"0050_0060"} ) ;
printf( " %-30s  %20d\n", "-0060ps < -0070ps", $violation_count_per_range{"0060_0070"} ) ;
printf( " %-30s  %20d\n", "-0070ps < -0080ps", $violation_count_per_range{"0070_0080"} ) ;
printf( " %-30s  %20d\n", "-0080ps < -0090ps", $violation_count_per_range{"0080_0090"} ) ;
printf( " %-30s  %20d\n", "-0090ps < -0100ps", $violation_count_per_range{"0090_0100"} ) ;
printf( " %-30s  %20d\n", "-0100ps < -0110ps", $violation_count_per_range{"0100_0110"} ) ;
printf( " %-30s  %20d\n", "-0110ps < -0120ps", $violation_count_per_range{"0110_0120"} ) ;
printf( " %-30s  %20d\n", "-0120ps < -0130ps", $violation_count_per_range{"0120_0130"} ) ;
printf( " %-30s  %20d\n", "-0130ps < -0140ps", $violation_count_per_range{"0130_0140"} ) ;
printf( " %-30s  %20d\n", "-0140ps < -0150ps", $violation_count_per_range{"0140_0150"} ) ;
printf( " %-30s  %20d\n", "-0150ps < -0160ps", $violation_count_per_range{"0150_0160"} ) ;
printf( " %-30s  %20d\n", "-0160ps < -0170ps", $violation_count_per_range{"0160_0170"} ) ;
printf( " %-30s  %20d\n", "-0170ps < -0180ps", $violation_count_per_range{"0170_0180"} ) ;
printf( " %-30s  %20d\n", "-0180ps < -0190ps", $violation_count_per_range{"0180_0190"} ) ;
printf( " %-30s  %20d\n", "-0190ps < -0200ps", $violation_count_per_range{"0190_0200"} ) ;
printf( " %-30s  %20d\n", "-0200ps < -0300ps", $violation_count_per_range{"0200_0300"} ) ;
printf( " %-30s  %20d\n", "-0300ps < -0400ps", $violation_count_per_range{"0300_0400"} ) ;
printf( " %-30s  %20d\n", "-0400ps < -0500ps", $violation_count_per_range{"0400_0500"} ) ;
printf( " %-30s  %20d\n", "-0500ps < -1000ps", $violation_count_per_range{"0500_1000"} ) ;
printf( " %-30s  %20d\n", "-1000ps < -2000ps", $violation_count_per_range{"1000_2000"} ) ;
printf( " %-30s  %20d\n", "-2000ps < -5000ps", $violation_count_per_range{"2000_5000"} ) ;
printf( " %-30s  %20d\n", "-5000ps <         ", $violation_count_per_range{"5000_"} ) ;
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
      @clock = split( "-->", $_ ) ;
      $startpoint_clock = $clock[0] ;
      $endpoint_clock = $clock[1] ;
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
      @clock = split( "-->", $_ ) ;
      $startpoint_block = $clock[0] ;
      $endpoint_block = $clock[1] ;
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
    if( $endpoint =~ /\/[ABS][0-9]*$/ ) {
      printf( "Warning: clock gating check at combinational cell %s\n", $endpoint ) ;
      if( ( $path_type eq "min" ) && ( $clock_root_arrival{$startpoint} != $clock_root_arrival{$endpoint} ) ) {
        printf( "Warning: startpoint %s clocked at %s but endpoint %s clocked at %s\n",
          $startpoint, $clock_root_arrival{$startpoint}, $endpoint, $clock_root_arrival{$endpoint} ) ;
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
