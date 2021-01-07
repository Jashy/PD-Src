proc show_lib_arc {args} {
	set lib_arcs [eval [concat get_lib_timing_arcs $args]]
	echo [format "%15s %-15s %18s" "from_lib_pin" "to_lib_pin" "sense"]
	echo [format "%15s %-15s %18s" "---------------" "---------------" "-----"]
	
	foreach_in_collection lib_arc $lib_arcs {
		set fpin [get_attribute $lib_arc from_lib_pin]
		set tpin [get_attribute $lib_arc to_lib_pin]
		set sense [get_attribute $lib_arc sense]
		set from_pin_name [get_attribute $fpin base_name]
		set to_pin_name [get_attribute $tpin base_name]
		echo [format "%15s -> %-15s %18s" $from_pin_name $to_pin_name $sense]
	}
}

