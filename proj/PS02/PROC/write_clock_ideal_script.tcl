proc write_clock_ideal_script { file_name } {
  set file [ open $file_name w ]
  set net_col {}
  foreach_in_collection pin [ get_pins */* -hierarchical -filter "is_extracted_clock_pin == true" ] {
    append_to_collection -unique net_col [ all_connected $pin ]
  }
  foreach_in_collection net $net_col {
    set net_name [get_object_name $net]
    puts $file [ format "set_load -net %s 0.1p" $net_name ]
    puts $file [ format "set_slew -net %s 0.2n" $net_name ]
  }
  close $file
}

