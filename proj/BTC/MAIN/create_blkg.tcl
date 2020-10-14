#set extra 6
set margin 1
foreach macro_coordinate  [get_attribute [all_macro_cells] bbox ] {
set point_0 [lindex $macro_coordinate 0]
set point_0_x [lindex $point_0 0]
set point_0_y [lindex $point_0 1]

set point_1 [lindex $macro_coordinate 1]
set point_1_x [lindex $point_1 0]
set point_1_y [lindex $point_1 1]

set point_0_x [expr $point_0_x - $margin]
set point_0_y [expr $point_0_y - $margin]
set point_1_x [expr $point_1_x + $margin]
set point_1_y [expr $point_1_y + $margin]

set macro_coordinate [lreplace $macro_coordinate 0 1 $point_0_x $point_0_y $point_1_x $point_1_y]

create_placement_blockage -bbox $macro_coordinate -type hard

}
