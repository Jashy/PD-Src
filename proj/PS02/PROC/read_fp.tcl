########################################################################
# step
set STEP read_fp

########################################################################
# FLOORPLAN
echo "INFO: read_def start"

if { ${FP_DEF} != "" } {
   current_design ${TOP}
   read_def -allow_physical  -enforce_scaling  ${FP_DEF} > ${SESSION}.run/read_def.log
}

########################################################################
# connect standard cell PG
derive_pg_connection 	-power_net $mw_power_net -ground_net $mw_ground_net \
			-power_pin $mw_power_pin -ground_pin $mw_ground_pin


if { ${COMP_DEF} != "" } {
  read_def $COMP_DEF
}

########################################################################
# reports
#check_physical_constraints
#write_floorplan ./fp.tcl -placement {io hard_macro soft_macro} -row -track 
#report_net_fanout -threshold  100 -nosplit      > ${SESSION}.run/initial_net_fanout.rpt
#report_design -physical 			> ${SESSION}.run/initial_pr_summary.rpt
#report_utilization				> ${SESSION}.run/initial_utilization.rpt
#source /user/home/marshals/utility/ICC/proces/convert_blockage.tcl
#convert_blockage 8


save_mw_cel 
save_mw_cel -as $STEP
