########################################################################
# DEFINE VARIABLES
#
set mw_power_net   VDD
set mw_ground_net  VSS
set mw_power_port  VDD
set mw_ground_port VSS
set mw_logic1_net  VDD
set mw_logic0_net  VSS
#set MW_LIB MDB_${TOP}
set MW_CEL GAIAIO_FB

create_mw_lib -tech $TECH_FILE MDB_FB
set_mw_lib_reference -mw_reference_library $MW_REF_LIB ./MDB_FB
open_mw_lib MDB_FB

sh rm -f ${SESSION}.run/read_verilog.log
foreach VNET ${VNET_LIST} {
  read_verilog ${VNET} >> ${SESSION}.run/read_verilog.log
}
current_design ${TOP}
uniquify
link > ${SESSION}.run/link.log

########################################################################
# READ SDC
#
echo "INFO: read_sdc "
sh rm -f ${SESSION}.run/read_sdc.log
source   -echo ${FUNC_SDC} >> ${SESSION}.run/read_sdc.log

save_mw_cel -as $MW_CEL
echo "INFO: read_def start"
#set_fp_options -unit_tile_name {core bcore}
#set mw_site_name_mapping "core unit"
if { ${FB_DEF} != "" } {
  current_design ${TOP}
   read_def -allow_physical  -enforce_scaling  ${FB_DEF} > ${SESSION}.run/read_fb_def.log
}

source /proj/Hydra5/RELEASE/20090305_FP/delnet_pw_analog.tcl

read_def -allow_physical  -enforce_scaling  ${DEF} > ${SESSION}.run/read_fp_def.log

legalize_placement 

set_route_mode_options -zroute true

set_ignored_layers  -min_routing_layer M1 -max_routing_layer M5
set_tlu_plus_files -max_tluplus $TLUP_MAX -tech2itf_map $TLUP_MAP
set_route_options -same_net_notch check_and_fix

set_delay_calculation -clock_arnoldi
set_route_zrt_global -clock_topology comb -comb_distance 4
route_zrt_group -from_file /proj/Hydra5/WORK/keith/mgm/20090212/export/GAIAIO%fb-adjust.clk -max_detail_route_iterations 20
save_mw_cel -as fishbone_routing

route_zrt_auto -max_detail_route_iterations 20

save_mw_cel -as detail_routing
