proc sink { input output} {
	set input [open $input r]
	set output [open $output w]

	while {[gets $input line] >= 0} {
		if {[regexp {not floating (\S+) of (\S+) in (\S+)!!} $line dummy pin ins mod]} {
			set head [get_attribute [get_cells * -filter "ref_name == $mod" -hierarchy] full_name]
			set loads [get_pins -of_objects [all_connected $head/$ins/$pin] -filter "pin_direction == in"]
			foreach_in_collection each_load $loads {
				set name [get_attribute $each_load full_name]
				#echo "name;$name"
				regexp {(.*)\/(.*)} $name dummy load_ins load_pin
				set ref [get_attribute [get_cells $load_ins] ref_name]
				#echo "ref;$ref"
				puts $output "$head/$ins $ref $name"
				#echo "$head/$ins $ref $name"
			}
		}
	}
}
