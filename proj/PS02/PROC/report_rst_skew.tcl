###report reset pins skew in PT############################################
proc report_rst_skew { rst_port report_file_name} {
  set all_endpoints [ all_fanout -from $rst_port -flat -endpoints_only  ]
  array unset delay
  echo -n "" > .tmp
  foreach_in_collection endpoint $all_endpoints {
    echo "  [ get_attr [ get_timing_path -from $rst_port -to $endpoint ] arrival ] [ get_attr $endpoint full_name ]" >> .tmp
  }
  exec sort -u -n .tmp > ${report_file_name}_skew.rpt
}
echo "please run 'report_rst_skew rst_port report_file_name'"
