proc INSERT_INVTER {pin ref} {
	global ECO_STRING
	if {[info exists ECO_STRING] ==0} { set ECO_STRING ALCHIP_ECO }
	set pin_name [get_attribute [get_pins $pin] full_name]
	regexp {(\S+)/([a-zA-Z0-9]+)$} $pin_name "" cc pp
	set count 0 
	set new_inst_name [format "%s_%s_%s_U%d" $cc $pp $ECO_STRING $count]
	while { [ sizeof_collection [ get_cells $new_inst_name -quiet ] ] != 0 } {
		incr count
		set new_inst_name [format "%s_%s_%s_U%d" $cc $pp $ECO_STRING $count]
	}
	set drv_pin_col [get_pins -leaf -of_objects [get_nets -of_objects [get_pins $pin]] -filter "direction ==out"]
	foreach_in_collection drv_pin_tmp $drv_pin_col { set drv_pin [get_pins $drv_pin_tmp] }
	create_cell $new_inst_name [get_model $ref]
	connect_pin -from $drv_pin -to ${new_inst_name}/I -port_name $ECO_STRING
	disconnect_net [get_nets -of_objects [get_pins $pin]] ${pin}
	connect_pin -from ${new_inst_name}/ZN -to ${pin} -port_name $ECO_STRING        
	return $new_inst_name
}

