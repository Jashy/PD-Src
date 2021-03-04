#--------------------------------------------------------
#Script For Generate NDM Files For  rfps2p64x100m2k1p
#--------------------------------------------------------
source /proj2/FEINT/GENIP/rfps_new/genip_script/ndm_gen_script/n7/run.tcl 
source -e /proj2/FEINT/GENIP/rfps_new/genip_script/ndm_gen_script/n7/library_global_lm_setting.tcl 
set PVT " ssgnp_ccwt0p675v0c tt0p75v85c ffgnp_ccbt1p045v0c ffgnp_ccbt0p825v0c ffgnp_ccbt0p935v0c"
set sram_name rfps2p64x100m2k1p
set LIBNAME $sram_name
sh rm /proj2/FEINT/GENIP/rfps_new/sram/${sram_name}/${LIBNAME}_ccs.ndm -rf
create_workspace $LIBNAME -flow normal -technology $TECH_FILE 

#######################################################################
## Define all the .db files to use.
## May need to use the -process_label option if process
## names not unique
#
## logic libray file (.db) is used only to determine 
## golden port directon
########################################################################

read_lef -cell_boundary by_cell_size /proj2/FEINT/GENIP/rfps_new/sram/${sram_name}/${sram_name}.plef

foreach corner $PVT {
  set corner_target $corner
  set db_file [glob /proj2/FEINT/GENIP/rfps_new/sram/${sram_name}/$corner/${sram_name}.db]
  foreach corner_source [array names corner_map ] { 
     if {$corner_source == $corner} {set corner_target $corner_map($corner_source)} 
  }
    read_db -process_label $corner_target $db_file
    puts "read_db -process_label $corner_target $db_file
"}

#### read gds file, don't need for macro
#read_gds ${data_dir}/gds/${LIBNAME}.gds 
#         -layer_map $LM_GDS_MAPPING_FILE 
#         -block_map block.map 
#         -trace_option pins_only

set_app_options -as_user_default -name lib.physical_model.preserve_metal_blockage -value false
set_app_options -as_user_default -name lib.physical_model.block_all -value false
set_app_options -as_user_default  -name lib.physical_model.trim_metal_blockage_around_pin -value { {M1 touch} }
check_workspace -allow_missing
report_lib -antenna -physical -routability -placement_constraints -wire_tracks -timing_arcs ${LIBNAME}
commit_workspace -force -output /proj2/FEINT/GENIP/rfps_new/sram/${sram_name}/${LIBNAME}_ccs.ndm

exit
