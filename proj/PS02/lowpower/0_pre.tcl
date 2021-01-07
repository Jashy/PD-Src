#remove_net_routing [ get_flat_nets * -all]
#remove_stdcell_filler -tap -end_cap 
#create_port -direction "out" {SCPRE_OUT_PD_24 SCALL_OUT_PD_24}
create_net "SCPRE_OUT_PD_24 SCALL_OUT_PD_24"
connect_net SCPRE_OUT_PD_24 SCPRE_OUT_PD_24
connect_net SCALL_OUT_PD_24 SCALL_OUT_PD_24
#create_port -direction "in" {SCPRE_PD_24 SCALL_PD_24}
create_net "SCPRE_PD_24 SCALL_PD_24"
connect_net SCPRE_PD_24 SCPRE_PD_24
connect_net SCALL_PD_24 SCALL_PD_24
#create_terminal -bbox {0.000 2382.000 0.220 2382.050} -layer M4 -port SCPRE_OUT_PD_24 -direction right
#create_terminal -bbox {0.000 2382.300 0.220 2382.350} -layer M4 -port SCALL_OUT_PD_24 -direction right
#create_terminal -bbox {0.000 2382.600 0.220 2382.650} -layer M4 -port SCPRE_PD_24 -direction right
#create_terminal -bbox {0.000 2382.900 0.220 2382.950} -layer M4 -port SCALL_PD_24 -direction right
#
#derive_pg_connection -power_net VDD_PD24 -power_pin VDD -reconnect
#derive_pg_connection -power_net VDD_PD24 -power_pin VDD -cells *PD24_sw* 
#derive_pg_connection -power_net VDD_PD24 -power_pin VDD -cells *PD24_pre_sw* 
#derive_pg_connection -power_net VDD -power_pin VDDPE -reconnect
#derive_pg_connection -power_net VDD1V_MEM -power_pin VDDCE -reconnect
#derive_pg_connection -ground_net VSS -ground_pin VSS  -reconnect
#derive_pg_connection -ground_net VSS -ground_pin VSSE  -reconnect

