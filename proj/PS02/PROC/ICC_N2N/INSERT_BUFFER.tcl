proc INSERT_BUFFER { args } {

  ########################################################################
  # USAGE
  #
  proc usage_INSERT_BUFFER { } {
    puts {Usage: INSERT_BUFFER <pin> <buf_model_name> [-location {<x> <y>}] } 
  }

  ########################################################################
  # GET ARGUMENTS
  #
  set arg_count 0
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
          usage_SPLIT_NET
          return
        }
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
  if { [ llength [get_lib_cells $buf_model_name -q ]] == 0 } {
    puts [ format "Error: Cannot find lib cell '%s'." $buf_model_name]
    return
  }

  ########################################################################
  # MAKE CHANGES
  #
  # reconnect given pins
    if { [ info exists location ] == 1 } {
        set command "insert_buffer $pin $buf_model_name -location \[ list $location \]"
        puts $command
        eval $command
    } else {
        set command "insert_buffer $pin $buf_model_name "
        puts $command
        eval $command
#        set driver_pin_location_X [ lindex [ lindex [get_attribute $pin bbox] 0 ] 0 ] 
#        set driver_pin_location_Y [ lindex [ lindex [get_attribute $pin bbox] 0 ] 1 ]
#        set drvier_cell [get_cells -of [ get_pins $pin ] ]
#        set driver_cell_orientation [get_attribute  $drvier_cell orientation ]
#        set new_buffer_drive_pins  [remove_from_collection [get_pins -leaf -of [get_net -seg -top -of [get_pin $pin]]] $pin]
#        set new_drive_buffer_cell [get_cell -of [get_pin $new_buffer_drive_pins]]
#        set new_drive_buffer_cell_name [get_attribute $new_drive_buffer_cell full_name]
#        set_attribute -quiet [ get_cells $new_drive_buffer_cell_name ] origin [list $driver_pin_location_X $driver_pin_location_Y ]
#        set_attribute -quiet [ get_cells $new_drive_buffer_cell_name ] orientation $driver_pin_cell_orientation
    }
}
