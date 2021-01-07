set_ignored_layers -max_routing_layer $MAX_ROUTING_LAYER
set_droute_options -name hardMaxLayerConx -value 2
set_separate_process_options -routing false -extraction false  -placement false
set_route_mode_options -zroute true
route_zrt_eco
save_mw_cel $TOP
