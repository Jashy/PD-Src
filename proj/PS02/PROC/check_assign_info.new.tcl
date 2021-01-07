
proc get_hier_cell { module } {
	set hcell [get_cells * -hier -filter "ref_name == $module"]
	return [get_attribute $hcell full_name]
}

proc remove_assign_one_is_top_net { pinA pinB } {
	set tnet [get_nets $pinA -top]
	set tnet_name [get_attribute $tnet full_name]
	#set pinA_net_name [get_attribute [get_nets -of [get_pins $pinA]] full_name]
	#set pinB_net_name [get_attribute [get_nets -of [get_pins $pinB]] full_name]
	if { $tnet_name eq $pinA } {
        	echo "\t\tCommand-3: set Bloading \[get_pins -of \[get_nets -of \[get_pins $pinB\]\] -filter \"full_name != $pinB\"\]"
        	echo "\t\tCommand-3: disconnect_net \[get_nets -of \[get_pins $pinB\]\] \$Bloading"
        	echo "\t\tCommand-3: connect_net \[get_nets -of \[get_pins $pinA\]\] \$Bloading"
        	echo "\t\tCommand-3: disconnect_net \[get_nets $pinA\] \[get_pins $pinB\]"
		echo "\t\tKeeping: $pinA"
        	#echo "\t\tCommand: remove_port \[get_pins $pinB\]"
	} elseif { $tnet_name eq $pinB } {
        	echo "\t\tCommand-3: set Aloading \[get_pins -of \[get_nets -of \[get_pins $pinA\]\] -filter \"full_name != $pinA\"\]"
        	echo "\t\tCommand-3: disconnect_net \[get_nets -of \[get_pins $pinA\]\] \$Aloading"
        	echo "\t\tCommand-3: connect_net \[get_nets -of \[get_pins $pinB\]\] \$Aloading"
        	echo "\t\tCommand-3: disconnect_net \[get_nets $pinB\] \[get_pins $pinA\]"
		echo "\t\tKeeping: $pinB"
        	#echo "\t\tCommand: remove_port \[get_pins $pinB\]"
	} else {
		echo "\t\tError: remove_assign_one_is_top_net"
	}

}

proc remove_assign_one_is_floating { pinA pinB } {
	echo "\t\tCommand-1: disconnect_net \[get_nets $pinB\] \[get_pins $pinA\]"
	echo "\t\tKeeping: $pinB"
}

proc remove_assign_one_is_no_fanout { pinA pinB } {
	echo "\t\tCommand-2: disconnect_net \[get_nets $pinB\] \[get_pins $pinA\]"
	echo "\t\tKeeping: $pinB"
}

proc remove_assign_feedthrough { pinA pinB } {
	echo "\t\tCommand-4: set netA \[get_nets -of \[get_pins $pinA\]\]"
	echo "\t\tCommand-4: set netB \[get_nets -of \[get_pins $pinB\]\]"
	echo "\t\tCommand-4: set loadB \[remove_from_collection \[get_pins -of \[get_nets \$netB\]\] \[get_pins $pinB\]\]"
	echo "\t\tCommand-4: disconnect_net \[get_nets \$netB\] \$loadB"
	echo "\t\tCommand-4: connect_net \[get_nets \$netA\] \$loadB"
}

proc check_assign_info { pinA pinB } {
	echo ""
	#set anet_valid [sizeof_collection [get_nets -of [get_pins $pinA] -top]]
	#set bnet_valid [sizeof_collection [get_nets -of [get_pins $pinB] -top]]
	if { ! ( [sizeof_collection [get_nets -of [get_pins $pinA] -top -quiet]] || [sizeof_collection [get_nets -of [get_pins $pinB] -top -quiet]] ) } {
		echo "No connections on two hierarchical pins"
		echo "\tFloating two hierarchical pins: $pinA , $pinB , Checking........."
		return 1
	} elseif { ! [sizeof_collection [get_nets -of [get_pins $pinB] -top -quiet]] } {
		echo "No connection on one hierarchical pin"
		echo "\tloadings are from $pinA . Floating hierarchical pin and Removing $pinA ."
		remove_assign_one_is_floating $pinB $pinA
		return 1
	} elseif { ! [sizeof_collection [get_nets -of [get_pins $pinA] -top -quiet]] } {
		echo "No connection on one hierarchical pin"
		echo "\tloadings are from $pinA . Floating hierarchical pin and Removing $pinB ."
		remove_assign_one_is_floating $pinA $pinB
		return 1
	} else {
		set anet [get_attribute [get_nets $pinA -top] full_name]
		set bnet [get_attribute [get_nets $pinB -top] full_name]
		if { $anet ne $bnet } {
			echo "Different TOP net name: $pinA: $anet, $pinB: $bnet"
			return 0
		} else {
			echo "Same TOP net name: $pinA: $anet, $pinB: $bnet"
		}
		set pinA_dir [get_attribute [get_pins $pinA] pin_direction]
		set pinB_dir [get_attribute [get_pins $pinB] pin_direction]
		if { $pinA_dir eq $pinB_dir } {
			echo "\tDirection: $pinA: $pinA_dir"
			echo "\tDirection: $pinB: $pinB_dir"
		} else {
			echo "\tFeedthrough: $pinA: $pinA_dir, $pinB: $pinB_dir"
			set topnet [get_attribute [get_nets -of $pinA -top -seg] full_name]
			echo "\tFeedthrough: Real TOP name $topnet"
			remove_assign_feedthrough $pinA $pinB
			return 0
		}
		set is_pinA_loading 0
		set is_pinB_loading 0
		if { [sizeof_collection [all_fanout -from [get_pins $pinA] -flat -pin_level 1]] > 1 } {
				set is_pinA_loading 1
		}
		if { [sizeof_collection [all_fanout -from [get_pins $pinB] -flat -pin_level 1]] > 1 } {
				set is_pinB_loading 1
		}
		if { $is_pinA_loading == 1 && $is_pinB_loading == 1 } {
			#set pinA_net_name [get_attribute [get_nets -of [get_pins $pinA]] full_name]
			#set pinB_net_name [get_attribute [get_nets -of [get_pins $pinB]] full_name]
			if { $anet eq $pinA || $bnet eq $pinB } {
				echo "\tloadings are from two hierarchical pins. One is top net. Removing another!!!!!"
				remove_assign_one_is_top_net $pinA $pinB
			} else {
				echo "\tloadings are from two hierarchical pins. No net is top net. Step into hierarchies. Carefully!!!!!!!"
			}
		} elseif { $is_pinA_loading == 1 } {
			echo "\tloadings are from $pinA . Removing $pinB ."
			remove_assign_one_is_no_fanout $pinB $pinA
			#echo "\t\tCommand: disconnect_net \[get_nets $pinA\] \[get_pins $pinB\]"
			#echo "\t\tCommand: remove_port [get_pins $pinB]"
			#echo "\t\tKeeping: $pinA"
		} elseif { $is_pinB_loading == 1 } {
			echo "\tloadings are from $pinB . Removing $pinA ."
			remove_assign_one_is_no_fanout $pinA $pinB
			#echo "\t\tCommand: disconnect_net \[get_nets $pinB\] \[get_pins $pinA\]"
			#echo "\t\tCommand: remove_port [get_pins $pinA]"
			#echo "\t\tKeeping: $pinB"
		} else { 
			echo "\tNo loadings are from two hierarchical pins. Checking or removing both $pinA and $pinB ..........."
		}
		return 1
	}
}

set TOP_NET_RTP ./check_top_net.rpt.r1
set REPORT_ONLY 0

file delete $TOP_NET_RTP

set aaa [open /user/home/nealj/pz/ICC/TOP/pezy1_wrapper.run/assign.list r]

set num 0

while { [gets $aaa line] > 0 } {
	if { [regexp {module\s+(\S+)} $line tmp module]  } {
		set hcell [get_hier_cell $module]
		echo "----- $hcell ----" >> $TOP_NET_RTP
		set num 0
	} elseif { [regexp {assign\s+(\S+)\s+=\s+(\S+).*} $line tmp pinA pinB] } {
		incr num
		set tnet_a [get_attribute [get_nets $hcell/$pinA -top] full_name]
		set tnet_b [get_attribute [get_nets $hcell/$pinB -top] full_name]
		echo "($num) $hcell/$pinA : $tnet_a" >> $TOP_NET_RTP
		echo "($num) $hcell/$pinB : $tnet_b" >> $TOP_NET_RTP
		if { $REPORT_ONLY == 0 } {
			check_assign_info $hcell/$pinA $hcell/$pinB
		}
	}
}

close $aaa
