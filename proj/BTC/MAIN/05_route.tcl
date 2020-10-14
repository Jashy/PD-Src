#######################################################################
# step

set STEP route
set compile_instance_name_suffix   "_ROUTE"
################################################################################
#-#-  source -e ./flow_btc/tcl/insert_tie.tcl
#-#-  save_mw_cel -as tie_reinserted
########################################################################
#routing options
source -e ./flow_btc/tcl/022_place_constraint.tcl
source -e ./flow_btc/tcl/023_route_constraint.tcl
remove_bounds *
#############################
source -e ./flow_btc/tcl/024_set_clock_idea.tcl

set_net_routing_rule [get_nets -of [get_flat_cells *_ALCP_CLK_ANCHOR_L1_*] ]  -rule DSDW_shield_preroute_clk_routing_rule
set_net_routing_rule [get_nets -of [get_flat_cells *_ALCP_CLK_PREPLACE_*] ]  -rule DSDW_shield_preroute_clk_routing_rule
set preroute_clk_nets [add_to_collection [get_nets -of [get_flat_cells *_ALCP_CLK_ANCHOR_L1_*] ] [get_nets -of [get_flat_cells *_ALCP_CLK_PREPLACE_*] ] ]
set_net_routing_rule -reroute freeze [get_flat_nets -of [get_flat_pins  */SNS ] ]
set_net_routing_rule -reroute freeze [get_flat_nets -of [get_flat_pins  */RTO ] ]


check_routeability > ${SESSION}.run/check_routeability.log

echo [sh date ] > ./Runtime/${STEP}
set_ignored_layers -min_routing_layer C4 -max_routing_layer C7
route_zrt_group -nets $preroute_clk_nets
set_ignored_layers -min_routing_layer M2 -max_routing_layer C7
route_zrt_group -all_clock_nets
route_zrt_auto 
create_zrt_shield -ignore_shielding_net_pins true -with_ground VSS
echo [sh date ] >> ./Runtime/${STEP}

save_mw_cel -as ${STEP}
define_name_rules verilog -check_bus_indexing -allowed {a-zA-Z0-9_} -remove_internal_net_bus -flatten_multi_dimension_busses -first_restricted "\\"
change_names -rules verilog -hier -verbose

save_mw_cel
save_mw_cel -as ${STEP}

########################################################################
# export
foreach pin [get_attribute [get_pins u_hce_pd/u_core_clk_wrap/CAR_CORE_CLK_CKB_*__u_ckb/u_sc_ckbuf/Y] full_name ] { report_timing -from $pin -nosplit >> ./REPORT/buf2block.rpt }
source -e ./flow_btc/tcl/export_des.tcl
