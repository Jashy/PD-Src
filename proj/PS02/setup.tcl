set SEV(src)      020_icc_crt_design
set SEV(dst)      060_icc_place_opt
set SEV(dst_key)  place_opt       ; # for lib_model/lib_vt selection; icc_crt_design use the same setting as place_opt
set SEV(work_dir) [ pwd ]
set CLOCK_MODE "ideal"

source $SEV(work_dir)/scripts/des.tcl

if { [llength [all_scenarios]] != 0 } {
  remove_scenario -all
}

set_app_var compile_instance_name_prefix "PLCOPT"
sproc_source -file $SEV(scripts_dir)/scripts/generic/common_optimization_settings_icc.tcl
sproc_source -file $SEV(scripts_dir)/scripts/generic/common_route_si_settings_zrt_icc.tcl

sproc_source -file $SEV(scripts_dir)/scripts/generic/mcmm.scenarios.tcl

set_active_scenarios [ lminus [ all_scenarios ] [ get_scenarios -setup false -hold false -cts_mode true ] ]


extract_rc

report_timing -path full -delay max -input_pins -nets -slack_lesser_than 0.000 -max_paths 1000000 -transition_time -capacitance > report_timing_internal_normal-wcl_cworst_m25c_max-cts_leakage.rep.gz
