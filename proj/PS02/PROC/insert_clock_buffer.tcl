proc insert_clock_buffer { root_pin_names } {

  proc get_structure_list { pin_count } {

    if       { $pin_count <=    50 } { set structure_list { { { CKBD24 1 } } { { CKBD24  2 } { CKND4  0 } } { { CKBD24   6 } { CKND4  0 } } }
    } elseif { $pin_count <=   100 } { set structure_list { { { CKBD24 1 } } { { CKBD24  2 } { CKND4  0 } } { { CKBD24   8 } { CKND4  0 } } }
    } elseif { $pin_count <=   150 } { set structure_list { { { CKBD24 1 } } { { CKBD24  2 } { CKND4  0 } } { { CKBD24   10} { CKND4  0 } } }
    } elseif { $pin_count <=   200 } { set structure_list { { { CKBD24 1 } } { { CKBD24  2 } { CKND4  0 } } { { CKBD24   12} { CKND4  0 } } }
    } elseif { $pin_count <=   250 } { set structure_list { { { CKBD24 1 } } { { CKBD24  3 } { CKND4  0 } } { { CKBD24   14} { CKND4  0 } } }
    } elseif { $pin_count <=   300 } { set structure_list { { { CKBD24 1 } } { { CKBD24  3 } { CKND4  0 } } { { CKBD24   16} { CKND4  0 } } }
    } elseif { $pin_count <=   400 } { set structure_list { { { CKBD24 1 } } { { CKBD24  3 } { CKND4  0 } } { { CKBD24   18} { CKND4  0 } } }
    } elseif { $pin_count <=   500 } { set structure_list { { { CKBD24 1 } } { { CKBD24  3 } { CKND4  0 } } { { CKBD24  20 } { CKND4  0 } } }
    } elseif { $pin_count <=   600 } { set structure_list { { { CKBD24 1 } } { { CKBD24  3 } { CKND4  0 } } { { CKBD24  22 } { CKND4  0 } } }
    } elseif { $pin_count <=   700 } { set structure_list { { { CKBD24 1 } } { { CKBD24  3 } { CKND4  0 } } { { CKBD24  24 } { CKND4  0 } } }
    } elseif { $pin_count <=   800 } { set structure_list { { { CKBD24 1 } } { { CKBD24  3 } { CKND4  0 } } { { CKBD24  26 } { CKND4  0 } } }
    } elseif { $pin_count <=   900 } { set structure_list { { { CKBD24 1 } } { { CKBD24  4 } { CKND4  0 } } { { CKBD24  28 } { CKND4  0 } } }
    } elseif { $pin_count <=  1000 } { set structure_list { { { CKBD24 1 } } { { CKBD24  4 } { CKND4  0 } } { { CKBD24  30 } { CKND4  0 } } }
    } elseif { $pin_count <=  1100 } { set structure_list { { { CKBD24 1 } } { { CKBD24  4 } { CKND4  0 } } { { CKBD24  32 } { CKND4  0 } } }
    } elseif { $pin_count <=  1200 } { set structure_list { { { CKBD24 1 } } { { CKBD24  4 } { CKND4  0 } } { { CKBD24  34 } { CKND4  0 } } }
    } elseif { $pin_count <=  1300  } { set structure_list { { { CKBD24 1 } } { { CKBD24  4 } { CKND4  0 } } { { CKBD24 36 } { CKND4  0 } } }
    } elseif { $pin_count <=  1400 } { set structure_list { { { CKBD24 1 } } { { CKBD24  5 } { CKND4  0 } } { { CKBD24  38 } { CKND4  0 } } }
    } elseif { $pin_count <=  1600  } { set structure_list { { { CKBD24 1 } } { { CKBD24  5 } { CKND4  0 } } { { CKBD24  40 } { CKND4  0 } } }
    } elseif { $pin_count <=  1800 } { set structure_list { { { CKBD24 1 } } { { CKBD24  5 } { CKND4  0 } } { { CKBD24  44 } { CKND4  0 } } }
    } elseif { $pin_count <=  2000 } { set structure_list { { { CKBD24 1 } } { { CKBD24  5 } { CKND4  0 } } { { CKBD24  48 } { CKND4  0 } } }
    } elseif { $pin_count <=  2500 } { set structure_list { { { CKBD24 1 } } { { CKBD24  6 } { CKND4  0 } } { { CKBD24  54 } { CKND4  0 } } }
    } elseif { $pin_count <=  3000 } { set structure_list { { { CKBD24 1 } } { { CKBD24  7 } { CKND4  0 } } { { CKBD24  60 } { CKND4  0 } } }
    } elseif { $pin_count <=  3500 } { set structure_list { { { CKBD24 1 } } { { CKBD24  7 } { CKND4  0 } } { { CKBD24  66 } { CKND4  0 } } }
    } elseif { $pin_count <=  4000 } { set structure_list { { { CKBD24 1 } } { { CKBD24  8 } { CKND4  0 } } { { CKBD24  76 } { CKND4  0 } } }
    } elseif { $pin_count <=  6000 } { set structure_list { { { CKBD24 1 } } { { CKBD24  9 } { CKND4  0 } } { { CKBD24  86 } { CKND4  0 } } }
    } elseif { $pin_count <=  8000 } { set structure_list { { { CKBD24 1 } } { { CKBD24 10 } { CKND4  0 } } { { CKBD24  96 } { CKND4  0 } } }
    } elseif { $pin_count <= 10000 } { set structure_list { { { CKBD24 1 } } { { CKBD24 12 } { CKND4  0 } } { { CKBD24 120 } { CKND4  0 } } }
    } elseif { $pin_count <= 15000 } { set structure_list { { { CKBD24 1 } } { { CKBD24 14 } { CKND4  0 } } { { CKBD24 140 } { CKND4  0 } } }
    } elseif { $pin_count <= 20000 } { set structure_list { { { CKBD24 1 } } { { CKBD24 16 } { CKND4  0 } } { { CKBD24 160 } { CKND4  0 } } }
    } elseif { $pin_count <= 30000 } { set structure_list { { { CKBD24 1 } } { { CKBD24 20 } { CKND4  0 } } { { CKBD24 200 } { CKND4  0 } } }
    } elseif { $pin_count <= 40000 } { set structure_list { { { CKBD24 1 } } { { CKBD24 24 } { CKND4  0 } } { { CKBD24 200 } { CKND4  0 } } }
    } else                          {
      puts "Not supported pin count > 40000"
    }
    return $structure_list
  }

  ####################################################################################################
  # MAIN
  #
  foreach root_pin_name $root_pin_names {
    set root_pin [ get_pins $root_pin_name ]
    set root_net [ get_nets -of $root_pin -top -seg ]
    set root_cell [ get_cell -of $root_pin ]
    set root_cell_name [ get_attr $root_cell full_name ]
    set root_model_pin_name [ lindex [ split $root_pin_name "/" ] end ]
    set base_cell_name      [ lindex [ split $root_cell_name "/" ] end ]
    set base_prefix [ format "%s_%s" $base_cell_name $root_model_pin_name ]
    set full_prefix [ format "%s_%s" $root_cell_name $root_model_pin_name ]

    # Define clock structure by pin count
    set pins [ add_to_collection "" "" ]
    set pins [ filter_collection [ get_loads $root_net ] " \
                                                        full_name !~ whydra_0/whydracore_0/whdcore_0/* \
                                 " ]

    set pin_count [ sizeof_collection $pins ]
    if { [ info exists structure_list($root_pin_name) ] == 0 } {
      set structure_list($root_pin_name) [ get_structure_list $pin_count ]
    }

    # Insert L3 buffer
    #set new_cell_name [ format "%s_FB_L3_DRIVE01" $base_prefix ]
    #set new_net_name  [ format "%s_FB_L3"         $base_prefix ]
    set new_cell_name [ format "%s_FB_L3_DRIVE01" $full_prefix ]
    set new_net_name  [ format "%s_FB_L3"         $full_prefix ]
    set model [ lindex [ lindex [ lindex $structure_list($root_pin_name) 2 ] 0 ] 0 ]
    set model_name [ get_model $model ]
    #set FB_L3 [insert_buffer $root_pin_name  $model_name -new_cell_names $new_cell_name -new_net_names $new_net_name]
    #puts "create_cell $new_cell_name $model_name"
    #puts "create_cell $new_cell_name $model"
    create_cell $new_cell_name $model_name
    #create_cell $new_cell_name $model
    create_net $new_net_name
    set orgi_net [ get_nets -of $root_pin_name -boundary_type lower ]
    disconnect_net $orgi_net $root_pin_name
    connect_net $new_net_name [ get_pins -of $new_cell_name -filter "direction == in" ]
    connect_net $new_net_name $root_pin_name
    connect_net $orgi_net [ get_pins -of $new_cell_name -filter "direction == out" ]
    set_cell_location $new_cell_name -coordinates { 0 0 }

    # Insert L2 buffer
    #set new_cell_name [ format "%s_FB_L2_DRIVE01" $base_prefix ]
    #set new_net_name  [ format "%s_FB_L2"         $base_prefix ]
    set new_cell_name [ format "%s_FB_L2_DRIVE01" $full_prefix ]
    set new_net_name  [ format "%s_FB_L2"         $full_prefix ]
    set model [ lindex [ lindex [ lindex $structure_list($root_pin_name) 1 ] 0 ] 0 ]
    set model_name [ get_model $model ]
    #set FB_L2 [insert_buffer $root_pin_name  $model_name -new_cell_names $new_cell_name -new_net_names $new_net_name]
    create_cell $new_cell_name $model_name
    #create_cell $new_cell_name $model
    create_net $new_net_name
    set orgi_net [ get_nets -of $root_pin_name -boundary_type lower ]
    disconnect_net $orgi_net $root_pin_name
    connect_net $new_net_name [ get_pins -of $new_cell_name -filter "direction == in" ]
    connect_net $new_net_name $root_pin_name
    connect_net $orgi_net [ get_pins -of $new_cell_name -filter "direction == out" ]
    set_cell_location $new_cell_name -coordinates { 0 0 }

    # Insert L1 buffer
    #set new_cell_name [ format "%s_FB_L1_DRIVE01" $base_prefix ]
    #set new_net_name  [ format "%s_FB_L1"         $base_prefix ]
    set new_cell_name [ format "%s_FB_L1_DRIVE01" $full_prefix ]
    set new_net_name  [ format "%s_FB_L1"         $full_prefix ]
    set model [ lindex [ lindex [ lindex $structure_list($root_pin_name) 0 ] 0 ] 0 ]
    set model_name [ get_model $model ]
    #set FB_L1 [insert_buffer $root_pin_name  $model_name -new_cell_names $new_cell_name -new_net_names $new_net_name]
    create_cell $new_cell_name $model_name
    #create_cell $new_cell_name $model
    create_net $new_net_name
    set orgi_net [ get_nets -of $root_pin_name -boundary_type lower ]
    disconnect_net $orgi_net $root_pin_name
    connect_net $new_net_name [ get_pins -of $new_cell_name -filter "direction == in" ]
    connect_net $new_net_name $root_pin_name
    connect_net $orgi_net [ get_pins -of $new_cell_name -filter "direction == out" ]
    set_cell_location $new_cell_name -coordinates { 0 0 }

    # Insert L3 parallel driver
    for { set i 2 } { $i <= [ lindex [ lindex [ lindex $structure_list($root_pin_name) 2 ] 0 ] 1 ] } { incr i } {
      set new_cell_name [ format "%s_FB_L3_DRIVE%02d" $full_prefix $i ]
      set model [ lindex [ lindex [ lindex $structure_list($root_pin_name) 2 ] 0 ] 0 ]
      set model_name [ get_model $model ]
      create_cell $new_cell_name $model_name
      #create_cell $new_cell_name $model
      set bpin_i [ get_pins -of [ format "%s_FB_L3_DRIVE%02d" $full_prefix 1  ] -filter "direction == in"  ]
      set bpin_o [ get_pins -of [ format "%s_FB_L3_DRIVE%02d" $full_prefix 1  ] -filter "direction == out" ]
      set ppin_i [ get_pins -of [ format "%s_FB_L3_DRIVE%02d" $full_prefix $i ] -filter "direction == in"  ]
      set ppin_o [ get_pins -of [ format "%s_FB_L3_DRIVE%02d" $full_prefix $i ] -filter "direction == out" ]
      connect_net [ get_nets -of $bpin_i -boundary_type lower ] $ppin_i
      connect_net [ get_nets -of $bpin_o -boundary_type lower ] $ppin_o
    }

    # Insert L3 dummy loading
    for { set i 1 } { $i <= [ lindex [ lindex [ lindex $structure_list($root_pin_name) 2 ] 1 ] 1 ] } { incr i } {
      set new_cell_name [ format "%s_FB_L3_DUMMY%02d" $full_prefix $i ]
      set model [ lindex [ lindex [ lindex $structure_list($root_pin_name) 2 ] 1 ] 0 ]
      set model_name [ get_model $model ]
      create_cell $new_cell_name $model_name
      #create_cell $new_cell_name $model
      set bpin_i [ get_pins -of [ format "%s_FB_L3_DRIVE%02d" $full_prefix 1  ] -filter "direction == in"  ]
      set bpin_o [ get_pins -of [ format "%s_FB_L3_DRIVE%02d" $full_prefix 1  ] -filter "direction == out" ]
      set ppin_i [ get_pins -of [ format "%s_FB_L3_DUMMY%02d" $full_prefix $i ] -filter "direction == in"  ]
      set ppin_o [ get_pins -of [ format "%s_FB_L3_DUMMY%02d" $full_prefix $i ] -filter "direction == out" ]
      connect_net [ get_nets -of $bpin_i -boundary_type lower ] $ppin_i
      #connect_net [ get_nets -of $bpin_o -top -seg ] $ppin_o
    }

    # Insert L2 parallel driver
    for { set i 2 } { $i <= [ lindex [ lindex [ lindex $structure_list($root_pin_name) 1 ] 0 ] 1 ] } { incr i } {
      set new_cell_name [ format "%s_FB_L2_DRIVE%02d" $full_prefix $i ]
      set model [ lindex [ lindex [ lindex $structure_list($root_pin_name) 1 ] 0 ] 0 ]
      set model_name [ get_model $model ]
      create_cell $new_cell_name $model_name
      #create_cell $new_cell_name $model
      set bpin_i [ get_pins -of [ format "%s_FB_L2_DRIVE%02d" $full_prefix 1  ] -filter "direction == in"  ]
      set bpin_o [ get_pins -of [ format "%s_FB_L2_DRIVE%02d" $full_prefix 1  ] -filter "direction == out" ]
      set ppin_i [ get_pins -of [ format "%s_FB_L2_DRIVE%02d" $full_prefix $i ] -filter "direction == in"  ]
      set ppin_o [ get_pins -of [ format "%s_FB_L2_DRIVE%02d" $full_prefix $i ] -filter "direction == out" ]
      connect_net [ get_nets -of $bpin_i -boundary_type lower ] $ppin_i
      connect_net [ get_nets -of $bpin_o -boundary_type lower ] $ppin_o
    }

    # Insert L3 dummy loading
    for { set i 1 } { $i <= [ lindex [ lindex [ lindex $structure_list($root_pin_name) 1 ] 1 ] 1 ] } { incr i } {
      set new_cell_name [ format "%s_FB_L2_DUMMY%02d" $full_prefix $i ]
      set model [ lindex [ lindex [ lindex $structure_list($root_pin_name) 1 ] 1 ] 0 ]
      set model_name [ get_model $model ]
      create_cell $new_cell_name $model_name
      #create_cell $new_cell_name $model
      set bpin_i [ get_pins -of [ format "%s_FB_L2_DRIVE%02d" $full_prefix 1  ] -filter "direction == in"  ]
      set bpin_o [ get_pins -of [ format "%s_FB_L2_DRIVE%02d" $full_prefix 1  ] -filter "direction == out" ]
      set ppin_i [ get_pins -of [ format "%s_FB_L2_DUMMY%02d" $full_prefix $i ] -filter "direction == in"  ]
      set ppin_o [ get_pins -of [ format "%s_FB_L2_DUMMY%02d" $full_prefix $i ] -filter "direction == out" ]
      connect_net [ get_nets -of $bpin_i -boundary_type lower ] $ppin_i
      #connect_net [ get_nets -of $bpin_o -top -seg ] $ppin_o
    }

  }

  ####################################################################################################
  # LOG
  #
  set fb_nets ""
  set log_file insert_clock_tree.log
  set log [ open $log_file a ]
  foreach root_pin_name $root_pin_names {
    puts $log [ format "####################################################################################################" ]
    puts $log [ format "# %s" $root_pin_name ]
    puts $log [ format "#" ]
    puts $log [ format "set structure_list($root_pin_name) { { { %s %d } } { { %s %d } { %s %d } } { { %s %d } { %s %d } } }" \
      [ lindex [ lindex [ lindex $structure_list($root_pin_name) 0 ] 0 ] 0 ] [ lindex [ lindex [ lindex $structure_list($root_pin_name) 0 ] 0 ] 1 ] \
      [ lindex [ lindex [ lindex $structure_list($root_pin_name) 1 ] 0 ] 0 ] [ lindex [ lindex [ lindex $structure_list($root_pin_name) 1 ] 0 ] 1 ] \
      [ lindex [ lindex [ lindex $structure_list($root_pin_name) 1 ] 1 ] 0 ] [ lindex [ lindex [ lindex $structure_list($root_pin_name) 1 ] 1 ] 1 ] \
      [ lindex [ lindex [ lindex $structure_list($root_pin_name) 2 ] 0 ] 0 ] [ lindex [ lindex [ lindex $structure_list($root_pin_name) 2 ] 0 ] 1 ] \
      [ lindex [ lindex [ lindex $structure_list($root_pin_name) 2 ] 1 ] 0 ] [ lindex [ lindex [ lindex $structure_list($root_pin_name) 2 ] 1 ] 1 ] \
    ]

    set root_pin [ get_pins $root_pin_name ]
    set root_net [ get_nets -of $root_pin -top -seg ]
    set root_cell [ get_cell -of $root_pin ]
    set root_cell_name [ get_attr $root_cell full_name ]
    set root_model_pin_name [ lindex [ split $root_pin_name "/" ] end ]
    set base_cell_name      [ lindex [ split $root_cell_name "/" ] end ]
    set base_prefix [ format "%s_%s" $base_cell_name $root_model_pin_name ]
    set full_prefix [ format "%s_%s" $root_cell_name $root_model_pin_name ]

    # root pin -> L1
    puts $log [ format "#---------------------------------------------------------------------------------------------------" ]
    set pin [ get_pins $root_pin_name ]
    set net [ get_nets -of $pin -top -seg ]
    set net_name [ get_attr $net full_name ]
    set source_pins [ sort_collection [ get_drivers $net ] {full_name} ]
    set sink_pins   [ sort_collection [ get_loads $net   ] {full_name} ]
    foreach_in_collection pin $source_pins  {
      set pin_name   [ get_attr $pin full_name ]
      set model_name [ get_attr [get_cells -of $pin] ref_name ]
      puts $log [ format "# %s (%s)" $pin_name $model_name ]
    }
    puts $log [ format "# %s (net) %s" $net_name [ sizeof_collection $sink_pins ] ]
    foreach_in_collection pin $sink_pins  {
      set pin_name   [ get_attr $pin full_name ]
      set model_name [ get_attr [ get_cells -of $pin ] ref_name ]
      puts $log [ format "# %s (%s)" $pin_name $model_name ]
    }

    # L1 -> L2
    puts $log [ format "#---------------------------------------------------------------------------------------------------" ]
    set pin [ get_pins -of [ format "%s_FB_L1_DRIVE01" $full_prefix ] -filter "direction == out" ]
    set net [ get_nets -of $pin -top -seg]
    set net_name [ get_attr $net full_name ]
    set source_pins [ sort_collection [ get_drivers $net ] {full_name} ]
    set sink_pins   [ sort_collection [ get_loads $net   ] {full_name} ]
    foreach_in_collection pin $source_pins  {
      set pin_name   [ get_attr $pin full_name ]
      set model_name [ get_attr [get_cells -of $pin] ref_name ]
      puts $log [ format "# %s (%s)" $pin_name $model_name ]
    }
    puts $log [ format "# %s (net) %s" $net_name [ sizeof_collection $sink_pins ] ]
    foreach_in_collection pin $sink_pins  {
      set pin_name   [ get_attr $pin full_name ]
      set model_name [ get_attr [ get_cells -of $pin ] ref_name ]
      puts $log [ format "# %s (%s)" $pin_name $model_name ]
    }

    # L2 -> L3
    puts $log [ format "#---------------------------------------------------------------------------------------------------" ]
    set pin [ get_pins -of [ format "%s_FB_L2_DRIVE01" $full_prefix ] -filter "direction == out" ]
    set net [ get_nets -of $pin -top -seg]
    set net_name [ get_attr $net full_name ]
    set source_pins [ sort_collection [ get_drivers $net ] {full_name} ]
    set sink_pins   [ sort_collection [ get_loads $net   ] {full_name} ]
    foreach_in_collection pin $source_pins  {
      set pin_name   [ get_attr $pin full_name ]
      set model_name [ get_attr [get_cells -of $pin] ref_name ]
      puts $log [ format "# %s (%s)" $pin_name $model_name ]
    }
    puts $log [ format "# %s (net) %s" $net_name [ sizeof_collection $sink_pins ] ]
    foreach_in_collection pin $sink_pins  {
      set pin_name   [ get_attr $pin full_name ]
      set model_name [ get_attr [ get_cells -of $pin ] ref_name ]
      puts $log [ format "# %s (%s)" $pin_name $model_name ]
    }

    # L3 -> leaf pin
    puts $log [ format "#---------------------------------------------------------------------------------------------------" ]
    set pin [ get_pins -of [ format "%s_FB_L3_DRIVE01" $full_prefix ] -filter "direction == out" ]
    set net [ get_nets -of $pin -top -seg]
    set net_name [ get_attr $net full_name ]
    set source_pins [ sort_collection [ get_drivers $net ] {full_name} ]
    set sink_pins   [ sort_collection [ get_loads $net   ] {full_name} ]
    foreach_in_collection pin $source_pins  {
      set pin_name   [ get_attr $pin full_name ]
      set model_name [ get_attr [get_cells -of $pin] ref_name ]
      puts $log [ format "# %s (%s)" $pin_name $model_name ]
    }
    puts $log [ format "# %s (net) %s" $net_name [ sizeof_collection $sink_pins ] ]
    set fb_nets [concat $fb_nets $net_name]
    #foreach_in_collection pin $sink_pins  {
    #  set pin_name   [ get_attr $pin full_name ]
    #  set model_name [ get_attr [ get_cells -of $pin ] ref_name ]
    #  puts $log [ format "# %s (%s)" $pin_name $model_name ]
    #}

  }
  close $log
  set top_fb_nets [ get_attr [ get_nets $fb_nets -top -seg] full_name ]
  return $top_fb_nets

}
