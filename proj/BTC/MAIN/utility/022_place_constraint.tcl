###################
## the following options is closed by Jupiter

# set_pnet_options -partial -density 0 { M2 M1 }
# set placer_gated_register_area_multiplier 15
# set physopt_delete_unloaded_cells  false
# set physopt_checkpoint_stage 1
# set_buffer_opt_strategy -effort medium
# set_cost_priority {max_delay max_transition max_capacitance max_fanout} 
# set_distributed_route
# remove_clock_cell_spacing -all
# set_clock_cell_spacing -y_spacing 0.9 -lib_cells {S2CKBUFV1D16 S2CKBUFV1D14 S2CKBUFV1D12 S2CKBUFV1D10 S2CKBUFV1D8 S2CKBUFV1D6}


#-#-  set_pnet_options -partial M3 ; # recommended by SNPS -> commented because routing violation in 14nm
set physopt_delete_unloaded_cells  false
set_fix_multiple_port_nets -all -buffer_constants [all_designs]
set_auto_disable_drc_nets -constant false
#set_cbt_options -threshold $MAX_FANOUT -references $CBT_BUFFER
#-#-  set CBT_BUFFER "BUFFD4BWP20P90 BUFFD8BWP20P90 BUFFD12BWP20P90 BUFFD16BWP20P90 INVD8BWP20P90 INVD12BWP20P90 INVD16BWP20P90"
#-#-  set_ahfs_options -mf_threshold -1 -enable_port_punching false -default_reference $CBT_BUFFER 
# 
set place_opt_enable_new_hfs true
set placer_enable_enhanced_soft_blockages true
set placer_enable_enhanced_router true
set physopt_new_fix_constants true
set physopt_ultra_high_area_effort true
set placer_enable_high_effort_congestion true
set physopt_enable_via_res_support true
set_cost_priority {max_delay max_transition max_capacitance max_fanout} 
set_place_opt_strategy -consider_routing true

#-#-  #tsmc rule
#-#-  source ./jupiter2_scripts/data/set_lib_cell_label_spacing.tcl
set_separate_process_options -routing false -extraction false  -placement false
#-#-  set legalizer_vth_spacing_use_files true ;#TSMC recommended
#-#-  set legalizer_consider_vth_spacing true ;#TSMC recommended 


# Use these commands before placement to make sure gap of 1 unit-tile is not created.
# Minimum filler cell width is 2-unit-tile.
remove_all_spacing_rules
set_lib_cell_spacing_label -left_lib_cells *_A*T*_C1* -right_lib_cells *_A*T*_C1* -names no_1x
set_spacing_label_rule {1 1} -labels  {no_1x no_1x}
#-#-  set_lib_cell_spacing_label -names {X} -left_lib_cells {*} -right_lib_cells {*} 
#-#-  set_spacing_label_rule -labels {X X} {1 1}
source -e ./flow_btc/tcl/set_spacing_label_rule.tcl

#Recommendation by SNPS
#For GR driven placement, need to  use -congestion and also use:
#set_app_var placer_congestion_effort medium
#set_app_var placer_show_zroutegr_output true
