proc ISOLATE_PORT {args} {
#     set design my_design -- top level design
#     set lib_cell bufxxx -- buffer for input and output ports
#     set port_name address0 -- port location to place buffer
    
    set iso_string ISO_PORT 
    parse_proc_arguments -args $args results
    set lib_cell $results(-lib_cell)
    set port_name $results(-port_name)
    set iso_string $results(-iso_string)

    set port_direction [get_attribute [get_port $port_name] direction]

# find pins:
    set pin_in [get_lib_pins $lib_cell/* -filter "pin_direction == in"]
    set pin_out [get_lib_pins $lib_cell/* -filter "pin_direction == out"]
    set pin_in_name [get_attribute $pin_in name]
    set pin_out_name [get_attribute $pin_out name]

    set port_net_name [all_connected [get_port $port_name]]
    set pin_list [all_connected [get_net $port_net_name]]
    set pin_list [remove_from_collection $pin_list [get_port $port_name]]

# if port is floating , return 
    if { [sizeof_collection $pin_list] == 0 } {
      echo "*****************************************"
      echo "the port $port_name is a floating port"
      echo "no isolation buffer insertion"
      return 
    }

# create cell and nets
    echo "*****************************************"
    echo "Insert cell $lib_cell to $port_direction port $port_name"
    set net_name [format "%s_n_%s" $port_name $iso_string ]
    set cell_name [format "%s_i_%s" $port_name $iso_string ]
    echo "cell name : $cell_name"
    create_cell $cell_name $lib_cell
    set_dont_touch $cell_name true
    create_net $net_name

    if {$port_direction == "in"} {
	connect_net $net_name [get_pin $cell_name/$pin_out_name]
    } else {
	connect_net $net_name [get_pin $cell_name/$pin_in_name]
    }

    disconnect_net $port_net_name [get_pin $pin_list] 
    connect_net $net_name [get_pin $pin_list] 
    if {$port_direction == "in"} {
	connect_net $port_net_name [get_pin $cell_name/$pin_in_name]
    } else {
	connect_net $port_net_name [get_pin $cell_name/$pin_out_name]
    }

    set location_x [lindex [get_location [get_port $port_name]] 0]
    set location_y [lindex [get_location [get_port $port_name]] 1]

    set coordinates1 [concat $location_x $location_y]
    set_cell_location -coordinate $coordinates1 [get_cell $cell_name]

#    echo "die coordinates are (llx, lly, urx, ury): $die_llx $die_lly $die_urx $die_ury"
#    echo "bound coordinates are (llx, lly, urx, ury): $coordinates_bound"
#    echo "port coordindates are (x, y): $location_x $location_y"
	echo $cell_name
	echo [get_location [get_cell $cell_name]]
	set_dont_touch [get_cells $cell_name]
	set_dont_touch [get_nets $port_net_name]
}

define_proc_attributes ISOLATE_PORT \
  -info "Places input & output buffers" \
  -define_args \
  {
    {-lib_cell "library name for input buffer" "" string required}
    {-port_name "port name" "" string required}
    {-iso_string "ISO string" "" string optional}
}

# usage example
#foreach_in_collection port $all_data_inputs {
#  set port_name [get_attribute $port full_name]
#  ISOLATE_PORT -lib_cell ss_1v08_125c/BUFX8HS -iso_string ISO_PORT -port_name $port_name
#}

