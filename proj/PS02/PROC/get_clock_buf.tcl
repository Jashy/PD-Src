
set a [ get_cells -hie * -filter "ref_name =~ CLKBUF* || ref_name =~ CLKNV*" ]
set b ""


foreach_in_collection aa $a {
  set aa_f_name [ get_att [ get_cells $aa ] full_name ]
  if { [ regexp {^UUruby_dft\/ruby_core\/image_proc.*$} $aa_f_name ] == 1 } { continue }
  if { [ regexp {^UUruby_dft\/ruby_core\/arm926.*$} $aa_f_name ] == 1 } { continue }
  set a_pins [ get_pins $aa_f_name/* -filter "direction == in" ]
  set b_pins [ get_pins $a_pins -filter "is_on_clock_network == true" ]
  if { [sizeof_collection $b_pins] == 1 } {
    set b_pins_f_name [ get_attr [ get_pins $b_pins ] full_name ]
    set b [ concat $b_pins_f_name $b ]
  }
}
llength $b


