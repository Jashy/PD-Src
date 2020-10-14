## logical
set sh_enable_line_editing true
set case_analysis_sequential_propagation never
set enable_page_mode false
set case_analysis_with_logic_constants false
## if you draw FB, you must modify this variable to guarantee ICC can analysis high fanout net
set high_fanout_net_threshold 5000
#set_extraction_options -fan_out_thres 2000
set placer_disable_auto_bound_for_gated_clock false
set collection_result_display_limit 100
set enable_recovery_removal_arcs true
set auto_restore_mw_cel_lib_setup true
set power_cg_auto_identify true
set physopt_delete_unloaded_cells false
set timing_remove_clock_reconvergence_pessimism false
set report_default_significant_digits 3
history keep 200
##physical
#set physopt_delete_unloaded_cells               "true"          ; # default = "true"
set compile_instance_name_prefix                "ALCHIP_U"      ; # default = "U"
set compile_instance_name_suffix                ""              ; # default = ""
set verilogout_no_tri                           "true"          ; # default = "false"
set timing_enable_multiple_clocks_per_reg       "true"          ; # default = "false"

