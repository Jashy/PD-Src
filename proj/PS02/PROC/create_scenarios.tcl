######################################################################
## Two scenarios are defined: wc_leakage/wcl_timing
## Each scenario must define SDC/operating_cond/tlu+/derate

remove_scenario -all

foreach mode [ array name scenarios_sdc ] {
  puts "*INFO Create scenario: $mode*"
  create_scenario $mode

  source -echo $scenarios_sdc($mode) >> ${SESSION}.run/read_sdc.${mode}.log

#  set a ""
#  set a [get_pins -hier */EMA[*]]
#  foreach_in_collection b $a {
#    set c [get_attribute $b full_name]
#    set_case_analysis 0 [ get_pins  $c  ]
#    echo "set 0 to $c"
#  }

  source ${TCL_SRC}/set_design_constrain.tcl

  set_operating_conditions $operating_cond -analysis_type on_chip_variation -lib $operating_cond_lib
  set_tlu_plus_files -max_tluplus $TLUP_MAX -tech2itf_map $TLUP_MAP

  ########################################################################
  # PATH GROUP
  set weight_default 5
  set weight_AC      5
  if { $STEP == "psynopt" } { set weight_AC 1}

  set_critical_range 10 [current_design]
  group_path -default      -weight $weight_default -critical_range 9.999

  foreach_in_collection clock [ get_clocks * ] {
    set clock_name [ get_attr $clock full_name ]
    group_path -name $clock_name -weight $weight_default -critical_range 10 -to $clock
  }

  group_path -name from_in -weight $weight_AC -critical_range 15 -from [all_inputs]
  group_path -name to_out  -weight $weight_AC -critical_range 15 -to   [all_outputs]
  if { $mode == "normal" } {
    group_path -name ARMCLK  -weight 10 -critical_range 10 -from [get_clocks ARMCLK]
    group_path -name ARMCLK  -weight 10 -critical_range 10 -to [get_clocks ARMCLK]
    group_path -name MICLK   -weight 10 -critical_range 10 -to [get_clocks MICLK]
  }
#  report_path_group >      ${SESSION}.run/path_group.rpt

}

#################################################################
if { [ info exists scenarios_sdc ] == 1 } {
  set_scenario_options -leakage_power true -scenarios [ array name scenarios_sdc ]
  report_scenario_options -scenarios [all_scenarios] > ${SESSION}.run/scenario_options_all.${STEP}.rpt
  
  set_active_scenario -all
  report_scenario  > ${SESSION}.run/initial_all.scenario.${STEP}.rpt
} else {

  source ${TCL_SRC}/set_design_constrain.tcl

  ########################################################################
  # PATH GROUP
  set weight_default 5
  set weight_AC      5
  if { $STEP == "psynopt" } { set weight_AC 1}

  set_critical_range 10 [current_design]
  group_path -default      -weight $weight_default -critical_range 9.999

  foreach_in_collection clock [ get_clocks * ] {
    set clock_name [ get_attr $clock full_name ]
    group_path -name $clock_name -weight $weight_default -critical_range 10 -to $clock
  }

  group_path -name from_in -weight $weight_AC -critical_range 15 -from [all_inputs]
  group_path -name to_out  -weight $weight_AC -critical_range 15 -to   [all_outputs]
#  group_path -name ARMCLK  -weight 10 -critical_range 10 -from [get_clocks ARMCLK]
#  group_path -name ARMCLK  -weight 10 -critical_range 10 -to [get_clocks ARMCLK]
#  group_path -name MICLK   -weight 10 -critical_range 10 -to [get_clocks MICLK]
}


