source /proj/wHydra/WORK/peter/ICC/scripts/N2N/DUPLICATE_ICG.tcl
source /proj/wHydra/WORK/peter/ICC/scripts/N2N/PIN_NET.tcl
set aaa [ get_pins *latch/Q -hier ]
foreach_in_collection x $aaa {
	if { [ sizeof_collection [ all_connected [ all_connected [ get_pins $x ] ] -leaf ]] > 3 } {
	set pinN [ get_attribute $x full_name ]
	set netN [ get_attribute [ PIN_NET $pinN ] full_name ]
	set xlen [ get_attribute [get_nets  $netN ] x_length ]
	set ylen [ get_attribute [get_nets  $netN ] y_length ]
	set length1 [ expr $xlen + $ylen ]
	set length2 [ expr $length1 / 1000.000 ]
	set drv_name [get_attribute [get_pins -leaf -of_objects [PIN_NET $pinN] -filter "direction==out"] full_name]
	echo "${length2} um $netN $drv_name" >> wire.txt
	}
}
