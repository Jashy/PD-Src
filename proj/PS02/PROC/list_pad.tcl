#proc list_net { rpt_file } {
#	set rpt [open $rpt_file w]
#	set all_nets [get_nets -of_objects [get_pins -of_objects [get_cells *ISO_PORT*] -filter "pin_direction == in"]]
#	foreach_in_collection net $all_nets {
#		set name [get_attribute $net full_name]
#		puts $rpt $name
#	}
#	close $rpt
#}
#





proc list_pad {file_name } {
	set file [open $file_name r]
	while {[gets $file line] != -1} {
		if {[regexp {PAD=1} $line]} {
			regexp {\s+(\S+) \(MUX\) PAD=1$} $line total mux_pins
			set net [get_nets -of [get_pins $mux_pins]]
			set pins [get_attr [get_pins -of $net] full_name]
			set pin [lindex $pins 1]
	   		echo [format "%s    %s" $mux_pins    $pin] >> mux.tcl

		}
	}
}
#proc list_pad {file_name } {
#	set file [open $file_name r]
#	while {[gets $file line] != -1} {
#		if {[regexp {PAD=1} $line]} {
#	   		echo [format "%s" $line] >> mux.tcl
#
#		}
#	}
#}
