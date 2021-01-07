#### proc:  this one is used for 1V only memory  
#template : 
# set blockage_list with the target org blockage_list  
# draw_mem_strap $blockage_list 
proc Insert_power_switch_in_channel {blockage_list} {

set sc_1_volt_area DEFAULT_VA
set sc_1_y_incr 4.8
set sc_1_array_upf_define  "PD24_sw:HEADBUF16_X1M_A8TR_C34"
set sc_1_array_prefix "PD24_sw"

# Draw M7
set M7_width 1.2
set M7_space 0.28
set M7_direction "vertical"
set M7_sc_1_net "VDD VDD_PD24 VSS"

# Draw M6
set M6_width 1.2
set M6_space 0.28
set M6_direction "horizontal"
set M6_pitch 40
set M6_net "VDD VDD_PD24 VSS"
set M6_mem_narrow_offset 12

#Draw M5
set M5_width 1.2
set M5_space 0.28
set M5_direction "vertical"
set M5_sc_1_net "VDD VDD_PD24 VSS"

##### create switch cell array on sc_area1

foreach_in_col channel [get_placement_blockage $blockage_list] {
set channel_cor [ get_attr $channel bbox ]
set channel_x1 [expr ([lindex [lindex $channel_cor 0] 0] + [lindex [lindex $channel_cor 1] 0])/2 - $M7_width]
set channel_y1 [lindex [lindex $channel_cor 0] 1]
set channel_x2 [lindex [lindex $channel_cor 1] 0]
set channel_y2 [lindex [lindex $channel_cor 1] 1]
set draw_cor "$channel_x1 $channel_y1 $channel_x2 $channel_y2"

create_power_switch_array -voltage_area $sc_1_volt_area -bounding_box $draw_cor -y_increment $sc_1_y_incr -x_increment 999 -respect { macro} -lib_cell $sc_1_array_upf_define -prefix $sc_1_array_prefix
}
}
