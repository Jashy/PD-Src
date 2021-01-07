proc check_pg_connection { cell } {
	set i 0
	foreach_in_collection pin [get_flat_pins -all -of [get_flat_cells $cell] -filter "name=~*VDD* || name=~*VSS* || name=~*POC* || name=~*GND*"] {
		set pin_name [get_attr  [get_flat_pins -all $pin] full_name]
		set net_name [get_attr  [get_flat_nets -all -of [get_flat_pins -all $pin]] full_name -quiet]
		puts "$pin_name \t $net_name"
		incr i 
	}
	puts "[get_attr  [get_flat_cells $cell] full_name] $i PG pins"
}

