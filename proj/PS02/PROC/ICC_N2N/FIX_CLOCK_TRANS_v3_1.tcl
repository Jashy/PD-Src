##################################################################
##                       Writen by Vien                         ##
##		 	  Version 3.0				##
##################################################################

#source /filer/home/vieng/SPLIT_NET.tcl
#set tran_sum_file "/proj/F-CHIP/WORK/vieng/pt/5_fb_fix_hold_c/SDF-mode/wcl_cworst_m40c_sdf/REPORT/report_constraint.max_transition.rep.summary"
#set tran_sum_file "/proj/Chloris/WORK/vieng/ETS/for_fix_slew/constraint_maxtran.rpt.sum"
#set tran_sum_file "/proj/Chloris/WORK/vieng/ETS/for_fix_slew/test.rpt"
#catch "unset tran_violated_pins"
#set tran_violated_pins ""
#set file [open $tran_sum_file r]
#while { [gets $file line ] != -1 } {
#    if {[regexp {\S+\/\S+} $line pin]} {
#       set tran_violated_pins [concat $tran_violated_pins $pin]
#    }
#}
#file mkdir eco_scripts
##echo "#transition_eco_script" > ./eco_scripts/fix_transition.tcl
#set eco_script_file {eco_scripts/fix_transition.tcl}

proc FIX_CLOCK_TRANS_v3_1 { args } {
########################################################################
# USAGE
#
  proc usage_FIX_CLOCK_TRANS_v3_1 { } {
    puts {Usage: FIX_CLOCK_TRANS_v3_1 {<loading_pin_names>}}
  }

########################################################################
# GET ARGUMENTS
#
  set arg_count 0
  if { [ regexp -- [ lindex $args $arg_count ] {-help} ] == 1 } {
    usage_FIX_CLOCK_TRANS_v3_1
    return 
  } elseif { [ llength $args ] == 0 } {
    usage_FIX_CLOCK_TRANS_v3_1
    return
  } else {
    set tran_violated_pins [lindex $args 0] 
  }
#######################################################################
#global eco_script_file
source /proj/Chloris/WORK/vieng/AURORA/ICC/scripts/SPLIT_NET_vien.tcl
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

proc get_window { box_list } { 
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
  return [ list $x_min $y_min ]
}

proc get_fix_location_info {location_1 location_2 {fix no} {upper_split_buf_inputpin_name "" } {split_buf_model ""}} {
#global eco_script_file
  set x_dr [lindex $location_1 0]
  set y_dr [lindex $location_1 1]
  set x_ld [lindex $location_2 0]
  set y_ld [lindex $location_2 1]
  set middle_x [expr ($x_dr + $x_ld)*0.5]
  set middle_y [expr ($y_dr + $y_ld)*0.5]
  set distance [expr abs([expr $x_dr - $x_ld]) + abs([expr $y_dr - $y_ld])]
  set dis_x [expr abs([expr $x_ld - $x_dr])]
  set dis_y [expr abs([expr $y_ld - $y_dr])]
  if {$distance > 500} {
    if { ($x_dr<=$x_ld && $y_dr<=$y_ld) } {
      set method 1
    } elseif {($x_dr>$x_ld && $y_dr>$y_ld)} {
      set method 2
    } elseif {($x_dr>$x_ld && $y_dr<$y_ld)} {
      set method 3
    } elseif {($x_dr<$x_ld && $y_dr>$y_ld)} {
      set method 4
    }
    set step_x [expr $dis_x/(floor($distance/230))]
    set step_y [expr $dis_y/(floor($distance/230))]
    if {$fix != "no"} {
      set num 1
      set x $x_dr
      set y $y_dr
      while {$num<[expr floor($distance/230)]} {
        if {$method == 1} {
          set x [expr int([expr $x+$step_x])]  
          set y [expr int([expr $y+$step_y])]
          INSERT_BUFFER $upper_split_buf_inputpin_name $split_buf_model -location "$x $y" 
 #         echo "INSERT_BUFFER $upper_split_buf_inputpin_name $split_buf_model -location {$x $y}" >> ./$eco_script_file
        } elseif {$method == 2} {
          set x [expr int([expr $x-$step_x])]  
          set y [expr int([expr $y-$step_y])]
          INSERT_BUFFER $upper_split_buf_inputpin_name $split_buf_model -location "$x $y"
 #         echo "INSERT_BUFFER $upper_split_buf_inputpin_name $split_buf_model -location {$x $y}" >> ./$eco_script_file
        } elseif {$method == 3} {
          set x [expr int([expr $x-$step_x])]  
          set y [expr int([expr $y+$step_y])]
          INSERT_BUFFER $upper_split_buf_inputpin_name $split_buf_model -location "$x $y" 
 #         echo "INSERT_BUFFER $upper_split_buf_inputpin_name $split_buf_model -location {$x $y}" >> ./$eco_script_file
        } elseif {$method == 4} {
          set x [expr int([expr $x+$step_x])]  
          set y [expr int([expr $y-$step_y])]
          INSERT_BUFFER $upper_split_buf_inputpin_name $split_buf_model -location "$x $y"
 #         echo "INSERT_BUFFER $upper_split_buf_inputpin_name $split_buf_model -location {$x $y}" >> ./$eco_script_file
        }
        incr num
      }
    }
    return [list $method $distance $step_x $step_y ]
  } else {
    set method 0
    return [list $method $distance $middle_x $middle_y]
  }
}


if {[array exists split_net]} {
   unset split_net 
}
#if {[array exists insert_buf]} {
#   unset insert_buf 
#}
#if {[array exists change_link]} {
#   unset change_link 
#}
foreach violated_pin $tran_violated_pins {
#    set bufd_over_8 0
####################
#   check_object   #
#
    if {[get_attr [get_pins $violated_pin] full_name] == ""} {
        puts "ERROR: No such pin named $violated_pin"
        continue
    }
###################
    set vlp_direction [get_attr [get_pins $violated_pin] direction]
    set less_driver_pin_name [get_attr [get_pins -leaf -of [get_flat_nets -of $violated_pin] -filter "direction==out" ] full_name] 
    set less_driver_cell_name [get_attr [get_cells -of [get_pin -leaf -of [get_flat_nets -of $violated_pin] -filter "direction==out" ]] full_name] 
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
#    change_link $change_link_cell $change_link($change_link_cell)
#}
#foreach output_vlp [array names insert_buf] {
#    INSERT_BUFFER $output_vlp $insert_buf($output_vlp) -place_on_pin
#}
foreach less_driver_pin [array names split_net] {
    catch "unset pins_by_matrix_index"
    set split_buf_locations ""
    set split_buf_input_names ""
    set all_box_list ""
    foreach violated_loading $split_net($less_driver_pin) {
	set all_box_list [ concat $all_box_list [ list [ get_attr [get_pins  $violated_loading ] bbox ] ] ] 
    }   
    set win_x [lindex [get_window $all_box_list] 0]
    set win_y [lindex [get_window $all_box_list] 1]
  #  echo "set split_buf_input_names \"\" " >> ./$eco_script_file
    foreach violated_loading $split_net($less_driver_pin) {
        set pin_name [ get_attr $violated_loading full_name ]
        # Get pin center location
        set box_list [ list [ get_attr $violated_loading bbox ] ]
        set location [ get_center_location $box_list ]
        set location_x [expr ([ lindex $location 0 ] - $win_x)]
        set location_y [expr ([ lindex $location 1 ] - $win_y)]
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
	  set loading_x [lindex $loadings_location 0]
	  set loading_y [lindex $loadings_location 1]
          set less_driver_pin_location [get_attr [get_pins $less_driver_pin] center]
	  set method [lindex [get_fix_location_info $less_driver_pin_location $loadings_location] 0]
	  set distance [lindex [get_fix_location_info $less_driver_pin_location $loadings_location] 1]
	  if {[llength $current_pins] > 1} {
		if {$distance > 250} {
	#	INSERT_BUFFER [get_attr [get_cells $split_buf] full_name]/Z $split_buf_model -location $loadings_location
	#	echo "INSERT_BUFFER \[get_attr \[get_cells \$split_buf\] full_name\]/Z $split_buf_model -location {$loadings_location}" >> ./$eco_script_file
	  	    lappend split_buf_locations [list "$loadings_location" "$loadings_location"]
          	    set split_buf [SPLIT_NET_vien $less_driver_pin $current_pins $split_buf_model -location $loadings_location]
		    set split_buf_input_names [concat $split_buf_input_names [get_attr [get_cells $split_buf] full_name]/I] 
   #       	echo "set split_buf \[SPLIT_NET_vien $less_driver_pin {$current_pins} $split_buf_model -location {$loadings_location}\]" >> ./$eco_script_file
   #		echo "set split_buf_input_names \[concat \$split_buf_input_names \[get_attr \[get_cells \$split_buf\] full_name\]/I\]" >> ./$eco_script_file 
		} else {
		    SPLIT_NET_vien $less_driver_pin $current_pins $split_buf_model -location $loadings_location
		}
	  } else {
	      if {($method == 0) && ($distance > 250)} {
	            set loading_x [lindex [get_fix_location_info $less_driver_pin_location $loadings_location] 2]
	            set loading_y [lindex [get_fix_location_info $less_driver_pin_location $loadings_location] 3]
	            set new_buf_location [list $loading_x $loading_y]
	            set split_buf [SPLIT_NET_vien $less_driver_pin $current_pins $split_buf_model -location $new_buf_location]
   #	            echo "set split_buf \[get_attr \[get_cells \[SPLIT_NET_vien $less_driver_pin {$current_pins} $split_buf_model -location {$new_buf_location}\]\] full_name\]" >> $eco_script_file
	      } elseif {$method != 0} {
              	    set step_x [lindex [get_fix_location_info $less_driver_pin_location $loadings_location] 2]
              	    set step_y [lindex [get_fix_location_info $less_driver_pin_location $loadings_location] 3]
	      
	      	    if {$method==1} {
 	            	set loading_x [expr $loading_x - $step_x]
	            	set loading_y [expr $loading_y - $step_y]
	      	    } elseif {$method==2} {
	            	set loading_x [expr $loading_x + $step_x]
	            	set loading_y [expr $loading_y + $step_y]
	      	    } elseif {$method==3} {
	            	set loading_x [expr $loading_x + $step_x]
	            	set loading_y [expr $loading_y - $step_y]
	      	    } elseif {$method==4} {
	            	set loading_x [expr $loading_x - $step_x]
	               	set loading_y [expr $loading_y + $step_y]
	      	    } 
	      	    set new_buf_location [list $loading_x $loading_y]
	      	    lappend split_buf_locations [list "$new_buf_location" "$new_buf_location"]
              	    set split_buf [SPLIT_NET_vien $less_driver_pin $current_pins $split_buf_model -location $new_buf_location]
	            set split_buf_input_names [concat $split_buf_input_names [get_attr [get_cells $split_buf] full_name]/I] 
    #          	    echo "set split_buf \[SPLIT_NET_vien $less_driver_pin {$current_pins} $split_buf_model -location {$new_buf_location}\]" >> ./$eco_script_file
    #	            echo "set split_buf_input_names \[concat \$split_buf_input_names \[get_attr \[get_cells \$split_buf\] full_name\]/I\]" >> ./$eco_script_file 
	      }
	  }
        }
    }
    if {$split_buf_input_names != ""} {
        set split_buf_location [get_center_location $split_buf_locations]
        set method [lindex [get_fix_location_info $less_driver_pin_location $split_buf_location] 0]
        set distance [lindex [get_fix_location_info $less_driver_pin_location $split_buf_location] ]
        if {($method == 0) && ($distance > 250)} {
            set sp_x [lindex [get_fix_location_info $less_driver_pin_location $split_buf_location] 2]
            set sp_y [lindex [get_fix_location_info $less_driver_pin_location $split_buf_location] 3]
            set m_location [list $sp_x $sp_y]
            SPLIT_NET_vien $less_driver_pin $split_buf_input_names $split_buf_model -location $m_location
    #        echo "SPLIT_NET_vien $less_driver_pin \$split_buf_input_names $split_buf_model -location {$m_location}" >> ./$eco_script_file
        } elseif {$method != 0} {
            set upper_split_buf_name [SPLIT_NET_vien $less_driver_pin $split_buf_input_names $split_buf_model -location $split_buf_location]
            set upper_split_buf_inputpin_name [get_attr [get_cells $upper_split_buf_name] full_name]/I
    #        echo "set upper_split_buf_name \[SPLIT_NET_vien $less_driver_pin \$split_buf_input_names $split_buf_model -location {$split_buf_location}\]" >> ./$eco_script_file
    #        echo "set upper_split_buf_inputpin_name \[get_attr \[get_cells \$upper_split_buf_name\] full_name\]/I" >> ./$eco_script_file
            get_fix_location_info $less_driver_pin_location $split_buf_location yes $upper_split_buf_inputpin_name $split_buf_model
        }
    }		
}
}
