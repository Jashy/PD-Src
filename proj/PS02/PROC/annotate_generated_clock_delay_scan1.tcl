  
  set ECO_STRING ALCP_CTS
  set pin_names "MIREFCLK_eco_mux_U1"

  foreach_in_collection cell [ get_cells -hier *SCAN_AC_ECO* ] {
    set pin [ get_pins -of $cell -filter "direction == out" ]
    set pin_name [ get_attr $pin full_name ]
    if { [ string match "UUruby_dft/ruby_core/image_proc/*" $pin_name ] == 1 } { continue }
    if { [ string match "UUruby_dft/ruby_core/arm926/*" $pin_name ] == 1 } { continue }
    set pin_names [ concat $pin_names $pin_name ]
  }

  foreach_in_collection cell [ get_cells -hier *SCAN_DC_ECO* ] {
    set pin [ get_pins -of $cell -filter "direction == out" ]
    set pin_name [ get_attr $pin full_name ]
    if { [ string match "UUruby_dft/ruby_core/image_proc/*" $pin_name ] == 1 } { continue }
    if { [ string match "UUruby_dft/ruby_core/arm926/*" $pin_name ] == 1 } { continue }
    set pin_names [ concat $pin_names $pin_name ]
  }

  foreach_in_collection cell [ get_cells -hier *SCAN_ECO* ] {
    set pin [ get_pins -of $cell -filter "direction == out" ]
    set pin_name [ get_attr $pin full_name ]
    if { [ string match "UUruby_dft/ruby_core/image_proc/*" $pin_name ] == 1 } { continue }
    if { [ string match "UUruby_dft/ruby_core/arm926/*" $pin_name ] == 1 } { continue }
    if { [ string match "*IP_SCAN_ECO*" $pin_name ] == 1 } { continue }
    set pin_names [ concat $pin_names $pin_name ]
  }


  foreach pin $pin_names {
    set_clock_tree_exceptions -dont_touch_subtre ${pin}/I1 
puts "set_clock_tree_exceptions -dont_touch_subtre ${pin}/I1"
  }
