proc fpb {from to} {
        report_timing -from $from -to $to -input_pins -nets -nosplit
        }
proc fpbc {from to} {
        report_timing -from $from -to $to -input_pins -nets -path full_clock -nosplit
        }
proc fpt {to} {
        report_timing -to $to -input_pins -nets -nosplit
        }
proc fpthr {thr} {
        report_timing -th $thr -input_pins -nets -nosplit
        }
proc fptc {to} {
        report_timing -to $to -input_pins -nets -path full_clock -nosplit
        }
proc fpf {from} {
        report_timing -from $from -input_pins -nets -nosplit
        }
proc fpfc {from} {
        report_timing -from $from -input_pins -nets -path full_clock -nosplit
        }

proc fpbh {from to} {
        report_timing -from $from -to $to -input_pins -nets -nosplit -delay min
        }
proc fpbhc {from to} {
        report_timing -from $from -to $to -input_pins -nets -path full_clock -nosplit -delay min
        }
proc fpth {to} {
        report_timing -to $to -input_pins -nets -nosplit -delay min
        }
proc fpthc {to} {
        report_timing -to $to -input_pins -nets -path full_clock -nosplit -delay min
        }
proc fpfh {from} {
        report_timing -from $from -input_pins -nets -nosplit -delay min
        }
proc fpfhc {from} {
        report_timing -from $from -input_pins -nets -path full_clock -nosplit -delay min
        }

proc rn {net} {
        report_net -conn $net
        }
proc rc {cell} {
        report_cell -conn $cell
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

proc fn {net} {
  #find -hierarchy net *$net* 
  set all_nets [find -hierarchy net *$net*]
  foreach_in_collection list $all_nets {
      set net_name [get_attr $list full_name]
      puts $net_name
  }
}

proc tn {net} {
  puts [get_attribute [get_nets [get_nets $net] -top_net_of_hierarchical_group -segments] full_name]
} 

proc pin2net {pin} {
  puts [get_attribute [get_nets [all_connected $pin] -top_net_of_hierarchical_group -segments] full_name]
}

proc cda { from to delay } {
  set_annotated_delay -cell -from $from -to $to $delay
}

proc cdi { from to increment } {
  set_annotated_delay -cell -from $from -to $to -increment $increment
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

