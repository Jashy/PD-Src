
proc CHANGE_CELL_REF_ICC { cell_name new_ref_name } {
  set cell [ get_cells $cell_name ]
  set cell_name [ get_attr $cell full_name ]
  set orientation   [ get_attr $cell orientation]
  set origin        [ get_attr $cell origin]
  set is_placed     [ get_attr $cell is_placed]
  set is_fixed      [ get_attr $cell is_fixed]
  set is_soft_fixed [ get_attr $cell is_soft_fixed]
  set eco_status    [ get_attr $cell eco_status]
  set lib_cell_name [get_attr [get_physical_lib_cells */$new_ref_name] full_name]
  
   foreach_in pin [ get_pins -of $cell ] {
    set lib_pin_name [ get_attr $pin lib_pin_name ]
		if { [sizeof_collection [ get_physical_lib_pins $lib_cell_name/$lib_pin_name -quiet ] ] == 0 } {
			echo " Error: No such pin named $lib_pin_name on the new ref "
			continue
		}
		if { [sizeof_collection [ get_nets -of $pin -quiet] ] == 1 } {
			set pin_net($lib_pin_name) [ get_nets -of $pin ]
		} elseif { [sizeof_collection [ get_flat_nets -of $pin -quiet] ] == 1 } {
			set pin_net($lib_pin_name) [ get_flat_nets -of $pin ]
		} else {
			echo " Warning: No connect on pin named $lib_pin_name "
		}
  }
  remove_cell $cell
  create_cell $cell_name $new_ref_name
  foreach lib_pin_name [ array names pin_net ] {
    connect_net $pin_net($lib_pin_name) $cell_name/$lib_pin_name
  }
  set_attr [ get_cells $cell_name ] orientation   $orientation  
  set_attr [ get_cells $cell_name ] origin        $origin       
  set_attr [ get_cells $cell_name ] is_placed     $is_placed    
  set_attr [ get_cells $cell_name ] is_fixed      $is_fixed     
  set_attr [ get_cells $cell_name ] is_soft_fixed $is_soft_fixed
  set_attr [ get_cells $cell_name ] eco_status    $eco_status   
}
