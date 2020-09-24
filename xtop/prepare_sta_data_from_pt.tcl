source /project/PD/signoff/fct/fullchip_timing/BI/XTOP_TRAIL/tile_script_12_12/timing_data_0.tcl

set sta_data_dir ./sta_data 
set tokens [split $scenario -]
set checktype [lindex $tokens 5]
if {[regexp "Hld" $checktype]} {
  report_pba_data_for_icexplorer -scenario_name $scenario -dir $sta_data_dir -delay_type min -max_paths 1000000 -nworst 20 -path_type full -pba_mode none
} elseif {[regexp "Stp" $checktype]} {
  report_pba_data_for_icexplorer -scenario_name $scenario -dir $sta_data_dir -delay_type max -max_paths 1000000 -nworst 20 -path_type full -pba_mode none
} else {
  report_pba_data_for_icexplorer -scenario_name $scenario -dir $sta_data_dir -delay_type min_max -max_paths 1000000 -nworst 20 -path_type full -pba_mode none
}
report_scenario_data_for_icexplorer -scenario_name $scenario -dir  $sta_data_dir
redirect $sta_data_dir/${scenario}_link_path {puts [join [lrange $link_path 2 end] "\n"]}
