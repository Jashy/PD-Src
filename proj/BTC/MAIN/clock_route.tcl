#######################################################################
# step
sh mkdir -p ECO_LOG Runtime Ready
remove_route_by_type -signal_detail_route -clock_tie_off
 
################################################################################
save_mw_cel


set STEP CLOCK_0730
set compile_instance_name_suffix   "_${STEP}"
#-#-  source -e ./flow/tcl/2_2_create_scenarios.tcl
#-#-  legalize_placement -incremental -eco
################################################################################
# Route fishbone
source -e ./flow/tcl/set_route_rule.tcl

source -e ./flow/FB_route.tcl
source -e ./flow/CTS_route.tcl

#######################################################################

source -e ./flow/tcl/set_route_constrain.tcl
set_route_zrt_common_options -enforce_voltage_areas off
remove_pnet_options
#-#-  remove_bounds clkgen
############################DS routing 
#set_net_routing_layer_constraints  $DSnets  -min_layer M1  -max_layer M6
#set_net_routing_rule -rule double_spacing $DWDSnets -top_layer_probe  AnyPort -reroute  minorchange
#-#-  set clks [get_flat_nets -filter net_type=~Clock]
#-#-  #set att $clks net_type clock
#-#-  #double spacing double width
#-#-  set DSnets [get_att $clks full_name]
#-#-  route_zrt_group -nets  $DSnets
#-#-  save_mw_cel -as clock_route_done
#-#-  echo [sh date ] >> route_clock_time
#############################
#-#-  source -e ./flow/tcl/2_5_set_clock_ideal.tcl

echo [sh date ] > ./Runtime/${STEP}
route_zrt_auto 
echo [sh date ] >> ./Runtime/${STEP}

save_mw_cel -as ${STEP}

define_name_rules verilog -check_bus_indexing -allowed {a-zA-Z0-9_} -remove_internal_net_bus -flatten_multi_dimension_busses -first_restricted "\\"
change_names -rules verilog -hier -verbose

save_mw_cel -as ${STEP}
save_mw_cel

remove_placement_blockage [get_placement_blockages *L*]
source -e ./flow/tcl/insert_filler.tcl
source -e /proj/THP7312/WORK/arckeonw/Final/floorplan/Blkg/Blkg_FB_0722.tcl
source -e ./flow/tcl/via_opt.tcl

save_mw_cel
save_mw_cel -as ${STEP}
save_mw_cel -as CAMERA_TOP 
source -e /proj/THP7312/WORK/arckeonw/Final/floorplan/STEP_FOR_TIMING/connect_TX_Apin.tcl
write_verilog -no_physical_only_cells  -output_net_name_for_tie  ${SESSION}.run/${STEP}.v
sh touch ./Ready/${STEP}.ready

source -e /proj/THP7312/WORK/arckeonw/Final/floorplan/template/Route_guide.tcl
source -e ./flow/tcl/insert_metal_filler.tcl

save_mw_cel 
source -e /proj/THP7312/WORK/rexc/Data/LVS/derive_pg.tcl
write_verilog -pg  ${SESSION}.run/CAMERA_TOP_pg.v
source -e ./flow/write_gds.tcl
sh touch ./Ready/gds.ready

