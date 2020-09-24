redirect -file $report_dir/tran_fix.rpt {puts "Before opt the memory is [mem] KB."}
redirect -append -file $report_dir/tran_fix.rpt {summarize_transition_violations  -as_reference }

set_parameter eco_cell_classify_rule {cell_attribute}  ;# set the cell classify rule for gate sizing: cell_attribute, nominal_keywords, and nominal_regex
set_parameter eco_cell_match_attribute {footprint} ;# set the size cell attribute matching type: footprint, user_function_class, pin_function
set_parameter eco_cell_nominal_swap_keywords {"HDBULT08" "HDBULT11"  "HDBLVT08" "HDBLVT11" "HDBSVT08" "HDBSVT11"}  ;# set the nominal keywords for swapping cells.
set_parameter eco_cell_nominal_sizing_pattern {_(\d+)$}  ;# set the nominal pattern for sizing cells.

#all the $variables defined in  xtop_config.tcl
set_placement_constraint -max_displacement [list 10 0]
set_parameter eco_new_object_prefix fix_tran_$keyword

set_dont_touch [get_io_path_pins ] 0
source $script_dir/dont_touch_use.tcl

#fix the transition by lowering VT
#redirect -tee -append -file $report_dir/tran_fix.rpt {fix_transition_violations -methods size_cell -size_rule nominal_keywords }

#fix the transition by sizeup cell
redirect -tee -append -file $report_dir/tran_fix.rpt {fix_transition_violations -methods size_cell -size_rule nominal_regex}

#fix the transition by all available method
redirect -tee -append -file $report_dir/tran_fix.rpt {fix_transition_violations -buffer_list $eco_buffer_list_for_setup}

redirect -file $report_dir/tran_fix.rpt -append {puts "After opt the memory is [mem] KB."}
redirect -append -file $report_dir/tran_fix.rpt {summarize_eco_actions}
redirect  -append -file $report_dir/tran_fix.rpt {summarize_transition_violations -with_reference -with_delta }
if {[sizeof_collection [get_transition_violated_pins]]>0} {
  report_fail_reasons  -truncate 1000 -pins [get_transition_violated_pins] > $report_dir/tran_failed_pins.rpt
}