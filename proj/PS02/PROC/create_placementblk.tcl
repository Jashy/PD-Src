proc create_placementblk {args} {
	proc create_placementblk_usage {} {
		puts "create_placementblk_usage: create_placementblk_usage -cell <macro or macros' list> -size <extra size of placement blockages>, this command is used create placement blockage for macro cells in icc."
	}
	set arg_count 0
	if { [regexp -- {^-} [lindex $args $arg_count]] == 1 } {
		if { [regexp -- [lindex $args $arg_count] {-help}] == 1 } {
			create_placementblk_usage
			return
		}
		if { [regexp -- [lindex $args $arg_count] {-cell}] == 1 } {
			incr arg_count
			set data_list [lindex $args $arg_count]
			incr arg_count
		}
		if { [regexp -- [lindex $args $arg_count] {-size}] == 1 } {
			incr arg_count
			set extra_size_l [lindex $args $arg_count]
			incr arg_count
			set extra_size_b [lindex $args $arg_count]
			incr arg_count
			set extra_size_r [lindex $args $arg_count]
			incr arg_count
			set extra_size_t [lindex $args $arg_count]
		}
	} else {
		create_placementblk_usage
	}
	set macros [get_flat_cell $data_list]
	set macro_names [get_attr [get_flat_cell $macros] full_name]
	set macro_count [sizeof_collection [get_flat_cell $macros]]
	for [set i 0] {$i < $macro_count} {incr i} {
		set macro [lindex $macro_names $i]
		set name [get_attr [get_flat_cell $macro] full_name]
		set box [get_attr [get_flat_cells $macro] bbox]
		set x_l [string trim [lindex [split $box " "] 0] \{ ]
		set y_l [string trim [lindex [split $box " "] 1] \} ]
		set x_u [string trim [lindex [split $box " "] 2] \{ ]
		set y_u [string trim [lindex [split $box " "] 3] \} ]
		set blk_x_l [expr $x_l - $extra_size_l]
		set blk_y_l [expr $y_l - $extra_size_b]
		set blk_x_u [expr $x_u + $extra_size_r]
		set blk_y_u [expr $y_u + $extra_size_t]
		
		#create placement blockage
		set cmd "create_placement_blockage -type hard -name placement_blockage_${name}_${i} -coordinate {{$blk_x_l $blk_y_l} {$blk_x_u $blk_y_u}}"
		eval $cmd
	}
}
