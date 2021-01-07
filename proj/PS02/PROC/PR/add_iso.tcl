proc add_iso { args } {
	parse_proc_arguments -args $args results
	set ref_name [ get_model $results(-type) ]
	set cell  $results(-cell) 

	set pins [get_pins -of_objects [get_cells $cell ]]
	set clock_pins [all_fanout -flat -clock_tree -level 0]
	set signal_pins [remove_from_collection [ get_pins  $pins ] $clock_pins]
	set clock_pins 	[remove_from_collection $pins $signal_pins]

	if {[info exists results(-exclude) ] !=0 } {
		set exclude   $results(-exclude)
		if { [sizeof_collection [ get_pins $results(-exclude) -quiet ] ] != 0 } {
			set exclude  [ get_pins $results(-exclude) ]
			set signal_pins [remove_from_collection $signal_pins $exclude] 
		} else {
			puts "Error: Not Exists exclude pins."
		 	
		}
	} 
	if {[info exists results(-only) ] !=0 } {
		if { [sizeof_collection [ get_pins $results(-only) -quiet ] ] != 0 } {
			set signal_pins  [ get_pins $results(-only) ]
		} else {
			puts "Error: Not Exists only pins."
			set signal_pins ""
			return
		}	
	} 
	##########################################################################################
	# insert isolation buffers for signal pins
	##########################################################################################
	foreach_in_collection pin $signal_pins {
		if { [sizeof_collection [ get_flat_nets -of $pin -quiet ]] != 0  && [sizeof_collection [get_flat_pins -of [ get_flat_nets -of $pin -quiet ] -quiet]] != 1 } {
 			set pin [get_pins $pin]
			set cell [get_cells -of $pin]
			set cell_name [get_attr [get_cells $cell] full_name]
			set cell_base_name [get_attr [get_cells $cell] base_name]
			set hier_cell [string trimright $cell_name ?$cell_base_name?]
			set net [get_nets -of [get_pins $pin]]
			set net_name [get_attr [get_nets $net] full_name]
			set net_base_name [get_attr [get_nets $net] base_name]
			set hier_net [string trimright $net_name ?$net_base_name?]
			if { [ regexp -- {(\S+)_AlcpISO_net_(\d)+} $net_base_name ] == 1 } {
				set iso_prelevel_cells [get_cells -of [get_nets -of [get_pins $pin]]]
				foreach_in_collection iso_prelevel_cell $iso_prelevel_cells {
					set iso_prelevel_cell_name [get_attr [get_cells $iso_prelevel_cell] full_name]
					if { [ regexp -- {(\S+)_AlcpISO_(\d)+} $iso_prelevel_cell_name ] == 1 } {
						set iso_prelevel_base_cell $iso_prelevel_cell_name
					}
				}
				set iso_para [ lindex [ split $iso_prelevel_base_cell _ ] end ]
				incr iso_para
				set new_cell_base_name [join [ lreplace [ split $iso_prelevel_base_cell _ ] end end $iso_para ] _ ]
				set new_net_base_name [join [ lreplace [ split $net_base_name _ ] end end $iso_para ] _ ]
				set new_cell_name ${hier_cell}${new_cell_base_name}
    				set new_net_name  ${hier_net}${new_net_base_name}
			} else { 
				set i 0
				set new_cell_name ${hier_cell}${cell_base_name}_${net_base_name}_AlcpISO
    				set new_net_name  ${hier_net}${cell_base_name}_${net_base_name}_AlcpISO_net
				while  { [ sizeof_collection [get_cells $new_cell_name -quiet] ] != 0  || [ sizeof_collection [get_nets $new_net_name -quiet]] != 0} {
					set new_cell_name ${hier_cell}${cell_base_name}_${net_base_name}_AlcpISO_${i}
    					set new_net_name  ${hier_net}${cell_base_name}_${net_base_name}_AlcpISO_net_${i}
					incr i
				}
			}
			set pin_name [get_attr [get_pins $pin] full_name]
	
		##########################################################################################
		# check isolation buffer level
		##########################################################################################
			if { [ regexp -- {(\S+)_AlcpISO_net_(\d)+} $net_base_name ] == 1 } {
				set iso_para [ lindex [ split $net_base_name _ ] end ]
				incr iso_para
				puts "Warning: Have existed $iso_para level ISO buffer on $pin_name."
				puts "Warning: Have existed $iso_para level ISO net on $pin_name."
			}
   	 		set pin_direction [ get_attr [get_pins $pin] direction ]
			if { $pin_direction == "inout" } {
				puts "Error: didn't support inout pin $pin_name."
				continue
			}
		##########################################################################################
		# insert isolation buffer
		##########################################################################################
			puts "INFO: Insert ISO buffer on $pin_name."
			
			create_net $new_net_name
			create_cell $new_cell_name $ref_name
			disconnect_net $net $pin
			connect_net $new_net_name $pin
			if { $pin_direction == "in" } {
				connect_net $net [ get_pins -of $new_cell_name -filter "direction == in " ]
				connect_net $new_net_name [ get_pins -of $new_cell_name -filter "direction == out " ]
			} else {
				connect_net $net [ get_pins -of $new_cell_name -filter "direction == out " ]
				connect_net $new_net_name [ get_pins -of $new_cell_name -filter "direction == in " ]
			}
	
    			set bbox [ get_attr $pin bbox ]
			set location [ lindex $bbox 0 ]
			move_objects [get_cells  $new_cell_name] -to $location -ignore_fixed
			set_attribute [get_cells  $new_cell_name] is_fixed false
			set_attribute [get_cells  $new_cell_name] is_soft_fixed true
		}

	}
	puts "[get_attr [get_cells $cell] full_name] has clock output pins: [get_attr [get_pins $clock_pins] full_name]\n"
	
}

define_proc_attributes add_iso -info "Insert ISO buffer macro's PINS" \
  -define_args \
  { \
    	{-type "Specify the ref_name of ISO buffer" obj string required} \
	{-cell "Specify the cell which need to add ISO buffer" obj string required} \
	{-exclude "Specify the cell's pins which don't need to insert iso buffer" obj string optional} \
	{-only "Specify the cell's pins which need to insert iso buffer" obj string optional} \
  }
