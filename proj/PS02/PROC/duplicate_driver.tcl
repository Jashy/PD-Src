proc duplicate_driver {args  } {
	########################################################################
 	 # USAGE
 	 #
  	proc usage_duplicate_driver { } {
   	 puts {Usage: duplicate_driver [list1] [list2] [...] }
 	 }

 	 ########################################################################
	# GET ARGUMENTS
  	#
  	set arg_count 0
        if { [ regexp -- [ lindex $args $arg_count ] {-help} ] == 1 } {
        usage_duplicate_driver
        return
        } elseif { [ llength $args ] == 0 } {
        usage_duplicate_driver
        return
        }

	set arg_count  0
	while { $arg_count < [ llength $args ] } {
		set list [get_flat_pins [ lindex $args $arg_count]]
		set pin [get_flat_pins -of [get_flat_nets -of [get_flat_pins $list]] -filter direction==out]
		if { [sizeof_collection [get_flat_pins  $pin]] != 1 } {
			puts "Error: $args[$arg_count] have more than one drive pins!"
			continue	
		}
		set cell [get_flat_cells -of [get_flat_pins $pin] ]
		set cell_name [get_attr [get_cells $cell] full_name]
		set ref_name [get_attr [get_cells $cell] ref_name]
		set cell_base_name [get_attr [get_cells $cell] base_name]
		set hier_cell [string trimright $cell_name ?$cell_base_name?]
		set new_cell_name ${hier_cell}${cell_base_name}_U${arg_count}
		set i 0
		while  { [ sizeof_collection [get_cells $new_cell_name -quiet] ] != 0  } {
			set new_cell_name ${hier_cell}${cell_base_name}_U${arg_count}_${i}
			incr i
		}
		create_cell $new_cell_name $ref_name

		set num 0
		set x 0
		set y 0
		foreach_in_collection p [get_flat_pins $list] {
			incr num
			set pin_location [lindex [get_attribute [get_pins $p] bbox] 0]
			set x [expr $x + [lindex $pin_location 0]]
			set y [expr $y + [lindex $pin_location 1]]
		}
		set x [expr $x/$num]
		set y [expr $y/$num]
		set pin_location "$x $y"
	        move_objects -to $pin_location  [get_cells $new_cell_name ]

		foreach_in_collection in_pin [get_flat_pins -of $cell -filter direction==in] {
			set pin_name [get_attr [get_flat_pins $in_pin] full_name]
			set pin_base_name [get_attr [get_flat_pins $in_pin] base_name]
			connect_net [get_nets -of [get_flat_pins $in_pin]] [get_flat_pins $new_cell_name/$pin_base_name]
		}

		set pin_base_name [get_attr [get_flat_pins $pin] base_name]
		set out_pin [get_flat_pins $new_cell_name/$pin_base_name] 
		if { [ info exists ECO_STRING ] == 0 } {
    			set ECO_STRING ALCHIP_${cell_base_name}_${arg_count}
  		}
		foreach_in_collection list_pin [get_flat_pins $list] {
			disconnect_net [get_nets -of [get_flat_pins $list_pin]] [get_flat_pins $list_pin]
			connect_pin -from [get_flat_pins $out_pin] -to [get_flat_pins $list_pin] -port_name $ECO_STRING 
			
		}
		incr arg_count
	}
}
