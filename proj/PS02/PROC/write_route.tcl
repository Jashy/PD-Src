change_selection [get_net_shapes -filter {route_type == "P/G Strap" && (layer == "M5"||layer == "M6")}]
write_route -output vddvss.tcl -objects [get_selection]

