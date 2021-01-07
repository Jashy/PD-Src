proc DUP_DRV {cell_instance cell_type count} {
	set DB_DRV [get_cell $cell_instance ]
	set DB_DRV_name [get_attribute $DB_DRV full_name]
	set FB_DRV_REF  [get_model $cell_type]
	set cell_input_net [get_nets -of [get_pins -of [get_cells $cell_instance] -filter "direction == in"]] 
	set cell_output_net [get_nets -of [get_pins -of [get_cells $cell_instance] -filter "direction == out"]] 
	set DB_DRV_PINS [get_pins -of_objects $cell_input_net -leaf -filter "direction ==out"]
	set loc_array 	[list]
	set ori_array 	[list]
	set ECO_PATTERN PAR_I_
	#foreach_in_collection DB_DRV_PIN $DB_DRV_PINS {
	#	set DB_DRV [get_cells -of_objects $DB_DRV_PIN] 
	#	set  DB_DRV_NAME [get_attribute $DB_DRV full_name]
	#	if { ![regexp {(\S+_FB_L3_DRIVE)} $DB_DRV_NAME "" ECO_PATTERN ] } { 
	#		puts "$DB_DRV_NAME is not match with _FB_L3_DRIVE"
	#		Error
	#		continue
	#	}
		lappend loc_array [get_attribute $DB_DRV origin]
		lappend ori_array [get_attribute $DB_DRV orientation]
	#}
	# check FB buffer locaiton and orientation
	if {[llength [ lsort -unique $ori_array ] ] > 1} {
		puts "Error: FB driver orientation is not uniquefied !!"
		Error
	}
	foreach loc $loc_array {
		lappend x_array [lindex $loc 0]
		lappend y_array [lindex $loc 1]
	}
	set y_array [lsort -real $y_array]
	if {[llength [ lsort -unique $x_array ] ] > 1} {
		puts "Error: FB driver buffers are not placed align !!"
		Error
	}
	set x 		[lindex $x_array 0]
	set y_max 	[lindex $y_array end]
	set y_min 	[lindex $y_array 0]
	#
	set eco_ori [lindex $ori_array 0]
	set pre_net $cell_input_net
	set org_num [sizeof_collection $DB_DRV_PINS ]
	set eco_cell_list [list]
	for {set eco_num 1} {$eco_num <=  $count } {incr eco_num} {
		set step [expr [expr $eco_num + [expr $eco_num % 2] ] / 2]
		if {[expr $eco_num % 2]} {
			set y [expr $y_min - [expr $step * 3.6] ]
		} else {
			set y [expr $y_max + [expr $step * 3.6] ]
		}
		set eco_count [expr $eco_num + $org_num]
		if {${eco_count} > 9} {
			set eco_cell_name  ${DB_DRV_name}_${ECO_PATTERN}${eco_count}
		} else {
			set eco_cell_name  ${DB_DRV_name}_${ECO_PATTERN}0${eco_count}
		}
		create_cell ${eco_cell_name} $FB_DRV_REF
		connect_net $cell_input_net ${eco_cell_name}/I
		connect_net $cell_output_net ${eco_cell_name}/Z
		lappend eco_cell_list $eco_cell_name
		set_attribute [get_cells $eco_cell_name] orientation $eco_ori
		set_attribute [get_cells $eco_cell_name] origin [list $x $y]
		set_attribute [get_cells $eco_cell_name] is_fixed true
		#puts "$eco_cell_name $x $y" 
	}
	puts "Info: Total $count cells added !!\r"
	return $eco_cell_list
}
