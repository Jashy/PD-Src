set VNET_LIST(r)	"_REF_NETLIST_"
set VNET_LIST(i)	"_PR_NETLIST_"
set TOP			"_TOP_"
set DATE		[ sh date +%m%d ]
set SESSION		${TOP}_${DATE}

sh rm -rf	${SESSION}.run
sh mkdir	${SESSION}.run

source -e ./fm_lib.tcl
#-#-  read_db /proj/BTC/LIB/SC/sc9mcpp84_base_lvt_c14/arm/samsung/ln14lpp/sc9mcpp84_base_lvt_c14/r3p2/db/sc9mcpp84_ln14lpp_base_lvt_c14_ss_nominal_max_0p59v_125c.db
#-#-  read_db /proj/BTC/LIB/SC/HPK/sc9mcpp84_hpk_lvt_c14/arm/samsung/ln14lpp/sc9mcpp84_hpk_lvt_c14/r3p0/db/sc9mcpp84_ln14lpp_hpk_lvt_c14_ss_nominal_max_0p59v_125c.db
#-#-  read_db /proj/BTC/LIB/SC/sc9mcpp84_base_lvt_c16/arm/samsung/ln14lpp/sc9mcpp84_base_lvt_c16/r3p2/db/sc9mcpp84_ln14lpp_base_lvt_c16_ss_nominal_max_0p59v_125c.db
#-#-  read_db /proj/BTC/LIB/SC/HPK/sc9mcpp84_hpk_lvt_c16/arm/samsung/ln14lpp/sc9mcpp84_hpk_lvt_c16/r3p0/db/sc9mcpp84_ln14lpp_hpk_lvt_c16_ss_nominal_max_0p59v_125c.db

set sh_new_variable_message		"false"         ; # default = "true"
set hdlin_auto_top			"false"         ; # default = "false"
set verification_failing_point_limit	999             ; # default = 20
set verification_blackbox_match_mode	"Identity"      ; # default = "Any"
expr 1
## for dummy clock gating
set verification_assume_reg_init	"None"		; # default = "Auto"
set verification_blackbox_match_mode	"Identity"      ; # default = "Any"

set SEV(fm,dup) ""
if {$SEV(fm,dup) != ""} {
	guide
	source $SEV(fm,dup)
	setup
}

#set verification_clock_gate_hold_mode low

################################################################################
# Read design
read_verilog -container r -libname WORK $VNET_LIST(r)
set_top r:/WORK/${TOP}
read_verilog -container i -libname WORK $VNET_LIST(i)
set_top i:/WORK/${TOP}
  
################################################################################
# case(function)
#-#-  set_constant i:/WORK/${TOP}/dft_mode    0
#-#-  set_constant i:/WORK/${TOP}/ip_bypass 0
#-#-  set_constant i:/WORK/${TOP}/scan_mode    0
#-#-  set_constant r:/WORK/${TOP}/scan_mode    0

match
  
report_unmatched_points > ${SESSION}.run/report_unmatched_points.rpt
report_matched_points   > ${SESSION}.run/report_matched_points.rpt
  
set result [verify r:/WORK/${TOP} i:/WORK/${TOP}]
  
report_failing > ${SESSION}.run/report_failing.rpt
report_passing > ${SESSION}.run/report_passing.rpt
report_aborted > ${SESSION}.run/report_aborted.rpt
  
if { $result == 1 } {
	exit
} else {
	save_session ${SESSION}.run/fail.session -replace
	start_gui
}
