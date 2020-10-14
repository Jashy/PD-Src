source -e ./flow_btc/create_route_guide.tcl
derive_pg_connection -power_net VDD -power_pin VDD -ground_net VSS -ground_pin VSS
preroute_standard_cells -nets  {VDD VSS}  -connect horizontal  -fill_empty_rows  -port_filter_mode off -cell_master_filter_mode off -cell_instance_filter_mode off -voltage_area_filter_mode off -route_type {P/G Std. Cell Pin Conn}

foreach {layer width pitch step start stop } {
	C5	1	10	20	3	422	
	C6	3	15	30	5	420	
} { 
	set direction [get_attribute [get_layers $layer ] preferred_direction]
	set_preroute_drc_strategy -min_layer $layer -max_layer $layer
	create_power_straps -direction $direction -layer $layer -width $width -pitch_within_group $pitch -step $step -start_at $start -stop $stop -configure step_and_stop -keep_floating_wire_pieces -nets {VDD VSS}
}
create_power_straps  -direction vertical  -start_at 5.5 -nets  {VDD VSS}  -layer C7 -width 3 -configure step_and_stop  -step 12 -stop 422 -pitch_within_group 6 -extend_low_ends force_to_boundary_and_generate_pins -extend_high_ends force_to_boundary_and_generate_pins

remove_route_guide *
set_preroute_drc_strategy -min_layer M1 -max_layer LB
set_preroute_advanced_via_rule -move_via_to_center -x_offset 0.0 -y_offset 0.0 -x_step 0.0 -y_step 0.0 -size_by_via_area {3 3}
create_preroute_vias -advanced_via_rules -from_layer C7 -from_object_strap -to_layer C6 -to_object_strap -mark_as strap -nets {VDD VSS}
set_preroute_advanced_via_rule -move_via_to_center -x_offset 0.0 -y_offset 0.0 -x_step 0.0 -y_step 0.0 -size_by_via_area {1 3}
create_preroute_vias -advanced_via_rules -from_layer C6 -from_object_strap -to_layer C5 -to_object_strap -mark_as strap -nets {VDD VSS}
set_preroute_advanced_via_rule -move_via_to_center -x_offset 0.0 -y_offset 0.0 -x_step 0.0 -y_step 0.0 -contact_code V1_25_25_25_25_XX_Vx -size_by_via_area {0.4 0.096}
set_preroute_advanced_via_rule -move_via_to_center -x_offset 0.0 -y_offset 0.0 -x_step 0.0 -y_step 0.0 -contact_code V2_25_25_25_25_XX_Vx -size_by_via_area {0.4 0.096}
set_preroute_advanced_via_rule -move_via_to_center -x_offset 0.0 -y_offset 0.0 -x_step 0.0 -y_step 0.0 -size_by_via_area {0.4 0.096}
set_preroute_advanced_via_rule -move_via_to_center -x_offset 0.0 -y_offset 0.0 -x_step 0.0 -y_step 0.0 -size_by_via_area {0.4 0.096}
create_preroute_vias -advanced_via_rules -from_layer C5 -from_object_strap -to_layer M1 -to_object_std_pin_connection -mark_as standard_cell_pin_connection -nets {VDD VSS}
