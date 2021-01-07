set sun_cells [get_cells * -hier -filter "ref_name =~ SUN*"]

foreach_in_collection sun $sun_cells {
	set name [get_attribute $sun full_name]
	set ref [get_attribute $sun ref_name]
	echo "CHANGE_CELL $name $ref"
}
