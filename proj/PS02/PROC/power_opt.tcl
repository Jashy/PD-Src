####################################################################
# power optimize
#
set_power_options -leakage true -leakage_effort high
set physopt_power_critical_range 0.4
psynopt -only_power
#place_opt -power

save_mw_cel -as power_opt
report_design -physical                                         > ${SESSION}.run/power_opt_pr_summary.rpt
report_utilization                                              > ${SESSION}.run/power_opt_utilization.rpt
report_net_fanout -threshold  20 -nosplit                       > ${SESSION}.run/power_opt_net_fanout.rpt
#report_congestion -congestion_effort high                       > ${SESSION}.run/power_opt_congestion.rpt
report_timing -max 10000 -nosplit  -slack_less 0  -net -tran -cap -input -nosplit > ${SESSION}.run/power_opt_max.rpt
write -format verilog -hierarchy   -output                        ${SESSION}.run/power_opt.v

