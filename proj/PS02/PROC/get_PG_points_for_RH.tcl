proc get_PG_points_for_RH { metal owner_net {ll 2}} {
	if {!((($metal == "M6") || ($metal == "M7")) && (($owner_net == "VDD") || ($owner_net == "VSS") ))} {
		puts  "*INFO*  Please Type in : get_PG_points_for_RH   M6/M7  VDD/VSS "	
	} else {
			if {$metal == "M6"} {
				set k 1
			} else {
				set k 0
			}
			if {$owner_net == "VDD"} {
				set PG POWER
			} else {
				set PG GROUND
			}
			switch ${k}_${PG} {
				1_POWER {set points  [get_attribute  [get_net_shapes -filter {route_type == "P/G Strap" && layer == M6 && owner_net == VDD && length > 300}] points ]}
				0_POWER {set points  [get_attribute  [get_net_shapes -filter {route_type == "P/G Strap" && layer == M7 && owner_net == VDD && length > 300}] points ]}
				1_GROUND {set points  [get_attribute  [get_net_shapes -filter {route_type == "P/G Strap" && layer == M6 && owner_net == VSS && length > 300}] points ]}
				0_GROUND {set points  [get_attribute  [get_net_shapes -filter {route_type == "P/G Strap" && layer == M7 && owner_net == VSS && length > 300}] points ]}
			}
			set n  [llength $points]
			for {set i 0} {$i < $n} {incr i} { 
				set array1($i) [lindex $points $i]
			}
			for {set i 0} {$i < [expr $n-1]} {incr i} { 
				for {set j [expr $i+1]} {$j < $n} {incr j} {
					if {[lindex $array1($i) 0 $k] > [lindex $array1($j) 0 $k] } {
						set temp        $array1($i)
						set array1($i)  $array1($j)
						set array1($j)  $temp
					}
				}
			}
			set x 1
			for {set i 0} {$i < $n} {incr i [expr $ll+1]} { 
				echo "${owner_net}_$x   [lindex $array1($i) 0]    $metal   $PG" >> ${metal}.ploc 
				echo "${owner_net}_[expr $x + 1]   [lindex $array1($i) 1]    $metal   $PG" >> ${metal}.ploc
				incr x 2
			}
		}
	}
echo "please run the commands: 'get_PG_points_for_RH metal_name owner_net'"
