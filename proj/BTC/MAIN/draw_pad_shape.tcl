set length	25.145
set width	48
foreach_in_collection cell [get_flat_cells -all pad_P_*VSS*] {
       	set bbox [get_attribute $cell bbox]
	set orientation [get_attribute $cell orientation]
       	set x0 [lindex [lindex $bbox 0] 0]
       	set y0 [lindex [lindex $bbox 0] 1]
	set x1 [lindex [lindex $bbox 1] 0]
	set y1 [lindex [lindex $bbox 1] 1]
	set net VSS
	switch $orientation {
		W {
			set x1 [expr $x1 - 25]
			create_net_shape -no_snap -type path -net $net -layer LB -datatype 0 -path_type 0 -width $width -route_type pg_strap -points [list [list $x1 [expr ($y0 + $y1)/2] ] [list  [expr $x1 + $length] [expr ($y0 + $y1)/2] ] ] }
		N {
			set y0 [expr $y0 + 25]
			create_net_shape -no_snap -type path -net $net -layer LB -datatype 0 -path_type 0 -width $width -route_type pg_strap -points [list [list [expr ($x0 + $x1)/2] [expr $y0 - $length] ] [list  [expr ($x0 + $x1)/2 ] $y0 ] ] }
		S {
			set y1 [expr $y1 - 25]
			create_net_shape -no_snap -type path -net $net -layer LB -datatype 0 -path_type 0 -width $width -route_type pg_strap -points [list [list [expr ($x0 + $x1)/2] $y1] [list [expr ($x0 + $x1)/2]  [expr $y1 + $length] ] ] }
		E {
			set x0 [expr $x0 + 25]
			create_net_shape -no_snap -type path -net $net -layer LB -datatype 0 -path_type 0 -width $width -route_type pg_strap -points [list [list [expr $x0 - $length] [expr ($y0 + $y1)/2] ] [list  $x0 [expr ($y0 + $y1)/2] ] ] }
	}
}

foreach_in_collection cell [get_flat_cells -all pad_P_*VDD*] {
       	set bbox [get_attribute $cell bbox]
	set orientation [get_attribute $cell orientation]
       	set x0 [lindex [lindex $bbox 0] 0]
       	set y0 [lindex [lindex $bbox 0] 1]
	set x1 [lindex [lindex $bbox 1] 0]
	set y1 [lindex [lindex $bbox 1] 1]
	set net VDD
	switch $orientation {
		W {
			set x1 [expr $x1 - 25]
			create_net_shape -no_snap -type path -net $net -layer LB -datatype 0 -path_type 0 -width $width -route_type pg_strap -points [list [list $x1 [expr ($y0 + $y1)/2] ] [list  [expr $x1 + $length] [expr ($y0 + $y1)/2] ] ] }
		N {
			set y0 [expr $y0 + 25]
			create_net_shape -no_snap -type path -net $net -layer LB -datatype 0 -path_type 0 -width $width -route_type pg_strap -points [list [list [expr ($x0 + $x1)/2] [expr $y0 - $length] ] [list  [expr ($x0 + $x1)/2 ] $y0 ] ] }
		S {
			set y1 [expr $y1 - 25]
			create_net_shape -no_snap -type path -net $net -layer LB -datatype 0 -path_type 0 -width $width -route_type pg_strap -points [list [list [expr ($x0 + $x1)/2] $y1] [list [expr ($x0 + $x1)/2]  [expr $y1 + $length] ] ] }
		E {
			set x0 [expr $x0 + 25]
			create_net_shape -no_snap -type path -net $net -layer LB -datatype 0 -path_type 0 -width $width -route_type pg_strap -points [list [list [expr $x0 - $length] [expr ($y0 + $y1)/2] ] [list  $x0 [expr ($y0 + $y1)/2] ] ] }
	}
}


foreach_in_collection cell [get_flat_cells -all pad_u*] {
       	set bbox [get_attribute $cell bbox]
	set orientation [get_attribute $cell orientation]
       	set x0 [lindex [lindex $bbox 0] 0]
       	set y0 [lindex [lindex $bbox 0] 1]
	set x1 [lindex [lindex $bbox 1] 0]
	set y1 [lindex [lindex $bbox 1] 1]
	set net VSS
	switch $orientation {
		W {
			set x1 [expr $x1 - 25]
			create_net_shape -no_snap -type path -net $net -layer LB -datatype 0 -path_type 0 -width $width -route_type pg_strap -points [list [list $x1 [expr ($y0 + $y1)/2] ] [list  [expr $x1 + $length] [expr ($y0 + $y1)/2] ] ] }
		N {
			set y0 [expr $y0 + 25]
			create_net_shape -no_snap -type path -net $net -layer LB -datatype 0 -path_type 0 -width $width -route_type pg_strap -points [list [list [expr ($x0 + $x1)/2] [expr $y0 - $length] ] [list  [expr ($x0 + $x1)/2 ] $y0 ] ] }
		S {
			set y1 [expr $y1 - 25]
			create_net_shape -no_snap -type path -net $net -layer LB -datatype 0 -path_type 0 -width $width -route_type pg_strap -points [list [list [expr ($x0 + $x1)/2] $y1] [list [expr ($x0 + $x1)/2]  [expr $y1 + $length] ] ] }
		E {
			set x0 [expr $x0 + 25]
			create_net_shape -no_snap -type path -net $net -layer LB -datatype 0 -path_type 0 -width $width -route_type pg_strap -points [list [list [expr $x0 - $length] [expr ($y0 + $y1)/2] ] [list  $x0 [expr ($y0 + $y1)/2] ] ] }
	}
}
