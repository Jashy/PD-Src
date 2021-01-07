proc CHANGE_INV2BUF {cell ref} {
	write_floorplan -objects  [get_cells $cell]  -placement { std_cell } -no_placement_blockage -no_bound -no_plan_group -no_voltage_area -no_route_guide -no_create_boundary .inv2buf.tmp.tcl
	set cell_name [get_attr $cell full_name]
	if {![regexp {(\S+)_BUF2INV_ECO_U0$} $cell_name "" new_buf_name]} {
		set new_buf_name [format "%s_INV2BUF_ECO_U0" $cell_name]
	}
	create_cell $new_buf_name [get_model $ref]
	connect_net [get_nets -of_objects ${cell_name}/I]  ${new_buf_name}/I
	connect_net [get_nets -of_objects ${cell_name}/ZN] ${new_buf_name}/Z
	remove_cell $cell
	set obj [get_cells $new_buf_name -all]
	exec grep set_attribute .inv2buf.tmp.tcl > .inv2buf.tmp.tcl.part
	source .inv2buf.tmp.tcl.part
	return $new_buf_name
}

