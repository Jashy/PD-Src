proc create_rg {args} {
	proc create_rg_usage {} {
		puts "create_rg_usage: create_rg -cell <macro or macros' list> -la <blocked metal layers  M1 M2 > -size <extra size of rg>, this command is used create rg for macro cells in icc."
	}
	set arg_count 0
	if { [regexp -- {^-} [lindex $args $arg_count]] == 1 } {
		if { [regexp -- [lindex $args $arg_count] {-help}] == 1 } {
			create_rg_usage
			return
		}
		if { [regexp -- [lindex $args $arg_count] {-cell}] == 1 } {
		incr arg_count
		set data_list [lindex $args $arg_count]
		incr arg_count
		}
		if { [regexp -- [lindex $args $arg_count] {-la}] == 1 } {
		incr arg_count
		set layers [lindex $args $arg_count]
		incr arg_count
		}
		if { [regexp -- [lindex $args $arg_count] {-size}] == 1 } {
		incr arg_count
		set extra_size [lindex $args $arg_count]
		}
	} else {
		create_rg_usage
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
		set blk_x_l [expr $x_l - $extra_size]
		set blk_y_l [expr $y_l - $extra_size]
		set blk_x_u [expr $x_u + $extra_size]
		set blk_y_u [expr $y_u + $extra_size]
		
		#create placement blockage
		set cmd "create_route_guide -name route_guide_${name}_${i} -no_signal_layers {$layers} -zero_min_spacing -no_preroute_layers {$layers} -coordinate {{$blk_x_l $blk_y_l} {$blk_x_u $blk_y_u}} -no_snap "
		eval $cmd
	}
}
