#split TIE's load
#one module, one tie
proc alchip_duplicate_tie { tie} {
	#set com [open $com w]
	set all_tie_ins [get_cells * -filter "ref_name =~ *$tie*" -hier]
	set tie_num [sizeof_collection $all_tie_ins]
	set current_design [get_attribute [get_designs [current_design]] full_name]
	set i 1
	set com "a.rep"
	redirect $com {echo ""}
	foreach_in_collection each_tie_ins $all_tie_ins {
		set full_name [get_attribute $each_tie_ins full_name]
		set base_name [get_attribute $each_tie_ins base_name]
		if {[string match cpu2* $full_name] == 0} {
			continue
		}
		echo "$i ...\n"
		incr i
		echo "base_name;$base_name"
		echo "full_name;$full_name"
		redirect $com { echo "full_name;$full_name" }
		if {[string compare $full_name $base_name] != 0} {
			set module_name [chomp $full_name $base_name]
			set module_name [string trimright $module_name "/"]
			set ref_name [get_attribute [get_cells $module_name] ref_name]
		} else {
			set ref_name $current_design
		}
		echo "ref_name;$ref_name"
		if {[string length [array names tie_group $ref_name]] != 0} {
			set group $tie_group($ref_name)
		}
		lappend group "$full_name"
		echo "group;$group"
		set tie_group($ref_name) $group
		echo ""
	}
	foreach index [array names tie_group] {
		#puts $com "ref;$index"
		echo "ref;$index"
		redirect -append $com { echo "ref;$index" }
		set temp $tie_group($index)
		#puts $com "$temp"
		echo "dump;$temp"
		redirect -append $com { echo "dump;$temp" }
	}
	echo "num;$tie_num"
}

proc dump_list { lists file } {
	for {set i 0} {$i < [llength $lists]} {incr i} {
		set value [lindex $lists $i]
		#redirect -append $file { echo "value;$value"}
		puts $file "value;$value"
	}
}

proc chomp { source_str sub_str } {
	set sub_str_length [string length $sub_str]
	set source_str_length [string length $source_str]
	set first [expr $source_str_length - $sub_str_length]
	set result [string replace $source_str $first $source_str_length]
	return $result
}
