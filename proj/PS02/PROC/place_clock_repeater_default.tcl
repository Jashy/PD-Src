  #set file_name ./tcl/highlight_clock_repeater.tcl
  #set file [ open $file_name w ]

proc place_repeater { lines } {
  set from [ get_pins $from ]
  set to   [ get_pins $to ]

  set cell_names ""

  foreach obj $path {
    if { $obj == "*" } { continue }
    set pin [ get_pins $obj -filter "is_hierarchical == false" -quiet ]
    if { [ sizeof_collection $pin ] != 0 } {
      set cell_name  [ get_attr [ get_cells -of $pin ] full_name ]
      if { [ lsearch $cell_names $cell_name ] != -1 } {
        set cell_names [ concat $cell_names [ get_attr [ get_cells -of $pin ] full_name ] ]
      }
    }
  }

  set start_pin_location   [ get_attr $from bbox ]
  set start_pin_location_x [ lindex [ lindex $start_pin_location 1 ] 0 ]
  set start_pin_location_y [ lindex [ lindex $start_pin_location 1 ] 1 ]

  set end_pin_location_x [ lindex [ lindex $end_pin_location 0 ] 0 ]
  set end_pin_location_y [ lindex [ lindex $end_pin_location 0 ] 1 ]
  set end_pin_location [ list $end_pin_location_x $end_pin_location_x ]

  set is_close_to_endpin 1
  set is_close_to_startpin 1

  set distance_x [ expr $end_pin_location_x - $start_pin_location_x ]
  set distance_y [ expr $end_pin_location_y - $start_pin_location_y ]
  if {($is_close_to_endpin == 0)} {
  	set step_x [ expr $distance_x / ( [ llength $cell_names ] + 1) ]
  	set step_y [ expr $distance_y / ( [ llength $cell_names ] + 1) ]
  } else {
      set step_x [ expr $distance_x / ( [ llength $cell_names ] ) ]
      set step_y [ expr $distance_y / ( [ llength $cell_names ] ) ]
  }
  puts "Step: $step_x $step_y"

  set total_step [ expr [ expr abs($step_x) ] + [ expr abs($step_y) ] ]
  if { $total_step > $max_step } { set max_step $total_step }
  if { $total_step < $min_step } { set min_step $total_step }

  
  set x_dir [ expr $distance_x / [ expr abs($distance_x) ] ]
  set y_dir [ expr $distance_y / [ expr abs($distance_y) ] ]
  puts "$x_dir $y_dir"
  if { $is_close_to_startpin == 1} {
    set start_pin_location_x $start_pin_location_x
    set start_pin_location_y $start_pin_location_y
    puts "MOVE_CELL [ lindex $cell_names 0 ] -coordinates { $start_pin_location_x $start_pin_location_y }"
    move_objects -x $start_pin_location_x -y $start_pin_location_y -ignore_fixed [ lindex $cell_names 0 ]
    hilight_instance [ lindex $cell_names 0 ]
    #set_cell_location [ lindex $cell_names 0 ] -coordinates { $start_pin_location_x $start_pin_location_y }
    set distance_x [ expr $end_pin_location_x - $start_pin_location_x ]
    set distance_y [ expr $end_pin_location_y - $start_pin_location_y ]
    if {($is_close_to_endpin == 0)} {
        set step_x [ expr $distance_x / ( [ llength $cell_names ]) ]
        set step_y [ expr $distance_y / ( [ llength $cell_names ]) ]
    } else {
        set step_x [ expr $distance_x / ( [ llength $cell_names ] -1 ) ]
        set step_y [ expr $distance_y / ( [ llength $cell_names ] -1 ) ]
    }

    puts "Step: $step_x $step_y"
    set cell_index 1
    foreach cell_name $cell_names {
      hilight_instance $cell_name
      if { $cell_name == [ lindex $cell_names 0 ] } { continue }
      #if { $cell_name == [ lindex $cell_names 1 ] } { continue }
      set x [ expr $start_pin_location_x + $step_x * ( $cell_index ) ]
      set y [ expr $start_pin_location_y + $step_y * ( $cell_index ) ]
      puts "MOVE_CELL $cell_name -coordinates { $x $y }"
      #set_cell_location $cell_name -coordinates { $x $y }
      move_objects -x $x -y $y -ignore_fixed $cell_name
      incr cell_index
    }
  } else {
    set cell_index 1
    foreach cell_name $cell_names {
      hilight_instance $cell_name
      set x [ expr $start_pin_location_x + $step_x * ( $cell_index ) ]
      set y [ expr $start_pin_location_y + $step_y * ( $cell_index ) ]
      puts "MOVE_CELL $cell_name -coordinates { $x $y }"
      #set_cell_location $cell_name -coordinates { $x $y }
      move_objects -x $x -y $y -ignore_fixed $cell_name
      incr cell_index
    }
  }
}
