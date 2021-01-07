proc NET_DRV {net} {
	return [get_pins -leaf -of_objects $net -filter "direction == out && is_hierarchical == false"]
}
