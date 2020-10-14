################################################################################
#-points [list [list [expr $x0 - $length] [expr ($y0 + $y1)/2] ] [list  $x0 [expr ($y0 + $y1)/2] ] ] ; # draw -X
#-points [list [list $x1 [expr ($y0 + $y1)/2] ] [list  [expr $x1 + $length] [expr ($y0 + $y1)/2] ] ] ; # draw +X
#-points [list [list [expr ($x0 + $x1)/2] [expr $y0 - $length] ] [list  [expr ($x0 + $x1)/2 ] $y0 ] ] ; # draw -Y
#-points [list [list [expr ($x0 + $x1)/2] $y1] [list [expr ($x0 + $x1)/2]  [expr $y1 + $length] ] ] ; # draw +Y

set length	7
foreach net {VDD VSS} {
	foreach cell {u_hce_pd/u_eh/u_hce_011 u_hce_pd/u_eh/u_hce_012 u_hce_pd/u_eh/u_hce_059 u_hce_pd/u_eh/u_hce_043 u_hce_pd/u_eh/u_hce_044 u_hce_pd/u_eh/u_hce_027 u_hce_pd/u_eh/u_hce_028 u_hce_pd/u_eh/u_hce_035 u_hce_pd/u_eh/u_hce_003 u_hce_pd/u_eh/u_hce_036 u_hce_pd/u_eh/u_hce_019 u_hce_pd/u_eh/u_hce_004 u_hce_pd/u_eh/u_hce_060 u_hce_pd/u_eh/u_hce_051 u_hce_pd/u_eh/u_hce_052 u_hce_pd/u_eh/u_hce_020} {
		foreach_in_collection pin_shape [get_pin_shapes -of [get_pins -all ${cell}/$net] -filter "layer == C7"] {
	        	set bbox [get_attribute $pin_shape bbox]
	        	set x0 [lindex [lindex $bbox 0] 0]
	        	set y0 [lindex [lindex $bbox 0] 1]
	       		set x1 [lindex [lindex $bbox 1] 0]
	        	set y1 [lindex [lindex $bbox 1] 1]
			create_net_shape -no_snap -type path -net $net -layer C7 -datatype 0 -path_type 0 -width [expr $x1 - $x0] -route_type pg_strap \
				-points [list [list [expr ($x0 + $x1)/2] $y1] [list [expr ($x0 + $x1)/2]  [expr $y1 + $length] ] ] ; # draw +Y
		}
	}
}

