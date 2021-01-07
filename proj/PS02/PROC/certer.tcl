#proc CC {cell} {
#	set loc	[get_attribute [get_cells $cell] origin]
#	set x 1242
#	set y 4820
#	set avg_x [expr [expr $x + [lindex $loc 0] ] /2]
#	set avg_y [expr [expr $y + [lindex $loc 1] ] /2]
#	return [list $avg_x $avg_y]
#}

proc CC {xx yy} {
	set loc [list $xx $yy]
       set x 1242
       set y 4820
       set avg_x [expr [expr $x + [lindex $loc 0] ] /2]
       set avg_y [expr [expr $y + [lindex $loc 1] ] /2]
       return [list $avg_x $avg_y]
}

