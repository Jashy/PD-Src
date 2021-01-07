
set ECO_STRING ANA_ISO

set anacells "UUruby_dft/ruby_core/usb_phy_1
UUruby_dft/ruby_core/dac4ch_1/slowdacq8
UUruby_dft/ruby_core/adc8ch/garnet_saradc10
UUruby_dft/ruby_core/sys/sys_ctrl/DCLKPLL
UUruby_dft/ruby_core/sys/sys_ctrl/AFECLKPLL
UUruby_dft/ruby_core/sys/sys_ctrl/ARMCLKPLL
UUruby_dft/ruby_core/sys/sys_ctrl/MCLKPLL
UUruby_dft/ruby_core/sys/sys_ctrl/garnet_ref_and_reset
UUruby_dft/ruby_core/sys/sys_ctrl/RMIICLKPLL
UUruby_dft/ruby_core/sys/sys_ctrl/MEMCLKPLL
UUruby_dft/ruby_core/dac4ch_0/slowdacq8
UUruby_dft/ruby_core/usb_phy_0"


foreach cell $anacells {
  foreach_in_collection pin [ get_pins -of $cell -filter "direction != inout" ] {
    set net [ get_nets -of $pin -top -seg -quiet ]
    set pin_name [ get_attr $pin full_name ]
    if { [ sizeof_collection $net ] == 0 } { continue }
    set dir [ get_attr $pin direction ]
    INSERT_BUFFER $pin_name CLKBUFV8 -place
#    if { $dir == "out" } {
#      INSERT_BUFFER $pin_name CLKBUFV8 -place
#    } else {
#      
#      #if { [ sizeof_collection [ get_pins -of $net -leaf -filter "direction == out" ] ] == 0 } {
#      #  puts [ get_attr $pin full_name ]
#      #} else {
#      #set driver [ get_cells -of [ get_drivers $net ] ]
#      #puts [ get_attr $driver full_name]
#      #}
#    }
  }
}

set_attribute  [get_cells *ANA_ISO* -hierarchical] is_fixed true
set_dont_touch [get_cells *ANA_ISO* -hierarchical] 

#set_attribute  [get_cells *ANA_ISO* -hierarchical] is_fixed false
#legalize_placement -cells [get_cells *ANA_ISO* -hierarchical] -priority high
#set_attribute  [get_cells *ANA_ISO* -hierarchical] is_fixed true

foreach_in_collection cell [ get_cells pad_i1/* ] {
  set out [ get_pins -of $cell -filter "direction == out" ]
  set in  [ get_pins -of $cell -filter "direction == in" ]
  puts "*INFO* [ get_attr $cell full_name ]"
  set out_port [ get_ports -of [ get_nets -of $out -seg ] -quiet ]
  set in_port  [ get_ports -of [ get_nets -of $in  -seg ] -quiet ]
  if { [ sizeof_collection $out_port ] == 0 && [ sizeof_collection $in_port ] == 0} {
    continue
  }

  if { [ sizeof_collection $out_port ] == 1 } {
    
  } else {
    set net [ get_nets -of $in_port -top -seg ]
  }
}



