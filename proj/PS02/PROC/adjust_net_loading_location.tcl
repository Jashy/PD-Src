
set target_net_rpt /proj/wHydra/WORK/peter/PT/20100905_ECO4/post-layout/normal-mode/wcl_cworst_setup/clk_path.rpt_1um.lis
set output_net_rpt /proj/wHydra/WORK/peter/PT/20100905_ECO4/post-layout/normal-mode/wcl_cworst_setup/clk_path.rpt_1um.lis_wo_clkgen

set llx 1120
set lly 4787
set rtx 1320
set rty 4923

set IN  [open $target_net_rpt r]
set OUT [open $output_net_rpt w]
while {[gets $IN line] >=0} {
	if {[regexp {^whydra_0/whydracore_0/whdcore_0/} $line ""]} { continue }
	foreach_in_collection pin [get_pins -of_objects $line] {
		set loc [get_attribute [get_cells -of_objects $pin ] origin]
		set loc_x [lindex $loc 0]
		set loc_y [lindex $loc 1]
		if {[expr $loc_x > $llx] && [expr $loc_y > $lly] && [expr $loc_x < $rtx] && [expr $loc_y < $rty]} { continue }
		puts $OUT $line
	}
}
close $IN
close $OUT
