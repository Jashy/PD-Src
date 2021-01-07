
########### spare gate ##############
 set_attribute [get_cells  -hier -filter "full_name =~ *_spare_ins*" ] is_spare_cell true
 spread_spare_cells [get_cells -hier -filter "full_name =~ *_spare_ins*"] -bbox { {197.100 197.100} {5014.800 10237.860} }

set cell_fix [get_cells -hier -filter "is_fixed == true && mask_layout_type == std"]
set cell_nofix [get_cells -hier -filter "is_fixed == false && mask_layout_type == std"]

set_attr $cell_nofix is_fixed true

set spare_cell [ get_cells *_spare_ins* -hierarchical ]

set_attr $spare_cell is_fixed false


#legalize_placement -incremental

############ tie cell #####################
source /proj/Garnet/WORK/danielw/ICC/spare_gate/insert_tie.tcl
insert_tie_cell
set_tlu_plus_files -max_tluplus $TLUP_MAX -tech2itf_map $TLUP_MAP
set_preferred_routing_direction -layers ALRDL -direction horizontal

legalize_placement -eco

derive_pg_connection -power_net  VDD -ground_net VSS


########### unfix cells ###############
set_attr $cell_nofix is_fixed false
#save

