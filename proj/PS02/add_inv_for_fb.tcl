## duplicate inv for fb driver

proc add_inv {source_cel  {num 2} } {

#set source_cel CLK_FRU_PD16_ISO_CLK_BUF_U0_Y_split_buf2_U0_Y_ALCHIP_151117_U0_dup_7 
#set num 4
echo "$num inv insert."
for {set i  $num}  {$i > 0} {incr i -1} {

	create_cell ${source_cel}_dup_inv_${i} INV_X20B_A8TR
	hilight_instance ${source_cel}_dup_inv_${i}
	connect_net [get_nets -of $source_cel/A] ${source_cel}_dup_inv_${i}/A
	connect_net [get_nets -of $source_cel/Y] ${source_cel}_dup_inv_${i}/Y
	
	set x_r [ lindex [ lindex [ get_attr [get_cells  $source_cel] bbox ] 1 ] 0 ]
        set x_l [ lindex [ lindex [ get_attr [get_cells  $source_cel] bbox ] 0 ] 0 ]
	set y_t [ lindex [ lindex [ get_attr [get_cells  $source_cel] bbox ] 1 ] 1 ]
	set y_b [ lindex [ lindex [ get_attr [get_cells  $source_cel] bbox ] 0 ] 1 ]
	
	set inv_x_l $x_l
	set inv_y_b [expr $y_b - $i * 1.6 ]

	move_objects ${source_cel}_dup_inv_${i} -x $inv_x_l -y $inv_y_b
	
	set_att ${source_cel}_dup_inv_${i} is_fixed true

}

}

