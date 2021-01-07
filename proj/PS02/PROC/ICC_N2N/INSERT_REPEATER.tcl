proc INSERT_REPEATER { args } {

  ########################################################################
  # USAGE
  #
  proc usage_INSERT_REPEATER { } {
    puts {Usage: INSERT_REPEATER <pin> <buf_model_name> [-name <cell_name>] [-num <n>] [-location {<x> <y>}] } 
  }

  ########################################################################
  # GET ARGUMENTS
  #
  set arg_count 0
  while { $arg_count < [ llength $args ] } {
    if { [ regexp -- {^-} [ lindex $args $arg_count ] ] == 1 } {
        if { [ regexp -- [ lindex $args $arg_count ] {-help} ] == 1 } {
            usage_INSERT_REPEATER
            return
        }

        if { ( [ regexp -- [ lindex $args $arg_count ] {-num} ] == 1 ) } {
            incr arg_count
            set cell_count [ lindex $args $arg_count ]
            incr arg_count
            continue
        }
        
        if { ( [ regexp -- [ lindex $args $arg_count ] {-location} ] == 1 ) } {
            incr arg_count
            set location [ lindex $args $arg_count ]
            if { ([expr [ llength $location ] % 2 ] != 0) || ([ llength $location ] < 2) } {
                usage_SPLIT_NET
                return
            }
            incr arg_count
            continue
        }

        if {[regexp -- [ lindex $args $arg_count ] {-name}] == 1} {
            incr arg_count
            set cell_name [ lindex $args $arg_count ]
            if { ([ llength $cell_name ] == 0) || ( [regexp -- $cell_name {-location|-num}] == 1) } {
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
    usage_INSERT_REPEATER
    return
  }

  if { [ info exists pin ] == 0 } {
    puts [ format "Error: <pin> not specified." ]
    usage_INSERT_REPEATER
    return
  }
  if { [ info exists buf_model_name ] == 0 } {
    puts [ format "Error: <buf_model_name> not specified." ]
    usage_INSERT_REPEATER
    return
  }

#
  global ECO_STRING
  if { [ info exists ECO_STRING ] == 0 } {
    set DATE [ sh date +%y%m%d ]
    set ECO_STRING ALCHIP_ECO_$DATE
  }
  if { [ info exists cell_count ] == 0 } {
       set  cell_count 1;
  }
#
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
  if { [ info exists cell_name ] == 1} {
      if { [llength [get_cells $cell_name -q ]] != 0} {
        puts [format "Error: The cell '%s' already exists." $cell_name]
        return
      }
      set hier_name  [join [lrange [split  $cell_name {/}] 0 end-1] {/}]
      if { ([llength $hier_name] != 0) && ([llength [get_cells $hier_name -q ]] == 0) } {
            puts [ format "Error: Cannot find hier cell '%s'." $hier_name]
            return
      }
      set cell_name_last [lindex [split  $cell_name {/}] end]
      if { [string match {[/0-9-]*} $cell_name_last] == 1} {
        puts [format "Error: The cell name '%s' is illegal." $cell_name_last]
        return
      }
   }

  puts [ format "INSERT_REPEATER %s" $args ]
  ########################################################################
  # MAKE CHANGES
  #
  # reconnect given pins
  set net_name [get_attribute [get_nets -top -seg -of $pin -q] full_name]
  set pin_full_name [get_attribute $pin full_name] 
  set base_cell_name $net_name
  if {[ info exists cell_name ] == 0} {
    set new_cell_name [ format "%s_%s_U" $base_cell_name $ECO_STRING ]
  } else {
    set new_cell_name $cell_name
  }
     
  set pin_direction [ get_attribute $pin_full_name direction ]
  if { $pin_direction == "in"} {
    set drive_pins [filter_collection [get_pins  -of $net_name -leaf -q] "direction==out"]    
    disconnect_net [get_nets -of $pin_full_name] $pin_full_name
    for {set i 0} {$i < $cell_count} {incr i} {
        set new_cell_name_tmp [ format "%s_%s" $new_cell_name $i]
        create_cell $new_cell_name_tmp $buf_model_name
        set input_pin [get_pins -of $new_cell_name_tmp -filter "direction == in"]
        set output_pin [get_pins -of $new_cell_name_tmp -filter "direction == out"]
        connect_pin -from $pin -to $output_pin -port_name $ECO_STRING
        set pin $input_pin
    }        
    foreach_in_collection pin_t $drive_pins {
        disconnect_net [get_nets -of $pin_t]  $pin_t
        connect_pin -from $pin  -to $pin_t -port ${ECO_STRING}
    }
    if { [info exists location] == 1 } {
        for {set i 0} {$i < $cell_count} {incr i} {
            set new_cell_name_tmp [ format "%s_%s" $new_cell_name $i]
            set location_tmp [lrange $location [expr $i*2] [expr [expr $i*2] + 1]] 
            if { [llength $location_tmp] != 0} {
                set_cell_location    $new_cell_name_tmp -coordinates "$location_tmp"
            }
        }
    }
  } else {
    set load_pins [filter_collection [get_pins  -of $net_name -leaf -q] "direction==in"]
    disconnect_net [get_nets -of $pin_full_name] $pin_full_name
    for {set i 0} {$i < $cell_count} {incr i} {
        set new_cell_name_tmp [ format "%s_%s" $new_cell_name $i]
        create_cell $new_cell_name_tmp $buf_model_name
        set input_pin [get_pins -of $new_cell_name_tmp -filter "direction == in"]
        set output_pin [get_pins -of $new_cell_name_tmp -filter "direction == out"]
        connect_pin -from $input_pin -to $pin -port_name $ECO_STRING
        set pin $output_pin     
    }
    foreach_in_collection pin_t $load_pins {
        disconnect_net [get_nets -of $pin_t]  $pin_t
        connect_pin -from $pin_t  -to $pin -port ${ECO_STRING}
    }
    if { [info exists location] == 1 } {
        for {set i 0} {$i < $cell_count} {incr i} {
            set new_cell_name_tmp [ format "%s_%s" $new_cell_name $i]
            set location_tmp [lrange $location [expr $i*2] [expr [expr $i*2] + 1]] 
            if { [ llength $location_tmp ] != 0 } {
                set_cell_location $new_cell_name_tmp -coordinates "$location_tmp"
            }
        }
    }
  }  
}
