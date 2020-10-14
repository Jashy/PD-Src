#######################################################################
# step
source -e flow_btc/UPF/pt_lib.tcl
source -e flow_btc/UPF/set_operating_condition.tcl
sh mkdir -p .ECO OUTPUT Runtime Ready REPORT
set DATE [exec date +%m-%d]
set STEP ECO_${DATE}
set TOP LKB11

#-#-  remove_stdcell_filler -stdcell
remove_route_by_type -shield
#-#-  remove_route_by_type -shield -signal_detail_route

#######################################################################
#routing options
source -e ./flow_btc/tcl/022_place_constraint.tcl
source -e ./flow_btc/tcl/023_route_constraint.tcl

#-#-  #-#-  source -e -v /proj/BTC/WORK/carsonl/PT/TOP/20150907a_fp_3412x3442_8M/0908a/normal-mode/0p59wc_Cworst_125c_SS/OUTPUT/fix_setup.tcl >> ./.ECO/carson_eco.log
#-#-  #-#-  source -e -v /proj/BTC/WORK/carsonl/ICC/top/0908a/fix_fanout/fix_fanout.tcl >> ./.ECO/carson_eco.log
#-#-  source -e -v /proj/BTC/WORK/carsonl/PT/TOP/20150907a_fp_3412x3442_8M/0908b/fix_setup.tcl >> ./.ECO/carson_eco_2.log
#-#-  source -e -v /proj/BTC/WORK/carsonl/ICC/top/0908a/fix_slew.tcl >> ./.ECO/carson_eco_2.log
#-#-  source -e -v /proj/BTC/WORK/carsonl/fix_HD/TOP/0908a/fix_hd_eco.tcl >> ./.ECO/carson_eco_2.log
source -e -v /proj/BTC/WORK/carsonl/ICC/top/0908b/fix_noise.tcl >> ./.ECO/carson_eco_3.log
source -e -v /proj/BTC/WORK/carsonl/ICC/top/0908b/fix_slew.tcl >> ./.ECO/carson_eco_3.log
source -e -v /proj/BTC/WORK/carsonl/PT/TOP/20150907a_fp_3412x3442_8M/0908b/fix_setup.tcl >> ./.ECO/carson_3.log
source -e -v /proj/BTC/WORK/carsonl/fix_HD/TOP/0908b/fix_hd_eco.tcl >> ./.ECO/carson_3.log


legalize_placement -incremental
save_mw_cel -as ${STEP}
################################################################################
# Reroute
set noise_nets [get_nets -of [get_flat_cells *on_route*] ]
remove_net_shape [get_net_shapes -of $noise_nets]
remove_via [get_vias -of $noise_nets]
set_net_routing_rule $noise_nets  -rule DS_routing_rule


echo [sh date ] > ./Runtime/${STEP}
route_zrt_eco
create_zrt_shield -ignore_shielding_net_pins true -with_ground VSS
echo [sh date ] >> ./Runtime/${STEP}
save_mw_cel -as ${STEP}_route

source -e ./flow_btc/tcl/insert_filler.tcl
echo [sh date ] >> ./Runtime/${STEP}
insert_redundant_vias 
save_mw_cel -as insert_redundant_vias 

define_name_rules verilog -check_bus_indexing -allowed {a-zA-Z0-9_} -remove_internal_net_bus -flatten_multi_dimension_busses -first_restricted "\\"
change_names -rules verilog -hier -verbose

save_mw_cel -as ${STEP}_route
save_mw_cel

########################################################################
# export
set TOP LKB11
sh rm -rf ./OUTPUT/${TOP}.gds.gz
save_mw_cel -as pv_trial
set_write_stream_options -reset
set_write_stream_options -contact_prefix ${TOP}
set_write_stream_options -rename_cell ./flow_btc/tcl/rename_cell
set_write_stream_options -map_layer /proj/BTC/WORK/jasons/ICC/BTC/0803_8M/icv_stream_out_layer_map
set_write_stream_options -keep_data_type -child_depth 0 -max_name_length 128 -output_pin {geometry text}  -output_filling FILL -output_outdated_fill
write_stream -cells pv_trial -format gds ./OUTPUT/${TOP}.gds
sh gzip ./OUTPUT/${TOP}.gds 
sh touch ./Ready/icc_for_virtuso.ready

write_verilog -no_physical_only_cells  -output_net_name_for_tie  OUTPUT/${TOP}_fm.v
sh touch ./Ready/icc_for_fm.ready
write_verilog -no_physical_only_cells  -output_net_name_for_tie  OUTPUT/${TOP}_sta.v
sh touch ./Ready/icc_for_star.ready

