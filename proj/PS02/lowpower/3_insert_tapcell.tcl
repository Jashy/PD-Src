## insert tap cells
set TAP_CELL         FILLBIASNW4_A8TR
set ENDCAP_LEFT      ENDCAPBIASNW5_A8TR
set ENDCAP_RIGHT     ENDCAPBIASNW5_A8TR
set DCAP             FILLCAP64_A8TR

set spare_DCAP_distance 100
set tap_cell_distance   120
set mw_ground_net    VSS
set mw_power_net     VDD

remove_stdcell_filler -tap -end_cap -stdcell
add_end_cap -respect_blockage -ignore_soft_blockage -lib_cell [ index_collection [ get_physical_lib_cell */$ENDCAP_LEFT  ] 0 ] -mode bottom_left
add_end_cap -respect_blockage -ignore_soft_blockage -lib_cell [ index_collection [ get_physical_lib_cell */$ENDCAP_RIGHT ] 0 ] -mode upper_right

  add_tap_cell_array \
          -master_cell_name $TAP_CELL \
          -connect_ground_name $mw_ground_net \
          -connect_power_name $mw_power_net \
          -skip_fixed_cells true \
          -distance $tap_cell_distance \
          -tap_cell_identifier ALCP_TAP \
          -pattern stagger_every_other_row \
          -ignore_soft_blockage true \
          -no_1x

save_mw_cel -as  after_tap

## insert DCAP cells 
#derive_placement_blockages -thin_channel_width 30 -apply
#set chan [ get_placement_blockage -filter "full_name=~*THIN_CHAN*" -type hard ]
source /proj/PS02/WORK/jasons/Block/GAIA/CF_1202/FP1202/thin_blkg.tcl
source /proj/PS02/WORK/jasons/Block/script/GAIA/data/create_mem_blockage.tcl
create_mem_blockage_dcap [all_macro_cells]
#source /proj/PS02/WORK/jasons/Block/script/GAIA/data/thin_blockage.tcl
set_attribute [get_placement_blockage -filter "full_name=~*THIN_CHAN*" -type hard] type soft
source /proj/PS02/WORK/jasons/Block/script/GAIA/utility/Insert_DCAP.tcl
set_attri [get_flat_cells -fil full_name=~*ALCP_TAP* -all] is_fixed true
set_attribute [get_placement_blockage -filter "full_name=~*THIN_CHAN*" -type soft] type hard
save_mw_cel -as  after_dcap
## create power memsh on tap cells 
source /proj/PS02/WORK/jasons/Block/script/GAIA/utility/create_power_strap_in_tapcell.tcl
source /proj/PS02/WORK/jasons/Block/script/GAIA/data/cut_metal3.tcl
save_mw_cel

