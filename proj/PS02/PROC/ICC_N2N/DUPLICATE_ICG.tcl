  ####################################################################################################
  # PROGRAM     : DUPLICATE_ICG.tcl
  # DESCRIPTION : DUPLICATE ICG cell
  # USAGE       : source DUPLICATE_ICG.tcl and run 'DUPLICATE_ICG $root_pin_names'
  # WRITTEN BY  : Marshal Su (marshals@alchip.com)
  ####################################################################################################

proc DUPLICATE_ICG {root_pin_names} {

  ####################################################################################################
  # TECHNOLOGY DEPENDENT CONFIGURATION
  #
  set fanout_limit 16

  set cluster_size_x 100
  set cluster_size_y 100

  ####################################################################################################
  # PROC
  #
  proc get_center_location { box_list } {
    set x_min    999999999
    set x_max    -999999999
    set y_min    999999999
    set y_max    -999999999
    foreach box $box_list {
      set left   [ lindex [ lindex $box 0 ] 0 ]
      set right  [ lindex [ lindex $box 1 ] 0 ]
      set bottom [ lindex [ lindex $box 0 ] 1 ]
      set top    [ lindex [ lindex $box 1 ] 1 ]
  
      if { $left   < $x_min   } { set x_min  $left   }
      if { $right  > $x_max   } { set x_max  $right  }
      if { $bottom < $y_min   } { set y_min  $bottom }
      if { $top    > $y_max   } { set y_max  $top    }
    }
    set location_x [ expr ( $x_min + $x_max ) * 0.5 ]
    set location_y [ expr ( $y_min + $y_max ) * 0.5 ]
    return [ list $location_x $location_y ]
  }

  ####################################################################################################
  # MAIN
  #
  set cnt 0
  foreach root_pin_name $root_pin_names {
    set root_pin [ get_pins $root_pin_name ]
    set root_net [ get_nets -of $root_pin -boundary_type lower ]
    set root_net_name [ get_attr $root_net full_name ]
    set root_cell [ get_cell -of $root_pin ]
    set root_cell_name [ get_attr $root_cell full_name ]
    set root_cell_model [ get_model [ get_attr $root_cell ref_name ] ]
    set root_model_pin_name [ lindex [ split $root_pin_name "/" ] end ]
    set base_cell_name      [ lindex [ split $root_cell_name "/" ] end ]
    set base_prefix [ format "%s_%s" $base_cell_name $root_model_pin_name ]
    set full_prefix [ format "%s_%s" $root_cell_name $root_model_pin_name ]


    # Find flipflops directly connected to root net
    set pins [ get_pins -quiet -leaf -of $root_net -filter "direction == in || direction == inout" ]
    
    # Build cluster matrix index
    foreach_in_collection pin $pins {
      set pin_name [ get_attr $pin full_name ]
  
      # Get pin center location
      set box_list [ list [ get_attr $pin bbox ] ]
      set location [ get_center_location $box_list ]
      set location_x [ lindex $location 0 ]
      set location_y [ lindex $location 1 ]
  
      # Get matrix index
      set matrix_index_x [ expr $location_x / $cluster_size_x ]
      set matrix_index_y [ expr $location_y / $cluster_size_y ]
      regsub {\.\d+$} $matrix_index_x "" matrix_index_x
      regsub {\.\d+$} $matrix_index_y "" matrix_index_y
  
      if { [ info exists pins_by_matrix_index($matrix_index_x,$matrix_index_y) ] == 0 } {
        set pins_by_matrix_index($matrix_index_x,$matrix_index_y) $pin_name
      } else {
        set pins_by_matrix_index($matrix_index_x,$matrix_index_y) [ concat $pins_by_matrix_index($matrix_index_x,$matrix_index_y) $pin_name ]
      }
    }

    foreach matrix_index [ array names pins_by_matrix_index ] {
      set matrix_index_x [ lindex [ split $matrix_index "," ] 0 ]
      set matrix_index_y [ lindex [ split $matrix_index "," ] 1 ]

      # Sort pins by location
      catch "unset pin_by_location"
      foreach pin_name $pins_by_matrix_index($matrix_index) {
        set box_list [ list [ get_attr [ get_pins $pin_name] bbox ] ]
        set location [ get_center_location $box_list ]
        set location_x [ lindex $location 0 ]
        set location_y [ lindex $location 1 ]
        set pin_by_location($location_x,$location_y) $pin_name
      }
      set tmp_pins ""
      foreach location [ lsort [ array names pin_by_location ] ] {
        set pin $pin_by_location($location)
        set location_x [ lindex [ split $location "," ] 0 ]
        set location_y [ lindex [ split $location "," ] 1 ]
        set tmp_pins [ concat $tmp_pins $pin ]
      }
      if { [ llength $tmp_pins ] != [ llength $pins_by_matrix_index($matrix_index) ] } {
        puts "Error: Unexpected error at pin sort by location."
      }

      set group_index 0

      # Split pins by fanout limit
      while { [ llength $tmp_pins ] > 0 } {
        set current_pins [ lrange $tmp_pins 0 [ expr $fanout_limit - 1 ] ]
        set tmp_pins [ lrange $tmp_pins $fanout_limit end ]

        # Define new object names
        set new_gating_cell_name [ format "%s_DUPLICATED_%d_%d_U%d" $full_prefix $matrix_index_x $matrix_index_y $group_index ]
        set new_gating_net_name  [ format "%s_DUPLICATED_%d_%d_n%d" $full_prefix $matrix_index_x $matrix_index_y $group_index ]
        set new_port_name        [ lindex [ split $new_gating_net_name "/" ] end ]

        # Create new objects
        create_cell $new_gating_cell_name $root_cell_model
        create_net  $new_gating_net_name
        puts "*INFO* create new ICG: $new_gating_cell_name"
        incr cnt

        # Create connections
        foreach_in_collection root_input_pin [ get_pins -of $root_cell -filter " direction == in " ] {
          set root_input_pin_name [ get_attr $root_input_pin full_name ]
          set root_model_input_pin_name [ lindex [ split $root_input_pin_name "/" ] end ]
          set root_input_net [ get_nets -of $root_input_pin -boundary_type lower ]
          connect_net $root_input_net [ get_pins $new_gating_cell_name/$root_model_input_pin_name ]
        }
        connect_net $new_gating_net_name [ get_pins $new_gating_cell_name/$root_model_pin_name ]

        foreach pin_name $current_pins {
          disconnect_net [ get_nets -of $pin_name ] $pin_name
          connect_pin -from $new_gating_cell_name/$root_model_pin_name -to  $pin_name -port_name $new_port_name
        }

        # Get center location of pins
        set box_list ""
        foreach pin_name $current_pins {
          set box_list [ concat $box_list [ list [ get_attr [get_pins  $pin_name ] bbox ] ] ]
        }
        set location [ get_center_location $box_list ]
        set location_x [ lindex $location 0 ]
        set location_y [ lindex $location 1 ]

        # Shift location based on pin offset
        set box_list [ list [ get_attr [ get_pins $new_gating_cell_name/$root_model_pin_name ] bbox ] ]
        set cell_bbox   [ get_attr [ get_cells $new_gating_cell_name ] bbox ]
        set cell_x [ lindex [ lindex $cell_bbox 0 ] 0 ]
        set cell_y [ lindex [ lindex $cell_bbox 0 ] 1 ]
        set offset [ get_center_location $box_list ]
        set offset_x [ expr [ lindex $offset 0 ] - $cell_x ]
        set offset_y [ expr [ lindex $offset 1 ] - $cell_y ]
        set location_x [ expr $location_x - $offset_x ]
        set location_y [ expr $location_y - $offset_y ]

        # Move cells
        move_object $new_gating_cell_name -x $location_x -y $location_y -ignore_fixed

        incr group_index
      }
    }
  }
  puts "*INFO* Totally create $cnt new ICGs"
}
