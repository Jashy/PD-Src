#########################################################################
# area recovery
#
set physopt_area_critical_range 0.5
#place_opt -area_recovery -num_cpus 4
psynopt -area_recovery

save_mw_cel -as area_opt
report_design -physical                                         > ${SESSION}.run/area_opt_pr_summary.rpt
report_utilization                                              > ${SESSION}.run/area_opt_utilization.rpt
report_net_fanout -threshold  20 -nosplit                       > ${SESSION}.run/area_opt_net_fanout.rpt
report_congestion -congestion_effort high                       > ${SESSION}.run/area_opt_congestion.rpt
report_timing -max 10000 -nosplit  -slack_less 0  -net -tran -cap -input -nosplit > ${SESSION}.run/area_opt_max.rpt
report_constraint -all                                          > ${SESSION}.run/area_opt_all.rpt
write -format verilog -hierarchy   -output                        ${SESSION}.run/area_opt.v
#

