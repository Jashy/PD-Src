##################################################################
##                       Writen by Vien                         ##
##################################################################

#source /filer/home/vieng/SPLIT_NET.tcl
#set tran_sum_file "/proj/F-CHIP/WORK/vieng/pt/5_fb_fix_hold_c/SDF-mode/wcl_cworst_m40c_sdf/REPORT/report_constraint.max_transition.rep.summary"
#set tran_sum_file "/proj/Chloris/WORK/vieng/ETS/for_fix_slew/constraint_maxtran.rpt.sum"
#catch "unset tran_violated_pins"
#set tran_violated_pins ""
#set file [open $tran_sum_file r]
#while { [gets $file line ] != -1 } {
#    if {[regexp {\S+\/\S+} $line pin]} {
#       set tran_violated_pins [concat $tran_violated_pins $pin]
#    }
#}
proc FIX_CLOCK_TRANS_v1 {tran_violated_pins} {

source /proj/Aurora/WORK/DATA/scripts/SPLIT_NET_vien.tcl
set fanout_limit 16
set cluster_size_x 100
set cluster_size_y 100
set split_buf_model CKBD16BWP
set insert_buf_ref BUFFD8BWP
proc get_center_location { box_list } { 
  set x_min    999999999
  set x_max    -999999999
  set y_min    999999999
  set y_max    -999999999
  foreach box $box_list {
    set left   [ lindex [ lindex $box 0 ] 0 ] 
    set right  [ lindex [ lindex $box 1 ] 0 ] 
    set bottom [ lindex [ lindex $box 0 ] 1 ] 
    set top    [ lindex [ lindex $box 1 ] 1 ] 
    if { $left   < $x_min   } { set x_min  $left   }   
    if { $right  > $x_max   } { set x_max  $right  }
    if { $bottom < $y_min   } { set y_min  $bottom }
    if { $top    > $y_max   } { set y_max  $top    }   
  }   
  set location_x [ expr ( $x_min + $x_max ) * 0.5 ]
  set location_y [ expr ( $y_min + $y_max ) * 0.5 ]
  return [ list $location_x $location_y ]
}
proc get_middle_location_vien {location_1 location_2} {
  set x_dr [lindex $location_1 0]
  set y_dr [lindex $location_1 1]
  set x_ld [lindex $location_2 0]
  set y_ld [lindex $location_2 1]
  set middle_x [expr ($x_dr + $x_ld)*0.5]
  set middle_y [expr ($y_dr + $y_ld)*0.5]
  return [list $middle_x $middle_y]
}
#file mkdir eco_scripts
#echo "#transition_eco_script" > ./eco_scripts/fix_transition.tcl
if {[array exists split_net]} {
   unset split_net 
}
#if {[array exists insert_buf]} {
#   unset insert_buf 
#}
#if {[array exists change_link]} {
#   unset change_link 
#}
set new_buffers ""
foreach violated_pin $tran_violated_pins {
#    set bufd_over_8 0
    set vlp_direction [get_attr [get_pins $violated_pin] direction]
    set less_driver_pin_name [get_attr [get_flat_pins -of [get_flat_nets -of $violated_pin] -filter "direction==out" ] full_name] 
    set less_driver_cell_name [get_attr [get_cells -of [get_flat_pins -of [get_nets -seg -top -of $violated_pin] -filter "direction==out" ]] full_name] 
    set less_driver_cell_ref [get_attr [get_cells $less_driver_cell_name] ref_name]
#    if {[regexp {.*D0BWP} $less_driver_cell_ref]} {
#       regsub {D0BWP} $less_driver_cell_ref D1BWP new_ref_name
#       if {![info exists change_link($less_driver_cell_name)]} {
#           set change_link($less_driver_cell_name) $new_ref_name
#       }
#    } elseif {[regexp {(BUFF|INV)D(\d)BWP} $less_driver_cell_ref "" "" strenth]} 
#       if {$strenth<2} {
#         regsub {D.BWP} $less_driver_cell_ref D4BWP new_ref_name
#       } elseif { $strenth<4 } {
#         regsub {D.BWP} $less_driver_cell_ref D6BWP new_ref_name
#       } elseif { $strenth<8 } {
#         regsub {D.BWP} $less_driver_cell_ref D8BWP new_ref_name
#       } elseif { $strenth>=8 } {
#         set bufd_over_8 1
#         if {![info exists split_net($less_driver_pin_name)]} {
#             set split_net($less_driver_pin_name) ""
#             set split_net($less_driver_pin_name) [concat $split_net($less_driver_pin_name) $violated_pin]
#         }  else {
#             set split_net($less_driver_pin_name) [concat $split_net($less_driver_pin_name) $violated_pin]
#         }
#       } 
#       if {![info exists change_link($less_driver_cell_name)]} {
#           set change_link($less_driver_cell_name)  $new_ref_name
#       }
    if {$vlp_direction=="in"} {
       if {![info exists split_net($less_driver_pin_name)]} {
           set split_net($less_driver_pin_name) ""
           set split_net($less_driver_pin_name) [concat $split_net($less_driver_pin_name) $violated_pin]
       }  else {
           set split_net($less_driver_pin_name) [concat $split_net($less_driver_pin_name) $violated_pin]
       }
    }
#    if {$vlp_direction=="out" && ![info exists change_link($less_driver_cell_name)] && $bufd_over_8==0} {
#      set insert_buf($violated_pin) $insert_buf_ref
#    }
}
#foreach driver [array names insert_buf] {
#    if {[info exists split_net($driver)]} {
#      unset split_net($driver)
#    }
#}
#foreach change_link_cell [array names change_link] {
#    echo "change_link $change_link_cell $change_link($change_link_cell)" >> ./eco_scripts/fix_transition.tcl
#}
#foreach output_vlp [array names insert_buf] {
#    echo "INSERT_BUFFER $output_vlp $insert_buf($output_vlp) -place_on_pin" >> ./eco_scripts/fix_transition.tcl
#}
foreach less_driver_pin [array names split_net] {
    catch "unset pins_by_matrix_index"
    foreach violated_loading $split_net($less_driver_pin) {
        set pin_name [ get_attr $violated_loading full_name ]
        # Get pin center location
        set box_list [ list [ get_attr $violated_loading bbox ] ]
        set location [ get_center_location $box_list ]
        set location_x [ lindex $location 0 ]
        set location_y [ lindex $location 1 ]
        # Get matrix index
        set matrix_index_x [expr int([ expr $location_x / $cluster_size_x ])]
        set matrix_index_y [expr int([ expr $location_y / $cluster_size_y ])]
        if { [ info exists pins_by_matrix_index($matrix_index_x,$matrix_index_y) ] == 0 } {
          set pins_by_matrix_index($matrix_index_x,$matrix_index_y) $pin_name
        } else {
          set pins_by_matrix_index($matrix_index_x,$matrix_index_y) [ concat $pins_by_matrix_index($matrix_index_x,$matrix_index_y) $pin_name ]
        }
    }
    foreach matrix_index [ array names pins_by_matrix_index ] {
        set matrix_index_x [ lindex [ split $matrix_index  ] 0 ]
        set matrix_index_y [ lindex [ split $matrix_index  ] 1 ]
        # Sort pins by location
        catch "unset pin_by_location"
        foreach pin_name $pins_by_matrix_index($matrix_index) {
          set box_list [ list [ get_attr [ get_pins $pin_name] bbox ] ]
          set location [ get_center_location $box_list ]
          set location_x [ lindex $location 0 ]
          set location_y [ lindex $location 1 ]
          set pin_by_location($location_x,$location_y) $pin_name
        }
        set tmp_pins ""
        foreach location [ lsort [ array names pin_by_location ] ] {
          set pin $pin_by_location($location)
          set location_x [ lindex [ split $location  ] 0 ]
          set location_y [ lindex [ split $location  ] 1 ]
          set tmp_pins [ concat $tmp_pins $pin ]
        }
        if { [ llength $tmp_pins ] != [ llength $pins_by_matrix_index($matrix_index) ] } {
          puts "Error: Unexpected error at pin sort by location."
        }
        # Split pins by fanout limit
        while { [ llength $tmp_pins ] > 0 } {
          set current_pins [ lrange $tmp_pins 0 [ expr $fanout_limit - 1 ] ]
          set tmp_pins [ lrange $tmp_pins $fanout_limit end ]
          set box_list ""
          foreach pin_name $current_pins {
            set box_list [ concat $box_list [ list [ get_attr [get_pins  $pin_name ] bbox ] ] ]
          }
          set loadings_location [ get_center_location $box_list ]
          set less_driver_pin_location [get_attr [get_pins $less_driver_pin] center]
          set new_buf_location [get_middle_location_vien $less_driver_pin_location $loadings_location]
          set cmd "SPLIT_NET_vien $less_driver_pin {$current_pins} $split_buf_model -location {$loadings_location}"
	  echo $cmd
	  set new_buffers [concat $new_buffers [eval $cmd]]
        }
    }
}
echo "New Inserted Buffers : {\n$new_buffers}"

}
