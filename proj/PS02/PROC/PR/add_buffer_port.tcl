proc  add_buffer_port {args  } {
	set port  [ lindex $args 0]
	set ref_name  [ lindex $args 1]
	if { [ llength [get_ports $port -q ]] == 0  } {
		puts "Error: $port not exist!"
		break
	} 
	set port_name [get_attr [get_ports $port] full_name]
	set net [get_attr [get_nets -of [get_ports  $port]] full_name]
	set location [lindex [get_attr	[get_ports $port] bbox] 0]
	set i 0
	set new_cell_name ${port_name}_ISO
    	set new_net_name  ${port_name}_ISO
	while  { [ sizeof_collection [get_cells $new_cell_name -quiet] ] != 0  || [ sizeof_collection [get_nets $new_net_name -quiet]] != 0} {
		set new_cell_name ${port_name}_ISO_${i}
		set new_net_name  ${port_name}_ISO_${i}
		incr i
	}	
	create_net $new_net_name
	create_cell $new_cell_name $ref_name 
	move_objects -to $location $new_cell_name 
	disconnect_net $net $port

	if { [string equal [get_attr [get_ports $port] direction]  in ] } {
		connect_net $new_net_name $port
		connect_net $new_net_name [ get_pins -of $new_cell_name -filter "direction == in "]
		connect_net $net [ get_pins -of $new_cell_name -filter "direction == out " ]
	} else {
		connect_net $new_net_name $port
		connect_net $new_net_name [ get_pins -of $new_cell_name -filter "direction == out "]
		connect_net $net [ get_pins -of $new_cell_name -filter "direction == in " ]
	}
}
