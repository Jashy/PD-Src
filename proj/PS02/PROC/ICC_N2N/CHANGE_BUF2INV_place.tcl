proc CHANGE_BUF2INV {cell ref} {
	write_floorplan -objects  [get_cells $cell]  -placement { std_cell } -no_placement_blockage -no_bound -no_plan_group -no_voltage_area -no_route_guide -no_create_boundary .tmp.tcl
	set cell_name [get_attr $cell full_name]
	set new_inv_name [format "%s_BUF2INV_ECO_U0" $cell_name]
	create_cell $new_inv_name [get_model $ref]
	connect_net [get_nets -of_objects ${cell_name}/I] ${new_inv_name}/I
	connect_net [get_nets -of_objects ${cell_name}/Z] ${new_inv_name}/ZN
	remove_cell $cell
	set obj [get_cells $new_inv_name -all]
	exec grep set_attribute .tmp.tcl > .tmp.tcl.part
	source .tmp.tcl.part
	return $new_inv_name
}

