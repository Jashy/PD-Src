########################################################################
# PROGRAM:     check_open_input_pin.tcl
# CREATOR:     Mitsuya Takashima <mitsuya@alchip.com>
# DATE:        Tue Sep  2 12:19:04 JST 2003
# DESCRIPTION: Check open input pins in PrimeTime.
# USAGE:       check_open_input_pin
# REQUIRED:    get_drive_pin.tcl
########################################################################

proc check_open_input_pin { } {
	echo [ format "Info: check_open_input_pin started on %s" [ sh date +'%Y/%m%d %H:%M:%S' ] ]

	set cells [ get_cells * -hierarchical -filter "is_hierarchical != true" ]
	set input_pins [ get_pins -of_objects $cells -filter "direction == in || direction == inout" ]

	# Virage only
	#set input_pins [ filter_collection $input_pins "lib_pin_name != iq" ]

	set open_input_pin_count 0
	foreach_in_collection input_pin $input_pins {
		set net [ all_connected $input_pin ]
		set is_open_input_pin 0
		if { [ sizeof_collection $net ] == 0 } {
			set is_open_input_pin 1
		} elseif { [ sizeof_collection [ get_drive_pin $net ] ] == 0 } {
			set is_open_input_pin 1
		}
		if { $is_open_input_pin == 1 } {
			incr open_input_pin_count
			set pin_name [ get_attribute $input_pin full_name ]
			set ref_name [ get_attribute [ get_cells -of_objects $input_pin ] ref_name ]
			echo [ format "Warning: Open input pin %s (%s) found." $pin_name $ref_name ]
		}
	}
	echo [ format "Info: Total open input pin count = %d" $open_input_pin_count ]

	echo [ format "Info: check_open_input_pin finished on %s" [ sh date +'%Y/%m%d %H:%M:%S' ] ]
}

proc get_drive_pin { net_name } {
	set net [ get_nets $net_name ]
	set pins [ all_fanin -to $net -levels 1 -flat ]

	set drive_pins ""
	foreach_in_collection pin $pins {
		if { [ get_attribute [ get_cells -quiet -of_objects $pin ] is_hierarchical ] == "true" } { 
			continue
		}   
		set object_class [ get_attribute $pin object_class ]
		set direction    [ get_attribute $pin direction    ]
		if { ( $object_class == "pin"  ) && ( $direction == "in"  ) } {
			continue
		}
		if { ( $object_class == "port" ) && ( $direction == "out" ) } {
			continue
		}
		set drive_pins [ add_to_collection $drive_pins $pin ]
	}

	set drive_pins [ sort_collection $drive_pins full_name ]

	return $drive_pins
}

