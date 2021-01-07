echo "Checking tiehl fanout..."
set all_tiehi [get_cells * -hier -filter "is_hierarchical == false && ref_name =~ TIEH*"]
set all_tielo [get_cells * -hier -filter "is_hierarchical == false && ref_name =~ TIEL*"]
set flag 0
foreach_in_collection tiehi $all_tiehi {
	set tiehi_name [get_attribute $tiehi full_name]
	set tiehi_fanout_number [sizeof_collection [filter_collection [all_fanout -flat -levels 1 -from ${tiehi_name}/Z] "( object_class == pin && direction == in )"]]
	if { ${tiehi_fanout_number} > 10 } {
		echo "${tiehi_name}/Z fanout is " ${tiehi_fanout_number}
		incr flag
	}
}
foreach_in_collection tielo $all_tielo {
        set tielo_name [get_attribute $tielo full_name]
        set tielo_fanout_number [sizeof_collection [filter_collection [all_fanout -flat -levels 1 -from ${tielo_name}/ZN] "( object_class == pin && direction == in )"]]
        if { ${tielo_fanout_number} > 10 } {
		echo "${tielo_name}/ZN fanout is " ${tielo_fanout_number}
		incr flag
        }
}
if {$flag == 0} {
	echo "all tie cells' fanouts are less than 10."
}

