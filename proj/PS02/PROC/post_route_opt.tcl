set STEP post_route_opt
set compile_instance_name_suffix              "PRTEOPT"              ; # default = ""
#set pt_timing_rpt  /proj/R2SI/WORK/danielw/PT/STA/1014/sta_script_r2si_release0.1/post-layout/normal-mode/wcl_cworst_setup/all_vio_all.ocv_setup.rep
########################################################################
# READ SDC
#
echo "INFO: read_sdc "
sh rm -f ${SESSION}.run/read_sdc.log
foreach SDC ${SDC_LIST} {
   source   -echo ${SDC} >> ${SESSION}.run/read_sdc.log
}

########################################################################
# post route opt
#

source ../tcl/timing_derate.tcl
source ../tcl/set_dont_use.tcl
source /proj/R2SI/WORK/jasonw/ICC/keep/TSMC_dontuse_080930.tcl
########################################################################
# SET KEEP/DONT_TOUCH NET/CELL
#
source /proj/R2SI/WORK/jasonw/ICC/keep/TSMC_dontuse_080930.tcl 
source /proj/R2SI/WORK/jasonw/SDC/20081031/R2SI_KEEP_CELL.tcl 
source /proj/R2SI/WORK/jasonw/SDC/20081031/R2SI_DONT_TOUCH_WIRE.tcl 
source /proj/R2SI/WORK/jasonw/ICC/keep/R2SI_keep_mux.lis

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


source ../tcl/timing_derate.tcl
set_false_path -from [ all_inputs]
set_false_path -to [all_outputs]
#set_propagated_clock [all_clocks]
#set high_fanout_net_threshold 8000
report_timing -max 10000 -slack_less 0 -net -tran -cap -input > ${SESSION}.run/post_route_bf_opt_max.rpt
exec /proj/${PROJ}/TEMPLATES/PT/check_violation_summary.pl  ${SESSION}.run/post_route_bf_opt_max.rpt \
	 > ${SESSION}.run/post_route_bf_opt_max.rpt.summary

exec /proj/WyvernES2/WORK/danielw/R2SI/ICC/tcl/GetMarginOnEndPoint.pl \
     $pt_timing_rpt > ./margin.tmp

source ../tcl/AddMarginOnEndPoint.tcl
post_route_margin ./margin.tmp
source ./margin.tcl

report_timing -max 10000 -slack_less 0 -net -tran -cap -input > ${SESSION}.run/post_route_bf_opt_withMargin_max.rpt
exec /proj/${PROJ}/TEMPLATES/PT/check_violation_summary.pl  ${SESSION}.run/post_route_bf_opt_withMargin_max.rpt \
	 > ${SESSION}.run/post_route_bf_opt_withMargin_max.rpt.summary


set bist_list { U_i_ren3ot_0_Alchip_pinshare_eco0_4/U1/Z U_i_rxtlen_0_Alchip_pinshare_eco0_5/U1/Z }
foreach net $bist_list {
        set_dont_touch ${net}
}


route_opt -incremental -effort high

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

set_clock_uncertainty -setup 0.80 [ all_clocks ]

report_timing -max 10000 -slack_less 0 -net -tran -cap -input > ${SESSION}.run/${STEP}_0.8Margin_max.rpt
exec /proj/${PROJ}/TEMPLATES/PT/check_violation_summary.pl  ${SESSION}.run/${STEP}_0.8Margin_max.rpt > ${SESSION}.run/${STEP}_0.8Margin_max.rpt.summary

exit
