set cells [get_flat_cells * -filter "ref_name =~ O2LVLUO*"]
foreach_in_collection cel $cells {
	set cel_name [get_attr [get_cells $cel] full_name]
	set net [get_attr [get_nets -of $cel_name/ENB] full_name]
	set driver_cel [get_object_name [get_drivers $cel_name/ENB]]
	echo "$driver_cel $net $cel_name/ENB" >> lvl_enb.info
}

