proc CLONE_CELL { args } {
  ########################################################################
  # GLOBAL
  #
  ########################################################################
  # USAGE
  #
  proc usage_CLONE_CELL { } {
    puts {Usage: CLONE_CELL <cell_name> [-place]}
  }

  ########################################################################
  # GET ARGUMENTS
  #
  set arg_count 0
  while { $arg_count < [ llength $args ] } {
    if { [ regexp -- {^-} [ lindex $args $arg_count ] ] == 1 } {
      if { [ regexp -- [ lindex $args $arg_count ] {-help} ] == 1 } {
        usage_CLONE_CELL
        return
      }
      if { [ regexp -- [ lindex $args $arg_count ] {-place} ] == 1 } {
        set place 1
        incr arg_count
        continue
      }
    } else {
      if { [ info exists cell_name ] == 0 } {
        set cell_name [ lindex $args $arg_count ]
        incr arg_count
        continue
      }
    }
    usage_CLONE_CELL
    return
  }

  if { [ info exists cell_name ] == 0 } {
    usage_CLONE_CELL
    return
  }

  global ECO_STRING
  if { [ info exists ECO_STRING ] == 0 } {
    set ECO_STRING ALCHIP
  }

  puts [ format "CLONE_CELL %s" $args ]

  ########################################################################
  # CHECK OBJECTS
  #
  set cell [ get_cells $cell_name -quiet ]

  if { [ sizeof_collection $cell ] == 1 } {
    set cell_name [ get_attr $cell full_name ]
  } else {
    puts [ format "Error: Cannot find cell '%s'." $cell_name ]
    return
  }

  ########################################################################
  # MAKE CHANGE
  #
  set base_cell_name $cell_name
  if { [ regexp {^(\S+)_([0-9]*)$} $base_cell_name ] == 1 } {
    regexp {^(\S+)_([0-9]*)$} $base_cell_name null base_cell_name suffix
    set new_cell_name [ format "%s_%d" $base_cell_name [ expr $suffix + 1 ] ]
    if { [ sizeof_collection [ get_cells $new_cell_name -quiet ] ] != 0 } {
      puts [ format "Error: Cell '%s' already exists." $new_cell_name ]
      return
    }
  } else {
    regsub [ format {_%s_U[0-9][0-9]*$} $ECO_STRING ] $base_cell_name "" base_cell_name
    set eco_count 0
    set new_cell_name [ format "%s_%s_U%s" $base_cell_name $ECO_STRING $eco_count]
    while { [ sizeof_collection [ get_cells $new_cell_name -quiet ] ] == 1 } {
      incr eco_count
      set new_cell_name [ format "%s_%s_U%s" $base_cell_name $ECO_STRING $eco_count]
    }
  }
  create_cell $new_cell_name [ get_model [ get_attr $cell ref_name ] ]

  # reconnect original pin
  foreach_in_collection pin [ get_pins -of $cell_name ] {
    set pin_name [ get_attr $pin full_name ]
    set model_pin_name [ lindex [ split $pin_name "/" ] end ]
    connect_net [ get_nets -of $pin ] $new_cell_name/$model_pin_name
  }

  ########################################################################
  # PLACE CELL
  #
  if { [ info exists place ] == 1 } {
    set location_x [ lindex [ lindex [ get_attr $cell bbox ] 0 ] 0 ]
    set location_y [ lindex [ lindex [ get_attr $cell bbox ] 0 ] 1 ]
    move_object $new_cell_name -x $location_x -y $location_y -ignore
  }
}

