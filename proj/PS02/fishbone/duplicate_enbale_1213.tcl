###########################################################################
# duplicate enable > 16
#
source /proj/PS02/TEMPLATE/FB/from_darnell/1214/DUPLICATE_ICG_v3.tcl
source /proj/PS02/TEMPLATE/FB/from_darnell/1214/check_loading_distance.tcl

#source  /proj/PS02/WORK/jasons/Block/GAIA/FB_layout_0111/clock_tree/insert_dummy/L3_dup.tcl
#source  /proj/PS02/WORK/jasons/Block/GAIA/FB_layout_0111/clock_tree/insert_dummy/L2_dup.tcl
#source  /proj/PS02/WORK/jasons/Block/GAIA/FB_layout_0111/clock_tree/dup_L2/L1_dup.tcl
source  /proj/PS02/WORK/jasons/Block/GAIA/FB_layout_0111/clock_tree/balance/L2_dup

foreach enb $target_enbs {
      set enb_name [get_attr $enb full_name]
      if { [get_attr $enb_name dont_touch -quiet ] != true } {
          set place_results [check_loading_distance ${enb_name}/ECK]
      if {[llength $place_results] == 1} { continue }
      if {[expr [lindex $place_results 0] < 150] && [expr [lindex $place_results 5] < 50 ]} { 
          echo "$enb_name is ok"
          continue 
      }
      echo [format "DUPLICATE_ICG %s/ECK %d \t; # %d\t%s" $enb_name 50  [lindex $place_results 5]  [lindex $place_results 0] ] >> ./dup_icg_v2.tcl
      }
}

