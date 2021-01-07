###################################################################

# Created by write_floorplan on Thu Nov 10 11:07:15 2011

###################################################################
undo_config -disable

remove_die_area 

create_die_area  \
	-poly {	{0.000 0.000} {350.000 0.000} {350.000 3000.000} {0.000 3000.000} {0.000 0.000}} 
set oldSnapState [set_object_snap_type -enabled false]

#**************
#  std cell  
# obj#: 2 
# objects are in alphabetical ordering 
#**************


set obj [get_cells {"u_pcie_ocp_pipe_pipe_axi_axi_reg_cap_subsysid_r_reg_15_"} -all]
set_attribute -quiet $obj orientation N
set_attribute -quiet $obj origin {175.140 1025.220}
set_attribute -quiet $obj is_placed true
set_attribute -quiet $obj is_fixed false
set_attribute -quiet $obj is_soft_fixed false
set_attribute -quiet $obj eco_status eco_reset

set obj [get_cells {"u_pcie_ocp_pipe_pipe_axi_axi_reg_cap_vendevid_r_reg_15_"} -all]
set_attribute -quiet $obj orientation N
set_attribute -quiet $obj origin {162.820 1021.860}
set_attribute -quiet $obj is_placed true
set_attribute -quiet $obj is_fixed false
set_attribute -quiet $obj is_soft_fixed false
set_attribute -quiet $obj eco_status eco_reset

set_object_snap_type -enabled $oldSnapState
undo_config -enable
