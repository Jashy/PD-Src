proc trace_clk { clk_net report } {
	set report [open $report w]
	set ini_cells [all_fanout -from $clk_net -flat -only_cells]
	set stack { }
	puts $report "$clk_net (start)"
	foreach_in_collection each_ini $ini_cells {
		set name [get_attribute $each_ini full_name]
		push stack $name
		set ref [get_attribute [get_cells $each_ini] ref_name]
		puts $report "$name:$ref"
	}
	puts $report ""
	while { [llength $stack] > 0 } {
		set driver [pop stack]
		#echo "driver;$driver"
		set ref [get_attribute [get_cells $driver] ref_name]
		puts $report "$driver ($ref)"
		if { [is_stop $driver] == 0 } {
			#echo "driver; $ref $driver"
			#return
			set load [get_loads $driver]
			#echo "load; $load"
			foreach each_load $load {
				#echo "each_load;$each_load"
				set ref [get_attribute [get_cells $each_load] ref_name]
				puts $report "$each_load:$ref"
				push $stack $each_load
			}
		}
		puts $report ""
		#break
	}
	close $report
}

proc get_loads { driver } {
	#echo "get_load;driver;$driver"
	set load {}
        set out_pins [get_pins $driver/* -filter "pin_direction == out"]
        foreach_in_collection each_out $out_pins {
		set out_name [get_attribute $each_out full_name]
                set load_ins [all_fanout -from $out_name -only_cells -flat]
		foreach_in_collection each_load $load_ins {
			lappend load [get_attribute $each_load full_name]
		}
        }
	#echo "get_load;$load"
        return $load
}

proc push { stack value } {
	#echo "push;$value"
        upvar $stack list
        lappend list $value
}

proc pop { stack } {
        upvar $stack list
        set value [lindex $list end]
	#echo "pop;$value"
        set list [lrange $list 0 [expr [llength $list] -2]]
        return $value
}

proc shift { stack } {
	upvar $stack list
	set value [lindex $list 0]
	set list [lrange $list 1 [expr [llength $list] -1]]
	return $value
}

proc is_stop { cell } {
	global STOP
	set ref [get_attribute [get_cells $cell] ref_name]
	#echo "ref; $ref $cell"
	foreach stop $STOP {
		if { [string match $stop $ref] } {
			#echo "$stop $ref;1"
			return 1
		}
	}
	#echo "$ref;0"
	return 0
}
