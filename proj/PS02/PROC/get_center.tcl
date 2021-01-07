proc get_center {args} {
	set pin  [ lindex $args 0]

	if { [ llength [get_flat_pins $pin -q ]] == 0 } {
		puts "Error: $pin not exist!"
		break
	}
	#set pin_location [lindex [get_attribute [get_pins $pin] bbox] 0]
	set load_pins [get_flat_pins -of [get_flat_nets -of $pin] -filter direction==in]
	set num 0
	set x 0
	set y 0
	foreach_in_collection p [get_flat_pins $load_pins] {
		incr num
		set pin_location [lindex [get_attribute [get_pins $p] bbox] 0]
		set x [expr $x + [lindex $pin_location 0]]
		set y [expr $y + [lindex $pin_location 1]]
	}
	set x [expr $x/$num]
	set y [expr $y/$num]
	set pin_location "$x $y"
	return  $pin_location
}
