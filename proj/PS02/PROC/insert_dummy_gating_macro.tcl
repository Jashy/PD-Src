#set fr [ open macro.tcl w ]
set i 0
foreach_in_collection cells [ get_cells -hier * -filter "is_hierarchical == false " ] {
      set cell [ get_attr $cells full_name ]
      set type [ get_attr $cells ref_name ]
      if { [ regexp "^TS1N65LPA|^TS3N65LPA|^T1HP" $type ] } {
         set x [ lindex [ get_location [ get_pins $cell/CLK ] ] 0 ]
         set y [ lindex [ get_location [ get_pins $cell/CLK ] ] 1 ]
         set location [ concat $x $y ]
         puts "insert_buffer -new_net_names DUMMY_MACRO -new_cell_names DUMMY_MACRO \[ get_pins $cell/CLK \] tcbn65lp_cklnqddx_wcl/CKLNQDD8 -location {$location}"
         eval "insert_buffer -new_net_names DUMMY_MACRO -new_cell_names DUMMY_MACRO \[ get_pins $cell/CLK \] tcbn65lp_cklnqddx_wcl/CKLNQDD8 -location {$location}"
         incr i 
      }
}
#close $fr
puts "$i"
