
define_name_rules verilog -check_bus_indexing -allowed {a-zA-Z0-9_} \
  -remove_internal_net_bus -flatten_multi_dimension_busses -first_restricted "\\"
change_names -rules verilog -hier -verbose

write_verilog -no_physical_only_cells -force_no_output_references {INT_R PO_RES ESD_CORNERD} ${SESSION}.run/${STEP}.v

