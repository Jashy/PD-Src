## add iso cel for port

set port clk
set iso_ref BUF_X16B_A8TR

      create_cell ${port}_iso_cell $iso_ref
      create_net  ${port}_iso_cell_n0
      connect_net ${port}_iso_cell_n0 [ get_pins -of ${port}_iso_cell -filter "direction == out" ]
      
      foreach_in_collection pin [ get_pins -of [ get_nets -of $port ] -filter "pin_direction == in " ] {
        disconnect_net [ get_nets -of $port ] $pin
        connect_net    ${port}_iso_cell_n0 $pin
      }
      
      connect_net [ get_nets -of ${port} ] [ get_pins -of ${port}_iso_cell -filter "direction == in" ]

      magnet_placement $port -move_fixed -mark_fixed


set port hclk
set iso_ref BUF_X16B_A8TR

      create_cell ${port}_iso_cell $iso_ref
      create_net  ${port}_iso_cell_n0
      connect_net ${port}_iso_cell_n0 [ get_pins -of ${port}_iso_cell -filter "direction == out" ]
      
      foreach_in_collection pin [ get_pins -of [ get_nets -of $port ] -filter "pin_direction == in " ] {
        disconnect_net [ get_nets -of $port ] $pin
        connect_net    ${port}_iso_cell_n0 $pin
      }
      
      connect_net [ get_nets -of ${port} ] [ get_pins -of ${port}_iso_cell -filter "direction == in" ]

      magnet_placement $port -move_fixed -mark_fixed

