proc  add_routing { args } {
	set_object_snap_type -disable
	parse_proc_arguments -args $args results
	set cell  $results(-cell)
	set len  $results(-len)
 
	set pins [get_pins -of_objects [get_cells $cell ]]
	set cell_box [get_attr [get_cells $cell] bbox]
	set clx [string trim [lindex [split $cell_box ] 0 ] \{ ] 
	set cly [string trim [lindex [split $cell_box ] 1 ] \} ] 
	set cux [string trim [lindex [split $cell_box ] 2 ] \{ ] 
	set cuy [string trim [lindex [split $cell_box ] 3 ] \} ] 
	if {[info exists results(-exclude) ] !=0 } {
		set exclude   $results(-exclude)
		if { [sizeof_collection [ get_pins $results(-exclude) -quiet ] ] != 0 } {
			set exclude  [ get_pins $results(-exclude) ]
			set pins [remove_from_collection $pins $exclude] 
		} else {
			puts "Error: Not Exists exclude pins."
		 	
		}
	} 
	if {[info exists results(-only) ] !=0 } {
		if { [sizeof_collection [ get_pins $results(-only) -quiet ] ] != 0 } {
			set pins  [ get_pins $results(-only) ]
		} else {
			puts "Error: Not Exists only pins."
			set pins ""
			return
		}	
	}

	foreach_in_collection pin $pins {
		if { [sizeof_collection [ get_flat_nets -of $pin -quiet ]] != 0  && [sizeof_collection [get_flat_pins -of [ get_flat_nets -of $pin -quiet ] -quiet]] != 1 } {
			set pin [get_pins $pin]
			set pin_name [get_attr [get_pins $pin] full_name]
			set net [get_nets -of [get_pins $pin]]
			set net_name [get_attr [get_nets $net] full_name]
			set layer [lindex [get_attribute [get_pins $pin ] layer] 0]
			set loc [get_attribute [get_pins $pin] bbox]
			set p1 [lindex  [get_attribute [get_pins $pin] bbox] 0]
			set p2 [lindex  [get_attribute [get_pins $pin] bbox] 1]
			set x1 [lindex  $p1 0]
			set y1 [lindex  $p1 1]
			set x2 [lindex  $p2 0]
			set y2 [lindex  $p2 1]
			if { $y1 == $cly } {
				set w [expr $x2 - $x1]
				set l [expr $len + $y2/4 - $y1/4 ]
				set x [expr $x1 + 0.5*$w]
				set y [expr $y1 -$len]
				set cmd "create_net_shape -net $net_name -route_type user_enter -origin {$x  $y} -length $l -width $w -layer $layer -vertical"
				eval $cmd
			} elseif { $x2 == $cux } {
				set w [expr $y2 - $y1]
				set l [expr $len + $x2/4 - $x1/4 ]
				set x [expr $x2 - $x2/4 + $x1/4 ]
				set y [expr $y2 - 0.5*$w]
				set cmd "create_net_shape -net $net_name -route_type user_enter -origin {$x  $y} -length $l -width $w -layer $layer"
				eval $cmd
			} elseif { $y2 == $cuy } {
				set w [expr $x2 - $x1]
				set l [expr $len + $y2/4 - $y1/4 ]
				set x [expr $x2 - 0.5*$w]
				set y [expr $y2 - $y2/4 + $y1/4 ] 
				set cmd "create_net_shape -net $net_name -route_type user_enter -origin {$x  $y} -length $l -width $w -layer $layer -vertical"
				eval $cmd
			} elseif { $x1 == $clx } {
				set w [expr $y2 - $y1]
				set l [expr $len + $x2/4 - $x1/4 ]
				set x [expr $x1 - $len ]
				set y [expr $y1 + 0.5*$w] 
				set cmd "create_net_shape -net $net_name -route_type user_enter -origin {$x  $y} -length $l -width $w -layer $layer "
				eval $cmd
			} else {
				puts "The ****$pin_name**** is too complex, please route the net of this pin by manual"
			}
		}
	}
}


define_proc_attributes add_routing -info "create net shapes for analog cell" \
  -define_args \
  { \
	{-cell "Specify the cell which need to route" obj string required} \
	{-len "Specify the wire length which need to route" obj string required} \
	{-exclude "Specify the cell's pins which don't need to route" obj string optional} \
	{-only "Specify the cell's pins which need to route" obj string optional} \
  }

