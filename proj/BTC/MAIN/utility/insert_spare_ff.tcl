proc dump_cell_location { cells file_name } {
  write_floorplan -placement {io std_cell hard_macro} -objects $cells $file_name
}
proc dump_placement_blockage { blkg file_name } {
  write_floorplan -sm_placement_blockage -objects $blkg $file_name
}

foreach cell {SDFFRPQ_X2GS_A9PP84TR_C14 SDFFSQ_X2GS_A9PP84TR_C14} {
	set i 0
	while {$i < 200} {
		create_cell u_hce_pd/ALCP_spare_${cell}_${i} OAI22_X6F_A9PP84TL_C16
		set i [expr $i + 1]
	}
}
set_attribute [get_cells -all -hier ALCP_spare* ] is_spare_cell true
spread_spare_cells [get_cells -all -hier ALCP_spare* ] -bbox {350 1890 570 2150}
legalize_placement -incremental
dump_cell_location [get_cells -all -hier ALCP_spare* ] spare_loc.tcl
remove_cell [get_cells -all -hier ALCP_spare* ]

foreach cell {SDFFRPQ_X2GS_A9PP84TR_C14 SDFFSQ_X2GS_A9PP84TR_C14} {
	set i 0 
	while {$i < 200} {
		create_cell u_hce_pd/ALCP_spare_${cell}_${i} $cell
		set i [expr $i + 1]
	}
}
set_attribute [get_cells -all -hier ALCP_spare* ] is_spare_cell true
source -e spare_loc.tcl
#-#-  source -e /filer/home/carsonl/review_tcl/create_placement_blockage/placement_blockage.tcl
set_object_fixed_edit [get_cells -all -hier ALCP_spare* ] 1
foreach cell {SDFFRPQ_X2GS_A9PP84TR_C14 SDFFSQ_X2GS_A9PP84TR_C14} {
	set i 0 
	while {$i < 4} {
		create_cell u_pll_pd/ALCP_spare_${cell}_${i} $cell
		set i [expr $i + 1]
	}
}
set_attribute [get_cells -all -hier ALCP_spare* ] is_spare_cell true
set_object_fixed_edit [get_cells -all -hier ALCP_spare* ] 1
