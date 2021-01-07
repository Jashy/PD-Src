#set STRING place_opt
#set STRING psynopt_CaptureOcc_CaptureDc
#set STRING psynopt_CaptureOcc_psynopt2
#set STRING psynopt_normal
set STRING ECO_9_AC
#set STRING psynopt_after_HFO
remove_sdc -keep_parasitics
source $FUNC_SDC
#set_clock_uncertainty 0.2 [ all_clocks ]
source $DERATE
report_timing -max 10000 -nosplit  -slack_less 0  -net -tran -cap -input -nosplit -derate > ${SESSION}.run/${STRING}_normal_max.rpt
exec /proj/Hydra5/TEMPLATES/PT/check_violation_summary.pl    ${SESSION}.run/${STRING}_normal_max.rpt > ${SESSION}.run/${STRING}_normal_max.rpt.summary

remove_sdc -keep_parasitics
source $SCAN1_SDC
set_clock_uncertainty 0.3 [ all_clocks ]
source $DERATE
report_timing -max 10000 -nosplit  -slack_less 0  -net -tran -cap -input -nosplit -derate > ${SESSION}.run/${STRING}_scan_capture_dc_max.rpt
exec /proj/Hydra5/TEMPLATES/PT/check_violation_summary.pl    ${SESSION}.run/${STRING}_scan_capture_dc_max.rpt > ${SESSION}.run/${STRING}_scan_capture_dc_max.rpt.summary

remove_sdc -keep_parasitics
source $SCAN2_SDC
set_clock_uncertainty 0.3 [ all_clocks ]
source $DERATE
report_timing -max 10000 -nosplit  -slack_less 0  -net -tran -cap -input -nosplit -derate > ${SESSION}.run/${STRING}_scan_capture_occ_max.rpt
exec /proj/Hydra5/TEMPLATES/PT/check_violation_summary.pl    ${SESSION}.run/${STRING}_scan_capture_occ_max.rpt > ${SESSION}.run/${STRING}_scan_capture_occ_max.rpt.summary

remove_sdc -keep_parasitics
source $SCAN3_SDC
set_clock_uncertainty 0.3 [ all_clocks ]
source $DERATE
report_timing -max 10000 -nosplit  -slack_less 0  -net -tran -cap -input -nosplit -derate > ${SESSION}.run/${STRING}_scan_shift_dc_max.rpt
exec /proj/Hydra5/TEMPLATES/PT/check_violation_summary.pl    ${SESSION}.run/${STRING}_scan_shift_dc_max.rpt > ${SESSION}.run/${STRING}_scan_shift_dc_max.rpt.summary

remove_sdc -keep_parasitics
source $SCAN4_SDC
set_clock_uncertainty 0.3 [ all_clocks ]
source $DERATE
report_timing -max 10000 -nosplit  -slack_less 0  -net -tran -cap -input -nosplit -derate > ${SESSION}.run/${STRING}_scan_shift_occ_max.rpt
exec /proj/Hydra5/TEMPLATES/PT/check_violation_summary.pl    ${SESSION}.run/${STRING}_scan_shift_occ_max.rpt > ${SESSION}.run/${STRING}_scan_shift_occ_max.rpt.summary

