set HtoL_ports ""
set LtoH_ports ""
foreach_in_collection pin [get_pins -of [get_cells u_pll_pd] -filter "direction == out"] {
	set pin_name [get_attribute $pin full_name ]
	set net [get_nets -of $pin]
	set load [get_pins -of $net -filter "direction == in"]
	set load_name [get_attribute $load full_name]
	set cell [get_cells -of $load ]
	set cell_name [get_attribute $cell full_name ]
	if {[lsearch $cell_name u_hce_pd ] != -1 } {
		echo "HtoL:$pin_name -> $load_name"
		lappend HtoL_ports $pin_name
	}
}

foreach_in_collection pin [get_pins -of [get_cells u_hce_pd] -filter "direction == out"] {
	set pin_name [get_attribute $pin full_name ]
	set net [get_nets -of $pin]
	set load [get_pins -of $net -filter "direction == in"]
	set load_name [get_attribute $load full_name]
	set cell [get_cells -of $load ]
	set cell_name [get_attribute $cell full_name ]
	if {[lsearch $cell_name u_pll_pd ] != -1 } {
		echo "LtoH:$pin_name -> $load_name"
		lappend LtoH_ports $pin_name 
	}
}

foreach_in_collection pin [get_pins -of [get_cells u_hce_pd] -filter "direction == out"] {
	set pin_name [get_attribute $pin full_name ]
	set net [get_nets -of $pin]
	set load [get_pins -of $net -filter "direction == in"]
	set load_name [get_attribute $load full_name]
	set cell [get_cells -of $load ]
	set cell_name [get_attribute $cell full_name ]
	if {[lsearch $cell_name u_pad ] != -1 } {
		echo "LtoH:$pin_name -> $load_name"
		lappend LtoH_ports $pin_name
	}
}

foreach_in_collection pin [get_pins -of [get_cells u_pad] -filter "direction == out"] {
	set pin_name [get_attribute $pin full_name ]
	set net [get_nets -of $pin]
	set load [get_pins -of $net -filter "direction == in"]
	set load_name [get_attribute $load full_name]
	set cell [get_cells -of $load ]
	set cell_name [get_attribute $cell full_name ]
	if {[lsearch $cell_name u_hce_pd ] != -1 } {
		echo "HtoL:$pin_name -> $load_name"
		lappend HtoL_ports $pin_name 
	}
}

foreach_in_collection pin [get_pins -of [get_cells u_pll_pd] -filter "direction == in"] {
	set pin_name [get_attribute $pin full_name ]
	set net [get_nets -of $pin]
	if {[sizeof_collection [get_pins -of $net -filter "direction == in"] ] < 2} {continue }
	set load [filter_collection [get_pins -of $net -filter "direction == in"] "full_name !~ u_pll_pd/*"]
	set load_name [get_attribute $load full_name]
	set cell [get_cells -of $load ]
	set cell_name [get_attribute $cell full_name ]
	if {[lsearch $cell_name u_hce_pd ] != -1 } {
		echo "Attention:$pin_name -> $load_name"
	}
}
echo $HtoL_ports
echo $LtoH_ports
