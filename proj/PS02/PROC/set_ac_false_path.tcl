##--- set ports_clock_root {}
##--- foreach_in_collection a_clock [get_clocks -quiet] {
##---   set src_ports [filter_collection [get_attribute $a_clock sources] @object_class==port]
##---   set ports_clock_root  [add_to_collection $ports_clock_root $src_ports]
##--- }
##--- 
##--- set_false_path -to [all_outputs]
##--- set_false_path -from [remove_from_collection [all_inputs] $ports_clock_root]
##--- set_false_path -from [remove_from_collection [all_inputs] $ports_clock_root] -to [all_outputs]
set all_inputs [ all_inputs ]
set all_outputs [ all_outputs ]
foreach_in_collection clock [ get_clocks * -quiet ] {
	set all_inputs [ remove_from_collection $all_inputs [ get_attribute $clock sources ] ]
}
set_false_path -from $all_inputs
set_false_path -to $all_outputs
