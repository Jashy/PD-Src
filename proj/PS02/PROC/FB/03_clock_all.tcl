##################################################
#scripts about fb
#write by carson
#2012/02/28
##############################################3##


set clk_names { pclk }

#fb nets
#write_route -nets $clk_names -skip_route_guide -output ./fb_nets.tcl
#fb drivers and L2 L3
foreach clk_name $clk_names {
set L1_net_name [get_flat_nets -of [get_flat_pins -of [get_cells -of [get_pins -leaf -of [get_nets $clk_name] -filter "direction=~in"]] -filter "direction=~out"]]
#set L1_via_name [get_vias -of $L1_net_name]
set pclk [get_flat_nets -of [get_flat_pins -of [get_cells -of [get_pins -leaf -of [get_nets $L1_net_name] -filter "direction=~out"]] -filter "direction=~in"]]
#set pclk_via_name [get_vias -of $pclk]
set L2_net_name [get_flat_nets -of [get_flat_pins -of [get_cells -of [get_pins -leaf -of [get_nets $L1_net_name] -filter "direction=~in"]] -filter "direction=~out"]]
#set L2_via_name [get_vias -of $L2_net_name]
set L3_net_name [get_flat_nets -of [get_flat_pins -of [get_cells -of [get_pins -leaf -of [get_nets $L2_net_name] -filter "direction=~in"]] -filter "direction=~out"]]
#set L3_via_name [get_vias -of $L3_net_name]

set drivers [get_flat_cells -of $L1_net_name]
set drivers [add_to_collection $drivers [get_flat_cells -of $L2_net_name]]
set clk_name_flat [get_att $clk_name name]
write_route -nets $pclk -skip_route_guide -output fb_nets_${clk_name_flat}.tcl
#write_route -objects $pclk_via_name -skip_route_guide -output fb_vias_${clk_name_flat}.tcl
write_route -nets $L1_net_name -skip_route_guide -output fb_nets_${clk_name_flat}_L1.tcl
#write_route -objects $L1_via_name -skip_route_guide -output fb_vias_${clk_name_flat}_L1.tcl
write_route -nets $L2_net_name -skip_route_guide -output fb_nets_${clk_name_flat}_L2.tcl
#write_route -objects $L2_via_name -skip_route_guide -output fb_vias_${clk_name_flat}_L2.tcl
write_route -nets $L3_net_name -skip_route_guide -output fb_nets_${clk_name_flat}_L3.tcl
#write_route -objects $L3_via_name -skip_route_guide -output fb_vias_${clk_name_flat}_L3.tcl
write_floorplan -object $drivers -placement { std_cell } -no_placement_blockage -no_bound -no_plan_group -no_voltage_area -no_route_guide -no_create_boundary fb_${clk_name_flat}_drivers.tcl
}
set clk_names { i_clk }

#fb nets
#write_route -nets $clk_names -skip_route_guide -output ./fb_nets.tcl
#fb drivers and L2 L3
foreach clk_name $clk_names {
set L1_net_name [get_flat_nets -of [get_flat_pins -of [get_cells -of [get_pins -leaf -of [get_nets $clk_name] -filter "direction=~in"]] -filter "direction=~out"]]
#set L1_via_name [get_vias -of $L1_net_name]
set i_clk [get_flat_nets -of [get_flat_pins -of [get_cells -of [get_pins -leaf -of [get_nets $L1_net_name] -filter "direction=~out"]] -filter "direction=~in"]]
#set i_clk_via_name [get_vias -of $i_clk]
set L2_net_name [get_flat_nets -of [get_flat_pins -of [get_cells -of [get_pins -leaf -of [get_nets $L1_net_name] -filter "direction=~in"]] -filter "direction=~out"]]
#set L2_via_name [get_vias -of $L2_net_name]
set L3_net_name [get_flat_nets -of [get_flat_pins -of [get_cells -of [get_pins -leaf -of [get_nets $L2_net_name] -filter "direction=~in"]] -filter "direction=~out"]]
#set L3_via_name [get_vias -of $L3_net_name]

set drivers [get_flat_cells -of $L1_net_name]
set drivers [add_to_collection $drivers [get_flat_cells -of $L2_net_name]]
set clk_name_flat [get_att $clk_name name]
write_route -nets $i_clk -skip_route_guide -output fb_nets_${clk_name_flat}.tcl
#write_route -objects $i_clk_via_name -skip_route_guide -output fb_vias_${clk_name_flat}.tcl
write_route -nets $L1_net_name -skip_route_guide -output fb_nets_${clk_name_flat}_L1.tcl
#write_route -objects $L1_via_name -skip_route_guide -output fb_vias_${clk_name_flat}_L1.tcl
write_route -nets $L2_net_name -skip_route_guide -output fb_nets_${clk_name_flat}_L2.tcl
#write_route -objects $L2_via_name -skip_route_guide -output fb_vias_${clk_name_flat}_L2.tcl
write_route -nets $L3_net_name -skip_route_guide -output fb_nets_${clk_name_flat}_L3.tcl
#write_route -objects $L3_via_name -skip_route_guide -output fb_vias_${clk_name_flat}_L3.tcl
write_floorplan -object $drivers -placement { std_cell } -no_placement_blockage -no_bound -no_plan_group -no_voltage_area -no_route_guide -no_create_boundary fb_${clk_name_flat}_drivers.tcl
}
#fb blockage
#write_floorplan -objects  {*fb*}  -no_bound -no_plan_group -no_voltage_area -no_route_guide -no_create_boundary fb_blockages.tcl
##########################load fb##########################################
#set clk_names {  }
##blockage
#remove_placement_blockage *fb*
#source fb_blockages.tcl
##drivers
#foreach clk_name $clk_names {
#set clk_name_flat [get_att $clk_name name]
#source ./fb_${clk_name_flat}_drivers.tcl
#}
##nets 
#source ./fb_nets.tcl
#foreach clk_name $clk_names {
#set clk_name_flat [get_att $clk_name name]
#source fb_nets_${clk_name_flat}_L3.tcl
#source fb_nets_${clk_name_flat}_L2.tcl
#}
