
### open/close

alias opl "open_lib"
alias opc "open_block"
alias clc "close_block"
alias cll "close_lib -force"

### get ###

proc gs { } {get_selection}

proc gmem { } {
        set name [get_attr [get_flat_cells -fil "is_hard_macro == true"] full_name]
        return $name
}

proc gport { } {
        set name [get_object_name [get_ports * -fil "full_name !~ *VDD* && full_name !~ *VSS*"]]
        return $name
}

proc sc { cell_name } {
	change_selection [get_flat_cells -all ${cell_name}]
	gui_zoom -exact -selection -window [gui_get_current_window -types "Layout" -mru]
}

proc sn { net_name } {
	change_selection [get_nets $net_name -all]
	gui_zoom -exact -selection -window [gui_get_current_window -types "Layout" -mru]
}

proc sp { pin_name } {
	change_selection [get_pins $pin_name -all]
	gui_zoom -exact -selection -window [gui_get_current_window -types "Layout" -mru]
}

proc csp {port} {
	set full_name [get_attr [get_ports $port] full_name]
	change_selection [get_ports $full_name]
	puts "$full_name"
	gui_zoom -exact -selection -window [gui_get_current_window -types "Layout" -mru]
}

alias csm "sc \[gmem\]"

### highlight ###

proc hcell {name } {
	gui_change_highlight -remove -all_colors
	change_selection [get_flat_cells -all -filter "full_name =~ $name*"]
	set num [sizeof_collection [get_selection]]
	hilight_collection  red [get_selection ]
	gui_zoom -selection -exact -window [gui_get_current_window -types "Layout" -mru ]
	echo "the number of hilight cell are $num."
}

proc hcell_ref {name } {
	gui_change_highlight -remove -all_colors
	change_selection [get_flat_cells -all -filter "ref_name =~ $name*"]
	set num [sizeof_collection [get_selection]]
	hilight_collection  red [get_selection ]
	gui_zoom -selection -exact -window [gui_get_current_window -types "Layout" -mru ]
	echo "the number of hilight cell are $num."
}

proc h_collection {collection } {
	gui_change_highlight -remove -all_colors
	change_selection $collection
	hilight_collection red [get_selection]
	gui_zoom -selection -exact -window [gui_get_current_window -types "Layout" -mru]
}

proc hclk_net {} {
	gui_change_highlight -remove -all_colors
	change_selection [get_net_shapes -filter {route_type =="Clk Strap" && net_type == "Clock"}]
	hilight_collection red [get_selection]
	gui_zoom -selection -exact -window [gui_get_current_window -types "Layout" -mru]
}

proc gpn {pin_name} {
        set temp [llength [get_nets -q $pin_name]]
        if {$temp != 0} {
                set net $pin_name
        } else {
                set net [get_flat_nets -of_objects [get_pins $pin_name]]
        }
	    gui_change_highlight -remove -color light_red
	    gui_change_highlight -remove -color light_blue
	    gui_change_highlight -remove -color yellow
	    set driver_list [get_attr [get_flat_pins -of_objects [get_nets [get_nets $net] -top -seg] -filter "direction == out"] full_name]
	    set load_list [get_attr [get_flat_pins -of_objects [get_nets [get_nets $net] -top -seg] -filter "direction == in"] full_name]
	    set driver_cell [get_flat_cells -of_objects [get_flat_pins -of_objects [get_nets [get_nets $net] -top -seg] -filter "direction == out"]]
	    set load_cell  [get_flat_cells -of_objects [get_flat_pins -of_objects [get_nets [get_nets $net] -top -seg] -filter "direction == in"]]
	    set drivers [get_attr [get_flat_pins $driver_list] full_name]
	    set driver_ref [get_attr [get_flat_cells -of [get_flat_pins $driver_list]] ref_name]
	    set driver_con [llength $driver_list]
	    set load_con [llength $load_list]
	    puts "===> the driver is :"
	    puts "driver_num is $driver_con"
	    puts "driver (pin) : $drivers  --> $driver_ref"
	    #puts "driver (net) : [get_object_name [get_nets $net]]"

	    puts "===> the loads are :"
	    foreach load $load_list {
	    	set load_pin [get_attr [get_flat_pins $load] full_name]
		set load_cell [get_attr [get_flat_cells -of $load_pin] full_name]
	    	set load_ref [get_attr [get_flat_cells -of [get_pins $load_pin]] ref_name]
		set load_dis [iCD $driver_cell $load_cell]
	    	puts "load (pin) : $load_pin  --> $load_ref --> $load_dis"
	    }
	    puts "loads_num are $load_con"
	    gui_change_highlight   -collection [get_nets [get_net $net] -top -seg] -color yellow
	    if {$driver_con == 0} {
	    	puts "floating input pin of net $net"
	    } else {
	    	gui_change_highlight  -collection $driver_cell  -color light_red
	    }
	    if {$load_con == 0} {
	    	puts "floating output pin of net $net"
	    } else {
	    	gui_change_highlight -collection $load_cell -color light_blue
	    }
	    change_selection [get_nets $net -all]
	    gui_zoom -exact -selection -window [gui_get_current_window -types "Layout" -mru]
}


### info ###
proc width {} {
        set cell [get_object_name [get_selection]]
}
proc cell_pin {cell} {
        get_flat_pins -of [get_attribute [get_flat_cells $cell] full_name]
}

proc cell_ref {cell} {
        set ref_name [get_attr [get_flat_cells $cell -q] ref_name]
        return $ref_name
}

proc cell_loc {cell} {
        set loc [get_attr [get_flat_cells $cell -q] origin]
        return $loc
}

proc pin_net {pin} {
        set net [get_attr [get_flat_nets -of [get_flat_pins $pin -q] -q] full_name]
        return $net
}

proc net_loads {net} {
        set loads [get_attr [get_flat_pins -of $net -q -filter direction==in] full_name]
        return $loads
}

proc net_drive {net} {
        set drive [get_attr [get_flat_pins -of $net -q -filter direction==out] full_name]
        return $drive
}

proc cell_inp {cell} {
        set input [get_attr [get_flat_pins -of $cell -fil direction==in] full_name]
        return $input
}

proc cell_outp {cell} {
        set output [get_attr [get_flat_pins -of $cell -fil direction==out] full_name]
        return $output
}

proc rc {cell} {
        set cell_name [get_attr [get_flat_cells $cell] full_name]
        set ref_name [cell_ref $cell_name]
        set input [cell_inp $cell_name]
        set output [cell_outp $cell_name]
        set loc [cell_loc $cell_name]
        puts [ format "cell type : %s location : %s " $ref_name $loc]
        puts [ format "\t%-20s %s \t%s" ----------- --------------   -----------------   -----------------]
        foreach out $output {
                set pin_name [get_attr [get_flat_pins $out] lib_pin_name]
                set net [pin_net $out]
                set loads [net_loads $net]
                foreach load $loads {
                        set load_name [get_attr [get_flat_pins $load] full_name]
                        set inst [get_attr [get_flat_cells -of $load -q] full_name]
                        if {$inst==""} {
                                set type port
                        } else {
                                set loc [cell_loc $inst]
                                set load_pin_name [get_attr [get_flat_pins $load] lib_pin_name]
                                set type [get_attr [get_flat_cells $inst]  ref_name]
                        }
                        set load_info "$type \t $load_pin_name \t $inst \{$loc\}\n"
                        puts "output:\t $pin_name  $load_info"
                }
        }
        puts [ format "\t%-20s %s \t%s" ----------- --------------   -----------------   ----------------]
        foreach in $input {
                set pin_name [get_attr [get_flat_pins $in] lib_pin_name]
                set net [pin_net $in]
                set drive [net_drive $net]
                set inst [get_attr [get_flat_cells -of $drive -q] full_name]
                if {$inst == ""} {
                        set type port
                } else {
                        set loc [cell_loc $inst]
                        set dri_pin_name [get_attr [get_flat_pins $drive] lib_pin_name]
                        set type [get_attr [get_flat_cells $inst] ref_name]
                }
                set drive_info "$type \t $dri_pin_name \t $inst \{$loc\}\n"
                puts "input:\t $pin_name $drive_info"
        }
}

proc rn { name } {
	set net_full_name [get_attr [get_nets $name] full_name]
    set route_length [get_attr [get_nets $net_full_name] route_length]
	puts "net: $net_full_name "
    puts "route length: $route_length"
	set driver_list [get_attr [get_pins -of_objects $net_full_name -leaf -filter "direction =~ *out"] full_name]
	set driver_con [llength $driver_list]
	puts "===> driver numbers: $driver_con"
	foreach driver $driver_list {
		set type [get_attr [get_flat_cells -of_objects $driver] ref_name ]
		puts "       driver(pin): $driver        Reference: $type"
	}

	set load_list [get_attr [get_pins -of_objects $net_full_name -leaf -filter "direction =~ *in"] full_name]
	set load_con [llength $load_list]
	puts "===> loading numbers: $load_con"
	foreach loading $load_list {
		set type [get_attr [get_flat_cells -of_objects $loading] ref_name ]
		puts "       loading(pin): $loading        Reference: $type\n"
	}
}

proc rp { name } {
	set pin_full_name [get_attr [get_pins $name] full_name]
	set net_full_name [get_attr [get_nets -of_objects $pin_full_name -top -seg] full_name]
	set pin_con [llength $pin_full_name]
	set net_con [llength $net_full_name]
	if {$pin_con == 0} {
		puts "Error: can not find the pin  $name  in current design."
		return
	} elseif {$net_con == 0} {
		puts "Error: can not find the net of pin  $pin_full_name  in current design"
		return
	}
	puts "####pin: $pin_full_name"
	puts "####connecting net: $net_full_name"
	switch [get_attr $pin_full_name direction] {
		"in" {
			set driver_list [get_attr [get_pins -of_objects $net_full_name -leaf -filter "direction =~ *out"] full_name]
			set driver_con [llength $driver_list]
			if { $driver_con == 0 } {
				puts " floating input pin of net $net_full_name"
			}
			puts "===>driver pin numbers:$driver_con"
			foreach driver $driver_list {
				set type [get_model [get_attr [get_flat_cells -of_objects $driver] ref_name ]]
				puts "    driver(pin): $driver      Reference: $type"
			}
		}
		"out" {
			set load_list [get_attr [get_pins -of_objects $net_full_name -leaf -filter "direction =~ *in"] full_name]
			set load_con [llength $load_list]
			if { $load_con == 0 } {
				puts "floating output pin of $net_full_name"
			}
			puts "===> loading pin numbers:$load_con "
			foreach loading $load_list {
				set type [get_model [get_attr [get_flat_cells -of_objects $loading] ref_name ]]
				puts " \n   driver(pin): $pin_full_name     Reference: $type"
				puts "    loading(pin): $loading     Reference: $type"
			}
		}
	}
	
}

proc iCD {cell1 cell2} {
	set cell1_location [get_attr [get_cells $cell1] bbox]
	set cell1_x_loc [lindex [lindex $cell1_location 0] 0]
	set cell1_y_loc [lindex [lindex $cell1_location 0] 1]
	set cell2_location [get_attr [get_cells $cell2] bbox]
	set cell2_x_loc [lindex [lindex $cell2_location 0] 0]
	set cell2_y_loc [lindex [lindex $cell2_location 0] 1]
	set distance [expr abs($cell1_x_loc - $cell2_x_loc) + abs($cell1_y_loc - $cell2_y_loc)]
	#puts "$cell1 and $cell2  distance: $distance"
	return $distance
}

### timing ###
proc all_groups {} {
        set all_groups [get_object_name [get_path_groups *]]
        set group []
        foreach g $all_groups {
                if {![regexp {\*} $g] && ![regexp {in2} $g] && ![regexp {2out} $g] && ![regexp {CLK} $g] && ![regexp {input} $g] && ![regexp {output} $g]} {
                        append group "$g "
                }
        }
        return $group
}

proc r { pin } {
        set group [all_groups]
        report_timing -through $pin -nets -input_pins -transition_time -capacitance -crosstalk_delta -significant_digits 3 -nworst 1 -nosplit -groups $group
}
 
proc rf { pin } {
        set group [all_groups]
        report_timing -from $pin -nets -input_pins -transition_time -capacitance -crosstalk_delta -significant_digits 3 -nworst 1 -nosplit -derate -groups $group
}

proc rt { pin } {
        set group [all_groups]
        report_timing -to $pin -nets -input_pins -transition_time -capacitance -crosstalk_delta -significant_digits 3 -nworst 1 -nosplit -groups $group
}

proc rft { pin1 pin2 } {
        set group [all_groups]
        report_timing -from $pin1 -to $pin2 -nets -input_pins -transition_time -crosstalk_delta -capacitance -significant_digits 3 -nworst 1 -nosplit -groups $group
}

proc fi {pin} {
        all_fanin -to $pin -flat -startpoints_only -only_cells
}

proc fo {pin} {
        all_fanout -from $pin -flat -endpoints_only -only_cells
}

proc sfi {pin} {
        sc [get_object_name [get_flat_cells [all_fanin -to $pin -flat -startpoints_only -only_cells]]]
}

proc sfo {pin} {
        sc [get_object_name [get_flat_cells [all_fanout -from $pin -flat -endpoints_only -only_cells]]]
}

proc late_slack {pin} {
        set slack [get_attr [get_timing_paths -through $pin -delay_type max] slack]
        return $slack
}

proc rtc {pin} {
        report_clock_timing -to $pin -verbose -type latency -nosplit -nets -significant_digits 3
}


### other script ###

source /project2/pd_tiles//jiasong/BI/scripts/misc/socb_fb.tcl
alias fwb "fw -bounding_cell"
alias bwb "bw -bounding_cell"