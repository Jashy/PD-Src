#!/usr/bin/perl

########################################################################
# INIT
#
$min_latency_limit = 1.000 ;
$max_latency_limit = 2.000 ;

my @ignores = qw( UUruby_dft/ruby_core/ddr2_ddr3/uniquify_phy/ /metaHold_reg/ /syncdHold_reg/ /DP_dd_DLVDS_lvds_macro/ UUruby_dft/ruby_core/sys/sys_ctrl/dclkdiv2ext_reg/CK LOCKUP UUruby_dft/ruby_core/ir_0/u_ocp2regif_v1_top_u_ocp2regif_v1_16_Reg_wr_o_reg/CK UUruby_dft/ruby_core/ir_1/u_ocp2regif_v1_top_u_ocp2regif_v1_16_Reg_wr_o_reg/CK UUruby_dft/ruby_core/ir_2/u_ocp2regif_v1_top_u_ocp2regif_v1_16_Reg_wr_o_reg/CK UUruby_dft/ruby_core/eth_mac/DWC_gmac_top_DWC_gmac_inst_DWC_gmac_sma_inst_sma_data_reg_.*_/CK UUruby_dft/ruby_core/eth_mac/DWC_gmac_top_DWC_gmac_inst_DWC_gmac_sma_inst_mdc_o_reg/CK UUruby_dft/ruby_core/jpeg/u_jpeg_dec_u_jpeg_dec_do_u_jpeg_dec_dct_u_jpeg_dec_dct_core_u_jpeg_dec_dct_splitting_sp_odd_data_reg_3_/CK UUruby_dft/ruby_core/jpeg/u_jpeg_dec_u_jpeg_dec_do_u_jpeg_dec_dct_u_jpeg_dec_dct_core_u_jpeg_dec_dct_splitting_sp_odd_data_reg_6_/CK UUruby_dft/ruby_core/usb_otg_0/u_otg_U_DWC_otg_sync_pwr_U_p2hl_in_p_d_reg_0_/CK UUruby_dft/ruby_core/usb_otg_0/u_otg_U_DWC_otg_sync_pwr_U_p2hl_in_p_d_reg_1_/CK UUruby_dft/ruby_core/usb_otg_1/u_otg_U_DWC_otg_sync_pwr_U_p2hl_in_p_d_reg_0_/CK UUruby_dft/ruby_core/usb_otg_1/u_otg_U_DWC_otg_sync_pwr_U_p2hl_in_p_d_reg_1_/CK UUruby_dft/ruby_core/usb_otg_1/u_otg_U_DWC_otg_biu_U_DWC_otg_biu_ahbslv_bius_gate_hclk_tmp_reg/CK UUruby_dft/ruby_core/usb_otg_0/u_otg_U_DWC_otg_biu_U_DWC_otg_biu_ahbslv_bius_gate_hclk_tmp_reg/CK UUruby_dft/ruby_core/usb_otg_1/u_otg_U_DWC_otg_pfc_U_DWC_otg_2clkfifo_sinkbuff_U_DWC_otg_dsyncmulti1_in_p_dd_reg_2_/CK UUruby_dft/ruby_core/usb_otg_0/u_otg_U_DWC_otg_csr_txfnum_daddr_3_0_reg_0_/CK  UUruby_dft/ruby_core/spi/spi_ctrl_spi_mstr_clk_reg/CK UUruby_dft/ruby_core/spi/spi_ctrl_spi_rx_full_int_reg/CK UUruby_dft/ruby_core/image_proc/ziti_inst/uRICOTTA_uPortA_syncmux_syncmux_bit_33_muxbit_QA_reg/CK UUruby_dft/ruby_core/image_proc/ziti_inst/uRICOTTA_uPortA_syncmux_syncmux_bit_31_muxbit_QA_reg/CK  UUruby_dft/ruby_core/image_proc/ziti_inst/uRICOTTA_uPortA_syncmux_syncmux_bit_33_muxbit_QA_reg/CK UUruby_dft/ruby_core/image_proc/ziti_inst/uRICOTTA_uPortA_syncmux_syncmux_bit_31_muxbit_QA_reg/CK UUruby_dft/ruby_core/ddr2_ddr3/mim/dfi_wrlvl_strobe_phy_reg_0_/CK UUruby_dft/ruby_core/ddr2_ddr3/mim/dfi_wrlvl_load_phy_reg_2_/CK UUruby_dft/ruby_core/ddr2_ddr3/mim/dfi_wrlvl_load_phy_reg_0_/CK UUruby_dft/ruby_core/ddr2_ddr3/mim/dfi_wrlvl_strobe_phy_reg_\d_/CK .*/CKN UUruby_dft/ruby_core/ddr2_ddr3/mim/dfi_rdlvl_load_phy_reg_\d_/CK UUruby_dft/ruby_core/ddr2_ddr3/mim/dfi_wrlvl_load_phy_reg_\d_/CK UUruby_dft/ruby_core/ddr2_ddr3/mim/bus_sel_reg/CK UUruby_dft/ruby_core/sys/sys_ctrl/plldiv_memdb_pfclk/div0/pos_reg/CK UUruby_dft/ruby_core/sys/sys_ctrl/plldiv_mempll/div\d/.*CK UUruby_dft/ruby_core/sys/sys_ctrl/plldiv_mpll/div\d/.*/CK UUruby_dft/ruby_core/sys/sys_ctrl/txclk2reg_reg/CK UUruby_dft/ruby_core/sys/sys_ctrl/plldiv_ethmacclk1/div0/pos_reg/CK UUruby_dft/ruby_core/sys/sys_ctrl/plldiv_rmiipll/div0/pos_reg/CK  UUruby_dft/ruby_core/sd_mmc/U_DWC_mobile_storage_ciu_U_DWC_mobile_storage_clkcntl_clk_div_bypass_reg_0_/CK UUruby_dft/ruby_core/sd_mmc/U_DWC_mobile_storage_ciu_U_DWC_mobile_storage_clkcntl_clk_div_out_reg_0_/CK UUruby_dft/ruby_core/sys/sys_ctrl/plldiv_adcclk/div0/pos_reg/CK .*reg/EN UUruby_dft/ruby_core/sys/sys_ctrl/snps_clk_chain_3/U_shftreg_0/ff_\d/q_reg/CK UUruby_dft/ruby_core/sys/sys_ctrl/snps_clk_chain_1/U_shftreg_0/ff_\d/q_reg/CK UUruby_dft/ruby_core/sys/sys_ctrl/snps_clk_chain_2/U_shftreg_0/ff_\d/q_reg/CK UUruby_dft/ruby_core/image_proc/DIG/DP_dd_DLVDS_lvds_gen_data_cnt_reg_\d_/CK UUruby_dft/ruby_core/image_proc/DIG/DP_dd_DLVDS_lvds_gen_txptn_en_d_reg/CK UUruby_dft/ruby_core/image_proc/DIG/DP_dd_DLVDS_lvds_gen_txptn_en_dd_reg/CK UUruby_dft/ruby_core/sys/sys_ctrl/snps_clk_chain_4/U_shftreg_0/ff_\d/q_reg/CK UUruby_dft/ruby_core/sys/sys_ctrl/snps_clk_chain_5/U_shftreg_0/ff_\d/q_reg/CK UUruby_dft/ruby_core/sys/sys_ctrl/snps_clk_chain_0/U_shftreg_0/ff_\d/q_reg/CK UUruby_dft/ruby_core/usb_otg_0/u_otg_U_DWC_otg_aiu_U_DWC_otg_aiu_dsch_bium_dma_count_reg_\d_/CK );

########################################################################
# USAGE
#
sub print_usage ( ) {
  printf( "Usage: %s <report_file> [-ignore_dbtest] [-ignore_dram] [-ignore_sram] [-ignore_fuse] [-ignore_bsc] [-ignore_adc]\n", "check_report_clock_timing_latency.pl" ) ;
}

########################################################################
# CHECK ARGUMENTS
#
while( $arg_count <= $#ARGV ) {
  if( $ARGV[$arg_count] =~ m/^-/ ) {
    if( "-help" =~ $ARGV[$arg_count] ) {
      print_usage ;
      exit ;
    }
    if( "-ignore_dbtest" =~ $ARGV[$arg_count] ) {
      $ignore_dbtest = 1 ;
    }
    if( "-ignore_dram" =~ $ARGV[$arg_count] ) {
      $ignore_dram = 1 ;
    }
    if( "-ignore_sram" =~ $ARGV[$arg_count] ) {
      $ignore_sram = 1 ;
    }
    if( "-ignore_fuse" =~ $ARGV[$arg_count] ) {
      $ignore_fuse = 1 ;
    }
    if( "-ignore_bsc" =~ $ARGV[$arg_count] ) {
      $ignore_bsc = 1 ;
    }
    if( "-ignore_adc" =~ $ARGV[$arg_count] ) {
      $ignore_adc = 1 ;
    }
  } else {
    $report_file = $ARGV[$arg_count] ;
  }
  $arg_count++ ;
}

if( $report_file eq "" ) {
  print_usage ;
  exit ;
}

########################################################################
# PARSE REPORT
#
open( REP, "< $report_file" ) ;
while( <REP> ) {
  if( /\s+-clock\s+(\S+)\s+-from\s+(\S+)\s*$/ ) {
    ( $clock_name, $source_name ) = /\s+-clock\s+(\S+)\s+-from\s+(\S+)\s*$/ ;
    $min_latency{$source_name} =  999.999 ;
    $max_latency{$source_name} = -999.999 ;
    $source_names{$clock_name} = $source_names{$clock_name} . " " . $source_name ;
    $source_names{$clock_name} =~ s/^\s+// ;
    printf( "\n" ) ;
    printf( " -------------------------------------------------------------------------------------- \n" ) ;
    printf( " %s (%s)\n", $source_name, $clock_name ) ;
    printf( "\n" ) ;
  }
  if( /^\s+(\S+)\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\S+)/ ) {
    ( $pin_name, $dummy1, $dummy2, $dummy3, $latency ) = /^\s+(\S+)\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\S+)/ ;

  ####################################################################################################
  # IGNORE PATICULAR LEAF PINS
  #
  my $is_ignore = 0;
  foreach my $ignore ( @ignores ) {
    if ( $pin_name =~ /$ignore/ ) {
      $is_ignore = 1;
    }
  }
  next if ( $is_ignore );
  #next if ( $pin_name =~ /UUruby_dft\/ruby_core\/ddr2_ddr3\/uniquify_phy/ );
  #next if ( $pin_name =~ /\/metaHold_reg\// );
  #next if ( $pin_name =~ /\/syncdHold_reg\// );

  ####################################################################################################

    if( $latency > $max_latency{$source_name} ) {
      $max_latency{$source_name} = $latency ;
      $max_latency_pin_name{$source_name} = $pin_name ;
    }
    if( $latency < $min_latency{$source_name} ) {
      $min_latency{$source_name} = $latency ;
      $min_latency_pin_name{$source_name} = $pin_name ;
    }
    if( $lantecy > $max_latency_limit ) {
      printf( " %.3f %s\n", $latency, $pin_name ) ;
    }
    if( $lantecy < $min_latency_limit ) {
      printf( " %.3f %s\n", $latency, $pin_name ) ;
    }
   #$count_by_clock{$clock_name}++ ;
   #$count_by_source{$source_name}++ ;
    $count_by_clock_source{"$clock_name:$source_name"}++ ;
  }
}
close( REP ) ;

########################################################################
# SUMMARY
#
print << "EOF" ;
 +---------------------------------------------------------------------------------------------------------------------------------------------------+ 
 | clock           | source                                                                      |    # of ff |        min |        max |       skew | 
 |-----------------+-----------------------------------------------------------------------------+------------+------------+------------+------------| 
EOF
foreach $clock_name ( sort( keys( %source_names ) ) ) {
  foreach $source_name ( split( /\s+/, $source_names{$clock_name} ) ) {
    $skew{$source_name} = $max_latency{$source_name} - $min_latency{$source_name} ;
    if( $skew{$source_name} > 0 ) {
      $print_clock_name = $clock_name ;
      $print_clock_name = "Phy_Clock" if( $print_clock_name eq "d2986/top/sc/susb/u_phy_top/u_SC900YX00010/Phy_Clock" ) ;
      $print_clock_name = "PHY_CLOCK" if( $print_clock_name eq "d2986/top/sc/susb/u_phy_top/u_SC900YX00010/PHY_CLOCK" ) ;
      if( $is_not_source{$clock_name} == 1 ) {
        printf( " | %-15s |  %-74s | %10d | %10.3f | %10.3f | %10.3f | \n",
          $print_clock_name, $source_name, $count_by_clock_source{"$clock_name:$source_name"},
          $min_latency{$source_name}, $max_latency{$source_name}, $skew{$source_name} ) ;
      } else {
        printf( " | %-15s | %-75s | %10d | %10.3f | %10.3f | %10.3f | \n",
          $print_clock_name, $source_name, $count_by_clock_source{"$clock_name:$source_name"},
          $min_latency{$source_name}, $max_latency{$source_name}, $skew{$source_name} ) ;
        $is_not_source{$clock_name} = 1 ;
      }
    }      
  }
}
print << "EOF" ;
 +---------------------------------------------------------------------------------------------------------------------------------------------------+ 
EOF

