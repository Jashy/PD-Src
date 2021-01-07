proc get_clk_net { input output } {
	set input [open $input r]

	set nets {}
	while { [gets $input line] >= 0} {
		if {[regexp {(.*):} $line dummy ins]} {
			set output_pins [get_pins $ins/* -filter "pin_direction == out"]
			#set output_pins [get_pins -of $ins -filter "pin_direction == out"]
			foreach_in_collection each_output $output_pins {
				set net [all_connected $each_output]
				#set net [get_nets -of  $each_output]
				set net_name [get_attribute $net full_name]
				if { [llength $net_name] > 0 } {
					lappend nets "$net_name"
				}
			}
		}
	}
	close $input
	set output [open $output w]
	foreach net $nets {
		puts $output "$net"
	}
	close $output
}
