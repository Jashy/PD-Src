proc write_clock_net_list { file_name } {
  set file [ open $file_name w ]
  set net_col {}
  foreach_in_collection pin [ get_pins */* -hierarchical -filter "is_extracted_clock_pin == true" ] {
    append_to_collection -unique net_col [ all_connected $pin ]
  }
  foreach_in_collection net $net_col {
    set net_name [get_attribute [get_nets -top_net_of_hierarchical_group -segments $net] full_name]
    puts $file [ format $net_name ]
  }
  close $file
}

