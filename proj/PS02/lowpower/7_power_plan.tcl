derive_pg_connection -power_net VDD -power_pin VDDG  -cells *SW_PD_24_PRE* -reconnect
derive_pg_connection -power_net VDD -power_pin VDDG  -cells *SW_PD_24_ALL* -reconnect
derive_pg_connection -power_net VDD_PD24 -power_pin VDD -reconnect
derive_pg_connection -power_net VDD_PD24 -power_pin VDD -cells *SW_PD_24_ALL*  -reconnect
derive_pg_connection -power_net VDD_PD24 -power_pin VDD -cells *SW_PD_24_PRE*  -reconnect
derive_pg_connection -power_net VDD -power_pin VDDPE -reconnect
derive_pg_connection -power_net VDD1V_MEM -power_pin VDDCE -reconnect
derive_pg_connection -ground_net VSS -ground_pin VSS  -reconnect
derive_pg_connection -ground_net VSS -ground_pin VSSE  -reconnect
derive_pg_connection -power_net VDD1V_MEM -power_pin VDDO -reconnect
source /proj/PS02/WORK/jasons/Block/GAIA/Level_shift_1216/GAIA.vio.list_dft
derive_pg_connection -power_net VDD1V_MEM -power_pin VDDPE -reconnect -cells [get_cells $mems]
## core strap 

remove_route_guide *
source /DELL/proj/PS02/WORK/jasons/Block/script/GAIA/data/create_mem_blockage.tcl
source /proj/PS02/WORK/jasons/Block/GAIA/scripts/power_plan/utility/thin_blkg.tcl

remove_power_plan_strategy -all

create_mem_route_guide_M7  [all_macro_cells]
create_mem_route_guide_M6  [all_macro_cells]
create_mem_route_guide_M5  [all_macro_cells]

create_chan_route_guide_M5 [ get_placement_blockage -filter "full_name=~*THIN_CHAN*" -type hard ]
create_chan_route_guide_M6 [ get_placement_blockage -filter "full_name=~*THIN_CHAN*" -type hard ]
create_chan_route_guide_M7 [ get_placement_blockage -filter "full_name=~*THIN_CHAN*" -type hard ]


set_power_plan_strategy core_M7 -net {VDD VSS} \
-core \
-template /proj/PS02/WORK/jasons/Block/GAIA/scripts/power_plan/utility/core_strap.tpl:core_M7

set_power_plan_strategy core_M6 -net {VDD VDD_PD24 VSS} \
-core \
-template /proj/PS02/TEMPLATE/Power_switch_script_1012/1201_update/TEMP/Power/core_strap.tpl:core_M6

set_power_plan_strategy core_M5 -net {VDD VDD_PD24} \
-core \
-template /proj/PS02/WORK/jasons/Block/GAIA/scripts/power_plan/utility/core_strap.tpl:core_M5

set_power_plan_strategy core_M5_VSS -net {VSS} \
-core \
-template /proj/PS02/TEMPLATE/Power_switch_script_1012/1201_update/TEMP/Power/core_strap.tpl:core_M5_VSS




compile_power_plan

remove_route_guide -all

############# mem strap #######################

###notest############
#for memory_area, you should define it with the memory placed polygon like the M6 we drawing before.
#################

remove_power_plan_strategy -all

remove_route_guide -all

#set MEM_TOP [get_flat_cells -filter "is_hard_macro == true"]
set MEM_TOP [all_macro_cells]

set_power_plan_strategy MEM_M7 -net {VDD VDD1V_MEM VSS} \
-macro $MEM_TOP \
-template /proj/PS02/WORK/jasons/Block/GAIA/scripts/power_plan/utility/mem_strap.tpl:mem_strap_M7

set_power_plan_strategy MEM_M6 -net {VDD VDD1V_MEM VSS} \
-macro $MEM_TOP \
-template /proj/PS02/WORK/jasons/Block/GAIA/scripts/power_plan/utility/mem_strap.tpl:mem_strap_M6

set_power_plan_strategy MEM_M5 -net {VDD VDD1V_MEM VSS} \
-macro $MEM_TOP \
-template /proj/PS02/WORK/jasons/Block/GAIA/scripts/power_plan/utility/mem_strap.tpl:mem_strap_M5



####for polycon you need specify by your self & you may need some
#set_power_plan_strategy MEM_M6 -net {VDD VDD_PD24 VDD1V_MEM VSS} \
#-polygon {{0 0} {1075.400 0} {1075.4 296.850} {0 296.850} {0 0}} \
#-extension {{stop: 0}} \
#-template /proj/PS02/TEMPLATE/Power_switch_script_1012/1201_update/TEMP/Power/mem_strap.tpl:mem_strap_M6

compile_power_plan

#######create vias
set_preroute_drc_strategy -min_layer M2 -max_layer IB
create_preroute_vias -from_layer IB -to_layer IA -from_object_strap -to_object_strap
create_preroute_vias -from_layer IA -to_layer M7 -from_object_strap -to_object_strap
create_preroute_vias -from_layer M7 -to_layer M6 -from_object_strap -to_object_strap
create_preroute_vias -from_layer M6 -to_layer M5 -from_object_strap -to_object_strap
create_preroute_vias -from_layer M5 -to_layer M2 -from_object_strap -to_object_std_pin_connection -special_via_rule -special_via_x_offset 0.3 -special_via_y_offset 0.032 -special_via_x_size 0.6 -special_via_y_size 0.07 -special_via_x_step 50 -special_via_y_step 50
create_preroute_vias -from_layer M5 -to_layer M4 -from_object_strap -to_object_macro_io_pin -special_via_rule -special_via_x_offset 0.375 -special_via_y_offset 0.057 -special_via_x_size 0.75 -special_via_y_size 0.078 -special_via_x_step 50 -special_via_y_step 50


create_preroute_vias -from_layer M5 -to_layer M4 -from_object_strap -to_object_macro_io_pin -nets VSS -special_via_rule -special_via_x_offset 0.375 -special_via_y_offset 0.057 -special_via_x_size 0.75 -special_via_y_size 0.078 -special_via_x_step 50 -special_via_y_step 50
create_preroute_vias -from_layer M5 -to_layer M2 -from_object_strap -to_object_stap -nets VSS -special_via_rule -special_via_x_offset 0.3 -special_via_y_offset 0.032 -special_via_x_size 0.6 -special_via_y_size 0.07 -special_via_x_step 50 -special_via_y_step 50
######
remove_placement_blockage ICC_THIN_CHAN*

save_mw_cel -as  Power_plan

