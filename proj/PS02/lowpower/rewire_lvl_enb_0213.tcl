
insert_buffer SCALL_PD_24 BUF_X4B_A8TR -new_cell_names ALCP_BUF_U0 -new_net_names ALCP_BUF_n0
insert_buffer ALCP_BUF_U0/Y BUF_X4B_A8TR -new_cell_names LVL_BUF_U0 -new_net_names LVL_BUF_n0
source /proj/PS02/WORK/jasons/Block/GAIA/scripts/lvluo_eco/scall_loads

set lvl_cels [get_object_name [get_flat_cells -filter "ref_name =~ O2LVLUO*"]]

foreach cell $lvl_cels {
	set cel [get_object_name [get_cells $cell]]
	echo "REWIRE LVL_BUF_U0/Y $cel/ENB" >> rewire_0213.tcl
	REWIRE LVL_BUF_U0/Y $cel/ENB
}

insert_buffer LVL_BUF_U0/Y BUF_X4B_A8TR -new_cell_names LVL_BUF_U1 -new_net_names LVL_BUF_n1

create_cell LVLUO_PD_24_U0 LVLUO_X4M_A8TR ##need move by manully##
create_net LVLUO_PD_24_n0
create_net LVLUO_PD_24_n1

disconnect_net LVL_BUF_n0 LVL_BUF_U0/Y
disconnect_net LVL_BUF_n0 LVL_BUF_U1/A

connect_net LVLUO_PD_24_n0 LVL_BUF_U0/Y
connect_net LVLUO_PD_24_n0 LVLUO_PD_24_U0/A
connect_net LVLUO_PD_24_n1 LVLUO_PD_24_U0/Y
connect_net LVLUO_PD_24_n1 LVL_BUF_U1/A

remove_buffer LVL_BUF_U1
