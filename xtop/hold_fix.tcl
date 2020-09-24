redirect -file $report_dir/hold_fix.rpt {puts "Before opt the memory is [mem] KB."}
redirect -append -file $report_dir/hold_fix.rpt {summarize_path_violations  -as_reference [get_paths -delay_type min -path_type "r2r clock_gating async"] }
#report_fail_reasons  -truncate 1000 -paths [get_paths -upper_bound 0 -delay_type min -path_type "r2r clock_gating async"] > $report_dir/hold_vio_ini_path_detail.rpt

#all the $variables defined in  xtop_config.tcl
set_placement_constraint -max_displacement [list 10 0]
set_parameter eco_new_object_prefix fix_hold_$keyword

set_dont_touch [get_io_path_pins ]
source $script_dir/dont_touch_use.tcl

#pba
#redirect -tee -append -file $report_dir/hold_fix.rpt {fix_hold_path_violations -buffer_list $eco_buffer_list_for_hold  -effort high  -setup_margin $eco_setup_slack_margin [get_paths -delay_type min -path_type "r2r clock_gating async"]}
#gba
redirect -tee -append -file $report_dir/hold_fix.rpt {fix_hold_gba_violations -buffer_list $eco_buffer_list_for_hold  -effort high  -setup_margin $eco_setup_slack_margin }

redirect -file $report_dir/hold_fix.rpt -append {puts "After opt the memory is [mem] KB."}
redirect -append -file $report_dir/hold_fix.rpt {summarize_eco_actions}
redirect -file $report_dir/hold_fix.rpt -append {summarize_path_violations -with_reference -with_delta [get_paths -delay_type min -path_type "r2r clock_gating async"] }
set failed_path [get_paths -upper_bound 0 -delay_type min -path_type "r2r clock_gating async"]
if {[sizeof_collection $failed_path] >0 } {
   report_path -truncate 1000 $failed_path   > $report_dir/hold_failed_path.rpt
   report_fail_reasons  -truncate 1000 -paths $failed_path > $report_dir/hold_failed_reason.rpt
}
