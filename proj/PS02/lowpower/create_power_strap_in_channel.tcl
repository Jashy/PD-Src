#### proc:  this one is used for 1V only memory  
#template : 
# set blockage_list with the target org blockage_list  
# draw_mem_strap $blockage_list 
proc create_power_strap_in_channel {blockage_list} {

#set sc_1_volt_area DEFAULT_VA
#set sc_1_y_incr 4
#set sc_1_array_prefix "PD24_sw"

# Draw M7
set M7_width 1.2
set M7_space 0.28
set M7_direction "vertical"
set M7_sc_1_net "VDD VSS"

# Draw M6
set M6_width 1.2
set M6_space 0.8
set M6_direction "horizontal"
set M6_pitch 40
set M6_net "VDD_PD24 VDD VSS"
set M6_mem_narrow_offset 12

#Draw M5
set M5_width 1.02
set M5_space 0.28
set M5_direction "vertical"
set M5_sc_1_net "VDD1V_MEM VDD VDD_PD24 VSS"


# draw M7 sc_1/2_area
foreach_in_col channel [get_placement_blockage $blockage_list] {
        set channel_cor [ get_attr $channel bbox ]
	#set channel_x1 [expr ([lindex [lindex $channel_cor 0] 0] + [lindex [lindex $channel_cor 1] 0])/2 ]
	set channel_x1 [lindex [lindex $channel_cor 0] 0]
        set channel_y1 [lindex [lindex $channel_cor 0] 1]
        set channel_x2 [lindex [lindex $channel_cor 1] 0]
        set channel_y2 [lindex [lindex $channel_cor 1] 1]
        set bbox_1 "{[lindex [lindex $channel_cor 0] 0] [ expr $channel_y2 - 30 ]}" 
	set bbox_2 "{$channel_x2 $channel_y2}"
	set bbox "$bbox_1 $bbox_2"
	set width [expr $channel_x2 - $channel_x1]
	if { $width > 5 } {
	set_preroute_drc_strategy -min_layer M7 -max_layer M7
	
        create_power_straps  -direction $M7_direction -start_at [expr $channel_x1  + 3.0] -step 999 -num_groups 1  -pitch_within_group [expr $M7_width + $M7_space]\
                       -nets  $M7_sc_1_net  -layer M7 -width $M7_width -configure groups_and_step \
                       -keep_floating_wire_pieces  -ignore_parallel_targets  \
                       -extend_low_ends off \
                       -extend_high_ends off \
                       -start_low_ends coordinate -start_low_ends_coordinate $channel_y1 -start_high_ends coordinate -start_high_ends_coordinate [ expr $channel_y2 ]

	#set_preroute_drc_strategy -min_layer M5 -max_layer M5
#
        #create_power_straps  -direction $M5_direction -start_at [expr $channel_x1 + 3.0] -step 999 -num_groups 1  -pitch_within_group [expr $M5_width + $M5_space]\
                       #-nets  $M5_sc_1_net  -layer M5 -width $M5_width -configure groups_and_step \
                       #-keep_floating_wire_pieces  -ignore_parallel_targets  \
                       #-extend_low_ends off \
                       #-extend_high_ends off \
                       #-start_low_ends coordinate -start_low_ends_coordinate $channel_y1 -start_high_ends coordinate -start_high_ends_coordinate [ expr $channel_y2 ]

} else { 
	continue
}
}
# draw M7&M5 PB area
# draw M6
foreach_in_col channel [get_placement_blockage $blockage_list] {
        set channel_cor [ get_attr $channel bbox ]
        set channel_x1 [lindex [lindex $channel_cor 0] 0]
        set channel_y1 [lindex [lindex $channel_cor 0] 1]
        set channel_x2 [lindex [lindex $channel_cor 1] 0]
        set channel_y2 [lindex [lindex $channel_cor 1] 1]

	set_preroute_drc_strategy -min_layer M6 -max_layer M6
	
        create_power_straps  -direction $M6_direction -start_at [expr $channel_y1 + 1.2] -step $M6_pitch -stop [expr $channel_y2] -pitch_within_group [expr $M6_width + $M6_space]\
                       -nets  $M6_net  -layer M6 -width $M6_width -configure step_and_stop \
                       -keep_floating_wire_pieces  -ignore_parallel_targets  \
                       -extend_low_ends off \
                       -extend_high_ends off \
                       -start_low_ends coordinate -start_low_ends_coordinate $channel_x1 -start_high_ends coordinate -start_high_ends_coordinate $channel_x2


}



}
