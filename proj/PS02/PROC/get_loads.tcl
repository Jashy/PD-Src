proc get_load { driver } {
	if { [get_cells $driver] == 0 } {
		echo "error : cannot get cell of $driver"
		return
	}
	set out_pins [get_pins $driver/* -filter "pin_direction == out"]
	foreach_in_collection each_out $out_pins {
		set load_pins [get_pins -of_objects [all_connected $out_pins] -filter "pin_direction == in"]
		foreach_in_collection each_load $load_pins {
			set name [get_attribute $each_load full_name]
			if { [regexp {(.*)\/(.*)} $name dummy ins pin] } {
				lappend load $ins
				#set load $ins
			} else {
				echo "error : extract ins name"
			}
		}
	}
	return $load
}
