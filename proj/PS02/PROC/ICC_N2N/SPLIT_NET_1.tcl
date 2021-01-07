proc SPLIT_NET_1 { args } {

  ########################################################################
  # USAGE
  #
  proc usage_SPLIT_NET { } {
    puts {Usage: SPLIT_NET <drive_pin> { <pin_names> } <model_name>  [-location {<x> <y>}]}
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
        set ECO_STRING ALCHIP_$DATE

  }
#
  puts [ format "SPLIT_NET %s" $args ]
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
  ########################################################################
  # MAKE CHANGES
  #
  set pin_hier [ split $drive_pin "/" ]
  set cell_name [ get_attr [ get_cells -of $drive_pin ] full_name ]
  set cell_hier [ split $cell_name "/" ]

  # create new cell
  set eco_count 0
  set base_cell_name [ join [ concat [ lindex $cell_hier end ] [ lindex $pin_hier end ] ] "_" ]
  set base_full_name [ join [ concat $cell_name [ lindex $pin_hier end ] ] "_" ]
  regsub [ format {_%s_U[0-9][0-9]*$} $ECO_STRING ] $base_cell_name "" base_cell_name
  regsub [ format {_%s_U[0-9][0-9]*$} $ECO_STRING ] $base_full_name "" base_full_name
  set new_cell_name [ format "%s_%s_U%s" $base_cell_name $ECO_STRING $eco_count]
  set new_full_name [ format "%s_%s_U%s" $base_full_name $ECO_STRING $eco_count]
  while { [ sizeof_collection [ get_cells $new_full_name -quiet ] ] != 0 } {
    incr  eco_count
    regsub [ format {_%s_U[0-9][0-9]*$} $ECO_STRING ] $base_cell_name "" base_cell_name
    regsub [ format {_%s_U[0-9][0-9]*$} $ECO_STRING ] $base_full_name "" base_full_name
    set new_cell_name [ format "%s_%s_U%s" $base_cell_name $ECO_STRING $eco_count]
    set new_full_name [ format "%s_%s_U%s" $base_full_name $ECO_STRING $eco_count]
  }

  # create new net
  set eco_count 0
  set base_net_name [ join [ concat [ lindex $cell_hier end ] [ lindex $pin_hier end ] ] "_" ]
  set base_full_name [ join [ concat $cell_name [ lindex $pin_hier end ] ] "_" ]
  regsub [ format {_%s_U[0-9][0-9]*$} $ECO_STRING ] $base_net_name "" base_net_name
  regsub [ format {_%s_U[0-9][0-9]*$} $ECO_STRING ] $base_full_name "" base_full_name
  set new_net_name [ format "%s_%s_n%s" $base_net_name $ECO_STRING $eco_count]
  set new_full_name [ format "%s_%s_n%s" $base_full_name $ECO_STRING $eco_count]
  while { [ sizeof_collection [ get_nets $new_full_name -quiet ] ] != 0 } {
    incr  eco_count
    regsub [ format {_%s_U[0-9][0-9]*$} $ECO_STRING ] $base_net_name "" base_net_name
    regsub [ format {_%s_U[0-9][0-9]*$} $ECO_STRING ] $base_full_name "" base_full_name
    set new_net_name  [ format "%s_%s_n%s" $base_net_name $ECO_STRING $eco_count]
    set new_full_name [ format "%s_%s_n%s" $base_full_name $ECO_STRING $eco_count]
  }

  set new_full_name [insert_buffer $pin_names  $model_name -new_cell_names $new_cell_name -new_net_names $new_net_name]

  ########################################################################
  # PLACE CELL
  #
  if { [ info exists location ] == 1 } {
    set command "set_cell_location $new_full_name  -coordinates \[ list $location \]"
    puts $command
    eval $command
  }
  return $new_full_name

}
