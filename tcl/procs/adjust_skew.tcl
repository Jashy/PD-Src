proc adjust_skew {curStep skew pin} {
	if {[regexp {icc2_placeopt} $curStep] || [regexp {icc2_cts} $curStep]} {
	set value $skew
	set pin_name [get_object_name [get_flat_pins $pin -q -filter "full_name !~ *latch* && full_name !~ *icg*"]]
	if {$pin_name == ""} {
		puts "INFO: Error! $pin not found!"
	} else {
		if {[regexp {icc2_placeopt} $curStep]} {
			foreach p $pin_name {
				set cmd "set_clock_latency $value $p -clock SOCCLK"
				puts $cmd
				eval $cmd
			}
		}
		if {[regexp {icc2_cts} $curStep]} {
			if {[regexp {\-} $value]} {
				set value [expr abs($value)]
			} else {
				set value "-$value"
			}
			foreach p $pin_name {
				set cmd "set_clock_balance_points -delay $value -balance_points $p"
				puts "$cmd"
				eval $cmd
			}
		}
	}
}
}