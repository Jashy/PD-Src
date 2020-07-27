
#set buf_pattern ^BUF|^INV|^CLK|^DLY|^LVL
#set clkgate_pattern ^SELAT|^SEGATE|^L1GATE|^PREICG|^FRICG
#set sink_pattern ^SDFF|^MP|^SYN|^RA|^SRAM|^LAT|^RF
#set stop_pattern ^SELAT

proc bb {} {
setLayerPreference node_misc -isSelectable 0
setLayerPreference flightLine -isVisible 0
setLayerPreference allM0 -isVisible 0
setLayerPreference allM1Cont -isVisible 0
setLayerPreference allM1 -isVisible 0
setLayerPreference allM2Cont -isVisible 0
setLayerPreference allM2 -isVisible 0
setLayerPreference allM3Cont -isVisible 0
setLayerPreference allM3 -isVisible 0
setLayerPreference allM4Cont -isVisible 0
setLayerPreference allM4 -isVisible 0
setLayerPreference allM5Cont -isVisible 0
setLayerPreference allM5 -isVisible 0
setLayerPreference allM6Cont -isVisible 0
setLayerPreference allM6 -isVisible 0
setLayerPreference allM7Cont -isVisible 0
setLayerPreference allM7 -isVisible 0
setLayerPreference allM8Cont -isVisible 0
setLayerPreference allM8 -isVisible 0
setLayerPreference allM9Cont -isVisible 0
setLayerPreference allM9 -isVisible 0
setLayerPreference allM10Cont -isVisible 0
setLayerPreference allM10 -isVisible 0
setLayerPreference allM11Cont -isVisible 0
setLayerPreference allM11 -isVisible 0
setLayerPreference allM12Cont -isVisible 0
setLayerPreference allM12 -isVisible 0
setLayerPreference allM13Cont -isVisible 0
setLayerPreference allM13 -isVisible 0
setLayerPreference allM14Cont -isVisible 0
setLayerPreference allM14 -isVisible 0
setLayerPreference power -isVisible 0
setLayerPreference pgPower -isVisible 0
setLayerPreference pgGround -isVisible 0
setLayerPreference shield -isVisible 0
setLayerPreference unknowState -isVisible 0
setLayerPreference metalFill -isVisible 0
setLayerPreference clock -isVisible 0
setLayerPreference whatIfShape -isVisible 0
setLayerPreference phyCell -isVisible 0
setLayerPreference coverCell -isVisible 0
setLayerPreference stdCell -isVisible 0
setLayerPreference node_net -isVisible 1
setLayerPreference node_route -isVisible 1
}

proc gpn {pin_name} {
	deselectAll
	#dehighlight -all
    #if {[dbGetNetByName $pin_name] != "OXO"} {set net $pin_name} else {
	set net [get_attribute [get_nets -of_objects [get_pins $pin_name]] full_name]
    #}
    #set net_ptr [dbGetNetByName $net]
    #set wire_len [lindex [wl $net] 0]
    #if {$wire_len >0 } {set layer1 [lindex [wl $net] 2]; set layer2 [lindex [wl $net] 3]}
    #if {$wire_len ==0 } {
    #set layer1 [dbGet ${net_ptr}.topPreferredLayer.name]
	#set layer2 [dbGet ${net_ptr}.bottomPreferredLayer.name]
    #}
	set driver_list [get_attr [get_pins -of_objects [get_nets [get_nets $net] -top -seg] -filter "direction == out"] full_name]
	set load_list [get_attr [get_pins -of_objects [get_nets [get_nets $net] -top -seg] -filter "direction == in"] full_name]
	set driver_cell [get_attr [get_cells -of_objects [get_pins -of_objects [get_nets [get_nets $net] -top -seg] -filter "direction == out"]] full_name]
	set load_cell  [get_attr [get_cells -of_objects [get_pins -of_objects [get_nets [get_nets $net] -top -seg] -filter "direction == in"]] full_name]
	set drivers [get_attr [get_pins $driver_list] full_name]
	set driver_ref [get_attr [get_cells -of [get_pins $driver_list]] ref_name]
    set driver_con [llength $driver_list]
	set load_con [llength $load_list]
	puts "===> The driver is :"
	puts "driver (pin) : $drivers  --> $driver_ref"
	puts "net : $net"
	puts "===> The loadings are :"
	foreach load $load_list {
		set load [get_attr [get_pins $load] full_name]
		set load_ref [get_attr [get_cells -of [get_pins $load]] ref_name]
		puts [format "%s\t  %5s\t %s\t %s\t" loading(pin): $load  --> $load_ref]
	}
	puts "loads_num are $load_con"
	highlight [get_attr [get_nets [get_net $net] -top -seg] full_name] -color yellow
	if {$driver_con == 0} {
		puts "floating input pin of net $net"
	} else {
            foreach d_cell $driver_cell {
                    highlight $d_cell  -color red
            }
	}
	if {$load_con == 0} {
		puts "floating output pin of net $net"
	} else {
            foreach l_cell $load_cell {
                    highlight $d_cell -color blue
            }
	}
	selectNet $net
	zoomSelected
}

proc ShowProcBody {name} {
		parse_proc_arguments -args $name option
		foreach arg [array args option] {
				puts "$arg = $option(arg)"
		}
		set temp [open ./$name.tcl w]
		set temp_body [info body $name]
		puts $temp $temp_body
		close $temp
		gvim ./$name.tcl
}

proc stat {} {
    df::steps -status
}

proc next {} {
    df::steps -run -next
}

proc auto_run {} {
    df::steps -run
}

proc run {step} {
    df::steps -run -name $step
}

proc pause {step} {
    df::steps -pause -name $step
}

proc skip {step} {
    df::steps -skip -name $step
}

proc redo {step} {
    df::steps -redo -name $step
}

proc load_snapshot {dir} {
    df::load_fp_snapshot -placement -no_pins -dir $dir
}

proc restore_vim {dir view} {
    df::netlist -restore -dir $dir -view $view -force
}

proc save_vim {dir view} {
    df::netlist -save -lef -dir $dir -view $view
}

proc save_800_vim {dir view} {
    df::netlist -save -view $view -full_def -dir $dir
}


proc fc {} {
    dbSet selected.pstatus fixed
}

proc uf {} {
    dbSet selected.pstatus placed
}

proc wfp { file_name } {
    writeFPlanScript -fileName $file_name -sections blocks

}

proc nl { net } {
    set np [dbGetNetByName $net]
    set x [dbu2uu [dbNetLenX $np]]
    set y [dbu2uu [dbNetLenY $np]]
    set len [expr $x +$y]
    return $len
}
proc net_drive { net } {
    set np [dbGetNetByName $net]
    set drive [dbget [dbget $np.instTerms {.isOutput==1}].name]
    if {$drive==0x0} {
	set drive [dbGet $np.terms.name]
    }

    return $drive
}

proc net_fanout { net } {
    set np [dbGetNetByName $net]
    set load_num [dbget $np.NumInputTerms]
    return $load_num
}

proc fix_wire { net } {
    foreach n $net {
      set net_ptr [dbGetNetByName $n]
	if { $net_ptr==0x0} { puts "$n not exist"}
	dbSet ${net_ptr}.DontTouch true
	dbSet ${net_ptr}.wires.status fixed
	dbSet ${net_ptr}.vias.status fixed
	dbSet ${net_ptr}.skipRouting true
}

}

proc get_pin_clock_top { pin } {
    if { [info exist trunk] } {unset trunk}
    if { [info exist trunk] } {unset top}
    set clock_names [lsort -u [get_object_name [get_property [get_pins $pin] clocks] ] ]
    foreach clock_name $clock_names {
    set clock_tree_name [get_ccopt_clock_trees $clock_name] 
    lappend top [get_ccopt_clock_tree_nets -in_clock_trees $clock_tree_name -net_types top]
    }
    set top [lsort -u $top]
    return $top
}


proc get_pin_clock_trunk { pin } {
    if { [info exist trunk] } {unset trunk}
    if { [info exist trunk] } {unset top}
    set clock_names [lsort -u [get_object_name [get_property [get_pins $pin] clocks] ] ]
    foreach clock_name $clock_names {
    set clock_tree_name [get_ccopt_clock_trees $clock_name] 
    lappend trunk [get_ccopt_clock_tree_nets -in_clock_trees  $clock_tree_name -net_types trunk]
    }
    set trunk [lsort -u $trunk]
    return $trunk
}

proc pin_inst { pin } {
    set pin_ptr [dbGetTermByInstTermName $pin]
    set inst [dbGet $pin_ptr.inst.name]
    return $inst
}
proc net_loads { net } {
    set np [dbGetNetByName $net]
    set loads [dbget [dbget $np.instTerms {.isInput==1}].name]
    return $loads
}


proc net_a { net } {
    getAttribute -net $net
}

proc wire_len { net } {
    set net_length ""
    foreach wire_length [dbGet [dbGetNetByName $net].wires.length] {
	set net_length [expr $net_length+$wire_length]
    }
    puts $net_length
#or can use dbu2uu [dbNetWireLenX [dbGetNetByName $net]] to get the X wire length and dbu2uu [dbNetWireLenY [dbGetNetByName $net]] to get the Y wire length
}
proc fix_net { net } {
    foreach n $net {
	dbSet [dbGetNetByName $n].DontTouch true
	dbSet [dbGetNetByName $n].wires.status fixed
	dbSet [dbGetNetByName $n].skipRouting true
    }
}
proc net_sta { net } {
    foreach n $net {
	puts "$n DontTouch [dbGet [dbGetNetByName $n].DontTouch]"
	puts "$n wires.status [dbGet [dbGetNetByName $n].wires.status]"
	puts "$n skipRouting [dbGet [dbGetNetByName $n].skipRouting]"
    }
}
proc wl { nets } {
    suppressMessage IMPDBTCL 205
    suppressMessage IMPDBTCL 204
    foreach net $nets {
    set total 0
    set net_length ""
    set netp [dbGetNetByName $net]
    set rule [dbGet $netp.rule.name]
    set shield [dbGet $netp.shieldNets.name]
    if {[info exists LL]} {unset LL}
    set i 0
    set j 0
    dbForEachNetWire $netp wire {
    if { [regexp {pWire|viaInst} [dbGet $wire.objType]] } { continue }
	if { [dbGet $wire.objType] == "0x0" } { continue }
	if { [dbGet $wire.layer] == "0x0" } { continue }
	if { [dbGet $wire.length] == "0x0" } { continue }
	set layer [dbGet $wire.layer.name]
	set len [dbGet $wire.length]
	if { [info exist LL($layer)] } {
		set LL($layer) [expr $LL($layer) + $len]
	} else {
		set LL($layer) $len
	}
	set total [expr $total + $len]
    }
	if {$total==0} { return "$total"}
    if { [llength [array names LL] ] >=2 } {
	 foreach layer [array names LL] {
#	    puts "$layer  $LL($layer)"
	    if { $LL($layer) >= $i} { 
		set i $LL($layer); set max_layer_1 $layer;
	    }
	}
	unset LL($max_layer_1)
	foreach layer [array names LL] {
	    if { $LL($layer) >= $j} { 
	    set j $LL($layer); set max_layer_2 $layer;
	    }
	}
	 return "$total $rule $max_layer_1 $max_layer_2 $i $j "
    }
	return "$total\t rule $rule\t shiled $shield"
    } 


}

proc pin_net { pin } {
set pin_ptr [dbGetTermByInstTermName $pin]
    if {$pin_ptr=="0x0"} { set pin_ptr [dbGetFTermByName $pin] }
    set net [dbget $pin_ptr.net.name]
    return $net

}
proc write_wire { net name } {
    deselectAll
    editSelect -net $net -shield 1  
    editSelectVia -net $net
    defOut -selected -routing ${name}.def
    deselectAll 
}
proc remove_inst_fg { inst } {
    set i 0
    puts "###delteInst from group"
    foreach ins $inst {
    set group_name [dbGet [dbGetInstByName $ins].group.name]
    puts "deleteInstFromInstGroup $group_name $ins"
    deleteInstFromInstGroup $group_name $ins
    incr i
    }
    puts "$i int delte from group"
}
proc inst_loc { inst } {
    set inst_ptr [dbGetInstByName $inst]
    set location [dbget $inst_ptr.pt]
    return $location
}
proc pin_loc { pin } {
    set pin_ptr [dbGetTermByInstTermName $pin]
    if {$pin_ptr=="0x0"} { set pin_ptr [dbGetFTermByName $pin] }
    set location [dbget $pin_ptr.pt]
    return $location
}
proc pin_layer { pin } {
    set pin_ptr [dbGetTermByInstTermName $pin]
    if {$pin_ptr=="0x0"} { set pin_ptr [dbGetFTermByName $pin] }
    set layer [dbget $pin_ptr.layer.name]
    return $layer
}

proc inst_cell { inst } {
    set inst_ptr [dbGetInstByName $inst]
    set cell_name [dbGet $inst_ptr.cell.name]
    return $cell_name
}
proc inst_group { inst } {
    set inst_ptr [dbGetInstByName $inst]
    set group_name [dbGet $inst_ptr.group.name]
    return $group_name
}

proc pin_slew { pin } {
    set pin_ptr [dbGetTermByInstTermName $pin]
    if {$pin_ptr=="0x0"} { set pin_ptr [dbGetFTermByName $pin] }
    if {$pin_ptr=="0x0"} { puts "not exist pin";return}
    set slew [get_property [get_pins $pin]  max_transition]
    return $slew
}
proc late_slack { pin } {
    set pin_ptr [dbGetTermByInstTermName $pin]
    if {$pin_ptr=="0x0"} { set pin_ptr [dbGetFTermByName $pin] }
    if {$pin_ptr=="0x0"} { puts "not exist pin";return}
    set slack [get_property [get_pins $pin]  slack_max]
    if { $slack=="" || $slack=="INFINITY"} {
	set slack [ get_property [report_timing -collection -through $pin -late] slack ]
	}
    return $slack
}
proc early_slack { pin } {
    set pin_ptr [dbGetTermByInstTermName $pin]
    if {$pin_ptr=="0x0"} { set pin_ptr [dbGetFTermByName $pin] }
    if {$pin_ptr=="0x0"} { return "not exist pin"}
    set slack [get_property [get_pins $pin]  slack_min]
    if { $slack=="" || $slack=="INFINITY"} {
	set slack [ get_property [report_timing -collection -through $pin -early] slack ]
	}
    return $slack
}
proc late_slew { pin } {
    set pin_ptr [dbGetTermByInstTermName $pin]
    if {$pin_ptr=="0x0"} { set pin_ptr [dbGetFTermByName $pin] }
    if {$pin_ptr=="0x0"} { return "not exist pin"}
    set slew [get_property [get_pins $pin]  slew_max]
    return $slew
}

proc rn { net } {
    if { [dbGetNetByName $net] == "OXO" } {
	puts "Net not exist";return 
    }
    set net_ptr [dbGetNetByName $net]
    set rule [dbGet ${net_ptr}.rule.name]
    set inputs [dbGet [dbGet ${net_ptr}.instTerms.IsInput 1 -p1].name]
    if { $inputs==0x0} {
	set inputs [dbGet ${net_ptr}.terms.name]
    }
    set outputs [dbGet [dbGet ${net_ptr}.instTerms.IsOutput 1 -p1].name]
    set load_num [dbGet ${net_ptr}.numInputTerms]
    set shield [dbGet ${net_ptr}.shieldNets.name]
    set wire_len [lindex [wl $net] 0]
    if {$wire_len >0 } {set layer1 [lindex [wl $net] 2]; set layer2 [lindex [wl $net] 3]}
    if {$wire_len ==0 } {
	set wire_len [nl $net]
	set layer1 [dbGet ${net_ptr}.topPreferredLayer.name]
	set layer2 [dbGet ${net_ptr}.bottomPreferredLayer.name]
    }
    puts [ format "net rule: %s shield: %s  length:%s  layer %s %s" $rule $shield $wire_len $layer1 $layer2]
    puts [ format "\t%-20s %s \t%s \t%-20s" Inst Pin Type location]
    puts [ format "\t%-20s %s\t %s" ----------- --------------   -----------------]
    set driver_pin [lindex [net_drive $net] 0]
    set drive_loc [pin_loc $driver_pin]
    if {[regexp {/} $driver_pin] } {
    set drive [join [lrange [split $driver_pin "/"] 0 end-1] /]
    set pin_name [lindex [split $driver_pin "/"] end ]
    set type [lindex [inst_cell $drive] 0]
    } else {
	set drive $driver_pin
	set pin_name port
	set type ""
    } 
    
    
    puts [format "%-10s\t %s \t%5s \t%s \t%s\n" driver: $drive $pin_name $type $drive_loc]
    puts [format "\t%-20s %s\t %s" ----------- --------------   -----------------]
    foreach loads $inputs {
	if { [regexp {/} $loads]} {
	    set load_loc [pin_loc $loads]
	    set loading [join [lrange [split $loads "/"] 0 end-1] /]
	    set pin_name [lindex [split $loads "/"] end ]
	    set type [inst_cell $loading]
	} else {
	    set loading $loads
	    set pin_name port
	    set type ""
	    set load_loc [dbGet ${net_ptr}.terms.pt]
	}
	puts [format "%s\t %s\t %5s\t %s\t %s\n" loading: $loading $pin_name $type $load_loc]
    }
}
proc rc { inst } {
    set inst_ptr [dbGetInstByName $inst]
    set output [dbGet [dbGet ${inst_ptr}.instTerms.isOutput 1 -p1].name]
    set input [dbGet [dbGet ${inst_ptr}.instTerms.isInput 1 -p1].name]
    set cell_type [inst_cell $inst]
    set loc [inst_loc $inst]
    puts [ format "cell type : %s location : %s " $cell_type $loc]
       puts [ format "\t%-20s %s \t%s" ----------- --------------   -----------------   -----------------]
    foreach out $output {
	 set pin_name [get_property [get_pins $out] ref_lib_pin_name]
	 set net [lindex [pin_net $out] 0]
	 set loads [net_loads $net]
	 foreach loading $loads {
	     set insts [dbGet [dbGetTermByInstTermName $loading].inst.name]
	     if {$insts==0x0} {
		 set type port
	     } else {
		 set loc [lindex [pin_loc $loading] 0]
		 set pin_name_load [get_property [get_pins $loading] ref_lib_pin_name]
		 set type [dbGet [dbGetTermByInstTermName $loading].inst.cell.name]
	     }
	     set loading_info "$type \t $pin_name_load   \{$loc\} \t $insts\n"
	     puts "output:\t $pin_name \t $loading_info"

	 }
    }
puts [ format "\t%-20s %s \t%s" ----------- --------------   -----------------   ----------------]
    foreach inp $input {
	 set pin_name [get_property [get_pins $inp] ref_lib_pin_name]
	 set net [lindex [pin_net $inp] 0]
	 set drive [net_drive $net]
	 set insts [dbGet [dbGetTermByInstTermName $drive].inst.name]
	 if { $insts==0x0 } {
		set type port
		set insts [dbGet [dbGetNetByName $net].terms.name]
		set pin_name_load ""
	 } else {
	 set loc [lindex [pin_loc $drive] 0]
	 set pin_name_load [get_property [get_pins $drive] ref_lib_pin_name]
	 set type [dbGet [dbGetTermByInstTermName $drive].inst.cell.name]
	}
	 set drive_info "$type \t $pin_name_load   \{$loc\} \t $insts"	
	puts "input:\t $pin_name \t $drive_info\n"
    }

   
}
proc net_far_pin { net } {
    set drive [net_drive $net]
    set loads [net_load $net]
    set drive_loc [pin_loc $drive]
    set drive_x [lindex [lindex $drive_loc 0] 0]
    set drive_y [lindex [lindex $drive_loc 0] 1]
    set org_distance 0
    foreach loadi $loads {
	set load_loc [pin_loc $loadi]
	set load_x [lindex [lindex $load_loc 0] 0]
	set load_y [lindex [lindex $load_loc 0] 1]
	set x_d [expr $load_x - $drive_x]
	set axd  [expr abs($x_d)]
	set y_d [expr $load_y - $drive_y]
	set ayd [expr abs($y_d)]
	set distance [expr $axd+$ayd]
	if {$org_distance < $distance} {
		set org_distance $distance
		set far_pin $loadi
		set far_pin_loc "$load_x $load_y"
		set far_in [concat $far_pin $far_pin_loc]
	    }	
	if { $x_d >10 } { lappend E $loadi $load_x $load_y}
	if { $y_d >10 } { lappend N $loadi $load_x $load_y}
	if { $x_d <-10 } { lappend W $loadi $load_x $load_y}	
	if { $y_d <-10 } { lappend S $loadi $load_x $load_y}	
    }
	set far_pin_x [lindex $far_in 1]
	set far_pin_y [lindex $far_in 2]
	set x_stand [expr [expr $drive_x - $far_pin_x]/2]
	set y_stand [expr [expr $drive_y - $far_pin_y]/2]
	set x_stand [expr abs($x_stand)]
	set y_stand [expr abs($y_stand)]
	if {$x_stand < 5 } {set x_stand 5}
	if {$y_stand < 5 } {set y_stand 5}
       if { [info exist W]} {
	    if { [lsearch $W $far_in]} {
		foreach {loadi load_x load_y} $W {
		    set far_pin_x [lindex $far_in 1]
		    set far_pin_y [lindex $far_in 2]
		    set x_dis [expr $far_pin_x -$load_x]
		    set y_dis [expr $far_pin_y -$load_y]
		    if { [expr abs($x_dis)] < $x_stand &&  [expr abs($y_dis)]< $y_stand } {
		    lappend far_group $loadi
		    }
		}
	    }
	}
	if { [info exist N]} {
	    if { [lsearch $N $far_in]} {
		foreach {loadi load_x load_y} $N {
		    set far_pin_x [lindex $far_in 1]
		    set far_pin_y [lindex $far_in 2]
		    set x_dis [expr $far_pin_x -$load_x]
		    set y_dis [expr $far_pin_y -$load_y]
		    if { [expr abs($x_dis)]<$x_stand &&  [expr abs($y_dis)]<$y_stand} {
		    lappend far_group $loadi
		    }
		}
	    }
	}

	if { [info exist E]} {
	    if { [lsearch $E $far_in]} {
		foreach {loadi load_x load_y} $E {
		    set far_pin_x [lindex $far_in 1]
		    set far_pin_y [lindex $far_in 2]
		    set x_dis [expr $far_pin_x -$load_x]
		    set y_dis [expr $far_pin_y -$load_y]
		    if { [expr abs($x_dis)]<$x_stand &&  [expr abs($y_dis)]<$y_stand} {
		    lappend far_group $loadi
		    }
		}
	    }
	}
	if { [info exist S]} {
	    if { [lsearch $S $far_in]} {
		foreach {loadi load_x load_y} $S {
		    set far_pin_x [lindex $far_in 1]
		    set far_pin_y [lindex $far_in 2]
		    set x_dis [expr $far_pin_x -$load_x]
		    set y_dis [expr $far_pin_y -$load_y]
		    if { [expr abs($x_dis)]<$x_stand &&  [expr abs($y_dis)]<$y_stand} {
		    lappend far_group $loadi
		    }
		}
	    }
	}


    lappend far_group $far_pin
    set far_group [lsort -unique -dictionary $far_group]
    return "$far_group $far_pin_loc"
    
}


proc far_pin { net } {
    set drive [net_drive $net]
    set loads [net_load $net]
    set drive_loc [pin_loc $drive]
    set drive_x [lindex [lindex $drive_loc 0] 0]
    set drive_y [lindex [lindex $drive_loc 0] 1]
    set org_distance 0
    foreach loadi $loads {
	set load_loc [pin_loc $loadi]
	set load_x [lindex [lindex $load_loc 0] 0]
	set load_y [lindex [lindex $load_loc 0] 1]
	set x_d [expr $load_x - $drive_x]
	set y_d [expr $load_y - $drive_y]
	set distance [expr sqrt($x_d*$x_d + $y_d*$y_d)]
	if {$org_distance < $distance} {
		set org_distance $distance
		set far_pin $loadi
		set far_pin_loc "$load_x $load_y"
		set far_in [concat $far_pin $far_pin_loc]
	    }
	if { $x_d >50 } { lappend E $loadi $load_x $load_y}
	if { $y_d >50 } { lappend N $loadi $load_x $load_y}
	if { $x_d <-50 } { lappend W $loadi $load_x $load_y}	
	if { $y_d <-50 } { lappend S $loadi $load_x $load_y}	
    }
	
       if { [info exist W]} {
	    if { [lsearch $W $far_in]} {
		foreach {loadi load_x load_y} $W {
		    set far_pin_x [lindex $far_in 1]
		    set far_pin_y [lindex $far_in 2]
		    set x_dis [expr $far_pin_x -$load_x]
		    set y_dis [expr $far_pin_y -$load_y]
		    if { [expr abs($x_dis)]<25 &&  [expr abs($y_dis)]<25} {
		    lappend far_group $loadi
		    }
		}
	    }
	}
	if { [info exist N]} {
	    if { [lsearch $N $far_in]} {
		foreach {loadi load_x load_y} $N {
		    set far_pin_x [lindex $far_in 1]
		    set far_pin_y [lindex $far_in 2]
		    set x_dis [expr $far_pin_x -$load_x]
		    set y_dis [expr $far_pin_y -$load_y]
		    if { [expr abs($x_dis)]<25 &&  [expr abs($y_dis)]<25} {
		    lappend far_group $loadi
		    }
		}
	    }
	}

	if { [info exist E]} {
	    if { [lsearch $E $far_in]} {
		foreach {loadi load_x load_y} $E {
		    set far_pin_x [lindex $far_in 1]
		    set far_pin_y [lindex $far_in 2]
		    set x_dis [expr $far_pin_x -$load_x]
		    set y_dis [expr $far_pin_y -$load_y]
		    if { [expr abs($x_dis)]<25 &&  [expr abs($y_dis)]<25} {
		    lappend far_group $loadi
		    }
		}
	    }
	}
	if { [info exist S]} {
	    if { [lsearch $S $far_in]} {
		foreach {loadi load_x load_y} $S {
		    set far_pin_x [lindex $far_in 1]
		    set far_pin_y [lindex $far_in 2]
		    set x_dis [expr $far_pin_x -$load_x]
		    set y_dis [expr $far_pin_y -$load_y]
		    if { [expr abs($x_dis)]<25 &&  [expr abs($y_dis)]<25} {
		    lappend far_group $loadi
		    }
		}
	    }
	}


    lappend far_group $far_pin
    set far_group [lsort -unique -dictionary $far_group]
    return "$far_group $far_pin_loc"
    
}


proc near_pin { net } {
    set drive [net_drive $net]
    set loads [net_load $net]
    set drive_loc [pin_loc $drive]
    set drive_x [lindex [lindex $drive_loc 0] 0]
    set drive_y [lindex [lindex $drive_loc 0] 1]
    set org_distance 0
    foreach loadi $loads {
	set load_loc [pin_loc $loadi]
	set load_x [lindex [lindex $load_loc 0] 0]
	set load_y [lindex [lindex $load_loc 0] 1]
	set x_d [expr $load_x - $drive_x]
	set y_d [expr $load_y - $drive_y]
	set distance [expr sqrt($x_d*$x_d + $y_d*$y_d)]
	if {$org_distance < $distance} {
		set org_distance $distance
		set near_pin $loadi
		set near_pin_loc "$load_x $load_y"
		set near_in [concat $near_pin $near_pin_loc]
	    }
	if { $x_d >20 } { lappend E $loadi $load_x $load_y}
	if { $y_d >20 } { lappend N $loadi $load_x $load_y}
	if { $x_d <-20 } { lappend W $loadi $load_x $load_y}	
	if { $y_d <-20 } { lappend S $loadi $load_x $load_y}	
    }
	
       if { [info exist W]} {
	    if { [lsearch $W $near_in]} {
		foreach {loadi load_x load_y} $W {
		    set near_pin_x [lindex $near_in 1]
		    set near_pin_y [lindex $near_in 2]
		    set x_dis [expr $near_pin_x -$load_x]
		    set y_dis [expr $near_pin_y -$load_y]
		    if { [expr abs($x_dis)]<25 &&  [expr abs($y_dis)]<25} {
		    lappend near_group $loadi
		    }
		}
	    }
	}
	if { [info exist N]} {
	    if { [lsearch $N $near_in]} {
		foreach {loadi load_x load_y} $N {
		    set near_pin_x [lindex $near_in 1]
		    set near_pin_y [lindex $near_in 2]
		    set x_dis [expr $near_pin_x -$load_x]
		    set y_dis [expr $near_pin_y -$load_y]
		    if { [expr abs($x_dis)]<25 &&  [expr abs($y_dis)]<25} {
		    lappend near_group $loadi
		    }
		}
	    }
	}

	if { [info exist E]} {
	    if { [lsearch $E $near_in]} {
		foreach {loadi load_x load_y} $E {
		    set near_pin_x [lindex $near_in 1]
		    set near_pin_y [lindex $near_in 2]
		    set x_dis [expr $near_pin_x -$load_x]
		    set y_dis [expr $near_pin_y -$load_y]
		    if { [expr abs($x_dis)]<25 &&  [expr abs($y_dis)]<25} {
		    lappend near_group $loadi
		    }
		}
	    }
	}
	if { [info exist S]} {
	    if { [lsearch $S $near_in]} {
		foreach {loadi load_x load_y} $S {
		    set near_pin_x [lindex $near_in 1]
		    set near_pin_y [lindex $near_in 2]
		    set x_dis [expr $near_pin_x -$load_x]
		    set y_dis [expr $near_pin_y -$load_y]
		    if { [expr abs($x_dis)]<25 &&  [expr abs($y_dis)]<25} {
		    lappend near_group $loadi
		    }
		}
	    }
	}


    lappend near_group $near_pin
    set near_group [lsort -unique -dictionary $near_group]
    return "$near_group $near_pin_loc"
    
}
proc size_inst { inst } {
	if {[dbGetInstByName $inst]==0x0} {return ""}
	set cell_type  [inst_cell $inst]
	set cell_type_org  [inst_cell $inst]
	regexp {_X(.*)\w_A9} $cell_type "" num
	if { [regexp P $num]} {
	    regsub P $num {.} num
	    regsub -expanded {[^0-9]$} $num 0 num
	}
	set new_num [expr $num +1]
	set new_num [expr ceil($new_num)]
	set new_num [expr int($new_num)]
	regsub _X$num $cell_type _X$new_num new_type
	if { [dbGetCellByName $new_type ] !=0x0} {
	    return "ecoChangeCell -inst $inst -cell $new_type; #org $cell_type_org\n"
	   }
	if { $new_num >=16 } { return ""}
	if {$new_num <16 && [dbGetCellByName $new_type ] ==0x0 } {
	    set a [size_inst_up $inst $cell_type]
	    set new_type [lindex $a 1]
	    if { $new_type !="" } {
	    return "ecoChangeCell -inst $inst -cell $new_type; #org $cell_type_org\n"
	    } 
	    } 
}

proc size_inst_up {inst cell_type} {
	global new_type
	regexp {_X(.*)\w_A9} $cell_type "" num
	if { [regexp P $num]} {
	    regsub P $num {.} num
	    regsub -expanded {[^0-9]$} $num 0 num
	}
	set new_num [expr $num +1]
	set new_num [expr ceil($new_num)]
	set new_num [expr int($new_num)]
	regsub _X$num $cell_type _X$new_num new_type
	set flag 0
	if { [dbGetCellByName $new_type] ==0x0 && $new_num <16 } {
		set flag 1
	}
	if {$flag==1} {size_inst_up $inst $new_type}
	
	if { [dbGetCellByName $new_type] !=0x0} { 
	return "$inst $new_type";
	}
	
}

proc size_to_slvt { inst } {
     set inst_ptr [dbGetInstByName $inst]
     if {$inst_ptr==0x0} {
         return
    } else {
     set cell_type [dbGet $inst_ptr.cell.name]
     if { [regexp A9PP84TSL $cell_type] } {
	    return "#$cell_type almost hightest vt"
	}
     regsub {_A9PP84T(.*)_} $cell_type _A9PP84TSL_ new_type
     return "ecoChangeCell -inst $inst -cell $new_type; #org $cell_type\n"
    }

}
proc size_inst_vt { inst } {
     set inst_ptr [dbGetInstByName $inst]
     if {$inst_ptr==0x0} {
         return
    } else {
     set cell_type [dbGet $inst_ptr.cell.name]
     if { [regexp A9PP84TSL $cell_type] } {
	    return "#$cell_type almost hightest vt"
	}
     regsub {_A9PP84(.*)_} $cell_type * new_type
     set all_type [dbGet head.libCells.name $new_type]
     set all_type [lsort -dictionary $all_type]
     set need_index [lsearch $all_type $cell_type]
     incr need_index 1
     set need_type [lindex $all_type $need_index] 
     return "ecoChangeCell -inst $inst -cell $need_type; #org $cell_type\n"
    }
    
    	
}

proc size_to_bigest { inst } {
     set new_num 0
     set inst_ptr [dbGetInstByName $inst]
     if {$inst_ptr==0x0 } {
	return ""
    } else {
     set cell_type [dbGet $inst_ptr.cell.name]
     regexp {_X(.*)(\w)_A9PP} $cell_type "" O T
     set org_str [lindex [split $O {}] end]
     if { [regexp {\d} $org_str]} {
	    set org_str ""
	}
     regsub {_X.*(\w)_A9PP.*} $cell_type "_X*${T}*TSL*"  new_type
     set all_type [dbGet head.allCells.name $new_type -e]
     foreach cell $all_type {
	regexp {_X(.*)(\w)_A9PP84} $cell "" info_new ST
	set num [join [lrange [split $info_new {}] 0 1] {}]
	regsub P $num . num
	if { [regexp -expanded {[^0-9]$} $num] } {
	    set num [lindex [split $num {}] 0]
	}
	set str [lindex [split $info_new {}] end]
	if { [regexp {\d} $str]} {
	    set str ""
	}
	if { [string eq $org_str $str] } {
	
	set num [expr ceil($num)]
	set num [expr int($num)]	
        if { $num > $new_num  && $num <17 } {
		set new_num $num
		set bigest_type $cell
	 }
	}
	
    
    }
    return "ecoChangeCell -inst $inst -cell $bigest_type; #org $cell_type\n"
 }

}
proc is_detour { net } {
    set net_ptr [dbGetNetByName $net]
    if {$net_ptr==0x0 } {
	return "net not exits,please check"
    } else {
	set result [dbGet ${net_ptr}.avoidDetour]
	return $result
    }
    
}

proc fix_net_slew {net limit current} {
	set net [lindex $net 0]
	set add 0
	set size 0
	set promt_layer 0
	global new_type
	global num
	global new_num
	set is_clk [is_clock $net]
	if {$is_clk==1} {
	    set add_cell_type  INV_X16N_A9PP84TSL_C14
	}
	if {$is_clk==0} {
	    set add_cell_type  BUF_X16N_A9PP84TSL_C16
	}

        set len [lindex [wl $net] 0]
	set elen [lindex [nl $net] 0]
	set ndr [lindex [wl $net] 1]
	set layer1 [lindex [wl $net] 2]
	set layer1_len [lindex [wl $net] 4]
	set layer2 [lindex [wl $net] 3]
	set layer2_len [lindex [wl $net] 5]
	set drive [net_drive [lindex $net 0]]
	set day [exec date "+%Y%m%d"]
	set inst [pin_inst $drive]
	set cell_type [inst_cell $inst]
	set fanout [net_fanout $net]
	set manual 0
	set is_detour [is_detour $net ]
	if { [regexp RCM|CLK $cell_type] } {
	    set manual 1
	} elseif { [regexp {_X(.*)\w_A9} $cell_type] } {

	    regexp {_X(.*)\w_A9} $cell_type "" num 
	    if { [regexp P $num]} {
		 regsub P $num {.} num
		 regsub -expanded {[^0-9]$} $num 0 num
	    }
	    set new_num [expr $num +1]
	    set new_num [expr ceil($new_num)]
	    set new_num [expr int($new_num)]
	}
	if { [regexp {differential} $ndr]  || [regexp {xserdes_.x_.\[\d\]} $net] } { continue } 
	if { [regexp {M|C} $layer1] || [regexp {M|C} $layer2]  } {
	    if { $layer1_len >40 || $layer2_len>40 } {
	    set promt_layer 1
	    }
	}
	set messages "###Net $net wire length: $len ndr: $ndr layer: $layer1 $layer2 load count: $fanout current slew: $current Limit: $limit drive_pin $drive type: $cell_type"
	if { $manual ==1} {set cmd "##manually fix";return "$messages\n$cmd" }
	
	set len_st [expr $elen *1.4]
	if { $len > $len_st && $fanout < 15 && !$is_detour } {
	    if { $promt_layer } {	    
	    set cmd "editDelete -net \{$net\} -shield 1; #net detour estimate length $elen;\nsetAttribute -net \{$net\} -avoid_detour true -top_preferred_routing_layer 9 -bottom_preferred_routing_layer 6 -preferred_routing_layer_effort high ;\n"
	    } else {
		set cmd "editDelete -net \{$net\} -shield 1; #net detour estimate length $elen;\nsetAttribute -net \{$net\} -avoid_detour true;\n"
	    }
	} else {
	    if {$len > 390  || [regexp {SDFF|RA|RF|HS56GBF08|RCM|TWGDSK|CLKGI_S20_|CLKG_S5|LAT} $cell_type] || $new_num >16 && !$promt_layer} {
		set add 1
		} else {
		    if { $len >150 && $len <=390 && $promt_layer } {
		    set cmd "editDelete -net \{$net\} -shield 1; \nsetAttribute -net \{$net\} -avoid_detour true -top_preferred_routing_layer 9 -bottom_preferred_routing_layer 6 -preferred_routing_layer_effort high ;\n"
		    } else {
		    set size 1
		}
	    }
	}
	if {$size==1} {
	    set slacks [expr $current -$limit]
	    if {$slacks < 30 } {
		set cmd [size_inst $inst]
	    } else {
		if { [regexp {BUF|INV|DLY} $cell_type] } {
		set cmd [size_to_bigest $inst]
		} else {
		    set cmd ""
		}
	    }
	     if {$cmd==""} {set add 1}
	}

	if { $add==1} {
	   if { $fanout==1 } {
		if { [regexp {BUF|INV} $cell_type] } {
		set cmd "ecoAddRepeater -net $net -cell $add_cell_type -relativeDistToSink 0.5\n"
		} else {
		set cmd "ecoAddRepeater -term \{$drive\} -cell $add_cell_type -relativeDistToSink 1\n"
		}
	    } elseif { $fanout >1 }  {	
		if { ![regexp {BUF|INV|DLY} $cell_type] } {
		    set cmd "ecoAddRepeater -term \{$drive\} -cell $add_cell_type -relativeDistToSink 1\n"
		} else {	
		set add_pin [lrange [net_far_pin $net] 0 end-2]
		set far_loc_x [lindex [net_far_pin $net] end-1]
		set far_loc_y [lindex [net_far_pin $net] end]
		set drive_loc_x [lindex [lindex [pin_loc $drive] 0] 0]
		set drive_loc_y [lindex [lindex [pin_loc $drive] 0] 1]
		set x_loc [expr $far_loc_x + $drive_loc_x]
		set x_loc [expr $x_loc/2]
		set y_loc [expr $far_loc_y + $drive_loc_y]
		set y_loc [expr $y_loc/2]
		set cmd "ecoAddRepeater -term \{$add_pin\} -cell $add_cell_type -loc \{$x_loc $y_loc\}\n"
		}
	    }
	}
	return "$messages\n$cmd"
}

proc split_net { net } {
	set drive_pin [net_drive $net]
	set drive_loc_x [lindex [pin_loc $drive_pin] 0]
	set drive_loc_y [lindex [pin_loc $drive_pin] 1]
	set add_pin [lrange [net_far_pin $net] 0 end-2]
	set far_loc_x [lindex [net_far_pin $net] end-1]
	set far_loc_y [lindex [net_far_pin $net] end]
	set drive_loc_x [lindex [lindex [pin_loc $drive_pin] 0] 0]
	set drive_loc_y [lindex [lindex [pin_loc $drive_pin] 0] 1]
	set x_loc [expr $far_loc_x + $drive_loc_x]
	set x_loc [expr $x_loc/2]
	set y_loc [expr $far_loc_y + $drive_loc_y]
	set y_loc [expr $y_loc/2]
	set cmd "ecoAddRepeater -term \{$add_pin\} -cell BUF_X16N_A9PP84TSL_C14 -loc \{$x_loc $y_loc\}\n"
	return $cmd
}
proc is_output { pin } {
   if { [dbGetTermByInstTermName $pin] ==0x0 && [dbGetFTermByName $pin] ==0x0 } {
     puts "pin or port not exists"
     return 0
    } else {
	if { [dbGetTermByInstTermName $pin] ==0x0} {
	    if { [get_attribute [get_ports $pin] direction] == "out" } {
		return 1
	    } else {
		return 0
	    }
	} else {
	    if { [get_attribute [get_pins $pin] direction] == "out" } {
		return 1
	    } else {
		return 0
	    }
	}
    }
  
}

proc is_input { pin } {
    if { [dbGetTermByInstTermName $pin] ==0x0 && [dbGetFTermByName $pin] ==0x0 } {
     puts "pin or port not exists"
     return 0
    } else {
	if { [dbGetTermByInstTermName $pin] ==0x0} {
	    if { [get_attribute [get_ports $pin] direction] == "in" } {
		return 1
	    } else {
		return 0
	    }
	} else {
	    if { [get_attribute [get_pins $pin] direction] == "in" } {
		return 1
	    } else {
		return 0
	    }
	}
    }

}

proc is_clock { net } {
    if {[dbGetNetByName $net] ==0x0} {
	return "$net not exist"
    } else {
	set net_ptr [dbGetNetByName $net]
	set is_clk [dbGet $net_ptr.isCTSClock]
	return $is_clk
    }

}

proc select_input { } {
    deselectAll
    selectPin [dbGet [dbGet top.terms {.isInput==1}].name]
}
proc select_output { } {
    deselectAll
    selectPin [dbGet [dbGet top.terms {.isOutput==1}].name]
}


proc show_clk_high_fanout { count } {
    set nets [dbGet [dbGet top.nets {.numInputTerms >$count && .isCTSClock==1 && .isPwrOrGnd==0} ].name]
    set total [llength $nets]
    if {[array exists b]} {array unset b}
    foreach aa $nets {
    set aa1 [dbGetNetByName $aa]
    set nu [dbGet $aa1.numInputTerms]
    if { [info exists b($nu)]} {
       lappend b($nu) $aa
    } else {
       set b($nu) $aa
    }
    }
    puts "fanout\tnet_name"
    foreach index [lsort -n -decreasing [array names b]] {
        foreach net_name $b($index) {
          puts "$index\t$net_name"
        }
    }
    puts "****total $total nets fanout > $count****"
}

proc show_high_fanout { count } {
    set nets [dbGet [dbGet top.nets {.numInputTerms >$count && .isClock==0 && .isPwrOrGnd==0} ].name]
    set total [llength $nets]
    if {[array exists b]} {array unset b}
    foreach aa $nets {
    set aa1 [dbGetNetByName $aa]
    set nu [dbGet $aa1.numInputTerms]
    if { [info exists b($nu)]} {
       lappend b($nu) $aa
    } else {
       set b($nu) $aa
    }
    }
    puts "fanout\tnet_name"
    foreach index [lsort -n -decreasing [array names b]] {
         foreach net_name $b($index) {
          puts "$index\t$net_name"
         }
    }
    puts "****total $total nets fanout > $count****"
}
proc trace_f { pin } {
    global last_tmp
    global depth
    global net_list
    global fanout
    global max_level
    global reg_list
    set depth 0
    set fanout 0
    set max_level 0
    if {[info exist reg_list]} {unset reg_list}
    if {[info exist net_list]} {unset net_list}
    if { [dbGetTermByInstTermName $pin] !=0x0 && [get_attribute [get_pins $pin] direction] == "out" } {
	puts "pin=$pin loading is"
	trace_cell_f $pin $depth
	puts "***max_fanout=$fanout*** ***max_level=$max_level***"
    } elseif { [dbGetTermByInstTermName $pin]== 0x0 } {
	puts "error!!! $pin not exists"
    } elseif { [get_attribute [get_pins $pin] direction] != "out"} {
	puts "error!!! $pin not output_pin, please give output_pin"
    }

}

proc trace_cell_f {pin depth} {
    global last_tmp
    global fanout
    global net_list
    global max_level
    global reg_list
  #  set reg "^SDFF|^MP|^SYN|^RA|^SRAM|^LAT|^RF|^HS|^TWGDSKA"
  #  set clkgate_pattern "^SELAT|^SEGATE|^L1GATE|^PREICG|^FRICG"
    set reg "SDFF|MP|SYN|RA|SRAM|RF|HS|TWGDSKA"
    set clkgate_pattern "SELAT|SEGATE|L1GATE|PREICG|FRICG|CKGPRELAT|LATNQX"
    #set net [get_attribute [get_pins $pin] net_name]
    set net [dbGet [dbGetTermByInstTermName $pin].net.name]
    if { [regexp {VSS|VDD|VCS} $net]} {
	set last_tmp [format "%-${depth}s%s" " " "${depth}*** net=$net **** "]
	puts $last_tmp
	return
    }

    set next_pins [get_property [get_attribute [get_nets $net] load_pins] full_name]
    if { [info exist net_list($net)] } {
	set net_load_count [ get_attribute [get_nets $net] num_load_pins]
	set last_tmp [format "%-${depth}s%s" " " " ${depth}*** net=$net loading count= ${net_load_count}; loading have been explored ***"]
	puts $last_tmp
	return
    
    } else {
	set net_list($net) ""
    }
    incr depth
    if { $max_level < $depth } {
	set max_level $depth
    }
    foreach next_pin $next_pins {
	set type [dbGet [dbGetObjByName $next_pin].objType]
    	if { [regexp term $type]} {
	      set last_tmp [format "%s%-${depth}s%s" $depth " " "$next_pin term"]
	      puts $last_tmp
	      return
    	}
	set next_pin_name [get_attribute [get_pins $next_pin] ref_lib_pin_name]
	set cell_name [dbGet [dbGetTermByInstTermName $next_pin].inst.name]
	set lib_name [get_attribute [get_cells $cell_name] ref_lib_cell_name]
	set is_seq 0
	if { [regexp $reg $lib_name] } {
	    set is_seq 1
	} elseif { [regexp $clkgate_pattern $lib_name] } {
	    set is_seq 0 ; # "set 1 stop at PREICG,set 0 can get PREICG following Reg"
	} 
	set nexouts [dbget [dbget [dbGetInstByName [lindex $cell_name 0]].instTerms {.isOutput==1}].name]
	if {$is_seq==0 } {
	    foreach nextout_pin $nexouts {
			set next_out_pin [get_attribute [get_pins $nextout_pin] ref_lib_pin_name]
		set last_tmp [format "%s%-${depth}s%s" $depth " " "$cell_name $next_pin_name $lib_name --> $next_out_pin" ]
		puts $last_tmp
		trace_cell_f $nextout_pin $depth
	    }
	}
	if { $is_seq>=1 } {
	    set last_tmp [format "%s%-${depth}s%s" $depth " " "$cell_name  $next_pin_name $lib_name (bounding cell)"]
	    puts $last_tmp
	    if { ![info exists reg_list($cell_name)] } {
		set reg_list($cell_name) " "
		incr fanout
	    }

	}
    }

}

proc trace_b { pin } {
    global  last_tmp
    global  depth
    global  fanin
    global  max_level
    global  net_list
    global  reg_list
    if { [info exist net_list] } {unset net_list}
    if { [info exist reg_list] } {unset reg_list}
    set depth 0
    set fanin 0
    set max_level 0
    if { [dbGetTermByInstTermName $pin] !=0x0 && [dbGet [dbGetTermByInstTermName $pin].isInput] } {
	puts "pin=$pin sources is"
	trace_cell_b $pin $depth
	puts "***fanin=$fanin*** ***max_level=$max_level***"
    } elseif { [dbGetTermByInstTermName $pin] ==0x0 } {
	puts "error!!! $pin not exists"
    } elseif { get_attribute [get_pins $pin] direction] != "in" } {
	puts "error!!! $pin not input_pin,please give input_pin"
    }

}

proc trace_cell_b { pin depth } {
    global last_tmp
    global fanin
    global max_level
    global net_list
    global reg_list
    set reg "^SDFF|^MP|^SYN|^RA|^SRAM|^LAT|^RF|^HS|^TWGDSKA"
    set clkgate_pattern "^SELAT|^SEGATE|^L1GATE|^PREICG|^FRICG"
    #set net [get_attribute [get_pins $pin] net_name]
    set net [dbGet [dbGetTermByInstTermName $pin].net.name]
    set net [lindex $net 0]
    if { [regexp {VSS|VDD|VCS} $net]} {
	set last_tmp [format "%-${depth}s%s" " " "${depth}*** net=$net **** "]
	puts $last_tmp
	return
    }
    if { [info exists net_list($net)] } {
	set net_load_count [get_attribute [get_nets $net] num_load_pins]
	set last_tmp [format "%-${depth}s%s" " " "${depth}*** net=$net loading count=${net_load_count};fanin have been explored"]
	puts $last_tmp
	return
	
    } else {
	set net_list($net) ""
    }
    set source_pins [get_property [get_attribute [get_nets $net] driver_pins] full_name]
    incr depth
    if { $max_level < $depth } {
	set max_level $depth
    }
    set type [dbGet [dbGetObjByName $source_pins].objType]
    if { [regexp term $type]} {
	set last_tmp [format "%s%-${depth}s%s" $depth " " "$source_pins $type"]
	puts $last_tmp
	return
    }
    set pin_name [get_attribute [get_pins $source_pins] ref_lib_pin_name]
    set cell_name [lindex [dbGet [dbGetTermByInstTermName $source_pins].inst.name] 0]
    set lib_name [dbGet [dbGetInstByName $cell_name].cell.name]
    set is_seq 0
    if { [regexp $reg $lib_name] } {
	    set is_seq 1
	} elseif { [regexp $clkgate_pattern $lib_name] } {
	    set is_seq 0 ; # "set 1 stop at PREICG,set 0 can get PREICG before Reg"
    } 
    set b_pins [dbget [dbget [dbGetInstByName $cell_name].instTerms {.isinput==1}].name]
  # echo $b_pins
    if { $is_seq==0 } {
	foreach b_pin $b_pins {
	    set b_pin_name [get_attribute [get_pins $b_pin] ref_lib_pin_name]
	    set last_tmp [format "%s%-${depth}s%s" $depth " " "$cell_name  $b_pin_name $lib_name -->$pin_name"]
	    puts $last_tmp
	    trace_cell_b $b_pin $depth
	}
    }
    if { $is_seq >=1 } {
	set last_tmp [format "%s%-${depth}s%s" $depth " " "$cell_name $pin_name $lib_name bounding cell"] 
	puts $last_tmp
	if { ![info exists reg_list($cell_name)] } {
	    set reg_list($cell_name) " "
	    incr fanin
	}
    }

}

###check_co
proc select_level_macro { pin level } {
    set cells [all_fanout -endpoints_only -only_cells -from $pin]


}




### 
source /home/jsong3/Useful/parse_arg.tcl

proc test { args } {
    define_proc_args -info test \
    -define_args {
	{-start "" string required}
	{-stop_cell "" string optional}
    }
    set a [dbGetInstByName $start]
    puts $a

}

proc synchr_rebind { cells } {
    setEcoMode -updateTiming false
    setEcoMode -honorDontTouch false
    setEcoMode -honorDontUse false
    setEcoMode -refinePlace false
    setEcoMode -LEQCheck false
    foreach cell $cells {
	set type [get_property [get_cells $cell] ref_lib_cell_name]
	if { [regexp {T[HRL]_} $type]} {
	    regsub {T[HRL]_} $type  TSL_ new_type
	    ecoChangeCell -inst $cell -cell $new_type
	}
    }
    setEcoMode -updateTiming true
    setEcoMode -honorDontTouch true
    setEcoMode -honorDontUse true
    setEcoMode -refinePlace true
    setEcoMode -LEQCheck true
}

proc route_nets_clk { net } {
deselectAll
selectNet $net
setAttribute -net $net -skip_routing false
setNanoRouteMode -routeSelectedNetOnly true
ecoRoute
setAttribute -net $net -skip_routing true
set_dont_touch $net true
setNanoRouteMode -routeSelectedNetOnly false
setAttribute -net $net -skip_routing true
}
proc route_nets { net } {
deselectAll
selectNet $net
setAttribute -net $net -skip_routing false
setNanoRouteMode -routeSelectedNetOnly true
ecoRoute
setAttribute -net $net -skip_routing true
set_dont_touch $net false
setNanoRouteMode -routeSelectedNetOnly false
}

proc fix_plate_drc { pins } {
set i 0
foreach port $pins {
	set net [dbGet [dbGet top.terms.name $port -p].net.name]
        editDelete -net $net
	set port [dbGet top.terms.name $port -p]
	set side [dbGet $port.side]
	set llx [dbGet $port.pt_x]
	set lly [dbGet $port.pt_y]
	set width 1.2
	set length 1.5
	incr i 
		if {$side == "South"} {
			createRouteBlk -name Plate_Protection_$i -layer {K3 H1} -box " [expr $llx - $width] $lly [expr $llx + $width] [expr $length +$lly]"
		}
		if {$side == "North"} {
			createRouteBlk -name Plate_Protection_$i -layer {K3 H1} -box "[expr $llx - $width] [expr $lly - $length] [expr $llx + $width] $lly "
		}
		if {$side == "East"} {
			createRouteBlk -name Plate_Protection_$i -layer {K3 H1} -box "0 [expr $lly-$width] $length [expr $lly + $width]"
		}
		if {$side == "West"} {
			createRouteBlk -name Plate_Protection_$i -layer {K3 H1} -box "[expr $llx - $length]  [expr $lly - $width] $llx [expr $lly + $width]"
		}
}

set layers "K3 H1"
foreach layer $layers {
#set a_box {{0 0 0 0 }}
	set a_box ""
	foreach b_box [lsort [dbGet [dbGet [dbGet top.fPlan.rBlkgs.layer.name $layer -p2].name Plate_Protection* -p].boxes]] {
			set c_box [dbShape $a_box OR $b_box ]
			set a_box $c_box
	}
}
       deleteRouteBlk -name Plate_Protection*
 set j 0
 foreach box $a_box {
             	createRouteBlk -name Plate_Protection_$j -layer {K3 H1} -box $box
             	puts "INFO : createRouteBlk -name Plate_Protection_$j -layer {K3 H1} -box {$box}"
			incr j
 }
}

proc trace_mem_f { mem } {
    set ptr [dbGetInstByName $mem]
    set outptr [dbGet [dbGet $ptr.instTerms {.isOutput==1} ].name -u ]
    foreach out $outptr {
    trace_f $out
    }
}
proc trace_mem_b { mem } {
    set ptr [dbGetInstByName $mem]
    set inptr [dbGet [dbGet $ptr.instTerms {.isInput==1} ].name -u ]
    foreach in $inptr {
    trace_b $in
    }
}


proc rptf {pin} {
        report_timing -from $pin 
}

proc rptt {pin} {
        report_timing -to $pin
}

proc si {inst} {
        deselectAll
        selectInst $inst
}

proc sc {cell} {
        deselectAll
        selectInstByCellName $cell 
}

proc name {} {
        dbGet selected.name
}

proc refname {} {
        dbGet selected.cell.name
}
