insert_boundary_cell \
	-top_boundary_cells {TBCAPNWOUTTIE16_A9PP84TL_C14 TBCAPNWOUT3_A9PP84TL_C14 TBCAPNWOUT2_A9PP84TL_C14 } \
        -bottom_boundary_cells {TBCAPNWINTIE16_A9PP84TL_C14 TBCAPNWIN3_A9PP84TL_C14 TBCAPNWIN2_A9PP84TL_C14} \
        -left_boundary_cell {ENDCAPTIE12_A9PP84TL_C14} \
        -right_boundary_cell {ENDCAPTIE12_A9PP84TL_C14} \
        -top_right_outside_corner_cell {CNRCAPNWOUTTIE12_A9PP84TL_C14} \
	-top_left_outside_corner_cell {CNRCAPNWOUTTIE12_A9PP84TL_C14} \
	-bottom_right_outside_corner_cell {CNRCAPNWINTIE12_A9PP84TL_C14} \
	-bottom_left_outside_corner_cell {CNRCAPNWINTIE12_A9PP84TL_C14} \
	-top_right_inside_corner_cells {INCNRCAPNWOUTTIE12_A9PP84TL_C14} \
	-top_left_inside_corner_cells {INCNRCAPNWOUTTIE12_A9PP84TL_C14} \
	-bottom_right_inside_corner_cells {INCNRCAPNWINTIE12_A9PP84TL_C14} \
	-bottom_left_inside_corner_cells {INCNRCAPNWINTIE12_A9PP84TL_C14} \
	-rules {respect_hard_blockage respect_hard_macro_keepout mirror_right_boundary_cell mirror_right_outside_corner_cell mirror_right_inside_corner_cell swap_top_bottom_inside_corner_cell}

foreach_in_collection cell [get_flat_cells -all -filter "ref_name == INCNRCAPNWINTIE12_A9PP84TL_C14 || ref_name == INCNRCAPNWOUTTIE12_A9PP84TL_C14"] {
	flip_objects -x 0 -anchor center -flip_transform $cell -ignore_fixed
}
add_tap_cell_array -master_cell_name FILLTIE11_A9PP84TL_C14 -pattern stagger_every_other_row -distance 98 -ignore_soft_blockage true -connect_ground_name VSS -connect_power_name VDD -skip_fixed_cells true -remove_redundant_tap_cells


#-#-  add_tap_cell_array -master_cell_name FILLSGCAP128_A9PP84TL_C14 -pattern stagger_every_other_row -distance 235 -ignore_soft_blockage true -connect_ground_name VSS -connect_power_name VDD -skip_fixed_cells true -remove_redundant_tap_cells
#-#-  set i 0 
#-#-  foreach_in_collection cell [get_flat_cells -all *FILLSGCAP128* -filter "ref_name == FILLSGCAP128_A9PP84TL_C14" ] {
	#-#-  set_name -type cell $cell -name ALCP_Preplace_Decap_FILLSGCAP128_A9PP84TL_C14_$i
	#-#-  set i [expr $i + 1]
#-#-  }

#-#-  derive_pg_connection -power_net VDD -power_pin VDD -ground_net VSS -ground_pin VSS
