proc B2I {cells} {
	foreach c [get_attr [get_flat_cells $cells] full_name] {
		set name [get_attr [get_flat_cells $c] full_name]
		puts "-----------$name--------"
		set n1 [get_nets -of [get_pins -of [get_flat_cells $c] -filter direction==in]]
		set n2 [get_nets -of [get_pins -of [get_flat_cells $c] -filter direction==out]]
		disconnect_net $n1 [get_pins -of [get_flat_cells $c] -filter direction==in]
		disconnect_net $n2 [get_pins -of [get_flat_cells $c] -filter direction==out]
		set bbox [lindex [get_attr [get_flat_cells $c] bbox] 0]
		remove_cell $name
		create_cell $name CKND16
		move_objects -to $bbox [get_flat_cells $name]
		connect_net $n1 [get_pins -of [get_flat_cells $name] -filter direction==in]
		connect_net $n2 [get_pins -of [get_flat_cells $name] -filter direction==out]
	}
}

