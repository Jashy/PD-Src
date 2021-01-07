################################################################################
# PRE HEAD
set x -30
array unset cell_y
#-#-  echo "" > check.info
set i 1
set all_heads ""
while {$x < 4370 } {
	set switch_cells [filter_collection [get_cells -within [list $x 0 [expr $x+60 ] 2950 ] ] "ref_name == HEADBUF16_X1M_A8TR_C34&& full_name =~ *PRE*" ]
	foreach_in_collection switch_cell $switch_cells {
		set y_location [lindex [get_attri [get_cells $switch_cell] origin] 1]
		set switch_cell_name [get_attri [get_cell $switch_cell] full_name]
		set cell_y($y_location) $switch_cell_name
	}
	if {[expr $i%2]} { set order -increasing } else {set order -decreasing }
	foreach yyy [lsort $order -real [array name cell_y] ] {
		#-#-  echo "$cell_y($yyy) : $yyy : $order :$i" >> check.info 
		set all_heads "$all_heads $cell_y($yyy)"
	}
	#-#-  echo "check arckeonw" >> check.info
	incr i
	set x [expr $x + 60 ]
	array unset cell_y
}
set total_number [llength $all_heads]
set n 0 
while {$n < [expr $total_number - 1 ] } {
	set head_1 [lindex $all_heads $n]
	set head_2 [lindex $all_heads [expr $n + 1] ] 
	create_net pre_head_connection_net_$n 
	connect_net pre_head_connection_net_$n $head_1/SLEEPOUT 
	connect_net pre_head_connection_net_$n $head_2/SLEEP 
	incr n 
}

################################################################################
# ALL HEAD
set x -30
array unset cell_y
#-#-  echo "" > check.info
set i 1
set all_heads ""
while {$x < 4370 } {
	set switch_cells [filter_collection [get_cells -within [list $x 0 [expr $x+60 ] 2950 ] ] "ref_name == HEADBUF16_X1M_A8TR_C34&& full_name =~ *ALL*" ]
	foreach_in_collection switch_cell $switch_cells {
		set y_location [lindex [get_attri [get_cells $switch_cell] origin] 1]
		set switch_cell_name [get_attri [get_cell $switch_cell] full_name]
		set cell_y($y_location) $switch_cell_name
	}
	if {[expr $i%2]} { set order -increasing } else {set order -decreasing }
	foreach yyy [lsort $order -real [array name cell_y] ] {
		#-#-  echo "$cell_y($yyy) : $yyy : $order :$i" >> check.info 
		set all_heads "$all_heads $cell_y($yyy)"
	}
	#-#-  echo "check arckeonw" >> check.info
	incr i
	set x [expr $x + 60 ]
	array unset cell_y
}
set total_number [llength $all_heads]
set n 0 
while {$n < [expr $total_number - 1 ] } {
	set head_1 [lindex $all_heads $n]
	set head_2 [lindex $all_heads [expr $n + 1] ] 
	create_net all_head_connection_net_$n 
	connect_net all_head_connection_net_$n $head_1/SLEEPOUT 
	connect_net all_head_connection_net_$n $head_2/SLEEP 
	incr n 
}

