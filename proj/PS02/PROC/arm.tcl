
set case_analysis_with_logic_constants true
set_operating_conditions $operating_cond -analysis_type on_chip_variation
set_tlu_plus_files -max_tluplus $tlup_max -tech2itf_map $tlup_map


remove_sdc
read_sdc /proj/M4ES/i-ARM/RELEASE/SDC/PT_0814/normal.sdc
    set_clock_uncertainty -setup 0.200 [ all_clocks ]


set_propagated_clock [all_clocks]
set high_fanout_net_threshold 3000
set_false_path -from [all_inputs]
set_false_path -to [all_outputs]

##initial report
set STEP initial
change_names -rule verilog -hier
save_mw_cel 
save_mw_cel -as ${STEP}
report_timing -max 10000 -nosplit  -slack_less 0  -net -tran -cap -input -nosplit -derate -path full_clock_expanded > ${SESSION}.run/${STEP}_max.rpt
exec /proj/M4ES/TEMPLATES/PT/check_violation_summary.pl   ${SESSION}.run/${STEP}_max.rpt >  ${SESSION}.run/${STEP}_max.rpt.summary

report_design -physical > ${SESSION}.run/${STEP}_pr_summary.rpt

write -format verilog -hierarchy   -output        ${SESSION}.run/${STEP}.v




source ../tcl/AddMarginOnEndPoint.tcl
post_route_margin ./margin.rep

psynopt
save_mw_cel

source ../tcl/route.tcl
source ../tcl/route_opt.tcl





