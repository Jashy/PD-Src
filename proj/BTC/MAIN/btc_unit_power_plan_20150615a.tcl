source -e ./flow_btc/create_route_guide.tcl
derive_pg_connection -power_net VDD -power_pin VDD -ground_net VSS -ground_pin VSS
preroute_standard_cells -nets  {VDD VSS}  -connect horizontal  -fill_empty_rows  -port_filter_mode off -cell_master_filter_mode off -cell_instance_filter_mode off -voltage_area_filter_mode off -route_type {P/G Std. Cell Pin Conn}

foreach {layer width pitch step start stop } {
	M3	0.192	1.28	2.56	3	417
	C4	1	5	10	3	417	
	C5	1	5	10	3	417	
	C6	3	15	30	5	415	
	C7	3	15	30	5	415	
	K1	3	15	30	5	415	
	K2	4	5.5	11	0	420	
	G1	10	14	28	0	420
} { 
	set direction [get_attribute [get_layers $layer ] preferred_direction]
	set_preroute_drc_strategy -min_layer $layer -max_layer $layer
	create_power_straps -direction $direction -layer $layer -width $width -pitch_within_group $pitch -step $step -start_at $start -stop $stop -configure step_and_stop -keep_floating_wire_pieces -nets {VDD VSS}
}

remove_route_guide *
set_preroute_drc_strategy -min_layer M1 -max_layer G1
set_preroute_advanced_via_rule -move_via_to_center -x_offset 0.0 -y_offset 0.0 -x_step 0.0 -y_step 0.0 -size_by_via_area {4 10}
create_preroute_vias -advanced_via_rules -from_layer G1 -from_object_strap -to_layer K2 -to_object_strap -mark_as strap -nets {VDD VSS}
set_preroute_advanced_via_rule -move_via_to_center -x_offset 0.0 -y_offset 0.0 -x_step 0.0 -y_step 0.0 -size_by_via_area {4 3}
create_preroute_vias -advanced_via_rules -from_layer K2 -from_object_strap -to_layer K1 -to_object_strap -mark_as strap -nets {VDD VSS}
set_preroute_advanced_via_rule -move_via_to_center -x_offset 0.0 -y_offset 0.0 -x_step 0.0 -y_step 0.0 -size_by_via_area {3 3}
create_preroute_vias -advanced_via_rules -from_layer K1 -from_object_strap -to_layer C7 -to_object_strap -mark_as strap -nets {VDD VSS}
set_preroute_advanced_via_rule -move_via_to_center -x_offset 0.0 -y_offset 0.0 -x_step 0.0 -y_step 0.0 -size_by_via_area {3 3}
create_preroute_vias -advanced_via_rules -from_layer C7 -from_object_strap -to_layer C6 -to_object_strap -mark_as strap -nets {VDD VSS}
set_preroute_advanced_via_rule -move_via_to_center -x_offset 0.0 -y_offset 0.0 -x_step 0.0 -y_step 0.0 -size_by_via_area {1 3}
create_preroute_vias -advanced_via_rules -from_layer C6 -from_object_strap -to_layer C5 -to_object_strap -mark_as strap -nets {VDD VSS}
set_preroute_advanced_via_rule -move_via_to_center -x_offset 0.0 -y_offset 0.0 -x_step 0.0 -y_step 0.0 -size_by_via_area {1 1}
create_preroute_vias -advanced_via_rules -from_layer C5 -from_object_strap -to_layer C4 -to_object_strap -mark_as strap -nets {VDD VSS}
set_preroute_advanced_via_rule -move_via_to_center -x_offset 0.0 -y_offset 0.0 -x_step 0.0 -y_step 0.0 -size_by_via_area {0.192 1}
create_preroute_vias -advanced_via_rules -from_layer C4 -from_object_strap -to_layer M3 -to_object_strap -mark_as strap -nets {VDD VSS}
set_preroute_advanced_via_rule -move_via_to_center -x_offset 0.0 -y_offset 0.0 -x_step 0.0 -y_step 0.0 -contact_code V1_25_25_25_25_XX_Vx -size_by_via_area {0.192 0.096}
set_preroute_advanced_via_rule -move_via_to_center -x_offset 0.0 -y_offset 0.0 -x_step 0.0 -y_step 0.0 -contact_code V2_25_25_25_25_XX_Vx -size_by_via_area {0.192 0.096}
create_preroute_vias -advanced_via_rules -from_layer M3 -from_object_strap -to_layer M1 -to_object_std_pin_connection -mark_as standard_cell_pin_connection -nets {VDD VSS}
