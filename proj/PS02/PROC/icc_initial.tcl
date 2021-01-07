########################################################################
# ICC USER DEFINED UTILITIES
#

source /user/home/danielw/tools/tcl_icc/alcpIccFb.tcl
source /user/home/danielw/tools/tcl_icc/N2N_ICC/CHANGE_CELL.tcl    
source /user/home/danielw/tools/tcl_icc/N2N_ICC/REMOVE_INVERTER.tcl
source /user/home/danielw/tools/tcl_icc/N2N_ICC/INSERT_BUFFER.tcl  
source /user/home/danielw/tools/tcl_icc/N2N_ICC/REWIRE.tcl
source /user/home/danielw/tools/tcl_icc/N2N_ICC/REMOVE_BUFFER.tcl 
source /user/home/danielw/tools/tcl_icc/N2N_ICC/SPLIT_NET.tcl
source /user/home/danielw/.timing.tcl

# get_ideal_nets for SIGS
proc get_ideal_nets { threshold } {
   set high_fanout_nets [all_high_fanout -nets -threshold $threshold]
   foreach_in_collection net $high_fanout_nets {
	set net_name [get_attr $net full_name]
	set fanout_number [sizeof_collection [get_pins -leaf -of $net_name]]
	echo "##$fanout_number  $net_name"
	echo "set_load -net $net_name 0.200p"
	echo "set_slew -net $net_name 0.500n"
   }
}

proc alcp_hilite_net { net_name } {
        change_selection [get_vias -of_objects $net_name]
        change_selection [get_net_shapes -of_objects $net_name] -add
        hilight [get_selection] red 1
        change_selection

        set all_load_pins [get_pins -of $net_name -leaf -filter "direction == in"]
        hilight [get_cells -of $all_load_pins] blue 1

        set all_driver_pins [get_pins -of $net_name -leaf -filter "direction == out"]
        hilight [get_cells -of $all_driver_pins] purple 1

}


##aliases
alias st  	"source ../tcl/design_settings.tcl"
alias op	"source ../tcl/open.tcl"
alias ol	"open_mw_lib"
alias oc	"open_mw_cel"


proc selectInst { instName } {
	change_selection [get_flat_cells -quiet $instName]
	foreach_in_collection inst [get_selection] {
		set fullName [get_attr $inst full_name]
		set refName [get_attr $inst ref_name]
		puts "$refName:	$fullName"
	}
	set number [sizeof_collection [get_selection]]
	puts "total selected: $number"	
}


proc selectCell { cellName } {
	puts "$cellName"
	change_selection [get_cells -all -hierarchical -filter ref_name=="$cellName"]
	set number [sizeof_collection [get_selection]]
	puts "total selected: $number"	
}
