set script_dir  [file dir [info script]]
source -echo $script_dir/xtop_config.tcl
set report_dir "report_$keyword"
exec rm -rf $report_dir
exec mkdir $report_dir

set tile_name "scu_fuse_t"

# Create workspace and import design
source -echo $script_dir/design_setup.tcl
# Check if reference library cells are valid for all cell instances.
check_placement_readiness
# Create scenario and link timing library
source -echo  $script_dir/mcmm.tcl

# Read timing data
read_timing_data -data_dir $sta_data_dir
save_workspace
#
# Check if timing library cells are valid for all cell instances in all corners.
check_inst_timing_library

source -echo $script_dir/dont_touch_use.tcl

if {$fix_tran} {
  source -echo $script_dir/tran_fix.tcl
}

if {$fix_setup} {
  source -echo $script_dir/setup_fix.tcl
}

if {$fix_hold} {
  source -echo $script_dir/hold_fix.tcl
}

if {$opt_leakage} {
  source -echo $script_dir/leakage_power_opt.tcl
}


 
set eco_dir "eco_$keyword"
exec rm -rf $eco_dir
exec mkdir $eco_dir
#exec rm -rf ./PT
#exec mkdir PT
write_design_changes -format ICC2 -eco_file_prefix $keyword -output_dir $eco_dir -force
#write_design_changes -format  PT -eco_file_prefix $keyword -output_dir ./PT -force

## added by Jia Song 2019/12/3
exec cat ./$eco_dir/${keyword}_netlist_${tile_name}.txt > ./$eco_dir/${tile_name}_${keyword}.eco
exec cat ./$eco_dir/${keyword}_physical_${tile_name}.txt >> ./$eco_dir/${tile_name}_${keyword}.eco