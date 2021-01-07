proc add_multi_buffer_tall {args  } {
	set pin  [ lindex $args 0]
	set name  [ lindex $args 1]
	set ref_name  [ lindex $args 2]
	set space  [lindex $args 3]
	if { [llength $args] == 5   } {
		set l [ lindex $args 4]
	} else {
		set l 0
	}

	if { [ llength [get_lib_cells */$ref_name -q ]] == 0 } {
		puts "Error: $ref_name not exist!"
		break
	}
	if { [ llength [get_pins $pin -q ]] == 0 && [ llength [get_ports $pin -q ]] == 0  } {
		puts "Error: $pin not exist!"
		break
	} elseif { [ llength [get_ports $pin -q ]] != 0 } {
		set port_name [get_attr [get_ports $pin] full_name]
		set net [get_attr [get_nets -of [get_ports  $pin]] full_name]
		set location [lindex [get_attr	[get_ports $pin] bbox] 0]
		set i 0
		set new_cell_name ${port_name}_ISO
    		set new_net_name  ${port_name}_ISO
		while  { [ sizeof_collection [get_cells $new_cell_name -quiet] ] != 0  || [ sizeof_collection [get_nets $new_net_name -quiet]] != 0} {
			set new_cell_name ${port_name}_ISO_${i}
			set new_net_name  ${port_name}_ISO_${i}
			incr i
		}	
		create_net $new_net_name
		create_cell $new_cell_name $ref_name 
		move_objects -to $location $new_cell_name 
		disconnect_net $net $pin

		if { [string equal [get_attr [get_port $pin] direction]  in ] } {
			connect_net $new_net_name $pin
			connect_net $new_net_name [ get_pins -of $new_cell_name -filter "direction == in "]
			connect_net $net [ get_pins -of $new_cell_name -filter "direction == out " ]
			set pin [ get_pins -of $new_cell_name -filter "direction == out " ] 
		} else {
			connect_net $new_net_name $pin
			connect_net $new_net_name [ get_pins -of $new_cell_name -filter "direction == out "]
			connect_net $net [ get_pins -of $new_cell_name -filter "direction == in " ]
			set pin [ get_pins -of $new_cell_name -filter "direction == in " ] 
		}
	} 
	set pin_name [get_attr [get_pins $pin] name]
	regsub {\[} $pin_name {_} pin_name
	regsub {\]} $pin_name {_} pin_name
	set pin_location [lindex [get_attribute [get_pins $pin] bbox] 0]
	set x1 [lindex $pin_location 0]
	set y1 [lindex $pin_location 1]
	set cell [get_cells -of $pin]
	set net [get_attr [get_nets -of [get_pins  $pin]] full_name]
	if { [string equal [get_attr [get_pins $pin] direction] in ] } {
		set all_pins [get_flat_pins -of [get_flat_nets -of [get_flat_pins $pin]] -filter direction==out ] 
		set x1 [lindex [lindex [get_attr [get_pins $all_pins] bbox] 0] 0]
		set y1 [lindex [lindex [get_attr [get_pins $all_pins] bbox] 0] 1]
	} else {
		set all_pins [get_flat_pins -of [get_flat_nets -of [get_flat_pins $pin]] -filter direction==in ]
	}


 set xmin 99999999999
 set ymin 99999999999
 set xmax 0
 set ymax 0


	set num [sizeof_collection $all_pins]
if { [string equal [get_attr [get_pins $pin] direction] out ] } {
	foreach_in_collection p [get_flat_pins $all_pins] {
	 set pin_bbox [get_attr $p bbox]
     set pin_dlx [ lindex [ lindex $pin_bbox 0 ] 0 ]
     set pin_dly [ lindex [ lindex $pin_bbox 0 ] 1 ]
     set pin_urx [ lindex [ lindex $pin_bbox 1 ] 0 ]
     set pin_ury [ lindex [ lindex $pin_bbox 1 ] 1 ]
    if {$pin_dlx < $xmin} {
	    set xmin $pin_dlx
    }
    if {$pin_dly < $ymin} {
	    set ymin $pin_dly
    }
    if {$pin_urx > $xmax} {
	    set xmax $pin_urx
    }
    if {$pin_ury > $ymax} {
	    set ymax $pin_ury
    }
}
 set x2  [expr ($xmax + $xmin)/2 ] 
 set y2  [expr ($ymax + $ymin)/2 ]
} else {
	set pin_location [lindex [get_attribute [get_pins $pin] bbox] 0]
	set x2 [lindex $pin_location 0]
	set y2 [lindex $pin_location 1]
}
	set x [expr ($x2-$x1)]
	set y [expr ($y2-$y1)]
	set length [expr abs($x) + abs($y)]
	if { $l >= $length } {
	#	puts "Error: $l larger than source-loading distance!"
	#	break
	set add_num 0
	} elseif { [expr $length-$l ] <= $space } {
	set add_num 1
        } else {
		set add_num [expr [expr $length-$l]/$space]
		set add_num [format "%.0f" $add_num]
		if { [expr [expr $length-$l]/$add_num] > [expr $space +50] } {
			incr add_num
	}
}

	if { $num > 1 && $add_num > 0} {
		set x1 [expr $x1 + $l*$x/($length)]
		set y1 [expr $y1 + $l*$y/($length)]
		set x [expr ($x2-$x1)/$add_num]
		set y [expr ($y2-$y1)/$add_num]
		incr add_num
		
	} elseif {$num > 1 && $add_num < 1} {
 		set x1 $x2 
		set y1 $y2 
		set x 0 
		set y 0 
		incr add_num
	} elseif  {$add_num >= 1}  {
		set x1 [expr $x1 + $l*$x/($length)]
		set y1 [expr $y1 + $l*$y/($length)]
		set x [expr ($x2-$x1)/$add_num]
		set y [expr ($y2-$y1)/$add_num]
	} else { 
		puts "Error: add buffer number $add_num less than 1!"
		break
	}
	
	set cell_name [get_attr [get_cells $cell] full_name]
	set cell_base_name [get_attr [get_cells $cell] base_name]
	set hier_cell [string trimright $cell_name ?$cell_base_name?]

	for { set n 0}  { $n < $add_num} { incr n } {
		set new_cell_name ${hier_cell}${cell_base_name}_${pin_name}_${name}_U$n
    		set new_net_name  ${hier_cell}${cell_base_name}_${pin_name}_${name}_n$n
		set i 0
		while  { [ sizeof_collection [get_cells $new_cell_name -quiet] ] != 0  || [ sizeof_collection [get_nets $new_net_name -quiet]] != 0} {
			set new_cell_name ${hier_cell}${cell_base_name}_${pin_name}_${name}_U${n}_${i}
			set new_net_name  ${hier_cell}${cell_base_name}_${pin_name}_${name}_n${n}_${i}
			incr i
		}	
		create_net $new_net_name
		create_cell $new_cell_name $ref_name 
		set pin_location  "[expr $x1 + $n*$x]  [expr $y1 + $n*$y]"
		move_objects -to $pin_location  [get_cells $new_cell_name ]
		set_attr [get_flat_cells  $new_cell_name] is_soft_fixed true
		if { $n ==0} {
			disconnect_net $net $pin
			if { [string equal [get_attr [get_pins $pin] direction]  in ] } {
				connect_net $net [ get_pins -of $new_cell_name -filter "direction == in " ]
				connect_net $new_net_name [ get_pins -of $new_cell_name -filter "direction == out " ]
			} else {
				connect_net $new_net_name $pin
				connect_net $new_net_name [ get_pins -of $new_cell_name -filter "direction == in " ]
			}
		} 
		if { $n== [expr $add_num -1]  && $n!=0 } {
			if { [string equal [get_attr [get_pins $pin] direction]  in ] } {
				connect_net $previous_net_name [ get_pins -of $new_cell_name -filter "direction == in " ]
				connect_net $new_net_name [ get_pins -of $new_cell_name -filter "direction == out " ]
				connect_net $new_net_name $pin
			} else {
				connect_net $new_net_name [ get_pins -of $previous_cell_name -filter "direction == out " ]
				connect_net $new_net_name [ get_pins -of $new_cell_name -filter "direction == in " ]
				connect_net $net [ get_pins -of $new_cell_name -filter "direction == out " ]
			}
		}
		if { $n== [expr $add_num -1]  && $n==0 } {
			if { [string equal [get_attr [get_pins $pin] direction]  in ] } {
				connect_net $new_net_name [ get_pins -of $pin -filter "direction == in " ]
			} else {
				connect_net $net [ get_pins -of $new_cell_name -filter "direction == out " ]
			}
		}
		if { $n< [expr $add_num -1] &&  $n > 0 } {
			if { [string equal [get_attr [get_pins $pin] direction]  in ] } {
				connect_net $previous_net_name [ get_pins -of $new_cell_name -filter "direction == in " ]
				connect_net $new_net_name [ get_pins -of $new_cell_name -filter "direction == out " ]
			} else {
				connect_net $new_net_name [ get_pins -of $previous_cell_name -filter "direction == out " ]
				connect_net $new_net_name [ get_pins -of $new_cell_name -filter "direction == in " ]
			}
		}
		set previous_cell_name 	$new_cell_name
		set previous_net_name   $new_net_name
	}
}





