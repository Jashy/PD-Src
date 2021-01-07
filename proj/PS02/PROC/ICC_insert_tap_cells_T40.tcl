## $Id: insert_tap_cell.tcl,v 1.2.0 2010/8/31 Exp $
## Panasonic confidential
##
##

#### 
## - 7grid
## source ICC_insert_tap_cells_T40.tcl
## add_end_cap -lib_cell STD_STDVT-7G/S2GDMYHTAP8V1D0 -respect_blockage -ignore_soft_blockage
## ICC_insert_tap_cells -endcapmaster S2GDMYHTAP8V1D0 -tapmaster S2TAP3V1D0 \
##                      -toptapmaster S2TAPP7V1D0 -bottomtapmaster S2TAPN7V1D0 \
##                      -freetapmaster S2TAP8V1D0 -powernet VDD -groundnet VSS
##

proc ICC_insert_tap_cells {args} {
  echo [exec hostname]
  set start_time [cpu -all]
    
  parse_proc_arguments -args ${args} results;
  set place_track   [lindex [Get_site_info] 0]
  set place_track_y [lindex [Get_site_info] 1]

  #### initialize ####
  set tap_master ""
  set top_master ""
  set bottom_master ""
  set both_master ""
  set endcap_master ""

  set second_master ""
  set rowendcap_master ""

  set pitch 0
  set offset 0
  set tap_prefix "TAP"
  set power_net  "VDDL"
  set ground_net "VSS"
  set mode_flag "all"

  set insert_flag ""

  if { $place_track == 0.14 } {
    ## T40 7Grid Initialization ##
    set tap_master       "S2TAP3V1D0"
    set top_master       "S2TAPP7V1D0"
    set bottom_master    "S2TAPN7V1D0"
    set both_master      "S2TAP8V1D0"
    set endcap_master    "S2GDMYHTAP8V1D0"

#     set second_master    "S2TAP3V1D0"
    set second_master    ""

    set pitch  29.96
    set offset  0.00

    set insert_flag "like45"
  } elseif { $place_track == 0.156 } {
    ## 32nm Initialization ##
    set tap_master       "S2TAP2V1D0"
    set top_master       "S2TAPP4V1D0"
    set bottom_master    "S2TAPN4V1D0"
    set both_master      "S2TAP4V1D0"
    set endcap_master    "S2GDMYHTAP10V1D0"
    set rowendcap_master "S2GDMYVSUBCON1V1D0"
#     set pitch  28.00
    set offset  0.00

    set insert_flag "like32"
  } elseif { $place_track == 0.18 } {
    ## 45nm Initialization ##
    set tap_master       "SBC2LTAP3V1D0"
    set top_master       "SBC2LTAPP7V1D0"
    set bottom_master    "SBC2LTAPN7V1D0"
    set both_master      "SBC2LTAP7V1D0"
    set endcap_master    "SBC2LGDMYTAP7V1D0"
    set second_master    "SBC2LTAP5V1D0"
#     set filler_master    "SBC2LSUBCON1V1D0"
#     set filler_prefix    "ENDCAP_EDGE_FILL"
#     set pitch  32.00
    set offset  0.00

    set insert_flag "like45"
  }
  
#  set pitch ""
  set boundarybox [get_attribute [current_mw_cel ] bbox]
  set target_llx  [lindex $boundarybox 0 0]
  set target_lly  [lindex $boundarybox 0 1]
  set target_urx  [lindex $boundarybox 1 0]
  set target_ury  [lindex $boundarybox 1 1]
  set llbox       [lindex [get_attribute [get_core_area] bbox] 0 0]
  set offset      $llbox 
  
  global suppress_errors
  lappend suppress_errors "HDU-104"
  
  foreach argname [array names results] {
    if { ${argname} == "-mode" } {
      set mode_flag $results(${argname});
    } elseif { ${argname} == "-pitch" } {
      set pitch $results(${argname});
    } elseif { ${argname} == "-offset" } {
      set offset $results(${argname});
      set offset  [expr $offset + $target_llx]
    } elseif { ${argname} == "-tapmaster" } {
      set tap_master $results(${argname});
    } elseif { ${argname} == "-toptapmaster" } {
      set top_master  $results(${argname});
    } elseif { ${argname} == "-bottomtapmaster" } {
      set bottom_master $results(${argname});
    } elseif { ${argname} == "-freetapmaster" } {
      set both_master $results(${argname});
    } elseif { ${argname} == "-endcapmaster" } {
      set endcap_master  $results(${argname});
    } elseif { ${argname} == "-rowendcapmaster" } {
      set rowendcap_master  $results(${argname});
    } elseif { ${argname} == "-secondmaster" } {
      set second_master  $results(${argname});
    } elseif { ${argname} == "-prefix_tap" } {
      set tap_prefix  $results(${argname});
    } elseif { ${argname} == "-powernet" } {
      set power_net $results(${argname});
    } elseif { ${argname} == "-groundnet" } {
      set ground_net $results(${argname});
    }
#     echo "  $argname = $results($argname)"
  }

  ### check Specify master name
  if { $insert_flag eq "like32" } {
    if {[check_ref32nm_cell $tap_master $top_master $bottom_master $both_master $endcap_master $rowendcap_master $mode_flag] == 1} {
      return -3103
    }
  } elseif {$insert_flag eq "like45" } {
    if {[check_ref45nm_cell $tap_master $top_master $bottom_master $both_master $endcap_master $second_master $mode_flag] == 1} {
      return -3103
    }
  }

  set tap_size_x    [lindex [Get_cell_bbox $tap_master]    1 0]
  set tap_size_y    [lindex [Get_cell_bbox $tap_master]    1 1]
  set endcap_size_x [lindex [Get_cell_bbox $endcap_master] 1 0]
  set i 0

  # TAPセル挿入部
  if { $mode_flag == "all" || $mode_flag == "insert_tap_only" } {
    if { $pitch == ""} {
      echo "Error : Please specify \'-pitch\'"
      return -3103
    }
  
    # create place area
    # EndCapの存在確認とEndCap一覧取得
    # EndCapが無ければError終了
    set all_endcap_collection {}
    set all_endcap [list $endcap_master]
    foreach endcap $all_endcap {
      append_to_collection all_endcap_collection [get_cells -hier -quiet -all -filter ref_name==$endcap]
    }

    if { [sizeof_collection $all_endcap_collection] == 0 } {
      echo "Error : No insert End Cap Cell"
      echo "    Please execute Insert EndCapCell ."
      return -310
    }

    # Tapセルの存在確認
    # Tapが有れば、すべて消す
    set all_tap_collection {}
    set all_tap [list $tap_master]
    foreach tap $all_tap {
      append_to_collection all_tap_collection [get_cells -hier -quiet -all -filter ref_name==$tap]
    }

    if { [sizeof_collection $all_tap_collection] != 0 } {
      echo "Warning : Already insert TapCell. Delete TapCell!!"
#       echo "      Please check TAP pitch and offset of layout cell."  
      remove_stdcell_filler -tap
    }

    # EndCap上に配置Blockage作成
    #  ※EndCapの近くにTapセルが入らないように
    set haba [expr $pitch * 0.5 - $endcap_size_x * 0.5 - $tap_size_x * 0.5 + $place_track * 0.5]
    set haba [expr int($haba / $place_track) * $place_track - $place_track]   
    echo "# Insert Tap Start #"
    x_create_blockage $haba 0 $all_endcap_collection $tap_prefix 

    # Offset位置調整
    #  Tap-EndCap間が空きすぎないように、offset位置を変更(マニュアルの注意事項参照)
    if { $offset > [expr $pitch + $llbox] } {
      set offset [expr $offset -  $pitch * ( int( $offset / $pitch ) -1 ) ]
    }

    ############## W.A of "add_tap_cell_array" Command offset Bug.
    ############## if "add_tap_cell_array" Fix, Delete following command.
    while { $offset < [expr $pitch * 0.5 + $llbox] } {
      set offset [expr $offset + $pitch]
    }

    set disp_pitch [expr int($pitch / $place_track) * $place_track ]
    set disp_offset [expr $offset - $llbox]
    set disp_offset [expr int($disp_offset / $place_track) * $place_track ]
    set disp_offset [expr $disp_offset - $target_llx + $llbox]
    echo "=============================================="
    echo "   Insert TAPMaster \"$tap_master\""
    echo "   pitch $disp_pitch , offset $disp_offset um"
    echo "=============================================="

    set offset [expr $offset - $pitch * 0.5  - $llbox]
    ######################################################
  
    set pitch  [expr int($pitch / $place_track) * $place_track ]     
    set offset [expr int($offset / $place_track) * $place_track ]

    ##### insert TAP cell #####  
    # icc標準コマンドでTap挿入
    add_tap_cell_array \
      -master_cell_name $tap_master \
      -distance $pitch \
      -offset $offset \
      -ignore_soft_blockage true \
      -connect_power_name $power_net \
      -connect_ground_name $ground_net \
      -tap_cell_identifier $tap_prefix \
      -tap_cell_separator "_"

    # EndCap上に作成したBlockage削除
    remove_objects [get_placement_blockage ${tap_prefix}_* ]
  }

  # TAPセル置換部
  if { $mode_flag == "all" || $mode_flag == "replace_tap_only" } {
    set all_tap ""
    set all_tap_collection {}
    set all_tap [list $tap_master]

    # TAPセルの存在チェック
    #  TAPセルが無ければ、Error終了
    foreach tap $all_tap {
      append_to_collection all_tap_collection [get_cells -hier -quiet -all -filter ref_name==$tap]
    }

    if { [sizeof_collection $all_tap_collection] == 0 } {
      echo "Error : No insert Tap Cell. Replace TapCell is not executed."
      echo "    Please execute Insert TapCell ."
      return -3103
    }

    # 最上位、最下位ROW上のRowEndCapセル上に配置Blockageを作成
    # 32相当処理の時のみ実行
    #  ※RowEndCapとの境のTAPセルは置換の必要が無いため(32のTAP挿入マニュアル参照)
    echo "### Get Tap info ###"
    if { $insert_flag eq "like32" } {
      set all_row_endcap ""
      foreach rowendcap $rowendcap_master {
        lappend all_row_endcap [get_cells -hier -quiet -all -filter ref_name==${rowendcap}]
      }
#     echo [sizeof_collection $all_row_endcap]
      x_create_blockage  0 0 $all_row_endcap $tap_prefix 
    }

    # Tapセル一覧取得
    set all_tap_collection {}
    set all_tap [list $tap_master $top_master $bottom_master]
    foreach tap $all_tap {
      append_to_collection all_tap_collection [get_cells -hier -quiet -all -filter ref_name==$tap *${tap_prefix}* ]
    }
    set tap_info [cell_collection_to_centerlist $all_tap_collection]

    # EndCapの一覧取得
    set all_endcap_collection {}
    set all_endcap [list $endcap_master]
    foreach endcap $all_endcap {
      append_to_collection all_endcap_collection [get_cells -hier -quiet -all -filter ref_name==$endcap *${tap_prefix}* ]
    }
    set endcap_info [cell_collection_to_centerlist2 $all_endcap_collection]

    # TAPセルの置換処理
    #  配置仕様にあわせて、配置制限ありTAPセル(tap_master)を置換
    echo "### Replace Tap Cell ###"
#     echo $tap_info
    y_box_check_and_cell_change $tap_info $tap_master $top_master $bottom_master $both_master $endcap_info $insert_flag

    # 45でsecont_masterの指定がある時には、45独自の置換処理を行う
    #  ※top_master,bottom_masterとtap_masterの間にscond_masterを挟む用に配置する(45TAP挿入マニュアル参照)
    #  T40では不要のため、にscond_masterを定義していない
    if { $insert_flag eq "like32" } {
      remove_objects [get_placement_blockage ${tap_prefix}_* ]
    } elseif { $insert_flag eq "like45" } {
      echo "\n\n### Replace2 Tap Cell ###"
      set all_replace_tap [list $bottom_master $top_master]
      foreach replace_tap $all_replace_tap {
        append_to_collection all_replace_tap_collection [get_cells -hier -quiet -all -filter ref_name==$replace_tap * ]
      }
      set replace_tap_info [cell_collection_to_centerlist $all_replace_tap_collection]
      if { $second_master ne "" } {
        replace_45nm_only $replace_tap_info $tap_master $second_master
      }
    }
  }

  echo "##### Insert Tap Cell End ####"

  set end_time [cpu -all]
  set run_time [expr $end_time - $start_time];
  echo "### Run CPU Time (sec) : $run_time ###"  
}

define_proc_attributes ICC_insert_tap_cells \
  -info "Insert Tap Cell ver1.2.0" \
  -define_args { \
    {-mode "Inser Mode" String one_of_string {optional value_help {values {all insert_tap_only replace_tap_only}}} }\
    {-pitch "Insert Tap Pitch" Float float optional} \
    {-offset "Insert Tap Offset " Float float optional} \
    {-tapmaster "Array Insert Tap Cell : Default : S2TAP2V1D0(32nm) SBC2LTAP3V1D0(45nm)" String string optional} \
    {-prefix_tap "Tap Cell Prefix : Default : TAP"  String string optional} \
    {-toptapmaster "Top Tap Cell : Default : S2TAPN4V1D0(32nm) SBC2LTAPN7V1D0(45nm)" String string optional} \
    {-bottomtapmaster "Bottom Tap Cell : Default : S2TAPP4V1D0(32nm) SBC2LTAPP7V1D0(45nm)" String string optional} \
    {-freetapmaster "Free Tap Cell : Default : S2TAP4V1D0(32nm) SBC2LTAP7V1D0(45nm)" String string optional} \
    {-endcapmaster "End Cap Cell : Default : S2GDMYHTAP10V1D0(32nm) SBC2LGDMYTAP7V1D0(45nm)" String string optional} \
    {-rowendcapmaster "End Cap Row Cell : Default : S2GDMYVSUBCONV1D0(32nmOnly)" List list optional} \
    {-secondmaster "Replace Tap Cell : Default : SBC2LTAP5V1D0(45nmOnly)" String string optional} \
    {-powernet "Power Net Name : Default : VDD"  String string optional} \
    {-groundnet "Ground Net Name : Default : VSS"  String string optional} \
  }

proc x_create_blockage { haba hosei all_tap_collection prefix } {
  set count 0
  set createblockagelist {}

  foreach_in_collection tapbox $all_tap_collection {
    incr count
    set box [get_attribute [get_cell -all $tapbox] bbox]

    set minx [expr [lindex $box 0 0] - $haba]
    set miny [expr [lindex $box 0 1] + $hosei]
    set maxx [expr [lindex $box 1 0] + $haba]
    set maxy [expr [lindex $box 1 1] - $hosei]
    set box2 [list $minx $miny $maxx $maxy]
    create_placement_blockage -bbox $box2 -type hard -name ${prefix}_${count}
  }
}

proc replace_45nm_only {replace_tap_info tap_master second_master} {
  set  all_replace2_tap_collection ""
  foreach info $replace_tap_info {
  set llx1 [lindex $info 2]
  set llx1 [expr $llx1 * 0.001]
  set lly1 [lindex $info 3]
  set lly1 [expr $lly1 * 0.001]
  set urx1 [lindex $info 4]
  set urx1 [expr $urx1 * 0.001]
  set ury1 [lindex $info 5]
  set ury1 [expr $ury1 * 0.001]
  set rect [list $llx1 $lly1 $urx1 $ury1]
  append_to_collection all_replace2_tap_collection [get_cells -all -intersect $rect  -filter ref_name==$tap_master]
  }
  
  set place_track_x [lindex [Get_site_info]  0 ]
  
  foreach_in_collection replace $all_replace2_tap_collection {
  set instname2 [get_attribute $replace full_name]
  set master $second_master
  echo "### $instname2 is replaced with $master . "
  change_cell_xcenter_move $instname2 $master $place_track_x
  }
}

proc check_ref32nm_cell {tap_master top_master bottom_master both_master endcap_master rowendcap_master mode_flag} {
  set ErrorFlag 0

  if { $mode_flag == "all" || $mode_flag == "insert_endcap_only" } {
    set endcap_flag [get_physical_lib_cells -q  $endcap_master]
    if {$endcap_flag == "" } {
      echo "Error:illegal master-cell \($endcap_master.\)"
      echo "Please specify correct master by \"-endcapmaster\""
      set ErrorFlag 1
    }
  
    foreach cell $rowendcap_master {
      set rowendcap_flag [get_physical_lib_cells -q  $cell]
      if {$rowendcap_flag == "" } {
        echo "Error:illegal master-cell \($cell.\)"
        echo "Please specify correct master by \"-rowendcapmaster\""
        set ErrorFlag 1
      }
    }
  }

  if { $mode_flag == "all" || $mode_flag == "insert_tap_only" } {
    set tap_flag [get_physical_lib_cells -q  $tap_master]
    if {$tap_flag == "" } {
      echo "Error:illegal master-cell \($tap_master.\)"
      echo "Please specify correct master by \"-tapmaster\""
      set ErrorFlag 1
    }
  }

  if { $mode_flag == "all" || $mode_flag == "replace_tap_only" } {
    set top_flag [get_physical_lib_cells -q  $top_master]
    if {$top_flag == "" } {
      echo "Error:illegal master-cell \($top_master.\)"
      echo "Please specify correct master by \"-toptapmaster\""
      set ErrorFlag 1
    }

    set bottom_flag [get_physical_lib_cells -q  $bottom_master]
    if {$bottom_flag == "" } {
      echo "Error:illegal master-cell \($bottom_master.\)"
      echo "Please specify correct master by \"-bottomtapmaster\""
      set ErrorFlag 1
    }

    set both_flag [get_physical_lib_cells -q  $both_master]
    if {$both_flag == "" } {
      echo "Error:illegal master-cell \($both_master.\)"
      echo "Please specify correct master by \"-freetapmaster\""
      set ErrorFlag 1
    }
  }

  return $ErrorFlag
}

proc check_ref45nm_cell {tap_master top_master bottom_master both_master endcap_master second_master mode_flag} {
  set ErrorFlag 0

  if { $mode_flag == "all" || $mode_flag == "insert_tap_only"} {
    set endcap_flag [get_physical_lib_cells -q  $endcap_master]
    if {$endcap_flag == "" } {
      echo "Error:illegal master-cell \($endcap_master.\)"
      echo "Please specify correct master by \"-endcapmaster\""
      set ErrorFlag 1
    }
  }

  if { $mode_flag == "all" || $mode_flag == "insert_tap_only" } {
    set tap_flag [get_physical_lib_cells -q  $tap_master]
    if {$tap_flag == "" } {
      echo "Error:illegal master-cell \($tap_master.\)"
      echo "Please specify correct master by \"-tapmaster\""
      set ErrorFlag 1
    }
  }

  if { $mode_flag == "all" || $mode_flag == "replace_tap_only" } { 
    set top_flag [get_physical_lib_cells -q  $top_master]
    if {$top_flag == "" } {
      echo "Error:illegal master-cell \($top_master.\)"
      echo "Please specify correct master by \"-toptapmaster\""
      set ErrorFlag 1
    }

    set bottom_flag [get_physical_lib_cells -q  $bottom_master]
    if {$bottom_flag == "" } {
      echo "Error:illegal master-cell \($bottom_master.\)"
      echo "Please specify correct master by \"-bottomtapmaster\""
      set ErrorFlag 1
    }

    set both_flag [get_physical_lib_cells -q  $both_master]
    if {$both_flag == "" } {
      echo "Error:illegal master-cell \($both_master.\)"
      echo "Please specify correct master by \"-freetapmaster\""
      set ErrorFlag 1
    }

    if { $second_master ne "" } {
      set second_flag [get_physical_lib_cells -q  $second_master]
      if {$second_flag == "" } {
        echo "Error:illegal master-cell \($second_master.\)"
        echo "Please specify correct master by \"-secondmaster\""
        set ErrorFlag 1
      }
    }
  }

  return $ErrorFlag
}

## 配置仕様にあわせてTAPセルの置換を行う (TAP挿入マニュアル参照)
##  tap_masterの上下rowにあるセルをチェック
##  tap_master以外のセルが有れば、top_master,bottom_masterに置換する
##  孤立している場合はboth_masterに置換する
##  Blockageの場合は置換しない
proc y_box_check_and_cell_change {tap_info tap_master top_master bottom_master both_master endcap_info insert_flag} {
  set instance 0
  set place_track_x [lindex [Get_site_info]  0 ]
  set place_halftrack_x [expr $place_track_x * 0.5]
#   set place_track_y [lindex [Get_site_info]  1]
#   set place_halftrack_y $place_halftrack_x

  set blockage_list [get_blockage_bbox]

  set tap_size_x  [lindex [Get_cell_bbox $tap_master] 1 0]
  set tap_size_y  [lindex [Get_cell_bbox $tap_master] 1 1]
  set tap_halfsize_y [expr $tap_size_y  * 0.5]

  set bottom_size_x [lindex [Get_cell_bbox $bottom_master] 1 0]
  set bottom_halfsize_x [expr int( ($bottom_size_x - $tap_size_x) * 1000 * 0.5)]

  set top_size_x [lindex [Get_cell_bbox $top_master] 1 0]
  set top_halfsize_x [expr int( ($top_size_x - $tap_size_x) * 1000 * 0.5)]

  set replacelist {}

  set displaycount 0
  set max_tap [llength $tap_info ]
  set display_out [expr int($max_tap * 0.1)]
  set outdisplaycount 0

  # TAPセルの置換対象を調べるため、座標ベースでFlagをたてる
  #  Tapの置き換えが必要ない座標がわかるように、座標でFlagを作る
  foreach info $tap_info {
    set master [lindex $info 0]
    set inst [lindex $info 1]

    set llx1 [lindex $info 2]
    set lly1 [lindex $info 3]
    set urx1 [lindex $info 4]
    set ury1 [lindex $info 5]

    set top_${lly1}_check_array(${llx1}_${urx1}) 1
    set bottom_${ury1}_check_array(${llx1}_${urx1}) 1
  }

  # TAPの置換が必要なセルをチェック
  #  上で作ったflagの座標と比較して、置換の必要性をチェックする
  #  座標にFlagが存在すれば、置換の必要なし
  echo "### Check Tap Cell ###"
  foreach info $tap_info {
    incr displaycount
    set outdisplay [expr int($displaycount / $display_out)]
    if { $outdisplaycount < $outdisplay } {
      set outdisplaycount $outdisplay
      echo "${outdisplaycount}0" "%"
    }

    set master [lindex $info 0]
    if { $master != $tap_master } continue

    set llx1 [lindex $info 2]
    set lly1 [lindex $info 3]
    set urx1 [lindex $info 4]
    set ury1 [lindex $info 5]

    set top_flag "0"
    set bottom_flag "0"
    set top_cap_flag "0"
    set bottom_cap_flag "0"
    set top_blockageflag "0"
    set bottom_blockageflag "0"

    set tmpllx {}
    set tmpurx {}
    set tmpury {}

    # Tapセル(tap_master)の上下に別のTapセルが有るか、Flagでチェック
    # 他のTapセルが有れば、何もしない
    # 置換対象のセルは、bottom_flag,top_flagを0とする
    # bottom_flag, top_flagともに0の場合はboth_masterに置き換える
    set tmp_bottom [array names bottom_${lly1}_check_array -exact ${llx1}_${urx1} ]
    if { $tmp_bottom != {} } {
      set bottom_flag 1
      array unset bottom_${lly1}_check_array  ${llx1}_${urx1}
    } 

#    set bottom_flag [lsearch $tap_info {* * $llx1 * $urx1 lly1}]

    set tmp_top [array names top_${ury1}_check_array -exact ${llx1}_${urx1} ]

    if { $tmp_top != {} } {
      set top_flag 1
      array unset top_${ury1}_check_array  ${llx1}_${urx1}
    }

#    set top_flag [lsearch $tap_info {* * $llx1 $ury1 $urx1 *}]

    if { $bottom_flag == 1 && $top_flag == 1 } continue

    # すでに置換対象のセルが有る場合は、置換をスキップする
    # bottom_cap
    set llx11 [expr int($llx1 - $bottom_halfsize_x)]
    set urx11 [expr int($urx1 + $bottom_halfsize_x)]

    set tmp_bottom [array names bottom_${lly1}_check_array -exact ${llx11}_${urx11} ]
    if { $tmp_bottom != {} } {
      set bottom_cap_flag 1
      array unset bottom_${lly1}_check_array  ${llx11}_${urx11}
    }

#     set bottom_cap_flag [lsearch $tap_info {* * $llx11 * $urx11 lly1}]
  
    # top_cap
    set llx11 [expr int($llx1 - $top_halfsize_x)]
    set urx11 [expr int($urx1 + $top_halfsize_x)]

    set tmp_top [array names top_${ury1}_check_array -exact ${llx11}_${urx11} ]
    if { $tmp_top != {} } {
      set top_cap_flag 1
      array unset top_${ury1}_check_array  ${llx11}_${urx11}
    }

#     set top_cap_flag [lsearch $tap_info {* * $llx11 $ury1 $urx11 *}]

#     if { $bottom_cap_flag == 1 && $top_cap_flag == 1 } continue

    set bottom_flag [expr $bottom_flag + $bottom_cap_flag ]
    set top_flag [expr $top_flag + $top_cap_flag ]

    if { $bottom_flag == 1 && $top_flag == 1 } continue

    # Blockageとの境界は置換リストからはずす
    if { $bottom_flag == 0 } {
      if { $insert_flag eq "like32" } {
        set check_bottom_bbox [list [list [expr ($llx1 * 0.001) - $place_track_x * 4  ] [expr ($lly1 * 0.001) - $tap_size_y + 0.0001] ] [list [expr ($urx1 * 0.001) + $place_track_x * 4  ] [expr ($lly1 * 0.001)  ]]]
      } elseif { $insert_flag eq "like45" } {
        set check_bottom_bbox [list [list [expr ($llx1 * 0.001)  ] [expr ($lly1 * 0.001) - $tap_size_y + 0.0001 ] ] [list [expr ($urx1 * 0.001) ] [expr ($lly1 * 0.001) ]]]
      }

#       echo "# Chack Bottom Blockage : " $check_bottom_bbox
#       set bottom_blockage_check [get_placement_blockages -quiet -type hard -intersect  $check_bottom_bbox]
#       set bottom_blockageflag [sizeof_collection $bottom_blockage_check]

      set bottom_blockageflag [check_overlap_bboxlist  $check_bottom_bbox $blockage_list $endcap_info ]

#       echo $bottom_blockageflag
      if { $bottom_blockageflag == 0 } {
        if { $top_flag != 0 } {
          set instname [lindex $info 1]
          set cellid [get_cell -quiet -all $instname]
#           echo "auau_b"
          set ori [get_attribute $cellid orientation]
          if { $ori == "N" || $ori == "FN" } {
            set tmplist [list  $instname $top_master]
            lappend replacelist $tmplist
          } elseif { $ori == "S" || $ori == "FS" } {
            set tmplist [list  $instname $bottom_master]
            lappend replacelist $tmplist
          }
          continue
        }
      }
    }

    # Blockageとの境界は置換対象からはずす
    if { $top_flag == 0 } {
      if { $insert_flag eq "like32" } {
        set check_top_bbox [list [list [expr ($llx1 * 0.001) - $place_track_x * 4 ] [expr ($ury1 * 0.001) ] ] [list [expr ($urx1 * 0.001) + $place_track_x * 4 ] [expr ($ury1 * 0.001) + $tap_size_y - 0.0001]]]
      } elseif { $insert_flag eq "like45" } {
        set check_top_bbox [list [list [expr ($llx1 * 0.001) ] [expr ($ury1 * 0.001) ] ] [list [expr ($urx1 * 0.001) ] [expr ($ury1 * 0.001) + $tap_size_y -0.0001 ]]]
      }
#       echo "# Chack Top Blockage : " $check_top_bbox
#       set top_blockage_check [get_placement_blockages -quiet -type hard -intersect  $check_top_bbox]
#       set top_blockageflag [sizeof_collection $top_blockage_check]
      set top_blockageflag [check_overlap_bboxlist  $check_top_bbox $blockage_list $endcap_info]

#       echo $top_blockageflag
      if { $top_blockageflag == 0 } {
        if { $bottom_flag != 0 } {
          set instname [lindex $info 1]
          set cellid [get_cell -quiet -all $instname]
#           echo "auau_t"
          set ori [get_attribute $cellid orientation]
          if { $ori == "N" || $ori == "FN" } {
            set tmplist [list  $instname $bottom_master]
            lappend replacelist $tmplist
          } elseif { $ori == "S" || $ori == "FS" } {
            set tmplist [list  $instname $top_master]
            lappend replacelist $tmplist
          }
          continue
        }
      }
    }

#     if { $bottom_blockageflag != 0 &&  $top_blockageflag != 0 } continue

#     set both_flag [expr $top_blockageflag + $top_flag + $bottom_blockageflag + $bottom_flag]
    set both_flag [expr $top_flag + $bottom_flag]

#     echo $top_blockageflag  $bottom_blockageflag  $top_flag $bottom_flag

    # 置換フラグにあわせてセルの置き換えリスト(replacelist)作成
    set tmplist {}
    # change cell
    if { $both_flag == 0 } {
      if { $top_blockageflag == 0 ||  $bottom_blockageflag == 0 } {
        set instname [lindex $info 1]
        set cellid [get_cell -quiet -all $instname]
        set ori [get_attribute $cellid orientation]
        set tmplist [list  $instname $both_master]
        lappend replacelist $tmplist
        continue
      }
    } else {
      continue
    }
  }

  # 置換リストにあわせて、セルの置き換え
  #  X座標の中心を動かさずに置換する(change_cell_xcenter_moveコマンド)
  set tmpcount [llength $replacelist]
  if {$tmpcount == 0 } {
    echo "### The change is not necessary. ###"
    return
  }
  foreach replace $replacelist {
    set instname2 [lindex $replace 0]
    set master [lindex $replace 1]
    echo "### $instname2 is replaced with $master . "
    change_cell_xcenter_move $instname2 $master $place_track_x
  }
}

proc get_blockage_bbox {} {
  set returnlist {}
  set blockage_colle [get_placement_blockages -quiet -type hard]

  foreach_in_collection blockageid $blockage_colle {
    set tmp [get_attribute $blockageid bbox]
    lappend returnlist $tmp
  }
  return $returnlist
}

# bboxAとbboxlistBとの重なりチェック
# bboxA がbboxlistBと重なっていて、bboxlistCと重なっていない時1を返す
proc check_overlap_bboxlist {bboxA bboxlistB bboxlistC} {
  set returnflag 0

  set xa1 [lindex $bboxA 0 0]
  set ya1 [lindex $bboxA 0 1]
  set xa2 [lindex $bboxA 1 0]
  set ya2 [lindex $bboxA 1 1]
  if { $xa1 > $xa2 } {
    set tmp $xa1
    set xa1 $xa2
    set xa2 $tmp
  }
  if { $ya1 > $ya2 } {
    set tmp $ya1
    set ya1 $ya2
    set ya2 $tmp
  }
  foreach bboxB $bboxlistB {
    set xb1 [lindex $bboxB 0 0]
    set yb1 [lindex $bboxB 0 1]
    set xb2 [lindex $bboxB 1 0]
    set yb2 [lindex $bboxB 1 1]

    if { $xb1 > $xb2 } {
      set tmp $xb1
      set xb1 $xb2
      set xb2 $tmp
    }
    if { $yb1 > $yb2 } {
      set tmp $yb1
      set yb1 $yb2
      set yb2 $tmp
    }

    if { $xa1 <= $xb2 
      && $ya1 <= $yb2 
      && $xa2 >= $xb1 
      && $ya2 >= $yb1 } {
      set returnflag 1
      break
    }
  }

  foreach bboxC $bboxlistC {
    set xc1 [lindex $bboxC 0]
    set yc1 [lindex $bboxC 1]
    set xc2 [lindex $bboxC 2]
    set yc2 [lindex $bboxC 3]

    if { $xc1 > $xc2 } {
      set tmp $xc1
      set xc1 $xc2
      set xc2 $tmp
    }
    if { $yc1 > $yc2 } {
      set tmp $yc1
      set yc1 $yc2
      set yc2 $tmp
    }

    if { $xa1 <= $xc2 
      && $ya1 <= $yc2 
      && $xa2 >= $xc1 
      && $ya2 >= $yc1 } {
      set returnflag 0
      break
    }
  }
  return $returnflag
}

# 毎回attributeを取得すると処理時間が膨大になるため、先に必要な情報を取得
proc cell_collection_to_centerlist { cellcollection } {
  set returnlist {}

#   echo [sizeof_collection $cellcollection]
  foreach_in_collection cellid $cellcollection {
    set tmplist {}
    set bbox [get_attribute $cellid bbox]
    set bbox_llx [expr [lindex $bbox 0 0] * 1000]
    set bbox_llx [expr int($bbox_llx)]

    set bbox_lly [expr [lindex $bbox 0 1] * 1000]
    set bbox_lly [expr int($bbox_lly)]  

    set bbox_urx [expr [lindex $bbox 1 0] * 1000]
    set bbox_urx [expr int($bbox_urx)]  

    set bbox_ury [expr [lindex $bbox 1 1] * 1000]  
    set bbox_ury [expr int($bbox_ury)]  

    set master [get_attribute $cellid ref_name]
    set instname [get_attribute $cellid full_name]

    set tmplist [list $master $instname $bbox_llx $bbox_lly $bbox_urx $bbox_ury]

    lappend returnlist $tmplist
  }
  return $returnlist
}

proc cell_collection_to_centerlist2 { cellcollection } {
  set returnlist {}

#   echo [sizeof_collection $cellcollection]
  foreach_in_collection cellid $cellcollection {
    set tmplist {}
    set bbox [get_attribute $cellid bbox]
    set bbox_llx [expr [lindex $bbox 0 0]]
#     set bbox_llx [expr int($bbox_llx)]

    set bbox_lly [expr [lindex $bbox 0 1]]
#     set bbox_lly [expr int($bbox_lly)]

    set bbox_urx [expr [lindex $bbox 1 0]]
#     set bbox_urx [expr int($bbox_urx)]

    set bbox_ury [expr [lindex $bbox 1 1]]
#     set bbox_ury [expr int($bbox_ury)]

    set tmplist [list $bbox_llx $bbox_lly $bbox_urx $bbox_ury]

    lappend returnlist $tmplist
  }
  return $returnlist
}

proc get_bbox_center {bbox} {  # echo "### Replace Tap Cell ###"
  set x0 [lindex $bbox 0 0]
  set y0 [lindex $bbox 0 1]
  set x1 [lindex $bbox 1 0]
  set y1 [lindex $bbox 1 1]

  set x [expr  ($x1 + $x0) / 2 ]
  set y [expr  ($y1 + $y0) / 2 ]

  set center [list $x $y]

  return $center
}

proc sisyagonyu {suuti keta } {
  set fugou 1

  if {$suuti < 0} {
    set fugou -1
  }
  set ketaketa [expr pow(10,$keta)]

  set suuti [expr abs($suuti)/$ketaketa+0.5]

  set kekka [expr int($suuti)*$ketaketa*$fugou]

  return $kekka
}

# 指定Cellの枠 Boxを取得する
# 返り値はcell box [list x y]
proc Get_cell_bbox {cellname } {
  set cell_id [index_collection [get_physical_lib_cells $cellname] 0]
  set cell_box [get_attribute $cell_id bbox]

  return $cell_box
}

# Rowのsite情報を取得する
# 返り値はsite size [list x y]
proc Get_site_info { } {
  set site_id [index_collection [get_site_rows] 0]
  set site_x [get_attribute $site_id site_space]
  set site_y [expr [get_attribute  $site_id bbox_ury] - [get_attribute  $site_id bbox_lly]]

  set site [list $site_x $site_y]

  return $site
}

# セル(instance)のx座標中心を動かさずに、指定masterセルに置換する
# 座標計算のため、配置グリッド(grid)を指定する
proc change_cell_xcenter_move {instance master grid} {
  echo "### change_cell ###"
  set cellcoll [get_cell -all  $instance]
  set point [get_attribute $cellcoll bbox]

  set center [get_bbox_center $point]
  set xcenter1 [lindex $center 0]

  change_link ${instance} ${master}

  set point [get_attribute $cellcoll bbox]
  set center2 [get_bbox_center $point]
  set xcenter2 [lindex $center2 0]
#   echo $xcenter1 $xcenter2

  set sabun [expr ($xcenter1 - $xcenter2) / $grid]
#   echo $sabun

  set sabun [expr [sisyagonyu $sabun 0] * $grid]
  set sabun [sisyagonyu $sabun -2]

  move_objects -ignore_fixed -delta [list ${sabun} 0] $cellcoll

#   set cellcoll [get_cell -all  $instance]

  gui_change_highlight -add -color red -collection ${cellcoll}
}

