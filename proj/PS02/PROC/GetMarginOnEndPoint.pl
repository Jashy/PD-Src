#!/usr/bin/perl

$check_clock_network_delay = 1 ;
$check_stage_count = 1 ;
$check_path_group = 1 ;
$check_block = 1 ;
$min_clock_paths_derating_factor = 1.0 ;
$max_clock_paths_derating_factor = 1.0 ;
$resolution = "medium" ;
$is_magma = 0 ;

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
  if( /-delay min/ ) {
    $resolution = "high" ;
  }
  if( /-nets/ ) {
    $check_stage_count = 1 ;
  }
  if( /^\**\s*Design\s*:\s*(\S+)/ ) {
    ( $design ) = /^\**\s*Design\s*:\s*(\S+)/ ;
  }
  if( /^# Mantle analysis report\s*$/ ) {
    $is_report_timing = 1 ;
    $is_magma = 1 ;
    $check_stage_count = 0 ;
    $check_clock_network_delay = 1 ;
    $check_path_group = 0 ;
  }
  if( $is_magma == 1 ) {
    if( /^#\s+\/work\/[^\/]+\/([^\/]+)\s+\\/ ) {
      ( $design ) = /^#\s+\/work\/[^\/]+\/([^\/]+)\s+\\/ ;
    }
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
    ( $dummy, $startpoint_pin ) = /^\s*(Start|Begin)point:\s+(\S+)/ ;
    $startpoint_clock = "" ;
    $startpoint_clock_root_arrival = "" ;
    $startpoint_derating_clock_network_delay = "" ;
    $endpoint_pin = "" ;
    $endpoint_clock = "" ;
    $endpoint_clock_root_arrival = "" ;
    $endpoint_derating_clock_network_delay = "" ;

    $is_data_path = 0 ;
    $stage_count = 0 ;

    $startpoint_pattern = $startpoint_pin ;
    $startpoint_pattern =~ s/([\[\]])/\\$1/g ;

    $delay_cell_found = 0 ;
  }

  if( $is_magma == 1 ) {
    if( /^Start\s+(\S+)\s*$/ ) {
      ( $startpoint_pin ) =  /^Start\s+(\S+)\s*$/ ;

      $startpoint_clock = "" ;
      $startpoint_clock_root_arrival = "" ;
      $startpoint_derating_clock_network_delay = "" ;
      $endpoint_pin = "" ;
      $endpoint_clock = "" ;
      $endpoint_clock_root_arrival = "" ;
      $endpoint_derating_clock_network_delay = "" ;

      $is_data_path = 0 ;
      $is_reference_clock_path = 0 ;
      $stage_count = 0 ;

      $startpoint_pattern = $startpoint_pin ;
      $startpoint_pattern =~ s/([\[\]])/\\$1/g ;

      $delay_cell_found = 0 ;
    }
    if( /^End\s+(\S+)\s*$/ ) {
      ( $endpoint_pin ) =  /^End\s+(\S+)\s*$/ ;
    }
    if( /^Path slack\s+(-*\d+)p\s*$/ ) {
      ( $slack ) =  /^Path slack\s+(-*\d+)p\s*$/ ;
      $slack = $slack / 1000.000 ;
    }
  }

  ########################################################################
  # get path path group
  #
  if( /^\**\s*Path Group:\s+(\S+)/ ) {
    ( $path_group ) = /^\s*Path Group:\s+(\S+)/ ;
    $path_group =~ s/^.*\/// if( $design eq "Tachyon2HDD" ) ; # Tachyon2HDD
  }

  ########################################################################
  # get clock
  #
  if( /\(.* clocked by (\S+)\)/ ) {
    ( $clock ) = /\(.* clocked by (\S+)\)/ ;
    if( $startpoint_clock eq "" ) {
      $startpoint_clock = $clock ;
      $startpoint = "$startpoint_pin:$startpoint_clock" ;
     #$startpoint_clock_root_arrival = 0 ;
     #$clock_root_arrival{$startpoint} = $startpoint_clock_root_arrival ;
    } elsif( $endpoint_clock eq "" ) {
      $endpoint_clock = $clock ;
      $endpoint = "$endpoint_pin:$endpoint_clock" ;
     #$endpoint_clock_root_arrival = 0 ;
     #$clock_root_arrival{$endpoint} = $endpoint_clock_root_arrival ;

      $clock_group = "$startpoint_clock,$endpoint_clock" ;
      if( $worst_slack_per_clock_group{$clock_group} eq "" ) {
         $worst_slack_per_clock_group{$clock_group} = 999999 ;
      }
    }
  }
  if( /\(clock source '(\S+)'\)/ ) {
    ( $clock ) = /\(clock source '(\S+)'\)/ ;
    if( $startpoint_clock eq "" ) {
      $startpoint_clock = $clock ;
      $startpoint = "$startpoint_pin:$startpoint_clock" ;
     #$startpoint_clock_root_arrival = 0 ;
     #$clock_root_arrival{$startpoint} = $startpoint_clock_root_arrival ;
    } elsif( $endpoint_clock eq "" ) {
      $endpoint_clock = $clock ;
      $endpoint = "$endpoint_pin:$endpoint_clock" ;
     #$endpoint_clock_root_arrival = 0 ;
     #$clock_root_arrival{$endpoint} = $endpoint_clock_root_arrival ;
    
      $clock_group = "$startpoint_clock,$endpoint_clock" ;
      if( $worst_slack_per_clock_group{$clock_group} eq "" ) {
         $worst_slack_per_clock_group{$clock_group} = 999999 ;
      } 
    }
  }
  if( /^\s*clock (\S+) \((\S+ edge|re|fe)\)\s+(\d*\.*\d+)\s+/ ) {
    if( ( $startpoint_clock eq "" ) && ( $endpoint_clock eq "" ) ) {
      ( $startpoint_clock, $dummy, $startpoint_clock_root_arrival ) = /^\s*clock (\S+) \((\S+ edge|re|fe)\)\s+(\d*\.*\d+)\s+/ ;
      $startpoint_clock =~ s/^.*\/// if( $design eq "Tachyon2HDD" ) ; # Tachyon2HDD
      $startpoint = "$startpoint_pin:$startpoint_clock" ;
    } elsif( ( $startpoint_clock ne "" ) && ( $endpoint_clock eq "" ) ) {
      ( $endpoint_clock, $dummy, $endpoint_clock_root_arrival ) = /^\s*clock (\S+) \((\S+ edge|re|fe)\)\s+(\d*\.*\d+)\s+/ ;
      $endpoint_clock =~ s/^.*\/// if( $design eq "Tachyon2HDD" ) ; # Tachyon2HDD
      $endpoint = "$endpoint_pin:$endpoint_clock" ;
      $clock_root_arrival{$endpoint} = $endpoint_clock_root_arrival ;

      $clock_group = "$startpoint_clock,$endpoint_clock" ;
      if( $worst_slack_per_clock_group{$clock_group} eq "" ) {
         $worst_slack_per_clock_group{$clock_group} = 999999 ;
      }
    }
  }

  if( $is_magma == 1 ) {
    if( /^\+ Cycle adjust \(([^:]+):\S+ vs\. ([^:]+):\S+\)\s+(\d+)\s*$/ ) {
      ( $startpoint_clock, $endpoint_clock ) = /^\+ Cycle adjust \(([^:]+):\S+ vs\. ([^:]+):\S+\)\s+(\d+)\s*$/ ;
      $startpoint = "$startpoint_pin:$startpoint_clock" ;
      $endpoint = "$endpoint_pin:$endpoint_clock" ;
      $clock_group = "$startpoint_clock,$endpoint_clock" ;
      if( $worst_slack_per_clock_group{$clock_group} eq "" ) {
         $worst_slack_per_clock_group{$clock_group} = 999999 ;
      }
     #$_ = sprintf( "  slack (VIOLATED) %s\n", $slack ) ; # HACK
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

  if( $is_magma == 1 ) {
    if( /^\+ Clock path delay\s+(\d+)\s*$/ ) {
      ( $startpoint_derating_clock_network_delay ) = /^\+ Clock path delay\s+(\d+)\s*$/ ;
      $startpoint_derating_clock_network_delay = $startpoint_derating_clock_network_delay / 1000.0 ;
    }
    if( /^Reference arrival time\s+(\d+)\s*$/ ) {
      ( $endpoint_derating_clock_network_delay ) = /^Reference arrival time\s+(\d+)\s*$/ ;
      $endpoint_derating_clock_network_delay = $endpoint_derating_clock_network_delay / 1000.0 ;
    }
  }

  ########################################################################
  # check pin for startpoint and endpoint
  #
  if( /^\**\s*(\S+) \((\S+)\)\s+(\S+)\s+(\S+)/ ) {
    $is_pin = 1 ;
    $is_pin = 0 if( /^\**\s*(\S+) \(net\)\s+(\S+)\s+(\S+)/ ) ;
    ( $pin, $cell ) = /^\**\s*(\S+)\s+\((\S+)\)\s+(\S+)\s+(\S+)/ if( $is_pin == 1 ) ;
  }

  if( $is_magma == 1 ) {
    if( /^(\S+)\s+(.*)\s+(RISE|FALL)/ ) {
      ( $pin ) = /^(\S+)\s+(.*)\s+(RISE|FALL)/ ;
    }
  }

  ########################################################################
  # check delay for stage count (exclude hierarchical pin)
  #
  if( /\s+(\d*\.*\d+)\s+(\*|&)*\s*(\d*\.*\d+)\s+(r|f|R|F)\s*/ ) {
    unless( / \(net\) / ) {
      ( $delay ) = /\s+(\d*\.*\d+)\s+(\*|&)*\s*(\d*\.*\d+)\s+(r|f|R|F)\s*/ ;
    }
  }

  ########################################################################
  # get startpoint (pin)
  #
  if( $is_data_path == 0 ) {
    if( ( $pin eq $startpoint_pin ) || ( $pin =~ /^($startpoint_pattern)\// ) ) {
      $startpoint_pin = $pin ;
      $startpoint = "$startpoint_pin:$startpoint_clock" ;
      $clock_root_arrival{$startpoint} = $startpoint_clock_root_arrival ;

      $is_data_path = 1 ;

      ##### ONLY FOR T2 #####
      if( $design eq "Tachyon2HDD" ) {
        $startpoint_block = $startpoint_pin ;
        if( $startpoint_pin !~ /\// ) {
          $startpoint_block = "in" ;
        } else {
          $startpoint_block =~ s/^d2975\/top\/sc_/d2975\/top\/sc\// ;
          $startpoint_block =~ s/^d2975\/top\/me_/d2975\/top\/me\// ;
          $startpoint_block =~ s/^d2975\/top\/pb_/d2975\/top\/pb\// ;
          $startpoint_block =~ s/^d2975\/top\/ck_/d2975\/top\/ck\// ;
          if( $startpoint_block =~ /^d2975\/top\/me\/mcpu\// ) { $startpoint_block = "d2975/top/me/mcpu (CPU_MEDIA)" }
          elsif( $startpoint_block =~ /^d2975\/top\/me\/mvme\// ) { $startpoint_block = "d2975/top/me/mvme (VETOP)" }
          elsif( $startpoint_block =~ /^d2975\/top\/me\/mavc\// ) { $startpoint_block = "d2975/top/me/mavc (A1RING)" }
          elsif( $startpoint_block =~ /^d2975\/top\/me\/mahbm\// ) { $startpoint_block = "d2975/top/me/mahbm/*" }
          elsif( $startpoint_block =~ /^d2975\/top\/me\/mdmac\// ) { $startpoint_block = "d2975/top/me/mdmac/*" }
          elsif( $startpoint_block =~ /^d2975\/top\/me\/mvld\// ) { $startpoint_block = "d2975/top/me/mvld/*" }
          elsif( $startpoint_block =~ /^d2975\/top\/me\// ) { $startpoint_block = "d2975/top/me/*" }

          elsif( $startpoint_block =~ /^d2975\/top\/sc\/scpu\// ) { $startpoint_block = "d2975/top/sc/scpu (CPU_MAIN)" }
          elsif( $startpoint_block =~ /^d2975\/top\/sc\/saw_a\// ) { $startpoint_block = "d2975/top/sc/saw_a (aw_a)" }
          elsif( $startpoint_block =~ /^d2975\/top\/sc\/semc1\/emc_io_wrapper\// ) { $startpoint_block = "d2975/top/sc/semc1/emc_io_wrapper (EMC_DDR_IO_WRAPPER_R2P0)" }
          elsif( $startpoint_block =~ /^d2975\/top\/sc\/skirk\// ) { $startpoint_block = "d2975/top/sc/skirk/*" }
          elsif( $startpoint_block =~ /^d2975\/top\/sc\/sata\// ) { $startpoint_block = "d2975/top/sc/sata/*" }
          elsif( $startpoint_block =~ /^d2975\/top\/sc\/satahdd\// ) { $startpoint_block = "d2975/top/sc/satahdd/*" }
          elsif( $startpoint_block =~ /^d2975\/top\/sc\/smrom\// ) { $startpoint_block = "d2975/top/sc/smrom/*" }
          elsif( $startpoint_block =~ /^d2975\/top\/sc\/sahbm\// ) { $startpoint_block = "d2975/top/sc/sahbm/*" }
          elsif( $startpoint_block =~ /^d2975\/top\/sc\/sahbs\// ) { $startpoint_block = "d2975/top/sc/sahbs/*" }
          elsif( $startpoint_block =~ /^d2975\/top\/sc\/sdmac0\// ) { $startpoint_block = "d2975/top/sc/sdmac0/*" }
          elsif( $startpoint_block =~ /^d2975\/top\/sc\/sdmac1\// ) { $startpoint_block = "d2975/top/sc/sdmac1/*" }
          elsif( $startpoint_block =~ /^d2975\/top\/sc\/sdmac2\// ) { $startpoint_block = "d2975/top/sc/sdmac2/*" }
          elsif( $startpoint_block =~ /^d2975\/top\/sc\/sms1\// ) { $startpoint_block = "d2975/top/sc/sms1/*" }
          elsif( $startpoint_block =~ /^d2975\/top\/sc\/sms2\// ) { $startpoint_block = "d2975/top/sc/sms2/*" }
          elsif( $startpoint_block =~ /^d2975\/top\/sc\/spmem\// ) { $startpoint_block = "d2975/top/sc/spmem/*" }
          elsif( $startpoint_block =~ /^d2975\/top\/sc\/sshr\// ) { $startpoint_block = "d2975/top/sc/sshr/*" }
          elsif( $startpoint_block =~ /^d2975\/top\/sc\/susb\// ) { $startpoint_block = "d2975/top/sc/susb/*" }
          elsif( $startpoint_block =~ /^d2975\/top\/sc\// ) { $startpoint_block = "d2975/top/sc/*" }

          elsif( $startpoint_block =~ /^d2975\/top\/pb\/pspi2\// ) { $startpoint_block = "d2975/top/me/pspi2/*" }
          elsif( $startpoint_block =~ /^d2975\/top\/pb\/pmib\// ) { $startpoint_block = "d2975/top/pb/pmib/*" }
          elsif( $startpoint_block =~ /^d2975\/top\/pb\// ) { $startpoint_block = "d2975/top/pb/*" }

          elsif( $startpoint_block =~ /^d2975\/top\/ck\// ) { $startpoint_block = "d2975/top/ck/*" }
          elsif( $startpoint_block =~ /^d2975\/top\/pll\// ) { $startpoint_block = "d2975/top/pll/*" }
          elsif( $startpoint_block =~ /^d2975\/top\/dbtest\// ) { $startpoint_block = "d2975/top/dbtest/*" }
          elsif( $startpoint_block =~ /^d2975\/top\/fuse\// ) { $startpoint_block = "d2975/top/fuse/*" }
          elsif( $startpoint_block =~ /^d2975\/top\/BPM[^\/]+\// ) { $startpoint_block = "d2975/top/BPM*" }
          elsif( $startpoint_block =~ /^d2975\/top\// ) { $startpoint_block = "d2975/top/*" }
          elsif( $startpoint_block =~ /^d2975\/[^\/]+_SF_reg\// ) { $startpoint_block = "d2975/*_SF_reg" }
          elsif( $startpoint_block =~ /^d2975\// ) { $startpoint_block = "d2975/*" }
          elsif( $startpoint_block =~ /^Venus\// ) { $startpoint_block = "Venus/*" }
          elsif( $startpoint_block =~ /^mercury\// ) { $startpoint_block = "mercury" }
          else { $startpoint_block = "*" }
        }
      ##### ONLY FOR DJIN #####
      } elsif( $design eq "DJINIO" ) {
        if( $startpoint_pin !~ /\// ) {
          $startpoint_block = "in" ;
        } elsif( $startpoint_pin =~ /\/SC900DRM[^\/]+\/[^\/]+$/i ) {
          $startpoint_block = "DRAM" ;
        } elsif( $startpoint_pin =~ /\/LV[12]P[^\/]+\/[^\/]+$/ ) {
          $startpoint_block = "SRAM" ;
        } elsif( $startpoint_pin =~ /FUSEBOX/ ) {
          $startpoint_block = "FUSEBOX" ;
        } elsif( $startpoint_pin =~ /_collar\/[^\/]+_FLOP_reg/ ) {
          $startpoint_block = "MBIST" ;
        } elsif( $startpoint_pin =~ /\/[^\/]+reg[^\/]*\/[^\/]+$/ ) {
          $startpoint_block = "DFF" ;
        } elsif( $startpoint_pin eq "djin_0/dadc_0/sc900xapaa00_0/CLKPcheckpin1" ) {
          $startpoint_block = "ADC" ;
        } else {
          $startpoint_block = "?" ;
        }
      ##### ONLY FOR HYDRA2IO #####
      } elsif( $design eq "HYDRA2IO" ) {
        if( $startpoint_pin !~ /\// ) {
          $startpoint_block = "in" ;
       #} elsif( $startpoint_pin =~ /^hydra2_0\/kcore_0\// ) {
       #  $startpoint_block = "KCORE" ;
       #} elsif( $startpoint_pin =~ /^hydra2_0\/dcore_0\/dcofdm1_0\// ) {
       #  $startpoint_block = "DCOFDM1" ;
        } elsif( $startpoint_pin =~ /^TACOTAPC/ ) {
          $startpoint_block = "*TAPC*" ;
        } elsif( $startpoint_pin =~ /^[A-Z0-9]+_0_[A-Z0-9]+\/(SF|UP)_reg\// ) {
          $startpoint_block = "*BSC*" ;
        } elsif( $startpoint_pin =~ /^([^\/]+\/[^\/]+)\/\S+/ ) {
          $startpoint_block = $startpoint_pin ;
          $startpoint_block =~ s/^([^\/]+\/[^\/]+)\/\S+$/\1\/\*/ ;
        } else {
          $startpoint_block = "*TOP*" ;
        }
      ##### ONLY FOR MCTEG0 #####
      } elsif( $design eq "MCTEG0" ) {
        if(      $startpoint_pin !~ /\// ) {
                 $startpoint_block = "in" ;
        } elsif( $startpoint_pin =~ /^topl\/DDRCONE\/emc\/EMC_DDR_IO_WRAPPER_R2P0\/emc_ddr_io\// ) {
                 $startpoint_block = "emc_ddr_io\/*" ;
        } else {
                 $startpoint_block = $startpoint_pin ;
                #$startpoint_block =~ s/\/.*$// ;
                #$startpoint_block =~ s/^([^\/]+)\/\S+$/\1\/\*/ ;
                 $startpoint_block =~ s/^([^\/]+\/[^\/]+)\/\S+$/\1\/\*/ ;
        }
      ##### ONLY FOR SDCHIP #####
      } elsif( $design eq "top" ) {
        if( $startpoint_pin !~ /\// ) {
                 $startpoint_block = "in" ;
        } elsif( $startpoint_pin =~ /^ahb2apb_/ ) {
                 $startpoint_block = "ahb2apb_*" ;
        } elsif( $startpoint_pin =~ /^(ahb_[^_\/]+_).*$/ ) {
                 $startpoint_block = $startpoint_pin ;
                 $startpoint_block =~ s/^(ahb_[^_\/]+_).*$/\1_\*/ ;
        } elsif( $startpoint_pin =~ /^(apb_[^_\/]+_).*$/ ) {
                 $startpoint_block = $startpoint_pin ;
                 $startpoint_block =~ s/^(apb_[^_\/]+_).*$/\1_\*/ ;
        } elsif( $startpoint_pin =~ /^([^\/]+)\/\S+/ ) {
                 $startpoint_block = $startpoint_pin ;
                 $startpoint_block =~ s/^([^\/]+)\/\S+$/\1\/\*/ ;
        } else {
                 $startpoint_block = "*TOP*" ;
        }
      ##### DEFAULT #####
      } else {
        if( $startpoint_pin !~ /\// ) {
          $startpoint_block = "in" ;
        } else {
          $startpoint_block = $startpoint_pin ;
          $startpoint_block =~ s/\/.*$// ;
        }
      }
    }
  }

  ########################################################################
  # get endpoint (pin)
  #
  if( ( ( /^\**\s*data arrival time / ) && ( $endpoint_pin eq "" ) ) || ( ( $is_magma == 1 ) && ( /Reference clock path/ ) ) ) {
    $endpoint_pin = $pin if( $pin ne "" ) ;
    $endpoint = "$endpoint_pin:$endpoint_clock" ;

    ##### ONLY FOR T2 #####
    if( $design eq "Tachyon2HDD" ) {
      $endpoint_block = $endpoint_pin ;
      if( $endpoint_pin !~ /\// ) {
        $endpoint_block = "out" ;
      } else {
        $endpoint_block =~ s/^d2975\/top\/sc_/d2975\/top\/sc\// ;
        $endpoint_block =~ s/^d2975\/top\/me_/d2975\/top\/me\// ;
        $endpoint_block =~ s/^d2975\/top\/pb_/d2975\/top\/pb\// ;
        $endpoint_block =~ s/^d2975\/top\/ck_/d2975\/top\/ck\// ;
        if( $endpoint_block =~ /^d2975\/top\/me\/mcpu\// ) { $endpoint_block = "d2975/top/me/mcpu (CPU_MEDIA)" }
        elsif( $endpoint_block =~ /^d2975\/top\/me\/mvme\// ) { $endpoint_block = "d2975/top/me/mvme (VETOP)" }
        elsif( $endpoint_block =~ /^d2975\/top\/me\/mavc\// ) { $endpoint_block = "d2975/top/me/mavc (A1RING)" }
        elsif( $endpoint_block =~ /^d2975\/top\/me\/mahbm\// ) { $endpoint_block = "d2975/top/me/mahbm/*" }
        elsif( $endpoint_block =~ /^d2975\/top\/me\/mdmac\// ) { $endpoint_block = "d2975/top/me/mdmac/*" }
        elsif( $endpoint_block =~ /^d2975\/top\/me\/mvld\// ) { $endpoint_block = "d2975/top/me/mvld/*" }
        elsif( $endpoint_block =~ /^d2975\/top\/me\// ) { $endpoint_block = "d2975/top/me/*" }

        elsif( $endpoint_block =~ /^d2975\/top\/sc\/scpu\// ) { $endpoint_block = "d2975/top/sc/scpu (CPU_MAIN)" }
        elsif( $endpoint_block =~ /^d2975\/top\/sc\/saw_a\// ) { $endpoint_block = "d2975/top/sc/saw_a (aw_a)" }
        elsif( $endpoint_block =~ /^d2975\/top\/sc\/semc1\/emc_io_wrapper\// ) { $endpoint_block = "d2975/top/sc/semc1/emc_io_wrapper (EMC_DDR_IO_WRAPPER_R2P0)" }
        elsif( $endpoint_block =~ /^d2975\/top\/sc\/skirk\// ) { $endpoint_block = "d2975/top/sc/skirk/*" }
        elsif( $endpoint_block =~ /^d2975\/top\/sc\/sata\// ) { $endpoint_block = "d2975/top/sc/sata/*" }
        elsif( $endpoint_block =~ /^d2975\/top\/sc\/satahdd\// ) { $endpoint_block = "d2975/top/sc/satahdd/*" }
        elsif( $endpoint_block =~ /^d2975\/top\/sc\/smrom\// ) { $endpoint_block = "d2975/top/sc/smrom/*" }
        elsif( $endpoint_block =~ /^d2975\/top\/sc\/sahbm\// ) { $endpoint_block = "d2975/top/sc/sahbm/*" }
        elsif( $endpoint_block =~ /^d2975\/top\/sc\/sahbs\// ) { $endpoint_block = "d2975/top/sc/sahbs/*" }
        elsif( $endpoint_block =~ /^d2975\/top\/sc\/sdmac0\// ) { $endpoint_block = "d2975/top/sc/sdmac0/*" }
        elsif( $endpoint_block =~ /^d2975\/top\/sc\/sdmac1\// ) { $endpoint_block = "d2975/top/sc/sdmac1/*" }
        elsif( $endpoint_block =~ /^d2975\/top\/sc\/sdmac2\// ) { $endpoint_block = "d2975/top/sc/sdmac2/*" }
        elsif( $endpoint_block =~ /^d2975\/top\/sc\/sms1\// ) { $endpoint_block = "d2975/top/sc/sms1/*" }
        elsif( $endpoint_block =~ /^d2975\/top\/sc\/sms2\// ) { $endpoint_block = "d2975/top/sc/sms2/*" }
        elsif( $endpoint_block =~ /^d2975\/top\/sc\/spmem\// ) { $endpoint_block = "d2975/top/sc/spmem/*" }
        elsif( $endpoint_block =~ /^d2975\/top\/sc\/sshr\// ) { $endpoint_block = "d2975/top/sc/sshr/*" }
        elsif( $endpoint_block =~ /^d2975\/top\/sc\/susb\// ) { $endpoint_block = "d2975/top/sc/susb/*" }
        elsif( $endpoint_block =~ /^d2975\/top\/sc\// ) { $endpoint_block = "d2975/top/sc/*" }

        elsif( $endpoint_block =~ /^d2975\/top\/pb\/pspi2\// ) { $endpoint_block = "d2975/top/me/pspi2/*" }
        elsif( $endpoint_block =~ /^d2975\/top\/pb\/pmib\// ) { $endpoint_block = "d2975/top/pb/pmib/*" }
        elsif( $endpoint_block =~ /^d2975\/top\/pb\// ) { $endpoint_block = "d2975/top/pb/*" }

        elsif( $endpoint_block =~ /^d2975\/top\/ck\// ) { $endpoint_block = "d2975/top/ck/*" }
        elsif( $endpoint_block =~ /^d2975\/top\/pll\// ) { $endpoint_block = "d2975/top/pll/*" }
        elsif( $endpoint_block =~ /^d2975\/top\/dbtest\// ) { $endpoint_block = "d2975/top/dbtest/*" }
        elsif( $endpoint_block =~ /^d2975\/top\/fuse\// ) { $endpoint_block = "d2975/top/fuse/*" }
        elsif( $endpoint_block =~ /^d2975\/top\/BPM[^\/]+\// ) { $endpoint_block = "d2975/top/BPM*" }
        elsif( $endpoint_block =~ /^d2975\/top\// ) { $endpoint_block = "d2975/top/*" }
        elsif( $endpoint_block =~ /^d2975\/[^\/]+_SF_reg\// ) { $endpoint_block = "d2975/*_SF_reg" }
        elsif( $endpoint_block =~ /^d2975\// ) { $endpoint_block = "d2975/*" }
        elsif( $endpoint_block =~ /^Venus\// ) { $endpoint_block = "Venus/*" }
        elsif( $endpoint_block =~ /^mercury\// ) { $endpoint_block = "mercury" }
        else { $endpoint_block = "*" }
      }
    ##### ONLY FOR DJIN #####
    } elsif( $design eq "DJINIO" ) {
      if( $endpoint_pin !~ /\// ) {
        $endpoint_block = "out" ;
      } elsif( $endpoint_pin =~ /\/SC900DRM[^\/]+\/[^\/]+$/i ) {
        $endpoint_block = "DRAM" ;
      } elsif( $endpoint_pin =~ /\/LV[12]P[^\/]+\/[^\/]+$/ ) {
        $endpoint_block = "SRAM" ;
      } elsif( $endpoint_pin =~ /FUSEBOX/ ) {
        $endpoint_block = "FUSEBOX" ;
      } elsif( $endpoint_pin =~ /\/(CL|PR)$/ ) {
        $endpoint_block = "**async_default**" ;
      } elsif( $endpoint_pin =~ /_clockgating_[^\/]+\/EN$/ ) {
        $endpoint_block = "CG(EN)" ;
      } elsif( $endpoint_pin =~ /_clockgating_[^\/]+\/T$/ ) {
        $endpoint_block = "CG(T)" ;
      } elsif( $endpoint_pin =~ /\/[^\/]+_CG\/EN$/ ) {
        $endpoint_block = "CG(EN)" ;
      } elsif( $endpoint_pin =~ /\/[^\/]+_CG\/T$/ ) {
        $endpoint_block = "CG(T)" ;
      } elsif( $endpoint_pin =~ /\/SE$/ ) {
        $endpoint_block = "DRAM(SE)" ;
      } elsif( $endpoint_pin =~ /\/[^\/]+reg[^\/]*\/S$/ ) {
        $endpoint_block = "DFF(SE)" ;
      } elsif( $endpoint_pin =~ /\/SPARECELL_DFF[0-9][0-9]\/S$/ ) {
        $endpoint_block = "DFF(SE)" ;
      } elsif( $endpoint_pin =~ /\/SCAN_DUMMY[0-9][0-9]\/S$/ ) {
        $endpoint_block = "DFF(SE)" ;
      } elsif( $endpoint_pin =~ /\/[^\/]+reg[^\/]*\/SI$/ ) {
        $endpoint_block = "DFF(SI)" ;
      } elsif( $endpoint_pin =~ /_collar\/[^\/]+_FLOP_reg/ ) {
        $endpoint_block = "DFF(MBIST)" ;
      } elsif( $endpoint_pin =~ /\/[^\/]+reg[^\/]*\/EN$/ ) {
        $endpoint_block = "DFF(EN)" ;
      } elsif( $endpoint_pin =~ /\/[^\/]+reg[^\/]*\/D$/ ) {
        $endpoint_block = "DFF" ;
      } else {
        $endpoint_block = "?" ;
      }
    ##### ONLY FOR HYDRA2IO #####
    } elsif( $design eq "HYDRA2IO" ) {
      if( $endpoint_pin !~ /\// ) {
        $endpoint_block = "out" ;
     #} elsif( $endpoint_pin =~ /^hydra2_0\/kcore_0\// ) {
     #  $endpoint_block = "KCORE" ;
     #} elsif( $endpoint_pin =~ /^hydra2_0\/dcore_0\/dcofdm1_0\// ) {
     #  $endpoint_block = "DCOFDM1" ;
      } elsif( $endpoint_pin =~ /^TACOTAPC/ ) {
        $endpoint_block = "*TAPC*" ;
      } elsif( $endpoint_pin =~ /^[A-Z0-9]+_0_[A-Z0-9]+\/(SF|UP)_reg\// ) {
        $endpoint_block = "*BSC*" ;
      } elsif( $endpoint_pin =~ /^([^\/]+\/[^\/]+)\/\S+/ ) {
        $endpoint_block = $endpoint_pin ;
        $endpoint_block =~ s/^([^\/]+\/[^\/]+)\/\S+$/\1\/\*/ ;
      } else {
        $endpoint_block = "*TOP*" ;
      }
    ##### ONLY FOR MCTEG0 #####
    } elsif( $design eq "MCTEG0" ) {
      if(      $endpoint_pin !~ /\// ) {
               $endpoint_block = "out" ;
      } elsif( $endpoint_pin =~ /^topl\/DDRCONE\/emc\/EMC_DDR_IO_WRAPPER_R2P0\/emc_ddr_io\// ) {
               $endpoint_block = "emc_ddr_io/*" ;
      } else {
               $endpoint_block = $endpoint_pin ;
              #$endpoint_block =~ s/\/.*$// ;
              #$endpoint_block =~ s/^([^\/]+)\/\S+$/\1\/\*/ ;
               $endpoint_block =~ s/^([^\/]+\/[^\/]+)\/\S+$/\1\/\*/ ;
      }
    ##### ONLY FOR SDCHIP ##### 
    } elsif( $design eq "top" ) {
      if(      $endpoint_pin !~ /\// ) {
               $endpoint_block = "out" ;
      } elsif( $endpoint_pin =~ /^ahb2apb_/ ) {
               $endpoint_block = "ahb2apb_*" ;
      } elsif( $endpoint_pin =~ /^(ahb_[^_\/]+_).*$/ ) {
               $endpoint_block = $endpoint_pin ;
               $endpoint_block =~ s/^(ahb_[^_\/]+_).*$/\1_\*/ ; 
      } elsif( $endpoint_pin =~ /^(apb_[^_\/]+_).*$/ ) {
               $endpoint_block = $endpoint_pin ;
               $endpoint_block =~ s/^(apb_[^_\/]+_).*$/\1_\*/ ;
      } elsif( $endpoint_pin =~ /^([^\/]+)\/\S+/ ) {
               $endpoint_block = $endpoint_pin ;
               $endpoint_block =~ s/^([^\/]+)\/\S+$/\1\/\*/ ;
      } else {
               $endpoint_block = "*TOP*" ; 
      } 
    ##### DEFAULT #####
    } else {
      if( $endpoint_pin !~ /\// ) {
        $endpoint_block = "out" ;
      } else {
        $endpoint_block = $endpoint_pin ;
        $endpoint_block =~ s/\/.*$// ;
      }
    }

    $block = "$startpoint_block,$endpoint_block" ;
    if( $worst_slack{$block} eq "" ) {
      $worst_slack{$block} = 999999 ;
    }
  }

  ########################################################################
  # count stage
  #
  if( $check_stage_count == 1 ) {
    if( $is_data_path == 1 ) {
      if( / \(net\) / ) {
       #$stage_count++ ;
        $stage_count++ if( $delay > 0.000 ) ;
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
  # end of reference clock path
  #
  if( $is_magma == 1 ) {
    if( /^Reference clock path/ ) {
      $is_data_path = 0 ;
      $is_reference_clock_path = 1 ;
    }
    if( $is_reference_clock_path == 1 ) {
      if( /^$/ ) {
        $is_reference_clock_path = 0 ;
        $_ = sprintf( "  slack \(VIOLATED\) %.3f\n", $slack ) ;
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
#     $clock{$startpoint} = $startpoint_clock ;
      $clock_root_arrival{"$startpoint_pin:$startpoint_clock"} = $startpoint_clock_root_arrival ;
#     $clock{$endpoint} = $endpoint_clock ;
      $clock_root_arrival{"$endpoint_pin:$endpoint_clock"} = $endpoint_clock_root_arrival ;

      ##### check endpoints #####
     #$endpoints_per_startpoint{"$startpoint_pin:$startpoint_clock"} = $endpoints_per_startpoint{"$startpoint_pin:$startpoint_clock"} . " " . "$endpoint_pin:$endpoint_clock" ;
      $endpoints_per_startpoint{$startpoint} = $endpoints_per_startpoint{$startpoint} . " " . $endpoint ;
      $path_slack{$startpoint,$endpoint} = $slack ;
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
#if( $resolution eq "high" ) {
#printf( "\n" ) ;
#printf( " %-30s  %20s\n", "violation range", "# of violations" ) ;
#printf( " %-30s  %20s\n", "------------------------------", "--------------------" ) ;
#printf( " %-30s  %20d\n", "-0.000ns < -0.010ns", $violation_count_per_range{"0000_0010"} ) ;
#printf( " %-30s  %20d\n", "-0.010ns < -0.020ns", $violation_count_per_range{"0010_0020"} ) ;
#printf( " %-30s  %20d\n", "-0.020ns < -0.030ns", $violation_count_per_range{"0020_0030"} ) ;
#printf( " %-30s  %20d\n", "-0.030ns < -0.040ns", $violation_count_per_range{"0030_0040"} ) ;
#printf( " %-30s  %20d\n", "-0.040ns < -0.050ns", $violation_count_per_range{"0040_0050"} ) ;
#printf( " %-30s  %20d\n", "-0.050ns < -0.060ns", $violation_count_per_range{"0050_0060"} ) ;
#printf( " %-30s  %20d\n", "-0.060ns < -0.070ns", $violation_count_per_range{"0060_0070"} ) ;
#printf( " %-30s  %20d\n", "-0.070ns < -0.080ns", $violation_count_per_range{"0070_0080"} ) ;
#printf( " %-30s  %20d\n", "-0.080ns < -0.090ns", $violation_count_per_range{"0080_0090"} ) ;
#printf( " %-30s  %20d\n", "-0.090ns < -0.100ns", $violation_count_per_range{"0090_0100"} ) ;
#printf( " %-30s  %20d\n", "-0.100ns < -0.110ns", $violation_count_per_range{"0100_0110"} ) ;
#printf( " %-30s  %20d\n", "-0.110ns < -0.120ns", $violation_count_per_range{"0110_0120"} ) ;
#printf( " %-30s  %20d\n", "-0.120ns < -0.130ns", $violation_count_per_range{"0120_0130"} ) ;
#printf( " %-30s  %20d\n", "-0.130ns < -0.140ns", $violation_count_per_range{"0130_0140"} ) ;
#printf( " %-30s  %20d\n", "-0.140ns < -0.150ns", $violation_count_per_range{"0140_0150"} ) ;
#printf( " %-30s  %20d\n", "-0.150ns < -0.160ns", $violation_count_per_range{"0150_0160"} ) ;
#printf( " %-30s  %20d\n", "-0.160ns < -0.170ns", $violation_count_per_range{"0160_0170"} ) ;
#printf( " %-30s  %20d\n", "-0.170ns < -0.180ns", $violation_count_per_range{"0170_0180"} ) ;
#printf( " %-30s  %20d\n", "-0.180ns < -0.190ns", $violation_count_per_range{"0180_0190"} ) ;
#printf( " %-30s  %20d\n", "-0.190ns < -0.200ns", $violation_count_per_range{"0190_0200"} ) ;
#printf( " %-30s  %20d\n", "-0.200ns < -0.300ns", $violation_count_per_range{"0200_0300"} ) ;
#printf( " %-30s  %20d\n", "-0.300ns < -0.400ns", $violation_count_per_range{"0300_0400"} ) ;
#printf( " %-30s  %20d\n", "-0.400ns < -0.500ns", $violation_count_per_range{"0400_0500"} ) ;
#printf( " %-30s  %20d\n", "-0.500ns < -1.000ns", $violation_count_per_range{"0500_1000"} ) ;
#printf( " %-30s  %20d\n", "-1.000ns < -2.000ns", $violation_count_per_range{"1000_2000"} ) ;
#printf( " %-30s  %20d\n", "-2.000ns < -5.000ns", $violation_count_per_range{"2000_5000"} ) ;
#printf( " %-30s  %20d\n", "-5.000ns <         ", $violation_count_per_range{"5000_"} ) ;
#printf( " %-30s  %20s\n", "------------------------------", "--------------------" ) ;
#printf( " %-30s  %20d\n", "total              ", $violation_count_per_range{total} ) ;
#} else {
#printf( "\n" ) ;
#printf( " %-30s  %20s\n", "violation range", "# of violations" ) ;
#printf( " %-30s  %20s\n", "------------------------------", "--------------------" ) ;
#printf( " %-30s  %20d\n", "-0.0ns < -0.1ns", $violation_count_per_range{"0000_0100"} ) ;
#printf( " %-30s  %20d\n", "-0.1ns < -0.2ns", $violation_count_per_range{"0100_0200"} ) ;
#printf( " %-30s  %20d\n", "-0.2ns < -0.5ns", $violation_count_per_range{"0200_0500"} ) ;
#printf( " %-30s  %20d\n", "-0.5ns < -1.0ns", $violation_count_per_range{"0500_1000"} ) ;
#printf( " %-30s  %20d\n", "-1.0ns < -2.0ns", $violation_count_per_range{"1000_2000"} ) ;
#printf( " %-30s  %20d\n", "-2.0ns < -5.0ns", $violation_count_per_range{"2000_5000"} ) ;
#printf( " %-30s  %20d\n", "-5.0ns <       ", $violation_count_per_range{"5000_"} ) ;
#printf( " %-30s  %20s\n", "------------------------------", "--------------------" ) ;
#printf( " %-30s  %20d\n", "total          ", $violation_count_per_range{total} ) ;
#}
#if( $violation_count_per_range{total} == 0 ) {
#  exit ;
#}

########################################################################
# print violations per derating skew range
#
#if( $check_clock_network_delay == 1 ) {
#if( $is_timing_derate == 1 ) {
#printf( "\n" ) ;
#printf( " %-30s  %20s\n", "derating skew range", "# of violations" ) ;
#printf( " %-30s  %20s\n", "------------------------------", "--------------------" ) ;
#printf( " %-30s  %20d\n", "       < -5.0ns", $violation_count_per_derating_skew_range{"_N5000"} ) ;
#printf( " %-30s  %20d\n", "-5.0ns < -2.0ns", $violation_count_per_derating_skew_range{"N5000_N2000"} ) ;
#printf( " %-30s  %20d\n", "-2.0ns < -1.0ns", $violation_count_per_derating_skew_range{"N2000_N1000"} ) ;
#printf( " %-30s  %20d\n", "-1.0ns < -0.5ns", $violation_count_per_derating_skew_range{"N1000_N0500"} ) ;
#printf( " %-30s  %20d\n", "-0.5ns < -0.2ns", $violation_count_per_derating_skew_range{"N0500_N0200"} ) ;
#printf( " %-30s  %20d\n", "-0.2ns < -0.1ns", $violation_count_per_derating_skew_range{"N0200_N0100"} ) ;
#printf( " %-30s  %20d\n", "-0.1ns <  0.0ns", $violation_count_per_derating_skew_range{"N0100_N0000"} ) ;
#printf( " %-30s  %20d\n", " 0.0ns < +0.1ns", $violation_count_per_derating_skew_range{"P0000_P0100"} ) ;
#printf( " %-30s  %20d\n", "+0.1ns < +0.2ns", $violation_count_per_derating_skew_range{"P0100_P0200"} ) ;
#printf( " %-30s  %20d\n", "+0.2ns < +0.5ns", $violation_count_per_derating_skew_range{"P0200_P0500"} ) ;
#printf( " %-30s  %20d\n", "+0.5ns < +1.0ns", $violation_count_per_derating_skew_range{"P0500_P1000"} ) ;
#printf( " %-30s  %20d\n", "+1.0ns < +2.0ns", $violation_count_per_derating_skew_range{"P1000_P2000"} ) ;
#printf( " %-30s  %20d\n", "+2.0ns < +5.0ns", $violation_count_per_derating_skew_range{"P2000_P5000"} ) ;
#printf( " %-30s  %20d\n", "+5.0ns <       ", $violation_count_per_derating_skew_range{"P5000_"} ) ;
#printf( " %-30s  %20s\n", "------------------------------", "--------------------" ) ;
#printf( " %-30s  %20d\n", "total          ", $violation_count_per_derating_skew_range{total} ) ;
#}
#
#printf( "\n" ) ;
#printf( " %-30s  %20s\n", "original skew range", "# of violations" ) ;
#printf( " %-30s  %20s\n", "------------------------------", "--------------------" ) ;
#printf( " %-30s  %20d\n", "       < -5.0ns", $violation_count_per_original_skew_range{"_N5000"} ) ;
#printf( " %-30s  %20d\n", "-5.0ns < -2.0ns", $violation_count_per_original_skew_range{"N5000_N2000"} ) ;
#printf( " %-30s  %20d\n", "-2.0ns < -1.0ns", $violation_count_per_original_skew_range{"N2000_N1000"} ) ;
#printf( " %-30s  %20d\n", "-1.0ns < -0.5ns", $violation_count_per_original_skew_range{"N1000_N0500"} ) ;
#printf( " %-30s  %20d\n", "-0.5ns < -0.2ns", $violation_count_per_original_skew_range{"N0500_N0200"} ) ;
#printf( " %-30s  %20d\n", "-0.2ns < -0.1ns", $violation_count_per_original_skew_range{"N0200_N0100"} ) ;
#printf( " %-30s  %20d\n", "-0.1ns <  0.0ns", $violation_count_per_original_skew_range{"N0100_N0000"} ) ;
#printf( " %-30s  %20d\n", " 0.0ns < +0.1ns", $violation_count_per_original_skew_range{"P0000_P0100"} ) ;
#printf( " %-30s  %20d\n", "+0.1ns < +0.2ns", $violation_count_per_original_skew_range{"P0100_P0200"} ) ;
#printf( " %-30s  %20d\n", "+0.2ns < +0.5ns", $violation_count_per_original_skew_range{"P0200_P0500"} ) ;
#printf( " %-30s  %20d\n", "+0.5ns < +1.0ns", $violation_count_per_original_skew_range{"P0500_P1000"} ) ;
#printf( " %-30s  %20d\n", "+1.0ns < +2.0ns", $violation_count_per_original_skew_range{"P1000_P2000"} ) ;
#printf( " %-30s  %20d\n", "+2.0ns < +5.0ns", $violation_count_per_original_skew_range{"P2000_P5000"} ) ;
#printf( " %-30s  %20d\n", "+5.0ns <       ", $violation_count_per_original_skew_range{"P5000_"} ) ;
#printf( " %-30s  %20s\n", "------------------------------", "--------------------" ) ;
#printf( " %-30s  %20d\n", "total          ", $violation_count_per_original_skew_range{total} ) ;
#}

#########################################################################
## print violations per path group
##
#if( $check_path_group == 1 ) {
#printf( "\n" ) ;
#printf( " %-30s  %20s  %20s\n", "path group", "# of violations", "worst slack" ) ;
#printf( " %-30s  %20s  %20s\n", "------------------------------", "--------------------", "--------------------" ) ;
#foreach $path_group ( sort( keys %violation_count_per_path_group ) ) {
#  if( $worst_slack_per_path_group{$path_group} < 0 ) {
#    if( $path_group ne "total" ) {
#      printf( " %-30s  %20s  %20s\n", $path_group, $violation_count_per_path_group{$path_group}, $worst_slack_per_path_group{$path_group} ) ;
#    }
#  }
#}
#printf( " %-30s  %20s  %20s\n", "------------------------------", "--------------------", "--------------------" ) ;
#printf( " %-30s  %20s  %20s\n", "*", $violation_count_per_path_group{total}, $worst_slack_per_path_group{total} ) ;
#}
#
#########################################################################
## print violations per clock group
##
#printf( "\n" ) ;
#printf( " %-20s  %-20s  %20s  %20s\n", "startpoint clock", "endpoint clock", "# of violations", "worst slack" ) ;
#printf( " %-20s  %-20s  %20s  %20s\n", "--------------------", "--------------------", "--------------------", "--------------------" ) ;
#foreach $clock_group ( sort( keys %violation_count_per_clock_group ) ) {
#  if( $worst_slack_per_clock_group{$clock_group} < 0 ) {
#    if( $clock_group ne "total" ) {
#      $_ = $clock_group ;
#      split( ",", $_ ) ;
#      $startpoint_clock = $_[0] ;
#      $endpoint_clock = $_[1] ;
#      printf( " %-20s  %-20s  %20s  %20s\n", $startpoint_clock, $endpoint_clock, $violation_count_per_clock_group{$clock_group}, $worst_slack_per_clock_group{$clock_group} ) ;
#    }
#  }
#}
#printf( " %-20s  %-20s  %20s  %20s\n", "--------------------", "--------------------", "--------------------", "--------------------" ) ;
#printf( " %-20s  %-20s  %20s  %20s\n", "*", "*", $violation_count_per_clock_group{total}, $worst_slack_per_clock_group{total} ) ;
#
#########################################################################
## print violations per block
##
#if( $check_block == 1 ) {
#printf( "\n" ) ;
#printf( " %-30s  %-30s  %20s  %20s\n", "startpoint block", "endpoint block", "# of violations", "worst slack" ) ;
#printf( " %-30s  %-30s  %20s  %20s\n", "------------------------------", "------------------------------", "--------------------", "--------------------" ) ;
#foreach $block ( sort( keys %violation_count_per_block ) ) {
#  if( $worst_slack_per_block{$block} < 0 ) {
#    if( $block ne "total" ) {
#      $_ = $block ;
#      split( ",", $_ ) ;
#      $startpoint_block = $_[0] ;
#      $endpoint_block = $_[1] ;
#      printf( " %-30s  %-30s  %20s  %20s\n", $startpoint_block, $endpoint_block, $violation_count_per_block{$block}, $worst_slack_per_block{$block} ) ;
#    }
#  }
#}
#printf( " %-30s  %-30s  %20s  %20s\n", "------------------------------", "------------------------------", "--------------------", "--------------------" ) ;
#printf( " %-30s  %-30s  %20s  %20s\n", "*", "*", $violation_count_per_block{total}, $worst_slack_per_block{total} ) ;
#}
#
#########################################################################
## print violations per stage count
##
#if( $check_stage_count == 1 ) {
#printf( "\n" ) ;
#printf( " %-30s  %20s\n", "stage count", "# of violations" ) ;
#printf( " %-30s  %20s\n", "------------------------------", "--------------------" ) ;
#foreach $stage_count ( sort { $a <=> $b } keys( %violation_count_per_stage_count ) ) {
#  if( $stage_count ne "total" ) {
#    printf( " %30d  %20d\n", $stage_count, $violation_count_per_stage_count{$stage_count} ) ;
#  }
#}
#printf( " %-30s  %20s\n", "------------------------------", "--------------------" ) ;
#printf( " %-30s  %20d\n", "total          ", $violation_count_per_stage_count{total} ) ;
#}

########################################################################
# print endpoints per startpoint
#
#printf( "\n" ) ;
#printf( "<# of violations>\t<startpoint> <slack> (<stage_count>) (<clock>:<clock_network_delay>)\n" ) ;
#printf( "\t\t\t<endpoint>   <slack> (<stage_count>) (<clock>:<clock_network_delay>) (<skew>)\n" ) ;
#printf( "\n" ) ;
foreach $startpoint ( keys %endpoints_per_startpoint ) {
  @startpoint = split( /:/, $startpoint ) ;
  $startpoint_pin = @startpoint[0] ;
  $startpoint_clock = @startpoint[1] ;
  @endpoints = split( " ", $endpoints_per_startpoint{$startpoint} ) ;
#  printf( "%d\t%s %.3f", $#endpoints + 1, $startpoint_pin, $startpoint_worst_slack{$startpoint} ) ;
#  if( $check_stage_count == 1 ) {
#    printf( " (%d)", $startpoint_stage_count{$startpoint} ) ;
#  }
#  if( $check_clock_network_delay == 1 ) {
#    if( $is_timing_derate == 1 ) {
#      printf( " (%s:%.3f->%.3f)",
#        $startpoint_clock, $original_clock_network_delay{$startpoint}, $derating_clock_network_delay{$startpoint} ) ;
#    } else {
#      printf( " (%s:%.3f)",
#        $startpoint_clock, $original_clock_network_delay{$startpoint} ) ;
#    }
#  }
#  printf( "\n" ) ;
	printf( "Start_Point %s\n", $startpoint_pin ) ;

  foreach $endpoint ( @endpoints ) {
    @endpoint = split( /:/, $endpoint ) ;
    $endpoint_pin = @endpoint[0] ;
    $endpoint_clock = @endpoint[1] ;
    printf( "\t%s %.3f", $endpoint_pin, $path_slack{$startpoint,$endpoint} ) ;
#    if( $check_stage_count == 1 ) {
#      printf( " (%d)", $path_stage_count{$startpoint,$endpoint} ) ;
#    }
#    if( $check_clock_network_delay == 1 ) {
#      if( $is_timing_derate == 1 ) {
#        printf( " (%s:%.3f->%.3f)",
#          $endpoint_clock, $original_clock_network_delay{$endpoint}, $derating_clock_network_delay{$endpoint} ) ;
#        printf( " (%.3f->%.3f)",
#          $original_clock_network_delay{$endpoint} - $original_clock_network_delay{$startpoint},
#          $derating_clock_network_delay{$endpoint} - $derating_clock_network_delay{$startpoint} ) ;
#      } else {
#        printf( " (%s:%.3f)",
#          $endpoint_clock, $original_clock_network_delay{$endpoint} ) ;
#        printf( " (%.3f)",
#          $original_clock_network_delay{$endpoint} - $original_clock_network_delay{$startpoint} ) ;
#      }
#    }
    printf( "\n" ) ;

    ##### WARNING #####
    if( $path_type eq "max" ) {
      if( $delay_cell_exist{$startpoint,$endpoint} == 1 ) {
        printf( "Warning: delay cell(s) exist on path.\n" ) ;
      }
    }
  }
  printf( "\n" ) ;
}

