remove_terminal *
set layer C4
set loc_x 0
set loc_y 240
set width 0.08
set height 1.5
set pitch 0.32
set direction [get_attribute [get_layer $layer] preferred_direction]
if {$direction == "vertical" } {
	set x_index 1 ; set y_index 0 ; # when placed terminals on bottom
} else {
	set x_index 0 ; set y_index 1 ; # when placed terminals on left
}
set i 0
foreach_in_collection port [get_ports * ] {
	set name [get_attribute $port full_name ]
	set x0 [expr $loc_x + $pitch * $i * $x_index ]
	set y0 [expr $loc_y + $pitch * $i * $y_index ]
	set x1 [expr $loc_x + $width * $x_index + $height * $y_index + $pitch * $i * $x_index ]
	set y1 [expr $loc_y + $width * $y_index + $height * $x_index + $pitch * $i * $y_index ]
	set i [expr $i + 1]
	create_terminal -name $name -port $name -layer $layer -bbox [list [list $x0 $y0] [list $x1 $y1 ]]
}
