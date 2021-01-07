source /filer/home/lukez/timing.tcl
set lvl_pins [get_pins -of [get_flat_cells * -filter "ref_name =~ O2LVLUO*"] -filter "direction == out"]

#set cells [get_flat_cells * -filter "ref_name =~ O2LVLUO*"]
#foreach_in_collection cel $cells {
	#set cel_name [get_attr [get_cells $cel] full_name]
	#set net [get_attr [get_nets -of $cel_name/ENB] full_name]
	#echo "disconnect_net $net $cel_name/ENB" >> disconnect_lvl_enb.tcl
#}

set i 0
foreach_in_collection lvl_pin $lvl_pins {
set load_cells [get_cells -of [gl $lvl_pin]]
set lvl_cell [get_attri [get_cells -of $lvl_pin] full_name]

foreach_in_collection load_cell $load_cells {
set load_cell_name [get_attri [get_cell $load_cell] full_name]
if {[get_attri [get_cell $load_cell] is_hard_macro] == true} {
set cells [get_attr [get_cells -of [get_drivers $load_cell_name/PGEN]] full_name]
echo "connect_pin -from $cells/Y -to $lvl_cell/ENB -port_name eco_20160127_${i}" >> rewire.tcl
set i [expr $i + 1]
} else {
	echo "$load_cell_name" >> 1.1
}
}
}
