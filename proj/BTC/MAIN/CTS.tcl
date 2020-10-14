source -e flow_btc/UPF/pt_lib.tcl
source -e flow_btc/UPF/set_operating_condition.tcl
set_voltage 0.76 -object_list {VDD_PLL}
set_voltage 0.59 -object_list {VDD}
set_voltage 0.0 -object_list {VSS}
set STEP CTS

################################################################################
#Prepare
set_active_scenarios normal
#-#-  remove_case_analysis -all
#-#-  remove_bounds -all
source -e ./flow_btc/define_route_rule.tcl

#create clock
#-#-  set cts_pins [list "clk_ALCP_ISO_IN_U0/Y" ]
#-#-  set i 0
set cts_clocks {core_clk_top xclk}

remove_clock_tree -honor_dont_touch -clock_trees $cts_clocks
foreach_in_collection cts_clock [get_clocks $cts_clocks] {
	set clock_source [get_attribute [get_clocks $cts_clock] sources ]
	set_dont_touch [get_nets -segments -of $clock_source ] false
	remove_ideal_network [get_nets -segments -of $clock_source]
        puts "INFO: remove ideal network -> [get_attribute [get_nets -segments -of $clock_source] full_name]"
        puts "INFO: remove dont touch -> [get_attribute [get_nets -segments -of $clock_source] full_name]"
	if {[get_attribute $clock_source object_class] == "port"} {continue}
	set_object_fixed_edit [get_cells -of [get_pins $clock_source] ] 1
	set_annotated_transition 0.1 $clock_source
}

set_clock_tree_exceptions -clocks xclk -exclude_pins {u_pll_pd/u_car/u_pll_in_buf/u_sc_ckbuf/A u_pll_pd/u_car/u_ck_mux/u_sc_mux/B u_pad/uo_clko/A}
#-#-  set_clock_tree_exceptions -clocks core_clk_top -exclude_pins {u_pll_pd/u_car/u_ck_mux/u_sc_mux/A u_hce_pd/u_core_clk_wrap/CAR_CORE_CLK_ICG_*__u_icg/u_sc_icg/CK}
set_clock_tree_exceptions -clocks pll_clk_out -exclude_pins {u_pll_pd/u_car/u_ck_mux/u_sc_mux/A u_hce_pd/u_core_clk_wrap/CAR_CORE_CLK_ICG_*__u_icg/u_sc_icg/CK}

reset_clock_tree_options -all
set_clock_tree_options -target_skew 0.08 \
                       -max_capacitance 0.05 \
                       -max_transition 0.05\
                       -layer_list {M2 M3 C4 C5 C6} \
                       -use_default_routing_for_sinks 1 \
                       -gate_sizing false \
                       -gate_relocation false \
                       -buffer_sizing true \
                       -buffer_relocation true \
                       -max_fanout 16 \
                       -ocv_clustering true \
		       -routing_rule DSDW_shield_routing_rule

remove_attribute [get_lib_cells */BUFH* ] dont_use
set_dont_use [get_lib_cells */BUF_* ]
reset_clock_tree_references
set_clock_tree_references -references {sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X8N_A9PP84TL_C14 sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X12N_A9PP84TL_C14 sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X10N_A9PP84TL_C14 sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p76v_125c/BUFH_X8N_A9PP84TL_C14 sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p76v_125c/BUFH_X12N_A9PP84TL_C14 sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p76v_125c/BUFH_X10N_A9PP84TL_C14}
set_clock_tree_references -references {sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X8N_A9PP84TL_C14 sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X12N_A9PP84TL_C14 sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X10N_A9PP84TL_C14 sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p76v_125c/BUFH_X8N_A9PP84TL_C14 sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p76v_125c/BUFH_X12N_A9PP84TL_C14 sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p76v_125c/BUFH_X10N_A9PP84TL_C14} -sizing_only
set_clock_tree_references -references {sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X8N_A9PP84TL_C14 sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X12N_A9PP84TL_C14 sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X10N_A9PP84TL_C14 sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p76v_125c/BUFH_X8N_A9PP84TL_C14 sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p76v_125c/BUFH_X12N_A9PP84TL_C14 sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p76v_125c/BUFH_X10N_A9PP84TL_C14} -delay_insertion_only


set cts_clocks [get_attribute [get_clocks {xclk core_clk*}] name ]
echo [sh date] > ./Runtime/${STEP}
compile_clock_tree -clock_trees [get_clocks $cts_clocks]
save_mw_cel -as compile_clock_tree
optimize_clock_tree  -buffer_sizing -buffer_relocation -clock_trees [get_attr [get_clocks $cts_clocks] full_name] 
save_mw_cel -as optimize_clock_tree
echo [sh date] >> ./Runtime/${STEP}

#mark clock 
mark_clock_tree -clock_trees [get_clock $cts_clocks] -clock_net
mark_clock_tree -clock_trees [get_clock $cts_clocks] -clock_synthesized
mark_clock_tree -clock_trees [get_clock $cts_clocks] -routing_rule DSDW_shield_routing_rule -use_default_routing_for_sinks 1
reset_clock_tree_references

save_mw_cel -as clock_opt

define_name_rules verilog -check_bus_indexing -allowed {a-zA-Z0-9_} -remove_internal_net_bus -flatten_multi_dimension_busses -first_restricted "\\"
change_names -rules verilog -hier -verbose

source -e ./flow_btc/change_icg_2.tcl
save_mw_cel -as clock_opt

sh mkdir -p cts_report
report_clock_tree  > ./cts_report/skew.rpt

set_dont_use [get_lib_cells */BUFH* ]
remove_attribute [get_lib_cells */BUF_* ] dont_use

save_mw_cel -as $STEP
save_mw_cel 
#-#-  source -e ./flow_btc/tcl/export_des.tcl 

