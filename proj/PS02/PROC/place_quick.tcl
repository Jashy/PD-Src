source $DONT_TOUCH_LIST
source $KEEP_LIST
source $DONT_USE_LIST

group_path -default      -weight 1.0 -critical_range 9.999
place_opt -effor low

save_mw_cel -as place
psynopt
save_mw_cel -as place_opt

set_false_path -from [ all_inputs ]
set_false_path -to [ all_outputs ]

report_timing -input -nets -nosp -max 10000 -slack_less 0 > GAIAIO.0126_init_timing_quick.run/place_opt.internal.rpt
exec /proj/Hydra5/TEMPLATES/PT/check_violation_summary.pl GAIAIO.0126_init_timing_quick.run/place_opt.internal.rpt > GAIAIO.0126_init_timing_quick.run/place_opt.internal.rpt.summary


