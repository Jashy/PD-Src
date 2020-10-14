###########################################
## Report annotated data for icexplorer
###########################################
set ::_inter_tcl [info script ]
if { [regexp {^\/} $::_inter_tcl] != 1 } {
  set cur_dir [pwd]
  set ::_inter_tcl ${cur_dir}/$::_inter_tcl
}


###############################################
# parameters
###############################################
set ::dumpVoltageData false
set ::ReportConstraintMaxCapacitance true
set ::skipCaseValuePins false
set ::deltaDelayThreshold 0.002
set ::removeFakeClockPins true
set ::skipNoise true
set ::iceCutnum 100000
set ::ignorePorts ""
set ::pathGroups ""
set ::skipILM false
###############################################
# Internal parameters
###############################################

set ::_logFile "dump_data.log"
set ::_internalPathPins ""
set ::_internalPathNets ""

##- check if command exists.
proc check_command { cmd } {
  set status [catch {$cmd -help > /dev/null}]
  return $status
}

##- check if gzip exists or not
proc no_gzip {} {
    set nogzip [catch {exec gzip -L}]
    return $nogzip
}

proc _log_begin_time {begin_time} {
  upvar 1 $begin_time int_btime
  set int_btime [clock milliseconds]
}

proc _get_elapsed_time {begin_time {update_begin_time true} } {
  upvar 1 $begin_time int_btime
  set int_etime [clock milliseconds]
  set result [expr {0.001 * ($int_etime - $int_btime)}]
  if {$update_begin_time} {
    set int_btime [clock milliseconds]
  }
  return $result
}


proc report_scenario_data_for_icexplorer { args } {
  parse_proc_arguments -args $args results
  if { [info exists results(-only_hier_path)] && [info exists results(-skip_modules)] } {
    puts stderr "Error: -only_hier_path and -skip_modules are mutually exclusive"
    return -1
  }
  set scenario_name $results(-scenario_name)
  if { ! [info exists results(-dir)] } {
    set dir .
  } else {
    set dir $results(-dir)
  }
  if { [info exists results(-dumpVoltageData)] } {
    set ::dumpVoltageData true
  } else {
    set ::dumpVoltageData false
  }
  if { [info exists results(-skip_modules)] } {
    set ::_internalPathPins ""
    set ::_internalPathNets ""
    foreach module $results(-skip_modules) {
      get_internal_objects $module true ::_internalPathPins ::_internalPathNets
    }
    puts "[sizeof_collection $::_internalPathPins] internal pins were skipped"
    puts "[sizeof_collection $::_internalPathNets] internal nets were skipped"
  }
  if { ! [info exists results(-only_hier_path)] } {
    set results(-only_hier_path) "."
  }
  set only_hier_path $results(-only_hier_path)
  regsub {\/$} $only_hier_path {} only_hier_path
  if { [ info exists results(-parallel) ] } {
    report_annotated_data_for_icexplorer_in_parallel $scenario_name $dir $only_hier_path
  } else {
    report_annotated_data_for_icexplorer $scenario_name $dir $only_hier_path
  }
}

proc report_pba_data_for_icexplorer { args } {
  parse_proc_arguments -args $args results
  if {! [ info exists results(-dir)] } {
    set results(-dir) "."
  }
  if {! [info exists results(-delay_type)]} {
    set results(-delay_type) "min_max"
  }
  if {! [info exists results(-max_paths)]} {
    set results(-max_paths) 100000
  }
  if {! [info exists results(-nworst)]} {
    set results(-nworst) 100
  }
  if {! [info exists results(-setup_threshold)]} {
    set results(-setup_threshold) 0.0
  }
  if {! [info exists results(-hold_threshold)]} {
    set results(-hold_threshold) 0.0
  }
  if {! [info exists results(-pba_mode)]} {
    set results(-pba_mode) "path"
  }
  if {! [info exists results(-path_type)]} {
    set results(-path_type) "full_clock"
  }
  if {! [info exists results(-group)]} {
    set results(-group) ""
  }
  report_pba_paths_for_icexplorer $results(-scenario_name) $results(-dir) $results(-delay_type) $results(-max_paths) $results(-nworst) \
                                  $results(-setup_threshold) $results(-hold_threshold) $results(-pba_mode) $results(-group) $results(-path_type) 
}

define_proc_attributes report_pba_data_for_icexplorer -info "Write PBA data file from PrimeTime for ICE2" \
   -define_args { \
     {-scenario_name "Specify scenario name" scenario string required} 
     {-dir "Directory under which PBA file will be created" dir string optional} 
     {-delay_type "Type of path delay, by default is min_max" type one_of_string {optional value_help {values {min max min_max}}} }
     {-max_paths "Maximum path number of per group, by default is 100000" max_paths int optional }
     {-nworst "Top N worst paths to one endpoint, by default is 100" nworst int optional}
     {-setup_threshold "Output paths with setup slack lesser than this value,by default is 0.0" setup_threshold float optional }
     {-hold_threshold "Output paths with hold slack lesser than this value, by default is 0.0" hold_threshold float optional}
     {-pba_mode "Path-based analysis mode,by default is path" effort one_of_string {optional value_help {values {path exhaustive none}} }}
     {-path_type "Specify the format ot timing report, by default is full_clock." path_type one_of_string \
                 {optional value_help {values {full_clock full_clock_expanded full}}} }
     {-group "Limit report to paths in these groups" group_name string optional}
   }
define_proc_attributes report_scenario_data_for_icexplorer -info "Write timing data files from PrimeTime for ICE2 " \
   -define_args { \
   {-scenario_name "Specify scenario name" scenario string required} 
   {-dir "Directory under which the timing data files will be generated" dir string optional} 
   {-only_hier_path "Only timing data under specific hierarchical path will be generated" hier_path string optional} 
   {-skip_modules "Internal timing data under specific modules will be skipped"  module_list list optional} 
   {-parallel "Generate all timing data files in parallel" "" boolean optional}
   {-dumpVoltageData  "Generate voltage rail file" "" boolean optional}
   }



######################################################################
# Procedure utilities
######################################################################
##-- report PBA paths for icexplorer
proc report_pba_paths_for_icexplorer {sce_name dir_name delay_type max_paths nworst setup_threshold hold_threshold pba_mode group_name {path_type full_clock} } {
  if {$delay_type != "min" && $delay_type != "max" && $delay_type != "min_max"} {
    puts stderr "delay_type only can be min, max or min_max"   
    return
  }
  if {$pba_mode != "path" && $pba_mode != "exhaustive" && $pba_mode != "none"} {
    puts stderr "pba_mode only can be path, exhaustive or none"   
    return
  }

  if {$dir_name == ""} {
    set dir_name "."
   } else {
    catch {exec mkdir -p $dir_name}
   }

  set file_name ${dir_name}/$sce_name\_data_timing_rpt.txt.gz
  #set timing_remove_clock_reconvergence_pessimism true
  #set pba_aocvm_only_mode false
  #set timing_aocvm_enable_analysis true
  set options "get_timing_paths -pba_mode $pba_mode -max_paths $max_paths -nworst $nworst -path_type full_clock_expanded "
  if { $group_name != ""} {
    set options "$options -group \"$group_name\" "
  }

  # test timing_report_include_eco_attributes and turn off it before report_timing
  set _turn_on_rpt_eco 0
  redirect -variable _app_var {report_app_var}
  if {[string match "*timing_report_include_eco_attributes*" $_app_var] == 1 } {
    if {[get_app_var timing_report_include_eco_attributes]} {
      set _turn_on_rpt_eco 1
      set_app_var timing_report_include_eco_attributes false
    }
  }
  unset _app_var

  _log_begin_time begin_time
  redirect -compress $file_name {
    puts [_generate_header "timing_report"]
    if {$delay_type == "min"} {
      set path_collection [eval "$options -slack_lesser_than $hold_threshold -delay_type min"]
      if {[sizeof_collection $path_collection] != 0} {
        report_timing $path_collection  -sig 4 -input_pins -cap -trans -derate -nosplit -path_type $path_type -crosstalk_delta
      }
      unset path_collection
    } elseif {$delay_type == "max"} {
      set path_collection [eval "$options -slack_lesser_than $setup_threshold -delay_type max"]
      if {[sizeof_collection $path_collection] != 0} {
        report_timing  $path_collection -sig 4 -input_pins -cap -trans -derate -nosplit -path_type $path_type -crosstalk_delta
      }
      unset path_collection
    } else {          
      set hold_path_collection [eval "$options -delay_type min -slack_lesser_than $hold_threshold "]
      if {[sizeof_collection $hold_path_collection] != 0} {
        report_timing  $hold_path_collection  -sig 4 -input_pins -cap -trans -derate -nosplit -path_type $path_type -crosstalk_delta
      }
      unset hold_path_collection
      set setup_path_collection [eval "$options -delay_type max -slack_lesser_than $setup_threshold"] 
      if {[sizeof_collection $setup_path_collection] != 0} {
        report_timing  $setup_path_collection -sig 4 -input_pins -cap -trans -derate -nosplit -path_type $path_type -crosstalk_delta
      }
      unset setup_path_collection
    }
  }
  set wall_time [_get_elapsed_time begin_time]
  # turn on timing_report_include_eco_attributes if it's ture before report_timing
  if {$_turn_on_rpt_eco} {
    set_app_var timing_report_include_eco_attributes true
  }
  unset _turn_on_rpt_eco

  set ::_logFile "dump_${sce_name}_data.log"
  redirect -append $::_logFile {
    echo "Dump path time for $sce_name use time " $wall_time
  }
}


##-- Report design info to log
proc _output_design_info_to_log {log_file} {
   redirect $log_file {
      puts "##############################################################"
      puts "#Script Invoked: $::_inter_tcl"
      puts "#Design Name   : [get_attribute [current_design] full_name]"
      puts "#Cells  Number : [sizeof_collection [get_cells -hier * -filter "is_hierarchical == false"] ]"
      puts "#Nets   Number : [sizeof_collection [get_nets -hier * -top -filter "defined(total_capacitance_max)"] ]"
      puts "#Pins   Number : [sizeof_collection [get_pins -hier * -filter "is_hierarchical == false"] ]"
      puts "##############################################################"
   }
}
##-- Get internal pins and nets under sub module
proc get_internal_objects {sub_module_name exclude_clock internal_pins internal_nets} {
   upvar 1 $internal_pins int_pins
   upvar 1 $internal_nets int_nets

   set cells [get_cells -hier * -filter "is_hierarchical == true && (ref_name == $sub_module_name || full_name == $sub_module_name)"]
   if {[sizeof_collection $cells] == 0} {
      return
   }

   foreach_in_collection itr $cells {
      current_instance [get_object_name $itr]
      set all_pins [get_pins -hier *]
      set all_nets [get_nets -hier * -top]
      current_instance
      if {[sizeof_collection $all_pins] == 0} {
         continue
      }

      set in_ports [get_pins -quiet -of_objects $itr -filter "direction == in  || direction == inout"]
      if {$exclude_clock} {
         set in_ports [get_pins -quiet -of_objects $itr -filter "(direction == in  || direction == inout) && is_clock_pin == false"]
      }
      set fanout_pins ""
      if {[sizeof_collection $in_ports] > 0} {
         set fanout_pins [all_fanout -from $in_ports  -flat -trace_arcs all]
         set tmp_pins [all_fanin -pin_levels 3 -flat -to $fanout_pins -trace_arcs all]
         append_to_collection -unique fanout_pins $tmp_pins
      }

      set out_ports [get_pins -quiet -of_objects $itr -filter "direction == out || direction == inout"]
      if {$exclude_clock} {
         set out_ports [get_pins -quiet -of_objects $itr -filter "(direction == out  || direction == inout) && is_clock_pin == false"]
      }
      set fanin_pins ""
      if {[sizeof_collection $out_ports] > 0} {
         set fanin_pins  [all_fanin  -to $out_ports -flat -trace_arcs all]
         set tmp_pins [all_fanout -pin_levels 2 -flat -from $fanin_pins -trace_arcs all]
         append_to_collection -unique fanin_pins $tmp_pins
      }

      set io_pins $fanin_pins
      append_to_collection -unique io_pins $fanout_pins

      set tmp_pins [remove_from_collection $all_pins $io_pins]
      append_to_collection -unique int_pins $tmp_pins

      set io_nets [get_nets -top -quiet -of_objects $io_pins]
      set tmp_nets [remove_from_collection $all_nets $io_nets]
      append_to_collection -unique int_nets $tmp_nets
   }
}

##-- filter out internal pins
proc _eraseInternalPins {pins} {
  upvar 1 $pins org_pins
  if {[sizeof_collection $org_pins] == 0} {
    return
  }
  if {[sizeof_collection $::_internalPathPins] > 0} {
    set org_pins [remove_from_collection $org_pins $::_internalPathPins]
  }
}

##-- filter out internal nets
proc _eraseInternalNets {nets} {
  upvar 1 $nets org_nets
  if {[sizeof_collection $org_nets] == 0} {
    return
  }
  if {[sizeof_collection $::_internalPathNets] > 0} {
    set org_nets [remove_from_collection $org_nets $::_internalPathNets]
  }
}

##-- Get file handler
proc _get_fp {file_name} {
   set fid ""
   if {[no_gzip] == 0} {
      if { [catch {open "| gzip -1 > $file_name.gz" w} fid] } {
         puts stderr "Failed to open file: $file_name.gz"
         error "Failed to open file: $file_name.gz"
      }
   } else {
      if { [catch {open $file_name w} fid] } {
         puts stderr "Failed to open file: $file_name"
         error "Failed to open file: $file_name"
      }
   }
   return $fid
}

##-- Output header information.
proc _generate_header {type} {
   set header "****************************************\n"
   append header "Design   : [get_attribute [current_design] full_name]\n"
   append header "Report   : $type \n"
   append header "Vendor   : PT\n"
   append header "Version  : 3.0\n"
   append header "TimeUnit : [get_pt_unit time]\n"
   append header "CapUnit  : [get_pt_unit cap]\n"
   append header "ResUnit  : [get_pt_unit res]\n"
   append header "Current_instance : [current_instance .]\n"
   append header "****************************************\n"
   return $header
}

##-- Generate the finish file after get all data from PT
proc _generate_finish_file {file_name} {
   if {[sizeof_collection [current_design] ] == 0} {
      return
   }

   set fid ""
   if { [catch {open $file_name w} fid] } {
      puts stderr "Failed to open file: $file_name"
      error "Failed to open file: $file_name"
   }
   puts $fid "Vendor   : PT"
   puts $fid "Version  : 3.0"
   close $fid
}


##-- Get maximum val of two variables.
proc max_value {var1 var2} {
   if {$var1 > $var2} {
      return $var1
   } else {
      return $var2
   }
}

##-- Get minimum val of two variables.
proc min_value {var1 var2} {
   if {$var1 < $var2 && $var1 != ""} {
      return $var1
   } else {
      return $var2
   }
}

##-- Exclude delta slew when report_constraint -max_transition etc.
proc _is_exclude_delta_slew {  } {
   if {[catch {set a $::si_xtalk_max_transition_mode}] == 0} {
      if {$::si_xtalk_max_transition_mode == "reliability"} {
         return false
      } else {
         return true
      }
   }
   if {[catch {set a $::timing_si_exclude_delta_slew_for_transition_constraint}] == 0} {
      return $::timing_si_exclude_delta_slew_for_transition_constraint
   }
   return true
}

##-- get pin timing data
proc report_pin_timing_for_icexplorer {file_name} {
   set fid [_get_fp $file_name]
   redirect -append $::_logFile { echo "Before report_pin_timing mem is [mem] , cputime is [cputime %g]" }
   ## Output header.
   puts -nonewline $fid [_generate_header "fast_report_pin_timing"]
   puts $fid "#si_enable_analysis $::si_enable_analysis"
   puts $fid "#timing_si_exclude_delta_slew_for_transition_constraint [_is_exclude_delta_slew]"
   puts $fid ""

   ## for designs
   puts $fid "\n#Design  design_name  max_transition  max_capacitance"
   set designs [get_designs *]
   foreach_in_collection dd $designs {
      puts -nonewline $fid [format "%s" [get_attribute $dd full_name] ]
      set maxtrans [get_attribute -quiet $dd max_transition]
      if {$maxtrans == ""} {
         puts -nonewline $fid "\t*" 
      } else {
         puts -nonewline $fid [format "\t%.4f" $maxtrans]
      }
      set maxcaps [get_attribute -quiet $dd max_capacitance]
      if {$maxcaps == ""} {
         puts $fid "\t*" 
      } else {
         puts $fid [format "\t%.4f" $maxcaps]
      }
   }
   unset designs

   ## Output max transition of pin.
   redirect -append $::_logFile { echo "Before report max_trans mem is [mem] , cputime is [cputime %g]" }
   set pins [get_pins -hier * -filter "is_hierarchical == false && defined(max_transition)"]
   _eraseInternalPins pins
   puts $fid "\n#MaxTransition pins max_transition [sizeof_collection $pins]"
   set datas [get_attribute -value_list $pins full_name]
   puts $fid "#pins_name [llength $datas]"
   set number [llength $datas]
   set iternum [expr $number/$::iceCutnum]
   for {set x 0} {$x <= $iternum} {incr x} {
      set tmp [lrange $datas [expr $x * $::iceCutnum] [expr (($x+1) * $::iceCutnum) - 1]]
      set tmp [string map {" " "\n" "{" "" "}" ""} $tmp]
      puts $fid $tmp
   }
   unset datas
   redirect -append $::_logFile { echo "After  report max_trans name mem is [mem] , cputime is [cputime %g]" }

   set datas [get_attribute -quiet -value_list $pins constraining_max_transition]
   if {[llength $datas] == [sizeof_collection $pins] } {
      puts $fid "#max_transition [llength $datas]"
      set number [llength $datas]
      set iternum [expr $number/$::iceCutnum]
      for {set x 0} {$x <= $iternum} {incr x} {
         set tmp [lrange $datas [expr $x * $::iceCutnum] [expr (($x+1) * $::iceCutnum) - 1]]
         set tmp [string map {" " "\n"} $tmp]
         puts $fid $tmp
      }
   } else {
      set datas [get_attribute -value_list $pins max_transition]
      puts $fid "#max_transition [llength $datas]"
      set number [llength $datas]
      set iternum [expr $number/$::iceCutnum]
      for {set x 0} {$x <= $iternum} {incr x} {
         set tmp [lrange $datas [expr $x * $::iceCutnum] [expr (($x+1) * $::iceCutnum) - 1]]
         set tmp [string map {" " "\n"} $tmp]
         puts $fid $tmp
      }
   }
   unset datas
   redirect -append $::_logFile { echo "After  report max_trans data mem is [mem] , cputime is [cputime %g]" }

   ## Output port timing.
   report_ports_timing_for_icexplorer $fid
   redirect -append $::_logFile { echo "After  report ports data mem is [mem] , cputime is [cputime %g]" }

   ## Output transition.
   set pins ""
   if {$::skipCaseValuePins} {
      set pins [get_pins -quiet -hier * -filter "is_hierarchical == false && \
                                         defined(actual_rise_transition_max) && \
                                         defined(actual_fall_transition_max) && \
                                         defined(actual_rise_transition_min) && \
                                         defined(actual_fall_transition_min) && \
                                         (undefined(case_value) || \
                                         (defined(case_value) && case_value != 0 && case_value != 1))"]
   } else {
      set pins [get_pins -quiet -hier * -filter "is_hierarchical == false && \
                                         defined(actual_rise_transition_max) && \
                                         defined(actual_fall_transition_max) && \
                                         defined(actual_rise_transition_min) && \
                                         defined(actual_fall_transition_min)"]
   }
   _eraseInternalPins pins

   redirect -append $::_logFile { echo "Before report slack_trans data mem is [mem] , cputime is [cputime %g]" }
   puts $fid "\n#PinTransition [sizeof_collection $pins]"
   set datas [get_attribute -quiet -value_list $pins full_name]
   puts $fid "#pins_name [llength $datas]"
   set number [llength $datas]
   set iternum [expr $number/$::iceCutnum]
   for {set x 0} {$x <= $iternum} {incr x} {
      set tmp [lrange $datas [expr $x * $::iceCutnum] [expr (($x+1) * $::iceCutnum) - 1]]
      set tmp [string map {" " "\n" "{" "" "}" ""} $tmp]
      puts $fid $tmp
   }
   unset datas
   redirect -append $::_logFile { echo "After  report slack_trans name mem is [mem] , cputime is [cputime %g]" }

   set datas [get_attribute -quiet -value_list $pins actual_rise_transition_max]
   puts $fid "#actual_rise_transition_max [llength $datas]"
   set number [llength $datas]
   set iternum [expr $number/$::iceCutnum]
   for {set x 0} {$x <= $iternum} {incr x} {
      set tmp [lrange $datas [expr $x * $::iceCutnum] [expr (($x+1) * $::iceCutnum) - 1]]
      set tmp [string map {" " "\n"} $tmp]
      puts $fid $tmp
   }
   unset datas
   redirect -append $::_logFile { echo "After  report setup_rise_trans mem is [mem] , cputime is [cputime %g]" }

   set datas [get_attribute -quiet -value_list $pins actual_fall_transition_max]
   puts $fid "#actual_fall_transition_max [llength $datas]"
   set number [llength $datas]
   set iternum [expr $number/$::iceCutnum]
   for {set x 0} {$x <= $iternum} {incr x} {
      set tmp [lrange $datas [expr $x * $::iceCutnum] [expr (($x+1) * $::iceCutnum) - 1]]
      set tmp [string map {" " "\n"} $tmp]
      puts $fid $tmp
   }
   unset datas
   redirect -append $::_logFile { echo "After  report setup_fall_trans mem is [mem] , cputime is [cputime %g]" }

   set datas [get_attribute -quiet -value_list $pins actual_rise_transition_min]
   puts $fid "#actual_rise_transition_min [llength $datas]"
   set number [llength $datas]
   set iternum [expr $number/$::iceCutnum]
   for {set x 0} {$x <= $iternum} {incr x} {
      set tmp [lrange $datas [expr $x * $::iceCutnum] [expr (($x+1) * $::iceCutnum) - 1]]
      set tmp [string map {" " "\n"} $tmp]
      puts $fid $tmp
   }
   unset datas
   redirect -append $::_logFile { echo "After  report hold_rise_trans mem is [mem] , cputime is [cputime %g]" }

   set datas [get_attribute -quiet -value_list $pins actual_fall_transition_min]
   puts $fid "#actual_fall_transition_min [llength $datas]"
   set number [llength $datas]
   set iternum [expr $number/$::iceCutnum]
   for {set x 0} {$x <= $iternum} {incr x} {
      set tmp [lrange $datas [expr $x * $::iceCutnum] [expr (($x+1) * $::iceCutnum) - 1]]
      set tmp [string map {" " "\n"} $tmp]
      puts $fid $tmp
   }
   unset datas
   redirect -append $::_logFile { echo "After  report hold_fall_trans mem is [mem] , cputime is [cputime %g]" }


   ## Output delta transition.
   if {$::si_enable_analysis && [_is_exclude_delta_slew] == false} {
      set pinsleng [sizeof_collection $pins]
      set datas [get_attribute -quiet -value_list $pins annotated_rise_transition_delta_max]
      set dataleng [llength $datas]
      if {[expr abs($pinsleng - $dataleng)] <= 1} {
          puts $fid "#annotated_rise_transition_delta_max [llength $datas]"
          set datas [string map {" " "\n"} $datas]
          puts $fid $datas
          redirect -append $::_logFile { echo "After  report max_rise_delta_trans data mem is [mem] , cputime is [cputime %g]" }
      }
      set datas [get_attribute -quiet -value_list $pins annotated_fall_transition_delta_max]
      set dataleng [llength $datas]
      if {[expr abs($pinsleng - $dataleng)] <= 1} {
         puts $fid "#annotated_fall_transition_delta_max [llength $datas]"
         set datas [string map {" " "\n"} $datas]
         puts $fid $datas
         redirect -append $::_logFile { echo "After  report max_fall_delta_trans data mem is [mem] , cputime is [cputime %g]" }
      }

      set datas [get_attribute -quiet -value_list $pins annotated_rise_transition_delta_min]
      set dataleng [llength $datas]
      if {[expr abs($pinsleng - $dataleng)] <= 1} {
         puts $fid "#annotated_rise_transition_delta_min [llength $datas]"
         set datas [string map {" " "\n"} $datas]
         puts $fid $datas
         redirect -append $::_logFile { echo "After  report min_rise_delta_trans data mem is [mem] , cputime is [cputime %g]" }
      }
      set datas [get_attribute -quiet -value_list $pins annotated_fall_transition_delta_min]
      set dataleng [llength $datas]
      if {[expr abs($pinsleng - $dataleng)] <= 1} {
         puts $fid "#annotated_fall_transition_delta_min [llength $datas]"
         set datas [string map {" " "\n"} $datas]
         puts $fid $datas
         redirect -append $::_logFile { echo "After  report min_fall_delta_trans data mem is [mem] , cputime is [cputime %g]" }
      }
   }

   ## Output max_capacitance
   set pins [get_pins -quiet -hier * -filter "is_hierarchical == false && defined(max_capacitance)"]
   _eraseInternalPins pins
   puts $fid "\n#MaxCapacitance pins max_capacitance [sizeof_collection $pins]"
   set datas [get_attribute -quiet -value_list $pins full_name]
   puts $fid "#pins_name [llength $datas]"
   set number [llength $datas]
   set iternum [expr $number/$::iceCutnum]
   for {set x 0} {$x <= $iternum} {incr x} {
      set tmp [lrange $datas [expr $x * $::iceCutnum] [expr (($x+1) * $::iceCutnum) - 1]]
      set tmp [string map {" " "\n" "{" "" "}" ""} $tmp]
      puts $fid $tmp
   }
   unset datas
   redirect -append $::_logFile { echo "After  report max_cap name mem is [mem] , cputime is [cputime %g]" }

   set datas [get_attribute -quiet -value_list $pins max_capacitance]
   puts $fid "#max_capacitance [llength $datas]"
   set datas [string map {" " "\n"} $datas]
   puts $fid $datas
   redirect -append $::_logFile { echo "After  report max_cap data mem is [mem] , cputime is [cputime %g]" }
   unset pins
   unset datas

   if {$::ReportConstraintMaxCapacitance} {
     puts $fid "\n"
     puts $fid "#constraint_max_capacitance"
     redirect -variable constraint_max_cap_data {report_constraint -max_capacitance -all_violators -sig 5 -nosplit}
     puts $fid $constraint_max_cap_data
     redirect -append $::_logFile { echo "After  report constraint -max_capa mem is [mem] , cputime is [cputime %g]" }
   }

   close $fid
}

##-- Report global slack
proc report_global_slack_for_icexplorer {file_name} {
   set fid [_get_fp $file_name]

   puts $fid [_generate_header "report_global_slack"]
   redirect -channel $fid {report_global_slack -sig 4 -nosplit}
 
   close $fid
}

proc report_total_capacitances_for_icexplorer {file_name} {
   set fid [_get_fp $file_name]
   redirect -append $::_logFile { echo "Before report net_cap data mem is [mem] , cputime is [cputime %g]" }

   ## Output header.
   puts $fid [_generate_header "fast_report_total_capacitance"]

   ## for ports
   puts $fid "\n#Port port_name pin_capacitance_max pin_capacitance_min"
   set ports [get_ports * -filter "defined(pin_capacitance_max) || defined(pin_capacitance_min)"]
   foreach_in_collection pp $ports {
      set cap_max [get_attribute -quiet $pp pin_capacitance_max]
      set cap_min [get_attribute -quiet $pp pin_capacitance_min]
      if {$cap_max == ""} { set cap_max $cap_min }
      if {$cap_min == ""} { set cap_min $cap_max }
      puts $fid [format "%s\t%.6f\t%.6f" \
                       [get_attribute $pp full_name] \
                       $cap_max \
                       $cap_min ]
   }
   unset ports

   ## for nets rc_annotated_segment == true 
   set nets [get_nets -quiet -hier * -top -filter " \
                                  defined(total_capacitance_max) && defined(total_capacitance_min) && \
                                  defined(wire_capacitance_max) && defined(wire_capacitance_min) && \
                                  defined(net_resistance_max) && defined(net_resistance_min)"]
   _eraseInternalNets nets

   set datas [get_attribute -value_list $nets full_name]
   puts $fid "\n#nets_name [llength $datas]"
   set number [llength $datas]
   set iternum [expr $number/$::iceCutnum]
   for {set x 0} {$x <= $iternum} {incr x} {
      set tmp [lrange $datas [expr $x * $::iceCutnum] [expr (($x+1) * $::iceCutnum) - 1]]
      set tmp [string map {" " "\n" "{" "" "}" ""} $tmp]
      puts $fid $tmp
   }
   unset datas
   redirect -append $::_logFile { echo "After  report net_cap name mem is [mem] , cputime is [cputime %g]" }

   set datas [get_attribute -value_list $nets total_capacitance_max]
   puts $fid "#total_capacitance_max [llength $datas]"
   set datas [string map {" " "\n"} $datas]
   puts $fid $datas
   unset datas
   redirect -append $::_logFile { echo "After  report total_cap_max mem is [mem] , cputime is [cputime %g]" }

   set datas [get_attribute -quiet -value_list $nets total_ccs_capacitance_max_rise]
   if {[llength $datas] == [sizeof_collection $nets]} {
      puts $fid "#total_ccs_capacitance_max_rise [llength $datas]"
      set datas [string map {" " "\n"} $datas]
      puts $fid $datas
      unset datas
      redirect -append $::_logFile { echo "After  report total_ccs_capacitance_max_rise mem is [mem] , cputime is [cputime %g]" }
   }
   set datas [get_attribute -quiet -value_list $nets total_ccs_capacitance_max_fall]
   if {[llength $datas] == [sizeof_collection $nets]} {
      puts $fid "#total_ccs_capacitance_max_fall [llength $datas]"
      set datas [string map {" " "\n"} $datas]
      puts $fid $datas
      unset datas
      redirect -append $::_logFile { echo "After  report total_ccs_capacitance_max_fall mem is [mem] , cputime is [cputime %g]" }
   }

   set datas [get_attribute -value_list $nets total_capacitance_min]
   puts $fid "#total_capacitance_min [llength $datas]"
   set datas [string map {" " "\n"} $datas]
   puts $fid $datas
   unset datas
   redirect -append $::_logFile { echo "After  report total_cap_min mem is [mem] , cputime is [cputime %g]" }

   set datas [get_attribute -value_list $nets wire_capacitance_max]
   puts $fid "#wire_capacitance_max [llength $datas]"
   set datas [string map {" " "\n"} $datas]
   puts $fid $datas
   unset datas
   redirect -append $::_logFile { echo "After  report wire_cap_max mem is [mem] , cputime is [cputime %g]" }

   set datas [get_attribute -value_list $nets wire_capacitance_min]
   puts $fid "#wire_capacitance_min [llength $datas]"
   set datas [string map {" " "\n"} $datas]
   puts $fid $datas
   unset datas
   redirect -append $::_logFile { echo "After  report wire_cap_min mem is [mem] , cputime is [cputime %g]" }

   set datas [get_attribute -value_list $nets net_resistance_max]
   puts $fid "#net_resistance_max [llength $datas]"
   set datas [string map {" " "\n"} $datas]
   puts $fid $datas
   unset datas
   redirect -append $::_logFile { echo "After  report net_res_max mem is [mem] , cputime is [cputime %g]" }

   set datas [get_attribute -value_list $nets net_resistance_min]
   puts $fid "#net_resistance_min [llength $datas]"
   set datas [string map {" " "\n"} $datas]
   puts $fid $datas
   unset datas
   redirect -append $::_logFile { echo "After  report net_res_min mem is [mem] , cputime is [cputime %g]" }

   set datas [get_attribute -value_list $nets total_coupling_capacitance]
   puts $fid "#total_coupling_capacitance [llength $datas]"
   if {[string first "{}" $datas] >= 0} {
      set datas [string map {" " "\n" "{}" "0.0"} $datas]
   } else {
      set datas [string map {" " "\n"} $datas]
   }
   puts $fid $datas
   unset datas
   redirect -append $::_logFile { echo "After  report total_coupling_cap mem is [mem] , cputime is [cputime %g]" }
    
   unset nets

   close $fid
}

##-- report timing derate
proc report_timing_derate_for_icexplorer {file_name} {
   set fid [_get_fp $file_name]

   puts $fid [_generate_header "report_timing_derate"]
   redirect -channel $fid {report_timing_derate -nosplit -significant_digits 4}

   if {$::timing_aocvm_enable_analysis} {
     puts $fid "\n"
     puts $fid "#aocvm_guardband"
     redirect -channel $fid {report_timing_derate -aocvm_guardband -nosplit -significant_digits 4}
   }
   if {$::timing_pocvm_enable_analysis} {
     puts $fid "\n"
     puts $fid "#pocvm_guardband"
     redirect -channel $fid {report_timing_derate -pocvm_guardband -nosplit -significant_digits 4}
   }

   puts $fid "\n"
   puts $fid "#increment_derate"
   redirect -channel $fid {report_timing_derate -increment -nosplit -significant_digits 4}

   close $fid
}

##-- report dont touch objects
proc report_dont_touch_objects_for_icexplorer {file_name} {
   set fid [_get_fp $file_name]
   ## Ouput header.
   puts $fid [_generate_header "report_dont_touch_objects"]

   ## Type : Net or Cell
   puts $fid "Name    Type"
   puts $fid "--------------------------------------------------------------------------------"

   set cells [get_cells -quiet -hier * -filter "dont_touch == true"]
   foreach_in_collection pp $cells {
      puts $fid "[get_attribute $pp full_name] Cell"
   }
   unset cells

   set nets [get_nets -quiet -hier * -filter "dont_touch == true"]
   foreach_in_collection pp $nets {
      puts $fid "[get_attribute $pp full_name] Net"
   }
   unset nets

   close $fid    
}

######################################################
# report clock pins
######################################################
proc report_used_as_clock_pins_for_icexplorer {file_name} {
  set fid [_get_fp $file_name]
  ##Put header in it.
  puts $fid [_generate_header "report_used_as_clock_pins"]
  puts $fid "--------------------------------------------------------------------------------"

  if {[sizeof_collection [get_clocks -quiet *]] == 0} {
    close $fid
    return
  }
### dont use -include_clock_gating_network
### typical clock gating network is from Latch/Q to an input pin of AND(OR) cell, and this pin
### is enable pin. if user sets gating check constraint, then the paths in gating network are the
### real paths and should be fixed, so we can't include clock gating network
#    set pins [get_clock_network_objects -type pin -include_clock_gating_network]
  set pins [get_clock_network_objects -type pin ]
  if {[sizeof_collection $pins] == 0} {
    close $fid
    return
  }
    
  if { $::removeFakeClockPins } { 
    set pins [filter_collection $pins "is_clock_used_as_clock != false or is_clock_used_as_data != true" ]
  }
  _eraseInternalPins pins
  set datas [get_attribute -value_list $pins full_name]
  set total_number [llength $datas]
  set iternum [expr $total_number/$::iceCutnum]
  for {set x 0}  {$x <= $iternum}  {incr x} {
     set tmp [lrange $datas [expr $x * $::iceCutnum] [expr (($x + 1) * $::iceCutnum) - 1]]
     set tmp [string map {" " "\n"} $tmp]
     puts $fid $tmp
  }
  unset datas
  unset pins
    
  set clocks [get_clocks * -quiet -filter "is_generated == true"]
  if {[llength $clocks] > 0} {
    redirect -variable d {report_clock_timing -type latency -clock $clocks -ver -no}
    set data [split $d "\n"]
    set match 0
    foreach line $data {
      if {[llength $line] == 1} {
        if {[string match "*--------*" $line]} {
          set match 1
          continue
        }
      }
      if {[string match "*total clock latency*" $line]} {
        set match 0
        continue
      }
      if {$match == 0 || [llength $line] < 6} {
        continue
      }
      puts $fid [lindex $line 0]
    }
  }
  close $fid
}

##-- Report cell voltage.
proc report_rail_voltage_for_icexplorer {file_name} {
   if {!$::dumpVoltageData} {
      return
   }
   set fid [_get_fp $file_name]
   ## Output header.
   puts $fid [_generate_header "report_rail_voltage"]
   redirect -append $::_logFile { echo "Before report_rail_voltage mem is [mem] , cputime is [cputime %g]" }

   set pins [get_pins -hier * -filter "is_hierarchical == false && defined(power_rail_voltage_max) && \
                                        defined(power_rail_voltage_min)"]
   _eraseInternalPins pins
   if {[sizeof_collection $pins] == 0} {
      return;
   }
    
   set datas [get_attribute -value_list $pins full_name]
   set total_number [llength $datas]
   puts $fid "#name $total_number"

   set iternum [expr $total_number/$::iceCutnum]
   for {set x 0}  {$x <= $iternum}  {incr x} {
      set tmp [lrange $datas [expr $x * $::iceCutnum] [expr (($x + 1) * $::iceCutnum) - 1]]
      set tmp [string map {" " "\n"} $tmp]
      puts $fid $tmp
   }
   redirect -append $::_logFile { echo "After report_rail_voltage names mem is [mem] , cputime is [cputime %g]" }

   set datas [get_attribute -value_list $pins power_rail_voltage_max]
   set total_number [llength $datas]
   puts $fid "#power_rail_voltage_max $total_number"
   set iternum [expr $total_number/$::iceCutnum]
   for {set x 0} {$x <= $iternum} {incr x} {
      set tmp [lrange $datas [expr $x * $::iceCutnum] [expr (($x + 1) * $::iceCutnum) - 1 ]]
      set tmp [string map {" " "\n"} $tmp]
      puts $fid $tmp
   }
   redirect -append $::_logFile { echo "After report power_rail_voltage_max names mem is [mem] , cputime is [cputime %g]" }

   set datas [get_attribute -value_list $pins power_rail_voltage_min]
   set total_number [llength $datas]
   puts $fid "#power_rail_voltage_min $total_number"
   set iternum [expr $total_number/$::iceCutnum]
   for {set x 0} {$x <= $iternum} {incr x} {
      set tmp [lrange $datas [expr $x * $::iceCutnum] [expr (($x + 1) * $::iceCutnum) - 1]]
      set tmp [string map {" " "\n"} $tmp]
      puts $fid $tmp
   }
   redirect -append $::_logFile { echo "After report power_rail_voltage_min names mem is [mem] , cputime is [cputime %g]" }
   unset datas
   unset pins
   close $fid
}

##-- report si delta 
proc report_delta_data_for_icexplorer {file_name threshold} {
   set fid [_get_fp $file_name]
   ## Ouput header.
   puts $fid [_generate_header "fast_report_delta"]

   if {!$::si_enable_analysis} {
      close $fid
      return
   }
   redirect -append $::_logFile { echo "Before report delta data mem is [mem] , cputime is [cputime %g]" }

   set nets [get_nets -hier * -top_net_of_hierarchical_group]
   _eraseInternalNets nets
   set time_unit [get_pt_unit time]
   if { $time_unit == 1e-12 } {
     set threshold [expr $threshold * 1000]
   }
   set arcs [get_timing_arcs -of_objects $nets -filter "\
                       annotated_delay_delta_max_rise >= $threshold || annotated_delay_delta_max_rise <= -$threshold || \
                       annotated_delay_delta_max_fall >= $threshold || annotated_delay_delta_max_fall <= -$threshold || \
                       annotated_delay_delta_min_rise >= $threshold || annotated_delay_delta_min_rise <= -$threshold || \
                       annotated_delay_delta_min_fall >= $threshold || annotated_delay_delta_min_fall <= -$threshold"]
   puts $fid "#Delta_delay [sizeof_collection $arcs]"
   redirect -append $::_logFile { echo "After  get_timing_arcs mem is [mem] , cputime is [cputime %g]" }

   set datas [get_attribute -value_list $arcs annotated_delay_delta_max_rise]
   puts $fid "#annotated_delay_delta_max_rise [llength $datas]"
   set datas [string map {" " "\n"} $datas]
   puts $fid $datas

   set datas [get_attribute -value_list $arcs annotated_delay_delta_max_fall]
   puts $fid "#annotated_delay_delta_max_fall [llength $datas]"
   set datas [string map {" " "\n"} $datas]
   puts $fid $datas

   set datas [get_attribute -value_list $arcs annotated_delay_delta_min_rise]
   puts $fid "#annotated_delay_delta_min_rise [llength $datas]"
   set datas [string map {" " "\n"} $datas]
   puts $fid $datas

   set datas [get_attribute -value_list $arcs annotated_delay_delta_min_fall]
   puts $fid "#annotated_delay_delta_min_fall [llength $datas]"
   set datas [string map {" " "\n"} $datas]
   puts $fid $datas

   puts $fid "#from_pins_name [sizeof_collection $arcs]"
   foreach_in_collection arc $arcs {
      puts $fid [get_attribute [get_attribute $arc from_pin] full_name]
   }

   puts $fid "#to_pins_name [sizeof_collection $arcs]"
   foreach_in_collection arc $arcs {
      puts $fid [get_attribute [get_attribute $arc to_pin] full_name]
   }
   unset datas
   unset arcs

   redirect -append $::_logFile { echo "Before get_pins for delta transition mem is [mem] , cputime is [cputime %g]" }

   puts $fid ""
   set pins [get_pins -quiet -hier * -filter "is_hierarchical == false && (\
                      annotated_rise_transition_delta_max >= $threshold || annotated_rise_transition_delta_max <= -$threshold || \
                      annotated_fall_transition_delta_max >= $threshold || annotated_fall_transition_delta_max <= -$threshold || \
                      annotated_rise_transition_delta_min >= $threshold || annotated_rise_transition_delta_min <= -$threshold || \
                      annotated_fall_transition_delta_min >= $threshold || annotated_fall_transition_delta_min <= -$threshold)"]
   _eraseInternalPins pins
   puts $fid "#Delta_transition [sizeof_collection $pins]"
   redirect -append $::_logFile { echo "After  get_pins for delta transition mem is [mem] , cputime is [cputime %g]" }

   set datas [get_attribute -value_list $pins annotated_rise_transition_delta_max]
   puts $fid "#annotated_transition_delta_rise_max [llength $datas]"
   set datas [string map {" " "\n"} $datas]
   puts $fid $datas

   set datas [get_attribute -value_list $pins annotated_fall_transition_delta_max]
   puts $fid "#annotated_transition_delta_fall_max [llength $datas]"
   set datas [string map {" " "\n"} $datas]
   puts $fid $datas

   set datas [get_attribute -value_list $pins annotated_rise_transition_delta_min]
   puts $fid "#annotated_transition_delta_rise_min [llength $datas]"
   set datas [string map {" " "\n"} $datas]
   puts $fid $datas

   set datas [get_attribute -value_list $pins annotated_fall_transition_delta_min]
   puts $fid "#annotated_transition_delta_fall_min [llength $datas]"
   set datas [string map {" " "\n"} $datas]
   puts $fid $datas

   set datas [get_attribute -value_list $pins full_name]
   puts $fid "#to_pins_name [llength $datas]"
   set number [llength $datas]
   set iternum [expr $number/$::iceCutnum]
   for {set x 0} {$x <= $iternum} {incr x} {
      set tmp [lrange $datas [expr $x * $::iceCutnum] [expr (($x+1) * $::iceCutnum) - 1]]
      set tmp [string map {" " "\n" "{" "" "}" ""} $tmp]
      puts $fid $tmp
   }
   unset datas
   unset pins
   redirect -append $::_logFile { echo "After  report delta datal mem is [mem] , cputime is [cputime %g]" }

   close $fid
}

##-- report si noise for icexplorer
proc report_si_noise_for_icexplorer {file_name} {
   set fid [_get_fp $file_name]
   if {!$::si_enable_analysis} {
      close $fid
      return
   }
   ## Output header.
   puts $fid [_generate_header "si_noise"]
   redirect -channel $fid {report_noise -nosplit -verbose -all_violators -significant_digits 6 }

   close $fid
}

##-- Report io information.
proc report_ilm_objects_for_icexplorer {file_name } {
  set fid [_get_fp $file_name]
  redirect -append $::_logFile { echo "Before report_ilm_objects mem is [mem] , cputime is [cputime %g]" }
  ## Ouput header.
  puts $fid [_generate_header "report_ilm_objects"]
  if { $::skipILM } {
    puts $fid "\n#pins_name 0"
    close $fid
    return
  }
  set cur_inst [current_instance .]
  if { $cur_inst != "" } {
    close $fid
    return;
  }
  if { [llength $::ignorePorts] > 0 } {
    set ports_col [get_ports -quiet $::ignorePorts]
    if { [sizeof_collection $ports_col ] > 0 } {
      if { ![info exists ::hier_enable_analysis] && ![check_command identify_interface_logic] } {
        identify_interface_logic -ignorePorts [get_ports -quiet $::ignorePorts]
      } elseif { $::hier_enable_analysis == false && ![check_command identify_interface_logic]} {
        identify_interface_logic -ignorePorts [get_ports -quiet $::ignorePorts]
      } else {
        ## derive IO pins by fanin and fanout
        write_fanin_fanout_pins $fid $ports_col
        close $fid
        redirect -append $::_logFile { echo "After  report_ilm_objects mem is [mem] , cputime is [cputime %g]" }
        return;
      }
    } else {
      if { ![info exists ::hier_enable_analysis] && ![check_command identify_interface_logic]} {
        identify_interface_logic -auto_ignore
      } elseif { $::hier_enable_analysis == false && ![check_command identify_interface_logic]} {
        identify_interface_logic -auto_ignore
      } else {
        write_fanin_fanout_pins $fid
        close $fid
        redirect -append $::_logFile { echo "After  report_ilm_objects mem is [mem] , cputime is [cputime %g]" }
        return;
      }
    }
  } else {
    if { ![info exists ::hier_enable_analysis] && ![check_command identify_interface_logic] } {
      identify_interface_logic -auto_ignore
    } elseif { $::hier_enable_analysis == false && ![check_command identify_interface_logic]} {
      identify_interface_logic -auto_ignore
    } else {
      write_fanin_fanout_pins $fid
      close $fid
      redirect -append $::_logFile { echo "After  report_ilm_objects mem is [mem] , cputime is [cputime %g]" }
      return;
    }
  }

  ## get pins on io paths
  set ilm_pins [get_pins  -hierarchical * -filter "is_hierarchical == false && is_interface_logic_pin == true" ]

  set all_ports [get_ports *]
  if { [llength $::ignorePorts] > 0 } {
     set all_ports [remove_from_collection $all_ports [get_ports $::ignorePorts] ]
  }
  #append_to_collection -unique ilm_pins [get_ports *]
  set ilm_pins_name [get_attribute -quiet -value_list $ilm_pins full_name]
  set number [expr [llength $ilm_pins_name] + [sizeof_collection $all_ports]]
  puts $fid "\n#pins_name $number"
  set iternum [expr $number/$::iceCutnum]
  for {set x 0} {$x <= $iternum} {incr x} {
    set tmp [lrange $ilm_pins_name [expr $x * $::iceCutnum] [expr (($x+1) * $::iceCutnum) - 1]]
    set tmp [string map {" " "\n" "{" "" "}" ""} $tmp]
    puts $fid $tmp
  }
  foreach_in_collection pin_coll $all_ports {
    set dir [get_attribute [get_ports $pin_coll] direction]
    if { $dir == "input" || $dir == "in"} {
      set conn_net [get_nets -of_objects [get_port $pin_coll]]
      set ilm_flag false
      foreach_in_collection conn_pin [get_pins -leaf -of_objects [get_nets $conn_net]  -quiet \
                                  -filter "direction == in || direction == input || direction == inout" ] {
        set pin_interface [get_attribute [get_pins $conn_pin] is_interface_logic_pin]
	      if { $pin_interface } {
	        set ilm_flag true
            break
        }
      }
      if { $ilm_flag } {
        puts $fid [get_object_name $pin_coll]
      }
    } else {
      set conn_net [get_nets -of_objects [get_port $pin_coll]]
      set ilm_flag false
      foreach_in_collection conn_pin [get_pins -leaf -of_objects [get_nets $conn_net] -quiet \
                                   -filter "direction == out || direction == output || direction == inout" ] {
        set pin_interface [get_attribute [get_pins $conn_pin] is_interface_logic_pin]
	      if { $pin_interface } {
          set ilm_flag true
            break
        }
      }
      if { $ilm_flag } {
        puts $fid [get_object_name $pin_coll]
      }
    }
  }
  unset all_ports
  unset ilm_pins
  unset ilm_pins_name

  redirect -append $::_logFile { echo "After  report_ilm_objects mem is [mem] , cputime is [cputime %g]" }
  close $fid
}

##-- Get pt unit
proc get_pt_unit {type} {
   set timeunit 1e-9 
   set capunit  1e-12 
   set resunit  1000 
   set volunit  1
   redirect -variable units_data {report_units -nosplit }
   set lines [split $units_data "\n"]
   foreach {line} $lines {
      if {[llength $line] != 4} {
         continue
      }
      if {[lindex $line 0] == "Capacitive_load_unit"} {
         set capunit [lindex $line 2]
      }
      if {[lindex $line 0] == "Time_unit"} {
         set timeunit [lindex $line 2]
      }
      if {[lindex $line 0] == "Resistance_unit"} {
         set resunit [lindex $line 2]
      }
      if {[lindex $line 0] == "Voltage_unit"} {
         set volunit [lindex $line 2]
      }
   }

   if {$type == "time"} {
      return $timeunit
   } elseif {$type == "cap"} {
      return $capunit
   } elseif {$type == "vol"} {
      return $volunit
   } else {
      return $resunit
   }
}

##-- Check if need to update timing
proc check_pin_arrival_and_slack_time { log } {
  if {$::timing_save_pin_arrival_and_slack == false} {
    set inittime [cputime %g]
    puts "Now set timing_save_pin_arrival_and_slack true and do update_timing"
    set ::timing_save_pin_arrival_and_slack true
    update_timing
    set endtime [cputime %g]
    puts [format "update_timing use time %.4f" [expr $endtime - $inittime]]
    redirect -append $log {echo [format "update_timing use time %.4f" [expr $endtime - $inittime]] }
  }
}

##-- write timing data files in parallel
proc report_annotated_data_for_icexplorer_in_parallel { scenario_name dir_name {hier_path .} } {
  current_instance
  current_instance $hier_path
  catch { exec rm -rf ${dir_name}/${scenario_name}_data_finish }
  catch {exec mkdir -p $dir_name}
  set ::_logFile "dump_${scenario_name}_data.log"
  _output_design_info_to_log $::_logFile
  check_pin_arrival_and_slack_time  $::_logFile

   _log_begin_time begin_time_total
   set nfile /dev/null
   set prefix_name "${dir_name}/${scenario_name}"

    #IO objects file
    _log_begin_time begin_time_a
    set fname ${prefix_name}_data_ilm_objects.txt
    redirect -file $nfile "report_ilm_objects_for_icexplorer $fname"
    set wall_time [_get_elapsed_time begin_time_a]
    redirect -append $::_logFile {echo [format "dump ilm objects use real time %.3f seconds" $wall_time]}

    parallel_execute -commands_only {
      {
        _log_begin_time begin_time_b
        set fname ${prefix_name}_data_pin_timing.txt
        redirect -file $nfile "report_pin_timing_for_icexplorer $fname"
        if { [file exists $fname] } {
          catch { exec gzip -1 $fname }
        }
        set wall_time [_get_elapsed_time begin_time_b]
        redirect -append $::_logFile {echo [format "dump pin timing use real time %.3f seconds" $wall_time]}
      }
      { 
        _log_begin_time begin_time_b
        set fname ${prefix_name}_data_pin_slack.txt
        redirect -file $nfile "report_global_slack_for_icexplorer $fname"
        if { [file exists $fname] } {
          catch { exec gzip -1 $fname }
        }
        set wall_time [_get_elapsed_time begin_time_b]
        redirect -append $::_logFile {echo [format "dump global slack use real time %.3f seconds" $wall_time]}
      }
      {
        _log_begin_time begin_time_b
        set fname ${prefix_name}_data_total_capacitances.txt
        redirect -file $nfile "report_total_capacitances_for_icexplorer $fname"
        if { [file exists $fname] } {
          catch { exec gzip -1 $fname }
        }
        set wall_time [_get_elapsed_time begin_time_b]
        redirect -append $::_logFile {echo [format "dump total capacitances use real time %.3f seconds" $wall_time]}
      }
      {
        _log_begin_time begin_time_b
        set fname ${prefix_name}_data_timing_derates.txt
        redirect -file $nfile "report_timing_derate_for_icexplorer $fname"
        if { [file exists $fname] } {
          catch { exec gzip -1 $fname }
        }
        set wall_time [_get_elapsed_time begin_time_b]
        redirect -append $::_logFile {echo [format "dump derate use real time %.3f seconds" $wall_time]}
      }
      {
        _log_begin_time begin_time_b
        set fname ${prefix_name}_data_dont_touch_objects.txt
        redirect -file $nfile "report_dont_touch_objects_for_icexplorer $fname"
        if { [file exists $fname] } {
          catch { exec gzip -1 $fname }
        }
        set wall_time [_get_elapsed_time begin_time_b]
        redirect -append $::_logFile {echo [format "dump dont touch objects use real time %.3f seconds" $wall_time]}
      }
      {
        _log_begin_time begin_time_b
        set fname ${prefix_name}_data_used_as_clocks.txt
        redirect -file $nfile "report_used_as_clock_pins_for_icexplorer $fname"
        if { [file exists $fname] } {
          catch { exec gzip -1 $fname }
        }
        set wall_time [_get_elapsed_time begin_time_b]
        redirect -append $::_logFile {echo [format "dump clock pins use real time %.3f seconds" $wall_time]}
      }
      {
        _log_begin_time begin_time_b
        set fname ${prefix_name}_data_rail_voltage.txt
        redirect -file $nfile "report_rail_voltage_for_icexplorer $fname"
        if { [file exists $fname] } {
          catch { exec gzip -1 $fname }
        }
        set wall_time [_get_elapsed_time begin_time_b]
        redirect -append $::_logFile {echo [format "dump rail_voltage use real time %.3f second" $wall_time]}
      }
      {
        _log_begin_time begin_time_b
        set fname ${prefix_name}_data_si_delta.txt
        report_delta_data_for_icexplorer $fname $::deltaDelayThreshold
        if { [file exists $fname] } {
          catch { exec gzip -1 $fname }
        }
        set wall_time [_get_elapsed_time begin_time_b]
        redirect -append $::_logFile {echo [format "dump si delta use real time %.3f seconds" $wall_time]} 
      }
      {
        _log_begin_time begin_time_b
        if { ! $::skipNoise } {
          set fname ${prefix_name}_data_si_noise.txt
          redirect -file $nfile "report_si_noise_for_icexplorer $fname"
          if { [file exists $fname] } {
            catch { exec gzip -1 $fname }
          }
        }
        set wall_time [_get_elapsed_time begin_time_b]
        redirect -append $::_logFile {echo [format "dump si noise use real time %.3f seconds" $wall_time]} 
      }
     }

   set wall_time [_get_elapsed_time begin_time_total]
   redirect -append $::_logFile {echo [format "report annotatd data use real time %.3f seconds" $wall_time ]}
   _generate_finish_file ${dir_name}/${scenario_name}_data_finish
}

##-- write timing data files
proc report_annotated_data_for_icexplorer { scenario_name dir_name { hier_path . } } {
   current_instance
   current_instance $hier_path
   catch { exec rm -rf ${dir_name}/${scenario_name}_data_finish }
   if {$dir_name == ""} {
      set dir_name "."
   } else {
      catch {exec mkdir -p $dir_name}
   }
   set ::_logFile "dump_${scenario_name}_data.log"
   _output_design_info_to_log $::_logFile
   check_pin_arrival_and_slack_time  $::_logFile

   _log_begin_time begin_time
   set nfile /dev/null
   set prefix_name  "${dir_name}/${scenario_name}"
   _report_annotated_timing_data $prefix_name
   set wall_time [_get_elapsed_time begin_time]
   redirect -append $::_logFile {echo [format "report annotatd data use real time %.3f seconds" $wall_time ]}
   _generate_finish_file ${dir_name}/${scenario_name}_data_finish
}

##-- Write all timing data files
proc _report_annotated_timing_data {prefix_name} {
  # set null file 
  set nfile /dev/null
  _log_begin_time begin_time

  # pin timing.
  set fname ${prefix_name}_data_pin_timing.txt
  redirect -file $nfile "report_pin_timing_for_icexplorer $fname"
  if { [file exists $fname] } {
    catch { exec gzip -1 $fname}
  }
  set wall_time [_get_elapsed_time begin_time]
  redirect -append $::_logFile {echo [format "dump pin timing use real time %.3f seconds" $wall_time]}

  # global_slack.
  set fname ${prefix_name}_data_pin_slack.txt
  redirect -file $nfile "report_global_slack_for_icexplorer $fname"
  if { [file exists $fname] } {
    catch { exec gzip -1 $fname}
  }
  set wall_time [_get_elapsed_time begin_time]
  redirect -append $::_logFile {echo [format "dump global slack use real time %.3f seconds" $wall_time]}

  # wire(total) capacitances
  set fname ${prefix_name}_data_total_capacitances.txt
  redirect -file $nfile "report_total_capacitances_for_icexplorer $fname"
  if { [file exists $fname] } {
    catch { exec gzip -1 $fname}
  }
  set wall_time [_get_elapsed_time begin_time]
  redirect -append $::_logFile {echo [format "dump total capacitances use real time %.3f seconds" $wall_time]}

  # derate.
  set fname ${prefix_name}_data_timing_derates.txt
  redirect -file $nfile "report_timing_derate_for_icexplorer $fname"
  if { [file exists $fname] } {
    catch { exec gzip -1 $fname}
  }
  set wall_time [_get_elapsed_time begin_time]
  redirect -append $::_logFile {echo [format "dump derate use real time %.3f seconds" $wall_time]}

  # dont touch cells or nets.
  set fname ${prefix_name}_data_dont_touch_objects.txt
  redirect -file $nfile "report_dont_touch_objects_for_icexplorer $fname"
  if { [file exists $fname] } {
    catch { exec gzip -1 $fname}
  }
  set wall_time [_get_elapsed_time begin_time]
  redirect -append $::_logFile {echo [format "dump dont touch objects use real time %.3f seconds" $wall_time]}

  # used as clock pins
  set fname ${prefix_name}_data_used_as_clocks.txt
  redirect -file $nfile "report_used_as_clock_pins_for_icexplorer $fname"
  if { [file exists $fname] } {
    catch { exec gzip -1 $fname}
  }
  set wall_time [_get_elapsed_time begin_time]
  redirect -append $::_logFile {echo [format "dump clock pins use real time %.3f seconds" $wall_time]}

  # rail voltage
  set fname ${prefix_name}_data_rail_voltage.txt
  redirect -file $nfile "report_rail_voltage_for_icexplorer $fname"
  if { [file exists $fname] } {
    catch { exec gzip -1 $fname}
  }
  set wall_time [_get_elapsed_time begin_time]
  redirect -append $::_logFile {echo [format "dump rail_voltage use real time %.3f second" $wall_time]}

  # si delta
  set fname ${prefix_name}_data_si_delta.txt
  report_delta_data_for_icexplorer $fname $::deltaDelayThreshold
  if { [file exists $fname] } {
    catch { exec gzip -1 $fname}
  }
  set wall_time [_get_elapsed_time begin_time]
  redirect -append $::_logFile {echo [format "dump si delta use real time %.3f seconds" $wall_time]} 

  # si noise 
  if { ! $::skipNoise } {
    set fname ${prefix_name}_data_si_noise.txt
    redirect -file $nfile "report_si_noise_for_icexplorer $fname"
    if { [file exists $fname] } {
      catch { exec gzip -1 $fname}
    }
  }
  set wall_time [_get_elapsed_time begin_time]
  redirect -append $::_logFile {echo [format "dump si noise use real time %.3f seconds" $wall_time]} 

  #IO objects file
  set fname ${prefix_name}_data_ilm_objects.txt
  redirect -file $nfile "report_ilm_objects_for_icexplorer $fname"
  if { [file exists $fname] } {
    catch { exec gzip -1 $fname}
  }
  set wall_time [_get_elapsed_time begin_time]
  redirect -append $::_logFile {echo [format "dump ilm objects use real time %.3f seconds" $wall_time]}
}

##-- Report port timing info.
proc report_ports_timing_for_icexplorer {fid} {
   puts $fid "\n#Port port_name Setup_RiseTrans Setup_FallTrans Hold_RiseTrans Hold_FallTrans Max_Trans  Max_Cap"
   set ports [get_ports *]
   foreach_in_collection pp $ports {
      # transition
      puts -nonewline $fid [get_attribute $pp full_name]
      puts -nonewline $fid "  [get_attribute -quiet $pp actual_rise_transition_max]"
      puts -nonewline $fid "  [get_attribute -quiet $pp actual_fall_transition_max]"
      puts -nonewline $fid "  [get_attribute -quiet $pp actual_rise_transition_min]"
      puts -nonewline $fid "  [get_attribute -quiet $pp actual_fall_transition_min]"

      ## max_transition
      set maxtransition [get_attribute -quiet $pp max_transition]
      if {$maxtransition == ""} {
         puts -nonewline $fid " \t*"
      } else {
         puts -nonewline $fid [format " \t%.6f" $maxtransition]
      }
      ## max_capacitance
      set maxcaps [get_attribute -quiet $pp max_capacitance]
      if {$maxcaps == ""} {
         puts -nonewline $fid " \t*"
      } else {
         puts -nonewline $fid [format " \t%.6f" $maxcaps]
      }

      puts $fid ""
   }
   unset ports
}

##############################################################################
### Write io pins by fanin and fanout.
##############################################################################
proc write_fanin_fanout_pins { fid {skip_ports ""} } {
  set all_ports [ remove_from_collection [add_to_collection [all_inputs -exclude_clock_ports] [all_outputs]] $skip_ports]
  if { [sizeof_collection $all_ports] < 1 } {
    return;
  }
  set ilm_pins [all_fanout -from $all_ports -flat -trace_arcs all]
  append_to_collection -unique ilm_pins [all_fanin -to $all_ports \
                                         -flat -trace_arcs all]
  #set ilm_pins [filter_collection  $ilm_pins "!defined(clocks)"]
  set ilm_pins_name [get_attribute -quiet -value_list $ilm_pins full_name]
  set number [sizeof_collection $ilm_pins]
  puts $fid "\n#pins_name $number";
  set iternum [expr $number/$::iceCutnum]
  for {set x 0} {$x <= $iternum} {incr x} {
    set tmp [lrange $ilm_pins_name [expr $x * $::iceCutnum] [expr (($x+1) * $::iceCutnum) - 1]]
    set tmp [string map {" " "\n" "{" "" "}" ""} $tmp]
    puts $fid $tmp
  }
}
##############################################
proc ice_helps { } {
  puts ""
  puts "########################################################"
  puts "# This script is used for ICExplorer2                  #"
  puts "# Available commands:                                  #"
  puts "#  report_scenario_data_for_icexplorer                 #"
  puts "#  report_pba_data_for_icexplorer                      #"
  puts "########################################################"
  help -verbose report_scenario_data_for_icexplorer
  help -verbose report_pba_data_for_icexplorer
}

ice_helps

