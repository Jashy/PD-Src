change_selection [get_net_shapes -filter {route_type == "P/G Strap"&&layer ==C7}]
convert_wire_to_pin -net_names {VDD VSS} [get_selection]
create_macro_fram -cell_name {hce} -extract_blockage_by_merge_with_threshold {C7 1 1}

