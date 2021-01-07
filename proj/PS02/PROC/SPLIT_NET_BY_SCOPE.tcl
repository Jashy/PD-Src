proc SPLIT_NET_BY_SCOPE { args } {

  ########################################################################
  # USAGE
  #
  proc usage_SPLIT_NET_BY_SCOPE { } {
    puts {Usage: SPLIT_NET_BY_SCOPE <drive_pin>  <model_name>  -scope {<x1> <y1> <x2> <y2>}}
  }

  ########################################################################
  # GET ARGUMENTS
  #
  set arg_count 0
  while { $arg_count < [ llength $args ] } {
    if { [ regexp -- {^-} [ lindex $args $arg_count ] ] == 1 } {
      if { [ regexp -- [ lindex $args $arg_count ] {-help} ] == 1 } {
        usage_SPLIT_NET_BY_SCOPE
        return
      }
      if { ( [ regexp -- [ lindex $args $arg_count ] {-scope} ] == 1 ) } {
        incr arg_count
        set scope [ lindex $args $arg_count ]
        if { [ llength $scope ] != 4 } {
          usage_SPLIT_NET_BY_SCOPE
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
      if { [ info exists model_name ] == 0 } {
        set model_name [ lindex $args $arg_count ]
        incr arg_count
        continue
      }
    }
    usage_SPLIT_NET_BY_SCOPE
    return
  }

  if { [ info exists drive_pin ] == 0 } {
    puts [ format "Error: <drive_pin> not specified." ]
    usage_SPLIT_NET_BY_SCOPE
    return
  }

  if { [ info exists model_name ] == 0 } {
    puts [ format "Error: <model_name> not specified." ]
    usage_SPLIT_NET_BY_SCOPE
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
  puts [ format "SPLIT_NET_BY_SCOPE %s" $args ]
#
#  ########################################################################
#  # CHECK OBJECTS
#  #
  if { [ llength [get_pins $drive_pin -q ]] == 0 } {
    puts [ format "Error: Cannot find pin '%s'." [get_attribute $drive_pin full_name]]
    return
  }

  set net_name [get_attribute [get_nets -top -seg -of $drive_pin -q] full_name]
  set continue 1
  if { $continue == 0 } {
    return
  }

  ########################################################################
  # get pins in scope
  #
  set scope_left [ lindex $scope 0 ]
  set scope_right [ lindex $scope 2 ]
  set scope_top [ lindex $scope 3 ]
  set scope_bottom [ lindex $scope 1 ]
  set pin_names ""
  set load_pins [ filter_collection [get_pins -of $net_name -leaf] "( object_class == pin && direction != out ) || ( object_class == port && direction != in )" ]
  foreach_in_collection  pin $load_pins {
    set load_pin_name [get_attribute $pin full_name]
    set box_list [ get_attribute [get_pins $pin] bbox ]
    set bb_left [ string trim [ lindex [split $box_list " "] 0] \{ ]
    set bb_right [ string trim [ lindex [split $box_list " "] [expr 2] ] \{ ]
    set bb_bottom [ string trim [ lindex [split $box_list " "] [expr 1] ] \} ]
    set bb_top [ string trim [ lindex [split $box_list " "] [expr 3] ] \} ]
    set location_x [ expr ( $bb_left + $bb_right ) * 0.5 ]
    set location_y [ expr ( $bb_bottom + $bb_top ) * 0.5 ]
    if { $location_x > $scope_left && $location_x < $scope_right && $location_y > $scope_bottom && $location_y < $scope_top } {
        set pin_names [ concat $pin_names $load_pin_name ]
    }
  }
  ########################################################################
  # MAKE CHANGES
  #
  # create new cell
  set base_cell_name $net_name
  regsub [ format {_%s_U[0-9][0-9]*$} $ECO_STRING ] $base_cell_name "" base_cell_name
  set new_cell_name [ format "%s_%s_U" $base_cell_name $ECO_STRING ] 
  set command "create_cell $new_cell_name $model_name"
  puts $command
  eval $command

  # create new net
  set base_net_name $net_name
  regsub [ format {_%s_n[0-9][0-9]*$} $ECO_STRING ] $base_net_name "" base_net_name
  set new_net_name  [ format "%s_%s_n" $base_net_name $ECO_STRING  ]
  set command "create_net  $new_net_name"
  puts $command
  eval $command

  # connect new cell
  foreach_in_collection  pin [get_pins -of $new_cell_name] {
    set pin_full_name [get_attribute $pin full_name]
    switch [ get_attribute $pin_full_name direction ] {
      "in" {
        set command "connect_net $net_name $pin_full_name"
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
}
