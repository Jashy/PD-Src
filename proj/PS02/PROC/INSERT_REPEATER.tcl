proc INSERT_REPEATER {pin_name ref {num 1}} {
	global ECO_STRING
	set ref_name [get_attribute [get_model $ref] full_name]
	if {$ref_name==""} {set ref_name [get_attribute [get_model BUFFD16] full_name]}
	if {[get_attribute [get_pins $pin_name] direction] == "in"} {
		set drv	     [get_cells -of_objects [get_pins -leaf -of_objects [get_nets -of_objects $pin_name] -filter "direction == out && is_hierarchical == false"] ]
		set drv_name [get_attribute $drv full_name]
		set drv_org  [get_attribute $drv origin]
		set load_org [get_attribute [get_cells -of_objects [get_pins $pin_name] ] origin]
		set x_longth [expr [lindex $drv_org 0] - [lindex $load_org 0] ]
		set y_longth [expr [lindex $drv_org 1] - [lindex $load_org 1] ]
		set x_step   [expr $x_longth / [expr 1 + $num ] ]
		set y_step   [expr $y_longth / [expr 1 + $num ] ]
	#} elseif {[get_attribute $pin_name direction] == "out"} { ; # Now only take care of input pins
	} else { puts "\rError: $pin_name direction Wrong\r"; Error}

	set ECO_BUFFER_LOC_ARRAY [list ]
	for {set count 0} {$count<$num} {incr count} {
		set temp_loc_array [list [expr [lindex $load_org 0] + [expr [expr $num -$count] * $x_step ]] [expr [lindex $load_org 1] + [expr [expr $num -$count] * $y_step ]] ]
		lappend ECO_BUFFER_LOC_ARRAY $temp_loc_array
	}
	foreach loc $ECO_BUFFER_LOC_ARRAY {
		set CMD [format "INSERT_BUFFER %s %s -location {%s}" $pin_name $ref_name $loc ]
		echo $CMD
		eval $CMD
	}
}
