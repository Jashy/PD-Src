proc INV2BUFF {cells} {
	foreach c [get_attr [get_flat_cells $cells] full_name] {
		set ful_name [get_attribute [get_flat_cells $c] full_name]
		set re_name  [get_attribute [get_flat_cells $c] ref_name]
		puts "-----------$ful_name--------"
		set n1 [get_nets -of [get_pins -of [get_flat_cells $c] -filter direction==in]]
		set n2 [get_nets -of [get_pins -of [get_flat_cells $c] -filter direction==out]]
		disconnect_net $n1 [get_pins -of [get_flat_cells $c] -filter direction==in]
		disconnect_net $n2 [get_pins -of [get_flat_cells $c] -filter direction==out]
		set bbox [lindex [get_attr [get_flat_cells $c] bbox] 0]
		remove_cell $ful_name
                if {[regexp  {CKND(\d*)} $re_name a var1] == 1} {
			regsub {CKND(\d*)} $re_name CKBD${var1} new_ref_name
		        create_cell $ful_name $new_ref_name
	        } elseif {[regexp  {INVD(\d*)} $re_name a var1] == 1} {
                         regsub {INVD(\d*)} $re_name BUFFD${var1} new_ref_name
		         create_cell $ful_name $new_ref_name
        	} else { puts "Error ....."}
		move_objects -to $bbox [get_flat_cells $ful_name]
		connect_net $n1 [get_pins -of [get_flat_cells $ful_name] -filter direction==in]
		connect_net $n2 [get_pins -of [get_flat_cells $ful_name] -filter direction==out]
    }
}


