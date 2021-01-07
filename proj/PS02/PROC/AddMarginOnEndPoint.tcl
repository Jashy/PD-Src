proc post_route_margin { file } {
	set pt_uncertainty 0.4
	set icc_uncertainty 0.8
	set RPT [ open $file r ]
	set OUT [ open margin.tcl w ]
	while { [ gets $RPT line ] >= 0 } {
		if { [ regexp {^\s*$} $line ] } {
			continue
		}
		if { [ regexp {Start_Point} $line ] } {
			set startpoint  [lindex $line 1 ]
		} else {
			set endpoint_pin [lindex $line 0 ]
			set pt_slack [lindex $line 1 ]
			set endpoint_cell [ get_attribute $endpoint_pin owner ]
			foreach_in_collection pin [get_pins -of_objects $endpoint_cell] {
				if { [ get_attribute $pin is_on_clock_network ] } {
					set icc_slack [ get_attribute $endpoint_pin worst_slack ]
					set margin [expr $icc_slack - $pt_slack + $icc_uncertainty + $icc_uncertainty - $pt_uncertainty ]
					set pin_name [ get_attribute $pin full_name ]
					puts "$endpoint_pin $pt_slack $icc_slack"
					puts $OUT "set_clock_uncertainty $margin $pin_name -setup"
					#set_clock_uncertainty $margin $pin_name -setup
				}
			}
		}
	}
	close $RPT
	close $OUT
}
