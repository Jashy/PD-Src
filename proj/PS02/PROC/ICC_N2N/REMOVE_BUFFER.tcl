proc REMOVE_BUFFER { args } {
  ########################################################################
  # USAGE
  #
  proc usage_REMOVE_BUFFER { } {
    puts {Usage: REMOVE_BUFFER <cell_name>}
  }

  ########################################################################
  # GET ARGUMENTS
  #
  set arg_count 0
  while { $arg_count < [ llength $args ] } {
    if { [ regexp -- {^-} [ lindex $args $arg_count ] ] == 1 } {
      if { [ regexp -- [ lindex $args $arg_count ] {-help} ] == 1 } {
        usage_REMOVE_BUFFER
        return
      }
    } else {
      if { [ info exists cell_name ] == 0 } {
        set cell_name [ lindex $args $arg_count ]
        incr arg_count
        continue
      }
    }
    usage_REMOVE_BUFFER
    return
  }

  if { [ info exists cell_name ] == 0 } {
    usage_REMOVE_BUFFER
    return
  }


  ########################################################################
  # CHECK OBJECTS
  #
  if {  [ llength [get_cells $cell_name -q ]] == 0  } {
    puts [ format "Error: Cannot find cell '%s'." $cell_name ]
    return
  }
    ########################################################################
  # MAKE CHANGES
  #
  # reconnect given pins
    set command "remove_buffer $cell_name"
    puts $command
    eval $command

}

