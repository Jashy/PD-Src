proc report_clk { clock_list } {
        #suppress_message SEL-005
        set input [open "$clock_list" r]
        set all_clock [list ]
        while { [gets $input line] >= 0 } {
                if { [ regexp {(.*)} $line dummy clock] } {
                lappend all_clock $clock
                }
        }
	foreach clock $all_clock {
		clk_str_fb $clock
	}
}
proc clk_str_fb { driver_pin } {
	set drv [get_pins $driver_pin]
    	global max_limit
    	set max_limit 20
	clk_structure $drv
}

proc clk_structure { driver {level 0} {level_limit 20} } {
	suppress_message ATTR-3
	suppress_message UITE-416
	global max_limit
	
	#echo [ format "%s" $level_limit ]

	set dri [ get_cells -of_object $driver ]
	set dri_name [ get_attribute $dri full_name ]
	set ref_name [ get_attribute $dri ref_name ]
	#echo [ format "%s" $ref_name ]
	#set fanout [ sizeof_collection [all_fanout -from $driver] ]
	#echo [ format "%s" $fanout ]
	
	set sink 0
	set sink_list ""
	set net [ all_connected $driver ]
	set net [get_nets $net -top_net_of_hierarchical_group -segments -quiet]
	set net_name [ get_attribute $net full_name ]
	#echo [ format "net: %s" [get_attribute $net full_name] ]
	if { [ sizeof_collection $net ] == 0 } {
		echo [ format "%s(%d) %s \[Ref: %s\]" [string repeat " " $level] $level $dri_name $ref_name]
		return
	}
	set pins [get_pins -of [get_nets $net] -filter "pin_direction == in" -leaf -quiet]
	#echo [ format "pins: %d" [sizeof_collection $pins] ]
	if { [ sizeof_collection $pins ] == 0} return
	set load_pins [ filter_collection $pins "( object_class == pin && direction == in )" ]
	#echo [ format "load_pins: %d" [sizeof_collection $load_pins] ]
	if { [ sizeof_collection $load_pins ] == 0 } return
	
	set next_load_pins [list ]
	foreach_in_collection load_pin $load_pins {
		set load_pin_name [ get_attribute [get_pins $load_pin] full_name ]
		#echo "load_pin_name: $load_pin_name"
		set object_class [ get_attribute [get_pins $load_pin] object_class ]
		#echo "object_class: $object_class"
		if { $object_class == "port" } {
		} else {
			set cell [ get_cells -of_object $load_pin ]
			set cell_name [ get_attribute $cell full_name ]
			set cell_ref_name  [get_attribute $cell ref_name]
			if { [get_attribute [get_cells -of_object $load_pin] is_sequential] == "true" } {
				incr sink 1
				append sink_list [format "%s(%d) \[ SINK PIN \] %s \[Ref: %s\]\n" [string repeat " " [expr $level+1]] [expr $level+1] $cell_name $cell_ref_name]
				set max_limit $level
			} else {
				set next_load_pins [ add_to_collection $next_load_pins $load_pin ]
			}
		}
	}

	#echo [format "drive_class: %s" [ get_attribute $driver object_class ]]
	echo -n [ string repeat " " $level]
	if { [ get_attribute $driver object_class ] == "port" } {
		echo [ format "(%d) %s \[Net: %s\] \[PORT\] \[Fanouts: %d\] \[Sinks: %d\]" $level $dri_name $net_name [sizeof_collection $load_pins] $sink]
	} else { echo [ format "(%d) %s \[Net: %s\] \[Ref: %s\] \[Fanouts: %d\] \[Sinks: %d\]" $level $dri_name $net_name $ref_name [sizeof_collection $load_pins] $sink]
	}
	echo $sink_list

	set next_load_pin_net [list ]
	set next_dummy_dri [list ]

	if { $level > $level_limit } {
		#echo [ format "Warning: Exceeded level count limit(%d). Stop to trace." $level_limit ]
	} else {

		foreach_in_collection next_load_pin $next_load_pins {

			foreach_in_collection next_drive_pin [ get_pins -of_objects [ get_cells -of_objects $next_load_pin ] -filter "direction == out" -quiet ] {
				if { [sizeof_collection [get_nets -of_objects $next_drive_pin -top_net_of_hierarchical_group -segments -quiet] ] > 0 } {
					set next_pin_net [ get_nets -of_objects $next_drive_pin -quiet ]
					set next_load_pin_net [ add_to_collection $next_load_pin_net $next_pin_net -unique]
				} else {
					set next_dummy_dri [ add_to_collection $next_dummy_dri [ get_cells -of_objects $next_drive_pin ] ]
				}
			}
		}

		foreach_in_collection next_dummy $next_dummy_dri {
			echo -n [ string repeat " " [ expr $level + 1 ] ]
			set next_dummy_name [ get_attribute $next_dummy full_name ]
			set next_dummy_refname [ get_attribute $next_dummy ref_name ]
			echo [ format "(%d) %s \[Ref: %s\]" [ expr $level + 1 ] $next_dummy_name $next_dummy_refname ]
		}

		foreach_in_collection next_pin_net $next_load_pin_net {
			set next_pin_net [get_nets $next_pin_net -top_net_of_hierarchical_group -segments -quiet]
			set next_pin_net_name [ get_attribute $next_pin_net full_name ]
			set next_dri_num [ sizeof_collection [get_pins -of_objects $next_pin_net -filter "direction == out" -leaf] ]
			set count 1
			foreach_in_collection next_dri_pin [ get_pins -of_objects $next_pin_net -filter "direction == out" -leaf] {
				set next_dri_name [ get_attribute [get_cells -of_objects $next_dri_pin] full_name]
				set next_dri_refname [ get_attribute [get_cells -of_objects $next_dri_pin] ref_name]
				
				if { $count < $next_dri_num } {
					echo -n [ string repeat " " [ expr $level + 1 ] ]
					echo [ format "(%d) %s \[Net: %s\] \[Ref: %s\]" [ expr $level + 1 ] $next_dri_name $next_pin_net_name $next_dri_refname ]
					incr count 1
				} else {
					clk_structure $next_dri_pin [ expr $level + 1 ] $max_limit
				}
			}
		}	
	}
}
