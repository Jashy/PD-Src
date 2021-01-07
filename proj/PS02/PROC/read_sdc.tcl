### sdc in
set SDC_LIST "/proj/NSP2/CURRENT/STA/robinsu/CENTER_CCX/center_ccx_data/CENTER_CCX_my.tcl"
foreach SDC ${SDC_LIST} {
 redirect -tee ${SESSION}.run/read_sdc.log { source -echo ${SDC} }
}

#redirect -tee ${SESSION}.run/check_timing.log { check_timing }
#redirect -tee ${SESSION}.run/timing_require.rpt { report_timing_requirements -nosplit }

foreach_in_collection clock [ all_clocks ] {
  if { [get_attribute $clock sources] != "" } {
    set_dont_touch_network $clock
  }
  set_clock_transition 0.3 $clock
}
if { ${CLOCK_MODE} == "ideal" } {
  set_clock_uncertainty -setup 0.300 [ all_clocks ]
  set_clock_uncertainty -hold 0.100 [ all_clocks ]
  set default_clock_transition 0.300
  set pins {}
  foreach_in_collection clock [ all_clocks ] {
    set pp [get_attribute $clock full_name]
    echo $pp
    foreach_in_collection source [ get_attribute $clock sources ] {
      #set pins [ add_to_collection $pins [ filter_collection [ all_fanout -flat -from $source ] "is_clock_pin == true" ] ]
      set_ideal_network $source
    }
  }
}
remove_propagated_clock [all_clocks]
#set_operating_conditions  -max $STA_COND -max_library $lib_name
set_operating_conditions -max ss_typical_max_0p90v_125c -max_library sc12_cln65gplus_base_lvt_ss_typical_max_0p90v_125c
report_timing -input -path full_clock_expanded -slack_lesser_than 0  -net -nosplit >             ${SESSION}.run/sdc_in.timing.rpt

#######################################################################
# PATH GROUP

group_path -name from_in  -from [ filter_collection  [all_registers -clock_pins ] "full_name =~ *ccx*"]
group_path -name to_out   -to   [ filter_collection  [all_registers -data_pins ] "full_name =~ *ccx*/D"]

report_path_group >      ${SESSION}.run/path_group.rpt
#report_timing -input -path full_clock_expanded -slack_lesser_than 0  -net -nosplit >             ${SESSION}.run/sdc_in.timing.rpt

#report_qor                      > ${SESSION}.run/pre_place.qor.rpt
## without IO path
if { $IO_TIMING == "FALSE" } {
	set all_clock_inputs ""
	  foreach_in_collection clock [ all_clocks ] {
	    foreach_in_collection source [ get_attribute $clock sources ] {
	      set all_clock_inputs [ add_to_collection $all_clock_inputs $source ]
	    }
	  }
	set all_data_inputs [ remove_from_collection [ all_inputs ] $all_clock_inputs ]
	set all_data_outputs [ remove_from_collection [ all_outputs ] $all_clock_inputs ]
	set_false_path -from $all_data_inputs
	set_false_path -to $all_data_outputs
	set ports [get_ports * -filter "direction == inout" -quiet ]
	if { [ sizeof_collection $ports ] != 0 } {
	  foreach_in_collection port $ports {
	    set_false_path -from $port
	    set_false_path -to $port
	  }
	}
}

