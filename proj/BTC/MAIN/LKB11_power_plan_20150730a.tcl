source -e ./flow_btc/create_route_guide.tcl
derive_pg_connection -power_net VDD -power_pin VDD -ground_net VSS -ground_pin VSS
derive_pg_connection -power_net VDD -power_pin VNW -ground_net VSS -ground_pin VPW
derive_pg_connection -power_net VDD_HIGH -power_pin VDD -cells "u_pll_pd" -reconnect
derive_pg_connection -power_net VDD_HIGH -power_pin VNW -cells "u_pll_pd" -reconnect
derive_pg_connection -power_net VDD_HIGH -power_pin VDD -cells "u_pad" -reconnect
derive_pg_connection -power_net VDD_HIGH -power_pin VNW -cells "u_pad" -reconnect
set_preroute_drc_strategy -min_layer M1 -max_layer M1
preroute_standard_cells -nets  {VDD VSS}  -connect horizontal  -fill_empty_rows  -port_filter_mode off -cell_master_filter_mode off -cell_instance_filter_mode off -voltage_area_filter_mode off -route_type {P/G Std. Cell Pin Conn} -exclude_voltage_areas PD_PPD
preroute_standard_cells -nets  {VDD_HIGH VSS}  -connect horizontal  -fill_empty_rows  -port_filter_mode off -cell_master_filter_mode off -cell_instance_filter_mode off -voltage_area_filter_mode off -route_type {P/G Std. Cell Pin Conn} -within_voltage_areas PD_PPD

foreach {layer width pitch step start stop } {
	C5	0.6	4.5	9	164	3474		
	C6	3	15	30	164	3474		
} { 
	set direction [get_attribute [get_layers $layer ] preferred_direction]
	set_preroute_drc_strategy -min_layer $layer -max_layer $layer
	create_power_straps -direction $direction -layer $layer -width $width -pitch_within_group $pitch -step $step -start_at $start -stop $stop -configure step_and_stop -keep_floating_wire_pieces -nets {VDD VSS} -within_voltage_areas PD_HPD -start_at_offset 0
	create_power_straps -direction $direction -layer $layer -width $width -pitch_within_group $pitch -step $step -start_at $start -stop $stop -configure step_and_stop -keep_floating_wire_pieces -nets {VDD_HIGH VSS} -within_voltage_areas PD_PPD -start_at_offset 0
}

#-#-  foreach {layer width pitch step start stop } {
#-#-  	G1	10	14	28	170	3465		
#-#-  	LB	10	14	28	170	3465	
#-#-  } { 
#-#-  	set direction [get_attribute [get_layers $layer ] preferred_direction]
#-#-  	set_preroute_drc_strategy -min_layer $layer -max_layer $layer
#-#-  	create_power_straps -direction $direction -layer $layer -width $width -pitch_within_group $pitch -step $step -start_at $start -stop $stop -configure step_and_stop -keep_floating_wire_pieces -nets {VDD VSS}
#-#-  }

remove_route_guide *
set_preroute_drc_strategy -min_layer M1 -max_layer LB
create_preroute_vias -from_layer LB -from_object_strap -to_layer G1 -to_object_strap -mark_as strap -nets {VDD_HIGH VDD VSS}
create_preroute_vias -from_layer G1 -from_object_strap -to_layer C7 -to_object_strap -mark_as strap -nets {VDD_HIGH VDD VSS} -to_object_macro_io_pin
set_preroute_advanced_via_rule -move_via_to_center -x_offset 0.0 -y_offset 0.0 -x_step 0.0 -y_step 0.0 -size_by_via_area {3 3}
create_preroute_vias -advanced_via_rules -from_layer C7 -from_object_strap -to_layer C6 -to_object_strap -mark_as strap -nets {VDD_HIGH VDD VSS}
set_preroute_advanced_via_rule -move_via_to_center -x_offset 0.0 -y_offset 0.0 -x_step 0.0 -y_step 0.0 -size_by_via_area {1 3}
create_preroute_vias -advanced_via_rules -from_layer C6 -from_object_strap -to_layer C5 -to_object_strap -mark_as strap -nets {VDD_HIGH VDD VSS}
set_preroute_advanced_via_rule -move_via_to_center -x_offset 0.0 -y_offset 0.0 -x_step 0.0 -y_step 0.0 -contact_code V1_25_25_25_25_XX_Vx -size_by_via_area {0.4 0.096}
set_preroute_advanced_via_rule -move_via_to_center -x_offset 0.0 -y_offset 0.0 -x_step 0.0 -y_step 0.0 -contact_code V2_25_25_25_25_XX_Vx -size_by_via_area {0.4 0.096}
set_preroute_advanced_via_rule -move_via_to_center -x_offset 0.0 -y_offset 0.0 -x_step 0.0 -y_step 0.0 -size_by_via_area {0.4 0.096}
set_preroute_advanced_via_rule -move_via_to_center -x_offset 0.0 -y_offset 0.0 -x_step 0.0 -y_step 0.0 -size_by_via_area {0.4 0.096}
create_preroute_vias -advanced_via_rules -from_layer C5 -from_object_strap -to_layer M1 -to_object_std_pin_connection -mark_as standard_cell_pin_connection -nets {VDD_HIGH VDD VSS}
