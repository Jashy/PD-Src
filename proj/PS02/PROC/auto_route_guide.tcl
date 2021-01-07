proc auto_route_guide {args} {
proc auto_route_guide_usage {} {
		puts "auto_route_guide_usage:auto_route_guide  -width <core to die> -high <core to die > -layers <layers>"
	}

set arg_count 0
if { [regexp -- {^-} [lindex $args $arg_count]] == 1 } {
	if { [regexp -- [lindex $args $arg_count] {-help}] == 1 } {
		auto_route_guide_usage
		return
		}
	if { [regexp -- [lindex $args $arg_count] {-width}] == 1 } {
		incr arg_count
		#set data_list [lindex $args $arg_count]
		set width [lindex $args $arg_count]
		incr arg_count
		}
	if { [regexp -- [lindex $args $arg_count] {-high}] == 1 } {
		incr arg_count
		#set layers [lindex $args $arg_count]
		set high [lindex $args $arg_count]
		incr arg_count
		}
	if { [regexp -- [lindex $args $arg_count] {-layers}] == 1 } {
		incr arg_count
		#set extra_size [lindex $args $arg_count]
		set layers [lindex $args $arg_count]
		}
	} else {
		auto_route_guide_usage
}


undo_config -disable
set oldSnapState [set_object_snap_type -enabled false]

set die_area_b [get_attribute [get_die_area] bbox]

     set x1 [lindex $die_area_b 0 0]
     set y1 [lindex $die_area_b 0 1]
     set x2 [lindex $die_area_b 1 0]
     set y2 [lindex $die_area_b 1 1]

set coord_0 "create_route_guide  \
	-coordinate {$x1 $y1 [expr $x1 + $width] $y2}  \
	-zero_min_spacing  \
	-no_signal_layers {$layers} \
	-no_preroute_layers {$layers} \
	-name route_guide_0 \
	-no_snap"
eval $coord_0
set coord_1 "create_route_guide  \
	-coordinate {{$x1 $y1} {$x2 [expr $y1 + $high]}}  \
	-zero_min_spacing  \
	-no_signal_layers {$layers} \
	-no_preroute_layers {$layers} \
	-name route_guide_1 \
	-no_snap"
eval $coord_1

set coord_2 "create_route_guide  \
	-coordinate {{[expr $x2 - $width] $y1} {$x2 $y2}}  \
	-zero_min_spacing  \
	-no_signal_layers {$layers} \
	-no_preroute_layers {$layers} \
	-name route_guide_2 \
	-no_snap"
eval $coord_2


set coord_3 "create_route_guide  \
	-coordinate {{$x1 [expr $y2 - $high]} {$x2 $y2}}  \
	-zero_min_spacing  \
	-no_signal_layers {$layers} \
	-no_preroute_layers {$layers} \
	-name route_guide_3 \
	-no_snap"
eval $coord_3

set_object_snap_type -enabled $oldSnapState
undo_config -enable

}
