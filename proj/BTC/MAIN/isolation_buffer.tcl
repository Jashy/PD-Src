set ECO_STRING ALCP_ISO_IN
set ISO_IN_TYPE  BUF_X6N_A9PP84TL_C14
set ISO_OUT_TYPE BUF_X6N_A9PP84TL_C14

if { [ sizeof_coll [ get_cells *ISO_BUF* -hier -quiet ] ] == 0 } {
  foreach_in_coll port [ get_ports * -filter "port_direction == in" ] {
    if { [ sizeof_collection [ get_nets -of $port -quiet ] ] == 0 } { continue }
    if { [ sizeof_collection [ get_loads [ get_nets -of $port ] ] ] == 0 } { continue }
    set port_name [ get_attr $port full_name ]
    set iso_cell ${port_name}_${ECO_STRING}_U0
    set iso_net  ${port_name}_${ECO_STRING}_n0
    create_cell $iso_cell [ index_collection [ get_lib_cells */$ISO_IN_TYPE ] 0 ]
    create_net  $iso_net
    connect_net $iso_net $iso_cell/Y
    foreach_in_coll pin [ get_pins -of $port_name ] {
      disconnect_net $port_name $pin
      connect_net    $iso_net $pin
    } 
    connect_net $port_name $iso_cell/A
  }
  set ECO_STRING ALCP_ISO_OUT
  foreach_in_coll port [ get_ports * -filter "port_direction == out" ] {
    if { [ sizeof_collection [ get_nets -of $port -quiet ] ] == 0 } { continue }
    if { [ sizeof_collection [ get_drivers [ get_nets -of $port ] ] ] == 0 } { continue }
    set port_name [ get_attr $port full_name ]
    set iso_cell ${port_name}_${ECO_STRING}_U0
    set iso_net  ${port_name}_${ECO_STRING}_n0
    create_cell $iso_cell [ index_collection [ get_lib_cells */$ISO_OUT_TYPE ] 0 ]
    create_net  $iso_net
    connect_net $iso_net $iso_cell/A
    foreach_in_coll pin [ get_pins -of $port_name ] {
      disconnect_net $port_name $pin
      connect_net    $iso_net $pin
    }
    connect_net $port_name $iso_cell/Y
  }
}

set_size_only [ get_cells *ALCP_ISO* -hier ]
set_dont_touch [ get_cells *ALCP_ISO* -hier ]
magnet_placement [ get_ports * -filter "port_direction == out" ] -mark_fixed
magnet_placement [ get_ports * -filter "port_direction == in" ] -mark_fixed
set_timing_weights -effort high [ get_nets -of [ get_ports * ] ]
set_dont_touch  [ get_nets -of [ get_ports * ] ]

