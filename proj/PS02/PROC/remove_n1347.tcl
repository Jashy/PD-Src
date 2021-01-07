
set _intr_pins {INT_R_TAINM/O INT_R_TAINM/I INT_R_TAINP/O INT_R_TAINP/I}
set _intr_nets {}
set _intr_ties {}

foreach pin $_intr_pins {
  set net [get_nets -of $pin]
  if {[sizeof_collection $net] > 0} {
    append_to_collection -unique _intr_nets $net
    foreach_in_collection pin2 [get_pins -of $net] {

      set cmd "  disconnect_net [get_object_name $net] [get_object_name $pin2]"
      puts "Info: $cmd"
      eval $cmd

      set cel [get_cells -of $pin2]
      if {[sizeof_collection $cel] > 0 && [get_attribute $cel ref_name] == "TIEL"} {
	append_to_collection -unique _intr_ties $cel
      }
    }
  }
}

set cmd "  remove_net { [get_object_name $_intr_nets] }"
puts "Info: $cmd"
eval $cmd

set cmd "  remove_cell { [get_object_name $_intr_ties] }"
puts "Info: $cmd"
eval $cmd

