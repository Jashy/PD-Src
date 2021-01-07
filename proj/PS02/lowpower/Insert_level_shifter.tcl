
proc Insert_level_shift { memory_name } {

	set name [ get_attr [get_cells $memory_name] full_name ]
	
	set PGEN_x [ lindex [ lindex [ get_attr [get_pins $name/PGEN] bbox ] 1 ] 0 ]
	set PGEN_y [ lindex [ lindex [ get_attr [get_pins $name/PGEN] bbox ] 1 ] 1 ]
	create_cell ${name}_level_shift_PGEN LVLUO_X8M_A8TR_C34
	REWIRE ${name}_level_shift_PGEN/Y $name/PGEN
	REWIRE level_shift_PGEN_ISO_BUF/Y ${name}_level_shift_PGEN/A

	set blockage [get_placement_blockage -filter "full_name=~*THIN_CHAN*" -intersect "[expr $PGEN_x - 30] [expr $PGEN_y - 10 ] [expr $PGEN_x + 30] [expr $PGEN_y + 10 ]"]
	
	set bbox [get_attr [get_placement_blockage $blockage] bbox]
	set level_shift_x [ get_attr [get_net_shapes -intersect  $bbox -filter "owner_net == VDD1 && layer == M5"] bbox_urx ]
	set_object_snap_type -enabled 1
	set_object_snap_type -type cell -snap row_tile
	
	
	move_object -to "[expr $level_shift_x - 3] $PGEN_y" [get_cells ${name}_level_shift_PGEN]
        set level_shift_PGEN_location [get_attr [get_cells ${name}_level_shift_PGEN] bbox ]
        for {set i 0} {$i<3} {incr i} {
        if { [sizeof_coll [get_cells -touch "[lindex [ lindex $bbox 0] 0] [expr [lindex [ lindex $level_shift_PGEN_location 0] 1] - $i*1.6] [lindex [ lindex $bbox 1] 0] [expr [lindex [ lindex $level_shift_PGEN_location 1] 1] - $i*1.6]" -filter "full_name != ${name}_level_shift_PGEN"]] == 0 } {
        move_object -to " [expr $level_shift_x - 3]  [expr $PGEN_y - 1.6*$i] " [get_cells ${name}_level_shift_PGEN]
        break
        }
        }

}

proc Replace_M2_rail { level_shift_name } {

	set name [get_attr [get_cells $level_shift_name] full_name ]
	set bbox [get_attr [get_cells $level_shift_name] bbox ]
	
	set blockage [get_placement_blockage -filter "full_name=~*THIN_CHAN*" -intersect $bbox]
	set blockage_bbox [get_attr [get_placement_blockage $blockage] bbox]

	if { [ sizeof_coll [get_net_shapes -intersect $bbox -filter "layer == M2 && owner_net == VDD_PD15"] ] } {
	puts "$name"
	set VDD_PD15_M2 [get_net_shapes -intersect $bbox -filter "layer == M2 && owner_net == VDD_PD15"]
	set VDD_PD15_M1 [get_net_shapes -intersect $bbox -filter "layer == M1 && owner_net == VDD_PD15"]
	set_attr [get_net_shapes $VDD_PD15_M2] owner_net VDD
	set_attr [get_net_shapes $VDD_PD15_M1] owner_net VDD
	}
}

proc Create_hard_blockage_M2_rail { level_shift_name } {

        set name [get_attr [get_cells $level_shift_name] full_name ]
        set bbox [get_attr [get_cells $level_shift_name] bbox ]

        set blockage [get_placement_blockage -filter "full_name=~*THIN_CHAN*" -intersect $bbox]
        set blockage_bbox [get_attr [get_placement_blockage $blockage] bbox]

        create_placement_blockage -bbox "[lindex [lindex $blockage_bbox 0] 0] [lindex [lindex $bbox 0] 1] [lindex [lindex $blockage_bbox 1] 0] [lindex [lindex $bbox 1] 1]" -name $name
}

