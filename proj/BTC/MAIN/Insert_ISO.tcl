foreach_in_collection cell [get_flat_cells -filter "ref_name == hce"] {
	set cell_name [get_attribute $cell name ]
	foreach_in_collection pin [get_flat_pins -of $cell -filter "direction == in || direction == out"] {
		set pin_name [get_attribute $pin name]
		insert_buffer [get_attribute $pin full_name] sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X4N_A9PP84TL_C14 -new_cell_names ${cell_name}_${pin_name}_BLOCK_ISO_U0 -new_net_names ${cell_name}_${pin_name}_BLOCK_ISO_n0
	}
}

foreach_in_collection pin [get_flat_pins u_pll_pd/u_car/u_pll/* -filter "direction == in || direction == out"] {
	set pin_name [get_attribute $pin name]
	insert_buffer [get_attribute $pin full_name] sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p76v_125c/BUFH_X4N_A9PP84TL_C14 -new_cell_names ${pin_name}_PLL_ISO_U0 -new_net_names ${pin_name}_PLL_ISO_n0
}

foreach_in_collection io [get_flat_cells u_pad/u* -filter "is_io == true"] {
	set io_name [get_attribute $io name]
	foreach_in_collection pin [get_flat_pins -of $io -filter "direction == in || direction == out"] {
		set pin_name [get_attribute $pin name ]
		if {$pin_name == "SNS"} {continue }
		if {$pin_name == "RTO"} {continue }
		if {$pin_name == "PAD"} {continue }
		#-#-  if {$io_name == "ui_xclkin"} {
			#-#-  if {$pin_name == "Y"} {continue }
		#-#-  }
		insert_buffer [get_attribute $pin full_name] sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p76v_125c/BUFH_X4N_A9PP84TL_C14 -new_cell_names ${io_name}_${pin_name}_IO_ISO_U0 -new_net_names ${io_name}_${pin_name}_IO_ISO_n0
	}
}
