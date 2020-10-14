###############################################################################
# Copyright ?2012 Synopsys, Inc.  All rights reserved.             
#                                                                  
# This script is proprietary and confidential information of        
# Synopsys, Inc. and may be used and disclosed only as authorized   
# per your agreement with Synopsys, Inc. controlling such use and   
# disclosure.                                                       
#              
# Procedure : check_empty_sites
#
# Purpose: For smaller technology nodes, it is not legal to have a 1x 
#          (unit tile) gap.  If the smallest allowable filler cells for this 
#          technology have a width of 3x and 2x, special spacing rules are created 
#          up front for placement to ensure that no 1x gaps are left in the 
#          layout. This procedure checks a fully placed and routed design, 
#          including filler cells, for any leftover 1x gaps .  
#
# Example Usage:
# 	icc_shell> source check_empty_sites.tcl
# 	icc_shell> check_empty_sites
###############################################################################

proc checkValidLocation {loc} {
   set curr_llx [lindex $loc 0]
   set curr_lly [lindex $loc 1]
   
   set valid_flag 1
   
   foreach_in_collection block [get_placement_blockages -quiet -intersect [list $loc $loc]] {
        set pb_llx [get_attribute -c placement_blockage $block bbox_llx]
        set pb_lly [get_attribute -c placement_blockage $block bbox_lly]
        set pb_urx [get_attribute -c placement_blockage $block bbox_urx]
        set pb_ury [get_attribute -c placement_blockage $block bbox_ury]
     	if { $curr_llx > $pb_llx && $curr_llx < $pb_urx && $curr_lly > $pb_lly && $curr_lly < $pb_ury} {
	     set valid_flag 0
	     break
	}	    
      }


  return $valid_flag
}
###############################################################################


###############################################################################
proc error_marker {site_width row_bbox row_name error_type_id1 lx lly ux ury error_type_id1_cnt} {
   if {[checkValidLocation [list [expr ($lx+$ux)/2.0] [expr ($lly+$ury)/2.0]]]} {
     if { [expr [expr $ux-$lx] >= $site_width] } {
     		#echo "[expr $ux-$lx] >= $site_width  at [list $lx $lly $ux $ury]"
     		set error_object_id [create_drc_error -type ${error_type_id1} -error_view check_empty_site.err \
               -info "$row_name : Empty site in the row with bbox: ${row_bbox} with >= 1x gap [list $lx $lly $ux $ury]"]
     		add_drc_error_detail -drc_error ${error_object_id} -rectangles [list 1 [list $lx $lly $ux $ury]] \
               -error_view check_empty_site.err
     		incr error_type_id1_cnt
       }
      }
      return $error_type_id1_cnt
}

###############################################################################
proc check_keepouts {keepoutFile} {

set master_list {}
set SCAN [open $keepoutFile r]
set flag 0

while {[gets $SCAN line]>=0} {
       if { [regexp {^Cell Name:.*$} $line match] } {
	     set cell_name [lindex [split $line] 2]
	     set flag 1
	     #echo $line
	  }
       if { [regexp {^ Hard Keepout -.*$} $line match] && ($flag==1)} {
            set x1 [lindex [split $line] 4]
	    set y1 [lindex [split $line] 5]
            set x2 [lindex [split $line] 6]
            set y2 [lindex [split $line] 7]
	    lappend master_list [list $cell_name $x1 $y1 $x2 $y2]
	   }

    } 
close $SCAN
#echo $master_list
return $master_list
}
###############################################################################
proc check_empty_sites {} {
 echo  "Start Time: [date]"
 set site_height [get_attribute [get_core_areas] tile_height]
 set site_width [get_attribute [get_core_areas] tile_width]

 set core_bbox [get_attribute [get_core_areas] bbox]
 set rows [get_attribute  [get_core_area] number_of_row]
 set row_name {}

 create_mw_cel check_empty_site -view err -not_as_current
 set error_type_id1 [create_drc_error_type -name "Empty-Site" -info "INFO : Empty-Site width >= 1x" \
    -error_view check_empty_site.err]
 set error_type_id1_cnt 0

   file delete keepouts.txt
   redirect -append -file keepouts.txt {echo "[report_keepout_margin [all_macro_cells]]"}
   
   
   set cnt 0
   foreach k [check_keepouts keepouts.txt] {
	   set x1 [expr [get_attribute [lindex $k 0] bbox_llx] - [lindex $k 1]]
	   set x2 [expr [get_attribute [lindex $k 0] bbox_urx] + [lindex $k 3]]
	   set y1 [expr [get_attribute [lindex $k 0] bbox_lly] - [lindex $k 2]]
	   set y2 [expr [get_attribute [lindex $k 0] bbox_ury] + [lindex $k 4]]
	   create_placement_blockage -name tst_tmp_${cnt} -bbox [list $x1 $y1 $x2 $y2]
	   incr cnt
	   #lset new_master_list $index 0 $x1
	   #lset new_master_list $index 1 $x2
	   #lset new_master_list $index 2 $name
   }


 foreach_in_collection i [get_site_rows] {
     set row_bbox  [get_attribute $i bbox]
     set row_name [get_attribute $i name]
     set llx [get_attribute [get_site_rows $i] bbox_llx]
     set lly [get_attribute [get_site_rows $i] bbox_lly]
     set urx [get_attribute [get_site_rows $i] bbox_urx]
     set ury [get_attribute [get_site_rows $i] bbox_ury]

     set col {}
     set col [add_to_collection $col [get_cells -all  -quiet -touching $row_bbox]]
     set col [add_to_collection $col [get_cells -all  -quiet -filter "height > $site_height" \
        -intersect $row_bbox]]
     set col [add_to_collection $col [get_placement_blockages -quiet -intersect  $row_bbox]]
     
     

   set master_list {} 

   foreach_in_collection cel $col {
   
    	set x1 [get_attribute $cel bbox_llx]
    	set x2 [get_attribute $cel bbox_urx]
	set y1 [get_attribute $cel bbox_lly]
	set y2 [get_attribute $cel bbox_ury]
    	set name [get_attribute $cel full_name]
	set objectClass [get_attribute $cel object_class]
	set mask {}
	
	if {$objectClass != {placement_blockage}} {
	  set mask [get_attribute $cel mask_layout_type]
	}
	
	if { ($y1!=$ury) && ($y2!=$lly)} { 
          if { $objectClass == {placement_blockage}} {
               lappend master_list [list $x1 $x2 $name]
	     }
	
          if { $mask != {stack_via}  && $objectClass != {placement_blockage}} {
               lappend master_list [list $x1 $x2 $name]
	     }
	 }
   }
   
   set new_master_list [lsort -real -index 0 $master_list]
   
   
   
   #set new_master_list [lsort -real -index 0 $new_master_list]
   
   for {set x 0} {$x < [llength $new_master_list]} {incr x} {
     if { $x == 0} { 
           set lx $llx
	   set ux [lindex [lindex $new_master_list $x] 0] 
	   set error_type_id1_cnt \
            [error_marker $site_width $row_bbox $row_name $error_type_id1 $lx $lly $ux $ury $error_type_id1_cnt]
	 } 
     if { $x == [expr [llength $new_master_list]-1] } { 
            set ux $urx
	    set lx [lindex [lindex $new_master_list $x] 1]
	    set error_type_id1_cnt \
             [error_marker $site_width $row_bbox $row_name $error_type_id1 $lx $lly $ux $ury $error_type_id1_cnt]
	    } 
     if { $x >= 0 && $x != [expr [llength $new_master_list]-1] } {
        set lx [lindex [lindex $new_master_list $x] 1]
        set ux [lindex [lindex $new_master_list [expr $x+1]] 0]
	set error_type_id1_cnt \
         [error_marker $site_width $row_bbox $row_name $error_type_id1 $lx $lly $ux $ury $error_type_id1_cnt] 
     }
    }
   }
save_mw_cel check_empty_site.err
close_mw_cel  check_empty_site.err -all_versions
remove_placement_blockage tst_tmp_*
echo "Total Empty-site     violations  : $error_type_id1_cnt"
echo "To view Empty-site Violations"
echo "Go To Verification --> Erro Browser..."
echo "Load check_empty_site.err cell"
echo "End Time: [date]"
}
###############################################################################

