
  set ECO_STRING CLK_RPT
  set rpt_model_name "CKND20"
######## MaxDis 300 is too small
  set MaxDis     800
  set is_inv     1
  
  set root_pin_names "
u_clk_gen_amba/U103_ZN_SCAN_ECO_U0/Z
u_clk_gen_amba/U110_ZN_SCAN_ECO_U0/Z
u_clk_gen_amba/U33_Z_SCAN_ECO_U0/Z
u_clk_gen_amba/U81_ZN_SCAN_ECO_U0/Z
u_clk_gen_amba/U89_ZN_SCAN_ECO_U0/Z
u_clk_gen_top/Clk_Gen_inst/U8_ZN_SCAN_ECO_U0/Z
u_clk_gen_top/Clk_Gen_inst/U9_ZN_SCAN_ECO_U0/Z
u_clk_gen_top/Clk_Gen_inst/clk_4p5fs_reg_Q_SCAN_ECO_U0/Z
u_clk_gen_top/Clk_Mux_inst/U9_ZN_SCAN_ECO_U0/Z
u_clk_gen_top/FREQ_div_inst/clk_40M_div10_reg_Q_SCAN_ECO_U0/Z
u_core/u_FTMAC110/pwr_manage_CLKGEN/g137/ZN
u_pin_module/g5997/Z
"

#visicblk/dmuxiblk/UCK/ckbuf_dv0/C
#visicblk/dmuxiblk/UCK/ckbuf_dv1/C
#visicblk/dmuxiblk/UCK/ckbuf_xdv0/C
#visicblk/dmuxiblk/UCK/ckbuf_xdv1/C

########################################
## v1.0 basic fuction
## v2.0 avoid placing on blockage for visic. the simple version.
  proc get_rpt_location { start_x start_y end_x end_y is_close_to_startpin is_close_to_endpin rpt_num } {
    
    set distance_x [ expr $end_x - $start_x ]
    set distance_y [ expr $end_y - $start_y ]
    set start_pin_location_x $start_x
    set start_pin_location_y $start_y
    set end_pin_location_x   $end_x
    set end_pin_location_y   $end_y
    
    if {($is_close_to_endpin == 0)} {
      set step_x [ expr $distance_x / ( $rpt_num + 1) ]
      set step_y [ expr $distance_y / ( $rpt_num + 1) ]
    } else {
      set step_x [ expr $distance_x / ( $rpt_num ) ]
      set step_y [ expr $distance_y / ( $rpt_num ) ]
    }
    #puts "Step: $step_x $step_y"
    
    set x_dir [ expr $distance_x / [ expr abs($distance_x) ] ]
    set y_dir [ expr $distance_y / [ expr abs($distance_y) ] ]
    #puts "$x_dir $y_dir"

    set re_comp 1
    set shft_y_num 0

    #### current only support shift +y for visic
    while { $re_comp == 1 } {
      set points ""
      if { $is_close_to_startpin == 1} {
        puts "puts close to root"
        set start_pin_location_sub_x [expr $start_pin_location_x + 5 * $x_dir ]
        set start_pin_location_sub_y [expr $start_pin_location_y + 5 * $y_dir ]
        set points [ concat $points $start_pin_location_sub_x $start_pin_location_sub_y ]
        set tmp_shft_y_num $shft_y_num
        while { $tmp_shft_y_num > 0 } {
          set start_pin_location_sub_y [expr $start_pin_location_sub_y + abs ($step_x) + abs ($step_y) ]
          set tmp_shft_y_num [ expr $tmp_shft_y_num - 1 ]
          set points [ concat $points $start_pin_location_sub_x $start_pin_location_sub_y ]
        }

        set distance_x [ expr $end_pin_location_x - $start_pin_location_sub_x ]
        set distance_y [ expr $end_pin_location_y - $start_pin_location_sub_y ]
        if {($is_close_to_endpin == 0)} {
            set step_x [ expr $distance_x / ( $rpt_num - $shft_y_num ) ]
            set step_y [ expr $distance_y / ( $rpt_num - $shft_y_num ) ]
        } else {
            set step_x [ expr $distance_x / ( $rpt_num -1 - $shft_y_num ) ]
            set step_y [ expr $distance_y / ( $rpt_num -1 - $shft_y_num ) ]
        }
      
        puts "*INFO* Step: $step_x $step_y"
        set remain_num [ expr $rpt_num - 1 - $shft_y_num ]

        set cell_index 1
        while { $remain_num > 0 } {
          set x [ expr $start_pin_location_sub_x + $step_x * ( $cell_index ) ]
          set y [ expr $start_pin_location_sub_y + $step_y * ( $cell_index ) ]
          set points [ concat $points $x $y]
          incr cell_index
          set remain_num [ expr $remain_num - 1 ]
        }
      } else {
        puts "*INFO* Step: $step_x $step_y"
	set start_pin_location_sub_x $start_pin_location_x
        set start_pin_location_sub_y $start_pin_location_y
        set tmp_shft_y_num $shft_y_num
        while { $tmp_shft_y_num > 0 } {
          set start_pin_location_sub_y [expr $start_pin_location_sub_y + abs ($step_x) + abs ($step_y) ]
          set tmp_shft_y_num [ expr $tmp_shft_y_num - 1 ]
          set points [ concat $points $start_pin_location_sub_x $start_pin_location_sub_y ]
        }
        set distance_x [ expr $end_pin_location_x - $start_pin_location_sub_x ]
        set distance_y [ expr $end_pin_location_y - $start_pin_location_sub_y ]
        if {($is_close_to_endpin == 0)} {
            set step_x [ expr $distance_x / ( $rpt_num - $shft_y_num ) ]
            set step_y [ expr $distance_y / ( $rpt_num - $shft_y_num ) ]
        } else {
            set step_x [ expr $distance_x / ( $rpt_num -1 - $shft_y_num ) ]
            set step_y [ expr $distance_y / ( $rpt_num -1 - $shft_y_num ) ]
        }

        set remain_num [expr $rpt_num - $shft_y_num]
        set cell_index 1
        while { $remain_num > 0 } {
          set x [ expr $start_pin_location_sub_x + $step_x * ( $cell_index ) ]
          set y [ expr $start_pin_location_sub_y + $step_y * ( $cell_index ) ]
          set points [ concat $points $x $y]
          incr cell_index
          set remain_num [ expr $remain_num - 1 ]
        }
      }
      set re_comp [test_blockage_overlap $points]
      incr shft_y_num 
      if { $re_comp == 1 } { puts "*INFO* test_blockage_overlap $shft_y_num"}
    }
    return $points
  } 

  ################################################################################
  ## test overlap with blockage
  ##
  proc test_blockage_overlap { points } {
    foreach_in_collection blockage [ get_placement_blockage * ] {
      set bbox [get_attr $blockage bbox ]
      set min_x [ lindex [ lindex $bbox 0 ] 0 ]
      set min_y [ lindex [ lindex $bbox 0 ] 1 ]
      set max_x [ lindex [ lindex $bbox 1 ] 0 ]
      set max_y [ lindex [ lindex $bbox 1 ] 1 ]

      set cell_index 0
      while { $cell_index < [ llength $points ] } {
        set x [ lindex $points $cell_index]
        set y [ lindex $points [ expr $cell_index + 1 ] ]
        if { $x < $max_x && $x > $min_x && $y < $max_y && $y > $min_y } { 
          return 1
        }
        set cell_index [ expr $cell_index + 2 ]
      }
    }
    return 0
  }

  ################################################################################
  ## get stage
  ##
  set max_stage -9999
  foreach root_pin_name $root_pin_names {
    set root_pin [ get_pins $root_pin_name ]
    set root_bbox [ get_attr $root_pin bbox ]
    set root_x [ lindex [ lindex $root_bbox 0 ] 0 ]
    set root_y [ lindex [ lindex $root_bbox 0 ] 1 ]
    #set loads [ filter_collection [ get_loads $root_pin ] "full_name =~ *FB_L1_DRIVE01*" ]
    set loads [ get_loads $root_pin ]
    set model_name [ get_attr [ get_cells -of $root_pin_name ] ref_name ]

    set is_close_to_startpin 0
    if { [ regexp {^(\S+)D(\d+)$} $model_name "" type size ] == 0 } {
        set is_close_to_startpin 1
    } else {
        regexp {^(\S+)D(\d+)$} $model_name "" type size
        if {$size < 16} {
                set is_close_to_startpin 1
        }
    }

    set box_list ""
    set root_num 0
    set leaf_num 0

    if { [ sizeof_collection $loads ] == 1 } {
      set load_bbox [ get_attr $loads bbox ]
      set load_x    [ lindex [ lindex $load_bbox 0 ] 0 ]
      set load_y    [ lindex [ lindex $load_bbox 0 ] 1 ]
      #set root_dis       [ expr hypot( [ expr $load_x - $root_x ], [ expr $load_y - $root_y ] ) ]
      set root_dis [ expr abs ($load_x - $root_x) + abs ( $load_y - $root_y) ]
      set root_num [ expr int ( [ expr $root_dis / $MaxDis ] ) ]
      set leaf_num 0
      set leaf_dis 0
    } elseif { [ sizeof_collection $loads ] > 1 } {
      foreach_in_collection pin $loads {
        set box_list [ concat $box_list [ list [ get_attr [get_pins  $pin ] bbox ] ] ]
      }
      set center_xy [ get_center_location $box_list ]
      set center_x [ lindex $center_xy 0 ]
      set center_y [ lindex $center_xy 1 ]
      #set root_dis [ expr hypot( [ expr $center_x - $root_x ], [ expr $center_y - $root_y ] ) ]     
      set root_dis [ expr abs ($center_x - $root_x) + abs ($center_y - $root_y) ]
      set root_num [ expr int ( [ expr $root_dis / $MaxDis ] ) + 1 ]

      set max_dis -9999
      foreach_in_collection load $loads {
        set load_bbox [ get_attr $load bbox ]
        set load_x    [ lindex [ lindex $load_bbox 0 ] 0 ]
        set load_y    [ lindex [ lindex $load_bbox 0 ] 1 ]
        #set leaf_dis  [ expr hypot( [ expr $load_x - $center_x ], [ expr $load_y - $center_y ] ) ]
        set leaf_dis [ expr abs ($load_x - $center_x) + abs ($load_y - $center_y) ]
        if { $leaf_dis > $max_dis } { set max_dis $leaf_dis }
      }
      set leaf_num [ expr int ( $max_dis / $MaxDis ) + 1 ]

    } else {
      puts "!!! Error !!! No loading on $root_pin_name"
    }
  
    if { $is_close_to_startpin == 1 } {
      set root_num [ expr $root_num + 1 ]
    }
   
    set RootInfo($root_pin_name) $root_num
    set RootDis($root_pin_name)  $root_dis 
    set LeafInfo($root_pin_name) $leaf_num
    set RootDrvInfo($root_pin_name) $is_close_to_startpin

    set stage [ expr $root_num + $leaf_num ]
    if { $is_inv == 1 } {
      set stage [ expr int( [ expr ceil( [ expr $stage / 2.0 ] ) * 2 ] ) ]
    }
    if { $stage > $max_stage } { set max_stage $stage}
  }

  ######################################################################################
  ## insert repeater
  foreach {root_pin_name is_close_to_startpin} [array get RootDrvInfo] {
    puts "*INFO* $root_pin_name"
    set root_pin [ get_pins $root_pin_name ]
    set root_bbox [ get_attr $root_pin bbox ]
    set root_x [ lindex [ lindex $root_bbox 0 ] 0 ]
    set root_y [ lindex [ lindex $root_bbox 0 ] 1 ]
    #set loads [ filter_collection [ get_loads $root_pin ] "full_name =~ *FB_L1_DRIVE01*" ]
    set loads [ get_loads $root_pin ]
    set root_num $RootInfo($root_pin_name)
    set leaf_num $LeafInfo($root_pin_name)
    set root_num [ expr $max_stage - $leaf_num ]

    #if { $is_inv == 1 } {
    #  set root_num [ expr int( [ expr ceil( [ expr $root_num / 2.0 ] ) * 2 ] ) ]
    #  set leaf_num [ expr int( [ expr ceil( [ expr $leaf_num / 2.0 ] ) * 2 ] ) ]
    #}


    set box_list ""
    if { [ sizeof_collection $loads ] == 1 } {
      set load_bbox [ get_attr $loads bbox ]
      set load_x    [ lindex [ lindex $load_bbox 0 ] 0 ]
      set load_y    [ lindex [ lindex $load_bbox 0 ] 1 ]
      #set affect    [ expr abs( $load_x - $root_x ) / abs( $load_y - $root_y ) ]
      #set x_step [ expr $affect * $MaxDis / ( $affect + 1 ) ]
      #set y_step [ expr $MaxDis - $x_step ]
      #set distance_x [ expr $load_x - $root_x]
      #set distance_y [ expr $load_y - $root_y]

      set points [ get_rpt_location $root_x $root_y $load_x $load_y $is_close_to_startpin 0 $root_num ]

      set cell_index [ expr $root_num * 2 - 1 ]
      while { $cell_index > 0 } {
        set x [ lindex $points [expr $cell_index - 1 ] ]
        set y [ lindex $points $cell_index ]
        #puts "$x $y"
        INSERT_BUFFER $root_pin_name $rpt_model_name -location "$x $y"
        set cell_index [ expr $cell_index - 2 ]
      }

    } elseif { [ sizeof_collection $loads ] > 1 } {
      foreach_in_collection pin $loads {
        set box_list [ concat $box_list [ list [ get_attr [get_pins  $pin ] bbox ] ] ]
      }
      set center_xy [ get_center_location $box_list ]
      set center_x [ lindex $center_xy 0 ]
      set center_y [ lindex $center_xy 1 ]
      ### insert root
      set points [ get_rpt_location $root_x $root_y $center_x $center_y $is_close_to_startpin 1 $root_num ]
      #puts $points
      set cell_index [ expr $root_num * 2 - 1 ]
      while { $cell_index > 0 } {
        set x [ lindex $points [expr $cell_index - 1 ] ]
        set y [ lindex $points $cell_index ]
        #puts "$x $y"
        INSERT_BUFFER $root_pin_name $rpt_model_name -location "$x $y"
        set cell_index [ expr $cell_index - 2 ]
      }
      ## insert leaf
      foreach_in_collection load $loads {
        set load_name [get_attr $load full_name ]
        set load_bbox [ get_attr $load bbox ]
        set load_x    [ lindex [ lindex $load_bbox 0 ] 0 ]
        set load_y    [ lindex [ lindex $load_bbox 0 ] 1 ]
        set points [ get_rpt_location $center_x $center_y $load_x $load_y 1 0 $leaf_num ]
        set cell_index 0
        while { $cell_index < [ expr $leaf_num * 2 ] } {
          set x [ lindex $points $cell_index]
          set y [ lindex $points [ expr $cell_index + 1 ] ]
          #puts "$x $y"
          INSERT_BUFFER $load_name $rpt_model_name -location "$x $y"
          set cell_index [ expr $cell_index + 2 ]
        }
      }
    }
  }

  puts "*INFO* Stage $max_stage"







