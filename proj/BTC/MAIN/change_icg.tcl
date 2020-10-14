set celN [  get_flat_cells * -filter "ref_name =~ PREICG*" ]
foreach_in_collection x $celN {
	set celN [ get_attribute [ get_flat_cells $x ] full_name ]
	set modN [ get_attribute [ get_flat_cells $x ] ref_name ]
	regsub "X1"    $modN "X6" modN
	size_cell $celN [get_lib_cells */$modN]
}
