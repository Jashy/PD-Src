set blockages [get_object_name [get_placement_blockages -filter full_name=~*jason*]]
foreach blk $blockages {
	set bbox [get_attr [get_placement_blockages $blk] bbox]
	remove_via [get_vias -filter "owner_net==VDD_PD24" -within "$bbox"]
	remove_net_shape [get_net_shapes -filter "owner_net==VDD_PD24" -within "$bbox"]
}

set blockages [get_object_name [get_placement_blockages -filter full_name=~*jason*]]
foreach blk $blockages {
	set bbox [get_attr [get_placement_blockages $blk] bbox]
	create_preroute_vias -nets VDD -from_layer M5 -from_object_strap -to_layer M2 -to_object_std_pin_connection -within "$bbox"
	create_preroute_vias -nets VDD1V_MEM -from_layer M5 -from_object_strap -to_layer M2 -to_object_std_pin_connection -within "$bbox"
}
