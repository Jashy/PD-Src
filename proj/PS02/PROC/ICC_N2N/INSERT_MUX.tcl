#connect all clock enable to TEST_mode pin 
#set clock_ens [get_cells -hierarchical -filter "ref_name =~ CKLNQ*"]
#foreach_in_collection en $clock_ens {
#        set name [get_att $en full_name]
#        disconnect_net [get_nets -of $name/TE] $name/TE
#        connect_pin -from $name/TE -to  u_P90_core/U741/ZN -port DFT_FIX_RB
#}
 
#mux reset/set/clock 
proc INSERT_MUX { args } { 
  ########################################################################
  # USAGE
  #
  proc usage_INSERT_MUX {} {
    puts {Usage: INSERT_MUX  <I0_Pin> <I1_Pin> <S_Pin> <mux_model_name> }
  }

  ########################################################################
  # GET ARGUMENTS
  #
  set arg_count 0
  while { $arg_count < [ llength $args ] } {
    if { [ regexp -- {^-} [ lindex $args $arg_count ] ] == 1 } {
      if { [ regexp -- [ lindex $args $arg_count ] {-help} ] == 1 } {
        usage_INSERT_MUX
        return
      }
    } else {
        if { [ info exists I0_Pin ] == 0 } {
            set I0_Pin [ lindex $args $arg_count ]
            incr arg_count
            continue
        }
        if { [ info exists I1_Pin ] == 0 } {
            set I1_Pin [ lindex $args $arg_count ]
            incr arg_count
            continue
        }
        if { [ info exists S_Pin ] == 0 } {             
            set S_Pin [ lindex $args $arg_count ]             
            incr arg_count
            continue
       }
        if { [ info exists mux_model_name ] == 0 } {
            set mux_model_name [ lindex $args $arg_count ]
            incr arg_count
            continue
        }
       } 
    usage_INSERT_MUX
    return
  }

  if { [ info exists I0_Pin ] == 0 } {
    puts [ format "Error: <I0_Pin> not specified." ]
    usage_INSERT_MUX
    return
  }
  if { [ info exists I1_Pin ] == 0 } {
    puts [ format "Error: <I1_Pin> not specified." ]
    usage_INSERT_MUX
    return
  }
  if { [ info exists S_Pin ] == 0 } {
    puts [ format "Error: <S_Pin> not specified." ]
    usage_INSERT_MUX
    return
  }
  if { [ info exists mux_model_name ] == 0 } {
    puts [ format "Error: <mux_model_name> not specified." ]
    usage_INSERT_MUX
    return
  }

  global ECO_STRING
  if { [ info exists ECO_STRING ] == 0 } {
    set DATE [ sh date +%y%m%d ]
    set ECO_STRING ALCHIP_$DATE
  }

 puts [ format "INSERT_MUX %s" $args ]
 ########################################################################
 # CHECK OBJECTS
 #
  if { [ llength [get_pins $I0_Pin -q ]] == 0 } {
    puts [ format "Error: Cannot find pin '%s'." $I0_Pin]
    return
  }    
  if { [ llength [get_pins $I1_Pin -q ]] == 0 } {
    puts [ format "Error: Cannot find pin '%s'." $I1_Pin]
    return
  }
  if { [ llength [get_pins $S_Pin -q ]] == 0 } {
    puts [ format "Error: Cannot find pin '%s'." $S_Pin]
    return
  }
  if { [ llength [get_lib_cells $mux_model_name -q ]] == 0 } {
    puts [ format "Error: Cannot find lib cell '%s'." $mux_model_name]
    return
  }
  set net_name [get_attribute [get_nets -of $I0_Pin -q] full_name]
  ########################################################################
  # MAKE CHANGES
  #
  # reconnect given pins
  set base_cell_name $net_name
#  regsub [ format {_%s_U[0-9][0-9]*$} $ECO_STRING ] $base_cell_name "" base_cell_name
  set new_cell_name [ format "%s_%s_U" $base_cell_name $ECO_STRING ]
  create_cell $new_cell_name $mux_model_name
  disconnect_net $net_name $I0_Pin
  connect_net $net_name $new_cell_name/Z
  connect_pin -from $I0_Pin -to $new_cell_name/I0 -port $ECO_STRING        
  connect_pin -from $I1_Pin -to $new_cell_name/I1 -port $ECO_STRING
  connect_pin -from $S_Pin -to $new_cell_name/S -port $ECO_STRING
}

