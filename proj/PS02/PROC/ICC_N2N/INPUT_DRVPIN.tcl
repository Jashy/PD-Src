proc INPUT_DRVPIN { input_pin } { 
	return [get_attribute [ get_pins -leaf -of_objects  [get_nets -of $input_pin ] -filter "direction == out"] full_name ]
}
