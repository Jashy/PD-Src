proc INSERT_BUFFER { args } {
  ########################################################################
  # USAGE
  #
  proc usage_INSERT_BUFFER { } {
    puts {Usage: INSERT_BUFFER <pin> <buf_model_name> [-location {<x> <y>}] [-place_on_pin]} 
  }

  ########################################################################
  # GET ARGUMENTS
  set arg_count 0
  #set place_on_pin 0
  while { $arg_count < [ llength $args ] } {
	    if { [ regexp -- {^-} [ lindex $args $arg_count ] ] == 1 } {
		      if { [ regexp -- [ lindex $args $arg_count ] {-help} ] == 1 } {
				usage_INSERT_BUFFER
				return
		      }
		      if { ( [ regexp -- [ lindex $args $arg_count ] {-location} ] == 1 ) || ( [ regexp -- [ lindex $args $arg_count ] {-xy} ] == 1 ) } {
				incr arg_count
				set location [ lindex $args $arg_count ]
				if { [ llength $location ] != 2 } {
					  usage_INSERT_BUFFER
					  return
				}
			incr arg_count
			continue
		      }
		      if { ( [ regexp -- [ lindex $args $arg_count ] {-place_on_pin} ] == 1 ) || ( [ regexp -- [ lindex $args $arg_count ] {-place_at_pin} ] == 1 ) } {
				set place_on_pin 1
				incr arg_count
				continue
		      }
		    } else {
			if { [ info exists pin ] == 0 } {
				    set pin [ lindex $args $arg_count ]
				    incr arg_count
				    continue
			}
			if { [ info exists buf_model_name ] == 0 } {
				    set buf_model_name [ lindex $args $arg_count ]
				    incr arg_count
				    continue
			}
	      }   
    usage_INSERT_BUFFER
    return
  }

  if { [ info exists pin ] == 0 } {
	    puts [ format "Error: <pin> not specified." ]
	    usage_INSERT_BUFFER
	    return
  }

  if { [ info exists buf_model_name ] == 0 } {
	    puts [ format "Error: <buf_model_name> not specified." ]
	    usage_INSERT_BUFFER
	    return
  }

  ########################################################################
  # PLACE AT PIN
  #
  if { ( [ info exists place_on_pin ] == 1 ) && ( [ info exists location ] == 0 ) } {
	    puts "INFO: Place on pin"
	    set location [ lindex [get_attr [get_pins $pin]  bbox] 0 ]
  }

#
#
  global ECO_STRING
  if { [ info exists ECO_STRING ] == 0 } {
	    set DATE [ sh date +%y%m%d ]
	    set ECO_STRING ALCHIP_$DATE
  }
#
  puts [ format "INSERT_BUFFER %s" $args ]
#
#  ########################################################################
#  # CHECK OBJECTS
#  #
  if { [ llength [get_pins $pin -q ]] == 0 } {
	puts [ format "Error: Cannot find pin '%s'." $pin]
	return
  }
  set buf_model_name [ get_model $buf_model_name ]
  if { [ llength [get_lib_cells $buf_model_name -q ]] == 0 } {
	    puts [ format "Error: Cannot find lib cell '%s'." $buf_model_name]
	    return
  }

  ########################################################################
  # MAKE CHANGES
  #
  # reconnect given pins

  # create new cell
  set pin_hier [ split $pin "/" ]
  set net      [ get_nets -of $pin ]
  set cell_name [ get_attr [ get_cells -of $pin ] full_name ]

  set eco_count 0
  set base_full_name [ join [ concat $cell_name [ lindex $pin_hier end ] ] "_" ]
  regsub [ format {_%s_U[0-9][0-9]*$} $ECO_STRING ] $base_full_name "" base_full_name
  set new_full_cell_name [ format "%s_%s_U%s" $base_full_name $ECO_STRING $eco_count]
  while { [ sizeof_collection [ get_cells $new_full_cell_name -quiet ] ] != 0 } {
	    incr  eco_count
	    regsub [ format {_%s_U[0-9][0-9]*$} $ECO_STRING ] $base_full_name "" base_full_name
	    set new_full_cell_name [ format "%s_%s_U%s" $base_full_name $ECO_STRING $eco_count]
  }

  # create new net
  set eco_count 0
  set base_full_name [ join [ concat $cell_name [ lindex $pin_hier end ] ] "_" ]
  regsub [ format {_%s_U[0-9][0-9]*$} $ECO_STRING ] $base_full_name "" base_full_name
  set new_full_net_name [ format "%s_%s_n%s" $base_full_name $ECO_STRING $eco_count]
  while { [ sizeof_collection [ get_nets $new_full_net_name -quiet ] ] != 0 } {
	    incr  eco_count
	    regsub [ format {_%s_U[0-9][0-9]*$} $ECO_STRING ] $base_full_name "" base_full_name
	    set new_full_net_name [ format "%s_%s_n%s" $base_full_name $ECO_STRING $eco_count]
  }

  disconnect_net $net $pin
  create_cell $new_full_cell_name $buf_model_name
  create_net $new_full_net_name
  if { [ get_attr [ get_pins $pin ] direction ] == "in" } {
	    connect_net $new_full_net_name $pin
	    connect_net $new_full_net_name [ get_pins -of $new_full_cell_name -filter "direction == out" ]
	    connect_net $net [ get_pins -of $new_full_cell_name -filter "direction == in" ]
  } else {
	    connect_net $new_full_net_name $pin
	    connect_net $new_full_net_name [ get_pins -of $new_full_cell_name -filter "direction == in" ]
	    connect_net $net [ get_pins -of $new_full_cell_name -filter "direction == out" ]
  }
  if { [ info exists location ] == 1 } {
	      move_object $new_full_cell_name -x [ lindex $location 0 ] -y [ lindex $location 1 ] -ignore
  } 
  return $new_full_cell_name
}

