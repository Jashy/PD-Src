proc move_buffer {args } {
	set cells [ lindex $args 0]
	set i_o [lindex $args 1]
	set l [lindex $args 2]
	foreach_in_collection cell [get_cells $cells] {
		set cell_ref_name [get_attr [get_flat_cell $cell] ref_name]
		set cell_name [get_attr [get_cell $cell] full_name]
		set input_num [sizeof [get_pins -of [get_cells $cell] -filter direction==in]]
		set output_num [sizeof [get_pins -of [get_cells $cell] -filter direction==out]]
		if { $input_num == 1 && $output_num == 1 } {
			set pins_l_o [get_flat_pins -of [get_flat_nets -of [get_flat_pins -of [get_flat_cells $cell] -filter direction==in]] -filter direction==out]
			set pins_l_i [get_flat_pins -of [get_flat_nets -of [get_flat_pins -of [get_flat_cells $cell] -filter direction==out]] -filter direction==in]
			set num 0
			set x1 0
			set y1 0
			foreach_in_collection p [get_flat_pins $pins_l_o] {
				incr num
				set pin_location [lindex [get_attribute [get_pins $p] bbox] 0]
				set x1 [expr $x1 + [lindex $pin_location 0]]
				set y1 [expr $y1 + [lindex $pin_location 1]]
			}
			set x1 [expr $x1/$num]
			set y1 [expr $y1/$num]
			set num 0
			set x2 0
			set y2 0
			foreach_in_collection p [get_flat_pins $pins_l_i] {
				incr num
				set pin_location [lindex [get_attribute [get_pins $p] bbox] 0]
				set x2 [expr $x2 + [lindex $pin_location 0]]
				set y2 [expr $y2 + [lindex $pin_location 1]]
			}
			set x2 [expr $x2/$num]
			set y2 [expr $y2/$num]
			set x [expr ($x2-$x1)]
			set y [expr ($y2-$y1)]
			set length [expr abs($x) + abs($y)]
			if { [regexp -- f $i_o] == 1 } {
				set x1 [expr $x1 + $l*$x/($length)]
				set y1 [expr $y1 + $l*$y/($length)]
			} elseif { [regexp -- t $i_o] == 1 } {
				set x1 [expr $x2 - $l*$x/($length)]
				set y1 [expr $y2 - $l*$y/($length)]
			}
			set pin_location  "$x1  $y1"
		    	move_objects -to $pin_location  [get_cells $cell ]
		} elseif {$input_num > 1} {
			puts "Error: $cell_name is not a  cell with only one input pin"
			break
		} elseif {$output_num > 1} {
			puts "Error: $cell_name is not a  cell with only one output pin"
			break
		}

	}
}
