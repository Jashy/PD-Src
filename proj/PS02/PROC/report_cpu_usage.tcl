proc report_cpu_usage { } {
  set data [ sh /bin/ps -p [ pid ] -o "time,etime,rss,vsz" ]
  set cpu_time     [ lindex $data 4 ]
  set elapsed_time [ lindex $data 5 ]
  set memory_usage [ lindex $data 7 ]
  echo [ format "CPU time: %s" $cpu_time ]
  echo [ format "Elapsed time: %s" $elapsed_time ]
  echo [ format "Memory usage: %.3f\[MB\]" [ expr $memory_usage / 1000 ] ]
}

if { 1 == 0 } {

source /home/mitsuya/synopsys/tcl/report_cpu_usage.tcl ;
report_cpu_usage ;

}

