proc check_report_clock_timing_latency { { clock_names * } } {
  global SESSION
  global STEP

  proc print_summary { sum_file } {
    echo $sum_file
    set file [ open $sum_file r ]
    set flag 0
    while { [ gets $file line ] >= 0 } {
      if { $line == " +-----------------------------------------------------------------------------------------------------------------------------------------+ " } {
        set flag 1
      }
      if { $flag == 1 } {
        echo $line
      }
    }
    close $file
  }

  set clocks [ get_clocks $clock_names ]
  if { [ sizeof_collection $clocks ] == 0 } {
    return 0
  }
  if { [ sizeof_collection $clocks ] > 1 } {
    set all_rep_file ${SESSION}.run/report_clock_timing.${STEP}.latency.rep
    file delete -force $all_rep_file
  }

  proc find_group { clock } {
    set groups(mclk_clocks) {MDCLK MCLK GMCLK}
    set groups(pclk_clocks) {PDCLK PCLK GPCLK GP2CLK GP3CLK GP4CLK GP5CLK GP6CLK GP7CLK GP8CLK}
    set groups(uclk_clocks) {UDCLK UCLK UREGWR}
    set groups(dclk_clocks) {DDCLK DCLK DCLKDIV2 DCLKDIV2EXT DCLKOUTSRC DCLKOUT}
    set groups(lclk_clocks) {LDCLK LCLK}
    set groups(memclk_clocks) {MEMCLK GMEMDBCLK}            ;# for DDR
    set groups(miclk_clocks) {GMICLK1 MIMCLKSRC MIMCLK}     ;# for etc_mac
    set groups(pfclk_clocks) {PFCLK MVCLKN}                 ;# for pflash
    set groups(arm_clocks) {ARMCLK GSPICLK SPICLK SSPCLKSRC SSPCLK}
    set groups(xclk_clocks) {HOST_CLOCK XCLK GXCLK XDCLK SADCCLK IR0CLK IR1CLK IR2CLK GIR0CLK GIR1CLK GIR2CLK PICLK GPICLK UREGWR_IR0 UREGWR_IR1 UREGWR_IR2}
    set groups(gclk_clocks) {IN0CLK GCLK}
    set groups(vclk_clocks) {IN1CLK VCLK}
    set groups(jclk_clocks) {V_CLOCK JCLK}
    set groups(rmii_clocks) {RMIICLK RMIICLKDIV1 RMIICLKRTLDIV1 ETHTXRXCLKSRC ETHTXRXCLK }
    set groups(i2s_clocks)  {I2SCLKIN0 I2SCLKIN1 I2SCLK I2OCLKOUT}
    set groups(i2o_clocks)  {I2OCLKIN I2OCLK}
    set groups(usb_clocks)  {USB_XCLK UUruby_dft/ruby_core/usb_phy_0/sieclock_8 UUruby_dft/ruby_core/usb_phy_0/sieclock_16 UTMI0_UTMICLK UUruby_dft/ruby_core/usb_phy_1/sieclock_8 UUruby_dft/ruby_core/usb_phy_1/sieclock_16 UTMI1_UTMICLK}
    set groups(memd2_clocks) {MEMD2CLK MEMD2MID2CLK1 MEMD2MID2CLK2 MEMD2MID2CLK3 MEMD2PFCLK}
    set groups(sd_clocks) {SDCLK SDCLKOUT}

    foreach group [ array name groups ] {
      if { [lsearch $groups($group) $clock ] != -1 } {
        return $group
      } 
    }
    return "other"
  }

  foreach_in_collection clock $clocks {
    set clock_name [ get_attribute $clock full_name ]
    set group_name [ find_group $clock_name ]

    set rep_file ${SESSION}.run/report_clock_timing.${STEP}.latency.${group_name}.rep

    foreach_in_collection source [ get_attribute $clock sources ] {
      set source_name [ get_attribute $source full_name ]
  
     #echo [ format "Checking %s:%s" $clock_name $source_name ]
  
      echo "report_clock_timing -nosplit -significant_digits 3 -type latency -nworst 999999 -clock $clock_name -from $source_name" >> $rep_file
      eval "report_clock_timing -nosplit -significant_digits 3 -type latency -nworst 999999 -clock $clock_name -from $source_name" >> $rep_file
  
      if { [ sizeof_collection $clocks ] > 1 } {
        echo "report_clock_timing -nosplit -significant_digits 3 -type latency -nworst 999999 -clock $clock_name -from $source_name" >> $all_rep_file
        eval "report_clock_timing -nosplit -significant_digits 3 -type latency -nworst 999999 -clock $clock_name -from $source_name" >> $all_rep_file
      }
  
      set cells [ filter_collection [ all_fanout -flat -from $source -only_cells ] "ref_name =~ *BF111*" ]
      set root_cells {}

      foreach_in_collection clock_gating_cell $root_cells {
        set pin [ get_pins -of_objects $clock_gating_cell -filter "lib_pin_name == X" ]
        set pin_name [ get_attribute $pin full_name ]
  
       #echo [ format "Checking clock path through '%s'" $pin_name ]
  
        echo "report_clock_timing -nosplit -significant_digits 3 -type latency -nworst 999999 -clock $clock_name -from $pin_name" >> $rep_file
        eval "report_clock_timing -nosplit -significant_digits 3 -type latency -nworst 999999 -clock $clock_name -from $pin_name" >> $rep_file
  
        if { [ sizeof_collection $clocks ] > 1 } {
          echo "report_clock_timing -nosplit -significant_digits 3 -type latency -nworst 999999 -clock $clock_name -from $pin_name" >> $all_rep_file
          eval "report_clock_timing -nosplit -significant_digits 3 -type latency -nworst 999999 -clock $clock_name -from $pin_name" >> $all_rep_file
        }
      }
  
      ####################################################################################################
      # SUMMARY
      #
      set sum_file $rep_file.summary
      sh /usr/bin/perl ./tcl/check_report_clock_timing_latency.pl $rep_file > $sum_file
      print_summary $sum_file
  
      #---------------------------------------------------------------------------------------------------
      # EXCEPTION
      #
  
#     if { $clock_name == "CKEA" } {
#       set sum_file $rep_file.summary.ignore_dbtest
#       sh /usr/bin/perl /proj/T2CDS/TEMPLATES/PT/check_report_clock_timing_latency.pl $rep_file -ignore_dbtest > $sum_file
#       print_summary $sum_file
#       set sum_file $rep_file.summary.ignore_dram.ignore_dbtest
#       sh /usr/bin/perl /proj/T2CDS/TEMPLATES/PT/check_report_clock_timing_latency.pl $rep_file -ignore_dram -ignore_dbtest > $sum_file
#       print_summary $sum_file
#     }

    } ; # foreach_in_collection source
  } ; # foreach_in_collection clock

  ####################################################################################################
  # SUMMARY
  #
  if { [ sizeof_collection $clocks ] > 1 } {
    set all_sum_file $all_rep_file.summary
    sh /usr/bin/perl ./tcl/check_report_clock_timing_latency.pl $all_rep_file > $all_sum_file
    print_summary $all_sum_file
  }
}

if { 1 == 0 } {

vi /proj/T2CDS/TEMPLATES/PT/check_report_clock_timing_latency.pl

source /proj/T2CDS/TEMPLATES/PT/check_report_clock_timing_latency.tcl
check_report_clock_timing_latency CKsc

}
