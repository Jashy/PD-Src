proc SPLIT_NET { args } {

  ########################################################################
  # USAGE
  #
  proc usage_SPLIT_NET { } {
    puts {Usage: SPLIT_NET <drive_pin> { <pin_names> } <model_name>  [-name {<cell_name>}] [-location {<x> <y>}]}
  }

  ########################################################################
  # GET ARGUMENTS
  #
  set arg_count 0
  while { $arg_count < [ llength $args ] } {
    if { [ regexp -- {^-} [ lindex $args $arg_count ] ] == 1 } {
      if { [ regexp -- [ lindex $args $arg_count ] {-help} ] == 1 } {
        usage_SPLIT_NET
        return
      }
      if { ( [ regexp -- [ lindex $args $arg_count ] {-location} ] == 1 ) } {
        incr arg_count
        set location [ lindex $args $arg_count ]
        if { [ llength $location ] != 2 } {
          usage_SPLIT_NET
          return
        }
        incr arg_count
        continue
      }
      if {[regexp -- [ lindex $args $arg_count ] {-name}] == 1} {
        incr arg_count
        set cell_name [ lindex $args $arg_count ]
        if { ([ llength $cell_name ] == 0) || ( [regexp -- $cell_name {-location}] == 1) } {
          usage_SPLIT_NET
          return
        }
        incr arg_count
        continue
      }
    } else {
      if { [ info exists drive_pin ] == 0 } {
        set drive_pin [ lindex $args $arg_count ]
        incr arg_count
        continue
      }
      if { [ info exists pin_names ] == 0 } {
        set pin_names [ lindex $args $arg_count ]
        incr arg_count
        continue
      }
      if { [ info exists model_name ] == 0 } {
        set model_name [ lindex $args $arg_count ]
        incr arg_count
        continue
      }
    }
    usage_SPLIT_NET
    return
  }

  if { [ info exists pin_names ] == 0 } {
    puts [ format "Error: <pin_names> not specified." ]
    usage_SPLIT_NET
    return
  }

  if { [ info exists drive_pin ] == 0 } {
    puts [ format "Error: <drive_pin> not specified." ]
    usage_SPLIT_NET
    return
  }

  if { [ info exists model_name ] == 0 } {
    puts [ format "Error: <model_name> not specified." ]
    usage_SPLIT_NET
    return
  }
#
#
  global ECO_STRING
  if { [ info exists ECO_STRING ] == 0 } {
        set DATE [ sh date +%y%m%d ]
        set ECO_STRING ALCHIP_ECO_$DATE

  }
#
#
#  ########################################################################
#  # CHECK OBJECTS
#  #
  if { [ llength [get_pins $drive_pin -q ]] == 0 } {
    puts [ format "Error: Cannot find pin '%s'." [get_attribute $drive_pin full_name]]
    return
  }

  if { [ llength [get_lib_cells $model_name -q ]] == 0 } {
    puts [ format "Error: Cannot find lib cell '%s'." $model_name]
    return
  }

  if {[ info exists cell_name ] == 1} {
      if {[llength [get_cells $cell_name -q ]] != 0} {
        puts [format "Error: The cell '%s' already exists." $cell_name]
        return
      }
      set hier_name  [join [lrange [split  $cell_name {/}] 0 end-1] {/}] 
      if {([llength $hier_name] != 0) && ([llength [get_cells $hier_name -q ]] == 0)} {  
            puts [ format "Error: Cannot find hier cell '%s'." $hier_name]
            return
      } 
      set cell_name_last [lindex [split  $cell_name {/}] end]
      if {[string match {[/0-9-]*} $cell_name_last] == 1} {
        puts [format "Error: The cell name '%s' is illegal." $cell_name_last]
        return
      }
  }

  set net_name [get_attribute [get_nets -top -seg -of $drive_pin -q] full_name]
  set continue 1
  foreach pin_name $pin_names {
    if { ( [llength [get_pins $pin_name -q ] ] == 0 ) } {
      puts [ format "Error: Cannot find pin '%s'." $pin_name ]
      set continue 0
      continue
    }
    if { [ llength [get_nets -of $pin_name -q ] ] == 0 } {
      puts [ format "Error: No net connected to pin '%s'." $pin_name ]
      set continue 0
      continue
    }
    if { [ sizeof_collection [filter_collection [get_pins -of  $net_name -q -leaf ] -regexp "full_name == $pin_name"]] == 0 } {
      puts [ format "Error: Net '%s' not connected to pin '%s'." $net_name $pin_name ]
      set continue 0
      continue
    }
  }
  if { $continue == 0 } {
    return
  }

  set continue 1
  if { $continue == 0 } {
    return
  }

  puts [ format "SPLIT_NET %s" $args ]
  ########################################################################
  # MAKE CHANGES
  #
  # create new cell
  set base_cell_name $net_name
  if {[ info exists cell_name ] == 0} {
    set new_cell_name [ format "%s_%s_U" $base_cell_name $ECO_STRING ] 
  } else {
    set new_cell_name $cell_name
  }
  set command "create_cell $new_cell_name $model_name"
  puts $command
  eval $command

  # connect new cell
  foreach_in_collection  pin [get_pins -of $new_cell_name] {
    set pin_full_name [get_attribute $pin full_name]
    switch [ get_attribute $pin_full_name direction ] {
      "in" {
        set command "connect_pin -from $pin_full_name -to $drive_pin -port_name $ECO_STRING"
        puts $command
        eval $command
      }
      "out" {
        set new_cell_output $pin_full_name
      }  
    }
  }
  # reconnect given pins
  foreach pin_name $pin_names {
    set command "disconnect_net [get_attribute [get_nets -of $pin_name] full_name]  $pin_name"
    puts $command
    eval $command
    set command "connect_pin -from $new_cell_output -to  $pin_name -port_name $ECO_STRING"
    puts $command
    eval $command
  }

  ########################################################################
  # PLACE CELL
  #
  if { [ info exists location ] == 1 } {
    set command "set_cell_location $new_cell_name  -coordinates \[ list $location \]"
    puts $command
    eval $command
  }
}
