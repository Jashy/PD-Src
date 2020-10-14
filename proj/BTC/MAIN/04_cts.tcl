set STEP CTS

################################################################################
#Prepare
set_active_scenarios normal
remove_case_analysis -all
remove_clock -all
remove_bounds -all
source -e ./flow_btc/define_route_rule.tcl

#create clock
set cts_pins [list "clk_ALCP_ISO_IN_U0/Y" ]
set i 0
foreach_in_collection pin [get_flat_pins $cts_pins] {
	set_object_fixed_edit [get_cells -of [get_pins $pin]] 1
	set_annotated_transition 0.1 [get_flat_pins $pin]
	create_clock -name cts_$i -period 10 [get_flat_pins $pin]
	remove_clock_tree -clock_trees cts_$i
	set_dont_touch [get_nets -of $pin] false
	remove_ideal_network [get_nets -of $pin]
        puts "INFO: remove ideal network -> [get_attribute [get_nets -of $pin] full_name]"
        puts "INFO: remove dont touch -> [get_attribute [get_nets -of $pin] full_name]"
	incr i
}

reset_clock_tree_options -all
set_clock_tree_options -target_skew 0.5 \
                       -max_capacitance 0.6 \
                       -max_transition 0.2 \
                       -layer_list {M2 M3 C4 C5 C6} \
                       -use_default_routing_for_sinks 1 \
                       -gate_sizing false \
                       -gate_relocation false \
                       -buffer_sizing true \
                       -buffer_relocation true \
                       -max_fanout 16 \
                       -ocv_clustering true \
		       -routing_rule DSDW_routing_rule
#-#-  set_dont_use [get_lib_cells */BUFH* ] false
remove_attribute [get_lib_cells */BUFH* ] dont_use
set_dont_use [get_lib_cells */BUF_* ]
reset_clock_tree_references
set_clock_tree_references -references {sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X4N_A9PP84TL_C14 sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X5N_A9PP84TL_C14 sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X6N_A9PP84TL_C14 sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X7N_A9PP84TL_C14 sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X8N_A9PP84TL_C14 sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X12N_A9PP84TL_C14 sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X10N_A9PP84TL_C14}
set_clock_tree_references -references {sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X4N_A9PP84TL_C14 sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X5N_A9PP84TL_C14 sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X6N_A9PP84TL_C14 sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X7N_A9PP84TL_C14 sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X8N_A9PP84TL_C14 sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X12N_A9PP84TL_C14 sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X10N_A9PP84TL_C14} -sizing_only
set_clock_tree_references -references {sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X4N_A9PP84TL_C14 sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X5N_A9PP84TL_C14 sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X6N_A9PP84TL_C14 sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X7N_A9PP84TL_C14 sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X8N_A9PP84TL_C14 sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X12N_A9PP84TL_C14 sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c/BUFH_X10N_A9PP84TL_C14} -delay_insertion_only

compile_clock_tree -clock_trees [get_clocks cts_*]
save_mw_cel -as compile_clock_tree
optimize_clock_tree  -buffer_sizing -buffer_relocation -clock_trees [get_attr [get_clocks cts_*] full_name] 
save_mw_cel -as optimize_clock_tree

#mark clock 
mark_clock_tree -clock_trees [get_clock cts_*] -clock_net
mark_clock_tree -clock_trees [get_clock cts_*] -clock_synthesized
mark_clock_tree -clock_trees [get_clock cts_*] -routing_rule DSDW_routing_rule -use_default_routing_for_sinks 1
reset_clock_tree_references

save_mw_cel -as clock_opt

define_name_rules verilog -check_bus_indexing -allowed {a-zA-Z0-9_} -remove_internal_net_bus -flatten_multi_dimension_busses -first_restricted "\\"
change_names -rules verilog -hier -verbose

source -e ./flow_btc/change_icg_2.tcl

save_mw_cel -as clock_opt

sh mkdir -p cts_report
report_clock_tree  > ./cts_report/skew.rpt

set_dont_use [get_lib_cells */BUFH* ]
#-#-  set_dont_use [get_lib_cells */BUF_* ] false
remove_attribute [get_lib_cells */BUF_* ] dont_use

reset_clock_tree_references
source -e ./flow_btc/tcl/021_create_scenarios.tcl
save_mw_cel -as $STEP
save_mw_cel 
source -e ./flow_btc/tcl/export_des.tcl 

