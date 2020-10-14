#######################################################################
# step

set STEP reroute_clk
set compile_instance_name_suffix   "_ROUTE"
sh mkdir -p LOG Runtime Ready REPORT OUTPUT
################################################################################
#-#-  source -e ./flow_btc/tcl/insert_tie.tcl
#-#-  save_mw_cel -as tie_reinserted
########################################################################
#routing options
source -e ./flow_btc/tcl/022_place_constraint.tcl
source -e ./flow_btc/tcl/023_route_constraint.tcl
#-#-  remove_bounds *
#############################
source -e ./flow_btc/tcl/024_set_clock_idea.tcl

source -e /proj/BTC/WORK/arckeonw/ICC/TOP/20150901b_fp_3442x3442_8M_ECO0/buf2block_cts_nets.tcl
set_net_routing_rule [get_nets $buf2block_cts_nets ] -rule DSDW_shield_preroute_clk_routing_rule
set_net_routing_rule [get_nets -of [get_flat_cells *_ALCP_CLK_ANCHOR_L1_*] ]  -rule DSDW_shield_preroute_clk_routing_rule
set_net_routing_rule [get_nets -of [get_flat_cells *_ALCP_CLK_PREPLACE_*] ]  -rule DSDW_shield_preroute_clk_routing_rule
set icg2buf_clk_nets [add_to_collection [get_nets -of [get_flat_cells *_ALCP_CLK_ANCHOR_L1_*] ] [get_nets -of [get_flat_cells *_ALCP_CLK_PREPLACE_*] ] ]
set preroute_clk_nets [add_to_collection $icg2buf_clk_nets $buf2block_cts_nets ]
set_net_routing_rule -reroute freeze [get_flat_nets -of [get_flat_pins  */SNS ] ]
set_net_routing_rule -reroute freeze [get_flat_nets -of [get_flat_pins  */RTO ] ]


#-#-  check_routeability > ${SESSION}.run/check_routeability.log

echo [sh date ] > ./Runtime/${STEP}
set_ignored_layers -min_routing_layer C4 -max_routing_layer C7
route_zrt_group -nets $preroute_clk_nets
set_ignored_layers -min_routing_layer M2 -max_routing_layer C7
route_zrt_group -all_clock_nets

#-#-  set TX_nets [get_nets -of [get_pins u_hce_pd/u_eh/u_hce_*_tx_*__BLOCK_ISO_U0/Y]]
#-#-  set RX_nets [get_nets -of [get_pins u_hce_pd/u_eh/u_hce_*_rx_*__BLOCK_ISO_U0/A]]
#-#-  set preroute_signal_nets [add_to_collection $TX_nets $RX_nets]
#-#-  route_zrt_group -nets $preroute_signal_nets
#-#-  add_buffer_on_route -cell_prefix arc_on_route_20150902a -first_distance 30 -no_eco_route -no_legalize -punch_port -repeater_distance 100 $preroute_signal_nets sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X8N_A9PP84TL_C14
#-#-  legalize_placement -incr 
#-#-  save_mw_cel -as add_buffer_on_route

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
source -e ./flow_btc/tcl/export_des.tcl
