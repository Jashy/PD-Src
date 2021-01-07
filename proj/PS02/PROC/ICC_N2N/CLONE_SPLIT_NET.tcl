proc CLONE_SPLIT_NET { args } {

  ########################################################################
  # USAGE
  #
  proc usage_CLONE_SPLIT_NET { } {
    puts {Usage: CLONE_SPLIT_NET <drive_pin> { <pin_names> } [-location {<x> <y>}]}
  }

  ########################################################################
  # GET ARGUMENTS
  #
  set arg_count 0
  while { $arg_count < [ llength $args ] } {
    if { [ regexp -- {^-} [ lindex $args $arg_count ] ] == 1 } {
      if { [ regexp -- [ lindex $args $arg_count ] {-help} ] == 1 } {
        usage_CLONE_SPLIT_NET
        return
      }
      if { ( [ regexp -- [ lindex $args $arg_count ] {-location} ] == 1 ) || ( [ regexp -- [ lindex $args $arg_count ] {-xy} ] == 1 ) } {
        incr arg_count
        set location [ lindex $args $arg_count ]
        if { [ llength $location ] != 2 } {
          usage_CLONE_SPLIT_NET
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
    }
    usage_CLONE_SPLIT_NET
    return
  }

  if { [ info exists pin_names ] == 0 } {
    puts [ format "Error: <pin_names> not specified." ]
    usage_CLONE_SPLIT_NET
    return
  }

  if { [ info exists drive_pin ] == 0 } {
    puts [ format "Error: <drive_pin> not specified." ]
    usage_CLONE_SPLIT_NET
    return
  }

  global ECO_STRING
  if { [ info exists ECO_STRING ] == 0 } {
        set DATE [ sh date +%y%m%d ]
        set ECO_STRING ALCHIP_$DATE

  }
#
  puts [ format "CLONE_SPLIT_NET %s" $args ]
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
    set load_net_name [ get_attr [get_nets -of $pin_name -top -seg ] full_name ]
    if { $load_net_name != $net_name } {
      puts [ format "Error: Net '%s' not connected to pin '%s'." $net_name $pin_name ]
      set continue 0
      continue
    }
  }

  set model_name [ get_model  [ get_attr [ get_cells -of [get_pins $drive_pin ] ]  ref_name ] ]
  if { [ llength [get_lib_cells $model_name -q ]] == 0 } {
    puts [ format "Error: Cannot find lib cell '%s'." $model_name]
    return
  }

  if { $continue == 0 } {
    return
  }

  set continue 1
  if { $continue == 0 } {
    return
  }
  ########################################################################
  # MAKE CHANGES
  #
  # create new cell
  set drive_pin_name [ get_attr  [get_pins $drive_pin ] full_name ]
  set lib_pin_name [ lindex [ split $drive_pin_name "/" ] end ]
  set cell_name [ get_attr  [ get_cells -of [get_pins $drive_pin ] ] full_name ]
  set base_cell_name ${cell_name}_${lib_pin_name}_CLONE

  regsub [ format {_%s_U[0-9][0-9]*$} $ECO_STRING ] $base_cell_name "" base_cell_name
  set new_cell_name [ format "%s_%s_U0" $base_cell_name $ECO_STRING ] 
  set eco_count 0
  while { [ sizeof_collection [ get_cells $new_cell_name -quiet ] ] != 0 } {
    incr  eco_count
    regsub [ format {_%s_U[0-9][0-9]*$} $ECO_STRING ] $base_cell_name "" base_cell_name
    set new_cell_name [ format "%s_%s_U%s" $base_cell_name $ECO_STRING $eco_count]
  }
  set command "create_cell $new_cell_name $model_name"
  puts $command
  eval $command

  # create new net
  set base_net_name $base_cell_name
  regsub [ format {_%s_n[0-9][0-9]*$} $ECO_STRING ] $base_net_name "" base_net_name
  set new_net_name  [ format "%s_%s_n0" $base_net_name $ECO_STRING  ]
  set eco_count 0
  while { [ sizeof_collection [ get_nets $new_net_name -quiet ] ] != 0 } {
    incr  eco_count
    regsub [ format {_%s_n[0-9][0-9]*$} $ECO_STRING ] $base_net_name "" base_net_name
    set new_net_name  [ format "%s_%s_n%s" $base_net_name $ECO_STRING $eco_count  ]
  }

  set command "create_net  $new_net_name"
  puts $command
  eval $command

  # connect new cell input
  foreach_in_collection  pin  [get_pins -of $cell_name -filter " direction == in " ] {
    set orgi_lib_pin_name [ lindex [ split [ get_attr $pin full_name ] "/" ] end ]
    set orgi_net [ get_nets -of $pin ]
    connect_net $orgi_net ${new_cell_name}/${orgi_lib_pin_name}
  }
  # connect new output 
  set new_cell_output ${new_cell_name}/${lib_pin_name}
  connect_net $new_net_name $new_cell_output

  # reconnect given pins
  foreach pin_name $pin_names {
    set command "disconnect_net [get_attribute [get_nets -of $pin_name] full_name]  $pin_name"
    puts $command
    eval $command
    set command "connect_pin -from $new_cell_output -to  $pin_name -port_name $ECO_STRING"
    #set command "connect_net $new_net_name $pin_name"
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
  return $new_cell_name

}
