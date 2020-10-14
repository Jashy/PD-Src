set DESIGN	"_DESIGN_"
set NETLIST "_NETLIST_"
set SPEF    "_SPEF_"
set VCD     "_VCD_"
set SDC     "_SDC_"

set USE_CUSTOM_PWR_LIB 1
set DATE [ sh date +%m%d%y ]
set SESSION [ format "PTPX_%s_%s" ${DESIGN} ${DATE}]
sh mkdir -p ${SESSION}.run

################################################################################
###### CUP set 
set num_cpus 4 
#set_host_options -name tmp_name -max_cores $num_cpus
set_host_options -max_cores $num_cpus

## ENABLE POWER ANALYSIS
set power_enable_analysis TRUE
set power_analysis_mode time_based ; # time_based(must have vcd file), averaged
set power_limit_extrapolation_range true
set power_enable_clock_scaling true
set link_create_black_boxes false
## SET LIBRARY PATHS
source -echo  /DELL/proj/BTC/WORK/lukez/PTPX/PT_lib_20150615a.tcl

## READ NETLIST
exec  mkdir -p LOG
foreach VNET ${NETLIST} {
    echo "Reading ${VNET} ..." >> ./LOG/read_verilog.log
    read_verilog ${VNET}       >> ./LOG/read_verilog.log
  }


current_design $DESIGN 
link > ./LOG/link.log

#set_operating_conditions $oper_cond
#set power_domains_compatibility  true

## READ SDC
#read_sdc $SDC > read_sdc.log
echo "Reading ${SDC} ..."    > ./LOG/read_sdc.log
source -echo          ${SDC} >> ./LOG/read_sdc.log

#read_parasitics $SPEF
read_parasitics -format SPEF -keep_capacitive_coupling -increment $SPEF


report_annotated_parasitics -check -internal_nets -boundary_nets -constant_arcs -max_nets 99999 -list_not_annotated > ./annotated_parasitics.rpt 
update_timing

## READ VCD
read_vcd -strip_path	TB/u_hce/ $VCD 

## RUN POWER ANALYSIS
check_power -verbose -significant_digits 3 > ${SESSION}.run/check_power.rpt
update_power

save_session ${DESIGN}.pw.session

## GENERATE REPORTS
report_power -nosplit -verbose -hierarchy > ${SESSION}.run/power.hier.rpt
report_power -nosplit -verbose > ${SESSION}.run/power_total.rpt
report_power -nosplit -leaf -cell_power -sort_by total_power > ${SESSION}.run/cell_power.rpt
set_max_fanout 32 [current_design]
report_constraint -all -ver -max_fanout > ${SESSION}.run/max_fanout.rpt
report_switching_activity -list_not_annotated > ${SESSION}.run/switching_activity.rpt

exit

