proc split_clock_only {args } {

	set pin  [ lindex $args 0]
	set ECO_STRING  [ lindex $args 1]
	set ref_name  [ lindex $args 2]
	set pin_list [lindex $args 3]
	
	if { [ llength [get_lib_cells */$ref_name -q ]] == 0 } {
		puts "Error: $ref_name not exist!"
		break
	}
	if { [ llength [get_pins $pin -q ]] == 0 } {
		puts "Error: $pin not exist!"
		break
	}
	if { [ llength [get_pins $pin_list -q ]] == 0 } {
		puts "Error: $pin_list not exist!"
		break
	}
	set cell [get_cells -of $pin]
	set cell_name [get_attr [get_cells $cell] full_name]
	set cell_base_name [get_attr [get_cells $cell] base_name]
	set hier_cell [string trimright $cell_name ?$cell_base_name?]
	set net [get_nets -of [get_pins $pin]]
  	set net_name [get_attr [get_nets $net] full_name]
  	set net_base_name [get_attr [get_nets $net] base_name]
	
#	global ECO_STRING
#	if { [ info exists ECO_STRING ] == 0 } {
#	#	set DATE [ sh date +%y%m%d ]
#		set ECO_STRING ALCHIP_$net_base_name
#	}	

	set n 0
	set new_cell_name ${hier_cell}${ECO_STRING}_${net_base_name}_BUF_$n
    	set new_net_name  ${hier_cell}${ECO_STRING}_${net_base_name}_n$n
#	puts "$net_base_name\n"
#	puts "$new_cell_name\n"
#	puts "$new_net_name\n"
	while  { [ sizeof_collection [get_cells $new_cell_name -quiet] ] != 0  || [ sizeof_collection [get_nets $new_net_name -quiet]] != 0} {
		incr n
		set new_cell_name ${hier_cell}${ECO_STRING}_${net_base_name}_BUF_${n}
		set new_net_name  ${hier_cell}${ECO_STRING}_${net_base_name}_n${n}
	}
	create_net $new_net_name
	create_cell $new_cell_name $ref_name
#	puts "$new_cell_name\n"
#	puts "$new_net_name\n"
	
	set num 0
	set x 0
	set y 0
	
	foreach_in_collection p [get_flat_pins $pin_list] {
		incr num
		set pin_location [lindex [get_attribute [get_pins $p] bbox] 0]
		set x [expr $x + [lindex $pin_location 0]]
		set y [expr $y + [lindex $pin_location 1]]
	}
	set x [expr $x/$num]
	set y [expr $y/$num]

	set pin_location "$x $y" 
	move_objects -to $pin_location  [get_cells [list  $new_cell_name]]
	
	connect_net $net [ get_pins -of $new_cell_name -filter "direction == in " ]
	connect_net $new_net_name [ get_pins -of $new_cell_name -filter "direction == out " ]


	set drive_pin [ get_pins -of $new_cell_name -filter "direction == out " ]

	foreach_in_collection pin_name [get_pins $pin_list] {
		set command "disconnect_net [get_attribute [get_nets -of $pin_name] full_name]  [get_attribute [get_pins $pin_name] full_name]"
		puts $command
		eval $command
		set command "connect_pin -from [get_attribute [get_pins $pin_name] full_name]  -to [get_attribute [get_pins $drive_pin] full_name] -port_name $ECO_STRING"
		puts $command
		eval $command
	}
}
