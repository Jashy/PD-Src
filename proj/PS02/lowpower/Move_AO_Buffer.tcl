set_object_snap_type -enabled 1
set_object_snap_type -type cell -snap row_tile


set hard_macro_bbox [get_attribute [all_macro_cells ] bbox]
set VDD_net_shape_in_memory {}

foreach bbox $hard_macro_bbox {
	set VDD_net_shape_in_memory [add_to_collection $VDD_net_shape_in_memory [get_net_shapes -intersect $bbox -filter "owner_net == VDD && layer_name == M5"]]
}

set VDD_net_shape_all [get_net_shapes -filter "owner_net == VDD && layer_name == M5"]
set VDD_net_shape [remove_from_collection $VDD_net_shape_all $VDD_net_shape_in_memory]

foreach_in_coll net_shape $VDD_net_shape {
		set name [ get_attr [get_net_shapes $net_shape ] full_name ]
	        set location [ get_attribute [ get_net_shapes $net_shape ] bbox ]
                set location_left [ lindex $location 0 ]
                set location_right [ lindex $location 1 ]
                set location_left_x [ lindex $location_left 0 ]
                set location_left_y [ lindex $location_left 1 ]
                set location_right_x [ lindex $location_right 0 ]
                set location_right_y [ lindex $location_right 1 ]
		set blockage_left_x [ expr $location_left_x - 30 ]
		set blockage_left_y [ expr $location_left_y - 0 ]
		set blockage_right_x [ expr $location_right_x + 30 ]	
		set blockage_right_y [ expr $location_right_y + 0 ]
		create_placement_blockage -bbox "$blockage_left_x $blockage_left_y $blockage_right_x $blockage_right_y" -type hard -name ${name}always_on
}

set alway_on_blockage [get_placement_blockages *always_on]
foreach_in_coll blockage $alway_on_blockage {
		set bbox [ get_attr [ get_placement_blockages $blockage ] bbox ]
		set bbox_left [ lindex $bbox 0 ]
		set bbox_left_x [ lindex $bbox_left 0]
		set cells [ get_cells -within $bbox -filter "ref_name =~ GPG*" ]
		if { [ sizeof_coll [ get_cells $cells ] ] } {
			foreach_in_coll cell $cells {
				set cell_origin_location [ get_attr [get_cells $cell] origin ]
				set cell_x [ expr $bbox_left_x + 30 ]
				set cell_y [ lindex $cell_origin_location 1 ]
				set cell_location "$cell_x $cell_y"
				move_objects $cell -to $cell_location
			}
		}
}
			
remove_placement_blockage *always_on	
