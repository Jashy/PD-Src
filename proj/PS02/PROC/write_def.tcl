
remove_route_guide {RG_M1#*}

define_name_rules verilog -check_bus_indexing -allowed {a-zA-Z0-9_} \
  -remove_internal_net_bus -flatten_multi_dimension_busses -first_restricted "\\"
change_names -rules verilog -hier -verbose

write_def	-components				\
		-rows_tracks_gcells			\
		-vias					\
		-regions_groups				\
		-pins					\
		-blockages				\
		-specialnets				\
		-nets					\
		-version 5.4 -unit 1000			\
		-compressed				\
		-output ${SESSION}.run/${STEP}.def

