proc split_clock {{pin ""} {ref_name ""} {exclude ""} } {

	########################################################################
 	 # USAGE
 	 #
  	proc usage_split_clock { } {
   	 puts {Usage: split_clock <driver_pin_name> <ref_name> <exclude pin name> }
   	 puts {           [ {split_pin_list}]}
 	 }

 	 ########################################################################

	if { [ llength [get_lib_cells */$ref_name -q ]] == 0 } {
		puts "Error: $ref_name not exist!"
		usage_split_clock
		return 0
	}
	if { [ llength [get_pins $pin -q ]] == 0 } {
		puts "Error: $pin not exist!"
		 return 0
	}


	set pin [get_pins $pin]
	set cell [get_cells -of $pin]
	set cell_name [get_attr [get_cells $cell] full_name]
	set cell_base_name [get_attr [get_cells $cell] base_name]
	set hier_cell [string trimright $cell_name ?$cell_base_name?]
	set net [get_nets -of [get_pins $pin]]
  	set net_name [get_attr [get_nets $net] full_name]
  	set net_base_name [get_attr [get_nets $net] base_name]
	set new_cell_name_1 ${hier_cell}ALCHIP_${net_base_name}_BUF_1
	set new_cell_name_2 ${hier_cell}ALCHIP_${net_base_name}_BUF_2
	set new_net_name_1  ${hier_cell}ALCHIP_${net_base_name}_n1

	if { [ sizeof_collection [get_cells $new_cell_name_1 -quiet] ] != 0 } {
			puts "Error: Exists buffer $new_cell_name_1 ."
		        break	
		}
	if { [ sizeof_collection [get_cells $new_cell_name_2 -quiet] ] != 0 } {
			puts "Error: Exists buffer $new_cell_name_2 ."
		        break	
		}

	if { [ sizeof_collection [get_nets $new_net_name_1 -quiet]] != 0 } {
			puts "Error: Exists net $new_net_name_1."
		        break	
		}
	
	if { [ info exists ECO_STRING ] == 0 } {
	#	set DATE [ sh date +%y%m%d ]
		set ECO_STRING ALCHIP_$net_base_name
	}	
	create_net $new_net_name_1
	create_cell $new_cell_name_1 $ref_name
	create_cell $new_cell_name_2 $ref_name

	set pin_location [lindex [get_attribute [get_pins $pin] bbox] 0]
	move_objects -to $pin_location  [get_cells [list  $new_cell_name_1 $new_cell_name_2]]
	disconnect_net $net $pin
	connect_net $new_net_name_1 $pin
	connect_net $net [ get_pins -of $new_cell_name_1 -filter "direction == out " ]
	connect_net $new_net_name_1 [ get_pins -of $new_cell_name_1 -filter "direction == in " ]
	connect_net $new_net_name_1 [ get_pins -of $new_cell_name_2 -filter "direction == in " ]

	set drive_pin [ get_pins -of $new_cell_name_2 -filter "direction == out " ]
	set leaf_pins [get_pins -leaf -of_objects [get_nets $net] -filter direction==in]
	set non_ck_pins ""
	foreach_in_collection leaf_pin $leaf_pins {
		set cell [get_cells -of_objects $leaf_pin]
		if { [get_attribute [get_cells $cell] is_combinational] } {
			if {[sizeof_collection [get_pins $non_ck_pins -quiet]] ==0 } { 
				set non_ck_pins [get_pins $leaf_pin]
			} else {
				set non_ck_pins [add_to_collection $non_ck_pins [get_attr [get_pins $leaf_pin] full_name]]
			}
		}
	}

	if {$exclude!=""} {
		set non_ck_pins [get_pins $exclude -q]
	}

	foreach_in_collection pin_name $non_ck_pins {
		set command "disconnect_net [get_attribute [get_nets -of $pin_name] full_name]  [get_attribute [get_pins $pin_name] full_name]"
		puts $command
		eval $command
		set command "connect_pin -from [get_attribute [get_pins $pin_name] full_name]  -to [get_attribute [get_pins $drive_pin] full_name] -port_name $ECO_STRING"
		puts $command
		eval $command
	}
}
