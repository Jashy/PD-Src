proc get_bbox { args } {
	if {[llength $args ]} {
	set cells [lindex $args 0]
	} else {
	set cells [get_selection]
	}
	foreach_in_collection cell [get_cells $cells] {
	set cell_name [get_attr [get_flat_cells $cell] full_name]
	set location [lindex [get_attr [get_flat_cells $cell] bbox] 0]
	puts [format  "move_objects -to {%s} %s" $location $cell_name]
	}
}
