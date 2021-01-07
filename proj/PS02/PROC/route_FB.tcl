### classical FB routing
set_ignored_layers -max_routing_layer $MAX_ROUTING_LAYER
set_droute_options -name hardMaxLayerConx -value 2
set_route_mode_options -zroute false
set_route_options  -groute_clock_routing comb
set_parameter -name combMaxConnections -module groute -type int -value 5
route_group -all_clock_nets -num_cpus 4
