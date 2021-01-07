reset_upf
load_upf /proj/PS02/WORK/jasons/Block/GAIA/Path_group_1222/ECO_pw_1223/GAIA.upf
#derive_pg_connection -create_nets
#derive_pg_connection -reconnect

#derive_pg_connection -power_net VDD_PD24 -power_pin VDD -reconnect
#derive_pg_connection -power_net VDD_PD24 -power_pin VDD -cells *PD24_sw* 
#derive_pg_connection -power_net VDD_PD24 -power_pin VDD -cells *PD24_pre_sw* 
#derive_pg_connection -power_net VDD -power_pin VDDPE -reconnect
#derive_pg_connection -power_net VDD1V_MEM -power_pin VDDCE -reconnect
#derive_pg_connection -ground_net VSS -ground_pin VSS  -reconnect
#derive_pg_connection -ground_net VSS -ground_pin VSSE  -reconnect

#save_mw_cel -as b4_pg_rail
