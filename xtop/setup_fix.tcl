redirect -file $report_dir/setup_opt.rpt {puts "Before opt the memory is [mem] KB."}
redirect -append -file $report_dir/setup_opt.rpt {summarize_path_violations  -as_reference [get_paths -delay_type max -path_type "r2r clock_gating async"] }

set_parameter eco_cell_classify_rule {cell_attribute}  ;# set the cell classify rule for gate sizing: cell_attribute, nominal_keywords, and nominal_regex
set_parameter eco_cell_match_attribute {footprint} ;# set the size cell attribute matching type: footprint, user_function_class, pin_function
set_parameter eco_cell_nominal_swap_keywords {"HDBULT08" "HDBULT11"  "HDBLVT08" "HDBLVT11" "HDBSVT08" "HDBSVT11"}  ;# set the nominal keywords for swapping cells.
set_parameter eco_cell_nominal_sizing_pattern {_(\d+)$}  ;# set the nominal pattern for sizing cells.

#all the $variables defined in  xtop_config.tcl
set_placement_constraint -max_displacement [list 10 0]
set_parameter eco_new_object_prefix fix_setup_$keyword

set_dont_touch [get_io_path_pins ]
source $script_dir/dont_touch_use.tcl

#fix the setup by lowering VT
#redirect -tee -append -file $report_dir/setup_opt.rpt {fix_setup_path_violations -methods size_cell -size_rule nominal_keywords  -effort high  -hold_margin $eco_hold_slack_margin [get_paths -delay_type max -path_type "r2r clock_gating async"]}

#fix the setup by sizeup
#pba
#redirect -tee -append -file $report_dir/setup_opt.rpt {fix_setup_path_violations -methods size_cell -size_rule nominal_regex  -effort high  -hold_margin $eco_hold_slack_margin [get_paths -delay_type max -path_type "r2r clock_gating async"]}
#gba
redirect -tee -append -file $report_dir/setup_opt.rpt {fix_setup_gba_violations -methods size_cell -size_rule nominal_regex  -effort high  -hold_margin $eco_hold_slack_margin }

#fix the setup by insert buffer and size cell
#pba
#redirect -tee -append -file $report_dir/setup_opt.rpt {fix_setup_path_violations -setup_target 0.002 -buffer_list $eco_buffer_list_for_setup  -effort high  -hold_margin $eco_hold_slack_margin [get_paths -delay_type max -path_type "r2r clock_gating async"]}
#gba
redirect -tee -append -file $report_dir/setup_opt.rpt {fix_setup_gba_violations -setup_target 0.003 -buffer_list $eco_buffer_list_for_setup  -effort high  -hold_margin $eco_hold_slack_margin }

redirect -file $report_dir/setup_opt.rpt -append {puts "After opt the memory is [mem] KB."}
redirect -append -file $report_dir/setup_opt.rpt {summarize_eco_actions}
redirect  -append -file $report_dir/setup_opt.rpt {summarize_path_violations -with_reference -with_delta [get_paths -delay_type max -path_type "r2r clock_gating async"] }
#set failed_path [get_paths -upper_bound 0 -delay_type max -path_type "r2r clock_gating async"]
#if {[sizeof_collection $failed_path] >0 } {
#   report_path -truncate 1000 $failed_path   > $report_dir/setup_failed_path.rpt
#   report_fail_reasons  -truncate 1000 -paths $failed_path > $report_dir/setup_failed_reason.rpt
#}