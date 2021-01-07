set PWR_DEF GAIA.def

create_port VDD

create_port VDD1V

create_port VDD1V_MEM

create_port VSS

connect_net VDD [get_ports VDD -all]

connect_net VDD1V [get_ports VDD1V -all]

connect_net VDD1V_MEM [get_ports VDD1V_MEM -all]

connect_net VSS [get_ports VSS -all]


write_def -rows_tracks_gcells -vias -all_vias -regions_groups -components -pins -blockages -floating_metal_fill -nets -diode_pins -specialnets -notch_gap -pg_metal_fill -scanchain -output ./$PWR_DEF -nondefault_rule -compressed
