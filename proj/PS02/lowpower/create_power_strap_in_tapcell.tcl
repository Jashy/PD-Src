set tap_cells [get_cells -filter "full_name =~ *ALCP_TAP* || full_name =~ *ENDCAP* && full_name !~ *DCAP" -all]
array unset tap_array
foreach_in_coll cell $tap_cells {
   set x [ lindex [ lindex [ get_attr $cell bbox ] 0 ] 0 ]
   if { [ info exists tap_array($x) ] } {
      set tap_array($x) [ add_to_coll $tap_array($x) $cell ]
   } else {
      set tap_array($x) $cell
   }
}

set net VDD
set layer M3
set width 0.2
foreach x [array names tap_array ] {
    set min_y 9999999
    set max_y -9999999
    foreach_in cell $tap_array($x) {
       set lly [ lindex [ lindex [ get_attr $cell bbox ] 0 ] 1 ]
       set ury [ lindex [ lindex [ get_attr $cell bbox ] 1 ] 1 ]
       if { $min_y > $lly } { set min_y $lly }
       if { $max_y < $ury } { set max_y $ury }
    }
       set length [ expr $max_y - $min_y ]
       set origin "[ expr $x + 0.259 ] $min_y"
       create_net_shape -origin $origin -length $length -layer $layer -net $net -route_type pg_strap -vertical -width $width

}
