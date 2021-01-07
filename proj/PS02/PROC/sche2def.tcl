proc sche2def { sche def remove set_file} {
	set sche [open $sche r]
	set def [open $def w]
	set remove [open $remove w]
	set set_file [open $set_file w]

	while {[gets $sche line] >= 0} {
		if {[regexp {\"(\S+)\".*?'\((\S+) (\S+)\)} $line all ins x y]} {
			set ref [get_attribute [get_cell $ins] ref_name]
			puts $def "+ $ins $ref FIXED ($x $y) S;"
			puts $remove "remove_dont_tech_placement $ins"
			puts $set_file "set_dont_touch_placement $ins"
		}
	}
	close $def
	close $remove
	close $set_file
}
