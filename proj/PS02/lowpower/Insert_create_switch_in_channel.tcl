#### proc:  this one is used for 1V only memory  
#template : 
# set blockage_list with the target org blockage_list  
# draw_mem_strap $blockage_list 
proc Insert_power_switch_in_channel {blockage_list} {

set sc_1_volt_area DEFAULT_VA
set sc_1_y_incr 4.0
set sc_1_array_upf_define  "PD24_sw:HEADBUF32_X2M_A8TR_C34"
set sc_1_array_prefix "PD24_sw"

# Draw M7
set M7_width 1.2
set M7_space 0.28
set M7_direction "vertical"
set M7_sc_1_net "VDD1V VDD1V_PD24 VSS"

# Draw M6
set M6_width 2
set M6_space 0.8
set M6_direction "horizontal"
set M6_pitch 40
set M6_net "VDD1V VDD1V_PD24 VSS"
set M6_mem_narrow_offset 12

#Draw M5
set M5_width 1.2
set M5_space 0.28
set M5_direction "vertical"
set M5_sc_1_net "VDD1V VDD1V_PD24 VSS"

        set_object_snap_type -enabled 1
        set_object_snap_type -type cell -snap row_tile


foreach_in_col channel [get_placement_blockage $blockage_list] {
set name [ get_attr $channel full_name ]
set channel_cor [ get_attr $channel bbox ]
set channel_x1 [expr ([lindex [lindex $channel_cor 0] 0] + [lindex [lindex $channel_cor 1] 0])/2 - $M7_width]
set channel_y1 [lindex [lindex $channel_cor 0] 1]
set channel_x2 [lindex [lindex $channel_cor 1] 0]
set channel_y2 [lindex [lindex $channel_cor 1] 1]
set channel_high [ expr $channel_y2 - $channel_y1 ]
set draw_cor "$channel_x1 $channel_y1 $channel_x2 $channel_y2"

set x1 [lindex [lindex $channel_cor 0] 0]
set x2 [lindex [lindex $channel_cor 1] 0]
set y1 [lindex [lindex $channel_cor 0] 1]
set y2 [lindex [lindex $channel_cor 1] 1]
set chan_space [expr $x2 -$x1]
set chan_height [expr $y2 - $y1]
set pitch 7.2
#set pitch [expr $chan_height / 6]
	#if { $chan_space < 4.5 } {
	 	 #continue
  		#} elseif { $chan_height < 10 } {
			#continue 
	#}
for {set i 0} { $i < $channel_high } {set i [expr {$i + $pitch}]} {
	set draw_cor "$channel_x1 [expr $channel_y1 + $i ]"
	create_cell PD24_sw_${i}_${name} HEADBUF32_X2M_A8TR_C34
	move_object PD24_sw_${i}_${name} -to $draw_cor

}
}
}
