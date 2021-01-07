proc DUMMY_GATE {cell loading {location {0 0}}} {
	set ECO_STRING [exec date +%m%d%k%M%S]
	set loading_pins [get_attribute [ get_pins -of [get_cells $loading] -filter "full_name =~ */CP"] full_name]
	
	set dummy_gating_cell DUMMY_GATING_ECO_${ECO_STRING}
	set tie_hi_cell DUMMY_TIE_HI_ECO_${ECO_STRING}
	set tie_l0_cell DUMMY_TIE_L0_ECO_${ECO_STRING}
	
	create_cell $dummy_gating_cell [get_attribute [get_cells $cell] ref_name]
	create_cell $tie_hi_cell TIEHBWP12T
	create_cell $tie_l0_cell TIELBWP12T
	
	create_net  DUMMY_TIE_HI_ECO_${ECO_STRING}_net
	create_net  DUMMY_TIE_L0_ECO_${ECO_STRING}_net
	connect_net DUMMY_TIE_HI_ECO_${ECO_STRING}_net [list [get_pins -of [get_cells $dummy_gating_cell] -filter "full_name =~ */E"] [\
	get_pins -of [get_cells $tie_hi_cell] -filter "direction == out" ]]
	connect_net DUMMY_TIE_L0_ECO_${ECO_STRING}_net [list [get_pins -of [get_cells $dummy_gating_cell] -filter "full_name =~ */TE"] [\
	get_pins -of [get_cells $tie_l0_cell] -filter "direction == out" ]]
	
	connect_net [get_nets -of [get_pins -of [get_cells $cell] -filter "full_name =~ */CP"]] [get_pins -of \
	[get_cells $dummy_gating_cell] -filter "full_name =~ */CP"]
	create_net  DUMMY_GATING_ECO_${ECO_STRING}_net 
	connect_net DUMMY_GATING_ECO_${ECO_STRING}_net [get_pins -of [get_cells $dummy_gating_cell] -filter "full_name =~ */Q"]
	REWIRE [get_pins -of [get_cells $dummy_gating_cell] -filter "full_name =~ */Q"] $loading_pins
	move_objects [get_cells *${ECO_STRING}] -to $location
}

