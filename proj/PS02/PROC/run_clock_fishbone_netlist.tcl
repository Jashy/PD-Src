   source ./tcl/design_settings.tcl
   open_mw_lib MDB_WHYDRAIO/
   ##open_mw_cel route_opt_incr
   ##save_mw_cel -as WHYDRAIO -overwrite
   ##close_mw_cel
   ##source ./tcl/design_settings.tcl
   open_mw_cel WHYDRAIO
   remove_stdcell_filler -stdcell
   ###################################################################################################
   # Initialize 
   #
   source -e /proj/wHydra/WORK/peter/ICC/scripts/FB/fishbone_util.tcl
   source -e /proj/wHydra/WORK/peter/ICC/scripts/FB/insert_clock_buffer.tcl
   source -e /proj/wHydra/WORK/peter/ICC/scripts/FB/get_xy_dis.tcl	
   source -e /proj/wHydra/WORK/peter/ICC/scripts/FB/insert_dummy_gating.tcl
   source -e /proj/wHydra/WORK/peter/ICC/scripts/FB/get_xy_dis.tcl
   source -e /proj/wHydra/WORK/peter/ICC/scripts/FB/SPLIT_BY_WINDOW.tcl
   source -e /proj/wHydra/WORK/peter/ICC/scripts/N2N/CHANGE_CELL.tcl
   source -e /proj/wHydra/WORK/peter/ICC/scripts/N2N/REWIRE.tcl
   source -e /proj/wHydra/WORK/peter/ICC/scripts/N2N/INSERT_BUFFER.tcl
   source -e /user/home/marshals/utility/ICC/N2N_ICC/SPLIT_NET.tcl
   source -e /user/home/marshals/utility/ICC/proces/get_loads.tcl

   set SESSION FB_IMP
   sh mkdir -p ${SESSION}.run
   remove_route_by_type -signal_detail_route
   report_design -physical                                                 > ${SESSION}.run/initial_pr_summary.rpt
 
  ####################################################################################################
  # INSERT FISHBONE CLOCK
  #
  remove_attribute [ get_lib_cells tcbn65lpwcl/CKBD* ] dont_use
  remove_attribute [ get_lib_cells tcbn65lpwcl/CKBD* ] dont_touch

  file delete ./${SESSION}.run/insert_clock_tree.log
  source -e -v /proj/wHydra/WORK/peter/ICC/scripts/FB/fb_imp.tcl 	  > ./${SESSION}.run/insert_clock_tree.log

  # ECO before FB drawing
  source -e /proj/wHydra/WORK/peter/ICC/20100828_SDC/ECO.tcl
  ####################################################################################################
  # Write Out Data
  #

  set of [ open ${SESSION}.run/fb_net.list w+ ]
  foreach_in_collection cell [ get_cells *FB_L3_DRIVE01 -hier ] {
    puts $of [ get_attr [ get_nets -of [ get_pins -of $cell -filter "direction == out" ] -top -seg ] full_name ]
  }
  close $of

  source ./h_nets.tcl
  set of [ open ${SESSION}.run/guide.tcl w+ ]
  foreach_in_collection cell [ get_cells * -hier -filter "full_name =~ *_FB_L3_DRIVE01" ] {
    set cell_name [ get_attr $cell full_name ]
    set fb_net [ get_attr [ get_nets -of [ get_pins -of $cell -filter "direction == out" ] -top -seg ]  full_name  ]
    set xy [ get_xy_dis [ get_loads $fb_net ] ]
    set x_dis [ expr [ lindex $xy 2 ] - [ lindex $xy 0 ] ]
    set y_dis [ expr [ lindex $xy 3 ] - [ lindex $xy 1 ] ]
    set x_factor  [ expr round( [expr $x_dis / 600 ] ) ]
    set y_factor  [ expr round( [expr $y_dis / 600 ] ) ]
    
    if { [ lsearch $h_nets $fb_net ] == -1 } { 
      set trunk "34"
      set tribi "35"
      set trunk_w [ expr $y_factor + 5 ]
      set tribi_w [ expr $trunk_w / 10.0 ]
    } else {
      set trunk "35"
      set tribi "34"
      set trunk_w [ expr $x_factor + 5 ]
      set tribi_w [ expr $trunk_w / 10.0 ]
    }

    set pitch 60
    if { [sizeof_collection [get_loads $fb_net ] ] > 5000 } {
      set pitch 50
    }
    puts $of "alcpFishBone $fb_net $trunk $trunk_w $tribi $tribi_w $pitch 2 32 32 32 0 0"
    puts "alcpFishBone $fb_net $trunk $trunk_w $tribi $tribi_w $pitch 2 32 32 32 0 0"
    puts $of ""
  }
  close $of
  
  source ${SESSION}.run/guide.tcl

  save_mw_cel -as $SESSION -overwrite
  exit
