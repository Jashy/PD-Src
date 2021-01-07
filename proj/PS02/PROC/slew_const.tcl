
foreach_in_collection lib_pins [ get_lib_pins tcbn65lpwcl/*/* ] {
  set_max_transition 0.62 $lib_pins
  puts "set_max_transition 0.62 $lib_pins"
}

foreach_in_collection lib_pins [ get_lib_pins tcbn65lphvtwcl/*/* ] {
  set_max_transition 0.85 $lib_pins
  puts "set_max_transition 0.85 $lib_pins"
}

