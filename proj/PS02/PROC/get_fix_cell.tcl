proc get_ref_name { cell } {
	set fixed [get_attribute [get_flat_cells $cell] is_fixed ]
	if { $fixed == "true" } {
		return $cell
	}
} 


set file_name /proj/Pezy-1/WORK/simon/ICC/atile_top/eco_1031b/boundary_cell
if { [catch {open $file_name r} FILE] } {
	puts "cant open file : $FILE\n"
} else {
	while { [gets $FILE line] != -1 } {
		puts [get_ref_name $line	]
	}

	close $FILE
}




