set always_on_cells [get_flat_cell abdcdsedfg -quiet]
set 1v_cells [get_flat_cell absdsdfdssd -quiet]

set always_on_blockages [remove_from_collection [get_placement_blockage *jasons*] [get_placement_blockage *jasons*DUMMY_BUFFER*]]

foreach_in_collection always_on_blockage $always_on_blockages  {
set bbox [get_attr  $always_on_blockage bbox]
set lx [lindex [lindex $bbox 0] 0]
set ly [lindex [lindex $bbox 0] 1]
set rx [lindex [lindex $bbox 1] 0]
set ry [lindex [lindex $bbox 1] 1]

set lx_new [expr ($lx - 0.1)]
set ly_new [expr ($ly - 0.1)]
set rx_new [expr ($rx + 0.1)]
set ry_new [expr ($ry + 0.1)]


set always_on_cells [add_to_collection $always_on_cells [get_cells -within "{$lx_new $ly_new} {$rx_new $ry_new}" -all]]

}
derive_pg_connection -power_net VDD -power_pin VDD -reconnect -cells [get_cells $always_on_cells -all ] -verbose




set 1v_blockages [get_placement_blockage *jasons*DUMMY_BUFFER*]
foreach_in_collection 1v_blockage $1v_blockages  {
	set bbox [get_attr  $1v_blockage bbox]
	set lx [lindex [lindex $bbox 0] 0]
	set ly [lindex [lindex $bbox 0] 1]
	set rx [lindex [lindex $bbox 1] 0]
	set ry [lindex [lindex $bbox 1] 1]

	set lx_new [expr ($lx - 0.1)]
	set ly_new [expr ($ly - 0.1)]
	set rx_new [expr ($rx + 0.1)]
	set ry_new [expr ($ry + 0.1)]


	set 1v_cells [add_to_collection $1v_cells [get_cells -within "{$lx_new $ly_new} {$rx_new $ry_new}" -all]]

}
derive_pg_connection -power_net VDD1V_MEM -power_pin VDD -reconnect -cells [get_cells $1v_cells -all] -verbose





