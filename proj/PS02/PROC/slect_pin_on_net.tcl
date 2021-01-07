proc select_pin_on_net {net} {
	change_selection [get_pins  -of_objects $net -leaf ]
}
alias net_pin select_pin_on_net
