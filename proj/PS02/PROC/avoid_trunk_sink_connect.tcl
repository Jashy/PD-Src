  define_routing_rule double_spacing -multiplier_spacing 2

  mark_clock_tree -clock_net
  mark_clock_tree -routing_rule double_spacing

  foreach_in_collection cell [ get_cells * -hier -filter "full_name =~ *_FB_L3_DRIVE01" ] {
    set outpin [ get_pins -of $cell -filter "direction == out" ]
    set fbnet  [ get_nets -of $outpin ]
    set fbnet_name [ get_attr $fbnet full_name ]
    set_attr $fbnet net_type "Clock"
    puts "*INFO* set_route_type on $fbnet_name"
    set_route_type -clock strap [ get_net_shapes -of_objects $fbnet_name ]
    set_route_type -clock strap [ get_vias -of_objects $fbnet_name ]
    set_net_routing_rule -rule double_spacing $fbnet_name
  }

  ######################################################################
  # CLOCK ROUTING OPTION
  #

  set_delay_calculation -clock_arnoldi

  set_route_zrt_global -clock_topology comb -comb_distance 4

  ############### change fishbone trunk and via names
    set fbnets [ get_nets -of [ get_pins -of [ get_cells * -hier -filter "full_name =~ *_FB_L3_DRIVE01" ] -filter "direction == out" ] ]
    foreach_in_collection fbnet $fbnets {
      set net_name [ get_attr $fbnet full_name ]
      create_net ${net_name}_tmp_driver_connection
      foreach_in_collection drive [ get_drivers $net_name ] {
        disconnect_net $net_name $drive
        connect_net ${net_name}_tmp_driver_connection $drive
      }
      set vias [ get_vias -of $fbnet -quiet ]
      set shapes [ get_net_shapes -of $fbnet -quiet -filter "width > 1 "]
      set owner_net [ lindex [ get_attr $shapes owner_net ] 0 ]
      create_net ${owner_net}_tmp_clock_rte
      set_attr $shapes owner_net ${owner_net}_tmp_clock_rte
      set_attr $vias owner_net ${owner_net}_tmp_clock_rte
    }

    ######## route
    route_zrt_group -max_detail_route_iterations 10 -all_clock_nets

    ############### recover fishbone trunk and via names
    set tmp_nets [ get_nets * -hier -filter "full_name =~ *_tmp_clock_rte " ]
    foreach tmp_net [ get_object_name $tmp_nets ] {
      set shapes [ get_net_shapes -of $tmp_net ]
      set vias   [ get_vias -of $tmp_net ]
      set owner_net [ lindex [ get_attr $shapes owner_net ] 0 ]
      regexp {^(\S+)_tmp_clock_rte$} $owner_net "" owner_net
      set_attr $shapes owner_net ${owner_net}
      set_attr $vias   owner_net ${owner_net}
      remove_net $tmp_net
    }
    set tmp_nets [ get_nets * -hier -filter "full_name =~ *_tmp_driver_connection " ]
    foreach tmp_net [ get_object_name $tmp_nets ] {
      set net_name [ get_attr $tmp_net full_name ]
      regexp {^(\S+)_tmp_driver_connection$} $net_name "" net_name
      foreach_in_collection drive [ get_drivers $tmp_net ] {
        disconnect_net $tmp_net $drive
        connect_net $net_name $drive
      }
      remove_net $tmp_net
    }


