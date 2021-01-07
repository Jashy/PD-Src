proc SPLIT_NET_vien { args } {

  ########################################################################
  # USAGE
  #
  proc usage_SPLIT_NET_vien { } {
    puts {Usage: SPLIT_NET_vien <drive_pin> { <pin_names> } <model_name>  [-location {<x> <y>}]}
  }

  ########################################################################
  # GET ARGUMENTS
  #
  set arg_count 0
  while { $arg_count < [ llength $args ] } {
    if { [ regexp -- {^-} [ lindex $args $arg_count ] ] == 1 } {
      if { [ regexp -- [ lindex $args $arg_count ] {-help} ] == 1 } {
        usage_SPLIT_NET_vien
        return
      }
      if { ( [ regexp -- [ lindex $args $arg_count ] {-location} ] == 1 ) || ( [ regexp -- [ lindex $args $arg_count ] {-xy} ] == 1 ) } {
        incr arg_count
        set location [ lindex $args $arg_count ]
        if { [ llength $location ] != 2 } {
          usage_SPLIT_NET_vien
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
    usage_SPLIT_NET_vien
    return
  }

  if { [ info exists pin_names ] == 0 } {
    puts [ format "Error: <pin_names> not specified." ]
    usage_SPLIT_NET_vien
    return
  }

  if { [ info exists drive_pin ] == 0 } {
    puts [ format "Error: <drive_pin> not specified." ]
    usage_SPLIT_NET_vien
    return
  }

  if { [ info exists model_name ] == 0 } {
    puts [ format "Error: <model_name> not specified." ]
    usage_SPLIT_NET_vien
    return
  }
#
#
  global ECO_STRING
  if { [ info exists ECO_STRING ] == 0 } {
        set DATE [ sh date +%y%m%d ]
        #set ECO_STRING FIX_CLOCK_TRANS_$DATE
        set ECO_STRING ALCHIP_${DATE}

  }
#
  puts [ format "SPLIT_NET_vien %s" $args ]
#
#  ########################################################################
#  # CHECK OBJECTS
#  #
  if { [ llength [get_pins $drive_pin -q ]] == 0 } {
    puts [ format "Error: Cannot find pin '%s'." [get_attribute $drive_pin full_name]]
    return
  }

  set net_name [ get_attribute [ get_nets -of $drive_pin -q ] full_name]
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
#    if { [ lsearch $load_net_name [ get_attribute [ get_nets -of $drive_pin -q -top -seg ] full_name] ] == -1 } 
#      if { $load_net_name != [ get_attribute [ get_nets -of $drive_pin -q -top -seg ] full_name ] } 
#        puts [ format "Error: Net '%s' not connected to pin '%s'." $net_name $pin_name ]
#        set continue 0
#        continue
     if { $drive_pin != [get_attr [get_flat_pins -of [get_flat_nets -of $pin_name ] -filter "direction==out"] full_name] } {
        puts [ format "Error: Loading '%s' not connected to driver '%s'." $pin_name $drive_pin]
        set continue 0
	continue
      }
  }

  set model_name [ get_model $model_name ]
  if { $model_name == 0 } {
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
  set base_cell_name ${cell_name}_${lib_pin_name}

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
        #set new_cell_output $pin_full_name
        #set command "connect_net $new_net_name $pin_full_name"
        #puts $command
        #eval $command
        set new_cell_output $pin_full_name
        set command "connect_net $new_net_name $pin_full_name"
        puts $command
        eval $command
      }  
    }
  }
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
    #set command "set_cell_location $new_cell_name  -coordinates \[ list $location \]"
    set command "move_object $new_cell_name  -to \[ list $location \]"

    puts $command
    eval $command
  }
  return $new_cell_name

}
