
proc get_fb_root_pins { file } { 
	set of [open $file w+]
	foreach_in_collection cell [ get_cells * -hier -filter "full_name =~ *_FB_L1_DRIVE01" ] {
		set driver [ get_drivers [ get_pins -of $cell -filter "direction == in" ] ]
		set driver_name [ get_attr $driver full_name ]
		puts $of $driver_name
	}
	close $of
}
