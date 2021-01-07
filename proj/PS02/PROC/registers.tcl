set registers [all_register]
foreach_in_collection reg $registers {
	set name [get_attribute $reg full_name]
	echo "$name"
}
