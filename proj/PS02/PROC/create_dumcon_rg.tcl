proc create_dumcon_rg { args } {
	set_object_snap_type -disable
	parse_proc_arguments -args $args results
	set corner_lib_cell_names [get_attribute [get_physical_lib_cell -filter mask_layout_type==corner_pad] name]
	foreach corner_lib_cell $corner_lib_cell_names {
		if { [regexp -- {\S+A\S*} $corner_lib_cell] == 1 } {
			set a_corner_ref $corner_lib_cell
		}
		if { [regexp -- {\S+A\S*} $corner_lib_cell] == 0 } {
			set d_corner_ref $corner_lib_cell
		}
	}
	set dcm  $results(-dcm)
	set acm  $results(-acm)
	set step $results(-step)

	set corner_cells [get_flat_cells -all -filter mask_layout_type==corner_pad]
	set corner_cell_names [get_attr [get_flat_cells -all $corner_cells] full_name]
	foreach corner_cell $corner_cell_names {
		set cell_ref_name [get_attr [get_flat_cell -all $corner_cell] ref_name]
		set corner_box [get_attr [get_flat_cells -all $corner_cell] bbox ]
		set xl [ string trim [lindex [split $corner_box] 0] \{ ]
		set yl [ string trim [lindex [split $corner_box] 1] \} ]
		set xu [ string trim [lindex [split $corner_box] 2] \{ ]
		set yu [ string trim [lindex [split $corner_box] 3] \} ]
		regsub {\.\d+$} $xl "" xl
		regsub {\.\d+$} $yl "" yl
		regsub {\.\d+$} $xu "" xu
		regsub {\.\d+$} $yu "" yu
		if { $xl == 0 && $yl == 0 && $xu != 0  && $yu != 0 } {
			if { [ string equal $cell_ref_name $a_corner_ref ] == 1 } {
				set y1 [expr $yl + $acm]
			}
			if { [ string equal $cell_ref_name $d_corner_ref ] == 1 } {
				set y1 [expr $yl + $dcm]
			}
			set x $xl
			for { set i [ expr $y1 - $step ] } {$i > 0} {incr i -$step} {
				set x [ expr $x + $step ]
				set y $i
				set cmd "create_route_guide -name route_guide_${corner_cell}_${i} -no_signal_layers {M1 M2 M3 M4 M5 M6 AP} -zero_min_spacing -no_preroute_layers {M1 M2 M3 M4 M5 M6 AP} -coordinate {{$xl $yl} {$x $y}} -no_snap "
				eval $cmd
			}
		}
		if { $xl != 0 && $yl != 0 && $xu != 0  && $yu != 0 } {
			if { [ string equal $cell_ref_name $a_corner_ref ] == 1 } {
				set x1 [expr $xu - $acm]
			}
			if { [ string equal $cell_ref_name $d_corner_ref ] == 1 } {
				set x1 [expr $xu - $dcm]
			}
			set y $yu
			for { set i [ expr $x1 + $step ] } { $i < $xu } { incr i +$step } {
				set x $i
				set y [ expr $y - $step ]
				set cmd "create_route_guide -name route_guide_${corner_cell}_${i} -no_signal_layers {M1 M2 M3 M4 M5 M6 AP} -zero_min_spacing -no_preroute_layers {M1 M2 M3 M4 M5 M6 AP} -coordinate {{$x $y} {$xu $yu}} -no_snap "
				eval $cmd
			}
		}
		if { $xl == 0 && $yl != 0 && $xu != 0  && $yu != 0 } {
			if { [ string equal $cell_ref_name $a_corner_ref ] == 1 } {
				set y1 [expr $yu - $acm]
				set x2 $acm
			}
			if { [ string equal $cell_ref_name $d_corner_ref ] == 1 } {
				set y1 [expr $yu - $dcm]
				set x2 $dcm
			}
			set x $xl
			for { set i [ expr $y1 + $step ] } { $i < $yu } { incr i +$step } {
				set x [ expr $x + $step ]
				set y $i
				set cmd "create_route_guide -name route_guide_${corner_cell}_${i} -no_signal_layers {M1 M2 M3 M4 M5 M6 AP} -zero_min_spacing -no_preroute_layers {M1 M2 M3 M4 M5 M6 AP} -coordinate {{$xl $y} {$x $yu}} -no_snap "
				eval $cmd
			}
		}
		if { $xl != 0 && $yl == 0 && $xu != 0  && $yu != 0 } {
			if { [ string equal $cell_ref_name $a_corner_ref ] == 1 } {
				set y2 $acm
				set x1 [expr $xu - $acm]
			}
			if { [ string equal $cell_ref_name $d_corner_ref ] == 1 } {
				set y2 $dcm
				set x1 [expr $xu - $dcm]
			}
			set y $yl
			for { set i [ expr $x1 + $step ] } { $i < $xu } { incr i +$step } {
				set x $i
				set y [ expr $y + $step ]
				set cmd "create_route_guide -name route_guide_${corner_cell}_${i} -no_signal_layers {M1 M2 M3 M4 M5 M6 AP} -zero_min_spacing -no_preroute_layers {M1 M2 M3 M4 M5 M6 AP} -coordinate {{$x $yl} {$xu $y}} -no_snap "
				eval $cmd
			}
		}
	}
}
define_proc_attributes create_dumcon_rg -info "create route guide on corner cell for adding dummy metal" \
  -define_args \
  { \
    	{-dcm "Specify spacing margin for digital corner cell" obj string required} \
    	{-acm "Specify spacing margin for analog corner cell" obj string required} \
	{-step "Specify step of a group of route guide" obj string required} \
  }
