proc SWAP_LOC {cell1 cell2} {
	set loc1 [get_attribute [get_cells $cell1] origin]
	set loc2 [get_attribute [get_cells $cell2] origin]
	move_object $cell2 -to $loc1
	move_object $cell1 -to $loc2
}

