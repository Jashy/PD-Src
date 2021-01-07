####################################################################################################
# PROGRAM     : fishbone_util.tcl
# DESCRIPTION : create fb For ICC ( TEST ON 2008.09-SP5)
# WRITTEN BY  : Marshal Su ( marshals@alchip.com )
# LAST UPDATE : Tue Jul 15 11:31 JST 2009
# HISTORY     : Tue Jul 15 11:31 JST 2009
#             : v1.0 initial test version
#             : v2.0 avoid fishbonebuffer overlap with blockage and fixed cell; add 'shft_x' 'shft_y' for shfit fishbonebuffer
#             : v2.5 improve the runtime
#             :      in order to avoid DRC on PowerVias. please convert 
#             : v3.0 get via/metal rules from techfile
#             :      fix some bugs about fishbone buffer placer
#             :      update for tsmc13
#             : v3.2 re-write CreateVias proc, techfile no use any more
# USAGE       : (1) Modify the METAL_LAYERS KEEPOUT_MARGIN techfile setting first according to project
#             : (2) change route type of power via to P/G Strap
#             : (3) alcpFishBone $NetName $TrunkLayer $TrunkWidth $BranchLayer $BranchWidth $pitch $RowStep $FirstStageLayer $PreStageLayer $LastStageLayer $shft_x $shft_y
# EXAMPLE     :
#             : alcpFishBone bist_clk_mgc_2 34 6 35 0.6 30 2 32 32 32
# KNOWN ISSUE : (1) can not be used in version 2007.03 due to no command `get_pin_shapes`
####################################################################################################


suppress_message MWUI-031
suppress_message HDU-104
#if { [ current_design_name ] == "TITANIO" } {
# mental layer list
#  set METAL_LAYERS [ list 31 32 33 34 35 ]
#  set KEEPOUT_MARGIN 1.5
#  set NumverOfFishBoneStage 3
#  set techfile /proj/R2SI/LIB/CURRENT/Techfile/astro/tsmcn65lp_5lm3x1yAlrdl.tf
#} elseif { [ current_design_name ] == "visic" } {
#  set METAL_LAYERS [ list 31 32 33 34 35 36 ]
#  set KEEPOUT_MARGIN 1.5
#  set NumverOfFishBoneStage 3
#  set techfile /proj/VISIC/LIB/CURRENT/Techfile/synopsys/astro/tsmc013gFsg_6lm_6x6.tf
#} 
  set METAL_LAYERS [ list 31 32 33 34 35 ]
#  set METAL_LAYERS [ list 61 62 63 64 65 66 ]
  set KEEPOUT_MARGIN 1.5
  set NumverOfFishBoneStage 3


proc alcpFishBone { NetName { TrunkLayer 34 } { TrunkWidth 6 } { BranchLayer 35 } {BranchWidth 0.6} { pitch 50 } { RowStep 2 }  { FirstStageLayer 32 } { PreStageLayer 32 } {LastStageLayer 32} { shft_x 0 } { shft_y 0 } { CheckStrap 1 } { CheckBlkg 0 } { CheckFixed 0 } } {

  global METAL_LAYERS
  global NumverOfFishBoneStage
  global KEEPOUT_MARGIN
  global ROW_HEIGHT

  set_object_snap_type -enabled 1
  set_object_snap_type -type cell -snap row_tile
  
  puts "##################################################################################"
  puts "## alcpFishBone $NetName $TrunkLayer $TrunkWidth $BranchLayer $BranchWidth $pitch $RowStep $FirstStageLayer $PreStageLayer $LastStageLayer"
  ResetFishbone $NetName $NumverOfFishBoneStage
  puts "*INFO* alcpFishBone $NetName"
  puts "*INFO* TrunkLayer / TrunkWidth                          : $TrunkLayer / $TrunkWidth"
  puts "*INFO* BranchLayer / BranchWidth                        : $BranchLayer / $BranchWidth"
  puts "*INFO* Pitch / RowStep                                  : $pitch / $RowStep"
  puts "*INFO* FirstStageLayer / PreStageLayer / LastStageLayer : $FirstStageLayer / $PreStageLayer / $LastStageLayer"
  puts "*INFO* shft_x / shft_y                                  : $shft_x / $shft_y"
  puts "*INFO* CheckStrap / CheckBlkg / CheckFixed              : $CheckStrap / $CheckBlkg / $CheckFixed"


  ############### place Last stage buffer
  set LoadInfo [ GetObjLocationInfo [ get_loads $NetName ] ]
  puts "*INFO* Totally [ sizeof_collection [ get_loads $NetName ] ] Loadings."
  set CenterX  [ expr [ lindex $LoadInfo 0 ] + $shft_x ]
  set CenterY  [ expr [ lindex $LoadInfo 1 ] + $shft_y ]
  set x_min    [ lindex $LoadInfo 2 ]
  set x_max    [ lindex $LoadInfo 3 ]
  set y_min    [ lindex $LoadInfo 4 ]
  set y_max    [ lindex $LoadInfo 5 ]
  puts "*INFO* Orginally Center: $CenterX $CenterY"

  set FishBoneDir [ get_attr [ get_layers $TrunkLayer ] preferred_direction ]
  puts "*INFO* FishBoneDir: $FishBoneDir"

  puts "*INFO* Place Fishbone $NumverOfFishBoneStage Stage Buffer ..."
  alcpPlaceFishboneBuffer $NetName "$CenterX $CenterY" $RowStep $NumverOfFishBoneStage 0

  set AllFishBoneBuffers {}
  set LastStageOutputs   [ get_drivers $NetName ]
  set AllFishBoneBuffers [ add_to_collection $AllFishBoneBuffers [ get_cells -of $LastStageOutputs ] ]
  set PerStageNet        [ get_attr [ get_nets -of [ get_pins -of [get_cells -of $LastStageOutputs ] -filter "direction == in" ] -top -seg ] full_name ]
  set LastStageInputs    [ get_loads $PerStageNet ]
  set PreStageOutputs    [ get_drivers $PerStageNet ]
  set AllFishBoneBuffers [ add_to_collection $AllFishBoneBuffers [ get_cells -of $PreStageOutputs ] ]
  set FirstStageNet      [ get_attr [ get_nets -of [ get_pins -of [get_cells -of $PreStageOutputs ] -filter "direction == in" ] -top -seg ] full_name ]
  set PreStageInputs     [ get_loads $FirstStageNet ]
  set FirstStageOutputs  [ get_drivers $FirstStageNet ]
  set AllFishBoneBuffers [ add_to_collection $AllFishBoneBuffers [ get_cells -of $FirstStageOutputs ] ]
  set dlt_cell [ GetCellXDltMoveValue [ index_collection $AllFishBoneBuffers 0 ] ]

  set LastStageOutputsBBox  [ GetPinBBox $LastStageOutputs ]
  set LastStageInputsBBox   [ GetPinBBox $LastStageInputs ]
  set PreStageOutputsBBox   [ GetPinBBox $PreStageOutputs ]
  set PreStageInputsBBox    [ GetPinBBox $PreStageInputs ]
  set FirstStageOutputsBBox [ GetPinBBox $FirstStageOutputs ]


  set CellBBoxes1 ""
  foreach_in_collection cell [ get_cells -of $LastStageOutputs ] {
    set bbox [ get_attr $cell bbox ]
    lappend CellBBoxes1 $bbox
  }
  set CellBBoxes2 ""
  foreach_in_collection cell  [ get_cells -of $PreStageOutputs ] {
    set bbox [ get_attr $cell bbox ]
    lappend CellBBoxes2 $bbox
  }
  set CellBBoxes3 ""
  foreach_in_collection cell [ get_cells -of $FirstStageOutputs ] {
    set bbox [ get_attr $cell bbox ]
    lappend CellBBoxes3 $bbox
  }

  set LastStageOutputsInfo [ GetObjLocationInfo $LastStageOutputs ]
  set TrunkCx [ lindex $LastStageOutputsInfo 0 ]
  set TrunkCy [ lindex $LastStageOutputsInfo 1 ]

  set LastStageInputsNetName [ get_attr [ get_nets -of $LastStageInputs -top -seg ] full_name ]
  set lly [ Min [ lindex [ lindex $LastStageInputsBBox 0 ] 1 ] [ lindex [ lindex $PreStageOutputsBBox 0 ] 1 ] ]
  set ury [ Max [ lindex [ lindex $LastStageInputsBBox 1 ] 1 ] [ lindex [ lindex $PreStageOutputsBBox 1 ] 1 ] ]
  set llx [ lindex [ lindex $LastStageInputsBBox 0 ] 0 ]
  set urx [ lindex [ lindex $LastStageInputsBBox 1 ] 0 ]
  set PreStageBBox [ list [ list $llx $lly ] [ list $urx $ury ] ]
  set FirstStageOutputsNetName [  get_attr [ get_nets -of $FirstStageOutputs -top -seg ] full_name ]
  set lly [ Min [ lindex [ lindex $PreStageInputsBBox 0 ] 1 ] [ lindex [ lindex $FirstStageOutputsBBox 0 ] 1 ] ]
  set ury [ Max [ lindex [ lindex $PreStageInputsBBox 1 ] 1 ] [ lindex [ lindex $FirstStageOutputsBBox 1 ] 1 ] ]
  set llx [ lindex [ lindex $PreStageInputsBBox 0 ] 0 ]
  set urx [ lindex [ lindex $PreStageInputsBBox 1 ] 0 ]
  set FirstStageBBox [ list [ list $llx $lly ] [ list $urx $ury ] ]


  puts "*INFO* Check DRC ..."
  set dlty 0
  if { $FishBoneDir == "vertical" } {
    set llx    [ expr $TrunkCx - $TrunkWidth / 2.0 ]
    set lly_bf [ lindex $LastStageOutputsInfo 4 ]
    set lly    [ expr [ Min $lly_bf $y_min ] ]
    set urx    [ expr $TrunkCx + $TrunkWidth / 2.0 ]
    set ury_bf [ lindex $LastStageOutputsInfo 5 ]
    set ury    [ expr [ Max $ury_bf $y_max ] ]
    set FishBoneBBox [ list [ list $llx $lly ] [ list $urx $ury ] ]
    set dltx   [  alcpGetLocationV [ AddBBoxMargin $LastStageOutputsBBox $KEEPOUT_MARGIN ] [ alcpGetCheckStrapLayers $LastStageLayer ] \
                                   [ AddBBoxMargin $PreStageBBox $KEEPOUT_MARGIN ]         [ alcpGetCheckStrapLayers $PreStageLayer ] \
                                   [ AddBBoxMargin $FirstStageBBox $KEEPOUT_MARGIN ]       [ alcpGetCheckStrapLayers $FirstStageLayer ] \
                                   [ AddBBoxMargin $FishBoneBBox $KEEPOUT_MARGIN ]         $TrunkLayer \
                                   $CellBBoxes1 $CellBBoxes2 $CellBBoxes3 $CheckStrap $CheckBlkg $CheckFixed $dlt_cell $dlt_cell ]
    set FishBoneBBox [ MoveBBox $FishBoneBBox "$dltx 0" ]
    set CenterX [ expr ( [ lindex [ lindex $FishBoneBBox 0 ] 0 ] + [ lindex [ lindex $FishBoneBBox 1 ] 0 ] ) / 2.00 ]
    set CenterY [ expr ( [ lindex [ lindex $FishBoneBBox 0 ] 1 ] + [ lindex [ lindex $FishBoneBBox 1 ] 1 ] ) / 2.00 ]
    puts "*INFO* MoveTo $CenterX $CenterY for DRC"
    alcpPlaceFishboneBuffer $NetName "$CenterX $CenterY" $RowStep $NumverOfFishBoneStage
  } else {
    set llx  [ expr [ Min $x_min [ lindex [ lindex $LastStageOutputsBBox 0 ] 0 ] ] ]
    set lly  [ expr $TrunkCy - $TrunkWidth / 2.00 ]
    set urx  [ expr [ Max $x_max [ lindex [ lindex $LastStageOutputsBBox 1 ] 0 ] ] ]
    set ury  [ expr $TrunkCy + $TrunkWidth / 2.00 ]
    set FishBoneBBox [ list [ list $llx $lly ] [ list $urx $ury ] ]
    set dlt [ alcpGetLocationH [ AddBBoxMargin $LastStageOutputsBBox $KEEPOUT_MARGIN ] [ alcpGetCheckStrapLayers $LastStageLayer ] \
                               [ AddBBoxMargin $PreStageBBox $KEEPOUT_MARGIN ]  [ alcpGetCheckStrapLayers $PreStageLayer ] \
                               [ AddBBoxMargin $FirstStageBBox $KEEPOUT_MARGIN ]   [ alcpGetCheckStrapLayers $FirstStageLayer ] \
                               [ AddBBoxMargin $FishBoneBBox $KEEPOUT_MARGIN ]        $TrunkLayer \
                               $CellBBoxes1 $CellBBoxes2 $CellBBoxes3 $CheckStrap $CheckBlkg $CheckFixed 0.2 $dlt_cell ]
    set dltx [ lindex $dlt 0 ]
    set dlty [ lindex $dlt 1 ]
    set dltcelly [ lindex $dlt 2 ]
    set FishBoneBBox [ MoveBBox $FishBoneBBox "0 $dlty" ]
    set CenterX [ expr ( [ lindex [ lindex $LastStageOutputsBBox 0 ] 0 ] +  [ lindex [ lindex $LastStageOutputsBBox 1 ] 0 ] ) / 2.00 + $dltx ]
    set CenterY [ expr ( [ lindex [ lindex $LastStageOutputsBBox 0 ] 1 ] +  [ lindex [ lindex $LastStageOutputsBBox 1 ] 1 ] ) / 2.00 + $dltcelly ]
    puts "*INFO* MoveTo $CenterX $CenterY for DRC"
    alcpPlaceFishboneBuffer $NetName "$CenterX $CenterY" $RowStep $NumverOfFishBoneStage
  }

  if { $FishBoneDir  == "vertical" } {
    ## Branch
    puts "*INFO* Branch ..."
    set half_pitch [ expr $pitch / 2.00 ]
    set current_y [ expr $y_min + $half_pitch ]
    set real_lly -9999
    set real_ury -9999
    set cnt 0
    while { $current_y <= $y_max } {
      set current_bbox [ list [list $x_min [ expr $current_y - $half_pitch ] ] [list $x_max [ expr $current_y + $half_pitch ] ] ]
      set loadings [ GetLoadingsInBox $NetName $current_bbox ]
      if { [ sizeof_collection $loadings ] == 0 } {
        set current_y [ expr $current_y + $half_pitch ]
        continue
      }
      set current_bbox [ GetObjLocationInfo $loadings ]
      set current_llx [ lindex $current_bbox 2 ]
      set current_urx [ lindex $current_bbox 3 ]
      set current_llx [ Min $current_llx [ lindex [ lindex $FishBoneBBox 0 ] 0 ] ]
      set current_urx [ Max $current_urx [ lindex [ lindex $FishBoneBBox 1 ] 0 ] ]
      set current_cy $current_y
      set CurrentBranchBBox [ list [ list $current_llx [ expr $current_cy - $BranchWidth / 2.00 ] ] [ list $current_urx [ expr $current_cy + $BranchWidth / 2.00 ] ] ]
      set dlty [ GetLocationH [ AddBBoxMargin $CurrentBranchBBox $KEEPOUT_MARGIN ] $BranchLayer 1 0 0 ]
      if { [ expr abs($dlty) ] >= $half_pitch } {
        set current_cy $current_cy
        set current_cy [ expr $dlty + $current_cy ]
      } else {
        set current_cy [ expr $dlty + $current_cy ]
      }
      set CurrentBranchBBox [ MoveBBox $CurrentBranchBBox "0 $dlty"]
      CreateNetShape $NetName $BranchLayer $CurrentBranchBBox
      incr cnt
      if { $real_lly == -9999 } { set real_lly [ expr $current_cy - $BranchWidth / 2.00 ] }
      set real_ury [ expr $current_cy + $BranchWidth / 2.00 ]
      set current_y [ expr $current_y + $pitch ]
    }
    if { $cnt != 1 } {
      set FishBoneBBox [ list [ list [ lindex [ lindex $FishBoneBBox 0 ] 0 ] $real_lly ]  [ list [ lindex [ lindex $FishBoneBBox 1 ] 0 ] $real_ury] ]
    } else {
      set LastStageOutputsBBox  [ GetPinBBox $LastStageOutputs ]
      set FishBoneBBox [ list [ list [ lindex [ lindex $FishBoneBBox 0 ] 0 ] [ Min [ lindex [ lindex $LastStageOutputsBBox 0 ] 1 ] $real_lly ] ]  [ list [ lindex [ lindex $FishBoneBBox 1 ] 0 ] [ Max [ lindex [ lindex $LastStageOutputsBBox 1 ] 1 ] $real_ury ] ] ]
    }
    # create Trunk
    puts "*INFO* Trunk ..."
    set Trunk [ CreateNetShape $NetName $TrunkLayer $FishBoneBBox ]
  } else {
    ## Branch
    puts "*INFO* Branch ..."
    set half_pitch [ expr $pitch / 2.00 ]
    set current_x [ expr $x_min + $half_pitch ]
    set real_llx -9999
    set real_urx -9999
    set cnt 0
    while { $current_x <= $x_max } {
      set current_bbox [ list [list [ expr $current_x - $half_pitch ] $y_min ] [ list [ expr $current_x + $half_pitch ] $y_max ] ]
      set loadings [ GetLoadingsInBox $NetName $current_bbox ]
      if { [ sizeof_collection $loadings ] == 0 } {
        set current_x [ expr $current_x + $half_pitch ]
        continue
      }
      set current_bbox [ GetObjLocationInfo $loadings ]
      set current_llx [ expr $current_x - $half_pitch ]
      set current_urx [ expr $current_x + $half_pitch ]
      set current_lly [ lindex $current_bbox 4 ]
      set current_ury [ lindex $current_bbox 5 ]
      set current_lly [ Min $current_lly [ lindex [ lindex $FishBoneBBox 0 ] 1 ] ]
      set current_ury [ Max $current_ury [ lindex [ lindex $FishBoneBBox 1 ] 1 ] ]
      set current_cx  [ expr ( $current_llx + $current_urx ) / 2.000 ]
      set CurrentBranchBBox [ list [ list [ expr $current_cx - $BranchWidth/2.00 ] $current_lly ] [ list [ expr $current_cx + $BranchWidth/2.00 ] $current_ury ] ]
      set dltx [ GetLocationV  [ AddBBoxMargin $CurrentBranchBBox $KEEPOUT_MARGIN ] $BranchLayer 1 0 0 ]
      if { [ expr abs($dltx) ] >= $half_pitch } {
        set current_cx $current_cx
      } else {
        set current_cx [ expr $dltx + $current_cx ]
      }

      set CurrentBranchBBox [ MoveBBox $CurrentBranchBBox "$dltx 0" ]
      CreateNetShape $NetName $BranchLayer $CurrentBranchBBox
      incr cnt
      if { $real_llx == -9999 } { set real_llx [ expr $current_cx - $BranchWidth / 2.00 ] }
      set real_urx [ expr $current_cx + $BranchWidth / 2.00 ]
      set current_x [ expr $current_x + $pitch ]
    }
    if { $cnt != 1 } {
      set FishBoneBBox [ list [list $real_llx [ lindex [ lindex $FishBoneBBox 0 ] 1 ] ] [ list $real_urx [ lindex [ lindex $FishBoneBBox 1 ] 1 ] ] ]
    } else {
      set LastStageOutputsBBox  [ GetPinBBox $LastStageOutputs ]
      set FishBoneBBox [ list [list [ Min $real_llx [ lindex [ lindex $LastStageOutputsBBox 0 ] 0 ] ] [ lindex [ lindex $FishBoneBBox 0 ] 1 ] ] [ list [ Max $real_urx [ lindex [ lindex $LastStageOutputsBBox 1 ] 0 ] ] [ lindex [ lindex $FishBoneBBox 1 ] 1 ] ] ]
    }
    # create Trunk
    puts "*INFO* Trunk ..."
    set Trunk [ CreateNetShape $NetName $TrunkLayer $FishBoneBBox ]
  }
  CreateVias $NetName $TrunkLayer $BranchLayer $Trunk [ get_net_shapes -of $NetName -filter "layer_number == $BranchLayer"]

  set LastStageOutputsBBox  [ GetPinBBox $LastStageOutputs ]
  set LastStageInputsBBox   [ GetPinBBox $LastStageInputs ]
  set PreStageOutputsBBox   [ GetPinBBox $PreStageOutputs ]
  set PreStageInputsBBox    [ GetPinBBox $PreStageInputs ]
  set FirstStageOutputsBBox [ GetPinBBox $FirstStageOutputs ]

  ### draw LastStage
  puts "*INFO* LastStage ..."
  if { $FishBoneDir  == "vertical" } {
    CreateVias $NetName $TrunkLayer [ lindex $METAL_LAYERS 0 ] $Trunk $LastStageOutputs
  } else {
    set llx [ lindex [ lindex $LastStageOutputsBBox 0 ] 0 ]
    set urx [ lindex [ lindex $LastStageOutputsBBox 1 ] 0 ]
    set lly [ Min [ lindex [ lindex $FishBoneBBox 0 ] 1 ] [ lindex [ lindex $LastStageOutputsBBox 0 ] 1 ] ]
    set ury [ Max [ lindex [ lindex $FishBoneBBox 1 ] 1 ] [ lindex [ lindex $LastStageOutputsBBox 1 ] 1 ] ]
    set LastStageOutputsBBox [ list [ list $llx $lly ] [ list $urx $ury ] ]
    set VTrunk [ CreateNetShape $NetName $LastStageLayer $LastStageOutputsBBox ]
    CreateVias $NetName [ lindex $METAL_LAYERS 0 ] $LastStageLayer $LastStageOutputs $VTrunk
    CreateVias $NetName $LastStageLayer $TrunkLayer $VTrunk $Trunk
  }

  ### draw PreStage
  puts "*INFO* PreStage ..."
  set LastStageInputsNetName [ get_attr [ get_nets -of $LastStageInputs -top -seg ] full_name ]
  set lly [ Min [ lindex [ lindex $LastStageInputsBBox 0 ] 1 ] [ lindex [ lindex $PreStageOutputsBBox 0 ] 1 ] ]
  set ury [ Max [ lindex [ lindex $LastStageInputsBBox 1 ] 1 ] [ lindex [ lindex $PreStageOutputsBBox 1 ] 1 ] ]
  set llx [ lindex [ lindex $LastStageInputsBBox 0 ] 0 ]
  set urx [ lindex [ lindex $LastStageInputsBBox 1 ] 0 ]
  set PreStageBBox [ list [ list $llx $lly ] [ list $urx $ury ] ]
  set PreStageShape [ CreateNetShape $LastStageInputsNetName $PreStageLayer $PreStageBBox ]
  CreateVias     $LastStageInputsNetName [ lindex $METAL_LAYERS 0 ] $PreStageLayer [ add_to_collection $LastStageInputs $PreStageOutputs ] $PreStageShape
  ### draw FirstStage
  puts "*INFO* FirstStage ..." 
  set FirstStageOutputsNetName [  get_attr [ get_nets -of $FirstStageOutputs -top -seg ] full_name ]
  set lly [ Min [ lindex [ lindex $PreStageInputsBBox 0 ] 1 ] [ lindex [ lindex $FirstStageOutputsBBox 0 ] 1 ] ]
  set ury [ Max [ lindex [ lindex $PreStageInputsBBox 1 ] 1 ] [ lindex [ lindex $FirstStageOutputsBBox 1 ] 1 ] ]
  set llx [ lindex [ lindex $PreStageInputsBBox 0 ] 0 ]
  set urx [ lindex [ lindex $PreStageInputsBBox 1 ] 0 ]
  set FirstStageBBox [ list [ list $llx $lly ] [ list $urx $ury ] ]
  set FirstStageShape [ CreateNetShape $FirstStageOutputsNetName $FirstStageLayer $FirstStageBBox ]
  CreateVias $FirstStageOutputsNetName [ lindex $METAL_LAYERS 0 ] $FirstStageLayer [ add_to_collection $PreStageInputs $FirstStageOutputs ] $FirstStageShape
  #hilight_net $NetName
}

####################################################################################################
# alcpPlaceFishboneBuffer 
# at -- CenterX, CenterY
#

proc alcpPlaceFishboneBuffer { NetName at RowStep NumberOfStage { fixed 1 } } {

  set DrvNet [ alcpPlaceFishboneLastStageBuffer $NetName $at $RowStep $fixed ]
  for { set i 0 } { $i < [ expr $NumberOfStage - 1 ] } { incr i } {
    set DrvNet [ alcpPlaceFishbonePreStageBuffer $DrvNet $RowStep $fixed $i ]
  }

}

proc alcpPlaceFishboneLastStageBuffer  { NetName at RowStep { fixed 1 } } {
  global ROW_HEIGHT

  set x [ lindex $at 0 ]
  set y [ lindex $at 1 ]

  set ParallelOutputs     [ get_drivers $NetName ]
  set ParallelCells       [ get_cells -of $ParallelOutputs ]
  set ParallelInputs      [ get_pins -of $ParallelCells -filter "direction == in" ]
  set ParallelCellNum     [ sizeof_collection $ParallelCells ]
  set DummyCellInputs     [ remove_from_collection [ get_pins -of [ get_nets -of $ParallelInputs ] -filter "direction == in" ] $ParallelInputs ]
  set DummyCells          [ get_cells -of $DummyCellInputs -quiet ]
  set DummyCellNum        [ sizeof_collection $DummyCells ]
  set HalfParallelCellNum [ expr int( [ expr $ParallelCellNum / 2.00 ] ) ]

  set i 0
  set output1 [ index_collection $ParallelOutputs 0 ]
  set cell1   [ get_cells -of $output1 ]
  set output_bbox [ get_attr $output1 bbox ]
  set output_urx  [ lindex [ lindex $output_bbox 1 ] 0 ]
  set output_llx  [ lindex [ lindex $output_bbox 0 ] 0 ]
  set output_ury  [ lindex [ lindex $output_bbox 1 ] 1 ]
  set output_lly  [ lindex [ lindex $output_bbox 0 ] 1 ]
  set cell_llx [ lindex [ lindex [ get_attr $cell1 bbox ] 0 ] 0 ]
  set cell_urx [ lindex [ lindex [ get_attr $cell1 bbox ] 1 ] 0 ]
  set cell_lly [ lindex [ lindex [ get_attr $cell1 bbox ] 0 ] 1 ]
  set cell_ury [ lindex [ lindex [ get_attr $cell1 bbox ] 1 ] 1 ]
  ## get cell x, y
  set x [ expr $x - ( $output_llx - $cell_llx ) - ( $output_urx - $output_llx ) / 2.00 ]
  set y [ expr $y - ( $output_lly - $cell_lly ) - ( $output_ury - $output_lly ) / 2.00 ]
  set ROW_HEIGHT     [ get_attr $cell1 height]
  move_objects $cell1 -x $x -y $y -ignore_fixed
  ## get real cell x, y
  set x [ lindex [ lindex [ get_attr $cell1 bbox ] 0 ] 0 ]
  set y [ lindex [ lindex [ get_attr $cell1 bbox ] 0 ] 1 ]
  ## get botton cell x, y
  set base_x $x
  set base_y [ expr $y - $ROW_HEIGHT * $RowStep * $HalfParallelCellNum + $ROW_HEIGHT * $RowStep * $i ]

  foreach_in_collection cell [ sort_collection $ParallelCells "full_name" ] {
        set cell_x $base_x
        set cell_y [ expr $base_y + $ROW_HEIGHT * $RowStep * $i ]
        move_objects -x $cell_x -y $cell_y -ignore_fixed $cell
        if { $fixed } { set_attribute  $cell is_fixed true }
        #hilight_instance $cell
        incr i
  }
  return [ get_attr [ get_nets -of $ParallelInputs -top -seg ] full_name ]
}

proc alcpPlaceFishbonePreStageBuffer { NetName RowStep { fixed 1 } { stage 0 } } {
  set ParallelOutputs [ get_drivers $NetName ]
  set ParallelCells       [ get_cells -of $ParallelOutputs ]
  set ParallelInputs      [ get_pins -of $ParallelCells -filter "direction == in" ]
  set ParallelCellNum     [ sizeof_collection $ParallelCells ]
  set DummyCellInputs     [ remove_from_collection [ get_pins -of [ get_nets -of $ParallelInputs ] -filter "direction == in" ] $ParallelInputs ]
  set DummyCells          [ get_cells -of $DummyCellInputs -quiet ]
  set DummyCellNum        [ sizeof_collection $DummyCells ]
  set HalfParallelCellNum [ expr int( [ expr $ParallelCellNum / 2.00 ] ) ]

  set Loads    [ get_loads $NetName ]
  set LoadNum  [ sizeof_collection $Loads ]
  set Load_cells [ get_cells -of [ get_loads $NetName ] ]
  set LoadsInfo [ GetObjLocationInfo $Loads ]
  set x [ lindex $LoadsInfo 0 ]
  set y [ lindex [ GetObjLocationInfo $Load_cells ] 4 ]

  set output1 [ index_collection $ParallelOutputs 0 ]
  set cell1   [ get_cells -of $output1 ]
  set output_bbox [ get_attr $output1 bbox ]
  set output_urx  [ lindex [ lindex $output_bbox 1 ] 0 ]
  set output_llx  [ lindex [ lindex $output_bbox 0 ] 0 ]
  set output_ury  [ lindex [ lindex $output_bbox 1 ] 1 ]
  set output_lly  [ lindex [ lindex $output_bbox 0 ] 1 ]
  set cell_llx [ lindex [ lindex [ get_attr $cell1 bbox ] 0 ] 0 ]
  set cell_urx [ lindex [ lindex [ get_attr $cell1 bbox ] 1 ] 0 ]
  set cell_lly [ lindex [ lindex [ get_attr $cell1 bbox ] 0 ] 1 ]
  set cell_ury [ lindex [ lindex [ get_attr $cell1 bbox ] 1 ] 1 ]
  set ROW_HEIGHT     [ get_attr $cell1 height]

  set x [ expr $x - ( $output_urx - $output_llx ) / 2.00 - ( $output_llx - $cell_llx ) ]
  if { $stage == 0 } {
    set orgin_RowStep $RowStep
  } else {
    set RowStep 2
  }

  if { $RowStep == 1 } {
    set RowStep 2
    set y [ expr $y + $ROW_HEIGHT * [ expr int ( [ expr ( ( $LoadNum - 1 ) * $orgin_RowStep - $ParallelCellNum * $RowStep ) / 2.00 ] ) ]  ]
  } else {
    set y [ expr $y + $ROW_HEIGHT * $RowStep * [ expr int ( [ expr ( $LoadNum - 1 - $ParallelCellNum ) / 2.00 ] ) ]  ]
  }

  set base_x $x
  set base_y $y
  set i 0
  set res 1
  foreach_in_collection cell [ sort_collection $ParallelCells "full_name" ] {
        set cell_x $base_x
        set cell_y [ expr $base_y + $ROW_HEIGHT * $RowStep * $i + $ROW_HEIGHT ]
        move_objects -x $cell_x -y $cell_y -ignore_fixed $cell

        set overlapped [ remove_from_collection [ GetFixedCellInRegion [ get_attr $cell bbox ] ] $cell ]
        set not_on_current_net_cells [ remove_from_collection $overlapped [ get_flat_cells -of $NetName ] ]
        set current_net_cells [ remove_from_collection $overlapped $not_on_current_net_cells ]
        if { [ sizeof_collection $current_net_cells ] > 1 } {
	  puts "Error: PreBuffer is abnormal on $NetName"
        } elseif { [ sizeof_collection $current_net_cells ] == 1 } {
	  set Load_cells [ get_cells -of [ get_loads $NetName ] ]
          set load_x [ lindex [ GetObjLocationInfo $Load_cells ] 2 ]
          if { $res == 1 } {
            set res 0
	    set load_y [ expr [ lindex [ GetObjLocationInfo $Load_cells ] 4 ] - $ROW_HEIGHT ]
          } else {
	    set res 1
            set load_y [ lindex [ GetObjLocationInfo $Load_cells ] 5 ]
	  }
          move_objects -x $load_x -y $load_y $current_net_cells -ignore
        } else {

        }
        if { $fixed } { set_attribute  $cell is_fixed true }
        incr i
  }
  return [ get_attr [ get_nets -of $ParallelInputs -top -seg ] full_name ]
}

############################################################################
## CreateVias
#
proc CreateVias { NetName from to obj1 obj2 } {

  set min [ get_attr [ get_layers $from ] full_name ]
  set max [ get_attr [ get_layers $to   ] full_name ]

  set_preroute_drc_strategy  -ignore_std_cells  -no_design_rule

  change_selection $obj1
  change_selection $obj2 -a

  create_preroute_vias -nets $NetName -object_shapes [get_selection -type {shape pin}] \
                       -from_layer $min -from_object_strap -from_object_std_pin_connection -from_object_std_pin \
                       -to_layer   $max -to_object_strap -to_object_std_pin_connection -to_object_std_pin \
                       -mark_as strap
  change_selection
  

}

############################################################################
## CreateNetShape
##
# 
proc CreateNetShape { NetName Layer bbox } {
    set llx [ lindex [ lindex $bbox 0 ] 0 ]
    set lly [ lindex [ lindex $bbox 0 ] 1 ]
    set urx [ lindex [ lindex $bbox 1 ] 0 ]
    set ury [ lindex [ lindex $bbox 1 ] 1 ]
    if { [ get_attr [ get_layers $Layer ] preferred_direction ]  == "vertical" } {
      set org_x [ expr ($llx + $urx ) / 2 ]
      set org_y $lly
      set width [ expr $urx - $llx ]
      set heigth [ expr $ury - $lly ]
      set shape [ create_net_shape -no_snap -vertical -type wire -net $NetName -layer [ get_layers $Layer ] -datatype 0 -path_type 0 -width $width -route_type clk_strap -length $heigth -origin "$org_x $org_y" ]
    } else {
      set org_x $llx
      set org_y [ expr ($lly + $ury ) / 2 ]
      set width [ expr $ury - $lly ]
      set heigth [ expr $urx - $llx ]
      set shape [ create_net_shape -no_snap -type wire -net $NetName -layer [ get_layers $Layer ] -datatype 0 -path_type 0 -width $width -route_type clk_strap -length $heigth -origin "$org_x $org_y" ]
    }
   return $shape
}
############################################################################
## get_objects
##
# GetPlacementBlockageInRegion bbox
# GetFixedCellInRegion bbox
# GetStrapInRegion bbox layers
# GetLoadingsInBox
proc GetPlacementBlockageInRegion { bbox } {
  set blockages {}
  set blockages [ add_to_collection $blockages [ get_placement_blockages -intersect $bbox -quiet ] ]
  set blockages [ add_to_collection $blockages [ get_placement_blockages -within    $bbox -quiet ] ]
  return $blockages
}

proc GetFixedCellInRegion { bbox } {
  set cells_tmp {}
  set llx [ lindex [ lindex $bbox 0 ] 0 ]
  set lly [ lindex [ lindex $bbox 0 ] 1 ]
  set urx [ lindex [ lindex $bbox 1 ] 0 ]
  set ury [ lindex [ lindex $bbox 1 ] 1 ]

  set cells_tmp [ add_to_collection $cells_tmp [ get_cells -within    $bbox -filter "is_fixed == true" -quiet ] ]
  set cells_tmp [ add_to_collection $cells_tmp [ get_cells -intersect $bbox -filter "is_fixed == true" -quiet ] ]

  set cells {}
  foreach_in_collection cell $cells_tmp {
    set bbox_tmp [ get_attr $cell bbox ]
    set llx_tmp [ lindex [ lindex $bbox_tmp 0 ] 0 ]
    set lly_tmp [ lindex [ lindex $bbox_tmp 0 ] 1 ]
    set urx_tmp [ lindex [ lindex $bbox_tmp 1 ] 0 ]
    set ury_tmp [ lindex [ lindex $bbox_tmp 1 ] 1 ]
    ## up
    if { $lly_tmp == $ury } {
      continue
    }
    ## down
    if { $ury_tmp == $lly } {
      continue
    }
    ## left
    if { $urx_tmp == $llx } {
      continue
    }
    ## right 
    if { $llx_tmp == $urx } {
      continue
    }
    set cells [ add_to_collection $cells $cell ]
  }
  return $cells
}

proc GetLoadingsInBox { NetName bbox } {
  set cells_tmp {}
  set cells_tmp [ add_to_collection $cells_tmp [ get_cells -within    $bbox -quiet ] ]
  set cells_tmp [ add_to_collection $cells_tmp [ get_cells -intersect $bbox -quiet ] ]

  set all_load_pins [ get_loads $NetName ]
  set all_loadings [ get_cells -of $all_load_pins ]
  set nonloadings [ remove_from_collection $cells_tmp $all_loadings ]
  set inregion_tmp_cells [ remove_from_collection $cells_tmp $nonloadings ]
  set inregion_tmp_pins [ get_pins -of $inregion_tmp_cells -filter " direction == in " ]

  set nonloadings [ remove_from_collection $inregion_tmp_pins $all_load_pins ]
  set pins [ remove_from_collection $inregion_tmp_pins $nonloadings ]

  set real_pins {}
  foreach_in_collection pin $pins {
    set bbox_tmp [ get_attr $pin bbox ]
    set llx [ lindex [ lindex $bbox_tmp 0 ] 0 ]
    set lly [ lindex [ lindex $bbox_tmp 0 ] 1 ]
    set urx [ lindex [ lindex $bbox_tmp 1 ] 0 ]
    set ury [ lindex [ lindex $bbox_tmp 1 ] 1 ]
    set p1 "$llx $lly"
    set p2 "$llx $ury"
    set p3 "$urx $ury"
    set p4 "$urx $lly"
    if { [ check_point_in_bbox $p1 $bbox ] || [ check_point_in_bbox $p2 $bbox ] || [ check_point_in_bbox $p3 $bbox ] || [check_point_in_bbox $p4 $bbox ]} {
      set real_pins [ add_to_collection $real_pins $pin ]
    }
  }

  return $real_pins

}

proc check_point_in_bbox { point bbox } {
  set x [ lindex $point 0 ]
  set y [ lindex $point 1 ]
  set llx [ lindex [ lindex $bbox 0 ] 0 ]
  set lly [ lindex [ lindex $bbox 0 ] 1 ]
  set urx [ lindex [ lindex $bbox 1 ] 0 ]
  set ury [ lindex [ lindex $bbox 1 ] 1 ]

  if { $x >= $llx && $x <= $urx && $y >= $lly && $y <= $ury } {
    return 1
  } else {
    return 0
  }
}

proc GetStrapInRegion { bbox layers { check_via 1 } } {
  set objects {}
  foreach Layer $layers {
    set layer_name [ get_attribute  [get_layers $Layer] full_name ]
    set objects [ add_to_collection $objects [ get_net_shapes -intersect $bbox -quiet -filter "( route_type =~ *Strap || route_type =~ P/G* ) && layer_number == $Layer " ] ]
    set objects [ add_to_collection $objects [ get_net_shapes -within    $bbox -quiet -filter "( route_type =~ *Strap || route_type =~ P/G* ) && layer_number == $Layer " ] ]
    if { $check_via } {
      set objects [ add_to_collection $objects [ get_vias -intersect $bbox -quiet -filter "( route_type =~ *Strap || route_type =~ P/G* ) && ( lower_layer == $layer_name || upper_layer == $layer_name ) " ] ]
      set objects [ add_to_collection $objects [ get_vias -within    $bbox -quiet -filter "( route_type =~ *Strap || route_type =~ P/G* ) && ( lower_layer == $layer_name || upper_layer == $layer_name ) " ] ]
    }
  }
  return $objects
}

proc GetPinBBox { objs } {
  set minx 99999999999
  set miny 99999999999
  set maxx -99999999999
  set maxy -99999999999
  foreach_in_collection obj $objs {
    set bbox [ get_attr $obj bbox ]
    set llx [ lindex [ lindex $bbox 0 ] 0 ]
    set lly [ lindex [ lindex $bbox 0 ] 1 ]
    set urx [ lindex [ lindex $bbox 1 ] 0 ]
    set ury [ lindex [ lindex $bbox 1 ] 1 ]
    if { $llx < $minx } { set minx $llx }
    if { $lly < $miny } { set miny $lly }
    if { $urx > $maxx } { set maxx $urx }
    if { $ury > $maxy } { set maxy $ury }
  }
  return [ list [ list $minx $miny ] [ list $maxx $maxy ] ]
}

proc MoveBBox { bbox dlt } {
  set dltx [ lindex $dlt 0 ]
  set dlty [ lindex $dlt 1 ]

  set llx [ expr $dltx + [ lindex [ lindex $bbox 0 ] 0 ] ]
  set lly [ expr $dlty + [ lindex [ lindex $bbox 0 ] 1 ] ]
  set urx [ expr $dltx + [ lindex [ lindex $bbox 1 ] 0 ] ]
  set ury [ expr $dlty + [ lindex [ lindex $bbox 1 ] 1 ] ]
  return [ list [ list $llx $lly ] [ list $urx $ury ] ]
}

proc MoveBBoxes { bboxes dlt } {
  set new_bboxes ""
  set dltx [ lindex $dlt 0 ]
  set dlty [ lindex $dlt 1 ]
  
  foreach bbox $bboxes {
    set llx [ expr $dltx + [ lindex [ lindex $bbox 0 ] 0 ] ]
    set lly [ expr $dlty + [ lindex [ lindex $bbox 0 ] 1 ] ]
    set urx [ expr $dltx + [ lindex [ lindex $bbox 1 ] 0 ] ]
    set ury [ expr $dlty + [ lindex [ lindex $bbox 1 ] 1 ] ]
    lappend new_bboxes [ list [ list $llx $lly ] [ list $urx $ury ] ]
  }
  return $new_bboxes
}

proc RemoveBBoxMargin { bbox margin } {
  set llx [ lindex [ lindex $bbox 0 ] 0 ]
  set lly [ lindex [ lindex $bbox 0 ] 1 ]
  set urx [ lindex [ lindex $bbox 1 ] 0 ]
  set ury [ lindex [ lindex $bbox 1 ] 1 ]
  return [ list [ list [ expr $llx + $margin ] [ expr $lly + $margin ] ] [ list [ expr $urx - $margin ] [ expr $ury - $margin ] ] ]
}

proc AddBBoxMargin { bbox margin } {
  set llx [ lindex [ lindex $bbox 0 ] 0 ]
  set lly [ lindex [ lindex $bbox 0 ] 1 ]
  set urx [ lindex [ lindex $bbox 1 ] 0 ]
  set ury [ lindex [ lindex $bbox 1 ] 1 ]
  return [ list [ list [ expr $llx - $margin ] [ expr $lly - $margin ] ] [ list [ expr $urx + $margin ] [ expr $ury + $margin ] ] ]
}

proc GetOverLapBBox { bbox1 bbox2 } {
  set llx1 [ lindex [ lindex $bbox1 0 ] 0 ]
  set lly1 [ lindex [ lindex $bbox1 0 ] 1 ]
  set urx1 [ lindex [ lindex $bbox1 1 ] 0 ]
  set ury1 [ lindex [ lindex $bbox1 1 ] 1 ]
  set llx2 [ lindex [ lindex $bbox2 0 ] 0 ]
  set lly2 [ lindex [ lindex $bbox2 0 ] 1 ]
  set urx2 [ lindex [ lindex $bbox2 1 ] 0 ]
  set ury2 [ lindex [ lindex $bbox2 1 ] 1 ]

  set llx [ Max $llx1 $llx2 ]
  set lly [ Max $lly1 $lly2 ]
  set urx [ Min $urx1 $urx2 ]
  set ury [ Min $ury1 $ury2 ]

  return [ list [ list $llx $lly ] [ list $urx $ury ] ]
}

proc get_drivers {args} {
 parse_proc_arguments -args $args results

 # if it's not a collection, convert into one
 redirect /dev/null {set size [sizeof_collection $results(object_spec)]}
 if {$size == ""} {
  set objects {}
  foreach name $results(object_spec) {
   if {[set stuff [get_ports -quiet $name]] == ""} {
    if {[set stuff [get_cells -quiet $name]] == ""} {
     if {[set stuff [get_pins -quiet $name]] == ""} {
      if {[set stuff [get_nets -quiet $name]] == ""} {
       continue
      }
      }
    }
   }
   set objects [add_to_collection $objects $stuff]
  }
 } else {
  set objects $results(object_spec)
 }

 if {$objects == ""} {
  echo "Error: no objects given"
  return 0
 }

 set driver_results {}

 # process all cells
 if {[set cells [get_cells -quiet $objects]] != ""} {
  # add driver pins of these cells
  set driver_results [add_to_collection -unique $driver_results \
   [get_pins -quiet -of $cells -filter "pin_direction == out || pin_direction == inout"]]
 }

 # get any nets
 set nets [get_nets -quiet $objects]

 # get any pin-connected nets
 if {[set pins [get_pins -quiet $objects]] != ""} {
  set nets [add_to_collection -unique $nets \
   [get_nets -quiet -of $pins]]
 }
 # get any port-connected nets
 if {[set ports [get_ports -quiet $objects]] != ""} {
  set nets [add_to_collection -unique $nets \
   [get_nets -quiet -of $ports]]
 }

 # process all nets
 if {$nets != ""} {
  # add driver pins of these nets
  set driver_results [add_to_collection -unique $driver_results \
   [get_pins -quiet -leaf -of $nets -filter "pin_direction == out || pin_direction == inout"]]
  set driver_results [add_to_collection -unique $driver_results \
   [get_ports -quiet -of $nets -filter "port_direction == in || port_direction == inout"]]
 }

 # return results
 return $driver_results
}

define_proc_attributes get_drivers \
 -info "Return driver ports/pins of object" \
 -define_args {\
  {object_spec "Object(s) to report" "object_spec" string required}
 }

proc get_loads {args} {
 parse_proc_arguments -args $args results

 # if it's not a collection, convert into one
 redirect /dev/null {set size [sizeof_collection $results(object_spec)]}
 if {$size == ""} {
  set objects {}
  foreach name $results(object_spec) {
   if {[set stuff [get_ports -quiet $name]] == ""} {
    if {[set stuff [get_cells -quiet $name]] == ""} {
     if {[set stuff [get_pins -quiet $name]] == ""} {
      if {[set stuff [get_nets -quiet $name]] == ""} {
       continue
      }
      }
    }
   }
   set objects [add_to_collection $objects $stuff]
  }
 } else {
  set objects $results(object_spec)
 }

 if {$objects == ""} {
  echo "Error: no objects given"
  return 0
 }

 set load_results {}

 # process all cells
 if {[set cells [get_cells -quiet $objects]] != ""} {
  # add load pins of these cells
  set load_results [add_to_collection -unique $load_results \
   [get_pins -quiet -of $cells -filter "pin_direction == in || pin_direction == inout"]]
 }

 # get any nets
 set nets [get_nets -quiet $objects]

 # get any pin-connected nets
 if {[set pins [get_pins -quiet $objects]] != ""} {
  set nets [add_to_collection -unique $nets \
   [get_nets -quiet -of $pins]]
 }

 # get any port-connected nets
 if {[set ports [get_ports -quiet $objects]] != ""} {
  set nets [add_to_collection -unique $nets \
   [get_nets -quiet -of $ports]]
 }

 # process all nets
 if {$nets != ""} {
  # add load pins of these nets
  set load_results [add_to_collection -unique $load_results \
   [get_pins -quiet -leaf -of $nets -filter "pin_direction == in || pin_direction == inout"]]
  set load_results [add_to_collection -unique $load_results \
   [get_ports -quiet -of $nets -filter "port_direction == out || port_direction == inout"]]
 }

 # return results
 return $load_results
}

define_proc_attributes get_loads \
 -info "Return load ports/pins of object" \
 -define_args {\
  {object_spec "Object(s) to report" "object_spec" string required}
 }

proc GetLocationV { bbox CheckLayers { CheckStrap 1 } { CheckBlkg 0 } { CheckFixed 0 } { dltmove 0.01 } } {

  set Beginllx [ lindex [ lindex $bbox 0 ] 0 ]
  set Beginlly [ lindex [ lindex $bbox 0 ] 1 ]
  set Beginurx [ lindex [ lindex $bbox 1 ] 0 ]
  set Beginury [ lindex [ lindex $bbox 1 ] 1 ]

  ## check V-L
  set llx $Beginllx
  set lly $Beginlly
  set urx $Beginurx
  set ury $Beginury
  set Width [ expr $Beginurx - $Beginllx ]
  set obs_exist 1
  while { $obs_exist } {
    set PreRoutes {}
    if { $CheckStrap } { set PreRoutes  [ GetStrapInRegion "$llx $lly $urx $ury" $CheckLayers ] }
    set blkg {}
    if { $CheckBlkg } { set blkg       [ GetPlacementBlockageInRegion "$llx $lly $urx $ury" ] }
    set fixed {}
    if { $CheckFixed } {
      set fixed     [ GetFixedCellInRegion "$llx $lly $urx $ury" ]
      if { [sizeof_collection $fixed ] == 1  } { set fixed {} }
    }
    if { [ sizeof_collection $PreRoutes ] != 0 } {
      set urx [ expr [ lindex [ GetObjLocationInfo $PreRoutes ] 2 ] - $dltmove ]
      set llx [ expr $urx - $Width ]
    } elseif { [ sizeof_collection $blkg ] != 0 } {
      set urx [ expr [ lindex [ GetObjLocationInfo $blkg ] 2 ] - $dltmove ]
      set llx [ expr $urx - $Width ]
    } elseif { [ sizeof_collection $fixed ] != 0 } {
      set urx [ expr [ lindex [ GetObjLocationInfo $fixed ] 2 ] - $dltmove ]
      set llx [ expr $urx - $Width ]
    } else {
      set obs_exist 0
    }
  }
  set dltxL [ expr $llx - $Beginllx ]
  ## check V-R
  set llx $Beginllx
  set lly $Beginlly
  set urx $Beginurx
  set ury $Beginury
  set Width [ expr $Beginurx - $Beginllx ]
  set obs_exist 1
  while { $obs_exist } {
    set PreRoutes {}
    if { $CheckStrap } { set PreRoutes  [ GetStrapInRegion "$llx $lly $urx $ury" $CheckLayers ] }
    set blkg {}
    if { $CheckBlkg } { set blkg       [ GetPlacementBlockageInRegion "$llx $lly $urx $ury" ] }
    set fixed {}
    if { $CheckFixed } {
      set fixed     [ GetFixedCellInRegion "$llx $lly $urx $ury" ] 
      if { [sizeof_collection $fixed ] == 1  } { set fixed {} }
    }
    if { [ sizeof_collection $PreRoutes ] != 0 } {
      set llx [ expr [ lindex [ GetObjLocationInfo $PreRoutes ] 3 ] + $dltmove ]
      set urx [ expr $llx + $Width ]
    } elseif { [ sizeof_collection $blkg ] != 0 } {
      set llx [ expr [ lindex [ GetObjLocationInfo $blkg ] 3 ] + $dltmove ]
      set urx [ expr $llx + $Width ]
    } elseif { [ sizeof_collection $fixed ] != 0 } {
      set llx [ expr [ lindex [ GetObjLocationInfo $fixed ] 3 ] + $dltmove ]
      set urx [ expr $llx + $Width ]
    } else {
      set obs_exist 0
    }
  }
  set dltxR [ expr $llx - $Beginllx ]
  if { [ expr $dltxR - abs($dltxL) ] < 0 } {
    set dltx $dltxR
  } else {
    set dltx $dltxL
  }
  return $dltx
}

proc GetCellXDltMoveValue { obj } {
  set org_bbox [ get_attr $obj bbox ]
  set org_llx [ lindex [ lindex $org_bbox 0 ] 0 ]
  set org_lly [ lindex [ lindex $org_bbox 0 ] 1 ]
  set org_urx [ lindex [ lindex $org_bbox 1 ] 0 ]
  set org_ury [ lindex [ lindex $org_bbox 1 ] 1 ]
  set llx $org_llx
  set dltx 0
  move_object $obj -x 500 -y 500 -ignore
  set bbox [ get_attr $obj bbox ]
  set llx_tmp [ lindex [ lindex $org_bbox 0 ] 0 ]
  set lly_tmp [ lindex [ lindex $org_bbox 0 ] 1 ]
  set llx $llx_tmp

  while { $llx_tmp == $llx } {
    set dltx [ expr $dltx + 0.01 ]
    move_object $obj -x [ expr $llx_tmp + $dltx ] -y $lly_tmp -ignore
    set bbox [ get_attr $obj bbox ]
    set llx [ lindex [ lindex $bbox 0 ] 0 ]
  }
  
  set dltx [ expr $llx - $llx_tmp ]
  move_object $obj -x $llx_tmp -y $lly_tmp -ignore

  return $dltx
  
== }

proc GetBBoxesInfo { PreRoutes } {
  # for x
  set min_x 99999999
  # for -x
  set max_x -99999999
  # for -y
  set max_y -99999999
  # for y
  set min_y 99999999

  foreach_in_collection PreRoute $PreRoutes {
    set bbox [ get_attr $PreRoute bbox ]
    set llx [ lindex [ lindex $bbox 0 ] 0 ]
    set lly [ lindex [ lindex $bbox 0 ] 1 ]
    set urx [ lindex [ lindex $bbox 1 ] 0 ]
    set ury [ lindex [ lindex $bbox 1 ] 1 ]
    if { $urx < $min_x } { set min_x $urx }
    if { $llx > $max_x } { set max_x $llx }
    if { $lly > $max_y } { set max_y $lly }
    if { $ury < $min_y } { set min_y $ury }
  }
  return [ list $min_x $max_x $min_y $max_y ]
}

proc alcpGetLocationV { StrapBBox1 CheckLayers1 StrapBBox2 CheckLayers2 StrapBBox3 CheckLayers3 StrapBBox4 CheckLayers4 CellBBoxes1 CellBBoxes2 CellBBoxes3 { CheckStrap 0 } { CheckBlkg 0 } { CheckFixed 0 } { dltmove 0.01 } { dltcellmove 0.2 } } {

  ## check -x for strap / -x for cell
  set obs_exist 1
  set dlt_preroute1 0
  set dlt_preroute2 0
  set dlt_preroute3 0
  set dlt_fbroute  0
  set dlt_cell1 0
  set dlt_cell2 0
  set dlt_cell3 0
  set tmp_StrapBBox1 $StrapBBox1
  set tmp_StrapBBox2 $StrapBBox2
  set tmp_StrapBBox3 $StrapBBox3
  set tmp_StrapBBox4 $StrapBBox4
  set tmp_CellBBoxes1 $CellBBoxes1
  set tmp_CellBBoxes2 $CellBBoxes2
  set tmp_CellBBoxes3 $CellBBoxes3

  while { $obs_exist } {
    set PreRoutes1 {}
    set PreRoutes2 {}
    set PreRoutes3 {}
    set FBRoutes  {}
    set blkg1      {}
    set blkg2      {}
    set blkg3      {}
    set fixed1     {}
    set fixed2     {}
    set fixed3     {}

    if { $CheckStrap } {
      set PreRoutes1  [ add_to_collection $PreRoutes1 [ GetStrapInRegion $tmp_StrapBBox1 $CheckLayers1 ] ]
      set PreRoutes2  [ add_to_collection $PreRoutes2 [ GetStrapInRegion $tmp_StrapBBox2 $CheckLayers2 ] ]
      set PreRoutes3  [ add_to_collection $PreRoutes3 [ GetStrapInRegion $tmp_StrapBBox3 $CheckLayers3 ] ]
      set FBRoutes   [ add_to_collection $FBRoutes [ GetStrapInRegion $tmp_StrapBBox4 $CheckLayers4  ] ]
    }
    if { $CheckBlkg } {
      foreach bbox $tmp_CellBBoxes1 {
        set blkg1 [ add_to_collection $blkg1 [ GetPlacementBlockageInRegion $bbox ] ]
      }
      foreach bbox $tmp_CellBBoxes2 {
        set blkg2 [ add_to_collection $blkg2 [ GetPlacementBlockageInRegion $bbox ] ]
      }
      foreach bbox $tmp_CellBBoxes3 {
        set blkg3 [ add_to_collection $blkg3 [ GetPlacementBlockageInRegion $bbox ] ]
      }
    }
    if { $CheckFixed } {
      foreach bbox $tmp_CellBBoxes1 {
        set fixed1 [ add_to_collection $fixed1 [ GetFixedCellInRegion $bbox ] ]
      }
      foreach bbox $tmp_CellBBoxes2 {
        set fixed2 [ add_to_collection $fixed2 [ GetFixedCellInRegion $bbox ] ]
      }
      foreach bbox $tmp_CellBBoxes3 {
        set fixed3 [ add_to_collection $fixed3 [ GetFixedCellInRegion $bbox ] ]
      }
    }
    if { [ sizeof_collection $PreRoutes1 ] != 0 } {
      set locations [ GetBBoxesInfo $PreRoutes1 ]
      set dlt_tmp [ expr int( [ expr ( [ lindex [ lindex $tmp_StrapBBox1 1 ] 0 ] - [ lindex $locations 1 ] ) / $dltmove ] ) * $dltmove + $dltmove ]
      set dlt_preroute1 [ expr $dlt_preroute1 - $dlt_tmp ]
    } elseif { [ sizeof_collection $PreRoutes2 ] != 0 } {
      set locations [ GetBBoxesInfo $PreRoutes2 ]
      set dlt_tmp [ expr int( [ expr ( [ lindex [ lindex $tmp_StrapBBox2 1 ] 0 ] - [ lindex $locations 1 ] ) / $dltmove ] ) * $dltmove + $dltmove ]
      set dlt_preroute2 [ expr $dlt_preroute2 - $dlt_tmp ]
    } elseif { [ sizeof_collection $PreRoutes3 ] != 0 } {
      set locations [ GetBBoxesInfo $PreRoutes3 ]
      set dlt_tmp [ expr int( [ expr ( [ lindex [ lindex $tmp_StrapBBox3 1 ] 0 ] - [ lindex $locations 1 ] ) / $dltmove ] ) * $dltmove + $dltmove ]
      set dlt_preroute3 [ expr $dlt_preroute3 - $dlt_tmp ]
    } elseif { [ sizeof_collection $FBRoutes ] != 0 } {
      set locations [ GetBBoxesInfo $FBRoutes ]
      set dlt_tmp [ expr int( [ expr ( [ lindex [ lindex $tmp_StrapBBox4 1 ] 0 ] - [ lindex $locations 1 ] ) / $dltmove ] ) * $dltmove + $dltmove ]
      set dlt_fbroute [ expr $dlt_fbroute - $dlt_tmp ]
    } elseif { [ sizeof_collection $blkg1 ] != 0 || [ sizeof_collection $fixed1 ] != 0 } {
      if { [ sizeof_collection $blkg1 ] != 0 } {
        set locations1 [ GetBBoxesInfo $blkg1 ]
        set dlt_tmp1 [ expr int( [ expr ( [ lindex [ lindex [ lindex $tmp_CellBBoxes1 0 ] 1 ] 0 ] - [ lindex $locations1 1 ] ) / $dltcellmove ] ) * $dltcellmove + $dltmove ]
      } else {
        set dlt_tmp1 0
      }
      if { [ sizeof_collection $fixed1 ] != 0 } {
        set locations2 [ GetBBoxesInfo $fixed1 ]
        set dlt_tmp2 [ expr int( [ expr ( [ lindex [ lindex [ lindex $tmp_CellBBoxes1 0 ] 1 ] 0 ] - [ lindex $locations2 1 ] ) / $dltcellmove ] ) * $dltcellmove + $dltcellmove ]
      } else {
        set dlt_tmp2 0
      }
      set dlt_cell1 [ expr $dlt_cell1 - [ AbsMax $dlt_tmp1 $dlt_tmp2 ] ]
    } elseif { [ sizeof_collection $blkg2 ] != 0 || [ sizeof_collection $fixed2 ] != 0 } {
      if { [ sizeof_collection $blkg2 ] != 0 } {
        set locations1 [ GetBBoxesInfo $blkg2 ]
        set dlt_tmp1 [ expr int( [ expr ( [ lindex [ lindex [ lindex $tmp_CellBBoxes1 0 ] 1 ] 0 ] - [ lindex $locations1 1 ] ) / $dltcellmove ] ) * $dltcellmove + $dltcellmove ]
      } else {
        set dlt_tmp1 0
      }
      if { [ sizeof_collection $fixed2 ] != 0 } {
        set locations2 [ GetBBoxesInfo $fixed2 ]
        set dlt_tmp2 [ expr int( [ expr ( [ lindex [ lindex [ lindex $tmp_CellBBoxes2 0 ] 1 ] 0 ] - [ lindex $locations2 1 ] ) / $dltcellmove ] ) * $dltcellmove + $dltcellmove ]
      } else {
        set dlt_tmp2 0
      }
      set dlt_cell2 [ expr $dlt_cell2 - [ AbsMax $dlt_tmp1 $dlt_tmp2 ] ]
    } elseif { [ sizeof_collection $blkg3 ] != 0 || [ sizeof_collection $fixed3 ] != 0 } {
      if { [ sizeof_collection $blkg3 ] != 0 } {
        set locations1 [ GetBBoxesInfo $blkg3 ]
        set dlt_tmp1 [ expr int( [ expr ( [ lindex [ lindex [ lindex $tmp_CellBBoxes1 0 ] 1 ] 0 ] - [ lindex $locations1 1 ] ) / $dltcellmove ] ) * $dltcellmove + $dltcellmove ]
      } else {
        set dlt_tmp1 0
      }
      if { [ sizeof_collection $fixed3 ] != 0 } {
        set locations2 [ GetBBoxesInfo $fixed3 ]
        set dlt_tmp2 [ expr int( [ expr ( [ lindex [ lindex [ lindex $tmp_CellBBoxes3 0 ] 1 ] 0 ] - [ lindex $locations2 1 ] ) / $dltcellmove ] ) * $dltcellmove + $dltcellmove ]
      } else {
        set dlt_tmp2 0
      }
      set dlt_cell1 [ expr $dlt_cell1 - [ AbsMax $dlt_tmp1 $dlt_tmp2 ] ]
    } else {
      set obs_exist 0
    }
    set dlt [ AbsMax [ AbsMax [ AbsMax [ AbsMax [ AbsMax [ AbsMax $dlt_cell1 $dlt_cell2 ] $dlt_cell3 ] $dlt_fbroute ] $dlt_preroute1 ] $dlt_preroute2 ] $dlt_preroute3 ]
    set dlt_preroute1 $dlt
    set dlt_preroute2 $dlt
    set dlt_preroute3 $dlt
    set dlt_cell1 $dlt
    set dlt_cell2 $dlt
    set dlt_cell3 $dlt
    set dlt_fbroute $dlt
    set tmp_StrapBBox1 [ MoveBBox $StrapBBox1 "$dlt 0" ]
    set tmp_StrapBBox2 [ MoveBBox $StrapBBox2 "$dlt 0" ]
    set tmp_StrapBBox3 [ MoveBBox $StrapBBox3 "$dlt 0" ]
    set tmp_StrapBBox4 [ MoveBBox $StrapBBox4 "$dlt 0" ]
    set tmp_CellBBoxes1 [ MoveBBoxes  $CellBBoxes1  "$dlt 0" ]
    set tmp_CellBBoxes2 [ MoveBBoxes  $CellBBoxes2  "$dlt 0" ]
    set tmp_CellBBoxes3 [ MoveBBoxes  $CellBBoxes3  "$dlt 0" ]
  }
  set dltxL $dlt

  ## check x for strap / x for cell
  set obs_exist 1
  set dlt_preroute1 0
  set dlt_preroute2 0
  set dlt_preroute3 0
  set dlt_fbroute  0
  set dlt_cell1 0
  set dlt_cell2 0
  set dlt_cell3 0
  set tmp_StrapBBox1 $StrapBBox1
  set tmp_StrapBBox2 $StrapBBox2
  set tmp_StrapBBox3 $StrapBBox3
  set tmp_StrapBBox4 $StrapBBox4
  set tmp_CellBBoxes1 $CellBBoxes1
  set tmp_CellBBoxes2 $CellBBoxes2
  set tmp_CellBBoxes3 $CellBBoxes3

  while { $obs_exist } {
    set PreRoutes1 {}
    set PreRoutes2 {}
    set PreRoutes3 {}
    set FBRoutes  {}
    set blkg1      {}
    set blkg2      {}
    set blkg3      {}
    set fixed1     {}
    set fixed2     {}
    set fixed3     {}

    if { $CheckStrap } {
      set PreRoutes1  [ add_to_collection $PreRoutes1 [ GetStrapInRegion $tmp_StrapBBox1 $CheckLayers1 ] ]
      set PreRoutes2  [ add_to_collection $PreRoutes2 [ GetStrapInRegion $tmp_StrapBBox2 $CheckLayers2 ] ]
      set PreRoutes3  [ add_to_collection $PreRoutes3 [ GetStrapInRegion $tmp_StrapBBox3 $CheckLayers3 ] ]
      set FBRoutes   [ add_to_collection $FBRoutes [ GetStrapInRegion $tmp_StrapBBox4 $CheckLayers4  ] ]
    }
    if { $CheckBlkg } {
      foreach bbox $tmp_CellBBoxes1 {
        set blkg1 [ add_to_collection $blkg1 [ GetPlacementBlockageInRegion $bbox ] ]
      }
      foreach bbox $tmp_CellBBoxes2 {
        set blkg2 [ add_to_collection $blkg2 [ GetPlacementBlockageInRegion $bbox ] ]
      }
      foreach bbox $tmp_CellBBoxes3 {
        set blkg3 [ add_to_collection $blkg3 [ GetPlacementBlockageInRegion $bbox ] ]
      }
    }
    if { $CheckFixed } {
      foreach bbox $tmp_CellBBoxes1 {
        set fixed1 [ add_to_collection $fixed1 [ GetFixedCellInRegion $bbox ] ]
      }
      foreach bbox $tmp_CellBBoxes2 {
        set fixed2 [ add_to_collection $fixed2 [ GetFixedCellInRegion $bbox ] ]
      }
      foreach bbox $tmp_CellBBoxes3 {
        set fixed3 [ add_to_collection $fixed3 [ GetFixedCellInRegion $bbox ] ]
      }
    }
    if { [ sizeof_collection $PreRoutes1 ] != 0 } {
      set locations [ GetBBoxesInfo $PreRoutes1 ]
      set dlt_tmp [ expr int( [ expr ( [ lindex $locations 0 ] - [ lindex [ lindex $tmp_StrapBBox1 0 ] 0 ] ) / $dltmove ] ) * $dltmove + $dltmove ]
      set dlt_preroute1 [ expr $dlt_preroute1 + $dlt_tmp ]
    } elseif { [ sizeof_collection $PreRoutes2 ] != 0 } {
      set locations [ GetBBoxesInfo $PreRoutes2 ]
      set dlt_tmp [ expr int( [ expr ( [ lindex $locations 0 ] - [ lindex [ lindex $tmp_StrapBBox2 0 ] 0 ] ) / $dltmove ] ) * $dltmove + $dltmove ]
      set dlt_preroute2 [ expr $dlt_preroute2 + $dlt_tmp ]
    } elseif { [ sizeof_collection $PreRoutes3 ] != 0 } {
      set locations [ GetBBoxesInfo $PreRoutes3 ]
      set dlt_tmp [ expr int( [ expr ( [ lindex $locations 0 ] - [ lindex [ lindex $tmp_StrapBBox3 0 ] 0 ] ) / $dltmove ] ) * $dltmove + $dltmove ]
      set dlt_preroute3 [ expr $dlt_preroute3 + $dlt_tmp ]
    } elseif { [ sizeof_collection $FBRoutes ] != 0 } {
      set locations [ GetBBoxesInfo $FBRoutes ]
      set dlt_tmp [ expr int( [ expr ( [ lindex $locations 0 ] - [ lindex [ lindex $tmp_StrapBBox4 0 ] 0 ] ) / $dltmove ] ) * $dltmove + $dltmove ]
      set dlt_fbroute [ expr $dlt_fbroute + $dlt_tmp ]
    } elseif { [ sizeof_collection $blkg1 ] != 0 || [ sizeof_collection $fixed1 ] != 0 } {
      if { [ sizeof_collection $blkg1 ] != 0 } {
        set locations1 [ GetBBoxesInfo $blkg1 ]
        set dlt_tmp1 [ expr int( [ expr ( [ lindex $locations1 0 ] - [ lindex [ lindex [ lindex $tmp_CellBBoxes1 0 ] 0 ] 0 ] ) / $dltcellmove ] ) * $dltcellmove + $dltcellmove ]
      } else {
        set dlt_tmp1 0
      }
      if { [ sizeof_collection $fixed1 ] != 0 } {
        set locations2 [ GetBBoxesInfo $fixed1 ]
        set dlt_tmp2 [ expr int( [ expr ( [ lindex $locations2 0 ] - [ lindex [ lindex [ lindex $tmp_CellBBoxes1 0 ] 0 ] 0 ] ) / $dltcellmove ] ) * $dltcellmove + $dltcellmove ]
      } else {
        set dlt_tmp2 0
      }
      set dlt_cell1 [ expr $dlt_cell1 + [ AbsMax $dlt_tmp1 $dlt_tmp2 ] ]
    } elseif { [ sizeof_collection $blkg2 ] != 0 || [ sizeof_collection $fixed2 ] != 0 } {
      if { [ sizeof_collection $blkg2 ] != 0 } {
        set locations1 [ GetBBoxesInfo $blkg2 ]
        set dlt_tmp1 [ expr int( [ expr ( [ lindex $locations1 0 ] - [ lindex [ lindex [ lindex $tmp_CellBBoxes2 0 ] 0 ] 0 ] ) / $dltcellmove ] ) * $dltcellmove + $dltcellmove ]
      } else {
        set dlt_tmp1 0
      }
      if { [ sizeof_collection $fixed2 ] != 0 } {
        set locations2 [ GetBBoxesInfo $fixed2 ]
        set dlt_tmp2 [ expr int( [ expr ( [ lindex $locations2 0 ] - [ lindex [ lindex [ lindex $tmp_CellBBoxes2 0 ] 0 ] 0 ] ) / $dltcellmove ] ) * $dltcellmove + $dltcellmove ]
      } else {
        set dlt_tmp2 0
      }
      set dlt_cell2 [ expr $dlt_cell2 + [ AbsMax $dlt_tmp1 $dlt_tmp2 ] ]
    } elseif { [ sizeof_collection $blkg3 ] != 0 || [ sizeof_collection $fixed3 ] != 0 } {
      if { [ sizeof_collection $blkg3 ] != 0 } {
        set locations1 [ GetBBoxesInfo $blkg3 ]
        set dlt_tmp1 [ expr int( [ expr ( [ lindex $locations1 0 ] - [ lindex [ lindex [ lindex $tmp_CellBBoxes3 0 ] 0 ] 0 ] ) / $dltcellmove ] ) * $dltcellmove + $dltcellmove ]
      } else {
        set dlt_tmp1 0
      }
      if { [ sizeof_collection $fixed3 ] != 0 } {
        set locations2 [ GetBBoxesInfo $fixed3 ]
        set dlt_tmp2 [ expr int( [ expr ( [ lindex $locations2 0 ] - [ lindex [ lindex [ lindex $tmp_CellBBoxes3 0 ] 0 ] 0 ] ) / $dltcellmove ] ) * $dltcellmove + $dltcellmove ]
      } else {
        set dlt_tmp2 0
      }
      set dlt_cell1 [ expr $dlt_cell3 + [ AbsMax $dlt_tmp1 $dlt_tmp2 ] ]
    } else {
      set obs_exist 0
    }
    set dlt [ AbsMax [ AbsMax [ AbsMax [ AbsMax [ AbsMax [ AbsMax $dlt_cell1 $dlt_cell2 ] $dlt_cell3 ] $dlt_fbroute ] $dlt_preroute1 ] $dlt_preroute2 ] $dlt_preroute3 ]
    set dlt_preroute1 $dlt
    set dlt_preroute2 $dlt
    set dlt_preroute3 $dlt
    set dlt_cell1 $dlt
    set dlt_cell2 $dlt
    set dlt_cell3 $dlt
    set dlt_fbroute $dlt
    set tmp_StrapBBox1 [ MoveBBox $StrapBBox1 "$dlt 0" ]
    set tmp_StrapBBox2 [ MoveBBox $StrapBBox2 "$dlt 0" ]
    set tmp_StrapBBox3 [ MoveBBox $StrapBBox3 "$dlt 0" ]
    set tmp_StrapBBox4 [ MoveBBox $StrapBBox4 "$dlt 0" ]
    set tmp_CellBBoxes1 [ MoveBBoxes  $CellBBoxes1  "$dlt 0" ]
    set tmp_CellBBoxes2 [ MoveBBoxes  $CellBBoxes2  "$dlt 0" ]
    set tmp_CellBBoxes3 [ MoveBBoxes  $CellBBoxes3  "$dlt 0" ]
  }
  set dltxR $dlt
  return [ AbsMin $dltxR $dltxL]

}

proc GetLocationH { bbox CheckLayers { CheckStrap 1 } { CheckBlkg 0 } { CheckFixed 0 } { dltmove 0.01 } } {

  set Beginllx [ lindex [ lindex $bbox 0 ] 0 ]
  set Beginlly [ lindex [ lindex $bbox 0 ] 1 ]
  set Beginurx [ lindex [ lindex $bbox 1 ] 0 ]
  set Beginury [ lindex [ lindex $bbox 1 ] 1 ]

  ## check V-D
  set llx $Beginllx
  set lly $Beginlly
  set urx $Beginurx
  set ury $Beginury
  set Higth [ expr $Beginury - $Beginlly ]
  set obs_exist 1
  while { $obs_exist } {
    set PreRoutes {}
    if { $CheckStrap } { set PreRoutes  [ GetStrapInRegion "$llx $lly $urx $ury" $CheckLayers ] }
    set blkg {}
    if { $CheckBlkg } { set blkg       [ GetPlacementBlockageInRegion "$llx $lly $urx $ury" ] }
    set fixed {}
    if { $CheckFixed } {
      set fixed     [ GetFixedCellInRegion "$llx $lly $urx $ury" ] 
      if { [sizeof_collection $fixed ] == 1  } { set fixed {} }
    }
    if { [ sizeof_collection $PreRoutes ] != 0 } {
      set ury [ expr [ lindex [ GetObjLocationInfo $PreRoutes ] 4 ] - $dltmove ]
      set lly [ expr $ury - $Higth ]
    } elseif { [ sizeof_collection $blkg ] != 0 } {
      set ury [ expr [ lindex [ GetObjLocationInfo $blkg ] 4 ] - $dltmove ]
      set lly [ expr $ury - $Higth ]
    } elseif { [ sizeof_collection $fixed ] != 0 } {
      set ury [ expr [ lindex [ GetObjLocationInfo $fixed ] 4 ] - $dltmove ]
      set lly [ expr $ury - $Higth ]
    } else {
      set obs_exist 0
    }
  }
  set dltyL [ expr $lly - $Beginlly ]
  ## check V-U
  set llx $Beginllx
  set lly $Beginlly
  set urx $Beginurx
  set ury $Beginury
  set Higth [ expr $Beginury - $Beginlly ]
  set obs_exist 1
  while { $obs_exist } {
    set PreRoutes {}
    if { $CheckStrap } { set PreRoutes  [ GetStrapInRegion "$llx $lly $urx $ury" $CheckLayers ] }
    set blkg {}
    if { $CheckBlkg } { set blkg       [ GetPlacementBlockageInRegion "$llx $lly $urx $ury" ] }
    set fixed {}
    if { $CheckFixed } {
      set fixed     [ GetFixedCellInRegion "$llx $lly $urx $ury" ] 
      if { [sizeof_collection $fixed ] == 1  } { set fixed {} }
    }
    if { [ sizeof_collection $PreRoutes ] != 0 } {
      set lly [ expr [ lindex [ GetObjLocationInfo $PreRoutes ] 5 ] + $dltmove ]
      set ury [ expr $lly + $Higth ]
    } elseif { [ sizeof_collection $blkg ] != 0 } {
      set lly [ expr [ lindex [ GetObjLocationInfo $blkg ] 5 ] + $dltmove ]
      set ury [ expr $lly + $Higth ]
    } elseif { [ sizeof_collection $fixed ] != 0 } {
      set lly [ expr [ lindex [ GetObjLocationInfo $fixed ] 5 ] + $dltmove ]
      set ury [ expr $lly + $Higth ]
    } else {
      set obs_exist 0
    }
  }
  set dltyR [ expr $lly - $Beginlly ]
  if { [ expr $dltyR - abs($dltyL) ] < 0 } {
    set dlty $dltyR
  } else {
    set dlty $dltyL
  }
  return $dlty
}

proc alcpGetLocationH { StrapBBox1 CheckLayers1 StrapBBox2 CheckLayers2 StrapBBox3 CheckLayers3 StrapBBox4 CheckLayers4 CellBBoxes1 CellBBoxes2 CellBBoxes3 { CheckStrap 0 } { CheckBlkg 0 } { CheckFixed 0 } { dltmove 0.01 } { dltcellmove 0.2 } } {
  global ROW_HEIGHT

  ## check -y for strap / -x for cell
  set obs_exist 1
  set dlt_preroute1 0
  set dlt_preroute2 0
  set dlt_preroute3 0
  set dlt_fbroute  0
  set dlt_cell1 0
  set dlt_cell2 0
  set dlt_cell3 0
  set tmp_StrapBBox1 $StrapBBox1
  set tmp_StrapBBox2 $StrapBBox2
  set tmp_StrapBBox3 $StrapBBox3
  set tmp_StrapBBox4 $StrapBBox4
  set tmp_CellBBoxes1 $CellBBoxes1
  set tmp_CellBBoxes2 $CellBBoxes2
  set tmp_CellBBoxes3 $CellBBoxes3

  while { $obs_exist } {
    set PreRoutes1 {}
    set PreRoutes2 {}
    set PreRoutes3 {}
    set FBRoutes  {}
    set blkg1      {}
    set blkg2      {}
    set blkg3      {}
    set fixed1     {}
    set fixed2     {}
    set fixed3     {}

    if { $CheckStrap } {
      set PreRoutes1  [ add_to_collection $PreRoutes1 [ GetStrapInRegion $tmp_StrapBBox1 $CheckLayers1 ] ]
      set PreRoutes2  [ add_to_collection $PreRoutes2 [ GetStrapInRegion $tmp_StrapBBox2 $CheckLayers2 ] ]
      set PreRoutes3  [ add_to_collection $PreRoutes3 [ GetStrapInRegion $tmp_StrapBBox3 $CheckLayers3 ] ]
      set FBRoutes   [ add_to_collection $FBRoutes [ GetStrapInRegion $tmp_StrapBBox4 $CheckLayers4  ] ]
    }
    if { $CheckBlkg } {
      foreach bbox $tmp_CellBBoxes1 {
        set blkg1 [ add_to_collection $blkg1 [ GetPlacementBlockageInRegion $bbox ] ]
      }
      foreach bbox $tmp_CellBBoxes2 {
        set blkg2 [ add_to_collection $blkg2 [ GetPlacementBlockageInRegion $bbox ] ]
      }
      foreach bbox $tmp_CellBBoxes3 {
        set blkg3 [ add_to_collection $blkg3 [ GetPlacementBlockageInRegion $bbox ] ]
      }
    }
    if { $CheckFixed } {
      foreach bbox $tmp_CellBBoxes1 {
        set fixed1 [ add_to_collection $fixed1 [ GetFixedCellInRegion $bbox ] ]
      }
      foreach bbox $tmp_CellBBoxes2 {
        set fixed2 [ add_to_collection $fixed2 [ GetFixedCellInRegion $bbox ] ]
      }
      foreach bbox $tmp_CellBBoxes3 {
        set fixed3 [ add_to_collection $fixed3 [ GetFixedCellInRegion $bbox ] ]
      }
    }
    if { [ sizeof_collection $PreRoutes1 ] != 0 } {
      set locations [ GetBBoxesInfo $PreRoutes1 ]
      set dlt_tmp [ expr int( [ expr ( [ lindex [ lindex $tmp_StrapBBox1 1 ] 0 ] - [ lindex $locations 1 ] ) / $dltmove ] ) * $dltmove + $dltmove ]
      set dlt_preroute1 [ expr $dlt_preroute1 - $dlt_tmp ]
    } elseif { [ sizeof_collection $PreRoutes2 ] != 0 } {
      set locations [ GetBBoxesInfo $PreRoutes2 ]
      set dlt_tmp [ expr int( [ expr ( [ lindex [ lindex $tmp_StrapBBox2 1 ] 0 ] - [ lindex $locations 1 ] ) / $dltmove ] ) * $dltmove + $dltmove ]
      set dlt_preroute2 [ expr $dlt_preroute2 - $dlt_tmp ]
    } elseif { [ sizeof_collection $PreRoutes3 ] != 0 } {
      set locations [ GetBBoxesInfo $PreRoutes3 ]
      set dlt_tmp [ expr int( [ expr ( [ lindex [ lindex $tmp_StrapBBox3 1 ] 0 ] - [ lindex $locations 1 ] ) / $dltmove ] ) * $dltmove + $dltmove ]
      set dlt_preroute3 [ expr $dlt_preroute3 - $dlt_tmp ]
    } elseif { [ sizeof_collection $FBRoutes ] != 0 } {
      set locations [ GetBBoxesInfo $FBRoutes ]
      set dlt_tmp [ expr int( [ expr ( [ lindex [ lindex $tmp_StrapBBox4 1 ] 1 ] - [ lindex $locations 3 ] ) / $dltmove ] ) * $dltmove + $dltmove ]
      set dlt_fbroute [ expr $dlt_fbroute - $dlt_tmp ]
    } elseif { [ sizeof_collection $blkg1 ] != 0 || [ sizeof_collection $fixed1 ] != 0 } {
      if { [ sizeof_collection $blkg1 ] != 0 } {
        set locations1 [ GetBBoxesInfo $blkg1 ]
        set dlt_tmp1 [ expr int( [ expr ( [ lindex [ lindex [ lindex $tmp_CellBBoxes1 0 ] 1 ] 0 ] - [ lindex $locations1 1 ] ) / $dltcellmove ] ) * $dltcellmove + $dltmove ]
      } else {
        set dlt_tmp1 0
      }
      if { [ sizeof_collection $fixed1 ] != 0 } {
        set locations2 [ GetBBoxesInfo $fixed1 ]
        set dlt_tmp2 [ expr int( [ expr ( [ lindex [ lindex [ lindex $tmp_CellBBoxes1 0 ] 1 ] 0 ] - [ lindex $locations2 1 ] ) / $dltcellmove ] ) * $dltcellmove + $dltcellmove ]
      } else {
        set dlt_tmp2 0
      }
      set dlt_cell1 [ expr $dlt_cell1 - [ AbsMax $dlt_tmp1 $dlt_tmp2 ] ]
    } elseif { [ sizeof_collection $blkg2 ] != 0 || [ sizeof_collection $fixed2 ] != 0 } {
      if { [ sizeof_collection $blkg2 ] != 0 } {
        set locations1 [ GetBBoxesInfo $blkg2 ]
        set dlt_tmp1 [ expr int( [ expr ( [ lindex [ lindex [ lindex $tmp_CellBBoxes1 0 ] 1 ] 0 ] - [ lindex $locations1 1 ] ) / $dltcellmove ] ) * $dltcellmove + $dltcellmove ]
      } else {
        set dlt_tmp1 0
      }
      if { [ sizeof_collection $fixed2 ] != 0 } {
        set locations2 [ GetBBoxesInfo $fixed2 ]
        set dlt_tmp2 [ expr int( [ expr ( [ lindex [ lindex [ lindex $tmp_CellBBoxes2 0 ] 1 ] 0 ] - [ lindex $locations2 1 ] ) / $dltcellmove ] ) * $dltcellmove + $dltcellmove ]
      } else {
        set dlt_tmp2 0
      }
      set dlt_cell2 [ expr $dlt_cell2 - [ AbsMax $dlt_tmp1 $dlt_tmp2 ] ]
    } elseif { [ sizeof_collection $blkg3 ] != 0 || [ sizeof_collection $fixed3 ] != 0 } {
      if { [ sizeof_collection $blkg3 ] != 0 } {
        set locations1 [ GetBBoxesInfo $blkg3 ]
        set dlt_tmp1 [ expr int( [ expr ( [ lindex [ lindex [ lindex $tmp_CellBBoxes1 0 ] 1 ] 0 ] - [ lindex $locations1 1 ] ) / $dltcellmove ] ) * $dltcellmove + $dltcellmove ]
      } else {
        set dlt_tmp1 0
      }
      if { [ sizeof_collection $fixed3 ] != 0 } {
        set locations2 [ GetBBoxesInfo $fixed3 ]
        set dlt_tmp2 [ expr int( [ expr ( [ lindex [ lindex [ lindex $tmp_CellBBoxes3 0 ] 1 ] 0 ] - [ lindex $locations2 1 ] ) / $dltcellmove ] ) * $dltcellmove + $dltcellmove ]
      } else {
        set dlt_tmp2 0
      }
      set dlt_cell1 [ expr $dlt_cell1 - [ AbsMax $dlt_tmp1 $dlt_tmp2 ] ]
    } else {
      set obs_exist 0
    }
    set dlt [ AbsMax [ AbsMax [ AbsMax [ AbsMax [ AbsMax $dlt_cell1 $dlt_cell2 ] $dlt_cell3 ] $dlt_preroute1 ] $dlt_preroute2 ] $dlt_preroute3 ]
    set dlt_preroute1 $dlt
    set dlt_preroute2 $dlt
    set dlt_preroute3 $dlt
    set dlt_cell1 $dlt
    set dlt_cell2 $dlt
    set dlt_cell3 $dlt
    set dlt_cellyD [ expr round( [ expr $dlt_fbroute / $ROW_HEIGHT ] ) * $ROW_HEIGHT  ]
    set tmp_StrapBBox1 [ MoveBBox $StrapBBox1 "$dlt $dlt_cellyD" ]
    set tmp_StrapBBox2 [ MoveBBox $StrapBBox2 "$dlt $dlt_cellyD" ]
    set tmp_StrapBBox3 [ MoveBBox $StrapBBox3 "$dlt $dlt_cellyD" ]
    set tmp_StrapBBox4 [ MoveBBox $StrapBBox4 "0 $dlt_fbroute" ]
    set tmp_CellBBoxes1 [ MoveBBoxes  $CellBBoxes1  "$dlt $dlt_cellyD" ]
    set tmp_CellBBoxes2 [ MoveBBoxes  $CellBBoxes2  "$dlt $dlt_cellyD" ]
    set tmp_CellBBoxes3 [ MoveBBoxes  $CellBBoxes3  "$dlt $dlt_cellyD" ]
    set llx [ Min [ lindex [ lindex $tmp_StrapBBox4 0 ] 0 ]  [ lindex [ lindex $tmp_StrapBBox1 0 ] 0 ] ]
    set urx [ Max [ lindex [ lindex $tmp_StrapBBox4 1 ] 0 ]  [ lindex [ lindex $tmp_StrapBBox1 1 ] 0 ] ]
    set lly [ lindex [ lindex $tmp_StrapBBox4 0 ] 1 ]
    set ury [ lindex [ lindex $tmp_StrapBBox4 1 ] 1 ]
    set tmp_StrapBBox4 [ list [ list $llx $lly ] [ list $urx $ury ] ]
    set llx [ lindex [ lindex $tmp_StrapBBox1 0 ] 0 ]
    set urx [ lindex [ lindex $tmp_StrapBBox1 1 ] 0 ]
    set lly [ Min [ lindex [ lindex $tmp_StrapBBox4 0 ] 1 ] [ lindex [ lindex $tmp_StrapBBox1 0 ] 1 ] ]
    set ury [ Max [ lindex [ lindex $tmp_StrapBBox4 1 ] 1 ] [ lindex [ lindex $tmp_StrapBBox1 1 ] 1 ] ]
    set tmp_StrapBBox1 [ list [ list $llx $lly ] [ list $urx $ury ] ]
  }
  set dltxL $dlt
  set dltyD $dlt_fbroute

  ## check y for strap / x for cell
  set obs_exist 1
  set dlt_preroute1 0
  set dlt_preroute2 0
  set dlt_preroute3 0
  set dlt_fbroute  0
  set dlt_cell1 0
  set dlt_cell2 0
  set dlt_cell3 0
  set tmp_StrapBBox1 $StrapBBox1
  set tmp_StrapBBox2 $StrapBBox2
  set tmp_StrapBBox3 $StrapBBox3
  set tmp_StrapBBox4 $StrapBBox4
  set tmp_CellBBoxes1 $CellBBoxes1
  set tmp_CellBBoxes2 $CellBBoxes2
  set tmp_CellBBoxes3 $CellBBoxes3

  while { $obs_exist } {
    set PreRoutes1 {}
    set PreRoutes2 {}
    set PreRoutes3 {}
    set FBRoutes  {}
    set blkg1      {}
    set blkg2      {}
    set blkg3      {}
    set fixed1     {}
    set fixed2     {}
    set fixed3     {}

    if { $CheckStrap } {
      set PreRoutes1  [ add_to_collection $PreRoutes1 [ GetStrapInRegion $tmp_StrapBBox1 $CheckLayers1 ] ]
      set PreRoutes2  [ add_to_collection $PreRoutes2 [ GetStrapInRegion $tmp_StrapBBox2 $CheckLayers2 ] ]
      set PreRoutes3  [ add_to_collection $PreRoutes3 [ GetStrapInRegion $tmp_StrapBBox3 $CheckLayers3 ] ]
      set FBRoutes   [ add_to_collection $FBRoutes [ GetStrapInRegion $tmp_StrapBBox4 $CheckLayers4  ] ]
    }
    if { $CheckBlkg } {
      foreach bbox $tmp_CellBBoxes1 {
        set blkg1 [ add_to_collection $blkg1 [ GetPlacementBlockageInRegion $bbox ] ]
      }
      foreach bbox $tmp_CellBBoxes2 {
        set blkg2 [ add_to_collection $blkg2 [ GetPlacementBlockageInRegion $bbox ] ]
      }
      foreach bbox $tmp_CellBBoxes3 {
        set blkg3 [ add_to_collection $blkg3 [ GetPlacementBlockageInRegion $bbox ] ]
      }
    }
    if { $CheckFixed } {
      foreach bbox $tmp_CellBBoxes1 {
        set fixed1 [ add_to_collection $fixed1 [ GetFixedCellInRegion $bbox ] ]
      }
      foreach bbox $tmp_CellBBoxes2 {
        set fixed2 [ add_to_collection $fixed2 [ GetFixedCellInRegion $bbox ] ]
      }
      foreach bbox $tmp_CellBBoxes3 {
        set fixed3 [ add_to_collection $fixed3 [ GetFixedCellInRegion $bbox ] ]
      }
    }
    if { [ sizeof_collection $PreRoutes1 ] != 0 } {
      set locations [ GetBBoxesInfo $PreRoutes1 ]
      set dlt_tmp [ expr int( [ expr ( [ lindex $locations 0 ] - [ lindex [ lindex $tmp_StrapBBox1 0 ] 0 ] ) / $dltmove ] ) * $dltmove + $dltmove ]
      set dlt_preroute1 [ expr $dlt_preroute1 + $dlt_tmp ]
    } elseif { [ sizeof_collection $PreRoutes2 ] != 0 } {
      set locations [ GetBBoxesInfo $PreRoutes2 ]
      set dlt_tmp [ expr int( [ expr ( [ lindex $locations 0 ] - [ lindex [ lindex $tmp_StrapBBox2 0 ] 0 ] ) / $dltmove ] ) * $dltmove + $dltmove ]
      set dlt_preroute2 [ expr $dlt_preroute2 + $dlt_tmp ]
    } elseif { [ sizeof_collection $PreRoutes3 ] != 0 } {
      set locations [ GetBBoxesInfo $PreRoutes3 ]
      set dlt_tmp [ expr int( [ expr ( [ lindex $locations 0 ] - [ lindex [ lindex $tmp_StrapBBox3 0 ] 0 ] ) / $dltmove ] ) * $dltmove + $dltmove ]
      set dlt_preroute3 [ expr $dlt_preroute3 + $dlt_tmp ]
    } elseif { [ sizeof_collection $FBRoutes ] != 0 } {
      set locations [ GetBBoxesInfo $FBRoutes ]
      set dlt_tmp [ expr int( [ expr ( [ lindex $locations 2 ] - [ lindex [ lindex $tmp_StrapBBox4 0 ] 1 ] ) / $dltmove ] ) * $dltmove + $dltmove ]
      set dlt_fbroute [ expr $dlt_fbroute + $dlt_tmp ]
    } elseif { [ sizeof_collection $blkg1 ] != 0 || [ sizeof_collection $fixed1 ] != 0 } {
      if { [ sizeof_collection $blkg1 ] != 0 } {
        set locations1 [ GetBBoxesInfo $blkg1 ]
        set dlt_tmp1 [ expr int( [ expr ( [ lindex $locations1 0 ] - [ lindex [ lindex [ lindex $tmp_CellBBoxes1 0 ] 0 ] 0 ] ) / $dltcellmove ] ) * $dltcellmove + $dltcellmove ]
      } else {
        set dlt_tmp1 0
      }
      if { [ sizeof_collection $fixed1 ] != 0 } {
        set locations2 [ GetBBoxesInfo $fixed1 ]
        set dlt_tmp2 [ expr int( [ expr ( [ lindex $locations2 0 ] - [ lindex [ lindex [ lindex $tmp_CellBBoxes1 0 ] 0 ] 0 ] ) / $dltcellmove ] ) * $dltcellmove + $dltcellmove ]
      } else {
        set dlt_tmp2 0
      }
      set dlt_cell1 [ expr $dlt_cell1 + [ AbsMax $dlt_tmp1 $dlt_tmp2 ] ]
    } elseif { [ sizeof_collection $blkg2 ] != 0 || [ sizeof_collection $fixed2 ] != 0 } {
      if { [ sizeof_collection $blkg2 ] != 0 } {
        set locations1 [ GetBBoxesInfo $blkg2 ]
        set dlt_tmp1 [ expr int( [ expr ( [ lindex $locations1 0 ] - [ lindex [ lindex [ lindex $tmp_CellBBoxes2 0 ] 0 ] 0 ] ) / $dltcellmove ] ) * $dltcellmove + $dltcellmove ]
      } else {
        set dlt_tmp1 0
      }
      if { [ sizeof_collection $fixed2 ] != 0 } {
        set locations2 [ GetBBoxesInfo $fixed2 ]
        set dlt_tmp2 [ expr int( [ expr ( [ lindex $locations2 0 ] - [ lindex [ lindex [ lindex $tmp_CellBBoxes2 0 ] 0 ] 0 ] ) / $dltcellmove ] ) * $dltcellmove + $dltcellmove ]
      } else {
        set dlt_tmp2 0
      }
      set dlt_cell2 [ expr $dlt_cell2 + [ AbsMax $dlt_tmp1 $dlt_tmp2 ] ]
    } elseif { [ sizeof_collection $blkg3 ] != 0 || [ sizeof_collection $fixed3 ] != 0 } {
      if { [ sizeof_collection $blkg3 ] != 0 } {
        set locations1 [ GetBBoxesInfo $blkg3 ]
        set dlt_tmp1 [ expr int( [ expr ( [ lindex $locations1 0 ] - [ lindex [ lindex [ lindex $tmp_CellBBoxes3 0 ] 0 ] 0 ] ) / $dltcellmove ] ) * $dltcellmove + $dltcellmove ]
      } else {
        set dlt_tmp1 0
      }
      if { [ sizeof_collection $fixed3 ] != 0 } {
        set locations2 [ GetBBoxesInfo $fixed3 ]
        set dlt_tmp2 [ expr int( [ expr ( [ lindex $locations2 0 ] - [ lindex [ lindex [ lindex $tmp_CellBBoxes3 0 ] 0 ] 0 ] ) / $dltcellmove ] ) * $dltcellmove + $dltcellmove ]
      } else {
        set dlt_tmp2 0
      }
      set dlt_cell1 [ expr $dlt_cell3 + [ AbsMax $dlt_tmp1 $dlt_tmp2 ] ]
    } else {
      set obs_exist 0
    }
    set dlt [ AbsMax [ AbsMax [ AbsMax [ AbsMax [ AbsMax $dlt_cell1 $dlt_cell2 ] $dlt_cell3 ] $dlt_preroute1 ] $dlt_preroute2 ] $dlt_preroute3 ]
    set dlt_preroute1 $dlt
    set dlt_preroute2 $dlt
    set dlt_preroute3 $dlt
    set dlt_cell1 $dlt
    set dlt_cell2 $dlt
    set dlt_cell3 $dlt
    set dlt_cellyU [ expr round( [ expr $dlt_fbroute / $ROW_HEIGHT ] ) * $ROW_HEIGHT  ]
    set tmp_StrapBBox1 [ MoveBBox $StrapBBox1 "$dlt $dlt_cellyU" ]
    set tmp_StrapBBox2 [ MoveBBox $StrapBBox2 "$dlt $dlt_cellyU" ]
    set tmp_StrapBBox3 [ MoveBBox $StrapBBox3 "$dlt $dlt_cellyU" ]
    set tmp_StrapBBox4 [ MoveBBox $StrapBBox4 "0 $dlt_fbroute" ]
    set tmp_CellBBoxes1 [ MoveBBoxes  $CellBBoxes1  "$dlt $dlt_cellyU" ]
    set tmp_CellBBoxes2 [ MoveBBoxes  $CellBBoxes2  "$dlt $dlt_cellyU" ]
    set tmp_CellBBoxes3 [ MoveBBoxes  $CellBBoxes3  "$dlt $dlt_cellyU" ]
    set llx [ Min [ lindex [ lindex $tmp_StrapBBox4 0 ] 0 ]  [ lindex [ lindex $tmp_StrapBBox1 0 ] 0 ] ]
    set urx [ Max [ lindex [ lindex $tmp_StrapBBox4 1 ] 0 ]  [ lindex [ lindex $tmp_StrapBBox1 1 ] 0 ] ]
    set lly [ lindex [ lindex $tmp_StrapBBox4 0 ] 1 ]
    set ury [ lindex [ lindex $tmp_StrapBBox4 1 ] 1 ]
    set tmp_StrapBBox4 [ list [ list $llx $lly ] [ list $urx $ury ] ]
    set llx [ lindex [ lindex $tmp_StrapBBox1 0 ] 0 ]
    set urx [ lindex [ lindex $tmp_StrapBBox1 1 ] 0 ]
    set lly [ Min [ lindex [ lindex $tmp_StrapBBox4 0 ] 1 ] [ lindex [ lindex $tmp_StrapBBox1 0 ] 1 ] ]
    set ury [ Max [ lindex [ lindex $tmp_StrapBBox4 1 ] 1 ] [ lindex [ lindex $tmp_StrapBBox1 1 ] 1 ] ]
    set tmp_StrapBBox1 [ list [ list $llx $lly ] [ list $urx $ury ] ]
  }

  set dltxR $dlt
  set dltyU $dlt_fbroute
 
  return [ list [ AbsMin $dltxR $dltxL] [ AbsMin $dltyU $dltyD ] [ AbsMin $dlt_cellyU $dlt_cellyD ] ]

}

############################################################################
## Reset specified FB routing
## ResetFishbone
## NetName   -- net name
## stage_cnt -- stage
proc ResetFishbone { NetNames { stage_cnt 3 } } {
  foreach NetName $NetNames {
	puts "*INFO* Reset FB $NetName"
	set net [ get_nets $NetName ]
	for { set i 0 } { $i < $stage_cnt } { incr i } {
                set net_sharps [ get_net_shapes -of $net -quiet ]
                set vias       [ get_vias -of $net -quiet ]
		if { [ sizeof_collection $net_sharps ] != 0 } { remove_objects $net_sharps }
                if { [ sizeof_collection $vias ] != 0 } { remove_objects $vias }

		set dirvers [ index_collection [ get_drivers $net ] 0 ]
		foreach_in_collection bufopin [ get_drivers $net ] {
                        set buf [ get_cells -of $bufopin ]
                        set_attribute  $buf is_fixed false
                        set_cell_location $buf -coordinates { 0 0 } -ignore_fixed
                        set_attribute -quiet $buf orientation N
                }
		set net [ get_nets -of [ get_pins -of [ get_cells -of $dirvers ] -filter "direction == in" ] -top -seg]
	}
  }
}

proc RemoveAllFishbone { { stage_cnt 3 } } {
  foreach_in_collection cell [ get_cells *FB_L3_DRIVE01 -hier] {
    set netname [ get_attr [get_nets -of [ get_pins -of $cell -filter "direction == out"] -top -seg] full_name]
    ResetFishbone $netname $stage_cnt
  }
} 
############################################################################
## GetObjLocationInfo
## objects -- cell/pin collection
proc GetObjLocationInfo { objects } {
  set object_counter [ sizeof_collection $objects ]
  set x_counter 0
  set y_counter 0
  set x_min 999999999
  set y_min 999999999
  set x_max 0
  set y_max 0

  foreach_in_collection object $objects { 
    set bbox [get_attribute $object bbox]
    set llx [ lindex [ lindex $bbox 0 ] 0 ]
    set lly [ lindex [ lindex $bbox 0 ] 1 ]
    set urx [ lindex [ lindex $bbox 1 ] 0 ]
    set ury [ lindex [ lindex $bbox 1 ] 1 ]

    set x_counter [ expr $x_counter + ( $llx + $urx ) / 2 ]
    set y_counter [ expr $y_counter + ( $lly + $ury ) / 2 ]

    if { $x_min > $llx } {
        set x_min $llx
    }
    if { $y_min > $lly } {
        set y_min $lly
    }
    if { $x_max < $urx } {
        set x_max $urx
    }
    if { $y_max < $ury } {
        set y_max $ury
    }
  }
  set x_center [ expr $x_counter / $object_counter ]
  set y_center [ expr $y_counter / $object_counter ]
  return [ list $x_center $y_center $x_min $x_max $y_min $y_max [ expr $x_max - $x_min ] [ expr $y_max - $y_min ] [ list [list $x_min $y_min ] [ list $x_max $y_max ] ] ]
}

############################################################################
## Max
proc Max { number1 number2 } {
        if { $number1 >= $number2 } {
                return $number1
        } else {
                return $number2
        }
}

proc AbsMax { number1 number2 } {
        set n1 [ expr abs($number1)]
        set n2 [ expr abs($number2)]
        if { $n1 >= $n2 } {
                return $number1
        } else {
                return $number2
        }
}

############################################################################
## Min
proc Min { number1 number2 } {
        if { $number1 <= $number2 } {
                return $number1
        } else {
                return $number2
        }
}

proc AbsMin { number1 number2 } {
        set n1 [ expr abs($number1)]
        set n2 [ expr abs($number2)]
        if { $n1 <= $n2 } {
                return $number1
        } else {
                return $number2
        }
}

############################################################################
## Get design infomation
proc alcpGetCheckStrapLayers { max } {
  global METAL_LAYERS
  set VLAYERS ""
  foreach_in_collection layer [ get_layers $METAL_LAYERS -filter " preferred_direction == vertical " -quiet ] {
    lappend VLAYERS [ get_attr $layer layer_number ]
  }
  set HLAYERS ""
  foreach_in_collection layer [ get_layers $METAL_LAYERS -filter " preferred_direction == horizontal " -quiet ] {
    lappend HLAYERS [ get_attr $layer layer_number ]
  }
  set CheckStrapLayers ""
  if { [ lsearch $VLAYERS $max ] != -1 } {
    for { set i 0 } { $i <= [ lsearch $VLAYERS $max ] } { incr i } {
      set CheckStrapLayers [ concat $CheckStrapLayers [ lindex $VLAYERS $i ] ]
    }
  } else {
    for { set i 0 } { $i <= [ lsearch $HLAYERS $max ] } { incr i } {
      set CheckStrapLayers [ concat $CheckStrapLayers [ lindex $HLAYERS $i ] ]
    }
  }
  return $CheckStrapLayers
}
############################################################################
  proc get_model { model_name } {
    if { [regexp {\/} $model_name ] == 1} {
      if { [ sizeof_collection [ get_lib_cells $model_name -quiet ] ] != 0 } {
        return [ get_lib_cells $model_name ]
      } else {
        return 0
      }
    } else {
      foreach_in_collection lib [get_libs *] {
        set lib_name [ get_object_name $lib ]
        if { [ sizeof_collection [ get_lib_cells $lib_name/$model_name -quiet ] ] != 0 } {
          return [ get_lib_cells $lib_name/$model_name ]
        }
      }
      return 0
    }
  }

