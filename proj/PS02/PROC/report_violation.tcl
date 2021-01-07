proc report_violation { file_name } {
  global synopsys_program_name
                                                                                                                                                 
  if { $synopsys_program_name == "pt_shell" } {
    report_timing -nosplit -significant_digits 3 -input_pins -nets -max_paths 999999 -nworst 1 \
      -delay_type max -path_type full -slack_lesser_than 0 \
      > $file_name
  } else {
    report_constraint -nosplit -significant_digits 3 -all_violators -max_delay -verbose > $file_name.tmp
    set endpoints {}
    set file [ open $file_name.tmp r ]
    while { [ gets $file line ] >= 0 } {
      if { [ regexp {^  (\S+)\s+\((\S+)\)\s+(\d+\.\d+)\s+\**\s+(\d+\.\d+)\s+([rf])\s*$} $line ] == 1 } {
        regexp {^  (\S+)\s+\((\S+)\)\s+(\d+\.\d+)\s+\**\s+(\d+\.\d+)\s+([rf])\s*$} $line "" pin_name ref_name
      }
      if { [ regexp {^  data arrival time\s+(\d+\.\d+)\s*$} $line ] == 1 } {
        set endpoints [ concat $endpoints $pin_name ]
      }
    }
    close $file
    if { [ llength $endpoints ] == 0 } {
      echo "Report : timing" > $file_name
    } else {
      report_timing -nosplit -significant_digits 3 -input_pins -nets -max_paths 999999 -nworst 1 \
        -delay max -path full \
        -to $endpoints -sort_by slack \
        > $file_name
    }
   #exec rm -f $file_name.tmp
  }
  sh perl /proj/BM/TEMPLATES/PT/check_violation_summary.pl $file_name > $file_name.summary
}

