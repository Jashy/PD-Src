#set STEP route_opt_incr
#set compile_instance_name_suffix              "RTEOPTINCR"              ; # default = ""
#
############################################################
## ROUTE OPT
##
# set case_analysis_with_logic_constants true
# set_operating_conditions $operating_cond -analysis_type on_chip_variation
# set_tlu_plus_files -max_tluplus $TLUP_MAX -tech2itf_map $TLUP_MAP
#
# set_si_options -delta_delay true\
#                -static_noise false\
#                -route_xtalk_prevention true
#
# set_route_options  -same_net_notch check_and_fix
# set_net_routing_layer_constraints * -min_layer_name M1 -max_layer_name M5
#
# source ../tcl/skip_route.tcl
#
#source /proj/R2SI/WORK/jasonw/ICC/keep/TSMC_dontuse_080930.tcl
#source ../tcl/set_dont_use.tcl
#
## set_distributed_route
#
# echo "INFO: start of route_opt"
# echo [exec date]
# source ../tcl/timing_derate.tcl
#
# set_distributed_route
# route_opt -effort high -area_recovery -skip_initial_route \
#	   -num_cpus 2
# echo "INFO: end of route_opt"
# echo [exec date]
#
# report_timing_derate > ${SESSION}.run/route_opt_timing_derate.rpt
#
# define_name_rules verilog -check_bus_indexing -allowed {a-zA-Z0-9_} \
# 	-remove_internal_net_bus -flatten_multi_dimension_busses -first_restricted "\\"
# change_names -rule verilog -hier
######################################################################
## save and reports
##
# save_mw_cel -as ${STEP}
# save_mw_cel 
# write_def -version 5.4 -unit 1000 \
#	   -components -output ./${SESSION}.run/${STEP}.def
# get_ideal_nets 40 > ${SESSION}.run/${STEP}_ideal_nets.cmd
# write -format verilog -hierarchy   -output      	  	${SESSION}.run/${STEP}.v
# exec touch ./${SESSION}.run/${STEP}.ready
# report_utilization						> ${SESSION}.run/${STEP}_utilization.rpt
# report_design -physical			 		> ${SESSION}.run/${STEP}_pr_summary.rpt
# report_net_fanout -threshold  20 -nosplit      		> ${SESSION}.run/${STEP}_net_fanout.rpt
## report_congestion -congestion_effort high      		> ${SESSION}.run/${STEP}_congestion.rpt
# report_constraint -all                         		> ${SESSION}.run/${STEP}_all.rpt
# report_timing -max 10000 -nosplit  -slack_less 0  -net -tran -cap -input -nosplit -derate > ${SESSION}.run/${STEP}_max.rpt
# exec /proj/M4ES/TEMPLATES/PT/check_violation_summary.pl   ${SESSION}.run/${STEP}_max.rpt >  ${SESSION}.run/${STEP}_max.rpt.summary

###########################################################
## ROUTE OPT INCREMENTAL (optional)
##
 set STEP route_opt_incr
 set compile_instance_name_suffix              "RTEOPTINCR"              ; # default = ""
 set case_analysis_with_logic_constants true
 set_operating_conditions $operating_cond -analysis_type on_chip_variation
 set_tlu_plus_files -max_tluplus $TLUP_MAX -tech2itf_map $TLUP_MAP

 set_si_options -delta_delay true\
                -static_noise false\
                -route_xtalk_prevention true

 set_route_options  -same_net_notch check_and_fix
 set_net_routing_layer_constraints * -min_layer_name M1 -max_layer_name M5

 source ../tcl/skip_route.tcl

source /proj/R2SI/WORK/jasonw/ICC/keep/TSMC_dontuse_080930.tcl
########################################################################
# SET KEEP/DONT_TOUCH NET/CELL
#
source /proj/R2SI/WORK/jasonw/ICC/keep/R2SI_DONT_TOUCH_WIRE_080930.tcl
source /proj/R2SI/WORK/jasonw/ICC/keep/TSMC_dontuse_080930.tcl
source /proj/R2SI/WORK/jasonw/ICC/keep/R2SI_KEEP_CELL_080930.tcl
#source /proj/R2SI/RELEASE/NETLIST/20081022_dft/R2SI_keep_mux.lis
source /proj/R2SI/WORK/danielw/ICC/1022_dft/R2SI_keep_mux.lis

###dont touch clock nets
set dft_clk [list BUF_bp/Z \
                bist_clk_buf1/Z \
                bist_clk_buf2/Z \
                bist_clk_buf3/Z]

foreach driver $dft_clk {
        set clk_net [get_attr [get_nets -of $driver] full_name]
        puts "set_dont_touch $clk_net"
        set_dont_touch ${clk_net}
        }


source ../tcl/set_dont_use.tcl
#
 source ../tcl/timing_derate.tcl
set_max_transition      0.5       [current_design]

# set_false_path -from [ all_inputs]
# set_false_path -to [all_outputs]
 echo "INFO: start of route_opt_incr"
 echo [exec date]
 route_opt -incremental -effort high -only_design_rule
 echo "INFO: end of route_opt_incr"
 echo [exec date]

define_name_rules verilog -check_bus_indexing -allowed {a-zA-Z0-9_} \
 	-remove_internal_net_bus -flatten_multi_dimension_busses -first_restricted "\\"
 change_names -rule verilog -hier

#####################################################################
# save and reports
#
 save_mw_cel 
 save_mw_cel -as ${STEP}
 exec touch ./${SESSION}.run/${STEP}.ready
 get_ideal_nets 40 > ${SESSION}.run/${STEP}_ideal_nets.cmd
 write -format verilog -hierarchy   -output      	  	${SESSION}.run/${STEP}.v
 report_utilization						> ${SESSION}.run/${STEP}_utilization.rpt
 report_design -physical			 		> ${SESSION}.run/${STEP}_pr_summary.rpt
 report_net_fanout -threshold  20 -nosplit      		> ${SESSION}.run/${STEP}_net_fanout.rpt
# report_congestion -congestion_effort high      		> ${SESSION}.run/${STEP}_congestion.rpt
 report_constraint -all                         		> ${SESSION}.run/${STEP}_all.rpt
 report_timing -max 10000 -nosplit  -slack_less 0  -net -tran -cap -input -nosplit -derate > ${SESSION}.run/${STEP}_max.rpt
 exec /proj/M4ES/TEMPLATES/PT/check_violation_summary.pl   ${SESSION}.run/${STEP}_max.rpt >  ${SESSION}.run/${STEP}_max.rpt.summary
exit
