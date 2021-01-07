proc CHANGE_CELL { args } {

  ########################################################################
  # USAGE
  #
  proc usage_CHANGE_CELL { } {
    puts {Usage: CHANGE_CELL <cell_name> <new_model_name>}
  }

  ########################################################################
  # GET ARGUMENTS
  #
  set arg_count 0
  while { $arg_count < [ llength $args ] } {
      if { [ regexp -- [ lindex $args $arg_count ] {-help} ] == 1 } {
        usage_CHANGE_CELL
        return
      } else {
        if { [ info exists cell_name ] == 0 } {
            set cell_name [ lindex $args $arg_count ]
            incr arg_count
            continue
        }
        if { [ info exists new_model_name ] == 0 } {
            set new_model_name [ lindex $args $arg_count ]
            incr arg_count
            continue
        }
      }
    usage_CHANGE_CELL
    return
  }

  if { [ info exists cell_name ] == 0 } {
    puts [ format "Error: <cell_name> not specified." ]
    usage_CHANGE_CELL
    return
  }

  if { [ info exists new_model_name ] == 0 } {
    puts [ format "Error: <new_model_name> not specified." ]
    usage_CHANGE_CELL
    return
  }

#
  set origin [get_attribute [ get_cell $cell_name ] origin]
  set orientation [get_attribute [ get_cell $cell_name ] orientation]
#  ########################################################################
#  # CHECK OBJECTS
#  #
  if { [ llength [get_cells $cell_name -q ]] == 0 } {
    puts [ format "Error: Cannot find cell '%s'." $cell_name]
    return
  }
  if { [ llength [get_lib_cells $new_model_name -q ]] == 0 } {
    puts [ format "Error: Cannot find lib cell '%s'." $new_model_name]
    return
  }    
  if { [get_attribute [get_cells $cell_name -q ] number_of_pins] != [get_attribute [get_lib_cells $new_model_name -q ] number_of_pins] } {
    puts [ format "Error: The pin number between '%s' and lib cell '%s' is inconsistence." $cell_name $new_model_name]
    return
  }
  
  puts [ format "CHANGE_CELL %s" $args ]
  ########################################################################
  # MAKE CHANGES
  #
  # 
  set lib_pin_names1 [sort_collection [get_lib_pins -of [get_lib_cells -of $cell_name]] {direction full_name} ]
  set lib_pin_names2 [sort_collection [get_lib_pins -of_objects $new_model_name] {direction full_name} ]
  if {[compare_collections $lib_pin_names1 $lib_pin_names2] == 0} {
        set command "change_link -all_instances $cell_name  $new_model_name"
        puts $command
        eval $command
  } else {
    global synopsys_program_name
    if { ($synopsys_program_name == "icc_shell") && ([get_attribute [get_cells $cell_name -q ] is_placed] == "true") } {
        set cell_orientation [get_attribute $cell_name orientation ]
        set cell_location [ lindex [ get_attribute [ get_cell $cell_name ] origin ] 0]
        set cell_is_fixed [get_attribute $cell_name is_fixed]  
    }  
  
    set pin_count [get_attribute [get_cells $cell_name -q ] number_of_pins]
    set pin_names [sort_collection [get_pins -quiet -of [get_cells $cell_name -q ]] {direction full_name}]
    set net_name {}
    for {set i 0} {$i < $pin_count} {incr i} {
        set pin_tmp [get_pins [index_collection $pin_names $i]]
        set net_name [add_to_collection $net_name  [get_nets -of $pin_tmp] ]
        disconnect_net [get_nets  -of $pin_tmp] [get_pins $pin_tmp]
    }
    remove_cell $cell_name
  
    create_cell $cell_name $new_model_name
    set pin_names [sort_collection [get_pins -quiet -of [get_cells $cell_name -q ]] {direction full_name}]
    for {set i 0} {$i < $pin_count} {incr i} {
        set pin_tmp [get_pins [index_collection $pin_names $i]]  
        set net_tmp [get_nets [index_collection $net_name $i]]
        connect_net [get_nets $net_tmp] [get_pins $pin_tmp]
    }

    if {[info exists cell_orientation]} {
        set_attribute -quiet $cell_name orientation $cell_orientation
        set_cell_location    $cell_name -coordinates  "$cell_location"
        set_attribute -quiet $cell_name is_fixed    $cell_is_fixed
        set_attribute -quiet $cell_name is_placed   true
    }

  }    
	set_attribute -quiet [ get_cells $cell_name ] origin $origin
	set_attribute -quiet [ get_cells $cell_name ] orientation $orientation
}
