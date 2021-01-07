proc adjust_port_location_macro {} {
#	remove_terminal [get_terminal *]
	foreach_in_collection port [get_ports] { 
		set port_name  [get_attr [get_ports $port] full_name]
		foreach_in_collection pin [get_flat_pins -of $port_name] {
			if  { [get_attr [get_cells -of  [get_pins $pin] ] mask_layout_type]=="macro"} {
				set pin_name [get_attr [get_pins $pin] full_name]
				set bbox [get_attr [get_pins $pin] bbox]
				set layer [lindex [get_attr [get_pins $pin] layer] end]
				create_terminal -bbox $bbox -port $port_name -layer $layer
				puts "create_terminal -bbox $bbox -port $port_name -layer $layer"
			}	
		} 
	}
	#remove_terminal [get_terminal *]
}
proc adjust_port_location {} {
	#remove_terminal [get_terminal *]
	foreach_in_collection port [get_ports] { 
		set port_name  [get_attr [get_ports $port] full_name]
		foreach_in_collection pin [get_flat_pins -of $port_name] {
			if  {[get_attr [get_cells -of  [get_pins $pin] ] mask_layout_type]=="io_pad" } {
				set pin_name [get_attr [get_pins $pin] full_name]
				set bbox [get_attr [get_pins $pin] bbox]
				set layer [lindex [get_attr [get_pins $pin] layer] end]
				create_terminal -bbox $bbox -port $port_name -layer $layer
				puts "create_terminal -bbox $bbox -port $port_name -layer $layer"
				remove_terminal [get_terminal $port_name]
			}
		} 
	}
	remove_terminal [get_terminal *]
}
