

  set session clock_fishbone_physical

#  #####################################################################################################
#  ## PLACE PRE-buffer.
#  ##
#  source ./tcl/insert_clock_repeater.tcl
#  source /proj/SOC16d/WORK/mandyz/PT/clock_trace/0803/PT_chip_081610.run/change_cell.tcl 
#  ## create fb blockage
#  create_fb_blockage
#
#  set FB_DRIVERS [ get_cells *FB_L?_DRIVE* -hier ]
#
#  dump_cell_location $FB_DRIVERS > ${SESSION}.run/fishbone_buffer_location.tcl
#
#  write_route -skip_route_guide -nets [ get_nets -of [ get_pins -of $FB_DRIVERS -filter "direction == out" ] -top -seg ] -output ${SESSION}.run/fishbone_route.tcl
#
  legalize_placement -eco -inc

  
  change_names -rule verilog -hier
  report_design -physical    > ${SESSION}.run/${session}_pr_summary.rpt
  report_utilization         > ${SESSION}.run/${session}_utilization.rpt
  report_net_fanout -threshold  32 -nosplit       > ${SESSION}.run/${session}_net_fanout.rpt
  write_verilog     -no_corner_pad_cells -no_pad_filler_cells -no_core_filler_cells -no_unconnected_cells  ${SESSION}.run/${session}.v
  write_def -component -unit 1000  -output                                     ${SESSION}.run/${session}.def
  write_route -nets [get_nets -of [ get_pins *FB_L*_DRIVE01/C -hierarchical ] -top -seg ] -output ${SESSION}.run/${session}_fb_route.tcl
  exec touch ${session}.ready
source  /proj/Garnet/WORK/mandyz/ICC/tcl/write_clock_pin_list.tcl
write_clock_pin_list ${SESSION}.run/clock_pin_list.rpt


  save_mw_cel -as $session

