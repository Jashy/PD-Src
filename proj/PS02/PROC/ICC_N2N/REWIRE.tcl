proc REWIRE { args } {
  ########################################################################
  # USAGE
  #
  proc usage_REWIRE { } {
    puts {}
    puts {Usage: REWIRE <drive_pin> { <pin_names> }} 
    puts {}
    puts {       Example: REWIER IN1/Q  { IN2/A IN3/B } }
    puts {}
  }

  ########################################################################
  # GET ARGUMENTS
  #
  set arg_count 0
  while { $arg_count < [ llength $args ] } {
      if { [ regexp -- [ lindex $args $arg_count ] {-help} ] == 1 } {
        usage_REWIRE
        return
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
      }   
    usage_REWIRE
    return
  }

  if { [ info exists pin_names ] == 0 } {
    puts [ format "Error: <pin_names> not specified." ]
    usage_REWIRE
    return
  }

  if { [ info exists drive_pin ] == 0 } {
    puts [ format "Error: <drive_pin> not specified." ]
    usage_REWIRE
    return
  }

###
  global ECO_STRING
  if { [ info exists ECO_STRING ] == 0 } {
    set DATE [ sh date +%y%m%d ]
    set ECO_STRING ALCHIP_ECO_$DATE
  }
###
#  ########################################################################
#  # CHECK OBJECTS
#  #
  if { [ llength [get_pins $drive_pin -q ]] == 0 } {
    puts [ format "Error: Cannot find pin '%s'." $drive_pin]
    return
  }
  foreach pin_name $pin_names {
    if { [ llength [get_pins $pin_name -q ]] == 0 } {
        puts [ format "Error: Cannot find pin '%s'." $pin_name]
        return
    }    
  }
  puts [ format "REWIRE %s" $args ]
  ########################################################################
  # MAKE CHANGES
  #
  # reconnect given pins
  foreach pin_name $pin_names {
    set command "disconnect_net [get_attribute [get_nets -of $pin_name] full_name]  $pin_name"
    puts $command
    eval $command
    set command "connect_pin -from $pin_name -to $drive_pin -port_name $ECO_STRING"
    puts $command
    eval $command
  }
}
