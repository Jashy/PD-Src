###
set DATE 1010
source ./design_settings.tcl
open_mw_lib MDB_R2SIIO
open_mw_cel R2SIIO
#
source ../tcl/timing_derate.tcl

#set_false_path -from [ all_inputs]
#set_false_path -to [all_outputs]

report_timing -max 10000 -slack_less 0 -net -tran -cap -input > ${SESSION}.run/post_route_bf_opt_wo_derate_max_endpoints.rpt
exec /proj/${PROJ}/TEMPLATES/PT/check_violation_summary.pl  ${SESSION}.run/post_route_bf_opt_wo_derate_max_endpoints.rpt \
	 > ${SESSION}.run/post_route_bf_opt_wo_derate_max_endpoints.rpt.summary

exec /proj/${PROJ}/WORK/danielw/ICC/tcl/GetMarginOnEndPoint.pl \
     /proj/R2SI/WORK/danielw/PT/STA/1010_route_opt/sta_script_r2si_release0.1/post-layout/normal-mode/wcl_cworst_setup/all_vio_all.ocv_setup.rep \
     > ./margin.tmp
source ../tcl/AddMarginOnEndPoint.tcl
post_route_margin ./margin.tmp

source ../tcl/timing_derate.tcl

route_opt -incremental

 save_mw_cel -as post_route_opt_2
 save_mw_cel 
 exec touch ./${SESSION}.run/post_route_opt_2.ready
 write -format verilog -hierarchy   -output        ${SESSION}.run/post_route_opt_2_endpoint.v
 report_design -physical                                                 > ${SESSION}.run/post_route_opt_2_endpoint_pr_summary.rpt
 report_utilization                                                              > ${SESSION}.run/post_route_opt_2_endpoint_utilization.rpt
 report_net_fanout -threshold  32 -nosplit       > ${SESSION}.run/post_route_opt_2_endpoint_net_fanout.rpt
 report_violation                                  ${SESSION}.run/post_route_opt_2_endpoint_timing.rpt
 report_congestion -congestion_effort high       > ${SESSION}.run/post_route_opt_2_endpoint_congestion.rpt
 report_timing -max 10000 -slack_less 0 -net -tran -cap -input > ${SESSION}.run/post_route_opt_2_endpoint_max.rpt
 report_constraint -all                          > ${SESSION}.run/post_route_opt_2_endpoint_all.rpt
 exec /proj/${PROJ}/TEMPLATES/PT/check_violation_summary.pl  ${SESSION}.run/post_route_opt_2_endpoint_max.rpt > ${SESSION}.run/post_route_opt_2_endpoint_max.rpt.summary

exit
