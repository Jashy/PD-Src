# File: report_cell_connection.tcl
# Author: by lyricl
# Date: Feb 20, 2008
# Function: IP connection check
proc report_cell_connection { cell } {
  set pins [ get_pins -of_objects [ get_cells $cell ] ]
  set ref [ get_attri [ get_cells $cell ] ref_name ]
  echo ""
  echo [ format "Analog macro: %s (%s)" $cell $ref ]
  echo [ format "Pin\t       Net\t\t\t\t\t\t       Driver/Receiver" ]
  echo [ format "===================================================================================================" ]
  foreach_in_collection pin $pins {
    set pin_name [ get_attri $pin full_name]
    regsub "$cell/" $pin_name "" pin_name_r
    set direction [ get_attri $pin direction ]
    if { $direction == "in" } {
      set dir_label  "I"
    } elseif { $direction == "out" } {
      set dir_label  "O"
    } else {
      set dir_label  "IO"
    }
    set net [ all_connected $pin]
    if { [ sizeof_collection $net ] == 0 } {
      echo [ format "%-8s(%2s)   <no_net>" $pin_name_r $dir_label ]
    } else {
      set net_name [ get_attri $net full_name]
      set pins_on_net [ get_pins -of_objects $net -leaf]
      foreach_in_collection pin_on_net $pins_on_net {
        set pin_on_net_name [ get_attri $pin_on_net full_name]
        if { $pin_on_net_name != $pin_name } {
          set dri_rec_ref [ get_attri [ get_cells -of_objects $pin_on_net_name ] ref_name ]
          echo [ format "%-8s(%2s)   %-55s %s(%s)" $pin_name_r $dir_label $net_name $pin_on_net_name $dri_rec_ref ]
        }
      }
    }
  }
}
