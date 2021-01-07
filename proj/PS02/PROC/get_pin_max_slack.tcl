proc get_pin_max_slack { pin_name } {
  set worst_slack 999999
  foreach_in_collection timing_path [ get_timing_paths -through [ get_pins $pin_name ] -delay max ] {
    set slack [ get_attribute $timing_path slack ]
    if { $slack < $worst_slack } {
      set worst_slack $slack
    }
  }
  return $worst_slack
}

