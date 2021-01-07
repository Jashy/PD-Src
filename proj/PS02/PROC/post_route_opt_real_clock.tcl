set STEP post_route_opt
set compile_instance_name_suffix              "PRTEOPT"              ; # default = ""
#set pt_timing_rpt  /proj/R2SI/WORK/danielw/PT/STA/1014/sta_script_r2si_release0.1/post-layout/normal-mode/wcl_cworst_setup/all_vio_all.ocv_setup.rep

########################################################################
# post route opt
#
#
echo "INFO: read_sdc "
sh rm -f ${SESSION}.run/read_sdc.log
foreach SDC ${SDC_LIST} {
   source   -echo ${SDC} >> ${SESSION}.run/read_sdc.log
}

source ../tcl/timing_derate.tcl
source ../tcl/set_dont_use.tcl
source /proj/R2SI/WORK/jasonw/ICC/keep/TSMC_dontuse_080930.tcl
########################################################################
# SET KEEP/DONT_TOUCH NET/CELL
#
source /proj/R2SI/WORK/jasonw/ICC/keep/R2SI_DONT_TOUCH_WIRE_080930.tcl
source /proj/R2SI/WORK/jasonw/ICC/keep/TSMC_dontuse_080930.tcl
source /proj/R2SI/WORK/jasonw/ICC/keep/R2SI_KEEP_CELL_080930.tcl
#source /proj/R2SI/RELEASE/NETLIST/20081022_dft/R2SI_keep_mux.lis
source /proj/R2SI/WORK/danielw/ICC/1022_dft/R2SI_keep_mux.lis

set_false_path -from [ all_inputs]
set_false_path -to [all_outputs]
set_propagated_clock [all_clocks]
set high_fanout_net_threshold 8000
#report_timing -max 10000 -slack_less 0 -net -tran -cap -input > ${SESSION}.run/post_route_bf_opt_max.rpt
#exec /proj/${PROJ}/TEMPLATES/PT/check_violation_summary.pl  ${SESSION}.run/post_route_bf_opt_max.rpt \
#	 > ${SESSION}.run/post_route_bf_opt_max.rpt.summary

exec /proj/${PROJ}/WORK/danielw/ICC/tcl/GetMarginOnEndPoint.pl \
     $pt_timing_rpt > ./margin.tmp

source ../tcl/AddMarginOnEndPoint.tcl
post_route_margin ./margin.tmp
source ./margin.tcl

source ../tcl/timing_derate.tcl

#####################################################################
# Route settings
set_ignored_layers \
        -min_routing_layer M1 -max_routing_layer M5

set_si_options -route_xtalk_prevention true

set_route_options -same_net_notch check_and_fix \
                -wire_contact_eol_rule check_and_fix

#set_operating_conditions $operating_cond -analysis_type on_chip_variation
set_tlu_plus_files -max_tluplus $TLUP_MAX -tech2itf_map $TLUP_MAP
source ../tcl/skip_route.tcl

set_distributed_route
route_opt -incremental  -effort high \
		-num_cpus 2

#####################################################################
# change name
#
source ../tcl/timing_derate.tcl
define_name_rules verilog -check_bus_indexing -allowed {a-zA-Z0-9_} \
 -remove_internal_net_bus -flatten_multi_dimension_busses -first_restricted "\\"
change_names -rules verilog -hier -verbose

#####################################################################
# save data
#
save_mw_cel -as ${STEP}
save_mw_cel 
exec touch ./${SESSION}.run/${STEP}.ready
get_ideal_nets 40 > ${SESSION}.run/${STEP}_ideal_nets.cmd
write -format verilog -hierarchy   -output        ${SESSION}.run/${STEP}.v
write_def -version 5.4 -unit 1000 \
           -components -output ./${SESSION}.run/${STEP}.def
report_design -physical                         > ${SESSION}.run/${STEP}_pr_summary.rpt
report_utilization                              > ${SESSION}.run/${STEP}_utilization.rpt
report_net_fanout -threshold  32 -nosplit       > ${SESSION}.run/${STEP}_net_fanout.rpt
report_constraint -all                          > ${SESSION}.run/${STEP}_all.rpt
report_timing -max 10000 -slack_less 0 -net -tran -cap -input > ${SESSION}.run/${STEP}_max.rpt
exec /proj/${PROJ}/TEMPLATES/PT/check_violation_summary.pl  ${SESSION}.run/${STEP}_max.rpt > ${SESSION}.run/${STEP}_max.rpt.summary

exit
