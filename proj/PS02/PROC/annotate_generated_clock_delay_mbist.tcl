  
  set ECO_STRING ALCP_CTS
  set pin_names ""


  set allpins [ add_to_collection [ all_fanout -from bist_clk_6_sel/Z -flat -endpoints_only ] [ all_fanout -from bist_clk_5_sel/Z -flat -endpoints_only ] ]
  foreach_in_collection pin $allpins {
    set cell [ get_cells -of $pin ]
    set ref_name [ get_attr $cell ref_name ]
    if { [ regexp {MUX} $ref_name ] != 1 } { continue }
    set cell_name [ get_attr $cell full_name]
    if { [ string match "UUruby_dft/ruby_core/image_proc/*" $cell_name ] == 1 } { continue }
    if { [ string match "UUruby_dft/ruby_core/arm926/*"     $cell_name ] == 1 } { continue }
    set pin_name [ get_attr [ get_pins -of $cell -filter "direction ==out"] full_name ]
    set pin_names [ concat $pin_names $pin_name ]
  }

  remove_clock *
  remove_case_analysis -all
  set is_macro 0
  set input_pin_name ""
  foreach pin_name $pin_names {
    set is_macro 0
    set pin [ get_pins $pin_name ]
    set cell [ get_cells -of $pin ]
    set cell_name [ get_attr $cell full_name ]
    set ref_name [ get_attr $cell ref_name ]
    if { [ regexp {MUX} $ref_name ] == 1 } {
      set input_pin_name ${cell_name}/I0
    } else {
      if { [ sizeof_collection [ get_pins ${cell_name}/CK -quiet ] ] != 0 } {
        set input_pin_name ${cell_name}/CK
      } elseif { [ sizeof_collection [ get_pins ${cell_name}/CKN -quiet ] ] != 0 } {
        set input_pin_name ${cell_name}/CKN
      } elseif { [ sizeof_collection [ get_pins -of ${cell_name} -filter "direction == in" ] ] == 1 } {
        set input_pin_name [ get_attr [ get_pins -of ${cell_name} -filter "direction == in" ] full_name ]
      } else {
        set is_macro 1
        puts "*INFO* regard $cell_name ($ref_name) as macro"
      }
    }
    if { $is_macro == 0 } {
      set iso_buffer [ INSERT_BUFFER $input_pin_name CLKBUFV12 -place ]
      create_clock -name "CTS_$input_pin_name" -period 10 [ get_pins -of $iso_buffer -filter "direction == out " ]
      puts "*INFO* create_clock CTS_$input_pin_name"
    } else {
      create_clock -name "CTS_$pin_name" -period 10 [ get_pins -of $pin_name ]
      puts "*INFO* create_clock CTS_$pin_name"
    }
  }

  set_propagated_clock [ get_clocks CTS* ]

  exec rm -rf skew.rpt

  foreach_in_collection clock [ get_clocks CTS* ] {
    report_clock_timing -clock $clock -type skew -no >> skew.rpt
  }
  set of [ open skew.rpt r ]
  set out [ open set_clock_tree_exceptions.tcl a ]
  set clock_name ""
  set min ""
  set max ""
#  UUruby_dft/ruby_core/usb_otg_1/u_otg_U_DWC_otg_pfc_U_DWC_otg_pfc_tknreq_chnl_ep_type_d_reg_1_/CK 0.531 rp-+
#  UUruby_dft/ruby_core/usb_otg_1/u_otg_U_DWC_otg_mac_U_DWC_otg_mac_pie_xfer_resp_reg_0_/CK 0.411 -0.000 0.120 rp-+
  set ready 0
  while { [ gets $of line ] >= 0 } {
    if { [ regexp {^\s+Clock:\s+CTS_(\S+)} $line "" clock_name ] == 1 } { incr ready }
    if { [ regexp {^\s+\S+\s+(\S+)\s+w\Sp\-\+} $line "" max ] == 1 }  { incr ready }
    if { [ regexp {^\s+\S+\s+(\S+)\s+\S+\s+\S+\s+w\Sp\-\+} $line "" min ] == 1 }  { incr ready }
    if { $ready == 3 } {
      set max [ AbsMax $min $max ]
      set min [ AbsMin $min $max ]
      set cell [ get_cells -of $clock_name ]
      set inputs [ get_pins -of $cell -filter "direction == in" ]
      set ref_name [ get_attr $cell ref_name ]
      if { [ regexp {MUX} $ref_name ] == 1 } {
        foreach_in_collection input $inputs {
          if { [ expr $max - $min ] > 0.2 } {
            puts $out "# $input_name [ expr $max - $min ]"
            set min [ expr $max - 0.2 ]
          }
          set input_name [ get_attr $input full_name ]
          set command "set_clock_tree_exceptions -float_pins $input_name -float_pin_max_delay_rise $max -float_pin_max_delay_fall $max -float_pin_min_delay_rise $min -float_pin_min_delay_fall $min"
          puts $command
          puts $out $command
          eval $command
        }
      } else {
        if { [ expr $max - $min ] > 0.2 } {
          puts $out "# $clock_name [ expr $max - $min ]"
          set min [ expr $max - 0.2 ]
        }
        set command "set_clock_tree_exceptions -float_pins $clock_name -float_pin_max_delay_rise $max -float_pin_max_delay_fall $max -float_pin_min_delay_rise $min -float_pin_min_delay_fall $min"
        puts $command
        puts $out $command
        eval $command
      }
      set ready 0
    }
  }
  close $of
  close $out

  REMOVE_BUFFER [ get_cells *${ECO_STRING}* -hier ]
