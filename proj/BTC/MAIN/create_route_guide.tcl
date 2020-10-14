set layer_name {M1 M2 M3 C4 C5 C6 C7 }
foreach coordinate_placement_blockage [get_attribute [get_placement_blockage -type hard] bbox] {
	create_route_guide -coordinate $coordinate_placement_blockage -no_preroute_layers $layer_name -no_signal_layers $layer_name  -zero_min_spacing
}
