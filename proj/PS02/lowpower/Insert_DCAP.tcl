set soft_blockage [get_placement_blockages -type soft]
set tap_cell_in_blockage {}
foreach_in_coll blockage $soft_blockage {
	set bbox [get_attr [get_placement_blockages $blockage] bbox]
	set tap_cell [ get_cells  -all -filter "full_name =~ *ALCP_TAP*" -within $bbox ]	
	set tap_cell_in_blockage [add_to_collection $tap_cell_in_blockage $tap_cell]
	echo "[get_object_name $tap_cell_in_blockage]"
}

set tap_cell_all  [ get_cells *ALCP_TAP* -all -filter "orientation == FS" ]
set tap_cell [remove_from_collection $tap_cell_all $tap_cell_in_blockage]

set_object_snap_type -enabled 1
set_object_snap_type -type cell -snap row_tile

foreach_in_coll cell $tap_cell {
	set tap_cell_name [get_attr [get_cells $cell -all] full_name]
	set DCAP_cell_name ${tap_cell_name}_DCAP
	set bbox [get_attr [get_cells $cell -all] bbox]
	set bbox_lx [lindex [ lindex $bbox 1 ] 0]
	set bbox_ly [lindex [ lindex $bbox 0 ] 1]
	create_cell $DCAP_cell_name FILLCAP64_A8TH
	move_object -to " $bbox_lx $bbox_ly " $DCAP_cell_name
}
