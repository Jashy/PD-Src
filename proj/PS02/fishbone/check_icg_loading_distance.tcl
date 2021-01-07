set icg_pins  [get_flat_pins */ECK]

foreach_in_collection icg_pin $icg_pins {
set icg_pin_name [get_attri [get_pins $icg_pin ] full_name]
set loadings [gl $icg_pin]
foreach_in_collection loading $loadings {
set loading_x [lindex [get_attri [get_pins $loading] center] 0]
set loading_y [lindex [get_attri [get_pins $loading] center] 1]

set driver_x [lindex [get_attri [get_pins $icg_pin] center] 0]
set driver_y [lindex [get_attri [get_pins $icg_pin] center] 1]
set loading_name [get_attri [get_pins $loading] full_name]

set x_distance [expr (abs($driver_x - $loading_x))]
set y_distance [expr (abs($driver_y - $loading_y))]
set distance [expr ($x_distance + $y_distance)]
if {$distance > 150} {
echo "$icg_pin_name $loading_name $distance" >> need_check.lis
}
}
}
