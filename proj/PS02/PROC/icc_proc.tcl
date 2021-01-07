# N2N
source /user/home/nealj/Template/tcl/ICC_N2N/REMOVE_REPEATER.tcl
#source /user/home/nealj/Template/tcl/ICC_tcl/N2N/CHANGE_BUF2INV.tcl
source /user/home/nealj/Template/tcl/ICC_N2N/CHANGE_BUF2INV_place.tcl
source /user/home/nealj/Template/tcl/ICC_N2N/CHANGE_INV2BUF_place.tcl
source /user/home/nealj/Template/tcl/ICC_tcl/N2N/CHANGE_CELL.tcl
source /user/home/nealj/Template/tcl/ICC_tcl/N2N/DUPLICATE_ICG.tcl
source /user/home/nealj/Template/tcl/ICC_tcl/N2N/INPUT_DRVPIN.tcl
source /user/home/nealj/Template/tcl/ICC_tcl/N2N/INSERT_BUFFER.tcl
#source /user/home/nealj/Template/tcl/ICC_tcl/N2N/INSERT_INVTER.tcl
source /user/home/nealj/Template/tcl/ICC_tcl/N2N/INSERT_REPEATER.tcl
source /user/home/nealj/Template/tcl/ICC_tcl/N2N/PIN_NET.tcl
source /user/home/nealj/Template/tcl/ICC_tcl/N2N/REMOVE_INVERTER.tcl
source /user/home/nealj/Template/tcl/ICC_tcl/N2N/REWIRE.tcl
#source /user/home/nealj/Template/tcl/ICC_tcl/N2N/SPLIT_NET.tcl
source /user/home/nealj/Template/tcl/ICC_tcl/N2N/SWAP_LOC.tcl
source /user/home/nealj/Template/tcl/timing.tcl
source /user/home/nealj/Template/tcl/ICC_tcl/SPLIT_BY_WINDOW.tcl
#source /user/home/nealj/Template/tcl/ICC_tcl/N2N_ICC/CHANGE_CELL.tcl
source /user/home/nealj/Template/tcl/ICC_tcl/N2N_ICC/CLONE_CELL.tcl
source /user/home/nealj/Template/tcl/ICC_tcl/N2N_ICC/CLONE_SPLIT_NET.tcl
source /user/home/nealj/Template/tcl/ICC_tcl/N2N_ICC/DELETE_BUFFER.tcl 
#source /user/home/nealj/Template/tcl/ICC_tcl/N2N_ICC/INSERT_BUFFER.tcl
#source /user/home/nealj/Template/tcl/ICC_tcl/N2N_ICC/INSERT_BUFFER.tcl.bk
source /user/home/nealj/Template/tcl/ICC_tcl/N2N_ICC/REMOVE_BUFFER.tcl
source /user/home/nealj/Template/tcl/ICC_tcl/N2N_ICC/REWIRE.tcl
source /user/home/nealj/Template/tcl/ICC_tcl/N2N_ICC/SPLIT_NET.tcl
source /user/home/nealj/Template/tcl/ICC_tcl/N2N_ICC/SPLIT_NET_1.tcl
source /user/home/nealj/Template/tcl/ICC_tcl/N2N_ICC/get_model.tcl

#rcg 
proc rcg { } {
	set cell_name [get_attribute [get_selection] full_name]
	set cell_type [get_attribute [get_selection] ref_name]
	puts "# $cell_name < -- > $cell_type #"
	rc [get_selection]
}
#rng 
proc rng { } {
	rn [get_selection]
}
# iccMNW 
proc iccMNW_selection { width } {
	foreach_in_collection NET [get_selection] {
		set_attribute $NET width $width
	}

}
# icc select file cell
proc get_cells_from_file { file } {
	set fa [open $file r]
  	change_selection
 	while { [gets $fa line] >=0 } {
		change_selection -add [get_cell $line ]
	}
	close $fa
}

# icc select cell
proc sc { cell_name } {
  change_selection [get_cell $cell_name -all]
  gui_zoom -selection -window [gui_get_current_window -types "Layout" -mru]
}
proc sca { cell_name } {
  change_selection [get_cell *${cell_name}* -all]
  gui_zoom -selection -window [gui_get_current_window -types "Layout" -mru]
}
#
proc gsn {  } {
	set se_name [get_attribute [get_selection] full_name]
	echo $se_name 
}
###
proc get_pins_from_file { file } {
	set fa [open $file r]
  	  change_selection
 	while { [gets $fa line] >=0 } {
	  change_selection -add [get_pins $line ]
	}
	close $fa
}

# icc select pin
proc sp { pin_name } {
  change_selection [get_pin $pin_name ]
  gui_zoom -selection -window [gui_get_current_window -types "Layout" -mru]
}
proc spa { pin_name } {
  change_selection -add [get_pin $pin_name ]
  gui_zoom -selection -window [gui_get_current_window -types "Layout" -mru]
}
# icc select file cell
proc get_nets_from_file { file } {
	set fa [open $file r]
        change_selection
 	while { [gets $fa line] >=0 } {
		change_selection -add [get_net $line ]
	}
	close $fa
}
# icc select net
proc sn { net_name } {
  change_selection [get_net $net_name -all]
  gui_zoom -selection -window [gui_get_current_window -types "Layout" -mru]
}
proc sna { net_name } {
  change_selection -add [get_net $net_name -all]
  gui_zoom -selection -window [gui_get_current_window -types "Layout" -mru]
}
# get_distance_of two cell
proc iCD { cell1 cell2 } {
	set X1 [ lindex [ get_attribute [get_cell $cell1] origin ] 0 ]
	set Y1 [ lindex [ get_attribute [get_cell $cell1] origin ] 1 ]
	set X2 [ lindex [ get_attribute [get_cell $cell2] origin ] 0 ]
	set Y2 [ lindex [ get_attribute [get_cell $cell2] origin ] 1 ]
	set DISTANCE [expr sqrt(($X1-$X2)*($X1-$X2)) + sqrt(($Y1-$Y2)*($Y1-$Y2)) ]
	puts "cell distance: $DISTANCE"
}
##
#get two pin distance
proc iPD {Pin1 Pin2} {
        set Pin1_location [get_attribute [get_pin $Pin1] bbox]
        set d_x_loc [ lindex [lindex $Pin1_location 0 ] 0 ]
        set d_y_loc [ lindex [lindex $Pin1_location 0 ] 1 ]
        set Pin2_location [get_attribute [get_pin $Pin2] bbox]
        set l_x_loc [ lindex [lindex $Pin2_location 0 ] 0 ]
        set l_y_loc [ lindex [lindex $Pin2_location 0 ] 1 ]
        set distance [ expr sqrt( ($l_x_loc - $d_x_loc) * ($l_x_loc - 
$d_x_loc) + ($l_y_loc - $d_y_loc) * ($l_y_loc - $d_y_loc) ) ]
        set x_dis [expr ($l_x_loc - $d_x_loc)]
        set y_dis [expr ($l_y_loc - $d_y_loc)]
        echo 
#==================================================================================
        echo From $Pin1 to $Pin2
        echo X distance\tY distance\tTotal distance
        echo $x_dis\t\t$y_dis\t\t$distance
        echo 
#==================================================================================
}
#get a net routing length
proc iND {net} {
        set net_shape_group [get_net_shapes -of [get_net $net]]
        set total_length 0
        foreach_in_collection shape $net_shape_group {
                set shape_location_info [get_attribute $shape bbox]
                #echo $shape_location_info
                set d_x_loc [ lindex [lindex $shape_location_info 0 ] 0 ]
                set d_y_loc [ lindex [lindex $shape_location_info 0 ] 1 ]
                set l_x_loc [ lindex [lindex $shape_location_info 1 ] 0 ]
                set l_y_loc [ lindex [lindex $shape_location_info 1 ] 1 ]
                #echo $d_x_loc $d_y_loc $l_x_loc $l_y_loc
                set x_dis [expr ($l_x_loc - $d_x_loc )]
                set y_dis [expr ($l_y_loc - $d_y_loc )]
                #echo $x_dis $y_dis
                if {$x_dis < $y_dis} {
                        #echo \tIt is vertical
                        #echo \tvertical distance is $y_dis
                        set total_length [expr ( $total_length + $y_dis )]
                } else {
                        #echo \tIt is horizontal
                        #echo \thorizontal distance is $x_dis
                        set total_length [expr ( $total_length + $x_dis )]
                }
        }
        echo Total length of $net is $total_length.
}


# dump pic
proc iccDumpJpgArea { picture_name } {
	gui_set_setting -window [gui_get_current_window -types Layout -mru] \
                -setting viewshot -value ${picture_name}.jpg
}
proc iccDumpJpgFull { picture_name } {
	gui_set_setting -window [gui_get_current_window -types Layout -mru] \
                -setting windowshot -value ${picture_name}.jpg

}
# rname net
proc iccReNameNetByName { Old_net_name New_net_name }  {
	set totshapes [get_net_shapes -of_objects [get_nets -all $Old_net_name]]
	foreach_in_collection i $totshapes {
		set_attribute $i owner_net $New_net_name
	}
}
proc iccReNameSelectionNet { New_net_name }  {
	set totshapes [ get_selection ]
	foreach_in_collection i $totshapes {
		set_attribute $i owner_net $New_net_name
	}
}
#ICC path show
proc iccPath { Starting_point Ending_point } {
	change_selection
	change_selection [get_timing_paths -from $Starting_point -to $Ending_point]
}
proc iccRemovePath { Starting_point Ending_point } {
	change_selection
#	change_selection -remove [get_timing_paths -from $Starting_point -to $Ending_point]
}
# dump net 
proc iccDumpSelectedNetALL { file_name } {
	write_route -nets [get_attr -c shape [get_selection] owner_net] -file_name $file_name
}
proc iccDumpNet { Net_name file_name } {
	write_route -nets $Net_name -file_name $file_name
}
# get current lib path 
proc iccGetCurrentLib { } {
	get_attribute [current_mw_lib] path
}
# select

proc qp { name } {
	gui_change_highlight -remove -color light_red 
	gui_change_highlight -remove -color light_blue 
	gui_change_highlight -color light_red -collection [get_pins $name]
	gui_change_highlight -color light_blue -collection [get_cells -of [get_pins $name] ]
}
proc qc { name } {
	gui_change_highlight -remove -color light_red 
	gui_change_highlight -color light_red -collection [get_cells $name]
}
proc qn { name } {
	gui_change_highlight -remove -color light_red 
	gui_change_highlight -remove -color light_blue 
	gui_change_highlight -remove -color yellow 
	gui_change_highlight -color yellow -collection [ get_nets [get_net $name] -segments -top ]
	set driver [ get_cells -of [ get_pins -leaf -of_obj [get_nets [get_net $name] -segments -top ] -filter "direction == out" ] ]
	set loading  [ get_cells -of [ get_pins -leaf -of_obj [get_nets [get_net $name] -segments -top ] -filter "direction == in" ] ]
	if { [ sizeof_collection $driver ] == 0 } {
		puts "floating input of net $name"
	} else {
		gui_change_highlight -color light_red -collection $driver
	}
	if { [ sizeof_collection $loading ] == 0 } {
		puts "floating output of net $name"
	} else {
		gui_change_highlight -color light_blue -collection $loading
	}
#	change_selection [get_nets $name]
}
proc dq { } {  
	gui_change_highlight -remove -color yellow
	gui_change_highlight -remove -color light_red
	gui_change_highlight -remove -color light_blue
	change_selection
}
# go zoon
proc igo {x y} {
  set x_l [expr $x - 5]
  set y_l [expr $y - 5]
  set x_r [expr $x + 5]
  set y_r [expr $y + 5]
  gui_zoom -rect [list [list $x_l $y_l] [list $x_r $y_r]]  -exact -window [gui_get_current_window -types "Layout" -mru]
}
# copy framshape to top lvl
# Script Documentation


#The attached script copies the metal shapes of the specified layer from the
#FRAM view to the top level.
#Usage:
#copy_fram_shapes
#        -layer             (Name of layer)
#        -instance          (Instance name)
#        -net_name          (Name of the net that needs to be created and mapped to newly created metal shapes)

#icc_shell> source copy_fram_shapes.tcl
#icc_shell> copy_fram_shapes -layer METAL3 -instance I_PCI_TOP/I_PCI_READ_FIFO/PCI_FIFO_RAM_3 -net_name skr


proc copy_fram_shapes { args } {

	parse_proc_arguments -args $args res
	set layer $res(-layer)
	set inst_name $res(-instance)
	set net_name $res(-net_name)
	
	if [file exists bbox.file] {file delete bbox.file; echo "Deleted bbox.file"}
	set top_cel_name [get_attr [current_mw_cel] full_name]
	
	set orig [lindex [get_attr $inst_name origin] 0]
	
	if {[lindex $orig 0] == [get_attr $inst_name bbox_llx]} {
	  if {[lindex $orig 1] == [get_attr $inst_name bbox_lly]} {
	    set flag 0
	  } elseif {[lindex $orig 1] == [get_attr $inst_name bbox_ury]} {
	    set flag 3
	  }
	} elseif {[lindex $orig 1] == [get_attr $inst_name bbox_lly]} {
	    set flag 1
	  } else {
	    set flag 2
	  }
	
	set flago [switch [get_attr $inst_name orientation] {FW - FE - E - W {format 1} default {format 0}}]
	set master_name [get_attr [get_cells $inst_name] ref_name]
	create_net $net_name
	
	open_mw_cel  [get_attr [get_cells $inst_name] ref_name].FRAM -readonly
	foreach_in_collection shape [get_user_shapes -filter "layer == $layer"] {
	set bbox [get_attr $shape bbox]
	echo $bbox >> bbox.file
	}
	close_mw_cel $master_name.FRAM
	
	set fp [open bbox.file r]
	while {[gets $fp bbox] >= 0} {
	
	set x1 [lindex [lindex [lindex [lindex $bbox 0 ] 0 ] 0 ]]
	set y1 [lindex [lindex [lindex [lindex $bbox 0 ] 0 ] 1 ]]
	set x2 [lindex [lindex [lindex [lindex $bbox 0 ] 1 ] 0 ]]
	set y2 [lindex [lindex [lindex [lindex $bbox 0 ] 1 ] 1 ]]
	
	if {$flago == 1} {
	  set tmp $x1
	  set x1 $y1
	  set y1 $tmp
	  
	  set tmp $x2
	  set x2 $y2
	  set y2 $tmp
	}
	if {$flag == 0} {
	set rx1 [expr $x1+[lindex $orig 0]]
	set ry1 [expr $y1+[lindex $orig 1]]
	set rx2 [expr $x2+[lindex $orig 0]]
	set ry2 [expr $y2+[lindex $orig 1]]
	} elseif {$flag == 1} {
	set rx1 [expr [lindex $orig 0]-$x1]
	set rx2 [expr [lindex $orig 0]-$x2]
	set ry1 [expr [lindex $orig 1]+$y1]
	set ry2 [expr [lindex $orig 1]+$y2]
	} elseif {$flag == 2} {
	set rx1 [expr [lindex $orig 0]-$x1]
	set rx2 [expr [lindex $orig 0]-$x2]
	set ry1 [expr [lindex $orig 1]-$y1]
	set ry2 [expr [lindex $orig 1]-$y2]
	} elseif {$flag == 3} {
	set rx1 [expr [lindex $orig 0]+$x1]
	set rx2 [expr [lindex $orig 0]+$x2]
	set ry1 [expr [lindex $orig 1]-$y1]
	set ry2 [expr [lindex $orig 1]-$y2]
	}
	set xlist [lsort -real [list $rx1 $rx2]]
	set ylist [lsort -real [list $ry1 $ry2]]
	
	create_net_shape -net $net_name -bbox [list [list [lindex $xlist 0] [lindex $ylist 0]] [list [lindex $xlist 1] [lindex $ylist 1]]] -type rect -layer $layer
	}
	close $fp
}

define_proc_attributes copy_fram_shapes \
        -info "Copies the shapes belonging to the specified layer from FRAM view to the top level" \
        -define_args { 
    { -layer   "Name of layer" "" string required }
    { -instance   "Instance name" "" string required }
    { -net_name   "Name of the net that needs to be created and mapped to newly created metal shapes" "" string required }
}

##################
# get all cells of module: iccGetModuleCells A/B/*
proc iccGetModuleCells { hier_pattern } {
	get_cells -hier * -filter "full_name=~$hier_pattern && is_hierarchical==false"
}
#################
# get Via of one nets
proc iccGetNetVia { net_name via_type } {
	get_vias -of $net_name -filter "via_master==$via_type"
}
#################
# get FF without clock source
proc no_clock {} {
	foreach_in_collection i [all_registers  -clock_pins] {
   		if { [get_attr -quiet [get_attr -quiet $i full_name] is_on_clock_network] != true } { 
       		echo " [get_attr -quiet $i full_name] is not on clock network" } 
       	}
}
#####################################################################
# creat Bonding Cell 
#####################################################################
# Example:                                                          #
#   createNplace_bondpads -inline_pad_ref_name PADIZ40 ;#inline     #
#   createNplace_bondpads -inline_pad_ref_name PADIZ40 \            #
#                         -stagger true \                           #
#                         -stagger_pad_ref_name PADOZ40             #
#                                                                   #
#####################################################################

proc createNplace_bondpads {args} {
  
  parse_proc_arguments -args $args pargs
  
  ## get bond pad style 
  if {[info exists pargs(-stagger)]} {
     set stagger $pargs(-stagger)
  } else {
     set stagger false
  }
  
  ## get inline bond pad ref_name
  if {[info exists pargs(-inline_pad_ref_name)]} {

      set bond_pad_ref_name $pargs(-inline_pad_ref_name)
      ## check specified inline bond pad cell
      if {[get_physical_lib_cells $bond_pad_ref_name] == "" } {
            echo ">>>> You specified inline bond pad cell $bond_pad_ref_name don't exist in physical library."
            return
      }

   } else {
        echo ">>>> Please specify the inline bond pad ref_name."
      return
   }

   ## get stagger bond pad ref_name
   if { $stagger == "true" } {
       if {[info exists pargs(-stagger_pad_ref_name)]} {
           set stagger_bond_pad_ref_name $pargs(-stagger_pad_ref_name)
           ## check specified inline bond pad cell
           if {[get_physical_lib_cells $stagger_bond_pad_ref_name] == "" } {
                 echo ">>>> You specified stagger bond pad cell $stagger_bond_pad_ref_name don't exist in physical library."
                 return
           }
     } else {
	   echo ">>>> Please specify the stagger bond pad ref_name." 
	   return
      }
   }

   suppress_message {HDU-104}
   
   ## get bond pad height & width
   set bond_pad_bbox [get_attribute [get_physical_lib_cells $bond_pad_ref_name] bbox]
   set pad_width     [expr [lindex $bond_pad_bbox 1 0] - [lindex $bond_pad_bbox 0 0]]
   set pad_height    [expr [lindex $bond_pad_bbox 1 1] - [lindex $bond_pad_bbox 0 1]]
  
   if {$stagger == "true" } {

      ## get stagger bond pad height & width
      set stagger_bond_pad_bbox [get_attribute [get_physical_lib_cells $stagger_bond_pad_ref_name] bbox]
      set stagger_pad_width     [expr [lindex $stagger_bond_pad_bbox 1 0] - [lindex $stagger_bond_pad_bbox 0 0]]
      set stagger_pad_height    [expr [lindex $stagger_bond_pad_bbox 1 1] - [lindex $stagger_bond_pad_bbox 0 1]]
   }
   
   ## get all left io_pad list and sort tis list by coordinate
   set all_left_io_cell_sort_list ""
   set all_left_io_cell_list [collection_to_list -name_only -no_braces [get_cells -all -hierarchical -filter "mask_layout_type==io_pad && orientation==E"]]
   foreach left_io_cell $all_left_io_cell_list {
   	set io_sort_index [lindex [get_attribute [get_cells -all -hierarchical $left_io_cell] origin] 1]
   	lappend all_left_io_cell_sort_list [list $left_io_cell $io_sort_index]
   }
   set all_left_io_cell_sort_list [lsort -real -index 1 $all_left_io_cell_sort_list]

   ## get all top io_pad list and sort tis list by coordinate
   set all_top_io_cell_sort_list ""
   set all_top_io_cell_list [collection_to_list -name_only -no_braces [get_cells -all -hierarchical -filter "mask_layout_type==io_pad && orientation==S"]]
   foreach top_io_cell $all_top_io_cell_list {
   	set io_sort_index [lindex [get_attribute [get_cells -all -hierarchical $top_io_cell] origin] 0]
   	lappend all_top_io_cell_sort_list [list $top_io_cell $io_sort_index]	
   }
   set all_top_io_cell_sort_list [lsort -real -index 1 $all_top_io_cell_sort_list]
   	
   ## get all right io_pad list and sort tis list by coordinate
   set all_right_io_cell_sort_list ""
   set all_right_io_cell_list [collection_to_list -name_only -no_braces [get_cells -all -hierarchical -filter "mask_layout_type==io_pad && orientation==W"]]
   foreach right_io_cell $all_right_io_cell_list {
   	set io_sort_index [lindex [get_attribute [get_cells -all -hierarchical $right_io_cell] origin] 1]
   	lappend all_right_io_cell_sort_list [list $right_io_cell $io_sort_index]
   }
   set all_right_io_cell_sort_list [lsort -real -index 1 $all_right_io_cell_sort_list]
   	
   ## get all bottom inline io_pad list and sort tis list by coordinate
   set all_bottom_io_cell_sort_list ""
   set all_bottom_io_cell_list [collection_to_list -name_only -no_braces [get_cells -all -hierarchical -filter "mask_layout_type==io_pad && orientation==N"]]
   foreach bottom_io_cell $all_bottom_io_cell_list {
   	set io_sort_index [lindex [get_attribute [get_cells -all -hierarchical $bottom_io_cell] origin] 0]
   	lappend all_bottom_io_cell_sort_list [list $bottom_io_cell $io_sort_index]
   }
   set all_bottom_io_cell_sort_list [lsort -real -index 1 $all_bottom_io_cell_sort_list]

   set all_io_cell_list [concat $all_left_io_cell_sort_list $all_top_io_cell_sort_list $all_right_io_cell_sort_list $all_bottom_io_cell_sort_list]
   
   ## remove current exist inline bonding pad cell
   set get_bond_pad_cells_cmd "get_cells -all -hierarchical -filter \"ref_name =="
   append get_bond_pad_cells_cmd $bond_pad_ref_name "\""
   
   set exist_bond_pad_list [eval $get_bond_pad_cells_cmd]
   
   if { $exist_bond_pad_list !=""} {
      echo ">>>> remove pre-exist inline bond pad cell $stagger_bond_pad_ref_name."
      remove_cell $exist_bond_pad_list
      } else {
      echo ">>>> current cell" [get_object_name [current_mw_cel]] "don't exist inline bond pad cell $bond_pad_ref_name."      
      }

   ## remove current exist stagger bonding pad cell
   if {$stagger == "true"}  {
     set get_stagger_bond_pad_cells_cmd "get_cells -all -hierarchical -filter \"ref_name =="
     append get_stagger_bond_pad_cells_cmd $stagger_bond_pad_ref_name "\""
     
     set exist_stagger_bond_pad_list [eval $get_stagger_bond_pad_cells_cmd]
     
     if { $exist_stagger_bond_pad_list !=""} {
        echo ">>>> remove pre-exist stagger bond pad cell $stagger_bond_pad_ref_name."
        remove_cell $exist_stagger_bond_pad_list
        } else {
        echo ">>>> current cell" [get_object_name [current_mw_cel]] "don't exist stagger bond pad cell $stagger_bond_pad_ref_name."      
	}
   }

   ## stagger pad counter
   set left_i   1
   set top_i    1
   set right_i  1
   set bottom_i 1

   foreach io_cell $all_io_cell_list {
   
      set io_cell_bbox [get_attribute [get_cells -all -hierarchical [lindex $io_cell 0]] bbox]
      set io_cell_orient [get_attribute [get_cells -all -hierarchical [lindex $io_cell 0]] orientation]
      set io_cell_LL_X [lindex $io_cell_bbox 0 0]
      set io_cell_LL_Y [lindex $io_cell_bbox 0 1]
      set io_cell_UR_X [lindex $io_cell_bbox 1 0]
      set io_cell_UR_Y [lindex $io_cell_bbox 1 1]
   
      set bond_pad_name ""
      append bond_pad_name [get_attribute [get_cells -all -hierarchical [lindex $io_cell 0]] name] "_PAD"
   
      ## left side io cell
      if { $io_cell_orient == "E" } {

	 if {$stagger == "true" && ![expr $left_i % 2]} {

	     create_cell $bond_pad_name $stagger_bond_pad_ref_name
             set bond_pad_LL_X [expr $io_cell_LL_X - $stagger_pad_height]
             set bond_pad_LL_Y [expr $io_cell_LL_Y]
         } else {

	    create_cell $bond_pad_name $bond_pad_ref_name
	    set bond_pad_LL_X [expr $io_cell_LL_X - $pad_height]
            set bond_pad_LL_Y [expr $io_cell_LL_Y]
	   }
	 
	 set left_i [expr $left_i + 1]
      }

      ## top side io cell
      if { $io_cell_orient == "S" } {
	 
	 if {$stagger == "true" && ![expr $top_i % 2]} {

	     create_cell $bond_pad_name $stagger_bond_pad_ref_name
	     set bond_pad_LL_X $io_cell_LL_X
             set bond_pad_LL_Y $io_cell_UR_Y

	 } else {
	 
	     create_cell $bond_pad_name $bond_pad_ref_name
             set bond_pad_LL_X $io_cell_LL_X
             set bond_pad_LL_Y $io_cell_UR_Y
         }
        
        set top_i [expr $top_i + 1]
      }
   
      ## right side io cell
      if { $io_cell_orient == "W" } {
	 
	 if {$stagger == "true" && ![expr $right_i % 2]} {

	     create_cell $bond_pad_name $stagger_bond_pad_ref_name
	     set bond_pad_LL_X $io_cell_UR_X
             set bond_pad_LL_Y $io_cell_LL_Y

	 } else {

	    create_cell $bond_pad_name $bond_pad_ref_name
	    set bond_pad_LL_X $io_cell_UR_X
            set bond_pad_LL_Y $io_cell_LL_Y

	 }
	
	set right_i [expr $right_i + 1]

       }
   
      ## bottom side io cell
      if { $io_cell_orient == "N" } {

	 if {$stagger == "true" && ![expr $bottom_i % 2]} {

	     create_cell $bond_pad_name $stagger_bond_pad_ref_name
             set bond_pad_LL_X $io_cell_LL_X
             set bond_pad_LL_Y [expr $io_cell_LL_Y - $stagger_pad_height]

	 } else {
	
	     create_cell $bond_pad_name $bond_pad_ref_name
	     set bond_pad_LL_X $io_cell_LL_X
             set bond_pad_LL_Y [expr $io_cell_LL_Y - $pad_height]

          }

	  set bottom_i [expr $bottom_i + 1]

         }
    
    set_attribute -quiet $bond_pad_name orientation $io_cell_orient
    move_objects -to [list $bond_pad_LL_X $bond_pad_LL_Y] [get_cells $bond_pad_name]
   
   }
   
   ## get current inline bonding pad cell
   set get_bond_pad_cells_cmd "get_cells -all -hierarchical -filter \"ref_name =="
   append get_bond_pad_cells_cmd $bond_pad_ref_name "\""
   
   echo ">>>> Total add" [sizeof_collection [eval $get_bond_pad_cells_cmd]] "inline bond pad cell $bond_pad_ref_name.<<<<"
   
   ## get all stagger io_pad list
   if {$stagger == "true"}  {
     set get_stagger_bond_pad_cells_cmd "get_cells -all -hierarchical -filter \"ref_name =="
     append get_stagger_bond_pad_cells_cmd $stagger_bond_pad_ref_name "\""
     echo ">>>> Total add" [sizeof_collection [eval $get_stagger_bond_pad_cells_cmd]] "stagger bond pad cell $stagger_bond_pad_ref_name.<<<<"
   }

   unsuppress_message {HDU-104}
   
}

define_proc_attributes createNplace_bondpads \
  -info "createNplace_bondpads # create and place bond pad" \
  -define_args {
	{-inline_pad_ref_name "inline bond pad reference name" inline_pad_ref_name string required}
	{-stagger "inline or stagger style bond pad <true | false(default)>" stagger string optional}
	{-stagger_pad_ref_name "stagger bond pad reference name" stagger_pad_ref_name string optional}
}

#####################################################################
# delete bond cell 
# Example:                                                          #
#   delte_bondpads -bond_pad_ref_name PADIZ40 ;#inline bond pad     #
#                                                                   #
#####################################################################
proc delete_bondpads {args} {
  
  parse_proc_arguments -args $args pargs
  
  ## get inline bond pad ref_name
  if {[info exists pargs(-bond_pad_ref_name)]} {

      set bond_pad_ref_name $pargs(-bond_pad_ref_name)

   ## check specified inline bond pad cell
   if {[get_physical_lib_cells $bond_pad_ref_name] == "" } {
 	echo ">>>> You specified inline bond pad cell $bond_pad_ref_name don't exist in physical library."
	return
      }

   } else {
        echo ">>>> Please specify the inline bond pad ref_name."
      return
   }

   ## remove current exist inline bonding pad cell
   set get_bond_pad_cells_cmd "get_cells -all -hierarchical -filter \"ref_name =="
   append get_bond_pad_cells_cmd $bond_pad_ref_name "\""
   
   set exist_bond_pad_list [eval $get_bond_pad_cells_cmd]
   
   if { $exist_bond_pad_list !=""} {
      echo ">>>> remove pre-exist bond pad cell"
      set size [sizeof_collection $exist_bond_pad_list]
      remove_cell [eval $get_bond_pad_cells_cmd]
      echo ">>>> Total deleted" $size "bond pad cell $bond_pad_ref_name.<<<<"      
   } else {
      echo ">>>> current cell" [get_object_name [current_mw_cel]] "don't exist bond pad cell $bond_pad_ref_name."      
   }
}

define_proc_attributes delete_bondpads \
  -info "delete_bondpads # delete bond pad by ref_name" \
  -define_args {
	{-bond_pad_ref_name "deleted bond pad reference name" bond_pad_ref_name string required}
}
#################
# write the selected wire shape

proc iccWriteSelectShape { } { 
file delete -force ./shapes.tcl
set netshapes [get_selection]
foreach_in_collection i $netshapes {
set len [get_attribute -c shape $i length]
set wid [get_attribute -c shape $i width]
set layname [get_attribute -c shape $i layer_name]
set routetype [get_attribute -c shape $i route_type]
set ori [lindex [get_attribute -c shape $i points] 0]
set netna [get_attribute -c shape $i owner_net]
set dtype [get_attribute -c shape $i datatype_number]
if {[string match square_ends_by_half_width [get_attribute -c shape $i endcap]]} {
set ptype 2
}

if {[string match square_ends [get_attribute -c shape $i endcap]]} {
set ptype 0
}

if {[string match round_ends [get_attribute -c shape $i endcap]]} {
set ptype 1
}

if {[regexp {User Enter} $routetype]} {
set rtype user_enter
}

if {[regexp {Signal Route} $routetype]} {
set rtype signal_route

}
 
if {[regexp {Signal Route (Global)} $routetype]} {
set rtype signal_route_global
}

if {[regexp {P/G Ring} $routetype]} {
set rtype pg_ring
}

if {[regexp {Clk Ring} $routetype]} {
set rtype clk_ring
}

if {[regexp {P/G Strap} $routetype]} {
set rtype pg_strap
}

if {[regexp {Clock Strap} $routetype]} {
set rtype clock_strap
}

if {[regexp {P/G Macro/ IO Pin Conn} $routetype]} {
set rtype pg_macro_io_pin_conn
}
if {[regexp {P/G Std. Cell Pin Conn} $routetype]} {
set rtype pg_std_cell_pin_conn
}
if {[regexp {Zero-Skew Route} $routetype]} {
set rtype clk_zero_skew_route
}
if {[regexp {Bus} $routetype]} {
set rtype bus
}
if {[regexp {Shield (fix)} $routetype]} {
set rtype shield
}
if {[regexp {Shield (dynamic)} $routetype]} {
set rtype shield_dynamic
}

if {[regexp {Fill Track} $routetype]} {
set rtype clk_fill_track
}

if {[regexp {Unknown} $routetype]} {
set rtype unknown
}

set verthorz [get_attribute -c shape $i object_type]

if {[string match VWIRE $verthorz]} {
redirect -append shapes.tcl {echo -n  "create_net_shape -no_snap -type wire -vertical -net $netna -layer $layname -datatype $dtype -path_type $ptype -route_type $rtype -length $len  -width $wid -origin [list $ori] \n"}


} else {
redirect -append shapes.tcl {echo -n  "create_net_shape -no_snap -type wire -net $netna -layer $layname -datatype $dtype -path_type $ptype -route_type $rtype -length $len  -width $wid -origin [list $ori] \n"}
}
}
}
###########################
# get RC from Star and ICC
# example : icc_star_nets net1 icc.spef star.spef
###########################
proc icc_star_nets {netname spef_icc spef_star} {
file delete -force ./single_icc.txt
set flag_net 0
set break_flag 0
# echo "$netname"
set fp [open "$spef_icc"]

while {[gets $fp line] != -1} {
if {[regexp $netname$ $line]} {
set net_id [lindex $line 0]
set sl [string length $net_id]
set net_id_no [string range $net_id 1 [expr $sl -1]]
# echo "$net_id_no"
# echo "$net_id"
set flag_net 1
}




if { $flag_net == 1} {
if { [string first "*D_NET $net_id " $line] != -1} {
redirect -file single_icc.txt {echo "$line"}
for {set i 1} {$break_flag !=1} {incr i} {
gets $fp line1
if {[regexp END $line1]} {
set break_flag 1
# echo "break_flag"
}
redirect -append -file single_icc.txt {echo "$line1"}
}
}
}
}

close $fp

if {[file exists "single_icc.txt"]} {

set flag_cap 0
set flag_res 0
set num_star 0
set num_nccap {}
set num_ccap {}
set num_res {}

set fp1 [open "single_icc.txt"]


 
while {[gets $fp1 sline] != -1} {

### total cap
if {[regexp D_NET $sline]} {
set tcap [lindex $sline 2]
}

### Non coupling cap and coupling cap

if {[regexp CAP $sline]} {
for {set j 0} {$flag_cap != 1} {incr j} {
gets $fp1 sline1
#echo "$sline1"
set slength [string length $sline1]

for {set k 0} {$k < $slength} {incr k} {                                                                                        
#echo "raj"
if {[string equal * [string index $sline1 $k]]} {                                                                              
# echo "raj1"
incr num_star 
 }
}

if {[regexp RES $sline1]} {
set flag_cap 1
}

if {$flag_cap != 1} {
if {$num_star == 1} {
# echo "1"
lappend num_nccap [lindex $sline1 2]
}
}

if {$flag_cap != 1} {
if {$num_star == 2} {
# echo "2"
lappend num_ccap [lindex $sline1 3]
}
}

set num_star 0
} 

for {set l 0} {$flag_res != 1} {incr l} {


gets $fp1 sline2
if {[regexp END $sline2]} {
set flag_res 1
}

if {$flag_res != 1} {
lappend num_res [lindex $sline2 3]
}


}


}


}
close $fp1


set temp_nccap 0
set temp_ccap 0
set temp_res 0
foreach i $num_nccap {
set temp_nccap [expr $i+$temp_nccap]
}


foreach i $num_ccap {
set temp_ccap [expr $i+$temp_ccap]
}

foreach i $num_res {
set temp_res [expr $i+$temp_res]
}

# unset num_nccap
# unset num_ccap
# unset num_res

set icc($netname,tcap) $tcap
set icc($netname,nccap) $temp_nccap
set icc($netname,ccap) $temp_ccap
set icc($netname,res) $temp_res

} else {

set icc($netname,tcap) NO
set icc($netname,nccap) NO
set icc($netname,ccap) NO
set icc($netname,res) NO
}

file delete -force ./single.txt

set flag_net 0
set break_flag 0
# echo "$netname"
set fp [open "$spef_star"]

while {[gets $fp line] != -1} {
if {[regexp $netname$ $line]} {
set net_id [lindex $line 0]
set sl [string length $net_id]
set net_id_no [string range $net_id 1 [expr $sl -1]]
# echo "$net_id_no"
# echo "$net_id"
set flag_net 1
}

if { $flag_net == 1} {
if { [string first "*D_NET $net_id " $line] != -1} {
redirect -file single.txt {echo "$line"}
for {set i 1} {$break_flag !=1} {incr i} {
gets $fp line1
if {[regexp END $line1]} {
set break_flag 1
# echo "break_flag"
}
redirect -append -file single.txt {echo "$line1"}
}
}
}
}

close $fp

if {[file exists "single.txt"]} {

set flag_cap 0
set flag_res 0
set num_star 0
set num_nccap {}
set num_ccap {}
set num_res {}

set fp1 [open "single.txt"]

while {[gets $fp1 sline] != -1} {

### total cap
if {[regexp D_NET $sline]} {
set tcap [lindex $sline 2]
}

### Non coupling cap and coupling cap

if {[regexp CAP $sline]} {
for {set j 0} {$flag_cap != 1} {incr j} {
gets $fp1 sline1
#echo "$sline1"
set slength [string length $sline1]

for {set k 0} {$k < $slength} {incr k} {                                                                                        
#echo "raj"
if {[string equal * [string index $sline1 $k]]} {                                                                              
# echo "raj1"
incr num_star 
 }
}

if {[regexp RES $sline1]} {
set flag_cap 1
}

if {$flag_cap != 1} {
if {$num_star == 1} {
# echo "1"
lappend num_nccap [lindex $sline1 2]
}
}

if {$flag_cap != 1} {
if {$num_star == 2} {
# echo "2"
lappend num_ccap [lindex $sline1 3]
}
}

set num_star 0
} 

for {set l 0} {$flag_res != 1} {incr l} {


gets $fp1 sline2
if {[regexp END $sline2]} {
set flag_res 1
}

if {$flag_res != 1} {
lappend num_res [lindex $sline2 3]
}
}
}
}
close $fp1
set temp_nccap 0
set temp_ccap 0
set temp_res 0
foreach i $num_nccap {
set temp_nccap [expr $i+$temp_nccap]
}

foreach i $num_ccap {
set temp_ccap [expr $i+$temp_ccap]
}

foreach i $num_res {
set temp_res [expr $i+$temp_res]
}

# unset num_nccap
# unset num_ccap
# unset num_res

set star($netname,tcap) $tcap
set star($netname,nccap) $temp_nccap
set star($netname,ccap) $temp_ccap
set star($netname,res) $temp_res

} else {

set star($netname,tcap) NO
set star($netname,nccap) NO
set star($netname,ccap) NO
set star($netname,res) NO
}

echo "For ICC, Total Capacitance of the $netname is $icc($netname,tcap)"
echo "For Star-rcxt, Total Capacitance of the $netname is $star($netname,tcap) \n"

echo "For ICC, Total Non-Coupling Capacitance of the $netname is $icc($netname,nccap)"
echo "For Star-rcxt, Total Non-Coupling Capacitance of the $netname is $star($netname,nccap) \n"

echo "For ICC, Total Coupling Capacitance of the $netname is $icc($netname,ccap)"
echo "For Star-rcxt, Total Coupling Capacitance of the $netname is $star($netname,ccap) \n"

echo "For ICC, Total Resistance of the $netname is $icc($netname,res)"
echo "For Star-rcxt, Total Resistance of the $netname is $star($netname,res)"
}

#############################
# add macro pin nets 
###
proc add_pattern_macro_pins { cell_name dx dy} {

####### To get (llx,lly) and (urx,ury) of the macro bbox ########

set macro_bbox [get_attribute $cell_name bbox]
set llx [lindex [lindex $macro_bbox 0] 0] 
set lly [lindex [lindex $macro_bbox 0] 1] 
set urx [lindex [lindex $macro_bbox 1] 0] 
set ury [lindex [lindex $macro_bbox 1] 1] 

######## To get macro pins which are touching bbox of the macro #########

set left [get_pins -of [get_cells $cell_name] -filter "bbox_llx == $llx"]
set bottom [get_pins -of  [get_cells $cell_name]  -filter "bbox_lly == $lly"]
set right [get_pins -of  [get_cells $cell_name]  -filter "bbox_urx == $urx"]
set top [get_pins -of  [get_cells $cell_name]  -filter "bbox_ury == $ury"]

############ PINS on Left side ############

if { [sizeof_collection $left] == 0} {
echo "There are no pins on left side of the Macro"
} else {


foreach_in_collection i $left {

set netname_le [get_nets -of [get_pins $i]]

if { [llength $netname_le] != 0} {
set pin_layers_le [get_attribute -c pin  $i layer]
set pin_bbox_le [get_attribute -c pin  $i bbox]
set pin_height_le [expr [lindex [lindex $pin_bbox_le 1] 1] - [lindex [lindex $pin_bbox_le 0] 1]]

if { $dy < $pin_height_le} {
set seg_x0_le [expr [lindex [lindex $pin_bbox_le 0] 0] -$dx]
set seg_y0_le [expr [expr [lindex [lindex $pin_bbox_le 0] 1] + [expr $dy/2]] + [expr [expr $pin_height_le - $dy]/2]]
for {set p 0} {$p < [llength $pin_layers_le]} {incr p} {
create_net_shape -no_snap -type wire -net $netname_le -layer [lindex $pin_layers_le $p] -path_type 0 -route_type user_enter -length $dx  -width $dy -origin [list $seg_x0_le $seg_y0_le]
} 
}


if {$dy == $pin_height_le} { 
set seg_x0_le [expr [lindex [lindex $pin_bbox_le 0] 0] -$dx]
set seg_y0_le [expr [lindex [lindex $pin_bbox_le 0] 1] +[expr $dy/2]]
for {set p 0} {$p < [llength $pin_layers_le]} {incr p} {
create_net_shape -no_snap -type wire -net $netname_le -layer [lindex $pin_layers_le $p] -path_type 0 -route_type user_enter -length $dx  -width $dy -origin [list $seg_x0_le $seg_y0_le]
} 
}

if { $dy > $pin_height_le} {
set seg_x0_le [expr [lindex [lindex $pin_bbox_le 0] 0] -$dx]
set seg_y0_le [expr [expr [lindex [lindex $pin_bbox_le 0] 1] + [expr $dy/2]] - [expr [expr $dy - $pin_height_le]/2]]
for {set p 0} {$p < [llength $pin_layers_le]} {incr p} {
create_net_shape -no_snap -type wire -net $netname_le -layer [lindex $pin_layers_le $p] -path_type 0 -route_type user_enter -length $dx  -width $dy -origin [list $seg_x0_le $seg_y0_le]
} 
}

} else {

echo "There is no logical net connected to [get_attribute $i full_name] on left side"
}
}
}



############ PINS on Right side ############

if { [sizeof_collection $right] == 0} {
echo "There are no pins on right side of the Macro"
} else {


foreach_in_collection j $right {

set netname_ri [get_nets -of [get_pins $j]]

if { [llength $netname_ri] != 0} {

set pin_layers_ri [get_attribute -c pin  $j layer]
set pin_bbox_ri [get_attribute -c pin  $j bbox]
set pin_height_ri [expr [lindex [lindex $pin_bbox_ri 1] 1] - [lindex [lindex $pin_bbox_ri 0] 1]]

if { $dy < $pin_height_ri} {
set seg_x0_ri [lindex [lindex $pin_bbox_ri 1] 0]
set seg_y0_ri [expr [expr [lindex [lindex $pin_bbox_ri 0] 1] + [expr $dy/2]] + [expr [expr $pin_height_ri - $dy]/2]]
for {set p 0} {$p < [llength $pin_layers_ri]} {incr p} {
create_net_shape -no_snap -type wire -net $netname_ri -layer [lindex $pin_layers_ri $p] -path_type 0 -route_type user_enter -length $dx  -width $dy -origin [list $seg_x0_ri $seg_y0_ri]
} 
}


if {$dy == $pin_height_ri} { 
set seg_x0_ri [lindex [lindex $pin_bbox_ri 1] 0]
set seg_y0_ri [expr [lindex [lindex $pin_bbox_ri 0] 1] +[expr $dy/2]]
for {set p 0} {$p < [llength $pin_layers_ri]} {incr p} {
create_net_shape -no_snap -type wire -net $netname_ri -layer [lindex $pin_layers_ri $p] -path_type 0 -route_type user_enter -length $dx  -width $dy -origin [list $seg_x0_ri $seg_y0_ri]
} 
}

if { $dy > $pin_height_ri} {
set seg_x0_ri [lindex [lindex $pin_bbox_ri 1] 0]
set seg_y0_ri [expr [expr [lindex [lindex $pin_bbox_ri 0] 1] + [expr $dy/2]] - [expr [expr $dy - $pin_height_ri]/2]]
for {set p 0} {$p < [llength $pin_layers_ri]} {incr p} {
create_net_shape -no_snap -type wire -net $netname_ri -layer [lindex $pin_layers_ri $p] -path_type 0 -route_type user_enter -length $dx  -width $dy -origin [list $seg_x0_ri $seg_y0_ri]
} 
}

} else {

echo "There is no logical net connected to [get_attribute $j full_name] on right side"
}

}
}

}

#####################
#get overlaped cell
proc iccGetOverlapCell {} {
global tcells {}
set lcells {}
file delete -force ./rep_legality.txt
link
check_legality -verbose > rep_legality.txt
set fp [open "rep_legality.txt"]
while {[gets $fp line] != -1} {
if {[string match (PSYN-055) [lindex $line [expr [llength $line]-1]]]} {
lappend lcells [lindex $line 2]
}
}
close $fp
if {[llength $lcells]} {
set tcells [lsort -unique $lcells]
change_selection [get_cells $tcells]
} else {
echo "There are no overlapped cells"
}
}
#####################
# shielding for long net
# example : iccShield $net_name 100
 
proc iccShield {netname threshold} { 
	set netseg [get_attribute $netname route_length]
	set es {}
	for {set i 0} {![string equal  $es [lindex [lindex [lindex $netseg 0] $i] 1]]} {incr i} {
		lappend netvalue [lindex [lindex [lindex $netseg 0] $i] 1]
	}
	
	set totlen 0
	foreach i $netvalue {
		set totlen [expr $totlen + $i]
	}
	
	if { $threshold < $totlen } {
		define_routing_rule shieldrule \
		-shield_widths {METAL 0.18 METAL2 0.22 METAL3 0.22 METAL4 0.46} \
		-shield_spacing {METAL 0.20 METAL2 0.23 METAL3 0.23 METAL4 0.48}
		set_net_routing_rule $netname -rule shieldrule
		create_auto_shield -nets $netname
	} else {
		echo " No autoshield done on $netname net"
		echo " Reason: Total length of the net is $totlen which doesn't exceed given threshold $threshold"
	} 
}
######################
# BMP to LOGO
################################################################
## This tcl file is used to generate LOGO in ICC.
## tpye "bmp2lay -help" to see help.
################################################################
proc iccBmp2Logo { args } {
  set options(-px) "1"
  set options(-py) "1"
  set options(-layer) "METAL1"
  parse_proc_arguments -args $args options
  set file_name $options(-f)
  set layer_name $options(-layer)
  if { [get_layers $layer_name -q]=="" } {
     puts "xx_error: layer $layer_name does not exist !"
     } else {
	drawbmp $file_name $options(-layer) $options(-px) $options(-py)
     }
} 
define_proc_attributes iccBmp2Logo \
  -info "draw bmp in layout,1 bit bmp, white color is logo" \
  -define_args {
    {-f    "BMP File Name" AString string required}
    {-layer    "layer to use" AString string required}
    {-px   "Pixel Size X in layout"  AnFloat float optional}
    {-py   "Pixel Size Y in layout"  AnFloat float optional}
    {-info "Description of variable" AString string optional}
  }

proc drawbmp {filename layer px_size py_size} {
 
  set f [open $filename r]

# Read the BMP header information

  binary scan [read $f 2] "a2" header_type
  binary scan [read $f 4] "i" header_fsize
  binary scan [read $f 4] "i" header_freserve
  binary scan [read $f 4] "i" header_offset
  binary scan [read $f 4] "i" header_bisize
  binary scan [read $f 4] "i" header_width
  binary scan [read $f 4] "i" header_height
  binary scan [read $f 2] "s" header_biplanes
  binary scan [read $f 2] "s" header_bitcount
  binary scan [read $f 4] "i" header_compress
  seek $f 16 current 
  binary scan [read $f 4] "i" header_colors

  if { $header_type != "BM" } {
    puts stderr "$filename is not a BMP file format."
     return}

  if { $header_colors == 0 } {
    seek $f 0x22 start
    binary scan [read $f 4] "i" imagesize 
    } else {
      set imagesize [expr $header_fsize - $header_offset]
    }
  puts "header_bitcount $header_bitcount"
  switch $header_bitcount {
    1 { set is_single_bit 1}
    default { puts "xx_error: format not support !"
      return}
  }
  seek $f $header_offset start
  set Xsize [expr ($imagesize/$header_height) ] 
  #puts "imagesize $imagesize"
  #puts "header_height $header_height"
  #puts "Xsize $Xsize"
  #puts "header_width $header_width"
  set fix [expr $header_width%4]

  
  for { set ym 0 } { $ym < $header_height } { incr ym } {
     for { set xm 0 } { $xm < $Xsize } { incr xm } {
        binary scan [read $f 1] "H2" data
        set imagedata "0x$data"
	set lx [expr $xm * 8 * $px_size]
	set ly [expr $ym * $py_size]
	set hy [expr $ly + $py_size]

     if {$imagedata&0x80} {
	   set bb "$lx $ly [expr $lx + $px_size] $hy"
	   create_user_shape -type rect -bbox $bb -layer $layer -no_snap
	}
	if {$imagedata&0x40} {
	   set bb "[expr $lx + 1 * $px_size] $ly [expr $lx + 2 * $px_size] $hy"
	   create_user_shape -type rect -bbox $bb -layer $layer -no_snap
	}
	if {$imagedata&0x20} {
	   set bb "[expr $lx + 2 * $px_size] $ly [expr $lx + 3 * $px_size] $hy"
	   create_user_shape -type rect -bbox $bb -layer $layer -no_snap
	}
	if {$imagedata&0x10} {
	   set bb "[expr $lx + 3 * $px_size] $ly [expr $lx + 4 * $px_size] $hy"
	   create_user_shape -type rect -bbox $bb -layer $layer -no_snap
	}
	if {$imagedata&0x08} {
	   set bb "[expr $lx + 4 * $px_size] $ly [expr $lx + 5 * $px_size] $hy"
	   create_user_shape -type rect -bbox $bb -layer $layer -no_snap
	}
	if {$imagedata&0x04} {
	   set bb "[expr $lx + 5 * $px_size] $ly [expr $lx + 6 * $px_size] $hy"
	   create_user_shape -type rect -bbox $bb -layer $layer -no_snap
	}
	if {$imagedata&0x02} {
   	   set bb "[expr $lx + 6 * $px_size] $ly [expr $lx + 7 * $px_size] $hy"
	   create_user_shape -type rect -bbox $bb -layer $layer -no_snap
	}
	if {$imagedata&0x01} {
	   set bb "[expr $lx + 7 * $px_size] $ly [expr $lx + 8 * $px_size] $hy"
	   create_user_shape -type rect -bbox $bb -layer $layer -no_snap
	}
     }
  }
  echo "compress $header_compress , bmp size: $header_width x $header_height"
  close $f
}

###################
# skip route net
proc iccRouteSkipNet { net_name } {
	set_net_routing_rule -rule default -reroute freeze [get_nets ${net_name}]
}

###################
##
proc save_shape_selected { } {
 file delete -force ./shapes.tcl
 set netshapes [get_selection]
 foreach_in_collection i $netshapes {
 
 
 if {[string equal shape [get_attribute $i object_class]]} {
 
 # echo "selected object is shape"
 set len [get_attribute -c shape $i length]
 set wid [get_attribute -c shape $i width]
 set layname [get_attribute -c shape $i layer_name]
 set routetype [get_attribute -c shape $i route_type]
 set ori [lindex [get_attribute -c shape $i points] 0]
 set netna [get_attribute -c shape $i owner_net]
 set dtype [get_attribute -c shape $i datatype_number]
 if {[string match square_ends_by_half_width [get_attribute -c shape $i endcap]]} {
 set ptype 2
 }
 
 if {[string match square_ends [get_attribute -c shape $i endcap]]} {
 set ptype 0
 }
 
 if {[string match round_ends [get_attribute -c shape $i endcap]]} {
 set ptype 1
 }
 
 if {[regexp {User Enter} $routetype]} {
 set rtype user_enter
 }
 
 if {[regexp {Signal Route} $routetype]} {
 set rtype signal_route
 
 }
  
 if {[regexp {Signal Route (Global)} $routetype]} {
 set rtype signal_route_global
 }
 
 if {[regexp {P/G Ring} $routetype]} {
 set rtype pg_ring
 }
 
 if {[regexp {Clk Ring} $routetype]} {
 set rtype clk_ring
 }
 
 if {[regexp {P/G Strap} $routetype]} {
 set rtype pg_strap
 }
 
 if {[regexp {Clk Strap} $routetype]} {
 set rtype clk_strap
 }
 
 if {[regexp {P/G Macro/IO Pin Conn} $routetype]} {
 set rtype pg_macro_io_pin_conn
 }
 if {[regexp {P/G Std. Cell Pin Conn} $routetype]} {
 set rtype pg_std_cell_pin_conn
 }
 if {[regexp {Zero-Skew Route} $routetype]} {
 set rtype clk_zero_skew_route
 }
 if {[regexp {Bus} $routetype]} {
 set rtype bus
 }
 if {[regexp {Shield (fix)} $routetype]} {
 set rtype shield
 }
 if {[regexp {Shield (dynamic)} $routetype]} {
 set rtype shield_dynamic
 }
 
 if {[regexp {Fill Track} $routetype]} {
 set rtype clk_fill_track
 }
 
 if {[regexp {Unknown} $routetype]} {
 set rtype unknown
 }
 
 set verthorz [get_attribute -c shape $i object_type]
 
 if {[string match VWIRE $verthorz]} {
 redirect -append shapes.tcl {echo -n  "create_net_shape -no_snap -type wire -vertical -net $netna -layer $layname -datatype $dtype -path_type $ptype -route_type $rtype -length $len  -width $wid -origin [list $ori] \n"}
 
 
 } else {
 redirect -append shapes.tcl {echo -n  "create_net_shape -no_snap -type wire -net $netna -layer $layname -datatype $dtype -path_type $ptype -route_type $rtype -length $len  -width $wid -origin [list $ori] \n"}
 }
 
 } elseif {[string equal via [get_attribute $i object_class]]} {
 
 # echo "selected object is via"
 
 
 #set v_name [get_attribute -c via $i name]
 set v_via_master [get_attribute -c via $i via_master]
 set v_row [get_attribute -c via $i row]
 set v_col [get_attribute -c via $i col]
 set v_center [get_attribute -c via $i center]
 set v_orientation [get_attribute -c via $i orientation]
 set v_owner_net [get_attribute -c via $i owner_net]
 set v_route_type [get_attribute -c via $i route_type]
 set v_object_type [get_attribute -c via $i object_type]
 
 if {[regexp {User Enter} $v_route_type]} {
 set v_rtype user_enter
 }
 
 if {[regexp {Signal Route} $v_route_type]} {
 set v_rtype signal_route
 
 }
  
 if {[regexp {Signal Route (Global)} $v_route_type]} {
 set v_rtype signal_route_global
 }
 
 if {[regexp {P/G Ring} $v_route_type]} {
 set v_rtype pg_ring
 }
 
 if {[regexp {Clk Ring} $v_route_type]} {
 set v_rtype clk_ring
 }
 
 if {[regexp {P/G Strap} $v_route_type]} {
 set v_rtype pg_strap
 }
 
 if {[regexp {Clk Strap} $v_route_type]} {
 set v_rtype clk_strap
 }
 
 if {[regexp {P/G Macro/IO Pin Conn} $v_route_type]} {
 set v_rtype pg_macro_io_pin_conn
 }
 if {[regexp {P/G Std. Cell Pin Conn} $v_route_type]} {
 set v_rtype pg_std_cell_pin_conn
 }
 if {[regexp {Zero-Skew Route} $v_route_type]} {
 set v_rtype clk_zero_skew_route
 }
 if {[regexp {Bus} $v_route_type]} {
 set v_rtype bus
 }
 if {[regexp {Shield (fix)} $v_route_type]} {
 set v_rtype shield
 }
 if {[regexp {Shield (dynamic)} $v_route_type]} {
 set v_rtype shield_dynamic
 }
 
 if {[regexp {Fill Track} $v_route_type]} {
 set v_rtype clk_fill_track
 }
 
 if {[regexp {Unknown} $v_route_type]} {
 set v_rtype unknown
 }
 
 if {[string match via_array $v_object_type]} {
 redirect -append shapes.tcl {echo -n "create_via -no_snap -type $v_object_type -net $v_owner_net -master $v_via_master -route_type $v_rtype -at [list $v_center] -orient $v_orientation -row $v_row -col $v_col \n"}
 } else {
 
 redirect -append shapes.tcl {echo -n "create_via -no_snap -type $v_object_type -net $v_owner_net -master $v_via_master -route_type $v_rtype -at [list $v_center] -orient $v_orientation \n"}
 }
 
 } else {
 echo "object_class of selected object [get_attribute $i full_name] is neither shape nor via "
 }
 }
}
##### get_all_nets ##
proc get_all_nets_from_all_stage { total_cell_list file file_ccx} {
#  set total_cell_list [get_cells {cmu1_l2t23_l2b23 l2d3 spc3 l2d2 spc7 spc2}]
  set file [open $file w]
  set file_ccx [open $file_ccx w]
  set all_cell_pins ""
  set all_pin_nets ""
  foreach_in_collection cell $total_cell_list {
    foreach_in_collection pin [get_pins -of $cell] {
      if { [get_attribute $pin direction] eq "out" } {
	   append_to_collection all_cell_pins [ all_fanout -from $pin ]
      }
      if { [get_attribute $pin direction] eq "in" } {
	   append_to_collection all_cell_pins [ all_fanin -to $pin ]
      }
    }
  }
#  set all_cell_pins [filter_collection $all_cell_pins " name !~ ccx* "]
  
  foreach_in_collection pin $all_cell_pins {
#    append_to_collection all_pin_nets [get_nets -of $pin -seg -top] full_name]
    set pin_names [get_attribute  $pin full_name]
    if { [regexp ccx  $pin_names] } { 
    set net_names [get_attribute [get_nets -of $pin -seg -top] full_name]
    puts $file_ccx $net_names
    } else {
   	 set net_names [get_attribute [get_nets -of $pin -seg -top] full_name]
  	 puts $file $net_names
    }
  }
  close $file
}
####3
 
proc get_net_value_list { file_net value file_out} {
set G [open ${file_net} r]
set GG [ open ${file_out} w]
        while { [gets $G line] >=0 } {
		set x_length [get_attribute [get_net $line ] x_length ]
		set y_length [get_attribute [get_net $line ] y_length ]
	  	if { $x_length == ""} {
		  puts $GG $line
		  continue
		}
		set total_length [expr ($x_length + $y_length)/1000]
		if { $total_length > $value } { 
		  puts $GG "$line $total_length"
	      	}
              }
close $G
close $GG
}

# get_cell_beween_two cell 

proc get_all_cells_between_them { total_cell_list patten file } {
#  set total_cell_list [get_cells {cmu1_l2t23_l2b23 l2d3 spc3 l2d2 spc7 spc2}]
  set file [open $file w]
  set all_cell_pins_out ""
  set all_cell_pins_in ""
  set all_pin_nets ""
  foreach_in_collection cell $total_cell_list {
    foreach_in_collection pin [get_pins -of $cell] {
      set pin_names [get_attribute  $pin full_name]
      puts $pin_names
      if { [get_attribute $pin is_on_clock_network ]} { continue }
      if { [get_attribute $pin direction] eq "out" } {
	   append_to_collection all_cell_pins_out [ all_fanout -from $pin ]
      }
    }
  }
  foreach_in_collection pin $all_cell_pins_out {
    set names_aa [get_attribute $pin full_name]
  #  if { [get_attribute $pin object_class] == "port" } {continue}
    if { [sizeof_collection [ get_pins -of [get_cells -of $pin ] -filter "direction ==out" ]] > 1} {
    	continue
      }
    	set end_cell [all_fanout -endpoints_only -from [get_pins -of [get_cells -of $pin ] -filter "direction ==out" ] ]
    	set pin_end [get_attribute $end_cell full_name ]
    	set cel_names [get_attribute [get_cells -of $pin ] full_name ]
	puts "$cel_names $patten"
    if { [regexp $patten $pin_end] } { 
    	set cel_names [get_attribute [get_cells -of $pin ] full_name ]
    	set ref_names [get_attribute [get_cells -of $pin ] ref_name ]
        puts $file "$cel_names  $ref_names"
    }

  }
  close $file
}

#### 
proc write_all_selection_to_file { file } {
 set file [open ${file} w]
 foreach_in_collection obj [get_selection] {
   set object_class [get_attribute $obj object_class]
   if { $object_class == "pin" } {
      set names_pin [get_attribute $obj full_name]
      puts $file "$obj $names_pin"
   }
   if { $object_class == "cell" } {
      set names_cel [get_attribute $obj full_name]
      puts $file "$obj $names_cel"
   }
   if { $object_class == "net" } {
      set names_net [get_attribute $obj full_name]
      puts $file "$obj $names_net"
   }
 }
 close $file
}
###
proc write_all_file_to_file { file_in file_out } {
 set file_1 [open ${file_in} w]
 set file_2 [open ${file_out} w]
 foreach_in_collection obj [get_selection] {
   set object_class [get_attribute $obj object_class]
   if { $object_class == "pin" } {
      set names_pin [get_attribute $obj full_name]
      puts $file "$obj $names_pin"
   }
   if { $object_class == "cell" } {
      set names_cel [get_attribute $obj full_name]
      puts $file "$obj $names_cel"
   }
   if { $object_class == "net" } {
      set names_net [get_attribute $obj full_name]
      puts $file "$obj $names_net"
   }
 }
 close $file_1
 close $file_2
}
###  ???? 
proc set_iso_location {} {
 foreach_in_collection line [get_selection] {  
   set cell_coor_y [lindex [lindex [get_attribute $line bbox] 0] 1]
   set pins [get_pins -of [get_nets -of [get_pins -of [get_cells $line] -filter "direction == out"] ] -filter "direction == in"]
   set pins_coor_x [lindex [lindex [get_attribute $pins bbox] 0] 0]
   set_attribute -quiet [get_cell $line] origin [list $pins_coor_x $cell_coor_y]
 }
 close $file
 foreach_in_collection line [get_selection] {  
   set cell_coor_y [lindex [lindex [get_attribute $line bbox] 0] 1]
   set pins [get_pins -of [get_nets -of [get_pins -of [get_cells $line] -filter "direction == in"] ] -filter "direction == out"]
   set pins_coor_x [lindex [lindex [get_attribute $pins bbox] 0] 0]
   set_attribute -quiet [get_cell $line] origin [list $pins_coor_x $cell_coor_y]
 }
 close $file
 
}
### ISO selection
proc ISO_selection_pin { collection lib_cell clk_pattern} {
	set list_hotpin [filter_collection $list_hotpin "full_name !~ *${clk_pattern}* && pin_direction == out" ]
	foreach_in_collection mem_pin $collection {
	  set mem_pin_name [get_attribute [get_pins $mem_pin] full_name]
	  ISOLATE_MEMORY -lib_cell $clk_pattern -iso_string ISO_cmu_l2b_l2d_ -pin_name $mem_pin_name
	}
}

proc ISO_selected_cell { cell_name lib_cell clk_pattern} {
	set mem_cells [get_cell ${cell_name} ]
	foreach_in_collection mem_cell $mem_cells {
		set mem_pins [get_pins -of_objects [get_cells $mem_cell]]
		set mem_pins [filter_collection $mem_pins "full_name !~ *${clk_pattern}* && pin_direction == out" ]
		foreach_in_collection mem_pin $mem_pins {
		  set mem_pin_name [get_attribute [get_pins $mem_pin] full_name]
		  ISOLATE_MEMORY -lib_cell $lib_cell -iso_string ISO_l2d1_ -pin_name $mem_pin_name
		}
	}
}
###
proc get_all_selection_cell_driver_load { collection } {
  foreach_in_collection cell $collection {
    set in_pin [get_pins -of [get_cells $cell ] -filter "direction == in" ]
    set out_pin [get_pins -of [get_cells $cell ] -filter "direction == out" ]
    set in_cells [all_fanin -to $in_pin -only -levels 1  -flat ]
    set out_cells [all_fanout -from $out_pin -only -levels 1  -flat ]
    change_selection -add [get_cell $in_cells ]
    change_selection -add [get_cell $out_cells  ]
  }
}

# get pi
proc gnpo { net_name } {
	change_selection [get_flat_pins -of [get_flat_nets $net_name] -filter "direction == out"]
	set pin_name [get_attribute [get_flat_pins -of [get_flat_nets $net_name] -filter "direction == out"] full_name]
	set pin_type [get_attribute [get_cells -of [get_flat_pins -of [get_flat_nets $net_name] -filter "direction == out"]] ref_name]
	echo $pin_name $pin_type
  	gui_zoom -selection -window [gui_get_current_window -types "Layout" -mru]
        qp [get_selection]
}
proc gscn { } {
	set cell_name [get_attribute [get_selection] full_name]
	set ref_name [get_attribute [get_selection] ref_name]
	echo $cell_name $ref_name
}
proc gspn { } {
	set pin_name [get_attribute [get_selection] full_name]
	echo $pin_name
}
proc gcon { cell_name  } {
	change_selection [get_net -of [get_pins -of [get_cells $cell_name] -filter "direction == out"] -seg -top]
  	#gui_zoom -selection -window [gui_get_current_window -types "Layout" -mru]
      	set net_name [get_attribute [get_selection] full_name]
      	echo $net_name
}
proc gcon { } {
  	set cell_name [get_selection]
	change_selection [get_net -of [get_pins -of [get_cells $cell_name] -filter "direction == out"] -seg -top]
  	#gui_zoom -selection -window [gui_get_current_window -types "Layout" -mru]
      	set net_name [get_attribute [get_selection] full_name]
      	echo $net_name
}
proc gnp { net_name } {
  	set net_names [get_attribute [get_net $net_name] full_name]
	change_selection [get_flat_pins -of [get_nets $net_name]]
	foreach_in_collection pin [get_flat_pins -of [get_nets $net_name]] {
		set pin_name [get_attribute $pin full_name]
		echo $pin_name
	}
	
}
proc gcc { patten } {
  	set cell_name [get_selection]
  	set cell_names [get_attribute [get_cell $cell_name] full_name]
    	set cell_loca [lindex [get_attribute [get_cell $cell_name] bbox] 0]
    	puts "cell's name --> $cell_names"
        set all_cell [ all_fanout -from [get_pins -of [get_cells $cell_name] -filter "direction == out"] -only -level 1 -flat] 
    	set all_cell [filter_collection $all_cell "full_name !~ *$patten*"]
    	set all_cell [filter_collection $all_cell "full_name != $cell_names"]
            #gui_zoom -selection -window [gui_get_current_window -types "Layout" -mru]
      	foreach_in_collection only_cell $all_cell {
            set cell_name [get_attribute $only_cell full_name]
	    set ref_name [get_attribute $only_cell ref_name]
	        echo "- ${cell_name}/A BUFH_X16M_A12TL -coordinate {$cell_loca} -eco_string aaa - $ref_name" 
	        #echo "- $cell_name {$cell_loca} - $ref_name" 
	      }
}
#

proc gcp { { pin_name [get_selection]} patten} {
  	set cell_names [get_attribute [get_cell -of [get_pin $pin_name]] full_name]
    	set pin_loca [lindex [get_attribute [get_pin $pin_name] bbox] 0]
    	puts "cell's name --> $cell_names"
        set all_cell [ all_fanout -from $pin_name -only -level 1 -flat] 
    	set all_cell [filter_collection $all_cell "full_name !~ *$patten*"]
    	#set all_cell [filter_collection $all_cell "full_name != $cell_names"]
            #gui_zoom -selection -window [gui_get_current_window -types "Layout" -mru]
      	foreach_in_collection only_cell $all_cell {
            set cell_name [get_attribute $only_cell full_name]
	    set ref_name [get_attribute $only_cell ref_name]
	        echo "- ${cell_name}/A BUFH_X16M_A12TL -coordinate {$pin_loca} -eco_string aaa - $ref_name" 
	      }
}
#proc gpoc { {patten [get_selection]} } {
#  	set pin_name [get_selection]
#  	set cell_names [get_attribute [get_cell -of [get_pin $pin_name]] full_name]
#    	set pin_loca [lindex [get_attribute [get_pin $pin_name] bbox] 0]
#    	puts "cell's name --> $cell_names"
#        set all_cell [ all_fanout -from $pin_name -only -level 1 -flat] 
#    	set all_cell [filter_collection $all_cell "full_name !~ *$patten*"]
#    	#set all_cell [filter_collection $all_cell "full_name != $cell_names"]
#            #gui_zoom -selection -window [gui_get_current_window -types "Layout" -mru]
#      	foreach_in_collection only_cell $all_cell {
#            set cell_name [get_attribute $only_cell full_name]
#	    set ref_name [get_attribute $only_cell ref_name]
#	        echo "- ${cell_name}/A BUFH_X16M_A12TL -coordinate {$cell_loca} -eco_string aaa - $ref_name" 
#	      }
#}

#
proc gnpi { net_name } {
	change_selection [get_pins -of [get_nets $net_name] -filter "direction == in"]
  	gui_zoom -selection -window [gui_get_current_window -types "Layout" -mru]
        qp [get_selection]
}
#
proc gpc {pin_name} {
	if { [get_attribute $pin_name direction] == "in" } {
	  set cell [all_fanin -to $pin_name -level 1 -only -flat ]
	 qc $cell
	}
	if { [get_attribute $pin_name direction] == "out" } {
	  set cell [all_fanout -from $pin_name -level 1 -only -flat ]
	qc $cell
	}
}
proc gpn {pin_name} {
	set net [get_attribute [get_flat_nets -of [get_pins $pin_name]] full_name]
	sn $net
	change_selection 
	echo $net
	qn $net
}
proc gspc { } {
  	set pin_name [get_selection]
	if { [get_attribute $pin_name direction] == "in" } {
	  set cell [all_fanin -to $pin_name -level 1 -only -flat ]
	 qc $cell
	}
	if { [get_attribute $pin_name direction] == "out" } {
	  set cell [all_fanout -from $pin_name -level 1 -only -flat ]
	qc $cell
	}
}
proc gscc  { } {
	change_selection [get_flat_cells -of [get_flat_nets -of [get_selection] ] -filter "mask_layout_type == std" ]
}

# 
proc gtn { net } {
	set net_top [get_attribute [get_net $net -top -seg] full_name]
      	echo $net_top
}
#
proc proute_guides_for_rail {} {
	set a 0
	foreach_in i [get_placement_blockages -filter "type == hard"] {
	set bbox [get_attr $i bbox]
		create_route_guide -name for_rail_$a -no_preroute_layers \
		[get_object_name [get_layers -filter "is_routing_layer == true && layer_type != via"]] \
		-coordinate $bbox -no_snap
		incr a
        }
}
##

##########set aliases#########
#alias page_on {set sh_enable_page_mode true}
#alias page_off {set sh_enable_page_mode false}
#alias h {history}
#alias rt {report_timing}
#alias rth {report_timing -delay min}

#source /user/home/peterl/work/pt_script/get_objects.tcl
#########procedures##########
proc clk { ck_pin } {
#  report_timing -from $ck_pin -path_type full_clock_expanded -nets -input_pins
report_clock_timing -to $ck_pin -type latency -verbose -nosplit
}
proc pn { pin } {
	get_flat_nets -of [get_flat_pins $pin -all]
}
proc sel { cell } {
	change_selection [get_cells $cell ]
	change_selection [get_cells $cell -hier ]
	gui_zoom -window [lindex [ gui_get_window_ids ] end ]  -selection
}
proc unsel { } {
	change_selection
}
proc clk1 { ck_pin } {
#  report_timing -from $ck_pin -path_type full_clock_expanded -nets -input_pins
report_clock_timing -to $ck_pin -type latency -verbose -nworst 1
}

#proc get_model {model} {
#	get_lib_cells  [ get_attri [get_libs *hvt*] full_name ]/$model 
#}
proc fpb {from to} {
        report_timing -from $from -to $to -input_pins -nets -nosplit
        }
proc fpbc {from to} {
        report_timing -from $from -to $to -input_pins -nets -path full_clock_expanded -nosplit
        }
proc fpt {to} {
        report_timing -to $to -input_pins -nets -nosplit
        }
proc fpthr {thr} {
        report_timing -th $thr -input_pins -nets -nosplit -significant_digits 3
        }
proc fpthrt {thr to } {
        report_timing -th $thr -to $to -input_pins -nets -nosplit -significant_digits 3
        }
proc fpthrh {thr} {
        report_timing -th $thr -input_pins -nets -nosplit -delay min -significant_digits 3
        }

proc fpthrl {thr less_than} {
        report_timing -th $thr -input_pins -nets -nosplit -slack_lesser_than $less_than -significant_digits 3
        }

proc fptc {to} {
        report_timing -to $to -input_pins -nets -path full_clock_expanded -nosplit
        }
proc fpf {from} {
        report_timing -from $from -input_pins -nets -nosplit
        }
proc fpft {from to} {
        report_timing -from $from -to $to -input_pins -nets -nosplit
        }
proc fpfc {from} {
        report_timing -from $from -input_pins -nets -path full_clock_expanded -nosplit
        }

proc fpbh {from to} {
        report_timing -from $from -to $to -input_pins -nets -nosplit -delay min
        }
proc fpbhc {from to} {
        report_timing -from $from -to $to -input_pins -nets -path full_clock_expanded -nosplit -delay min
        }
proc fpth {to} {
        report_timing -to $to -input_pins -nets -nosplit -delay min -significant_digits 3
        }

proc fptha {to} {
        report_timing -to $to -input_pins -nosplit -delay min -slack_lesser_than 0 -nworst 999
        }
proc fpthc {to} {
        report_timing -to $to -input_pins -nets -path full_clock_expanded -nosplit -delay min
        }
proc fpfh {from} {
        report_timing -from $from -input_pins -nets -nosplit -delay min
        }
proc fpfhc {from} {
        report_timing -from $from -input_pins -nets -path full_clock_expanded -nosplit -delay min
        }

#proc rn {net} {
#        report_net -conn $net
#        }
#proc rc {cell} {
#        report_cell -conn $cell
#        }

proc rn {net} {
	
	set driv_list [get_pins -of_objects $net -leaf -filter "direction =~ *out"]
	set load_list [get_pins -of_objects $net -leaf -filter "direction =~ in*"]
	puts [format "\n\nConnections for net \'%s\'\n    Driver Pins         Type\n    ------------        ----------------" [get_attr $net full_name ] ]
	foreach_in_collection driv $driv_list {
		puts [format "    %s\t\tOutput Pin (%s)" [get_attr $driv full_name] [get_attribute [get_lib_cells -of_objects [get_cells -of_objects $driv] ] full_name] ]
	}
	puts "\n    Load Pins           Type\n    ------------        ----------------"
	foreach_in_collection load $load_list {
		puts [format "    %s\t\tInput Pin (%s)" [get_attr $load full_name] [get_attribute [get_lib_cells -of_objects [get_cells -of_objects $load] ] full_name] ]
	}
        puts "\n"
}
proc rc {cell} {
#        set output_list [get_pins -of_objects $cell -leaf -filter "direction =~ *out"]
#        set input_list [get_pins -of_objects $cell -leaf -filter "direction =~ in*"]
#        puts [format "\n\nConnections for cell \'%s\'\n    Input Pins         Nets\n    ------------        ----------------" [get_attr $cell full_name ] ]
#        foreach_in_collection input $input_list {
#                puts [format "    %s\t\t (%s)" [get_attr $input full_name] [get_attribute  [get_nets -of_objects $input  ] full_name] ]
#        }
#        puts "\n    Output Pins         Nets\n    ------------        ----------------"
#        foreach_in_collection output $output_list {
#                puts [format  "    %s\t\t (%s)" [get_attr $output full_name] [get_attribute [get_nets -of_objects $output] full_name] ]
#        }
#	puts "\n"
report_cell -conn $cell -nosplit
}


##

proc fpbsn {s n from to} {
report_timing -slack_lesser_than $s -nworst $n -from $from -to $to -nosplit
}
proc fpbn {n from to} {
report_timing -nworst $n -from $from -to $to -nosplit
}
proc fpbgln {g l n from to} {
report_timing -slack_greater_than $g -slack_lesser_than $l -nworst $n -from $from -to $to -nosplit
}
proc fptsn {s n to} {
report_timing -slack_lesser_than $s -nworst $n -to $to -nosplit
}
proc fpbsnn {s n from to} {
report_timing -slack_lesser_than $s -nworst $n -from $from -to $to -nosplit -input_pins -nets
}

proc fc {cell} {
  set all_cells [find -hierarchy cell *$cell*]
  foreach_in_collection list $all_cells {
      set cell_name [get_attr $list full_name]
      puts $cell_name
  }
}

proc fcf {cell} {
  set RPT [ open cell.list w ]
  set all_cells [find -hierarchy cell *$cell*]
  foreach_in_collection list $all_cells {
      set cell_name [get_attr $list full_name]
      puts $cell_name
      puts $RPT $cell_name
  }
}


proc fn {net} {
  #find -hierarchy net *$net* 
  set all_nets [find -hierarchy net *$net*]
  foreach_in_collection list $all_nets {
      set net_name [get_attr $list full_name]
      puts $net_name
  }
}

proc tn {net} {
  puts [get_attribute [get_nets [get_nets $net] -top_net_of_hierarchical_group -segments] full_name]
} 

proc pt {pin} {
  puts [get_attribute [get_nets [all_connected $pin] -top_net_of_hierarchical_group -segments] full_name]
}

proc rp {pin} {
  report_net -conn [get_attribute [get_nets [all_connected $pin] -top_net_of_hierarchical_group -segments] full_name]
}

proc filter_ref {ins_key ref_key} {
        foreach_in_collection dummy [get_cells $ins_key -hierarchical] {
                        set name [get_attribute $dummy ref_name]
                        set insname [get_attribute $dummy full_name]
                        if { [ string match $ref_key $name ] != 1 } {
                                echo "$insname\t\t($name)"
                        }
        }
}

proc rl {pin} {

	rp [get_attr [get_pins -of [get_cells -of $pin] -filter "pin_direction == out"] full_name]

}

proc rd {pin} {

	 rp [get_attr [get_pins -of [get_cells -of $pin] -filter "pin_direction == in"] full_name]

}


proc report_ins_by_ref {ref_key} {
        foreach_in_collection ins [get_cells * -hierarchical] {
                        set name [get_attribute $ins ref_name]
                        set insname [get_attribute $ins full_name]
                        if { [ string match $ref_key $name ] == 1 } {
                                echo $insname
                        }
        }
}

proc match_ref {ins ref_key} {
	echo [sizeof_collection [get_cells $ins -hierarchical]]
	foreach_in_collection ins [get_cells $ins -hierarchical] {
                        set name [get_attribute $ins ref_name]
                        set insname [get_attribute $ins full_name]
                        if { [ string match $ref_key $name ] == 0 } {
                                echo $insname
                        }
        }
}

proc get_num_ref {ref_key} {
	set num 0
        foreach_in_collection ins [get_cells * -hierarchical] {
                        set name [get_attribute $ins ref_name]
                        set insname [get_attribute $ins full_name]
                        if { [ string match $ref_key $name ] == 1 } {
                               incr num 
                        }
        }
	echo $num
}

proc report_ins_by_ins {ins_key} {
        foreach_in_collection ins [get_cells $ins_key -filter "is_hierarchical == false"] {
                        set insname [get_attribute $ins full_name]
                        echo $insname
        }
}


proc cda { from to delay } {
  set_annotated_delay -cell -from $from -to $to $delay
}

proc cdi { from to increment } {
  set_annotated_delay -cell -from $from -to $to -increment $increment
}

proc latency { } {
  report_clock_timing -type latency -clock [get_clocks *] -nworst 50000 -nosplit > latency.detail.rpt
}

proc skew { } {
  report_clock_timing -type skew -clock [get_clocks *] -nworst 50000 -nosplit > skew.detail.rpt
}

proc rewire_reset {arg} {

echo "" > $arg.v2v
set inst [all_fanout -from $arg]
foreach_in_collection list $inst {
   set cell_name [get_attr $list full_name]
   if {[regexp {(\S+)\/RN} $cell_name]} {
       set net_name [all_conn [get_pin $cell_name] ]
       set NetName [get_attr $net_name full_name]
       set tmp_cell_name "$cell_name"
       regsub  {\/[A-Za-z0-9]+$}  $tmp_cell_name "" cell_name
       echo "REWIRE " $cell_name $NetName $arg >> $arg.v2v

   } elseif {[regexp {(\S+)\/SN} $cell_name]} {
      set net_name [all_conn [get_pin $cell_name] ]
      set NetName [get_attr $net_name full_name]
      set tmp_cell_name "$cell_name"
      regsub  {\/[A-Za-z0-9]+$}  $tmp_cell_name "" cell_name
      echo "REWIRE " $cell_name $NetName $arg >> $arg.v2v
   }
  }
}

proc get_clock_ports {} {
	set clk_port_list {}
	foreach_in_collection this_clock [all_clocks] {
		set source_of_clock [get_attribute [get_clocks $this_clock] sources]
    foreach_in_collection one_source $source_of_clock {   
    	set object_type [get_attribute $one_source object_class] 
    	if {$object_type == "port"} { 
    		lappend clk_port_list [get_object_name $one_source] 
    	}
    } 
	}
	return $clk_port_list
}
proc get_clock_net {} {
	set pins {}
	foreach_in_collection clock [ all_clocks ] {
		foreach_in_collection source [ get_attribute $clock sources ] {
			set pins [ add_to_collection $pins [ filter_collection [ all_fanout -flat -from $source ] "is_clock_pin == true" ] ]
		}
	}
	foreach_in_collection pin $pins {
		set pin_name [ get_attr $pin full_name ]
		puts [get_attribute [get_nets [all_connected $pin_name] -top_net_of_hierarchical_group -segments] full_name]
	}
}
proc get_ideal_nets { threshold } {
   set high_fanout_nets [all_high_fanout -nets -threshold $threshold]
   foreach_in_collection net $high_fanout_nets {
     set net_name [get_attr $net full_name]
     set fanout_number [sizeof_collection [get_pins -leaf -of $net_name]]
     echo "##$fanout_number  $net_name"
     echo "set_load -net $net_name 0.200p"
     echo "set_slew -net $net_name 0.500n"
   }
}

proc get_sigs_ideal_clk {mode} {
	global synopsys_program_name
  set RPT [ open ${mode}.clk.ideal.tmp w ]
  set RPT_PIN [ open ${mode}.clk.ideal.pin.tmp w ]
	set pins {}
	foreach_in_collection clock [ all_clocks ] {
		foreach_in_collection source [ get_attribute $clock sources ] {
			if {  $synopsys_program_name == "icc_shell" } {
				set pins [ add_to_collection $pins [ filter_collection [ all_fanout -flat -from $source ] "is_on_clock_network == true" ] ]
			} else {
				set pins [ add_to_collection $pins [ filter_collection [ all_fanout -flat -from $source ] "is_clock_pin == true" ] ]
			}
		}
	}
	foreach_in_collection pin $pins {
		set pin_name [ get_attr $pin full_name ]
		if { $pin_name == "" } {
			continue
		}
		set net_name [get_attribute [get_nets -of_objects $pin_name -top_net_of_hierarchical_group -segments] full_name]
		if { $net_name == "" } {
			continue
		}
		puts $RPT_PIN "set_ideal_transition_pt 0.4 $pin_name"
		puts $RPT "set_load -net $net_name 0.1p"
		puts $RPT "set_slew -net $net_name 0.4n"
	}
	close $RPT
	close $RPT_PIN
	exec sort -ud ${mode}.clk.ideal.tmp > ${mode}.clk.ideal	
	exec sort -ud ${mode}.clk.ideal.pin.tmp > ${mode}.clk.ideal.pin
	exec rm -f ${mode}.clk.ideal.tmp
	exec rm -f ${mode}.clk.ideal.pin.tmp
}

########## setup view utilities ##############
############# SETUP VIEW UTILITY ###############

proc view {args} {
    redirect tmpfile1212 {uplevel $args}
    # Without redirect, exec echos the PID of the new process to the screen
    redirect /dev/null {exec ../ref/tcl_procs/view.tk tmpfile1212 "$args" &}
}

alias vrt {view report_timing -nosplit}
alias vrtm {view report_timing -nosplit -delay min}
alias vman {view man}

############# SETUP FULL LOGGING ###############
set timestamp [clock format [clock scan now] -format "%Y-%m-%d_%H:%M"]
#set sh_output_log_file "${synopsys_program_name}.log.$timestamp"

#################### solveNet ###################
#   1. Getting clock network pins/ports for a specific clock
#
#      To determine all of the objects in the propagation path of clock CLK, we simply query the clock_network_pins attribute of the desired clock:
#
#      pt_shell> get_attribute [get_clocks CLK] clock_network_pins
#      {"UFF1/CP", "Umux/I0", "Umux/Z", "UFF2/CP", "UFF3/CP", "U1/I", "U1/Z", 
#      "CLK", "CLKOUT"}
#      pt_shell> get_attribute [get_clocks CLK_div2] clock_network_pins
#      {"UFF1/Q", "Umux/I1", "Umux/Z", "UFF2/CP", "UFF3/CP", "DIVOUT"}
#      pt_shell>
#
#      We can see that mixed collections of both leaf pins and ports are returned.
#
#   2. Getting clock network nets for a specific clock
#
#      This is similar to the previous example, except that we want the nets connected to the clock network objects. To determine this, we can use the get_nets -of command, which returns the collection of nets connected to the specified objects:
#
#      pt_shell> get_nets -top_net_of_hierarchical_group -segments \
#                 -of [get_attribute [get_clocks CLK] clock_network_pins]
#      {"CLK", "nCLKsel", "CLKOUT"}
#      pt_shell> get_nets -top_net_of_hierarchical_group -segments \
#                 -of [get_attribute [get_clocks CLK_div2] clock_network_pins]
#      {"DIVOUT", "nCLKsel"}
#      pt_shell>
#
#   3. Finding all ports that are part of a specific clock's network
#
#      This is also similar to Example 1, except that we use the get_ports -quiet command to filter out all the pins, and keep only the ports:
#
#      pt_shell> get_ports -quiet \
#                 [get_attribute [get_clocks CLK] clock_network_pins]
#      {"CLK", "CLKOUT"}
#      pt_shell> get_ports -quiet \
#                 [get_attribute [get_clocks CLK_div2] clock_network_pins]
#      {"DIVOUT"}
#      pt_shell>
#
#      We can accomplish the same thing by filtering the collection based on the object class:
#
#      pt_shell> filter_collection \
#                 [get_attribute [get_clocks CLK] clock_network_pins] \
#                 {object_class == port}
#      {"CLK", "CLKOUT"}
#      pt_shell> filter_collection \
#                 [get_attribute [get_clocks CLK_div2] clock_network_pins] \
#                 {object_class == port}
#      {"DIVOUT"}
#      pt_shell>
#
#   4. Finding all ports that are part of any clock's network
#
#      To do this, we only need to find the list of ports that have the clocks attribute defined on them:
#
#      pt_shell> get_ports {*} -filter {defined(clocks)}
#      {"CLK", "DIVOUT", "CLKOUT"}
#      pt_shell>
#
#   5. Finding non-clock control logic
#
#      Let's say we would like to find out what potential control logic might exist for clock domain CLK. First, we must get the entire fanin cone to all clock pins/ports in the CLK clock domain. Then, we filter to limit the collection to objects that have no clocks propagating through them:
#
#      pt_shell> filter_collection \
#                 [all_fanin -flat -to [all_registers -clock_pins -clock CLK]] \
#                 {undefined(clocks)}
#      {"Umux/S", "U4/Z", "U4/I", "SEL"}
#
#   6. Finding where two clock networks intersect
#
#      We would like to find out where the clock networks for CLK and CLK_div2 intersect. First, we get the two networks:
#
#      pt_shell> set CLK [get_attribute [get_clocks CLK] clock_network_pins]
#      {"UFF1/CP", "Umux/I0", "Umux/Z", "UFF2/CP", "UFF3/CP", "U1/I", "U1/Z", "CLK",
#      "CLKOUT"}
#      pt_shell> set CLK_div2 [get_attribute [get_clocks CLK_div2] \
#          clock_network_pins]
#      {"UFF1/Q", "Umux/I1", "Umux/Z", "UFF2/CP", "UFF3/CP", "DIVOUT"}
#      pt_shell>
#
#      Next, we must compute the intersection of these two collections. We use the technique shown in SolvNet article 011900 (Computing the Intersection of Two Collections) to do this:
#
#      pt_shell> set int [remove_from_collection $CLK \
#                         [remove_from_collection $CLK $CLK_div2]]
#      {"Umux/Z", "UFF2/CP", "UFF3/CP"}
#      pt_shell>
#
#   7. Finding all clock nets in the design
#
#      To find all clock nets in the design, we must first find all leaf pins and ports in the design that have a clock propagating through them. We do this by getting the ports and pins separately, and combining them with add_to_collection:
#
#      pt_shell> set clk_objects [add_to_collection \
#                 [get_ports {*} -filter {defined(clocks)}] \
#                 [get_pins -hier {*} -filter {defined(clocks)}]]
#      {"CLK", "DIVOUT", "CLKOUT", "UFF1/CP", "UFF1/Q", "Umux/I0", "Umux/I1", 
#      "Umux/Z", "UFF2/CP", "UFF3/CP", "U1/I", "U1/Z"}
#      pt_shell>
#
#      We now have all the clock pins and ports in the design. Next, we simply find all the nets that are connected to these clock network objects:
#
#      pt_shell> set clk_nets \
#                 [get_nets -top_net_of_hierarchical_group -segments \
#                  -of $clk_objects]
#      {"CLK", "DIVOUT", "CLKOUT", "nCLKsel"}
#      pt_shell>
#
#For an example of a Tcl procedure that uses these attributes, see the following SolvNet article:
#
#017582: How Can I Find And Report the Clock Steering Logic in My Design?


################################################################################
################################################################################
################################################################################
################################################################################
# set_ideal_net.pt
#
# Description: Mimic Design Compiler's ideal_net commands:
#	 set_ideal_net_pt        # set_ideal_net
#	 set_ideal_latency_pt    # set_ideal_latency
#	 set_ideal_transition_pt # set_ideal_transition
#

#source set_ideal_nets.pt


###############################################################################
#set_ideal_net_pt
proc set_ideal_net_pt { {objects ""} } {

if {$objects==""} {
  echo "Error: Required argument 'objects' was not found"
  return
}

foreach NN $objects {

  echo "Setting Ideal Net on [get_attribute [get_net $NN] full_name]"

  #Find all pins/ports driving net
  set driver_pin ""
  set other_pin  [get_pins -leaf -of_objects $NN]
  set driver_pin [filter [get_pins -leaf -of_objects $NN] "pin_direction==out"]
  if {$driver_pin == ""} {
    set d_pin [filter [get_ports -of_objects $NN] "port_direction==in"]
    set driver_pin [filter [get_ports $d_pin] "object_class==port"]
    echo "Setting Ideal Transition on [get_attribute $driver_pin full_name]"
    set_input_transition 0 $driver_pin
  }
  foreach_in_collection  OO $other_pin {
    echo "Setting Ideal Transition on [get_attribute $OO full_name]"
    set_annotated_transition 0 $OO
  }
}

# set capacitance of net to 0
set_load 0 [get_nets $objects] -subtract_pin

}

define_proc_attributes set_ideal_net_pt \
    -info "Sets the ideal_net attribute on specified individual nets" \
    -define_args \
    { {object_list "list of nets" "object_list" list required}
}


###############################################################################
#set_ideal_latency_pt
proc set_ideal_latency_pt { {delay 0} {pin_or_port_names_list ""} } {

if {$pin_or_port_names_list==""} {
  echo "No Net Name Found"
  return
}


foreach PP $pin_or_port_names_list {
  set pinn ""
  redirect /dev/null {set pinn [get_attribute [get_pins $PP] object_class]}
  if {$pinn == "pin"} {
  redirect /dev/null {remove_annotated_delay -to [get_pins $PP]}

  set arcs [get_timing_arcs -to [get_pins $PP]]

  set from_pin_list ""

  foreach_in_collection arc $arcs {

    set is_cellarc [get_attribute $arc is_cellarc]
    set fpin [get_attribute $arc from_pin]
    set from_pin_name [get_attribute $fpin full_name]

    if {[lsearch $from_pin_list $from_pin_name]==-1} {

      lappend from_pin_list $from_pin_name
      set tpin [get_attribute $arc to_pin]
      set to_pin_name [get_attribute $tpin full_name]
      set max_rise [get_attribute $arc delay_max_rise]
      set max_rise_new [expr $max_rise + $delay]
      set max_fall [get_attribute $arc delay_max_fall]
      set max_fall_new [expr $max_fall + $delay]
      set min_rise [get_attribute $arc delay_min_rise]
      set min_rise_new [expr $min_rise + $delay]
      set min_fall [get_attribute $arc delay_min_fall]
      set min_fall_new [expr $min_fall + $delay]

  echo "Setting ideal latency of $delay on [get_attribute [get_pin $PP] full_name]"
  set_annotated_delay -max -rise -cell $max_rise_new \
     -from [get_pins $from_pin_name] -to [get_pins $to_pin_name]
  set_annotated_delay -max -fall -cell $max_fall_new \
      -from [get_pins $from_pin_name] -to [get_pins $to_pin_name]
  set_annotated_delay -min -rise -cell $min_rise_new \
      -from [get_pins $from_pin_name] -to [get_pins $to_pin_name]
  set_annotated_delay -min -fall -cell $min_fall_new \
      -from [get_pins $from_pin_name] -to [get_pins $to_pin_name]

    }
  }

  } else {
  echo "Setting ideal latency of $delay on [get_attribute [get_port $PP] full_name]"
  set_annotated_delay -net $delay -from [get_port $PP]
  }

}

}

define_proc_attributes set_ideal_latency_pt \
    -info "Specifies ideal net latency on pins or ports." \
    -define_args \
    { {delay   "ideal latency" "delay" float required}
      {object_list "list of pins or ports" "object_list" list required}
}
#    { {[-rise] "specify ideal network rise latency" "-rise" float optional}
#      {[-fall] "specify ideal network fall latency" "-fall" float optional}
#      {[-min]  "specify ideal network rise and fall min condition latency" \
#                "delay" float required}
#      {[-max]  "specify ideal network rise and fall max condition latency"
#                "delay" float required}
#      {delay   "ideal latency" "delay" float required}
#      {object_list "list of pins or ports" "object_list" list required}
#}


###############################################################################
#set_ideal_transition_pt
proc set_ideal_transition_pt { {transition_time 0} {pin_or_port_names_list ""} } {

if {$pin_or_port_names_list==""} {
  echo "No Net Name Found"
  return
}


foreach PP $pin_or_port_names_list {

  set pinn ""
  redirect /dev/null {set pinn [get_attribute [get_pins $PP] object_class]}
  if {$pinn == "pin"} {

  echo "Setting ideal transition of $transition_time on [get_attribute [get_pin $PP] full_name]"
  set_annotated_transition -max -rise $transition_time [get_pins $PP]
  set_annotated_transition -max -fall $transition_time [get_pins $PP]
  set_annotated_transition -min -rise $transition_time [get_pins $PP]
  set_annotated_transition -min -fall $transition_time [get_pins $PP]

  } else {
  echo "Setting ideal transition of $transition_time on [get_attribute [get_ports $PP] full_name]"
  set_annotated_transition -max -rise $transition_time [get_ports $PP]
  set_annotated_transition -max -fall $transition_time [get_ports $PP]
  set_annotated_transition -min -rise $transition_time [get_ports $PP]
  set_annotated_transition -min -fall $transition_time [get_ports $PP]
  }
}

}

define_proc_attributes set_ideal_transition_pt \
    -info "Specifies ideal net transition on pins or ports." \
    -define_args \
    { {delay   "ideal transition" "delay" float required} 
      {object_list "list of pins or ports" "object_list" list required}
}
#    { {[-rise] "specify ideal network rise transition" "-rise" float optional}
#      {[-fall] "specify ideal network fall transition" "-fall" float optional}
#      {[-min]  "specify ideal network rise and fall min condition transition" \
#                "delay" float required}
#      {[-max]  "specify ideal network rise and fall max condition transition"
#                "delay" float required}
#      {delay   "ideal transition" "delay" float required}
#      {object_list "list of pins or ports" "object_list" list required}
#}

#########################
#set physopt_enable_tlu_plus false
######################### 
# eco command

#proc InstanceAddPostfix {instance_name patten} {
#  if { [ llength [ get_cells $instance_name -q ] ] == 0 } {
#    puts [ format "Error: Cannot find cell '%s'." $cell_name]
#    return
#  }
#  if { [ llength [ get_cells ${instance_name}_${patten} -q ] ] > 0 } {
#    puts [ format "Error: instance has exist '%s'." $instance_name}_${patten}]
#    return
#  }
#	set cell [get_cell $instance_name -all]
#	set cell_name [get_attribute $cell full_name]
#	set cell_type [get_attribute $cell ref_name]
#	set cell_orit [get_attribute $cell orientation]
#	set cell_orgi [get_attribute $cell origin]
#	set cell_place [get_attribute $cell is_placed]
#	set cell_fix [get_attribute $cell is_fixed]
#	set cell_soft [get_attribute $cell is_soft_fixed]
#	set cell_eco [get_attribute $cell eco_status]
#	create_cell ${cell_name}_${patten} [get_model $cell_type]
#	foreach_in_collection pin [get_pins -of $cell] {
#		set cell_pin [get_attribute $pin name]
#		set pin_net [get_nets -of $pin]
#		connect_net $pin_net ${cell_name}_${patten}/${cell_pin}
#	}
#	remove_cell $cell_name
#}
##
#####################################
#
# Workaround Solution for add rows in
# rectilinear area
#
#####################################

set cut_areas {}
set mw_add_row_overlap 1

proc get_bbox {poly_list} {
   set llx [lindex [lindex $poly_list 0] 0]
   set lly [lindex [lindex $poly_list 0] 1]
   set urx $llx
   set ury $lly
   set bbox {}
   foreach point $poly_list {
     set x [lindex $point 0]
     set y [lindex $point 1]
     if {$x < $llx} {
       set llx $x
     } else {
       if {$x > $urx} {
         set urx $x
       }
     }
     if {$y < $lly} {
       set lly $y
     } else {
       if {$y > $ury} {
         set ury $y
       }
     }
   }
   set core_llx [lindex [lindex [get_attribute [get_core_area] bbox] 0] 0]
   set dx [expr {int([expr $llx - $core_llx])}]
   set tile_width [get_attribute [get_core_area] tile_width]
   set mdt [expr {fmod($dx,$tile_width)}]
    if {$mdt > 0.0} {
	set nx [expr {int([expr $dx / $tile_width])}]
	set new_llx [expr [expr $core_llx + [expr $nx * $tile_width] + $tile_width]]
	set llx $new_llx
    }
   lappend bbox "$llx $lly" "$urx $ury"
   return $bbox
}

proc change_to_poly {bbox} {
  set poly {}
  set x1 [lindex [lindex $bbox 0] 0]
  set y1 [lindex [lindex $bbox 0] 1]
  set x2 [lindex [lindex $bbox 1] 0]
  set y2 [lindex [lindex $bbox 1] 1]
  lappend poly "$x1 $y1" "$x2 $y1" "$x2 $y2" "$x1 $y2" "$x1 $y1"
  return $poly
}


proc get_trim_row_area {poly_list overlap_rows} {
    global cut_areas
    set bbox_area [get_bbox $poly_list]
    if {[sizeof_collection $overlap_rows]} {
	undo_config -enable
	remove_site_row $overlap_rows
	undo_config -disable
    }

    set poly_area [change_to_poly $bbox_area]
    set cut_areas_poly [compute_polygon -boolean not $poly_area $poly_list]
    echo $cut_areas_poly
    foreach poly $cut_areas_poly {
	foreach rect [convert_from_polygon $poly] {
	    lappend cut_areas $rect
	}
    }   
  return $cut_areas
}

proc compute_poly_with_keepout {poly_list keepout_left keepout_right keepout_bottom keepout_top} {
    if {[string match {*10.12*} [get_app_var compatibility_version]]} {
	echo "version 2010.12"
	set new_poly [resize_polygon $poly_list -size_left $keepout_left -size_right $keepout_right -size_bottom $keepout_bottom -size_top $keepout_top] 
    } else {
	echo "version 2010.03"
	set new_poly [resize_polygon $poly_list -size $keepout_left]
    }
    return $new_poly
}

proc trim_row {} {
    global cut_areas
    foreach area $cut_areas {
      cut_row -area $area
    }
}

proc cut_row_by_rectilinear {poly_list} {
    undo_config -disable
    foreach rec [convert_from_polygon $poly_list] {
	cut_row -area $rec
    }
}

proc add_row_by_rectilinear {poly_list unit_tile keepout_left keepout_right keepout_bottom keepout_top} {
    global cut_areas
    set cut_areas {}
    if {$keepout_left > 0 || $keepout_right > 0 || $keepout_top > 0 || $keepout_bottom > 0 } {
	set keepout_left [expr $keepout_left * -1]
	set keepout_right [expr $keepout_right * -1]
	set keepout_bottom [expr $keepout_bottom * -1]
	set keepout_top [expr $keepout_top * -1]
	set new_poly [lindex [compute_poly_with_keepout $poly_list $keepout_left $keepout_right $keepout_bottom $keepout_top] 0]
    } else {
	set new_poly $poly_list
    }
    set bbox_area [get_bbox $new_poly]
    set overlap_rows [get_site_rows -intersect $bbox_area]
    echo "sizeof overlap inter is [sizeof_collection $overlap_rows] "
    set overlap_rows [add_to_collection $overlap_rows [get_site_rows -within $bbox_area]]
   set overlap_rows [add_to_collection $overlap_rows [get_site_rows -touching $bbox_area]]
echo "overlap rows are"
    echo [sizeof_collection $overlap_rows]
    set cut_areas [get_trim_row_area $new_poly $overlap_rows]
    add_row -dont_snap_to_existing_row -no_snap_to_wire_track -area [get_bbox $new_poly] -tile_name $unit_tile
    trim_row
    if {[sizeof_collection $overlap_rows]} {
	undo_config -enable
	undo
   }
 }
#
############RDL layer
# IC Compiler - Solvnet Article - 031405
# Copyright (C) 2007-2010 Synopsys, Inc. All rights reserved.
##########################################################################################
# create_net_shape_on_RDL_layer.tcl
# Create rectangular net shapes inside the 45-degree segments to mimic the 45-degree shape
##########################################################################################
# usage:
#source . /create_net_shape_on_RDL_layer.tcl

# Execute the create_net_shape_on_RDL_layer procedure from
# create_net_shape_on_RDL_layer.tcl. Create rectangular net shapes with
# 2um width inside 45-degree M9 route segments
#
#create_net_shape_on_RDL_layer -nets [get_flat_nets -all -of_objects \
#  [get_net_shapes -filter {layer==M9}]] 2 0 M9
#
#set_parameter -name ContactSizeSelection -value 2
#
# Set the min and max layers to the layer of PG straps and RDL layer
# respectively
#set_preroute_drc_strategy -min_layer M8 -max_layer M9
#
# Use create_preroute_vias to drop vias between PG straps and PG RDL routes
#create_preroute_vias -from_layer M9 -from_object_strap -from_object_user -to_layer M8 \
#  -to_object_strap -to_object_user -optimize_via_locations -mark_as strap
#
# Execute the remove_net_shape_on_RDL procedure from create_net_shape_on_RDL_layer.tcl
# Remove the net shapes inside 45-degree M9 route segments
#remove_net_shape_on_RDL -nets [get_flat_nets -all -of_objects [get_net_shapes -filter {layer==M9}]]
#Click the following link to download the create_net_shape_on_RDL_layer.tcl script:
#
proc round_down {val rounder} {
    set nval [expr floor($val*$rounder) /$rounder]
    return $nval
}

proc round_up {val rounder} {
    set nval [expr ceil($val*$rounder) /$rounder]
    return $nval
}

proc remove_net_shape_on_RDL {args} {
    if {([llength $args] == 2) && ([lindex $args 0] == "-nets" || [lindex $args 0] == "-nets_in_file")} {
        set net_input [lindex $args 0]
        set net_list [lindex $args 1]
        set is_coll [sizeof_collection $net_list]
        if {$net_input == "-nets"} {
            if { $is_coll >= 1 } {
                set net_coll $net_list
            } else {
                set net_coll [get_flat_nets -all $net_list]
            }
        } elseif { $net_input == "-nets_in_file"} {
            set net_coll {}
            set f [open $net_list r]
            while {[gets $f line] >= 0} {
                set net_coll [add_to_collection $net_coll [get_flat_nets -all $line]]
            }
            close $f
        }
        foreach_in_collection net $net_coll {
            set net_name [get_object_name $net]
            puts stdout "### Removing net shapes for net: $net_name"
            remove_net_shape [get_net_shapes -of_objects $net -filter {endcap==square_ends && route_type=="User Enter"}]
        }
    } else {
        puts stdout "Usage: remove_net_shape_on_RDL_layer"
        puts stdout " \[-nets nets\]           (nets collection)"
        puts stdout " \[-nets_in_file nets file\] (net names in a file)"
    }
}

proc create_net_shape_on_RDL_layer {args} {
    if {([llength $args] == 4 || [llength $args] == 5) && ([lindex $args 0] == "-nets" || [lindex $args 0] == "-nets_in_file")} {
        set net_input [lindex $args 0]
        set net_list [lindex $args 1]
        set is_coll [sizeof_collection $net_list]
        set step [lindex $args 2]
        set offset [lindex $args 3]
        if {[llength $args] == 5} {set layer [lindex $args 4]}
        if {$net_input == "-nets"} {
            if { $is_coll >= 1 } {
                set net_coll $net_list
            } else {
                set net_coll [get_flat_nets -all $net_list]
            }
        } elseif { $net_input == "-nets_in_file"} {
            set net_coll {}
            set f [open $net_list r]
            while {[gets $f line] >= 0} {
                set net_coll [add_to_collection $net_coll [get_flat_nets -all $line]]
            }
            close $f
        }
        set_object_snap_type -disable
        set pi 3.1416
        foreach_in_collection net $net_coll {
            set net_name [get_object_name $net]
            puts stdout "### Creating net shapes for net: $net_name"
            foreach_in_collection shape [get_net_shapes -of_objects $net -filter {endcap==octagon_ends_by_half_width}] {
                set llx [get_attribute $shape bbox_llx]
                set lly [get_attribute $shape bbox_lly]
                set urx [get_attribute $shape bbox_urx]
                set ury [get_attribute $shape bbox_ury]
                set width [get_attribute $shape width]
                set points [get_attribute $shape points]
                set layer [get_attribute $shape layer]
                set owner_net [get_attribute $shape owner_net]
                set name [get_attribute $shape name]
                set pt1 [lindex $points 0]
                set pt2 [lindex $points end]
                set pt1x [lindex $pt1 0]
                set pt1y [lindex $pt1 1]
                set pt2x [lindex $pt2 0]
                set pt2y [lindex $pt2 1]
                set proj_width [expr $width/2*tan($pi/8) + $width/2]
                if {(($pt1x < $pt2x) && ($pt1y < $pt2y)) || (($pt1x > $pt2x) && ($pt1y > $pt2y))} {
                    set x $llx
                    set y1 [expr $lly + $step./2]
                    set y2 $y1
                    while {$y1 < [expr $ury - $step./2]} {
                        set x1 [round_down [expr $x - $proj_width + $step + $offset] 1000]
                        set x2 [round_up [expr $x + $proj_width - $offset] 1000]
                        if {$x1 < $llx} { set x1 $llx }
                        if {$x2 > $urx} { set x2 $urx }
                        if {$y2 > $ury} { set y2 $ury }
                        create_net_shape -width $step -datatype 10 -type path -route_type user_enter -net $net -layer $layer -points "$x1 $y1 $x2 $y2"
                        set x [expr $x + $step]
                        set y1 [expr $y1 + $step]
                        set y2 $y1
                    }
                } elseif {(($pt1x < $pt2x) && ($pt1y > $pt2y)) || (($pt1x > $pt2x) && ($pt1y < $pt2y))} {
                    set x $urx
                    set y1 [expr $lly + $step./2]
                    set y2 $y1
                    while {$y1 <= [expr $ury - $step./2]} {
                        set x1 [round_down [expr $x - $proj_width + $offset] 1000]
                        set x2 [round_up [expr $x + $proj_width - $step - $offset] 1000]
                        if {$x1 < $llx} { set x1 $llx }
                        if {$x2 > $urx} { set x2 $urx }
                        if {$y2 > $ury} { set y2 $ury }
                        create_net_shape -width $step -datatype 10 -type path -route_type user_enter -net $net -layer $layer -points "$x1 $y1 $x2 $y2"
                        set x [expr $x - $step]
                        set y1 [expr $y1 + $step]
                        set y2 $y1
                    }
                }
            }
        }
    } else {
        puts stdout "Usage: create_net_shape_on_RDL_layer"
        puts stdout " \[-nets nets\]           (nets collection)"
        puts stdout " \[-nets_in_file nets file\] (net names in a file)"
        puts stdout " width                (width of the net shape)"
        puts stdout " offset  (offset from the edge of the wire)"
        puts stdout " layer   (net shape layer)"
    }
}
####
proc get_route_length {source_pin dest_pin} {
 set route_length 0
 foreach_in_collection i [gui_get_routes_between_objects [list $source_pin $dest_pin]] {
      if { [get_attr -quiet $i length] != {} } {
           set route_length [expr $route_length+[get_attr -quiet $i length]]        
	   }
 }
 echo "Total route length excluding vias : $route_length"
}
#
proc create_terminal_text { terminal_name } {
	foreach_in_collection terminal [get_terminals $terminal_name ] {
		set terminal_fullname [get_attribute $terminal name]
		puts $terminal_fullname
		if { [get_attribute [get_terminal $terminal] bbox] eq "" } {
			puts " port has no placement : $terminal_fullname"
			continue
		}
		set terminal_x1 [lindex [lindex [get_attribute $terminal bbox] 0 ] 0]
		set terminal_y1 [lindex [lindex [get_attribute $terminal bbox] 0 ] 1]
		set terminal_x2 [lindex [lindex [get_attribute $terminal bbox] 1 ] 0]
		set terminal_y2 [lindex [lindex [get_attribute $terminal bbox] 1 ] 1]
		set terminal_c_x [expr $terminal_x1 + ($terminal_x2-$terminal_x1)/2]
		set terminal_c_y [expr $terminal_y1 + ($terminal_y2-$terminal_y1)/2]
		set terminal_layer [get_attribute $terminal layer]
		if {[sizeof_collection [get_text * -quiet -filter "text == $terminal_fullname"]] > 0 } {
			puts $terminal_fullname
			remove_text [get_text * -filter "text == $terminal_fullname"]
		}
		puts "text : $terminal_fullname is created successfully"
		create_text -origin [list $terminal_c_x $terminal_c_y] -layer $terminal_layer -height 0.2 $terminal_fullname
		
	}

}
#
proc st { text } {
	change_selection [get_text * -filter "text == $text"]
}
proc qt { text } {
	gui_change_highlight -remove -color light_red 
	gui_change_highlight -color light_red -collection [get_text * -filter "text == $text"]
}
#
source /user/home/nealj/Template/tcl/ICC_tcl/hilight.tcl
source /user/home/nealj/Template/tcl/ICC_tcl/hilight_path.tcl
source /user/home/nealj/Template/tcl/ICC_tcl/hilight_object.tcl
#
          proc ng {x y} {
                 set x [expr $x * 1.111]
                 set y [expr $y * 1.111]
                 set x_l [expr $x - 5]
                 set y_l [expr $y - 5]
                 set x_r [expr $x + 5]
                 set y_r [expr $y + 5]
                 gui_zoom -rect [list [list $x_l $y_l] [list $x_r $y_r]]  -exact -window [gui_get_current_window -types "Layout" -mru]
         }
