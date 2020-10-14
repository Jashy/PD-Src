echo "STEP:${STEP}"
#####################################################################
# save and reports

write_verilog -no_physical_only_cells  -output_net_name_for_tie         ./OUTPUT/${STEP}.v
sh touch ./Ready/${STEP}.ready

set Total_cells [sizeof_collection [get_flat_cells * -filter "mask_layout_type == std && is_physical_only == false" ]]  
set LVT_cells [sizeof_collection [get_flat_cells * -filter "ref_name =~ *TL_* && is_physical_only == false"]] 
set RVT_cells [sizeof_collection [get_flat_cells * -filter "ref_name =~ *TR_* && is_physical_only == false"]]
echo "Total cells : ${Total_cells} "     >  ./REPORT/${STEP}.info
echo "LVT cells : ${LVT_cells}"         >> ./REPORT/${STEP}.info
echo "RVT cells : ${RVT_cells}"         >> ./REPORT/${STEP}.info
report_placement_utilization            				>> ./REPORT/${STEP}.info
report_design -physical                                			> ./REPORT/${STEP}_pr_summary.rpt
check_legality -verbose                     			        > ./REPORT/${STEP}_check_legality.rpt
report_net_fanout -threshold  32 -nosplit              			> ./REPORT/${STEP}_net_fanout.rpt
foreach_in_collection net [get_nets -hierarchical *] {
	set net_name [get_attribute $net full_name ]
	set x_length [get_attribute $net x_length ]
	set y_length [get_attribute $net y_length ]
	if {$x_length == "" || $y_length == "" } {continue }
	set net_length [expr $x_length + $y_length ]
	if {$net_length > 120000} {echo "$net_name $net_length" >> ./REPORT/${STEP}_net_length.rpt}
}
################################################################################
#Write spef
if {$STEP == "xxxxxnoxxxxx"} {
	extract_rc 
	write_parasitics -format spef -compress  -output ./OUTPUT/hce.spef
}

################################################################################
#Write spef
if {$STEP == "reroute_clk"} {
	source -e ./flow_btc/tcl/insert_filler.tcl
	save_mw_cel -as pv_trial
	source -e ./flow_btc/tcl/write_gds.tcl
}

