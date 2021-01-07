################################################
# Report timing with FB
set PROJ R2SI
set STEP fishbone


################################################
# Read SDC
#sh rm -f ${SESSION}.run/read_sdc.log
foreach SDC ${SDC_LIST} {
   source   -echo ${SDC} >> ${SESSION}.run/read_sdc_fishbone.log
}

set_propagated_clock [get_clocks [remove_from_collection [all_clocks] {v*} ] ]
set high_fanout_net_threshold 4000
source ../tcl/timing_derate.tcl


################################################
# Report clocks
report_clock -ttributes -nosplit 	>  ${SESSION}.run/${STEP}_fishbone_clock.rpt
report_clock -skew -nosplit 		>> ${SESSION}.run/${STEP}_fishbone_clock.rpt
report_clock -groups -nosplit 		>> ${SESSION}.run/${STEP}_fishbone_clock.rpt

report_clock_timing -type summary -nosplit > ${SESSION}.run/${STEP}_fishbone_clock.summary

#report_net_fanout -threshold  32 -nosplit       > ${SESSION}.run/${STEP}_net_fanout.rpt
report_constraint -all                          > ${SESSION}.run/${STEP}_all.rpt
report_timing -max 10000 -slack_less 0 -net -tran -cap -input > ${SESSION}.run/${STEP}_max.rpt
exec /proj/${PROJ}/TEMPLATES/PT/check_violation_summary.pl  ${SESSION}.run/${STEP}_max.rpt > ${SESSION}.run/${STEP}_max.rpt.summary

