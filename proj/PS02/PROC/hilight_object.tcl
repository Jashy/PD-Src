
proc hilight_collection { color collection } {
  gui_set_highlight_options -current_color $color
  gui_change_highlight -collection $collection
}

proc hilight_object { obj } {
  redirect /dev/null { set size [sizeof_collection $obj ] }
  if { $size == "" } {
    set objects {}
    foreach name $obj {
      if {[set stuff [get_ports -quiet $name]] == ""} {
        if {[set stuff [get_cells -quiet $name]] == ""} {
          if {[set stuff [get_pins -quiet $name]] == ""} {
            if {[set stuff [get_nets -quiet $name]] == ""} {
              continue
            }
          }
        }
      }
      set objects [ add_to_collection $objects $stuff ]
     }
  } else {
    set objects $obj
  }

  if {$objects == ""} {
   echo "Error: no objects given"
   return 0
  }

  set load_results {}

  if { [ set cells [get_cells -quiet $objects ] ] != "" } {
    hilight_collection "blue" $cells
  }

  if {[set pins [get_pins -quiet $objects]] != ""} {
    hilight_collection "yellow" $pins
  }

  if {[set ports [get_ports -quiet $objects]] != ""} {
    hilight_collection "yellow" $ports
  }

  # process all nets
  set nets [get_nets -quiet $obj]

  if {$nets != ""} {
    if { [ sizeof [ get_cells -of [ get_drivers $nets ] -quiet ] ] != 0 } {
      hilight_collection "green" [ get_cells -of [ get_drivers $nets ]  ]
    }
    if { [ sizeof [ get_cells -of [ get_loads $nets ]  -quiet ] ] != 0 } {
      hilight_collection "blue"  [ get_cells -of [ get_loads $nets ]  ]
    }
    if { [ sizeof [ get_net_shapes -of $nets -quiet ] ] != 0  } {
      hilight_collection "red" [ get_net_shapes -of $nets -quiet ]
    }
    if { [ sizeof [ get_vias -of $nets -quiet ] ] != 0  } {
      hilight_collection "red" [ get_vias -of $nets -quiet ]
    }
  }

  return [ sizeof_collection $objects ]
}
