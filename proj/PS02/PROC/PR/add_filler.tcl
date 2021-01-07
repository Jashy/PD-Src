############ decoupling cell #############
set cap_filler_cell [ list FDCAP32 FDCAP16 FDCAP8 FDCAP4 ]
insert_stdcell_filler -cell_with_metal  $cap_filler_cell \
  -dont_respect_soft_placement_blockage \
 -connect_to_power VDD -connect_to_ground VSS
#########################################

########## add filler ###################
insert_stdcell_filler -cell_without_metal { F_FILL16 F_FILL8 F_FILL4 F_FILL2 F_FILL1 }   -dont_respect_soft_placement_blockage
################### conect p/g ##########
