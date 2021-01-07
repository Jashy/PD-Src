# Insert Power swith
get_lib_cells */HEADBUF16_X1M_A8TR_C34
set chan [ get_placement_blockage -filter "full_name=~*THIN_CHAN*" -type hard ]

source /proj/PS02/WORK/jasons/Block/GAIA/scripts/power_plan/utility/Insert_create_switch_in_channel.tcl
Insert_power_switch_in_channel $chan

create_power_switch_array -bounding_box {{0.260 0.260} {4369.820 2944.260}} -y_increment 2.4 -x_increment 60.06 -respect {hard_blockage}  -lib_cell {SW_PD_24_ALL:HEADBUF16_X1M_A8TR_C34} -prefix SW_PD_24_ALL


save_mw_cel -as switch_cell_inserted
# manually pick switch_cells as pre power on, set to $pre 628/56162
set pre [ get_selection ]
foreach_in_coll t_each_cell [get_cell $pre] {
	set t_ref_name [get_attr [get_cell $t_each_cell] base_name]
	regexp {SW_PD_24_ALL(\S+)SW_PD_24_ALL(\S+)} $t_ref_name "" str1 str2
	set t_replace_name SW_PD_24_PRE${str1}SW_PD_24_PRE${str2}
	set_name -type cell [get_cell $t_ref_name] -name $t_replace_name
}

## connect sc
connect_power_switch -source SCPRE_PD_24 -direction vertical -mode daisy -port_name SCPRE_PD_24 -ack_out SCPRE_OUT_PD_24 -ack_port_name SCPRE_OUT_PD_24 -start_point upper_left -auto -voltage_area DEFAULT_VA -object_list [get_cell *SW_PD_24_PRE*]
connect_power_switch -source SCALL_PD_24 -direction vertical -mode daisy -port_name SCALL_PD_24 -ack_out SCALL_OUT_PD_24 -ack_port_name SCALL_OUT_PD_24 -start_point upper_left -auto -voltage_area DEFAULT_VA -object_list [get_cell *SW_PD_24_ALL*]

set_attr [get_flat_cells -filter "ref_name == HEADBUF16_X1M_A8TR_C34" -all] is_fixed true

save_mw_cel -as b4_core_power

