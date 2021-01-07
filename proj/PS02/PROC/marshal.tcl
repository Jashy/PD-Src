##########set aliases#########
alias page_on {set sh_enable_page_mode true}
alias page_off {set sh_enable_page_mode false}
alias h {history}

#########procedures##########
proc clk { ck_pin } {
#  report_timing -from $ck_pin -path_type full_clock -nets -input_pins
report_clock_timing -to $ck_pin -type latency -verbose -nosplit -significant_digits 3
}

proc clkr { ck_pin } {
#  report_timing -from $ck_pin -path_type full_clock -nets -input_pins
report_clock_timing -rise -to $ck_pin -type latency -verbose -nosplit -significant_digits 3
}
proc clkf { ck_pin } {
#  report_timing -from $ck_pin -path_type full_clock -nets -input_pins
report_clock_timing -fall -to $ck_pin -type latency -verbose -nosplit -significant_digits 3
}


proc clk1 { ck_pin } {
#  report_timing -from $ck_pin -path_type full_clock -nets -input_pins
report_clock_timing -to $ck_pin -type latency -verbose -nworst 1 -significant_digits 3
}

proc ck { ck_pin } {
report_clock_timing -to $ck_pin -type latency -verbose -nosplit -net -significant_digits 3
}

proc cks { ck_name } {
report_clock_timing -clock $ck_name -type skew -significant_digits 3
}

proc cka { ck_pin } {
 report_clock_timing -to $ck_pin -type latency -nworst 99999 -no -significant_digits 3
}

proc gcs { ck_name } {
  puts [ get_attr [ get_attr [ get_clocks $ck_name ] sources ] full_name ]
}


proc get_case_value { pin_name } {
  puts [ get_attr [ get_pins $pin_name ] case_value ]
}

proc rft {from to} {
        report_timing -from $from -to $to -input_pins -nets -nosplit  -significant_digits 3
        }
proc rftc {from to} {
        report_timing -from $from -to $to -input_pins -nets -path full_clock_expanded -nosplit -significant_digits 3
        }
proc rt {to } {
        if { [ sizeof_collection [ get_cells $to -quiet] ] != 0 } {
          set to [ get_pins -of $to -filter "direction == in" ]
        }
        report_timing -to $to -input_pins -nets -nosplit -significant_digits 3
}
proc rta {to { slack 0 } { start_end_pair 0 } { max_paths 1 } } {
        if { [ sizeof_collection [ get_cells $to -quiet] ] != 0 } {
          set to [ get_pins -of $to -filter "direction == in" ]
        }
        if { $start_end_pair == 0 } {
          report_timing -to $to -input_pins -nets -nosplit -significant_digits 3 -slack_lesser_than $slack -max_paths $max_paths
        } else {
          report_timing -to $to -input_pins -nets -nosplit -significant_digits 3 -slack_lesser_than $slack -start_end_pair
        }
}
proc rthr {thr} {
        report_timing -th $thr -input_pins -nets -nosplit -significant_digits 3
        }

proc rthrl {thr less_than} {
        report_timing -th $thr -input_pins -nets -nosplit -slack_lesser_than $less_than -significant_digits 3
k       }

proc rtr {to} {
        if { [ sizeof_collection [ get_cells $to -quiet] ] != 0 } {
          set to [ get_pins -of $to -filter "direction == in" ]
        }

        report_timing -rise_to $to -input_pins -nets -nosplit -significant_digits 3
        }

proc rtrc {to} {
        if { [ sizeof_collection [ get_cells $to -quiet] ] != 0 } {
          set to [ get_pins -of $to -filter "direction == in" ]
        }

        report_timing -rise_to $to -input_pins -nets -nosplit -path full_clock_expanded -significant_digits 3
        }

proc rtf {to} {
        if { [ sizeof_collection [ get_cells $to -quiet] ] != 0 } {
          set to [ get_pins -of $to -filter "direction == in" ]
        }

        report_timing -fall_to $to -input_pins -nets -nosplit -significant_digits 3
        }

proc rtfc {to} {
        if { [ sizeof_collection [ get_cells $to -quiet] ] != 0 } {
          set to [ get_pins -of $to -filter "direction == in" ]
        }

        report_timing -fall_to $to -input_pins -nets -nosplit -path full_clock_expanded -significant_digits 3
        }

proc rtc {to} {
        if { [ sizeof_collection [ get_cells $to -quiet] ] != 0 } {
          set to [ get_pins -of $to -filter "direction == in" ]
        }
        report_timing -to $to -input_pins -nets -path full_clock_expanded -nosplit  -significant_digits 3
        }
proc rf {from} {
        if { [ sizeof_collection [ get_cells $from -quiet] ] != 0 } {
	  set from [ get_pins -of $from -filter "direction == out" ]
	}
        report_timing -from $from -input_pins -nets -nosplit  -significant_digits 3
        }

proc rfa { from { slack 0 } { start_end_pair 0 } { max_paths 1 } } {
        if { [ sizeof_collection [ get_cells $from -quiet] ] != 0 } {
          set to [ get_pins -of $to -filter "direction == out" ]
        }
        if { $start_end_pair == 0 } {
          report_timing -from $from -input_pins -nets -nosplit -significant_digits 3 -slack_lesser_than $slack -max_paths $max_paths
        } else {
          report_timing -from $from -input_pins -nets -nosplit -significant_digits 3 -slack_lesser_than $slack -start_end_pair
        }
}


proc rfn {from} {
        if { [ sizeof_collection [ get_cells $from -quiet] ] != 0 } {
          set from [ get_pins -of $from -filter "direction == out" ]
        }
        report_timing -from $from -input_pins -nets -nosplit -nworst 1  -significant_digits 3
        }


proc rfc {from} {
        if { [ sizeof_collection [ get_cells $from -quiet] ] != 0 } {
          set from [ get_pins -of $from -filter "direction == out" ]
        }
        report_timing -from $from -input_pins -nets -path full_clock_expanded -nosplit  -significant_digits 3
        }

proc rtgc {to g} {
        report_timing -to $to -input_pins -nets -nosplit -significant_digits 3 -group $g -path full_clock_expanded  -significant_digits 3
        }

## hold
proc rftm {from to} {
        if { [ sizeof_collection [ get_cells $from -quiet] ] != 0 } {
          set from [ get_pins -of $from -filter "direction == out" ]
        }
        report_timing -from $from -to $to -input_pins -nets -nosplit -delay min  -significant_digits 3
        }
proc rftmc {from to} {
        if { [ sizeof_collection [ get_cells $from -quiet] ] != 0 } {
          set from [ get_pins -of $from -filter "direction == out" ]
        }
        report_timing -from $from -to $to -input_pins -nets -path full_clock_expanded -nosplit -delay min  -significant_digits 3
        }
proc rtm {to} {
        if { [ sizeof_collection [ get_cells $to -quiet] ] != 0 } {
          set to [ get_pins -of $to -filter "direction == in" ]
        }

        report_timing -to $to -input_pins -nets -nosplit -delay min -significant_digits 3
        }


proc rtgm {to g} {
        if { [ sizeof_collection [ get_cells $to -quiet] ] != 0 } {
          set to [ get_pins -of $to -filter "direction == in" ]
        }

        report_timing -to $to -input_pins -nets -nosplit -delay min -significant_digits 3 -group $g
        }

proc rtgcm {to g} {
        if { [ sizeof_collection [ get_cells $to -quiet] ] != 0 } {
          set to [ get_pins -of $to -filter "direction == in" ]
        }

        report_timing -to $to -input_pins -nets -nosplit -delay min -significant_digits 3 -group $g -path full_clock_expanded
        }

proc rtcm {to} {
        if { [ sizeof_collection [ get_cells $to -quiet] ] != 0 } {
          set to [ get_pins -of $to -filter "direction == in" ]
        }

        report_timing -to $to -input_pins -nets -path full_clock_expanded -nosplit -delay min  -significant_digits 3
        }
proc rfm {from} {
        if { [ sizeof_collection [ get_cells $from -quiet] ] != 0 } {
          set from [ get_pins -of $from -filter "direction == out" ]
        }
        report_timing -from $from -input_pins -nets -nosplit -delay min  -significant_digits 3
        }
proc rfcm {from} {
        if { [ sizeof_collection [ get_cells $from -quiet] ] != 0 } {
          set from [ get_pins -of $from -filter "direction == out" ]
        }
        report_timing -from $from -input_pins -nets -path full_clock_expanded -nosplit -delay min  -significant_digits 3
        }

proc rn {net} {
        report_net -conn $net
        }
proc rc {cell} {
        report_cell -conn $cell
        }

proc srt { cell_name } {
  set worst_slack 999999
  foreach_in_collection input [ get_pins -of $cell_name -filter "direction == in " ] {
    set pin_name [ get_attr $input full_name ]
    foreach_in_collection timing_path [ get_timing_paths -to [ get_pins $pin_name ] -delay max ] {
      set slack [ get_attribute $timing_path slack ]
      if { $slack < $worst_slack } {
        set worst_slack $slack
      }
    }
  }
  puts "$worst_slack"
}

proc srtm { cell_name } {
    set worst_slack 999999
  foreach_in_collection input [ get_pins -of $cell_name -filter "direction == in " ] {
    set pin_name [ get_attr $input full_name ]
    foreach_in_collection timing_path [ get_timing_paths -to [ get_pins $pin_name ] -delay min ] {
      set slack [ get_attribute $timing_path slack ]
      if { $slack < $worst_slack } {
        set worst_slack $slack
      }
    }
  }
    puts "$worst_slack"
}

proc srf { cell_name } {
    set worst_slack 999999
  foreach_in_collection input [ get_pins -of $cell_name -filter "direction == out " ] {
    set pin_name [ get_attr $input full_name ]
    foreach_in_collection timing_path [ get_timing_paths -to [ get_pins $pin_name ] -delay max ] {
      set slack [ get_attribute $timing_path slack ]
      if { $slack < $worst_slack } {
        set worst_slack $slack
      }
    }
  }
    puts "$worst_slack"
}

proc srfm { cell_name } {
    set worst_slack 999999
  foreach_in_collection input [ get_pins -of $cell_name -filter "direction == out " ] {
    set pin_name [ get_attr $input full_name ]
    foreach_in_collection timing_path [ get_timing_paths -to [ get_pins $pin_name ] -delay min ] {
      set slack [ get_attribute $timing_path slack ]
      if { $slack < $worst_slack } {
        set worst_slack $slack
      }
    }
  }
    puts "$worst_slack"
}

##

proc fpbsn {s n from to} {
report_timing -slack_lesser_than $s -nworst $n -from $from -to $to -nosplit
}
proc fpbn {n from to} {
report_timing -nworst $n -from $from -to $to -nosplit
}
proc fpbgln {g l n from to} {
report_timing -slack_greater_than $g -slack_lesser_than $l -nworst $n -from $from -to $to -nosplit
}
proc fptsn {s n to} {
report_timing -slack_lesser_than $s -nworst $n -to $to -nosplit
}
proc fpbsnn {s n from to} {
report_timing -slack_lesser_than $s -nworst $n -from $from -to $to -nosplit -input_pins -nets
}

proc fc {cell} {
  set all_cells [find -hierarchy cell *$cell*]
  foreach_in_collection list $all_cells {
      set cell_name [get_attr $list full_name]
      puts $cell_name
  }
}

proc fcf {cell} {
  set RPT [ open cell.list w ]
  set all_cells [find -hierarchy cell *$cell*]
  foreach_in_collection list $all_cells {
      set cell_name [get_attr $list full_name]
      puts $cell_name
      puts $RPT $cell_name
  }
}


proc fn {net} {
  #find -hierarchy net *$net* 
  set all_nets [find -hierarchy net *$net*]
  foreach_in_collection list $all_nets {
      set net_name [get_attr $list full_name]
      puts $net_name
  }
}

proc gbn { pin } {
  set nets [ get_nets -of $pin -seg ]
  foreach_in_collection net $nets {
    set net_name [ get_attr $net full_name ]
    if { [ regexp {UUruby_dft/ruby_core/image_proc/(\S+)} $net_name "" port ] == 1 } {
      if { [ regexp {\/} $port ] != 1 } {
        puts [ format "%-12s : %-15s" "image_proc" $port ]
      }
    }
    if { [ regexp {UUruby_dft/ruby_core/arm926/(\S+)} $net_name "" port ] == 1 } {
      if { [ regexp {\/} $port ] != 1 } {
        puts [ format "%-12s : %-15s" "arm926" $port ]
      }
    }
  }
}

proc tn {net} {
  puts [get_attribute [get_nets [get_nets $net] -top_net_of_hierarchical_group -segments] full_name]
} 

proc pt {pin} {
  puts [get_attribute [get_nets [all_connected $pin] -top_net_of_hierarchical_group -segments] full_name]
}

proc rp {pin} {
  report_net -conn [get_attribute [get_nets [all_connected $pin] -top_net_of_hierarchical_group -segments] full_name]
}

proc filter_ref {ins_key ref_key} {
        foreach_in_collection dummy [get_cells $ins_key -hierarchical] {
                        set name [get_attribute $dummy ref_name]
                        set insname [get_attribute $dummy full_name]
                        if { [ string match $ref_key $name ] != 1 } {
                                echo "$insname\t\t($name)"
                        }
        }
}

proc rl {pin} {

	rp [get_attr [get_pins -of [get_cells -of $pin] -filter "pin_direction == out"] full_name]

}

proc rd {pin} {

	 rp [get_attr [get_pins -of [get_cells -of $pin] -filter "pin_direction == in"] full_name]

}


proc report_ins_by_ref {ref_key} {
        foreach_in_collection ins [get_cells * -hierarchical] {
                        set name [get_attribute $ins ref_name]
                        set insname [get_attribute $ins full_name]
                        if { [ string match $ref_key $name ] == 1 } {
                                echo $insname
                        }
        }
}

proc match_ref {ins ref_key} {
	echo [sizeof_collection [get_cells $ins -hierarchical]]
	foreach_in_collection ins [get_cells $ins -hierarchical] {
                        set name [get_attribute $ins ref_name]
                        set insname [get_attribute $ins full_name]
                        if { [ string match $ref_key $name ] == 0 } {
                                echo $insname
                        }
        }
}

proc get_num_ref {ref_key} {
	set num 0
        foreach_in_collection ins [get_cells * -hierarchical] {
                        set name [get_attribute $ins ref_name]
                        set insname [get_attribute $ins full_name]
                        if { [ string match $ref_key $name ] == 1 } {
                               incr num 
                        }
        }
	echo $num
}

proc report_ins_by_ins {ins_key} {
        foreach_in_collection ins [get_cells $ins_key -filter "is_hierarchical == false"] {
                        set insname [get_attribute $ins full_name]
                        echo $insname
        }
}


proc cda { from delay } {
  set to [ get_pins -of [ get_cells -of $from ] -filter "direction == out" ]
  set_annotated_delay -cell -from $from -to $to $delay
}

proc cdar { from delay } {
  set to [ get_pins -of [ get_cells -of $from ] -filter "direction == out" ]
  set_annotated_delay -cell -from $from -to $to $delay -rise
}
proc cdaf { from delay } {
  set to [ get_pins -of [ get_cells -of $from ] -filter "direction == out" ]
  set_annotated_delay -cell -from $from -to $to $delay -fall
}

proc cdac { cell delay } {
  set outs [ get_pins -of [ get_cells $cell ] -filter "direction == out" ]
  set ins  [ get_pins -of [ get_cells $cell ] -filter "direction == in" ]
  foreach_in_collection in $ins {
    foreach_in_collection out $outs {
      set_annotated_delay -cell -from $in -to $out $delay
    }
  }
}



proc cdaft { from to delay } {
  set to [ get_pins -of [ get_cells -of $from ] -filter "direction == out" ]
  set_annotated_delay -cell -from $from -to $to $delay
}

proc cdif { from to increment } {
  set_annotated_delay -cell -from $from -to $to -increment $increment
}
proc cdi { from increment } {
  set to [ get_pins -of [ get_cells -of $from ] -filter "direction == out" ]
  set_annotated_delay -cell -from $from -to $to -increment $increment
}

proc cdan { from value } {
  set_annotated_delay $value -net -from $from
}


proc latency { } {
  report_clock_timing -type latency -clock [get_clocks *] -nworst 50000 -nosplit > latency.detail.rpt
}

proc skew { } {
  report_clock_timing -type skew -clock [get_clocks *] -nworst 50000 -nosplit > skew.detail.rpt
}

proc rewire_reset {arg} {

echo "" > $arg.v2v
set inst [all_fanout -from $arg]
foreach_in_collection list $inst {
   set cell_name [get_attr $list full_name]
   if {[regexp {(\S+)\/RN} $cell_name]} {
       set net_name [all_conn [get_pin $cell_name] ]
       set NetName [get_attr $net_name full_name]
       set tmp_cell_name "$cell_name"
       regsub  {\/[A-Za-z0-9]+$}  $tmp_cell_name "" cell_name
       echo "REWIRE " $cell_name $NetName $arg >> $arg.v2v

   } elseif {[regexp {(\S+)\/SN} $cell_name]} {
      set net_name [all_conn [get_pin $cell_name] ]
      set NetName [get_attr $net_name full_name]
      set tmp_cell_name "$cell_name"
      regsub  {\/[A-Za-z0-9]+$}  $tmp_cell_name "" cell_name
      echo "REWIRE " $cell_name $NetName $arg >> $arg.v2v
   }
  }
}

proc get_clock_ports {} {
	set clk_port_list {}
	foreach_in_collection this_clock [all_clocks] {
		set source_of_clock [get_attribute [get_clocks $this_clock] sources]
                foreach_in_collection one_source $source_of_clock {   
                     set object_type [get_attribute $one_source object_class] 
                     if {$object_type == "port"} { 
                          lappend clk_port_list [get_object_name $one_source] 
                     }
                } 
	}
	return $clk_port_list
}
########## setup view utilities ##############
############# SETUP VIEW UTILITY ###############

proc view {args} {
    redirect tmpfile1212 {uplevel $args}
    # Without redirect, exec echos the PID of the new process to the screen
    redirect /dev/null {exec ../ref/tcl_procs/view.tk tmpfile1212 "$args" &}
}

alias vrt {view report_timing -nosplit}
alias vrtm {view report_timing -nosplit -delay min}
alias vman {view man}

############# SETUP FULL LOGGING ###############
set timestamp [clock format [clock scan now] -format "%Y-%m-%d_%H:%M"]
#set sh_output_log_file "${synopsys_program_name}.log.$timestamp"


if {  $synopsys_program_name == "astro"} {
	source ~/utility/TCL/ASTRO/ASTRO.tcl
	InitWindow
	defineBindKey  "r" "( tcl \"source .hlight\" )"
        defineBindKey  "v" "( tcl \"ToogleLayerView\" )"
        defineBindKey  "V" "( tcl \"DeToogleLayerView\" )"
        defineBindKey  "x" "( tcl \"HFB\" )"
        defineBindKey  "X" "( tcl \"HFBs\" )"



}

proc rpt { STA_MODE {internal in } } {
    set all_inputs  [ all_inputs ]
    set all_outputs [ all_outputs ]
    foreach_in_collection clock [ get_clocks * ] {
        set all_inputs [ remove_from_collection $all_inputs [ get_attribute $clock sources ] ]
    }
    if { $internal == "internal" } {
      puts "Report Internal"
      set_false_path -from $all_inputs
      set_false_path -to $all_outputs
      report_timing -nets -input_pins -nosplit -significant_digits 3 \
        -max_paths 100000 -slack_lesser_than 0 -nworst 1 -unique_pins \
        -delay_type ${STA_MODE} -path_type full \
        > ./report_timing_${internal}.rep
      exec /usr/bin/perl /proj/Pezy-1/TEMPLATES/PT/check_violation_summary.pl \
          ./report_timing_${internal}.rep \
        > ./report_timing_${internal}.rep.summary
    } elseif { $internal == "ac" } {
      puts "Report AC"
      report_timing -nets -input_pins -nosplit -significant_digits 3 \
        -max_paths 100000 -slack_lesser_than 0 -nworst 1 -unique_pins -from $all_inputs \
        -delay_type ${STA_MODE} -path_type full \
        > ./report_timing_${internal}.rep
      report_timing -nets -input_pins -nosplit -significant_digits 3 \
        -max_paths 100000 -slack_lesser_than 0 -nworst 1 -unique_pins -to $all_outputs \
        -delay_type ${STA_MODE} -path_type full \
        >> ./report_timing_${internal}.rep
      exec /usr/bin/perl /proj/Pezy-1/TEMPLATES/PT/check_violation_summary.pl \
          ./report_timing_${internal}.rep \
        > ./report_timing_${internal}.rep.summary
    } elseif { $internal == "all" } {
      puts "Report ALL"
      report_timing -nets -input_pins -nosplit -significant_digits 3 \
        -max_paths 100000 -slack_lesser_than 0 -nworst 1 -unique_pins \
        -delay_type ${STA_MODE} -path_type full \
        > ./report_timing.rep
      exec /usr/bin/perl /proj/Pezy-1/TEMPLATES/PT/check_violation_summary.pl \
          ./report_timing.rep \
        > ./report_timing.rep.summary
    } else {
      puts "Report ALL"
      report_timing -nets -input_pins -nosplit -significant_digits 3 \
        -max_paths 100000 -nworst 1 -unique_pins \
        -delay_type ${STA_MODE} -path_type full -to $internal \
        > ./report_timing.rep
      exec /usr/bin/perl /proj/Pezy-1/TEMPLATES/PT/check_violation_summary.pl \
          ./report_timing.rep \
        > ./report_timing.rep.summary
    }
}

proc rpt_skew {} {
#    source /proj/Pezy-1/WORK/Peter/PT/scripts/check_report_clock_timing_latency.tcl
source ~/utility/PT/check_report_clock_timing_latency.tcl
#/proj/Pezy-1/TEMPLATES/PT/check_report_clock_timing_latency.tcl
    check_report_clock_timing_latency
}

proc dump_db {} {
       global TOP
       global CORNER
       stop_hosts
       set extract_model_capacitance_limit 190.000000
       set extract_model_clock_transition_limit 1.500000
       set extract_model_data_transition_limit 1.500000
       set extract_model_synthesis_compatible true
      #extract_model -parasitic_format spef -output    ./${TOP}.${CORNER}.spef
      #extract_model -format lib -library_cell -output ./${TOP}.${CORNER}.lib      
      #echo                                           "./${TOP}.${CORNER}.lib generated."
       extract_model -format db  -library_cell -output ./${TOP}.${CORNER}.db
       exec touch ./${TOP}.${CORNER}.db.ready
       echo                                           "./OUTPUT/${TOP}.${CORNER}.db  generated."
}

proc get_net_max_transition { net } {
  set max -999
  foreach_in_collection pin [ get_loads $net ] {
    set max_tran [ get_pin_max_transition $pin ]
    if { $max_tran > $max } { set max $max_tran }
  }
  return $max
}

proc get_net_loading_transition { net { thre 0.080 } { file ./.tmp } } {
  set max -999
  echo -n "" > $file
  foreach_in_collection pin [ get_loads $net ] {
    set max_tran [ get_pin_max_transition $pin ]
    if { $max_tran > $thre } {
       puts "[ get_attr $pin full_name ] $max_tran" 
       echo "hilight_object [ get_attr $pin full_name ]" >> ./.tmp
    }
    if { $max_tran > $max } { set max $max_tran }
  }
  return $max
}


proc get_pin_max_transition { pin } {
  set actual_rise_transition_max [ get_attr [ get_pins $pin ] actual_rise_transition_max ]
  set actual_fall_transition_max [ get_attr [ get_pins $pin ] actual_fall_transition_max ]
  if { $actual_rise_transition_max > $actual_fall_transition_max } {
    return $actual_rise_transition_max
  }
  return $actual_fall_transition_max
}

proc tc  { pin } {
  report_timing -thr $pin -input_pins -nets -nosplit -delay min  -significant_digits 3 -capacitance -transition_time
}

proc get_pin_max_slack { pin_name } {
  return [ get_pin_max_slack_single $pin_name ]
}

proc get_pin_max_slack_single { pin_name } {
  set worst_slack 999999
  foreach_in_collection timing_path [ get_timing_paths -through [ get_pins $pin_name ] -delay max ] {
    set slack [ get_attribute $timing_path slack ]
    if { $slack < $worst_slack } {
      set worst_slack $slack
    }
  }
  return $worst_slack
}


proc get_margin_cell { cell value } {
  set no_margin 0
  set cell [ get_cells $cell ]
  set cell_name [ get_attr $cell full_name ]
  foreach_in_collection pin [ get_pins -of $cell -filter "direction == out "] {
    set slack [ get_pin_max_slack $pin ]
    if { $slack < $value } { set no_margin 1 }
  }
  if { $no_margin != 1 } {
    set ref_name [ get_attr [ get_cells $cell ] ref_name ]
    if { [ regexp {^(\S+BWP12T)} $ref_name "" new_ref_name ] } {
      set new_ref_name ${new_ref_name}HVT
      if { $new_ref_name == $ref_name } { return }
      echo "## $ref_name ==> $new_ref_name"
      echo "change_link $cell_name $new_ref_name"
    }
  }
}

proc get_margin_in_list { file value } {
  foreach_in_collection pin [ get_pins_from_file $file ] {
    if { [ get_pin_max_slack $pin ] < $value } {
      echo [ get_attr $pin full_name ]
    } 
  }
}


proc get_hold_startpoints {} {

  set files [ exec find ../../ | grep _min/ | grep report_timing_internal.rep | grep -v /normal-mode/ | grep -v summary ]
  
  set cells {}
  foreach file $files {
    puts "## $file"
    set cells [ add_to_collection $cells [ get_startpoints_from_file $file ] -uni ]
  }
  
  set cells [ filter_collection $cells "ref_name =~ *BWP12T*"]
  set cells [ filter_collection $cells "ref_name !~ *HVT"]

  puts "sizeof_collection $cells"
  return $cells
}

proc change_hold_startpoints { cells remain_margin } {
  foreach_in cell $cells {
    get_margin_cell $cell $remain_margin
  }
}
