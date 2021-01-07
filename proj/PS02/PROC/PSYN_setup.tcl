  ########################################################################
  # control
  #
  set physopt_delete_unloaded_cells             "true"          ; # default = "true"
  set compile_instance_name_prefix              "ALCHIP_U"      ; # default = "U"
  set compile_instance_name_suffix              ""              ; # default = ""
  set verilogout_no_tri                         "true"          ; # default = "false"
  set timing_enable_multiple_clocks_per_reg     "true"          ; # default = "false"
  
  ########################################################################
  # TCL PROCEDURE
  #
  source /proj/BM/TEMPLATES/DC/report_violation.tcl
  source /proj/BM/TEMPLATES/DC/report_violation_summary.tcl
  source /proj/BM/TEMPLATES/DC/get_potential_high_fanout_net.tcl
  
