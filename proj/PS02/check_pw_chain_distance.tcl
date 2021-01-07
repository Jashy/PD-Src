source /filer/home/lukez/timing.tcl
#proc check_pw_chain { limition 300 } {
set limition 500
set cells [get_object_name [get_flat_cells -fil "ref_name == HEADBUF16_X1M_A8TR_C34"]]
foreach cel $cells {
####### check loading cell's ref name ##
	set load_count [sizeof_collection [gl $cel/SLEEPOUT]]
	if {$load_count == 1} {
	set load [get_attr [gl $cel/SLEEPOUT] full_name]
	#set load_ref [get_attr [get_cells -of [get_pins $load]] ref_name]
	#echo "$load $load_ref" >> load_cel.info
####### check net distance ###########
	set llx [lindex [get_location [get_pins $cel/SLEEPOUT]] 0]
	set lly [lindex [get_location [get_pins $cel/SLEEPOUT]] 1]
	set load_x [lindex [get_location [get_pins $load]] 0]
	set load_y [lindex [get_location [get_pins $load]] 1]
	if { $load_x < $llx } {
		set temp_x $llx
		set $llx $load_x
		set $load_x $temp_x }
	if { $load_y < $lly } {
		set temp_y $lly
		set $lly $load_y
		set $load_y $temp_y }
	set distance [ expr [ expr $load_x - $llx ] + [ expr $load_y - $lly ] ]
	if { $distance > $limition } {
		echo "$cel need insert buf" >> load_cell.info }
}
}
