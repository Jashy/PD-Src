
set VT_keywords  {"HDBULT08"  "HDBLVT08"  "HDBSVT08" }
#set VT_keywords_11  {"HDBULT11"  "HDBLVT11"  "HDBSVT11" }

set_parameter eco_cell_classify_rule {nominal_keywords}  ;# set the cell classify rule for gate sizing: cell_attribute, nominal_keywords, and nominal_regex
set_parameter eco_cell_nominal_swap_keywords $VT_keywords  ;# set the nominal keywords for swapping cells.

#
redirect  -file $report_dir/leakage_opt.rpt {puts "Before opt the memory is [mem] KB."}
set_dont_touch [get_io_path_pins ]
redirect -append -file $report_dir/lekage_opt.rpt {summarize_leakage_power -keywords $VT_keywords -as_reference}
redirect -append -file $report_dir/lekage_opt.rpt {summarize_gba_violations -exclude_path -as_reference -setup}
redirect -append -file $report_dir/lekage_opt.rpt {summarize_gba_violations -exclude_path -as_reference -hold}


########### Optimize leakage power #########
source $script_dir/dont_touch_use.tcl
#for leakage opt, must disable the use of the HVT cell
#set_dont_use {HD*HVT08_*} 0
#set_dont_use {HD*HVT11_*} 0
set_dont_use {HD*SVT08_*} 0
set_dont_use {HD*SVT11_*} 0
set_placement_constraint -max_displacement [list 0 0]
redirect -append -file $report_dir/lekage_opt.rpt {optimize_leakage_power -keywords $VT_keywords -setup_margin 0.050 -transition_margin 0.050}

########### Post opt report ################
redirect -append -file $report_dir/lekage_opt.rpt {puts "After opt the memory is [mem] KB."}
redirect -append -file $report_dir/leakage_opt.rpt {summarize_eco_actions}
redirect -append -file $report_dir/leakage_opt.rpt {summarize_leakage_power -keywords $VT_keywords -with_reference -with_delta}
redirect -append -file $report_dir/leakage_opt.rpt {summarize_gba_violations -exclude_path -with_reference -with_delta -setup}
redirect -append -file $report_dir/leakage_opt.rpt {summarize_gba_violations -exclude_path -with_reference -with_delta -hold}
