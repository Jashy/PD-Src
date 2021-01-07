proc get_icg {latency_sum clk max_lat min_lat} {
	set IN [open $latency_sum r]
	set OUT [open ${latency_sum}_${clk}.dup_icg.lis w]
	set ignore_flag 1
	while {[gets $IN line]>=0} {
		if {[regexp {^\s(\S+)\s\((\S+)\)$}  $line "" root tmp_clk]} {
			if {$clk == $tmp_clk} {	
				set ignore_flag 0
			} else {
				set ignore_flag 1
			} 
			continue
		}
		if {$ignore_flag} {continue}
		if {[regexp {^\s([0-9.]+)\s(\S+)$} $line "" lat sink]} {
			if { [expr $max_lat > $lat ] && [expr $lat > $min_lat]} { 
				puts $OUT [sink_drv $sink]
			}
		}
	}
	close $IN
	close $OUT
}
proc sink_drv {sink_pin} {
	set drv_cell [get_cells -of_objects [get_pins -leaf -of_objects [get_nets -of_objects $sink_pin]  -filter "direction == out && is_hierarchical ==false" ]] 
	if { [sizeof_collection $drv_cell] == 1} {
		return [get_attribute $drv_cell full_name]
	} else {
		return ""
	}
}

#if { $synopsys_program_name == "icc_shell" } 
proc get_icg_bad_loading {latency_sum clk} {
        set IN [open $latency_sum r]
        set OUT [open ${latency_sum}_${clk}.dup_icg.lis w]
        set ignore_flag 1
        while {[gets $IN line]>=0} {
                if {[regexp {^\s(\S+)\s\((\S+)\)$}  $line "" root tmp_clk]} {
                        if {$clk == $tmp_clk} {
                                set ignore_flag 0
                        } else {
                                set ignore_flag 1
                        }
                        continue
                }
                if {$ignore_flag} {continue}
                if {[regexp {^\s([0-9.]+)\s(\S+)$} $line "" lat sink]} {
			set [sink_drv $sink]
                        #if { [expr $max_lat > $lat ] && [expr $lat > $min_lat]} {
                        #        puts $OUT [sink_drv $sink]
                        #}
                }
        }
        close $IN
        close $OUT
}

proc load_status {drv_pin} {
	
	return ""
}
