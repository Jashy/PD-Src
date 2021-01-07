

proc toggle_color { } {
  global highlight_color_index

  set colors(0) yellow
  set colors(1) orange
  set colors(2) red
  set colors(3) green
  set colors(4) blue
  set colors(5) purple

  if { [ info exists highlight_color_index ] == 0 } {
    set highlight_color_index 0
  } else {
    if { $highlight_color_index == 5 } {
      set highlight_color_index 0
    } else {
      incr highlight_color_index
    }
  }

  return $colors($highlight_color_index)
}

proc hilight_path { path } {
  set highlight_color_index 0
  set pre_cell {}
  set cnt 0
  set count 0
  if { [ sizeof_collection [ get_text -filter "text =~ cell_*" -quiet ] ] != 0 } {
    remove_object [ get_text -filter "text =~ cell_*" ]
  }
  foreach obj $path {
    if { $obj == "*" } { continue }
    set pin [ get_pins $obj -filter "is_hierarchical == false" -quiet ]
    if { [ sizeof_collection $pin ] != 0 } {
      set color [toggle_color]
      if { $color == "yellow" } { set color [toggle_color] }
      if { $cnt == 0 } { set color "yellow" }
      set cell [ get_cells -of $pin ] 
      set net_shape [ get_net_shapes -of  [ get_nets -of $pin -top -seg ] ]
      if { [ sizeof_collection $net_shape ] != 0 } {
        gui_change_highlight -add -color $color -collection $net_shape
      }
      if { [ compare_collections $cell $pre_cell ] != 0 } {
        gui_change_highlight -add -color $color -collection $cell
        set origin [ get_attr $cell origin ]
        incr count
        create_text -origin $origin -height 3 "cell_$count" -layer 131
      }
      set pre_cell $cell
    }
    incr cnt
  }
}

alias hp hilight_path
