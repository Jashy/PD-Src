proc CHANGE_BUF2INV {cell ref} {
	set new_inv_name [format "%s_tmp_inv" $cell]
	create_cell $new_inv_name [get_model $ref]
	connect_net [get_nets -of_objects ${cell}/I] ${new_inv_name}/I
	connect_net [get_nets -of_objects ${cell}/Z] ${new_inv_name}/ZN
	move_object $new_inv_name -to [get_attribute $cell origin]
	remove_buffer $cell
	#rename $new_inv_name $cell 
}
