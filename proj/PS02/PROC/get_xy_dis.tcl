
proc get_xy_dis { arg } {
  set min_x 999999
  set min_y 999999
  set max_x -99999
  set max_y -99999

  foreach_in_collection obj $arg {
    set bbox [ get_attr $obj bbox ]
    set x [ lindex [ lindex $bbox 0 ] 0 ]
    set y [ lindex [ lindex $bbox 0 ] 1 ]
    if { $x < $min_x } { set min_x $x }
    if { $y < $min_y } { set min_y $y }
    if { $x > $max_x } { set max_x $x }
    if { $y > $max_y } { set max_y $y }
  }

  return "$min_x $min_y $max_x $max_y"
}
