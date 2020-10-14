set die_x0 [lindex [lindex [get_attribute [get_die_area ] bbox ] 0 ] 0] 
set die_y0 [lindex [lindex [get_attribute [get_die_area ] bbox ] 0 ] 1] 
set die_x1 [lindex [lindex [get_attribute [get_die_area ] bbox ] 1 ] 0] 
set die_y1 [lindex [lindex [get_attribute [get_die_area ] bbox ] 1 ] 1] 

set core_x0 [lindex [lindex [get_attribute [get_core_area ] bbox ] 0 ] 0] 
set core_y0 [lindex [lindex [get_attribute [get_core_area ] bbox ] 0 ] 1] 
set core_x1 [lindex [lindex [get_attribute [get_core_area ] bbox ] 1 ] 0] 
set core_y1 [lindex [lindex [get_attribute [get_core_area ] bbox ] 1 ] 1] 

set aaa 0.5 
set bbb 0.168
create_placement_blockage -type hard -bbox [list $die_x0 $die_y0 [expr $core_x0 + $bbb] $die_y1 ]
create_placement_blockage -type hard -bbox [list $die_x0 $die_y0 $die_x1 [expr $core_y0 + $aaa] ]
create_placement_blockage -type hard -bbox [list $die_x0 [expr $core_y1 - $aaa] $die_x1 $die_y1 ]
create_placement_blockage -type hard -bbox [list [expr $core_x1 - $bbb] $die_y0 $die_x1 $die_y1 ]

