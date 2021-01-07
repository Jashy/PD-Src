#############################
# PG connections to the physical-only cells must be updated manually
# No power port connected, since VDD*/VSS* wildcard is not supporte
# The cells in the collection needs to be leaf cells. They cannot be hierarchical blocks
# remove all pg
#remove_power_domain -all
#remove_voltage_area -all
#remove_pg_network VDD -top
#remove_pg_network VSS -top
##
#check_mv_design -verbose -power_net
# pg
#derive_pg_connection -create_nets
#derive_pg_connection -reconnect
derive_pg_connection -power_net VDD -ground_net VSS -power_pin VDD -ground_pin VSS
derive_pg_connection -power_net VDD -ground_net VSS -power_pin VDD -ground_pin GND
derive_pg_connection -power_net VDD -ground_net VSS -power_pin VDD -ground_pin VSS -tie
#derive_pg_connection -verbose
# remove pg port cmd : remove_port
# disconnect net cmd : disconnect_net
# test for multiple power
#create_power_net_info VDD1 -power
#create_power_net_info VDD21 -power
#create_power_net_info VDD22 -power
#create_power_net_info VSS0 -gnd
#create_power_domain DEFAULT_VA
#create_power_domain OHV_VA -power_down -obj ...
#create_power_domain ILV_VA -power_down -obj ...
#connect_power_domain DEFAULT_VA -primary_power VDD1 -primary_ground VSS0
#derive_pg_connection -create_nets
#### tie cell pg connection
# connect_tie_cells -tie_high_lib_cell TIEH -tie_low_lib_cell TIEL -objects [get_cells -hierarchical *] -obj_type cell_inst
####
# get power nets cmd:get_nets -all VDD
# Mannual connect P/G net cmd : connect_net/disconnect_net PG_net PG_pin 
# Mannual connect Tie net cmd : connect_net/disconnect_net SNPS_LOGIC1/0 pin_name

#After the completion of each optimization step, use the derive_pg_connection command
#to update the PG connections by specifying the PG net and pin names
#	derive_pg_connection \
#	-power_net <pwrn>\
#	-ground_net <gndn>\
#	-power_pin <pwrp>\
#	-ground_pin <gndp> \
#	-cells [get_cells -of [get_voltage_area <pd>]]
#	check_mv_design -power_nets
#
#redirect -file /dev/null {
#	foreach_in_col n [get_nets -all hier VDD1] {
#		disconnect_net $n -all
#	}
#}
# get cell cmd and style cmd :1. set cells [get_cells -all -hierarchical -filter ref_name==and02]
#		2. get_cells -all -of [get_voltage_areasVA3]
#		3. get_cells {U1 U2}
#		4. get_cells ?hierarchical * -filter {mask_layout_type!= macro \
#		   and mask_layout_type!= std \
#		   and mask_layout_type!= io_pad\
#		   and mask_layout_type!= cover}

#derive_pg_connection -power_net VDD21 -power_pin VDDC -ground_net VSSC -ground_pin DSSC
#derive_pg_connection -power_net VDD22 -power_pin VDDC -ground_net VSSC -ground_pin DSSC -cells [get_cells -of [get_voltage_area $PD1]]

# add tap cell cmd: add_tap_cell_array -master_cell_name BUFX2 -distance 28 -tap_cell_identifier tap_ \
#	-pattern every_other_row -connect_power VDD1 -connect_ground VSS -voltage_area PD_CB
#report_power_net
#report_pg_net
#create_power_net_info VDD1 -power
#derive_pg_connection -create_nets

