# Preroute M2 

create_route_guide -coordinate [get_attribute [get_die_areas] bbox] -no_preroute_layers {M3 M4 M5 M6 M7}

foreach_in b [ get_placement_blockage -type hard ] {
	create_routing_blockage -bbox [get_attribute $b bbox] -layers { metal1Blockage metal2Blockage }
}

insert_stdcell_filler -cell_without_metal "FILLCAP64_A8TH FILLCAP32_A8TH FILLCAP16_A8TH FILLCAP8_A8TH FILLCAP4_A8TH" -ignore_soft_placement_blockage -connect_to_power {VDD_PD24}  -connect_to_ground {VSS} -voltage_area DEFAULT_VA

 
preroute_standard_cells -nets {VDD_PD24 VSS} -route_pins_on_layer M2 -fill_empty_rows -connect horizontal -skip_macro_pins -skip_pad_pins -avoid_merging_vias -do_not_route_over_macros -port_filter_mode off -cell_master_filter_mode off -cell_instance_filter_mode off -voltage_area_filter_mode off -within_voltage_areas DEFAULT_VA

remove_route_guide *
remove_routing_blockage *
remove_stdcell_filler -stdcell

save_mw_cel -as preroute_M2
