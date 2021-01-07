proc write_clock_pin_list { file_name } {
  set file [ open $file_name w ]
  foreach_in_collection clock [ get_clocks * ] {
    set sources [ get_attribute $clock sources ]
    if { [ sizeof_collection $sources ] > 0 } {
      puts $file [ format "########################################################################" ]
      puts $file [ format "# Clock: %s" [ get_attribute $clock full_name ] ]
      puts $file [ format "#" ]
    }
    foreach_in_collection source $sources {
      puts $file [ format "#-----------------------------------------------------------------------" ]
      puts $file [ format "# Source: %s" [ get_attribute $source full_name ] ]
      puts $file [ format "#" ]

      # skip non-clock network
      #set leaf_pins [ filter_collection [ all_fanout -flat -from $source -endpoints_only ] "is_on_clock_network == true" ]
#      set leaf_pins [ filter_collection [ all_fanout -flat -from $source -endpoints_only ] "pin_on_clock_network == true" ]
#      if { [ sizeof_collection $leaf_pins ] == 0 } {
#        puts $file [ format "# Warning: No clock leaf pin found. Skipped." ]
#        continue
#      }

      foreach_in_collection pin [ all_fanout -flat -from $source ] {
        if { [ get_attribute $pin object_class ] == "port" } {
          set port_name [ get_attribute $pin full_name ]
          puts $file [ format "%s" $port_name ]
        } else {
          set cell [ get_cells -of_objects $pin ]
          set cell_name [ get_attribute $cell full_name ]
          set lib_pin_name [ get_attribute $pin lib_pin_name ]
          set ref_name [ get_attribute $cell ref_name ]
          puts $file [ format "%s %s" $cell_name $lib_pin_name $ref_name ]
        }
      }
    }
  }
  close $file
}

