foreach blk $blockages {
	set bbox [list [get_attr [get_placement_blockages $blk] bbox]]
	set cel [get_cells -fil "ref_name=~LVLUO*" -touching $bbox]
	if {$cel == ""} {
		get_object_name [get_cells -fil "ref_name=~FILL*" -all -touching $bbox] >> 1.0v_filler.lis
		get_object_name [get_cells -fil "ref_name=~ENDCAPTIE*" -all -touching $bbox] >> 1.0v_endcap.lis
} else {
		get_object_name [get_cells -fil "ref_name=~FILL*" -all -touching $bbox] >> 0.9v_filler.lis
		get_object_name [get_cells -fil "ref_name=~ENDCAPTIE*" -all -touching $bbox] >> 0.9v_endcap.lis
	}
}
