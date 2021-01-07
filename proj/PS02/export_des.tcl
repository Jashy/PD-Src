##########################################################################################################
## - export design
##########################################################################################################
set SVAR(dst,mdb)      $SEV(out_dir)/$SEV(design_name).mdb
set SVAR(dst,vnet_sta) $SEV(out_dir)/$SEV(design_name).v
set SVAR(dst,vnet_lvs) $SEV(out_dir)/$SEV(design_name)_icc_pg.v
set SVAR(dst,vnet_pg) $SEV(out_dir)/$SEV(design_name)_pg.v
set SVAR(dst,ddc)      $SEV(out_dir)/$SEV(design_name)_lvs.ddc

set no_output_ref1  "N28_DMY_TCD_FH N28_DMY_TCD_FV ddr106_h ddr109_h PCLAMPC_V_G"
set no_output_ref   "FILLTIE4_A8TR ENDCAPTIE5_A8TR ENDCAPBIASNW5_A8TR FILLBIASNW4_A8TR PAVDDPAD_E33_33_NT_DR PAVDDSEC_18_18_NT_DR PAVSSPA_E33_33_NT_DR PAVSSSEC_18_18_NT_DR PBRKSEC_18_18_NT_DR PBRKSOPD_E33_33_NT_DR PBRKSOPDF_E33_33_NT_DR PBRKSOP_E33_33_NT_DR PBRKSOPF_E33_33_NT_DR PDVDD_E33_33_NT_DR PDVDDPAD_E33_33_NT_DR PDVSS_E33_33_NT_DR PDVSSPAD_E33_33_NT_DR PFILL10_18_18_NT_DR PFILL10_E33_33_NT_DR PFILL5_E33_33_NT_DR  PFILLLINK_E33_33_NT_DR_2R10U PFILLLINK_E33_33_NT_DR_3R10U PVBIASAT_E33_33_NT_DR PVDDILAD_E33_33_NT_DR PVDDILSEC_18_18_NT_DR PVDDLAD_E33_33_NT_DR PVDDPAD_E33_33_NT_DR PVSENSE_E33_33_NT_DR PVSENSETIE_E33_33_NT_DR PVSSLA_E33_33_NT_DR PVSSSEC_18_18_NT_DR PFILL5_18_18_NT_DR"
##################################################
## - Change name
##################################################
#if { $synopsys_program_name == "icc_shell" } { save_mw_cel -as $SEV(design_name) } ; # sometimes icc will crash when change name, so save first
#define_name_rules verilog -check_bus_indexing -allowed {a-zA-Z0-9_} -reserved_words {int} \
                          #-remove_internal_net_bus -flatten_multi_dimension_busses -first_restricted "\\0-9_"
#change_names -rules verilog -hierarchy
#
##################################################
## earily complete, save mdb, write verilog/def
##################################################

define_name_rules verilog -check_bus_indexing -allowed {a-zA-Z0-9_} -reserved_words {int} \
                           -remove_internal_net_bus -flatten_multi_dimension_busses -first_restricted "\\0-9_"
change_names -rules verilog -hierarchy


if { $synopsys_program_name == "icc_shell" } {
  set force_output    [ get_physical_lib_cell -quiet { FILLECOCAP48_A8TR FILLECOCAP24_A8TR FILLECOCAP12_A8TR FILLECOCAP6_A8TR ESDCLAMP11V ESDCLAMP18V} ]
  set force_no_output [ get_physical_lib_cell -quiet { ddr106_h ddr109_h PCLAMPC_V_G} ]
  save_mw_cel -as $SEV(design_name)
  #if { "$SEV(icc,data_tmp_dir)$SVAR(dst,mdb)" != $SVAR(dst,mdb) } {
  #  exec cp -r $SEV(icc,data_tmp_dir)$SVAR(dst,mdb) $SVAR(dst,mdb)
  #}
  alcp_export -type netlist    "write_verilog -force_no_output_references \"$no_output_ref\" -diode_ports -no_physical_only_cells $SVAR(dst,vnet_sta)"
  #alcp_export -type netlist    "write_verilog -force_no_output_references \"$no_output_ref1\" -diode_ports -no_physical_only_cells $SVAR(dst,vnet_sta)_w_LDO_BGR.v"
  #alcp_export -type netlist_dc "write_verilog -force_no_output_references \"$no_output_ref\" -no_physical_only_cells $SEV(out_dir)/$SEV(design_name).dc.v"
  #alcp_export -type netlist_pg "write_verilog -pg -no_physical_only_cells -no_pad_filler_cells -force_output_references \"[get_attr $force_output name]\" \
                                              -force_no_output_references \"[get_attr $force_no_output name]\" -diode_ports \
                                              $SVAR(dst,vnet_lvs)"
  #alcp_export -type netlist_pg "write_verilog -pg -no_physical_only_cells -no_pad_filler_cells \
                                              -force_no_output_references \"[get_attr $force_no_output name]\" -diode_ports \
                                              $SVAR(dst,vnet_pg)"
  #report_names -rules verilog -hierarchy > $SEV(rpt_dir)/report_names.rep
  #alcp_export -type def        "write_def -version 5.7 -output  $SEV(out_dir)/$SEV(design_name)-components.def -components -compressed"
  #alcp_export -type def        "write_def -version 5.7 -output  $SEV(out_dir)/$SEV(design_name).def -all_vias -compressed"
  #write_def -version 5.7 -output  $SEV(out_dir)/$SEV(design_name).def -all_vias -compressed
  #write_def -version 5.7 -output  $SEV(out_dir)/$SEV(design_name).def -compressed
  #if { [ sizeof_coll [ get_power_domains -quiet ] ] } {
    #save_upf -supplemental $SEV(out_dir)/$SEV(design_name)_supplement_with_pg.upf -include_supply_exceptions
  #}
 #if { [ regexp {route|gds} $SEV(dst) ] && $SEV(design_name) != "PS02" }  {
   #source -e -v /proj/PS02/WORK/jasons/Block/GAIA/scripts/gdsout.tcl
   #source -e -v /proj/PS02/WORK/jasons/Block/GAIA/scripts/vnetout_pg.tcl
 #}
#} elseif { $synopsys_program_name == "dc_shell" } {
  #alcp_export -type netlist    "write -f verilog -h -o $SEV(out_dir)/$SEV(design_name).v"
  #alcp_export -type ddc        "write -f ddc -h -o     $SEV(out_dir)/$SEV(design_name).ddc"
  #write_def -version 5.7 -output  $SEV(out_dir)/$SEV(design_name)-components.def -components
#}
#
#foreach scenario [ lindex [ get_scenarios -dynamic_power true normal-* ] 0 ] {
  #set mode [ lindex [ split $scenario "-" ] 0 ]
  #write_saif -propagated -output $SEV(out_dir)/$SEV(design_name)-${mode}.saif
  #exec gzip $SEV(out_dir)/$SEV(design_name)-${mode}.saif
#}
#
#extract_rc -coupling_cap
#alcp_export -type spef "write_parasitics  -format SPEF -output $SEV(out_dir)/$SEV(design_name).${scenario}.spef"

## touch
exec touch $SEV(sum_dir)/early_complete
sproc_msg -info "Waiting $SEV(sum_dir)/early_complete.unlock ..."
while { [ file exists $SEV(sum_dir)/early_complete.unlock ] == 0 } {
  exec sleep 1
}

##################################################
## after earily complete
##################################################
## model
if { $SEV(design_name) != "PS02" } {
  if { $synopsys_program_name == "icc_shell" } {  alcp_export -type fram "create_macro_fram" }
  ## block_abstraction
  if { [all_scenarios] != "" } {
    alcp_export -type block_abstraction "create_block_abstraction"
  }
  save_mw_cel -as $SEV(design_name)
}

##################################################
## reports
##################################################
#printvar * > $SEV(rpt_dir)/printvar.rpt

#foreach scenario [ get_scenarios -setup true ] {
#  current_scenario $scenario
#  alcp_export -type report_case_analysis       -file $SEV(rpt_dir)/report_case_analysis_${scenario}.rpt      { report_case_analysis -all -nosplit }
#  alcp_export -type report_timing -file $SEV(rpt_dir)/report_timing_${scenario}.rep {report_timing -capacitance -transition_time -nets -input_pins -nosplit -significant_digits 3 -max_paths 1000000 -slack_lesser_than 0  -delay_type max}
#  if { [ file exists $SEV(rpt_dir)/report_timing_${scenario}.rep ] == 1 } {
#    exec $SEV(scripts_dir)/utility_scripts/check_violation_summary.pl $SEV(rpt_dir)/report_timing_${scenario}.rep > $SEV(rpt_dir)/report_timing_${scenario}.rep.summary
#    exec gzip $SEV(rpt_dir)/report_timing_${scenario}.rep
#    #alcp_export -type alcp_report_qor -file $SEV(rpt_dir)/report_alcp_qor_${scenario}.rep "alcp_report_qor $SEV(rpt_dir)/report_timing_${scenario}.rep.summary"
#  }
#  # alcp_export -type alcp_set_max_clock_latency -file $SEV(rpt_dir)/alcp_set_max_clock_latency_${scenario}.tcl     {alcp_set_max_clock_latency}
#  ## internal
#  set_false_path -from [ all_inputs ]
#  set_false_path -to [ all_outputs ]
#  alcp_export -type report_timing -file $SEV(rpt_dir)/report_timing_internal_${scenario}.rep {report_timing -capacitance -transition_time -nets -input_pins -nosplit -significant_digits 3 -max_paths 1000000 -slack_lesser_than 0  -delay_type max}
#  if { [ file exists $SEV(rpt_dir)/report_timing_internal_${scenario}.rep ] == 1 } {
#    exec $SEV(scripts_dir)/utility_scripts/check_violation_summary.pl $SEV(rpt_dir)/report_timing_internal_${scenario}.rep > $SEV(rpt_dir)/report_timing_internal_${scenario}.rep.summary
#    exec gzip $SEV(rpt_dir)/report_timing_internal_${scenario}.rep
#    #alcp_export -type alcp_report_qor -file $SEV(rpt_dir)/report_alcp_qor_internal_${scenario}.rep "alcp_report_qor $SEV(rpt_dir)/report_timing_internal_${scenario}.rep.summary"
#  }
#  alcp_export -type report_si -file $SEV(rpt_dir)/report_si_${scenario}.rpt {report_constraints -max_transition -max_capacitance -all_violators -nosplit}
#}

gui_start -no_windows
gui_create_window -type LayoutWindow
alcp_export -type snapshot_fp               "snapshot_fp $SEV(rpt_dir)/floorplan"
alcp_export -type snapshot_short            "snapshot_short $SEV(rpt_dir)/drc_short"
alcp_export -type snapshot_congestion       "snapshot_congestion $SEV(rpt_dir)/congestion_map"
alcp_export -type snapshot_cell_density     "snapshot_cell_density $SEV(rpt_dir)/cell_density"
alcp_export -type snapshot_hier_all         "snapshot_hier_all $SEV(rpt_dir)/module_distr"
if { [ info exists snap_hier_conf ] } {
  if { $snap_hier_conf != "" } {
    alcp_export -type snapshot_hier_by_conf     "snapshot_hier_by_conf \"$snap_hier_conf\" $SEV(rpt_dir)/module_distr"
  }
}
gui_show_toolbar -all
stop_gui
# change soft blockage to hard blockage
if { $synopsys_program_name == "icc_shell" } {
  soft_to_hard [ get_placement_blockage -type soft ]
}
suppress_message  PSYN-670
remove_keepout_margin [ get_lib_cells */* ]
remove_keepout_margin [ get_cells -hier * ]
# for initial design stage, check library and input data.
alcp_export -type report_units               -file $SEV(rpt_dir)/report_units.rpt              {report_units}
alcp_export -type check_library              -file $SEV(rpt_dir)/check_library.rpt             {check_library}
alcp_export -type report_qor                 -file $SEV(rpt_dir)/report_qor.rpt                {report_qor}
alcp_export -type report_qor_sum             -file $SEV(rpt_dir)/report_qor.rpt                {report_qor -summary}
alcp_export -type write_link_library         -file $SEV(rpt_dir)/write_link_library.rpt        {write_link_library -full_path_lib_names}
if { $synopsys_program_name == "icc_shell" } {
  alcp_export -type report_utilization         -file $SEV(rpt_dir)/placement_utilization.rpt     {report_placement_utilization -verbose}
  alcp_export -type report_pr_summary          -file $SEV(rpt_dir)/pr_summary.rpt                {report_design -physical}
  alcp_export -type report_max_fanout          -file $SEV(rpt_dir)/max_fanout.rpt                "report_net_fanout -threshold $syn_max_fanout -nosplit"
  alcp_export -type report_design_physical     -file $SEV(rpt_dir)/report_design_physical.rpt    {report_design_physical -all -verbose}

  if { [ regexp {route} $SEV(dst) ] }  {
     verify_lvs -max_error 20000 -ignore_floating_port  \
                                 -ignore_floating_net -ignore_eeq_pin -ignore_min_area \
                                 -ignore_blockage_overlap -ignore_floating_metal_fill_net \
                                 -check_open_locator -check_short_locator \
                                 -error_cell check_lvs.err

     set my_cel_id [open_mw_cel -not_as_current check_lvs.err]
     report_drc_error_type -error_view $my_cel_id > $SEV(rpt_dir)/lvs_summary.rpt
  }

  if { [ llength [ get_scenarios normal-ml_rcworst_125c_min-cts_leakage ] ] != 0 } {
    set leakage_scenario normal-ml_rcworst_125c_min-cts_leakage
  } else {
    set leakage_scenario [ lindex [ get_scenarios -leakage_power true ] 0 ]
  }

  if { $leakage_scenario == "" } { set leakage_scenario [ current_scenario ] }
  
  alcp_export -type report_power               -file $SEV(rpt_dir)/report_power                       {report_power -nosplit -scenario $leakage_scenario }
  alcp_export -type report_vt_ratio            -file $SEV(rpt_dir)/report_threshold_voltage_group.rpt {report_threshold_voltage_group}
  alcp_export -type check_legality             -file $SEV(rpt_dir)/check_legality.rpt              {check_legality -verbose}
  alcp_export -type report_congestion          -file $SEV(rpt_dir)/report_congestion.rpt              {report_congestion}
  alcp_export -type report_extraction_options  -file $SEV(rpt_dir)/report_extraction_options.rpt      {report_extraction_options -scenario [all_active_scenarios] -all }
  alcp_export -type report_clock_timing        -file $SEV(rpt_dir)/report_clock_timing.rpt            {report_clock_timing -nosplit -type skew -scenarios [get_scenarios -active true -setup true]}
  alcp_export -type report_clock_tree          -file $SEV(rpt_dir)/max_clock_tree.rpt                 {report_clock_tree -nosplit -summary -scenarios [get_scenarios -active true -setup true]}
  alcp_report_voltage_group
  #if { [ regexp {route} $SEV(dst) ] }  {
  #  source -e -v /proj/onepiece3/TEMPLATE/scripts_2015.04.21_PS02/scripts/ICC/gdsout_PS02.tcl
  #}
}
#if { $synopsys_program_name != "dc_shell" } {
  exit
#}
