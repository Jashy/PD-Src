proc ISOLATE_MEMORY {args} {
#     set design my_design -- top level design
#     set lib_cell bufxxx -- buffer for input and output pin of memory 
#     set pin_name address0 -- pin location to place buffer
    
    set iso_string ISO_PORT 
    parse_proc_arguments -args $args results
    set lib_cell $results(-lib_cell)
    set pin_name $results(-pin_name)
    set iso_string $results(-iso_string)

    set pin_direction [get_attribute [get_pin $pin_name] direction]

# find pins:
    set pin_in [get_lib_pins $lib_cell/* -filter "pin_direction == in"]
    set pin_out [get_lib_pins $lib_cell/* -filter "pin_direction == out"]
    set pin_in_name [get_attribute $pin_in name]
    set pin_out_name [get_attribute $pin_out name]

# insert iso buffer into floating input pin, but not floating output pin 
    set pin_net_name [all_connected [get_pins $pin_name]]
    set pin_list [all_connected [get_net $pin_net_name]]
    set pin_list [remove_from_collection $pin_list [get_pins $pin_name]]
    if { ($pin_direction == "out") && ([sizeof_collection $pin_list] == 0) } {
      echo "*****************************************"
      echo "Warning: no isolation buffer for floating output pin of memory !" 
      return 
    }

# create cell and nets
    echo "*****************************************"
    echo "Insert cell $lib_cell to $pin_direction pin $pin_name"
    #set memory_base_name [join [list [lindex [split $pin_name "/" ] end-1] [lindex [split $pin_name "/" ] end] ] "_"]
    #set net_name [format "%s_n_%s" $memory_base_name $iso_string]
    #set cell_name [format "%s_i_%s" $memory_base_name $iso_string]
    if { [regexp {\[} $pin_name] } {
    	regsub {\/(\w+)\[(\d+)\]} $pin_name {_\1_\2} memory_base_name
    } else {
	regsub {\/(\w+)$} $pin_name {_\1} memory_base_name
    }
    puts "## memory base name: $memory_base_name"
    set net_name [format "%s_n_%s" $memory_base_name $iso_string]
    set cell_name [format "%s_i_%s" $memory_base_name $iso_string]
    create_cell $cell_name $lib_cell
    set_dont_touch $cell_name true
    create_net $net_name

    if {$pin_direction == "in"} {
	connect_net $net_name [get_pin $cell_name/$pin_in_name]
    } else {
	connect_net $net_name [get_pin $cell_name/$pin_out_name]
    }

    disconnect_net $pin_net_name [get_pins $pin_list] 
    connect_net $net_name [get_pins $pin_list] 
    if {$pin_direction == "in"} {
	connect_net $pin_net_name [get_pins $cell_name/$pin_out_name]
    } else {
	connect_net $pin_net_name [get_pins $cell_name/$pin_in_name]
    }

    set location_x [lindex [get_location [get_pins $pin_name]] 0]
    set location_y [lindex [get_location [get_pins $pin_name]] 1]

    set coordinates1 [concat $location_x $location_y]
    set_cell_location -coordinate $coordinates1 [get_cell $cell_name]

#    echo "die coordinates are (llx, lly, urx, ury): $die_llx $die_lly $die_urx $die_ury"
#    echo "bound coordinates are (llx, lly, urx, ury): $coordinates_bound"
#    echo "pin coordindates are (x, y): $location_x $location_y"
	echo $cell_name
	echo [get_location [get_cell $cell_name]]
	set_dont_touch [get_cells $cell_name]
        set_dont_touch_placement [get_cells $cell_name]
	set_dont_touch [get_nets $pin_net_name]
}

define_proc_attributes ISOLATE_MEMORY \
  -info "Places input & output buffers" \
  -define_args \
  {
    {-lib_cell "library name for input buffer" "" string required}
    {-pin_name "pin name" "" string required}
    {-iso_string "ISO string" "" string optional}
}

# example
# 

