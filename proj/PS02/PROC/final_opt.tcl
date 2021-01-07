###################################################################
# FINAL OPTIMIZE
#

########################################################################
# PATH GROUP
#
group_path -default      -weight 10 -critical_range 9.999
group_path -name from_in -weight 0.5 -critical_range 9.999 -from [ all_inputs  ]
group_path -name to_out  -weight 0.5 -critical_range 9.999 -to   [ all_outputs ]
set_false_path -from [ all_inputs  ]
set_false_path -to [all_outputs   ]
report_path_group >      ${SESSION}.run/path_group.rpt

#check_timing  > ./${SESSION}.run/check_timing.log
#report_timing > ./${SESSION}.run/timing_report_bf_place.rpt

psynopt
change_names -rule verilog -hier
save_mw_cel -as final_opt -over

report_design -physical                                                                         > ${SESSION}.run/final_opt_pr_summary.rpt
report_utilization                                                                                      > ${SESSION}.run/final_opt_utilization.rpt
report_net_fanout -threshold  20 -nosplit                               > ${SESSION}.run/final_opt_net_fanout.rpt
report_congestion -congestion_effort high                               > ${SESSION}.run/final_opt_congestion.rpt
report_timing -max 10000 -nosplit  -slack_less 0  -net -tran -cap -input -nosplit       > ${SESSION}.run/final_opt_max.rpt
report_constraint -all                                                  > ${SESSION}.run/final_opt_all.rpt
write -format verilog -hierarchy   -output                                ${SESSION}.run/final_opt.v
write_def -unit 1000  -output                                                             ${SESSION}.run/final_opt.def
exec /proj/M4ES/TEMPLATES/PT/check_violation_summary.pl           ${SESSION}.run/final_opt_max.rpt >  ${SESSION}.run/final_opt_max.rpt.summary

sizeof_collection [get_cells * -filter "@ref_name =~ *HVT*" -hier] >  ${SESSION}.run/post_physopt_hvt_count
sizeof_collection [get_cells *  -hier]  >  ${SESSION}.run/post_physopt_cell_count


