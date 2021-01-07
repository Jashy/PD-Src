set fr [ open tcl/isolation.tcl w ]
foreach_in_collection cells [ get_cells -hier *ISO* ] {
       set cell [ get_attr $cells full_name ]
       set cell_basename [ get_attr $cells name ]
       set ref [ get_attr $cells ref_name ]
       #set net [ get_attr [ get_nets -of_objects [ get_pins $cell/Z ] ] full_name ]
       #set net [ get_attr [ get_nets -of_objects [ get_pins $cell/I ] ] full_name ]
       #set pin [ get_attr [ all_fanout -from $net -level 0 ] full_name ]
       #set pin [ get_attr [ all_fanin -to $net -level 0 ] full_name ]
       set x [ lindex [ get_location $cell ] 0 ]
       set y [ lindex [ get_location $cell ] 1 ]
       set coordinates [ concat $x $y ]
       set direction [ get_attr $cell orientation ]
       if { [ regexp {ISO_IP_ADC12_(\S+)} $cell "" pin1 ] } { set pin gaia_0/gadc_0/adc12_0/$pin1 }
       if { [ regexp {ISO_IP_ADC10_(\S+)} $cell "" pin1 ] } { set pin gaia_0/gramon_0/adc10_0/$pin1 }
       if { [ regexp {ISO_IP_OSC_(\S+)} $cell "" pin1 ] } { set pin osc_0/$pin1 }
       if { [ regexp {ISO_IP_PLL_(\S+)} $cell "" pin1 ] } { set pin gaia_0/gclkgen_0/pll_0/$pin1 }
       if { [ regexp {ISO_IO_(\S+)_(\S+)} $cell "" cell1 pin1 ] } { set pin $cell1/$pin1 }
       if { [ regexp {special_out_(ISO_IO_\S+)_(\S+)} $cell "" cell1 pin1 ] } { set pin $cell1/$pin1 }
       if { [ regexp {special_in_ISO_IO_(\S+)_(\S+)} $cell "" cell1 pin1 ] } { set pin $cell1/$pin1 }
         
       puts $fr "# $cell_basename"
       puts $fr "insert_buffer -new_net_names $cell_basename -new_cell_names $cell_basename \[ get_pins $pin \] tcbn65lpwcl/$ref  -location {$coordinates} -orientation $direction"
}
#foreach_in_collection cells [ get_cells -hier *DUMMY_MACRO* ] {
#       set cell [ get_attr $cells full_name ]
#       set cell_basename [ get_attr $cells name ]
#       set ref [ get_attr $cells ref_name ]
#       set pin [ get_attr [ all_fanin -to $net -level 0 ] full_name ]
#       set x [ lindex [ get_location $cell ] 0 ]
#       set y [ lindex [ get_location $cell ] 1 ]
#       set coordinates [ concat $x $y ]
#       set direction [ get_attr $cell orientation ]
#       puts $fr "# $cell_basename"
#       puts $fr "insert_buffer -new_net_names $cell_basename -new_cell_names $cell_basename \[ get_pins -of_objects $pin \] tcbn65lpwcl/$ref  -location {$coordinates} -orientation $direction"
close $fr
