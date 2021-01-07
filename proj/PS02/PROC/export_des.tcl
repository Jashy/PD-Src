
########################################################################
# change name
define_name_rules verilog -check_bus_indexing -allowed {a-zA-Z0-9_} \
 -remove_internal_net_bus -flatten_multi_dimension_busses -first_restricted "\\"
change_names -rules verilog -hier -verbose

#####################################################################
# save and reports
write_verilog -no_corner_pad_cells -no_pad_filler_cells -no_core_filler_cells -no_chip_cells -no_tap_cells -output_net_name_for_tie -supply_statement all tst.v
write_verilog -no_physical_only_cells  -output_net_name_for_tie -pg -force_no_output_references { bridge30_top P1DIODE P1DIODE8 PDIO8STL1_HD PDIODE} tst.v
write_verilog -no_physical_only_cells  -output_net_name_for_tie -force_no_output_references { bridge30_top P1DIODE P1DIODE8 PDIO8STL1_HD PDIODE}     ${SESSION}.run/${STEP}.v
#write_def -components -output ${SESSION}.run/${STEP}_comp.def
write_def -rows_tracks_gcells -vias -all_vias -nondefault_rule -components -pins -blockages -specialnets -nets -compressed -output all_${STEP}.def -lef ${STEP}.lef

save_mw_cel -as $MW_CEL
save_mw_cel -as ${STEP}
exec touch  ${STEP}.ready
exec touch                                                            ./${SESSION}.run/${STEP}.ready
#get_ideal_nets 40                                       > ${SESSION}.run/${STEP}_ideal_nets.cmd
#report_utilization                                      > ${SESSION}.run/${STEP}_utilization.rpt
#report_design -physical                                 > ${SESSION}.run/${STEP}_pr_summary.rpt
#check_legality -verbose                                 > ${SESSION}.run/${STEP}_check_legality.rpt
report_net_fanout -threshold  40 -nosplit               > ${SESSION}.run/${STEP}_net_fanout.rpt
#
#if { [ info exists scenarios_sdc ] == 1 } {
#  foreach mode [ array name scenarios_sdc ] {
#    current_scenario $mode
#    set STEP_SC ${STEP}_${mode}
#    report_constraint -all                                  > ${SESSION}.run/${STEP_SC}_constraints.rpt
#    report_timing -max 10000 -nosplit  -slack_less 0  -net -tran -cap -input -nosplit -derate > ${SESSION}.run/${STEP_SC}_setup.rep
#    exec ${TCL_SRC}/PT/check_violation_summary.pl   ${SESSION}.run/${STEP_SC}_setup.rep >  ${SESSION}.run/${STEP_SC}_setup.rep.summary
#  }
#} else {
#  report_constraint -all                                  > ${SESSION}.run/${STEP}_constraints.rpt
#  report_timing -max 10000 -nosplit  -slack_less 0  -net -tran -cap -input -nosplit -derate > ${SESSION}.run/${STEP}_setup.rep
#  exec ${TCL_SRC}/PT/check_violation_summary.pl   ${SESSION}.run/${STEP}_setup.rep >  ${SESSION}.run/${STEP}_setup.rep.summary
#}
#
