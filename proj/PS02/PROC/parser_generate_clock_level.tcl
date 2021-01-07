





report_clocks -nosplit > report_clocks.rpt

exec perl -p -i -e 's/\s+normal$//g' report_clocks.rpt

set root_clocks [ remove_from_collection [ get_clock * ] [ get_generated_clocks * ] ]
set all_gen_clocks [ get_generated_clocks * ]

array unset level
array unset relation
set of [ open report_clocks.rpt r ]
while { [ gets $of line ] >= 0 } {
  #ARMCLK        UUruby_dft/ruby_core/sys/sys_ctrl/ARMCLKPLL/CLK_OUT {UUruby_dft/ruby_core/sys/sys_ctrl/armclk_gate/lib_icgcell/Q} ARMPLL_OUT divide_by(1)
  if { [ regexp {_by\(\S+\)} $line ] == 0 } {
    #puts $line
    continue
  }
  if { [ regexp {^(\S+)\s+\S+\s+\S+\s+(\S+)\s+\S+$} $line "" clock master ] == 1 } {
    if { [ sizeof_collection [ get_generated_clocks $master -quiet ] ] == 0 } {
      set level($clock) 1
      set all_gen_clocks [ remove_from_collection $all_gen_clocks [ get_generated_clocks $clock ] ]
    } else {
      set relation($clock) $master
    }
  }
}
close $of

set cnt 0
set done {}
while { [ sizeof_collection $all_gen_clocks ] != 0 } {
  incr cnt
  foreach_in_collection clock $all_gen_clocks {
    set clock_name [ get_attr $clock full_name ]
    set master $relation($clock_name)
    if { [ info exist level($master) ] == 0 } { continue }
    if { $level($master) == $cnt } {
      set current_level [ expr $cnt + 1 ]
      set level($clock_name) $current_level
      set done [ add_to_collection $done $clock ]
      puts "INFO: $clock_name $current_level"
    }
    set max_level [ expr $cnt + 1 ]
  }
  set all_gen_clocks [ remove_from_collection $all_gen_clocks $done ]
}

if { [ sizeof_collection $all_gen_clocks ] != 0 } {
  puts "Error: [ get_object_name $all_gen_clocks ]"
} else {
  puts "INFO: Successfully clock parser level"
}

proc get_level_clocks { level_num } {
  global level
  set clock_names ""
  foreach clock_name [ array name level ] {
    if { $level($clock_name) == $level_num } {
      set clock_names [ concat $clock_names $clock_name ]
    }
  }
  return $clock_names
}

set clocks [ get_level_clocks 4 ]
compile_clock_tree -sync_phase both -clock_tree [ get_clocks $clocks ]
optimize_clock_tree -clock_tree [ get_clocks $clocks ]
optimize_clock_tree -clock_tree [ get_clocks $clocks ]
source ./tcl/annotate_generated_clock_delay.tcl

source ${TCL_SRC}/create_scenarios.tcl
current_scenario normal


set clocks [ get_level_clocks 3 ]
compile_clock_tree -sync_phase both -clock_tree [ get_clocks $clocks ]
optimize_clock_tree -clock_tree [ get_clocks $clocks ]
optimize_clock_tree -clock_tree [ get_clocks $clocks ]
source ./tcl/annotate_generated_clock_delay.tcl

source ${TCL_SRC}/create_scenarios.tcl
current_scenario normal


set clocks [ get_level_clocks 2 ]
compile_clock_tree -sync_phase both -clock_tree [ get_clocks $clocks ]
optimize_clock_tree -clock_tree [ get_clocks $clocks ]
optimize_clock_tree -clock_tree [ get_clocks $clocks ]
source ./tcl/annotate_generated_clock_delay.tcl

source ${TCL_SRC}/create_scenarios.tcl
current_scenario normal


set clocks [ get_level_clocks 1 ]
compile_clock_tree -sync_phase both -clock_tree [ get_clocks $clocks ]
optimize_clock_tree -clock_tree [ get_clocks $clocks ]
optimize_clock_tree -clock_tree [ get_clocks $clocks ]
source ./tcl/annotate_generated_clock_delay.tcl

source ${TCL_SRC}/create_scenarios.tcl
current_scenario normal

