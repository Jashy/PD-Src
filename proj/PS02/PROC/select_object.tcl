proc csc { cells } {
	change_selection [get_flat_cells $cells]
}
proc csp { pins } {
	change_selection
	foreach pin $pins {
		if { [sizeof [get_flat_pins $pin -quiet]] !=0 } {
			change_selection -add [get_flat_pins $pin -quiet]
		} elseif { [sizeof [get_ports $pin -quiet]] !=0 } {
			change_selection -add [get_ports $pin -quiet]
		} else {
			puts "Error: $pins is not pin or port"
		}
	}
}
proc csn { nets } {
	change_selection [get_flat_nets $nets]
}
proc sz { collection } {
	sizeof_collection $collection
}
proc lia {} {list_mw_cel -all_version -all_view}
proc oplt {} {open_mw_lib $TOP}
proc opl {args} {open_mw_lib $args}
proc opc {args} {open_mw_cel $args}
proc clc {} { close_mw_cel }
proc cll {} { close_mw_lib }
