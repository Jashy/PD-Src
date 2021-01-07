proc REMOVE_REPEATER { args } {
  ########################################################################
  # USAGE
  #
  proc usage_REMOVE_REPEATER { } {
    puts {Usage: REMOVE_REPEATER <cell_name>}
  }

  ########################################################################
  # GET ARGUMENTS
  #
  set arg_count 0
  while { $arg_count < [ llength $args ] } {
    if { [ regexp -- {^-} [ lindex $args $arg_count ] ] == 1 } {
      if { [ regexp -- [ lindex $args $arg_count ] {-help} ] == 1 } {
        usage_REMOVE_REPEATER
        return
      }
    } else {
      if { [ info exists cell_name ] == 0 } {
        set cell_name [ lindex $args $arg_count ]
        incr arg_count
        continue
      }
    }
    usage_REMOVE_REPEATER
    return
  }

  if { [ info exists cell_name ] == 0 } {
    usage_REMOVE_REPEATER
    return
  }

  global ECO_STRING
  if { [ info exists ECO_STRING ] == 0 } {
    set DATE [ sh date +%y%m%d ]
    set ECO_STRING ALCHIP_ECO_$DATE
  }
   

  ########################################################################
  # CHECK OBJECTS
  #
  if {  [ llength [get_cells $cell_name -q ]] == 0  } {
    puts [ format "Error: Cannot find cell '%s'." $cell_name ]
    return
  }
  puts [ format "REMOVE_REPEATER %s" $args ]
  ########################################################################
  # Make change
  #
  
  foreach_in_collection  pin [get_pins -of $cell_name] {
    set pin_full_name [get_attribute $pin full_name]
    switch [ get_attribute $pin_full_name direction ] {
        "in" {
            set in_net_name [get_nets -of $pin_full_name]
            set drive_pin [filter_collection [get_pins  -of $in_net_name -leaf -q] "direction==out"]
            set drive_pin_name [get_attribute $drive_pin full_name]
            disconnect_net $in_net_name $pin_full_name
        }
        "out" {
            set out_net_name [get_nets -of $pin_full_name]
            set load_pins [filter_collection [get_pins  -of $out_net_name -leaf -q] "direction==in"]
            disconnect_net $out_net_name $pin_full_name
        }
   }
 }  
   set command "remove_cell $cell_name"
   puts $command
   eval $command

   foreach_in_collection pin $load_pins {
            set pin_full_name [get_attribute $pin full_name]
            disconnect_net [get_nets -of $pin_full_name]  $pin
            connect_pin -from $pin  -to $drive_pin_name -port ${ECO_STRING}
   }
   remove_net $out_net_name  
}

